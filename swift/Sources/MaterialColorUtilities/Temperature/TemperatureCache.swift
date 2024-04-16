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

/// Design utilities using color temperature theory.
///
/// Analogous colors, complementary color, and cache to efficiently, lazily,
/// generate data for calculations when needed.
class TemperatureCache {
  let input: Hct

  private var _hctsByTemp: [Hct] = []
  private var _hctsByHue: [Hct] = []
  private var _tempsByHct: [Hct: Double] = [:]
  private var _inputRelativeTemperature: Double = -1
  private var _complement: Hct? = nil

  public var warmest: Hct {
    return hctsByTemp.last!
  }

  public var coldest: Hct {
    return hctsByTemp.first!
  }

  public init(_ input: Hct) {
    self.input = input
  }

  /// A set of colors with differing hues, equidistant in temperature.
  ///
  /// In art, this is usually described as a set of 5 colors on a color wheel
  /// divided into 12 sections. This method allows provision of either of those
  /// values.
  ///
  /// Behavior is undefined when [count] or [divisions] is 0.
  /// When divisions < count, colors repeat.
  ///
  /// [count] The number of colors to return, includes the input color.
  /// [divisions] The number of divisions on the color wheel.
  public func analogous(count: Int = 5, divisions: Int = 12) -> [Hct] {
    let startHue = Int(round(input.hue))
    let startHct = hctsByHue[startHue]
    var lastTemp = relativeTemperature(startHct)
    var allColors: [Hct] = [startHct]

    var absoluteTotalTempDelta = 0.0
    for i in 0..<360 {
      let hue = MathUtils.sanitizeDegreesInt(startHue + i)
      let hct = hctsByHue[hue]
      let temp = relativeTemperature(hct)
      let tempDelta = abs(temp - lastTemp)
      lastTemp = temp
      absoluteTotalTempDelta += tempDelta
    }
    var hueAddend = 1
    let tempStep = absoluteTotalTempDelta / Double(divisions)
    var totalTempDelta: Double = 0
    lastTemp = relativeTemperature(startHct)
    while allColors.count < divisions {
      let hue = MathUtils.sanitizeDegreesInt(startHue + hueAddend)
      let hct = hctsByHue[hue]
      let temp = relativeTemperature(hct)
      let tempDelta = abs(temp - lastTemp)
      totalTempDelta += tempDelta

      let desiredTotalTempDeltaForIndex = Double(allColors.count) * tempStep
      var indexSatisfied = totalTempDelta >= desiredTotalTempDeltaForIndex
      var indexAddend = 1

      // Keep adding this hue to the answers until its temperature is
      // insufficient. This ensures consistent behavior when there aren't
      // [divisions] discrete steps between 0 and 360 in hue with [tempStep]
      // delta in temperature between them.
      //
      // For example, white and black have no analogues: there are no other
      // colors at T100/T0. Therefore, they should just be added to the array
      // as answers.
      while indexSatisfied && allColors.count < divisions {
        allColors.append(hct)
        let desiredTotalTempDeltaForIndex = (Double(allColors.count + indexAddend) * tempStep)
        indexSatisfied = totalTempDelta >= desiredTotalTempDeltaForIndex
        indexAddend += 1
      }
      lastTemp = temp
      hueAddend += 1
      if hueAddend > 360 {
        while allColors.count < divisions {
          allColors.append(hct)
        }
        break
      }
    }

    var answers: [Hct] = [input]

    // First, generate analogues from rotating counter-clockwise.
    let increaseHueCount = Int(floor(Double(count - 1) / 2))
    for i in 1...increaseHueCount {
      var index = 0 - i
      while index < 0 {
        index = allColors.count + index
      }
      if index >= allColors.count {
        index = index % allColors.count
      }
      answers.insert(allColors[index], at: 0)
    }

    // Second, generate analogues from rotating clockwise.
    let decreaseHueCount = count - increaseHueCount - 1
    for i in 1...decreaseHueCount {
      var index = i
      while index < 0 {
        index = allColors.count + index
      }
      if index >= allColors.count {
        index = index % allColors.count
      }
      answers.append(allColors[index])
    }

    return answers
  }

  /// A color that complements the input color aesthetically.
  ///
  /// In art, this is usually described as being across the color wheel.
  /// History of this shows intent as a color that is just as cool-warm as the
  /// input color is warm-cool.
  public var complement: Hct {
    if _complement != nil {
      return _complement!
    }

    let coldestHue = coldest.hue
    let coldestTemp = tempsByHct[coldest]!

    let warmestHue = warmest.hue
    let warmestTemp = tempsByHct[warmest]!

    let range = warmestTemp - coldestTemp
    let startHueIsColdestToWarmest = TemperatureCache.isBetween(
      angle: input.hue, a: coldestHue, b: warmestHue)
    let startHue = startHueIsColdestToWarmest ? warmestHue : coldestHue
    let endHue = startHueIsColdestToWarmest ? coldestHue : warmestHue
    let directionOfRotation: Double = 1
    var smallestError: Double = 1000
    var answer = hctsByHue[Int(round(input.hue))]

    let complementRelativeTemp = 1 - inputRelativeTemperature
    // Find the color in the other section, closest to the inverse percentile
    // of the input color. This is the complement.
    for hueAddend in 0...360 {
      let hue = MathUtils.sanitizeDegreesDouble(startHue + directionOfRotation * Double(hueAddend))
      if !TemperatureCache.isBetween(angle: hue, a: startHue, b: endHue) {
        continue
      }
      let possibleAnswer = hctsByHue[Int(round(hue))]
      let relativeTemp = (_tempsByHct[possibleAnswer]! - coldestTemp) / range
      let error = abs(complementRelativeTemp - relativeTemp)
      if error < smallestError {
        smallestError = error
        answer = possibleAnswer
      }
    }
    _complement = answer
    return _complement!
  }

  /// Temperature relative to all colors with the same chroma and tone.
  /// Value on a scale from 0 to 1.
  public func relativeTemperature(_ hct: Hct) -> Double {
    let range = tempsByHct[warmest]! - tempsByHct[coldest]!
    let differenceFromColdest = tempsByHct[hct]! - tempsByHct[coldest]!

    // Handle when there's no difference in temperature between warmest and
    // coldest: for example, at T100, only one color is available, white.
    if range == 0 {
      return 0.5
    }
    return differenceFromColdest / range
  }

  /// Relative temperature of the input color. See [relativeTemperature].
  public var inputRelativeTemperature: Double {
    if _inputRelativeTemperature >= 0 {
      return _inputRelativeTemperature
    }

    let coldestTemp = tempsByHct[coldest]!

    let range = tempsByHct[warmest]! - coldestTemp
    let differenceFromColdest = tempsByHct[input]! - coldestTemp
    let inputRelativeTemp = (range == 0) ? 0.5 : differenceFromColdest / range

    _inputRelativeTemperature = inputRelativeTemp
    return _inputRelativeTemperature
  }

  /// HCTs for all hues, with the same chroma/tone as the input.
  /// Sorted from coldest first to warmest last.
  public var hctsByTemp: [Hct] {
    if !_hctsByTemp.isEmpty {
      return _hctsByTemp
    }

    var hcts = hctsByHue
    hcts.append(input)
    hcts.sort(by: sortByTemp)
    _hctsByTemp = hcts
    return _hctsByTemp
  }

  private func sortByTemp(this: Hct, that: Hct) -> Bool {
    let a = tempsByHct[this]!
    let b = tempsByHct[that]!
    return a < b
  }

  /// A Map with keys of HCTs in [hctsByTemp], values of raw temperature.
  public var tempsByHct: [Hct: Double] {
    if !_tempsByHct.isEmpty {
      return _tempsByHct
    }

    var allHcts = hctsByHue
    allHcts.append(input)
    var temperaturesByHct: [Hct: Double] = [:]
    for e in allHcts {
      temperaturesByHct[e] = TemperatureCache.rawTemperature(e)
    }
    _tempsByHct = temperaturesByHct
    return _tempsByHct
  }

  /// HCTs for all hues, with the same chroma/tone as the input.
  /// Sorted ascending, hue 0 to 360.
  public var hctsByHue: [Hct] {
    if !_hctsByHue.isEmpty {
      return _hctsByHue
    }
    var hcts: [Hct] = []
    for hue in 0...360 {
      let colorAtHue = Hct.from(Double(hue), input.chroma, input.tone)
      hcts.append(colorAtHue)
    }
    _hctsByHue = hcts
    return _hctsByHue
  }

  /// Determines if an angle is between two other angles, rotating clockwise.
  public static func isBetween(angle: Double, a: Double, b: Double) -> Bool {
    if a < b {
      return a <= angle && angle <= b
    } else {
      return a <= angle || angle <= b
    }
  }

  /// Value representing cool-warm factor of a color.
  /// Values below 0 are considered cool, above, warm.
  ///
  /// Color science has researched emotion and harmony, which art uses to select
  /// colors. Warm-cool is the foundation of analogous and complementary colors.
  /// See:
  /// - Li-Chen Ou's Chapter 19 in Handbook of Color Psychology (2015).
  /// - Josef Albers' Interaction of Color chapters 19 and 21.
  ///
  /// Implementation of Ou, Woodcock and Wright's algorithm, which uses
  /// L*a*b*/LCH color space.
  /// Return value has these properties:
  /// - Values below 0 are cool, above 0 are warm.
  /// - Lower bound: -0.52 - (chroma ^ 1.07 / 20). L*a*b* chroma is infinite.
  ///   Assuming max of 130 chroma, -9.66.
  /// - Upper bound: -0.52 + (chroma ^ 1.07 / 20). L*a*b* chroma is infinite.
  ///   Assuming max of 130 chroma, 8.61.
  public static func rawTemperature(_ color: Hct) -> Double {
    let lab = ColorUtils.labFromArgb(color.toInt())
    let hue = MathUtils.sanitizeDegreesDouble(
      atan2(lab[2], lab[1]) * 180.0 / Double.pi)
    let chroma = sqrt((lab[1] * lab[1]) + (lab[2] * lab[2]))
    let temperature =
      -0.5 + 0.02 * pow(chroma, 1.07)
      * cos(MathUtils.sanitizeDegreesDouble(hue - 50.0) * Double.pi / 180.0)
    return temperature
  }
}
