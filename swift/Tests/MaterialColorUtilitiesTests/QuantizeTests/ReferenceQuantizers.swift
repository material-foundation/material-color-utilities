// Copyright 2026 Google LLC
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

// A frozen copy of the quantizers before they were optimized, for `QuantizerEquivalenceTests`.
//
// Only the type names are changed (`Reference` prefix) and the access levels are internal. Do not
// change or optimize this code: it is the reference that the library is compared against.

import Foundation

@testable import MaterialColorUtilities

final class ReferenceQuantizerMap {
  func quantize(
    _ pixels: [Int], _ maxColors: Int, returnInputPixelToClusterPixel: Bool = false
  )
    -> QuantizerResult
  {
    var countByColor: [Int: Int] = [:]
    for pixel in pixels {
      let alpha = ColorUtils.alphaFromArgb(pixel)
      if alpha < 255 {
        continue
      }
      countByColor[pixel] = (countByColor[pixel] ?? 0) + 1
    }
    return QuantizerResult(countByColor)
  }
}

final class ReferenceQuantizerWu {
  var weights: [Int] = []
  var momentsR: [Int] = []
  var momentsG: [Int] = []
  var momentsB: [Int] = []
  var moments: [Double] = []
  var cubes: [ReferenceBox] = []

  // A histogram of all the input colors is constructed. It has the shape of a
  // cube. The cube would be too large if it contained all 16 million colors:
  // historical best practice is to use 5 bits  of the 8 in each channel,
  // reducing the histogram to a volume of ~32,000.
  static let indexBits: Int = 5
  static let maxIndex: Int = 32
  static let sideLength: Int = 33
  static let totalSize: Int = 35937

  func quantize(
    _ pixels: [Int], _ maxColors: Int, returnInputPixelToClusterPixel: Bool = false
  )
    -> QuantizerResult
  {
    let result = ReferenceQuantizerMap().quantize(pixels, maxColors)

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

  static func getIndex(_ r: Int, _ g: Int, _ b: Int) -> Int {
    let indexBits = ReferenceQuantizerWu.indexBits
    let red = r << (indexBits * 2)
    let green = r << (indexBits + 1)
    let blue = g << indexBits
    return red + green + blue + r + g + b
  }

  func constructHistogram(_ pixels: [(color: Int, population: Int)]) {
    weights = [Int](repeating: 0, count: ReferenceQuantizerWu.totalSize)
    momentsR = [Int](repeating: 0, count: ReferenceQuantizerWu.totalSize)
    momentsG = [Int](repeating: 0, count: ReferenceQuantizerWu.totalSize)
    momentsB = [Int](repeating: 0, count: ReferenceQuantizerWu.totalSize)
    moments = [Double](repeating: 0, count: ReferenceQuantizerWu.totalSize)
    for entry in pixels {
      let pixel = entry.color
      let count = entry.population

      let red = ColorUtils.redFromArgb(pixel)
      let green = ColorUtils.greenFromArgb(pixel)
      let blue = ColorUtils.blueFromArgb(pixel)

      let bitsToRemove = 8 - ReferenceQuantizerWu.indexBits
      let iR = (red >> bitsToRemove) + 1
      let iG = (green >> bitsToRemove) + 1
      let iB = (blue >> bitsToRemove) + 1
      let index = ReferenceQuantizerWu.getIndex(iR, iG, iB)

      weights[index] += count
      momentsR[index] += (red * count)
      momentsG[index] += (green * count)
      momentsB[index] += (blue * count)
      moments[index] +=
        (Double(count) * (Double(red * red) + Double(green * green) + Double(blue * blue)))
    }
  }

  func computeMoments() {
    for r in 1..<ReferenceQuantizerWu.sideLength {
      var area = [Int](repeating: 0, count: ReferenceQuantizerWu.sideLength)
      var areaR = [Int](repeating: 0, count: ReferenceQuantizerWu.sideLength)
      var areaG = [Int](repeating: 0, count: ReferenceQuantizerWu.sideLength)
      var areaB = [Int](repeating: 0, count: ReferenceQuantizerWu.sideLength)
      var area2 = [Double](repeating: 0, count: ReferenceQuantizerWu.sideLength)
      for g in 1..<ReferenceQuantizerWu.sideLength {
        var line: Int = 0
        var lineR: Int = 0
        var lineG: Int = 0
        var lineB: Int = 0
        var line2: Double = 0
        for b in 1..<ReferenceQuantizerWu.sideLength {
          let index = ReferenceQuantizerWu.getIndex(r, g, b)
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

          let previousIndex = ReferenceQuantizerWu.getIndex(r - 1, g, b)
          weights[index] = weights[previousIndex] + area[b]
          momentsR[index] = momentsR[previousIndex] + areaR[b]
          momentsG[index] = momentsG[previousIndex] + areaG[b]
          momentsB[index] = momentsB[previousIndex] + areaB[b]
          moments[index] = moments[previousIndex] + area2[b]
        }
      }
    }
  }

  func createBoxes(_ maxColorCount: Int) -> ReferenceCreateBoxesResult {
    cubes = []
    for _ in 0..<maxColorCount {
      cubes.append(ReferenceBox())
    }
    cubes[0] = ReferenceBox(
      r0: 0,
      r1: ReferenceQuantizerWu.maxIndex,
      g0: 0,
      g1: ReferenceQuantizerWu.maxIndex,
      b0: 0,
      b1: ReferenceQuantizerWu.maxIndex,
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

    return ReferenceCreateBoxesResult(
      requestedCount: maxColorCount,
      resultCount: generatedColorCount
    )
  }

  func createResult(_ colorCount: Int) -> [Int] {
    var colors: [Int] = []
    for i in 0..<colorCount {
      let cube = cubes[i]
      let weight = ReferenceQuantizerWu.volume(cube, weights)
      if weight > 0 {
        let r = Int(round(Double(ReferenceQuantizerWu.volume(cube, momentsR)) / Double(weight)))
        let g = Int(round(Double(ReferenceQuantizerWu.volume(cube, momentsG)) / Double(weight)))
        let b = Int(round(Double(ReferenceQuantizerWu.volume(cube, momentsB)) / Double(weight)))
        let color = ColorUtils.argbFromRgb(r, g, b)
        colors.append(color)
      }
    }
    return colors
  }

  func variance(_ cube: ReferenceBox) -> Double {
    let dr = ReferenceQuantizerWu.volume(cube, momentsR)
    let dg = ReferenceQuantizerWu.volume(cube, momentsG)
    let db = ReferenceQuantizerWu.volume(cube, momentsB)
    let xx =
      moments[ReferenceQuantizerWu.getIndex(cube.r1, cube.g1, cube.b1)]
      - moments[ReferenceQuantizerWu.getIndex(cube.r1, cube.g1, cube.b0)]
      - moments[ReferenceQuantizerWu.getIndex(cube.r1, cube.g0, cube.b1)]
      + moments[ReferenceQuantizerWu.getIndex(cube.r1, cube.g0, cube.b0)]
      - moments[ReferenceQuantizerWu.getIndex(cube.r0, cube.g1, cube.b1)]
      + moments[ReferenceQuantizerWu.getIndex(cube.r0, cube.g1, cube.b0)]
      + moments[ReferenceQuantizerWu.getIndex(cube.r0, cube.g0, cube.b1)]
      - moments[ReferenceQuantizerWu.getIndex(cube.r0, cube.g0, cube.b0)]

    let hypotenuse = (dr * dr + dg * dg + db * db)
    let volume_ = ReferenceQuantizerWu.volume(cube, weights)
    return xx - Double(hypotenuse / volume_)
  }

  func cut(_ one: ReferenceBox, _ two: ReferenceBox) -> Bool {
    let wholeR = ReferenceQuantizerWu.volume(one, momentsR)
    let wholeG = ReferenceQuantizerWu.volume(one, momentsG)
    let wholeB = ReferenceQuantizerWu.volume(one, momentsB)
    let wholeW = ReferenceQuantizerWu.volume(one, weights)

    let maxRResult = maximize(
      one, ReferenceDirection.red, one.r0 + 1, one.r1, wholeR, wholeG, wholeB, wholeW)
    let maxGResult = maximize(
      one, ReferenceDirection.green, one.g0 + 1, one.g1, wholeR, wholeG, wholeB, wholeW)
    let maxBResult = maximize(
      one, ReferenceDirection.blue, one.b0 + 1, one.b1, wholeR, wholeG, wholeB, wholeW)

    var cutDirection: ReferenceDirection
    let maxR = maxRResult.maximum
    let maxG = maxGResult.maximum
    let maxB = maxBResult.maximum
    if maxR >= maxG && maxR >= maxB {
      cutDirection = ReferenceDirection.red
      if maxRResult.cutLocation < 0 {
        return false
      }
    } else if maxG >= maxR && maxG >= maxB {
      cutDirection = ReferenceDirection.green
    } else {
      cutDirection = ReferenceDirection.blue
    }

    two.r1 = one.r1
    two.g1 = one.g1
    two.b1 = one.b1

    switch cutDirection {
    case ReferenceDirection.red:
      one.r1 = maxRResult.cutLocation
      two.r0 = one.r1
      two.g0 = one.g0
      two.b0 = one.b0
      break
    case ReferenceDirection.green:
      one.g1 = maxGResult.cutLocation
      two.r0 = one.r0
      two.g0 = one.g1
      two.b0 = one.b0
      break
    case ReferenceDirection.blue:
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

  func maximize(
    _ cube: ReferenceBox, _ direction: ReferenceDirection, _ first: Int, _ last: Int,
    _ wholeR: Int, _ wholeG: Int, _ wholeB: Int, _ wholeW: Int
  ) -> ReferenceMaximizeResult {
    let bottomR = ReferenceQuantizerWu.bottom(cube, direction, momentsR)
    let bottomG = ReferenceQuantizerWu.bottom(cube, direction, momentsG)
    let bottomB = ReferenceQuantizerWu.bottom(cube, direction, momentsB)
    let bottomW = ReferenceQuantizerWu.bottom(cube, direction, weights)

    var max: Double = 0
    var cut: Int = -1

    for i in first..<last {
      var halfR = bottomR + ReferenceQuantizerWu.top(cube, direction, i, momentsR)
      var halfG = bottomG + ReferenceQuantizerWu.top(cube, direction, i, momentsG)
      var halfB = bottomB + ReferenceQuantizerWu.top(cube, direction, i, momentsB)
      var halfW = bottomW + ReferenceQuantizerWu.top(cube, direction, i, weights)

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
    return ReferenceMaximizeResult(cutLocation: cut, maximum: max)
  }

  static func volume(_ cube: ReferenceBox, _ moment: [Int]) -> Int {
    return
      (moment[getIndex(cube.r1, cube.g1, cube.b1)] - moment[getIndex(cube.r1, cube.g1, cube.b0)]
      - moment[getIndex(cube.r1, cube.g0, cube.b1)] + moment[getIndex(cube.r1, cube.g0, cube.b0)]
      - moment[getIndex(cube.r0, cube.g1, cube.b1)] + moment[getIndex(cube.r0, cube.g1, cube.b0)]
      + moment[getIndex(cube.r0, cube.g0, cube.b1)] - moment[getIndex(cube.r0, cube.g0, cube.b0)])
  }

  static func bottom(_ cube: ReferenceBox, _ direction: ReferenceDirection, _ moment: [Int])
    -> Int
  {
    switch direction {
    case ReferenceDirection.red:
      return -moment[getIndex(cube.r0, cube.g1, cube.b1)]
        + moment[getIndex(cube.r0, cube.g1, cube.b0)] + moment[getIndex(cube.r0, cube.g0, cube.b1)]
        - moment[getIndex(cube.r0, cube.g0, cube.b0)]
    case ReferenceDirection.green:
      return -moment[getIndex(cube.r1, cube.g0, cube.b1)]
        + moment[getIndex(cube.r1, cube.g0, cube.b0)] + moment[getIndex(cube.r0, cube.g0, cube.b1)]
        - moment[getIndex(cube.r0, cube.g0, cube.b0)]
    case ReferenceDirection.blue:
      return -moment[getIndex(cube.r1, cube.g1, cube.b0)]
        + moment[getIndex(cube.r1, cube.g0, cube.b0)] + moment[getIndex(cube.r0, cube.g1, cube.b0)]
        - moment[getIndex(cube.r0, cube.g0, cube.b0)]
    }
  }

  static func top(
    _ cube: ReferenceBox, _ direction: ReferenceDirection, _ position: Int, _ moment: [Int]
  ) -> Int {
    switch direction {
    case ReferenceDirection.red:
      return
        (moment[getIndex(position, cube.g1, cube.b1)] - moment[getIndex(position, cube.g1, cube.b0)]
        - moment[getIndex(position, cube.g0, cube.b1)]
        + moment[getIndex(position, cube.g0, cube.b0)])
    case ReferenceDirection.green:
      return
        (moment[getIndex(cube.r1, position, cube.b1)] - moment[getIndex(cube.r1, position, cube.b0)]
        - moment[getIndex(cube.r0, position, cube.b1)]
        + moment[getIndex(cube.r0, position, cube.b0)])
    case ReferenceDirection.blue:
      return
        (moment[getIndex(cube.r1, cube.g1, position)] - moment[getIndex(cube.r1, cube.g0, position)]
        - moment[getIndex(cube.r0, cube.g1, position)]
        + moment[getIndex(cube.r0, cube.g0, position)])
    }
  }
}

enum ReferenceDirection {
  case red
  case green
  case blue
}

final class ReferenceMaximizeResult {
  // < 0 if cut impossible
  var cutLocation: Int
  var maximum: Double

  init(cutLocation: Int, maximum: Double) {
    self.cutLocation = cutLocation
    self.maximum = maximum
  }
}

final class ReferenceCreateBoxesResult {
  var requestedCount: Int
  var resultCount: Int

  init(requestedCount: Int, resultCount: Int) {
    self.requestedCount = requestedCount
    self.resultCount = resultCount
  }
}

final class ReferenceBox {
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

  var description: String {
    return "ReferenceBox R \(r0) -> \(r1) G \(g0) -> \(g1) B \(b0) -> \(b1) VOL = \(vol)"
  }
}

final class ReferencePointProviderLab: PointProvider {
  init() {}

  func fromInt(_ argb: Int) -> [Double] {
    return ColorUtils.labFromArgb(argb)
  }

  func toInt(_ lab: [Double]) -> Int {
    return ColorUtils.argbFromLab(lab[0], lab[1], lab[2])
  }

  func distance(_ one: [Double], _ two: [Double]) -> Double {
    let dL = (one[0] - two[0])
    let dA = (one[1] - two[1])
    let dB = (one[2] - two[2])
    // Standard CIE 1976 delta E formula also takes the square root, unneeded
    // here. This method is used by quantization algorithms to compare distance,
    // and the relative ordering is the same, with or without a square root.

    // This relatively minor optimization is helpful because this method is
    // called at least once for each pixel in an image.
    return (dL * dL + dA * dA + dB * dB)
  }
}

final class ReferenceDistanceAndIndex: Comparable {
  func compareTo(_ other: ReferenceDistanceAndIndex) -> Int {
    if distance < other.distance {
      return -1
    } else if distance > other.distance {
      return 1
    } else {
      return 0
    }
  }

  static func < (lhs: ReferenceDistanceAndIndex, rhs: ReferenceDistanceAndIndex) -> Bool {
    return lhs.distance < rhs.distance
  }

  static func == (lhs: ReferenceDistanceAndIndex, rhs: ReferenceDistanceAndIndex) -> Bool {
    return lhs.distance != rhs.distance
  }

  var distance: Double
  var index: Int

  init(_ distance: Double, _ index: Int) {
    self.distance = distance
    self.index = index
  }
}

final class ReferenceQuantizerWsmeans {
  static var debug: Bool = false

  static func debugLog(_ log: String) {
    if debug {
      print(log)
    }
  }

  static func quantize(
    _ inputPixels: [Int],
    _ maxColors: Int,
    startingClusters: [Int] = [],
    pointProvider: PointProvider = ReferencePointProviderLab(),
    maxIterations: Int = 5,
    returnInputPixelToClusterPixel: Bool = false
  ) -> QuantizerResult {
    var pixelToCount: [Int: Int] = [:]
    var points: [[Double]] = []
    var pixels: [Int] = []
    var pointCount = 0
    for inputPixel in inputPixels {
      var pixelCount = pixelToCount[inputPixel]
      if pixelCount == nil {
        pixelCount = 1
        pixelToCount[inputPixel] = pixelCount
      } else {
        pixelCount = pixelCount! + 1
        pixelToCount[inputPixel] = pixelCount
      }
      if pixelCount == 1 {
        pointCount = pointCount + 1
        points.append(pointProvider.fromInt(inputPixel))
        pixels.append(inputPixel)
      }
    }

    var counts = [Int](repeating: 0, count: pointCount)
    for i in 0..<pointCount {
      let pixel = pixels[i]
      let count = pixelToCount[pixel]
      counts[i] = count!
    }

    let clusterCount = min(maxColors, pointCount)

    var clusters = startingClusters.map { pointProvider.fromInt($0) }
    let additionalClustersNeeded = clusterCount - clusters.count
    if additionalClustersNeeded > 0 {
      var seedGenerator = ReferenceRandomNumberWithSeed(0x42688)
      var indices: [Int] = []
      for _ in 0..<additionalClustersNeeded {
        // Use existing points rather than generating random centroids.
        //
        // KMeans is extremely sensitive to initial clusters. This quantizer
        // is meant to be used with a Wu quantizer that provides initial
        // centroids, but Wu is very slow on unscaled images and when extracting
        // more than 256 colors.
        //
        // Here, we can safely assume that more than 256 colors were requested
        // for extraction. Generating random centroids tends to lead to many
        // "empty" centroids, as the random centroids are nowhere near any pixels
        // in the image, and the centroids from Wu are very refined and close
        // to pixels in the image.
        //
        // Rather than generate random centroids, we'll pick centroids that
        // are actual pixels in the image, and avoid duplicating centroids.
        var index = Int.random(in: 0..<points.count, using: &seedGenerator)
        while indices.contains(index) {
          index = Int.random(in: 0..<points.count, using: &seedGenerator)
        }
        indices.append(index)
      }

      for index in indices {
        clusters.append(points[index])
      }
    }
    ReferenceQuantizerWsmeans.debugLog(
      "have \(clusters.count) starting clusters, \(points.count) points")
    var clusterIndices = referenceFillArray(pointCount) { index in
      index % clusterCount
    }
    var indexMatrix = [[Int]](
      repeating: [Int](repeating: 0, count: clusterCount), count: clusterCount)
    var distanceToIndexMatrix: [[ReferenceDistanceAndIndex]] = referenceFillArray(clusterCount) {
      _ in
      referenceFillArray(clusterCount) { index in
        ReferenceDistanceAndIndex(0, index)
      }
    }
    var pixelCountSums = [Int](repeating: 0, count: clusterCount)
    for iteration in 0..<maxIterations {
      if ReferenceQuantizerWsmeans.debug {
        for i in 0..<clusterCount {
          pixelCountSums[i] = 0
        }
        for i in 0..<pointCount {
          let clusterIndex = clusterIndices[i]
          let count = counts[i]
          pixelCountSums[clusterIndex] = pixelCountSums[clusterIndex] + count
        }
        var emptyClusters = 0
        for cluster in 0..<clusterCount {
          if pixelCountSums[cluster] == 0 {
            emptyClusters = emptyClusters + 1
          }
        }
        ReferenceQuantizerWsmeans.debugLog(
          "starting iteration \(iteration + 1); \(emptyClusters) clusters are empty of \(clusterCount)"
        )
      }

      var pointsMoved = 0
      for i in 0..<clusterCount {
        for j in (i + 1)..<clusterCount {
          let distance = pointProvider.distance(clusters[i], clusters[j])
          distanceToIndexMatrix[j][i].distance = distance
          distanceToIndexMatrix[j][i].index = i
          distanceToIndexMatrix[i][j].distance = distance
          distanceToIndexMatrix[i][j].index = j
        }
        distanceToIndexMatrix[i].sort()
        for j in 0..<clusterCount {
          indexMatrix[i][j] = distanceToIndexMatrix[i][j].index
        }
      }

      for i in 0..<pointCount {
        let point = points[i]
        let previousClusterIndex = clusterIndices[i]
        let previousCluster = clusters[previousClusterIndex]
        let previousDistance = pointProvider.distance(point, previousCluster)
        var minimumDistance = previousDistance
        var newClusterIndex = -1
        for j in 0..<clusterCount {
          if distanceToIndexMatrix[previousClusterIndex][j].distance >= 4 * previousDistance {
            continue
          }
          let distance = pointProvider.distance(point, clusters[j])
          if distance < minimumDistance {
            minimumDistance = distance
            newClusterIndex = j
          }
        }
        if newClusterIndex != -1 {
          pointsMoved = pointsMoved + 1
          clusterIndices[i] = newClusterIndex
        }
      }

      if pointsMoved == 0 && iteration > 0 {
        ReferenceQuantizerWsmeans.debugLog("terminated after \(iteration) k-means iterations")
        break
      }

      ReferenceQuantizerWsmeans.debugLog("iteration \(iteration + 1) moved \(pointsMoved)")
      var componentASums = [Double](repeating: 0, count: clusterCount)
      var componentBSums = [Double](repeating: 0, count: clusterCount)
      var componentCSums = [Double](repeating: 0, count: clusterCount)

      for i in 0..<clusterCount {
        pixelCountSums[i] = 0
      }

      for i in 0..<pointCount {
        let clusterIndex = clusterIndices[i]
        let point = points[i]
        let count = counts[i]
        pixelCountSums[clusterIndex] = pixelCountSums[clusterIndex] + count
        componentASums[clusterIndex] = componentASums[clusterIndex] + (point[0] * Double(count))
        componentBSums[clusterIndex] = componentBSums[clusterIndex] + (point[1] * Double(count))
        componentCSums[clusterIndex] = componentCSums[clusterIndex] + (point[2] * Double(count))
      }

      for i in 0..<clusterCount {
        let count = pixelCountSums[i]
        if count == 0 {
          clusters[i] = [0, 0, 0]
          continue
        }
        let a = componentASums[i] / Double(count)
        let b = componentBSums[i] / Double(count)
        let c = componentCSums[i] / Double(count)
        clusters[i] = [a, b, c]
      }
    }

    var clusterArgbs: [Int] = []
    var clusterPopulations: [Int] = []
    for i in 0..<clusterCount {
      let count = pixelCountSums[i]
      if count == 0 {
        continue
      }

      let possibleNewCluster = pointProvider.toInt(clusters[i])
      if clusterArgbs.contains(possibleNewCluster) {
        continue
      }

      clusterArgbs.append(possibleNewCluster)
      clusterPopulations.append(count)
    }

    ReferenceQuantizerWsmeans.debugLog(
      "kmeans finished and generated \(clusterArgbs.count) clusters; \(clusterCount) were requested"
    )

    var inputPixelToClusterPixel: [Int: Int] = [:]
    if returnInputPixelToClusterPixel {
      let startTime = Date()
      for i in 0..<pixels.count {
        let inputPixel = pixels[i]
        let clusterIndex = clusterIndices[i]
        let cluster = clusters[clusterIndex]
        let clusterPixel = pointProvider.toInt(cluster)
        inputPixelToClusterPixel[inputPixel] = clusterPixel
      }
      let timeElapsed = abs(startTime.timeIntervalSinceNow)
      ReferenceQuantizerWsmeans.debugLog("took \(timeElapsed) ms to create input to cluster map")
    }

    var colorToCount: [Int: Int] = [:]
    for i in 0..<clusterArgbs.count {
      let key = clusterArgbs[i]
      let value = clusterPopulations[i]
      colorToCount[key] = value
    }
    return QuantizerResult(colorToCount, inputPixelToClusterPixel: inputPixelToClusterPixel)
  }
}

private func referenceFillArray<T>(_ count: Int, _ callback: (_ index: Int) -> T) -> [T] {
  var results: [T] = []
  for index in 0..<count {
    results.append(callback(index))
  }
  return results
}

private final class ReferenceRandomNumberWithSeed: RandomNumberGenerator {
  init(_ seed: Int) {
    srand48(seed)
  }

  func next() -> UInt64 {
    return UInt64(drand48() * Double(Int.max))
  }
}

final class ReferenceQuantizerCelebi {
  init() {}
  func quantize(
    _ pixels: [Int], _ maxColors: Int, returnInputPixelToClusterPixel: Bool = false
  )
    -> QuantizerResult
  {
    let wu = ReferenceQuantizerWu()
    let wuResult = wu.quantize(pixels, maxColors)
    let wsmeansResult = ReferenceQuantizerWsmeans.quantize(
      pixels,
      maxColors,
      startingClusters: Array(wuResult.colorToCount.keys).sorted(by: { $0 > $1 }),
      pointProvider: ReferencePointProviderLab(),
      returnInputPixelToClusterPixel: returnInputPixelToClusterPixel
    )
    return wsmeansResult
  }
}
