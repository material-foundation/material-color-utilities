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

import 'package:material_color_utilities/utils/color_utils.dart';
import 'package:material_color_utilities/utils/math_utils.dart';

import 'cam16.dart';
import 'viewing_conditions.dart';

/// HCT, hue, chroma, and tone. A color system that provides a perceptually
/// accurate color measurement system that can also accurately render what
/// colors will appear as in different lighting environments.
class HctColor {
  double _hue;
  double _chroma;
  double _tone;

  /// 0 <= [hue] < 360; invalid values are corrected.
  /// 0 <= [chroma] <= ?; Informally, colorfulness. The color returned may be
  ///    lower than the requested chroma. Chroma has a different maximum for any
  ///    given hue and tone.
  /// 0 <= [tone] <= 100; informally, lightness. Invalid values are corrected.
  static HctColor from(double hue, double chroma, double tone) {
    return HctColor._(hue, chroma, tone);
  }

  /// HCT representation of [argb].
  static HctColor fromInt(int argb) {
    final cam = Cam16.fromInt(argb);
    final tone = ColorUtils.lstarFromArgb(argb);
    return HctColor._(cam.hue, cam.chroma, tone);
  }

  int toInt() {
    return getInt(_hue, _chroma, _tone);
  }

  /// A number, in degrees, representing ex. red, orange, yellow, etc.
  /// Ranges from 0 <= [hue] < 360
  double get hue {
    return _hue;
  }

  /// 0 <= [newHue] < 360; invalid values are corrected.
  /// Chroma may decrease because chroma has a different maximum for any given
  /// hue and tone.
  set hue(double newHue) {
    _setInternalState(
        getInt(MathUtils.sanitizeDegreesDouble(newHue), _chroma, _tone));
  }

  double get chroma {
    return _chroma;
  }

  /// 0 <= [newChroma] <= ?
  /// Chroma may decrease because chroma has a different maximum for any given
  /// hue and tone.
  set chroma(double newChroma) {
    _setInternalState(getInt(_hue, newChroma, _tone));
  }

  /// Lightness. Ranges from 0 to 100.
  double get tone {
    return _tone;
  }

  /// 0 <= [newTone] <= 100; invalid values are corrected.
  /// Chroma may decrease because chroma has a different maximum for any given
  /// hue and tone.
  set tone(double newTone) {
    _setInternalState(
        getInt(_hue, _chroma, MathUtils.clampDouble(0.0, 100.0, newTone)));
  }

  HctColor._(double hue, double chroma, double tone)
      : _hue = MathUtils.sanitizeDegreesDouble(hue),
        _chroma = chroma,
        _tone = MathUtils.clampDouble(0.0, 100.0, tone) {
    _setInternalState(toInt());
  }

  void _setInternalState(int argb) {
    final cam = Cam16.fromInt(argb);
    final tone = ColorUtils.lstarFromArgb(argb);
    _hue = cam.hue;
    _chroma = cam.chroma;
    _tone = tone;
  }
}

/// When the delta between the floor & ceiling of a binary search for chroma is
/// less than this, the binary search terminates.
const _chromaSearchEndpoint = 0.4;

/// The maximum color distance, in CAM16-UCS, between a requested color and the
/// color returned.
const _deMax = 1.0;

/// The maximum difference between the requested L* and the L* returned.
const _dlMax = 0.2;

/// The minimum color distance, in CAM16-UCS, between a requested color and an
/// 'exact' match. This allows the binary search during gamut mapping to
/// terminate much earlier when the error is infinitesimal.
const _deMaxError = 0.000000001;

/// When the delta between the floor & ceiling of a binary search for J,
/// lightness in CAM16, is less than this, the binary search terminates.
const lightnessSearchEndpoint = 0.01;

int getInt(double hue, double chroma, double lstar) {
  return getIntInViewingConditions(
      hue: hue, chroma: chroma, lstar: lstar, frame: ViewingConditions.sRgb);
}

int getIntInViewingConditions({
  required double hue,
  required double chroma,
  required double lstar,
  required ViewingConditions frame,
}) {
  if (chroma < 1.0 || lstar.round() <= 0.0 || lstar.round() >= 100.0) {
    return ColorUtils.argbFromLstar(lstar);
  }

  hue = hue < 0
      ? 0
      : hue > 360
          ? 360
          : hue;

  // Perform a binary search to find a chroma low enough that lstar is
  // possible. For example, a high chroma, high L* red isn't available.

  // The highest chroma possible. Updated as binary search proceeds.
  var high = chroma;

  // The guess for the current binary search iteration. Starts off at the highest chroma, thus,
  // if a color is possible at the requested chroma, the search can stop early.
  var mid = chroma;
  var low = 0.0;
  var isFirstLoop = true;

  Cam16? answer;

  while ((low - high).abs() >= _chromaSearchEndpoint) {
    // Given the current chroma guess, mid, and the desired hue, find J, lightness in CAM16 color
    // space, that creates a color with L* = `lstar` in L*a*b*
    var possibleAnswer = findCamByJ(hue, mid, lstar, frame);

    if (isFirstLoop) {
      if (possibleAnswer != null) {
        return possibleAnswer.viewed(frame);
      } else {
        // If this binary search iteration was the first iteration, and this point has been reached,
        // it means the requested chroma was not available at the requested hue and L*. Proceed to a
        // traditional binary search, starting at the midpoint between the requested chroma and 0.

        isFirstLoop = false;
        mid = low + (high - low) / 2.0;
        continue;
      }
    }

    if (possibleAnswer == null) {
      // There isn't a CAM16 J that creates a color with L*a*b* L*. Try a lower chroma.
      high = mid;
    } else {
      answer = possibleAnswer;
      // It is possible to create a color with L* `lstar` and `mid` chroma. Try a higher chroma.
      low = mid;
    }

    mid = low + (high - low) / 2.0;
  }

  // There was no answer: for the desired hue, there was no chroma low enough to generate a color
  // with the desired L*. All values of L* are possible when there is 0 chroma. Return a color
  // with 0 chroma, i.e. a shade of gray, with the desired L*.
  if (answer == null) {
    return ColorUtils.argbFromLstar(lstar);
  }

  return answer.viewed(frame);
}

Cam16? findCamByJ(
    double hue, double chroma, double lstar, ViewingConditions frame) {
  var low = 0.0;
  var high = 100.0;
  var mid = 0.0;
  var bestdL = double.maxFinite;
  var bestdE = double.maxFinite;
  Cam16? bestCam;
  while ((low - high).abs() > lightnessSearchEndpoint) {
    mid = low + (high - low) / 2;
    final camBeforeClip =
        Cam16.fromJchInViewingConditions(mid, chroma, hue, frame);
    final clipped = camBeforeClip.viewed(frame);
    final clippedLstar = ColorUtils.lstarFromArgb(clipped);
    final dL = (lstar - clippedLstar).abs();
    if (dL < _dlMax) {
      final camClipped = Cam16.fromIntInViewingConditions(clipped, frame);
      final dE = camClipped.distance(Cam16.fromJchInViewingConditions(
          camClipped.j, camClipped.chroma, hue, frame));
      if ((dE <= _deMax && dE < bestdE) && dL < _dlMax) {
        bestdL = dL;
        bestdE = dE;
        bestCam = camClipped;
      }
    }

    if (bestdL == 0 && bestdE < _deMaxError) {
      break;
    }

    if (clippedLstar < lstar) {
      low = mid;
    } else {
      high = mid;
    }
  }

  return bestCam;
}
