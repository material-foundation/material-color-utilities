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

private struct ScoredHCT {
  let hct: Hct
  let score: Double

  init(hct: Hct, score: Double) {
    self.hct = hct
    self.score = score
  }
}

/// Given a large set of colors, remove colors that are unsuitable for a UI
/// theme, and rank the rest based on suitability.
///
/// Enables use of a high cluster count for image quantization, thus ensuring
/// colors aren't muddied, while curating the high cluster count to a much
///  smaller number of appropriate choices.
public enum Score {
  static private let targetChroma: Double = 48.0  // A1 Chroma
  static private let weightProportion: Double = 0.7
  static private let weightChromaAbove: Double = 0.3
  static private let weightChromaBelow: Double = 0.1
  static private let cutoffChroma: Double = 5.0
  static private let cutoffExcitedProportion: Double = 0.01

  /// Given a map with keys of colors and values of how often the color appears,
  /// rank the colors based on suitability for being used for a UI theme.
  ///
  /// - Parameters:
  ///   `colorsToPopulation`: is a map with keys of colors and values of often
  ///     the color appears, usually from a source image.
  ///   `desired`: Max count of colors to be returned in the list.
  ///   `fallbackColorARGB`: Color to be returned if no other options available.
  ///   `filter`: Whether to filter out undesireable combinations.
  ///
  /// - Returns: A list of color `Int` that can be used when generating a theme.
  ///   The list returned is of length <= `desired`. The recommended color is
  ///   the first item, the least suitable is the last. There will always be at
  ///   least one color returned. If all the input colors were not suitable for
  ///   a theme, a default fallback color will be provided, Google Blue. The
  ///   default number of colors returned is 4, simply because thats the # of
  ///   colors display in Android 12's wallpaper picker.
  public static func score(
    _ colorsToPopulation: [Int: Int], desired: Int = 4, fallbackColorARGB: Int = 0xff42_85F4,
    filter: Bool = true
  )
    -> [Int]
  {
    // Get the HCT color for each Argb value, while finding the per hue count and
    // total count.
    var colorsHCT: [Hct] = []
    var huePopulation = [Int](repeating: 0, count: 360)
    var populationSum: Double = 0.0
    for argb in colorsToPopulation.keys {
      let population = colorsToPopulation[argb]!
      let hct = Hct.fromInt(argb)
      colorsHCT.append(hct)
      let hue = Int(floor(hct.hue))
      huePopulation[hue] += population
      populationSum += Double(population)
    }

    // Hues with more usage in neighboring 30 degree slice get a larger number.
    var hueExcitedProportions = [Double](repeating: 0.0, count: 360)
    for hue in 0..<360 {
      let proportion = Double(huePopulation[hue]) / populationSum
      for i in (hue - 14)..<(hue + 16) {
        let neighborHue = MathUtils.sanitizeDegreesInt(i)
        hueExcitedProportions[neighborHue] += proportion
      }
    }

    // Scores each HCT color based on usage and chroma, while optionally
    // filtering out values that do not have enough chroma or usage.
    var scoredHCTs: [ScoredHCT] = []
    for hct in colorsHCT {
      let hue = MathUtils.sanitizeDegreesInt(Int(round(hct.hue)))
      let proportion = hueExcitedProportions[hue]
      if filter && (hct.chroma < cutoffChroma || proportion <= cutoffExcitedProportion) {
        continue
      }

      let proportionScore = proportion * 100.0 * weightProportion
      let chromaWeight = hct.chroma < targetChroma ? weightChromaBelow : weightChromaAbove
      let chromaScore = (hct.chroma - targetChroma) * chromaWeight
      let score = proportionScore + chromaScore
      scoredHCTs.append(ScoredHCT(hct: hct, score: score))
    }
    // Sorted so that colors with higher scores come first.
    scoredHCTs.sort {
      $0.score > $1.score
    }

    // Iterates through potential hue differences in degrees in order to select
    // the colors with the largest distribution of hues possible. Starting at
    // 90 degrees(maximum difference for 4 colors) then decreasing down to a
    // 15 degree minimum.
    var chosenColors: [Hct] = []
    for differenceDegrees in (15...90).reversed() {
      chosenColors.removeAll()
      for entry in scoredHCTs {
        if !chosenColors.contains(where: {
          MathUtils.differenceDegrees(entry.hct.hue, $0.hue) < Double(differenceDegrees)
        }) {
          chosenColors.append(entry.hct)
        }
        if chosenColors.count >= desired {
          break
        }
      }
      if chosenColors.count >= desired {
        break
      }
    }
    var colors: [Int] = []
    if chosenColors.isEmpty {
      colors.append(fallbackColorARGB)
    }
    for chosenHCT in chosenColors {
      colors.append(chosenHCT.toInt())
    }
    return colors
  }
}
