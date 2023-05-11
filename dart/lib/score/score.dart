// Copyright 2021 Google LLC
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

import 'package:collection/collection.dart';
import 'package:material_color_utilities/hct/hct.dart';
import 'package:material_color_utilities/utils/math_utils.dart';

class _ScoredHCT implements Comparable<_ScoredHCT> {
  Hct hct;
  double score;

  _ScoredHCT(this.hct, this.score);

  @override
  int compareTo(_ScoredHCT other) {
    if (score > other.score) {
      return -1;
    } else if (score == other.score) {
      return 0;
    } else {
      return 1;
    }
  }
}

/// Given a large set of colors, remove colors that are unsuitable for a UI
/// theme, and rank the rest based on suitability.
///
/// Enables use of a high cluster count for image quantization, thus ensuring
/// colors aren't muddied, while curating the high cluster count to a much
///  smaller number of appropriate choices.
class Score {
  static final _targetChroma = 48.0; // A1 Chroma
  static final _weightProportion = 0.7;
  static final _weightChromaAbove = 0.3;
  static final _weightChromaBelow = 0.1;
  static final _cutoffChroma = 5.0;
  static final _cutoffExcitedProportion = 0.01;

  /// Given a map with keys of colors and values of how often the color appears,
  /// rank the colors based on suitability for being used for a UI theme.
  ///
  /// [colorsToPopulation] is a map with keys of colors and values of often the
  /// color appears, usually from a source image.
  /// [desired] max count of colors to be returned in the list.
  /// [fallbackColorARGB] color to be returned if no other options available.
  /// [filter] whether to filter out undesireable combinations.
  ///
  /// The list returned is of length <= [desired]. The recommended color is the
  /// first item, the least suitable is the last. There will always be at least
  /// one color returned. If all the input colors were not suitable for a theme,
  /// a default fallback color will be provided, Google Blue. The default
  /// number of colors returned is 4, simply because thats the # of colors
  /// display in Android 12's wallpaper picker.
  static List<int> score(Map<int, int> colorsToPopulation,
      {int desired = 4,
      int fallbackColorARGB = 0xff4285F4,
      bool filter = true}) {
    // Get the HCT color for each Argb value, while finding the per hue count and
    // total count.
    final colorsHct = <Hct>[];
    final huePopulation = List<int>.filled(360, 0);
    var populationSum = 0;
    for (var entry in colorsToPopulation.entries) {
      final argb = entry.key;
      final population = entry.value;
      final hct = Hct.fromInt(argb);
      colorsHct.add(hct);
      final hue = hct.hue.floor();
      huePopulation[hue] += population;
      populationSum += population;
    }

    // Hues with more usage in neighboring 30 degree slice get a larger number.
    final hueExcitedProportions = List<double>.filled(360, 0.0);
    for (var hue = 0; hue < 360; hue++) {
      final proportion = huePopulation[hue] / populationSum;
      for (var i = hue - 14; i < hue + 16; i++) {
        final neighborHue = MathUtils.sanitizeDegreesInt(i);
        hueExcitedProportions[neighborHue] += proportion;
      }
    }

    // Scores each HCT color based on usage and chroma, while optionally
    // filtering out values that do not have enough chroma or usage.
    final scoredHcts = <_ScoredHCT>[];
    for (final hct in colorsHct) {
      final hue = MathUtils.sanitizeDegreesInt(hct.hue.round());
      final proportion = hueExcitedProportions[hue];
      if (filter &&
          (hct.chroma < _cutoffChroma ||
              proportion <= _cutoffExcitedProportion)) {
        continue;
      }

      final proportionScore = proportion * 100.0 * _weightProportion;
      final chromaWeight =
          hct.chroma < _targetChroma ? _weightChromaBelow : _weightChromaAbove;
      final chromaScore = (hct.chroma - _targetChroma) * chromaWeight;
      final score = proportionScore + chromaScore;
      scoredHcts.add(_ScoredHCT(hct, score));
    }
    // Sorted so that colors with higher scores come first.
    scoredHcts.sort();

    // Iterates through potential hue differences in degrees in order to select
    // the colors with the largest distribution of hues possible. Starting at
    // 90 degrees(maximum difference for 4 colors) then decreasing down to a
    // 15 degree minimum.
    final chosenColors = <Hct>[];
    for (var differenceDegrees = 90;
        differenceDegrees >= 15;
        differenceDegrees--) {
      chosenColors.clear();
      for (final entry in scoredHcts) {
        final hct = entry.hct;
        final duplicateHue = chosenColors.firstWhereOrNull((chosenHct) =>
            MathUtils.differenceDegrees(hct.hue, chosenHct.hue) <
            differenceDegrees);
        if (duplicateHue == null) {
          chosenColors.add(hct);
        }
        if (chosenColors.length >= desired) break;
      }
      if (chosenColors.length >= desired) break;
    }
    final colors = <int>[];
    if (chosenColors.isEmpty) {
      colors.add(fallbackColorARGB);
    }
    for (final chosenHct in chosenColors) {
      colors.add(chosenHct.toInt());
    }
    return colors;
  }
}
