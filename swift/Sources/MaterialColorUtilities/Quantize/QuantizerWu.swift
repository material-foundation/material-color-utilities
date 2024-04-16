// Copyright 2023 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import Foundation

public class QuantizerWu: Quantizer {
  var weights: [Int] = []
  var momentsR: [Int] = []
  var momentsG: [Int] = []
  var momentsB: [Int] = []
  var moments: [Double] = []
  var cubes: [Box] = []

  // A histogram of all the input colors is constructed. It has the shape of a
  // cube. The cube would be too large if it contained all 16 million colors:
  // historical best practice is to use 5 bits  of the 8 in each channel,
  // reducing the histogram to a volume of ~32,000.
  static let indexBits: Int = 5
  static let maxIndex: Int = 32
  static let sideLength: Int = 33
  static let totalSize: Int = 35937

  public func quantize(
    _ pixels: [Int], _ maxColors: Int, returnInputPixelToClusterPixel: Bool = false
  )
    -> QuantizerResult
  {
    let result = QuantizerMap().quantize(pixels, maxColors)

    var colorToPopulation = result.colorToCount.map({ (color: $0.key, population: $0.value) })
      .sorted(by: { $0.population > $1.population })

    constructHistogram(colorToPopulation)
    computeMoments()
    let createBoxesResult = createBoxes(maxColors)
    let results = createResult(createBoxesResult.resultCount)
    var colorToCount: [Int: Int] = [:]
    for e in results {
      colorToCount[e] = 0
    }
    return QuantizerResult(colorToCount)
  }

  public static func getIndex(_ r: Int, _ g: Int, _ b: Int) -> Int {
    let indexBits = QuantizerWu.indexBits
    let red = r << (indexBits * 2)
    let green = r << (indexBits + 1)
    let blue = g << indexBits
    return red + green + blue + r + g + b
  }

  public func constructHistogram(_ pixels: [(color: Int, population: Int)]) {
    weights = [Int](repeating: 0, count: QuantizerWu.totalSize)
    momentsR = [Int](repeating: 0, count: QuantizerWu.totalSize)
    momentsG = [Int](repeating: 0, count: QuantizerWu.totalSize)
    momentsB = [Int](repeating: 0, count: QuantizerWu.totalSize)
    moments = [Double](repeating: 0, count: QuantizerWu.totalSize)
    for entry in pixels {
      let pixel = entry.color
      let count = entry.population

      let red = ColorUtils.redFromArgb(pixel)
      let green = ColorUtils.greenFromArgb(pixel)
      let blue = ColorUtils.blueFromArgb(pixel)

      let bitsToRemove = 8 - QuantizerWu.indexBits
      let iR = (red >> bitsToRemove) + 1
      let iG = (green >> bitsToRemove) + 1
      let iB = (blue >> bitsToRemove) + 1
      let index = QuantizerWu.getIndex(iR, iG, iB)

      weights[index] += count
      momentsR[index] += (red * count)
      momentsG[index] += (green * count)
      momentsB[index] += (blue * count)
      moments[index] +=
        (Double(count) * (Double(red * red) + Double(green * green) + Double(blue * blue)))
    }
  }

  public func computeMoments() {
    for r in 1..<QuantizerWu.sideLength {
      var area = [Int](repeating: 0, count: QuantizerWu.sideLength)
      var areaR = [Int](repeating: 0, count: QuantizerWu.sideLength)
      var areaG = [Int](repeating: 0, count: QuantizerWu.sideLength)
      var areaB = [Int](repeating: 0, count: QuantizerWu.sideLength)
      var area2 = [Double](repeating: 0, count: QuantizerWu.sideLength)
      for g in 1..<QuantizerWu.sideLength {
        var line: Int = 0
        var lineR: Int = 0
        var lineG: Int = 0
        var lineB: Int = 0
        var line2: Double = 0
        for b in 1..<QuantizerWu.sideLength {
          let index = QuantizerWu.getIndex(r, g, b)
          line += weights[index]
          lineR += momentsR[index]
          lineG += momentsG[index]
          lineB += momentsB[index]
          line2 += moments[index]

          area[b] += line
          areaR[b] += lineR
          areaG[b] += lineG
          areaB[b] += lineB
          area2[b] += line2

          let previousIndex = QuantizerWu.getIndex(r - 1, g, b)
          weights[index] = weights[previousIndex] + area[b]
          momentsR[index] = momentsR[previousIndex] + areaR[b]
          momentsG[index] = momentsG[previousIndex] + areaG[b]
          momentsB[index] = momentsB[previousIndex] + areaB[b]
          moments[index] = moments[previousIndex] + area2[b]
        }
      }
    }
  }

  public func createBoxes(_ maxColorCount: Int) -> CreateBoxesResult {
    cubes = []
    for _ in 0..<maxColorCount {
      cubes.append(Box())
    }
    cubes[0] = Box(
      r0: 0,
      r1: QuantizerWu.maxIndex,
      g0: 0,
      g1: QuantizerWu.maxIndex,
      b0: 0,
      b1: QuantizerWu.maxIndex,
      vol: 0
    )

    var volumeVariance = [Double](repeating: 0, count: maxColorCount)
    var next = 0
    var generatedColorCount = maxColorCount
    var i = 1
    while i < maxColorCount {
      if cut(cubes[next], cubes[i]) {
        volumeVariance[next] = (cubes[next].vol > 1) ? variance(cubes[next]) : 0
        volumeVariance[i] = (cubes[i].vol > 1) ? variance(cubes[i]) : 0
      } else {
        volumeVariance[next] = 0
        i -= 1
      }

      next = 0
      var temp = volumeVariance[0]
      var j = 1
      while j <= i {
        if volumeVariance[j] > temp {
          temp = volumeVariance[j]
          next = j
        }
        j += 1
      }
      if temp <= 0 {
        generatedColorCount = i + 1
        break
      }
      i += 1
    }

    return CreateBoxesResult(
      requestedCount: maxColorCount,
      resultCount: generatedColorCount
    )
  }

  public func createResult(_ colorCount: Int) -> [Int] {
    var colors: [Int] = []
    for i in 0..<colorCount {
      let cube = cubes[i]
      let weight = QuantizerWu.volume(cube, weights)
      if weight > 0 {
        let r = Int(round(Double(QuantizerWu.volume(cube, momentsR)) / Double(weight)))
        let g = Int(round(Double(QuantizerWu.volume(cube, momentsG)) / Double(weight)))
        let b = Int(round(Double(QuantizerWu.volume(cube, momentsB)) / Double(weight)))
        let color = ColorUtils.argbFromRgb(r, g, b)
        colors.append(color)
      }
    }
    return colors
  }

  public func variance(_ cube: Box) -> Double {
    let dr = QuantizerWu.volume(cube, momentsR)
    let dg = QuantizerWu.volume(cube, momentsG)
    let db = QuantizerWu.volume(cube, momentsB)
    let xx =
      moments[QuantizerWu.getIndex(cube.r1, cube.g1, cube.b1)]
      - moments[QuantizerWu.getIndex(cube.r1, cube.g1, cube.b0)]
      - moments[QuantizerWu.getIndex(cube.r1, cube.g0, cube.b1)]
      + moments[QuantizerWu.getIndex(cube.r1, cube.g0, cube.b0)]
      - moments[QuantizerWu.getIndex(cube.r0, cube.g1, cube.b1)]
      + moments[QuantizerWu.getIndex(cube.r0, cube.g1, cube.b0)]
      + moments[QuantizerWu.getIndex(cube.r0, cube.g0, cube.b1)]
      - moments[QuantizerWu.getIndex(cube.r0, cube.g0, cube.b0)]

    let hypotenuse = (dr * dr + dg * dg + db * db)
    let volume_ = QuantizerWu.volume(cube, weights)
    return xx - Double(hypotenuse / volume_)
  }

  public func cut(_ one: Box, _ two: Box) -> Bool {
    let wholeR = QuantizerWu.volume(one, momentsR)
    let wholeG = QuantizerWu.volume(one, momentsG)
    let wholeB = QuantizerWu.volume(one, momentsB)
    let wholeW = QuantizerWu.volume(one, weights)

    let maxRResult = maximize(
      one, Direction.red, one.r0 + 1, one.r1, wholeR, wholeG, wholeB, wholeW)
    let maxGResult = maximize(
      one, Direction.green, one.g0 + 1, one.g1, wholeR, wholeG, wholeB, wholeW)
    let maxBResult = maximize(
      one, Direction.blue, one.b0 + 1, one.b1, wholeR, wholeG, wholeB, wholeW)

    var cutDirection: Direction
    let maxR = maxRResult.maximum
    let maxG = maxGResult.maximum
    let maxB = maxBResult.maximum
    if maxR >= maxG && maxR >= maxB {
      cutDirection = Direction.red
      if maxRResult.cutLocation < 0 {
        return false
      }
    } else if maxG >= maxR && maxG >= maxB {
      cutDirection = Direction.green
    } else {
      cutDirection = Direction.blue
    }

    two.r1 = one.r1
    two.g1 = one.g1
    two.b1 = one.b1

    switch cutDirection {
    case Direction.red:
      one.r1 = maxRResult.cutLocation
      two.r0 = one.r1
      two.g0 = one.g0
      two.b0 = one.b0
      break
    case Direction.green:
      one.g1 = maxGResult.cutLocation
      two.r0 = one.r0
      two.g0 = one.g1
      two.b0 = one.b0
      break
    case Direction.blue:
      one.b1 = maxBResult.cutLocation
      two.r0 = one.r0
      two.g0 = one.g0
      two.b0 = one.b1
      break
    }

    one.vol = (one.r1 - one.r0) * (one.g1 - one.g0) * (one.b1 - one.b0)
    two.vol = (two.r1 - two.r0) * (two.g1 - two.g0) * (two.b1 - two.b0)
    return true
  }

  public func maximize(
    _ cube: Box, _ direction: Direction, _ first: Int, _ last: Int, _ wholeR: Int, _ wholeG: Int,
    _ wholeB: Int, _ wholeW: Int
  ) -> MaximizeResult {
    let bottomR = QuantizerWu.bottom(cube, direction, momentsR)
    let bottomG = QuantizerWu.bottom(cube, direction, momentsG)
    let bottomB = QuantizerWu.bottom(cube, direction, momentsB)
    let bottomW = QuantizerWu.bottom(cube, direction, weights)

    var max: Double = 0
    var cut: Int = -1

    for i in first..<last {
      var halfR = bottomR + QuantizerWu.top(cube, direction, i, momentsR)
      var halfG = bottomG + QuantizerWu.top(cube, direction, i, momentsG)
      var halfB = bottomB + QuantizerWu.top(cube, direction, i, momentsB)
      var halfW = bottomW + QuantizerWu.top(cube, direction, i, weights)

      if halfW == 0 {
        continue
      }

      var tempNumerator = Double((halfR * halfR) + (halfG * halfG) + (halfB * halfB))
      var tempDenominator = Double(halfW)
      var temp = tempNumerator / tempDenominator

      halfR = wholeR - halfR
      halfG = wholeG - halfG
      halfB = wholeB - halfB
      halfW = wholeW - halfW

      if halfW == 0 {
        continue
      }

      tempNumerator = Double((halfR * halfR) + (halfG * halfG) + (halfB * halfB))
      tempDenominator = Double(halfW)
      temp += (tempNumerator / tempDenominator)

      if temp > max {
        max = temp
        cut = i
      }
    }
    return MaximizeResult(cutLocation: cut, maximum: max)
  }

  public static func volume(_ cube: Box, _ moment: [Int]) -> Int {
    return
      (moment[getIndex(cube.r1, cube.g1, cube.b1)] - moment[getIndex(cube.r1, cube.g1, cube.b0)]
      - moment[getIndex(cube.r1, cube.g0, cube.b1)] + moment[getIndex(cube.r1, cube.g0, cube.b0)]
      - moment[getIndex(cube.r0, cube.g1, cube.b1)] + moment[getIndex(cube.r0, cube.g1, cube.b0)]
      + moment[getIndex(cube.r0, cube.g0, cube.b1)] - moment[getIndex(cube.r0, cube.g0, cube.b0)])
  }

  public static func bottom(_ cube: Box, _ direction: Direction, _ moment: [Int]) -> Int {
    switch direction {
    case Direction.red:
      return -moment[getIndex(cube.r0, cube.g1, cube.b1)]
        + moment[getIndex(cube.r0, cube.g1, cube.b0)] + moment[getIndex(cube.r0, cube.g0, cube.b1)]
        - moment[getIndex(cube.r0, cube.g0, cube.b0)]
    case Direction.green:
      return -moment[getIndex(cube.r1, cube.g0, cube.b1)]
        + moment[getIndex(cube.r1, cube.g0, cube.b0)] + moment[getIndex(cube.r0, cube.g0, cube.b1)]
        - moment[getIndex(cube.r0, cube.g0, cube.b0)]
    case Direction.blue:
      return -moment[getIndex(cube.r1, cube.g1, cube.b0)]
        + moment[getIndex(cube.r1, cube.g0, cube.b0)] + moment[getIndex(cube.r0, cube.g1, cube.b0)]
        - moment[getIndex(cube.r0, cube.g0, cube.b0)]
    }
  }

  public static func top(_ cube: Box, _ direction: Direction, _ position: Int, _ moment: [Int])
    -> Int
  {
    switch direction {
    case Direction.red:
      return
        (moment[getIndex(position, cube.g1, cube.b1)] - moment[getIndex(position, cube.g1, cube.b0)]
        - moment[getIndex(position, cube.g0, cube.b1)]
        + moment[getIndex(position, cube.g0, cube.b0)])
    case Direction.green:
      return
        (moment[getIndex(cube.r1, position, cube.b1)] - moment[getIndex(cube.r1, position, cube.b0)]
        - moment[getIndex(cube.r0, position, cube.b1)]
        + moment[getIndex(cube.r0, position, cube.b0)])
    case Direction.blue:
      return
        (moment[getIndex(cube.r1, cube.g1, position)] - moment[getIndex(cube.r1, cube.g0, position)]
        - moment[getIndex(cube.r0, cube.g1, position)]
        + moment[getIndex(cube.r0, cube.g0, position)])
    }
  }
}

public enum Direction {
  case red
  case green
  case blue
}

public class MaximizeResult {
  // < 0 if cut impossible
  var cutLocation: Int
  var maximum: Double

  init(cutLocation: Int, maximum: Double) {
    self.cutLocation = cutLocation
    self.maximum = maximum
  }
}

public class CreateBoxesResult {
  var requestedCount: Int
  var resultCount: Int

  init(requestedCount: Int, resultCount: Int) {
    self.requestedCount = requestedCount
    self.resultCount = resultCount
  }
}

public class Box {
  var r0: Int
  var r1: Int
  var g0: Int
  var g1: Int
  var b0: Int
  var b1: Int
  var vol: Int

  init(r0: Int = 0, r1: Int = 0, g0: Int = 0, g1: Int = 0, b0: Int = 0, b1: Int = 0, vol: Int = 0) {
    self.r0 = r0
    self.r1 = r1
    self.g0 = g0
    self.g1 = g1
    self.b0 = b0
    self.b1 = b1
    self.vol = vol
  }

  public var description: String {
    return "Box R \(r0) -> \(r1) G \(g0) -> \(g1) B \(b0) -> \(b1) VOL = \(vol)"
  }
}
