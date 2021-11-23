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

import 'package:material_color_utilities/hct/cam16.dart';
import 'package:material_color_utilities/utils/color_utils.dart';
import 'package:material_color_utilities/utils/math_utils.dart';

///
class ArgbAndScore implements Comparable<ArgbAndScore> {
  int argb;
  double score;

  ArgbAndScore(this.argb, this.score);

  @override
  int compareTo(ArgbAndScore other) {
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
  static final _targetChroma = 48.0;
  static final _weightProportion = 0.7;
  static final _weightChromaAbove = 0.3;
  static final _weightChromaBelow = 0.1;
  static final _cutoffChroma = 15.0;
  static final _cutoffTone = 10.0;
  static final _cutoffExcitedProportion = 0.01;

  /// Given a map with keys of colors and values of how often the color appears,
  /// rank the colors based on suitability for being used for a UI theme.
  ///
  /// [colorsToPopulation] is a map with keys of colors and values of often the
  /// color appears, usually from a source image.
  ///
  /// The list returned is colors sorted by suitability for a UI theme. The most
  /// suitable color is the first item, the least suitable is the last. There
  /// will always be at least one color returned. If all the input colors were
  /// not suitable for a theme, a default fallback color will be provided,
  /// Google Blue.
  static List<int> score(Map<int, int> colorsToPopulation) {
    var populationSum = 0.0;
    for (var population in colorsToPopulation.values) {
      populationSum += population;
    }

    // Turn the count of each color into a proportion by dividing by the total
    // count. Also, fill a cache of CAM16 colors representing each color, and
    // record the proportion of colors for each CAM16 hue.
    final colorsToProportion = <int, double>{};
    final colorsToCam = <int, Cam16>{};
    final hueProportions = List<double>.filled(360, 0.0);
    for (var color in colorsToPopulation.keys) {
      final population = colorsToPopulation[color]!;
      final proportion = population / populationSum;
      colorsToProportion[color] = proportion;

      final cam = Cam16.fromInt(color);
      colorsToCam[color] = cam;

      final hue = cam.hue.round();
      hueProportions[hue] += proportion;
    }

    // Determine the proportion of the colors around each color, by summing the
    // proportions around each color's hue.
    final colorsToExcitedProportion = <int, double>{};
    for (var entry in colorsToCam.entries) {
      final color = entry.key;
      final cam = entry.value;
      final hue = cam.hue.round();

      var excitedProportion = 0.0;
      for (var i = hue - 15; i < hue + 15; i++) {
        final neighborHue = MathUtils.sanitizeDegreesInt(i);
        excitedProportion += hueProportions[neighborHue];
      }
      colorsToExcitedProportion[color] = excitedProportion;
    }

    // Score the colors by their proportion, as well as how chromatic they are.
    final colorsToScore = <int, double>{};
    for (var entry in colorsToCam.entries) {
      final color = entry.key;
      final cam = entry.value;
      final proportion = colorsToExcitedProportion[color]!;

      final proportionScore = proportion * 100.0 * _weightProportion;

      final chromaWeight =
          cam.chroma < _targetChroma ? _weightChromaBelow : _weightChromaAbove;
      final chromaScore = (cam.chroma - _targetChroma) * chromaWeight;

      final score = proportionScore + chromaScore;
      colorsToScore[color] = score;
    }

    // Remove colors that are unsuitable, ex. very dark or unchromatic colors.
    // Also, remove colors that are very similar in hue.
    final filteredColors = _filter(colorsToExcitedProportion, colorsToCam);
    final filteredColorsToScore = <int, double>{};
    for (var color in filteredColors) {
      var duplicateHue = false;
      final cam = colorsToCam[color]!;
      for (var alreadyChosenColor in filteredColorsToScore.keys) {
        final alreadyChosenCam = colorsToCam[alreadyChosenColor]!;
        if (MathUtils.differenceDegrees(cam.hue, alreadyChosenCam.hue) < 15) {
          duplicateHue = true;
          break;
        }
      }
      if (!duplicateHue) {
        filteredColorsToScore[color] = colorsToScore[color]!;
      }
    }

    // Ensure the list of colors returned is sorted such that the first in the
    // list is the most suitable, and the last is the least suitable.
    final colorsByScoreDescending = filteredColorsToScore.entries
        .map((entry) => ArgbAndScore(entry.key, entry.value))
        .toList();
    colorsByScoreDescending.sort();

    // Ensure that at least one color is returned.
    if (colorsByScoreDescending.isEmpty) {
      return [0xff4285F4]; // Google Blue
    }
    return colorsByScoreDescending.map((e) => e.argb).toList();
  }

  static List<int> _filter(
      Map<int, double> colorsToExcitedProportion, Map<int, Cam16> colorsToCam) {
    final filtered = <int>[];
    for (var entry in colorsToCam.entries) {
      final color = entry.key;
      final cam = entry.value;
      final proportion = colorsToExcitedProportion[color]!;

      if (cam.chroma >= _cutoffChroma &&
          ColorUtils.lstarFromArgb(color) >= _cutoffTone &&
          proportion >= _cutoffExcitedProportion) {
        filtered.add(color);
      }
    }
    return filtered;
  }
}
