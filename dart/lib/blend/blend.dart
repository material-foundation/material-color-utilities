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
import 'dart:math' as math;

import 'package:material_color_utilities/hct/cam16.dart';
import 'package:material_color_utilities/hct/hct.dart';
import 'package:material_color_utilities/utils/color_utils.dart';
import 'package:material_color_utilities/utils/math_utils.dart';

/// Functions for blending in HCT and CAM16.
class Blend {
  /// Shifts [designColor]'s hue towards [sourceColor]'s, creating a slightly
  /// warmer/coolor variant of [designColor]. Hue will shift up to 15 degrees.
  static int harmonize(int designColor, int sourceColor) {
    final fromHct = HctColor.fromInt(designColor);
    final toHct = HctColor.fromInt(sourceColor);
    final differenceDegrees =
        MathUtils.differenceDegrees(fromHct.hue, toHct.hue);
    final rotationDegrees = math.min(differenceDegrees * 0.5, 15.0);
    final outputHue = MathUtils.sanitizeDegreesDouble(fromHct.hue +
        rotationDegrees * _rotationDirection(fromHct.hue, toHct.hue));
    return HctColor.from(outputHue, fromHct.chroma, fromHct.tone).toInt();
  }

  /// Blends [from]'s hue in HCT toward's [to]'s hue.
  static int hctHue(int from, int to, double amount) {
    final ucs = Blend.cam16ucs(from, to, amount);
    final ucsCam = Cam16.fromInt(ucs);
    final fromCam = Cam16.fromInt(from);
    final blended = HctColor.from(
            ucsCam.hue, fromCam.chroma, ColorUtils.lstarFromArgb(from))
        .toInt();
    return blended;
  }

  /// Blend [from] and [to] in the CAM16-UCS color space.
  static int cam16ucs(int from, int to, double amount) {
    final fromCam = Cam16.fromInt(from);
    final toCam = Cam16.fromInt(to);

    final fromJstar = fromCam.jstar;
    final fromAstar = fromCam.astar;
    final fromBstar = fromCam.bstar;

    final toJstar = toCam.jstar;
    final toAstar = toCam.astar;
    final toBstar = toCam.bstar;

    final jstar = fromJstar + (toJstar - fromJstar) * amount;
    final astar = fromAstar + (toAstar - fromAstar) * amount;
    final bstar = fromBstar + (toBstar - fromBstar) * amount;

    return Cam16.fromUcs(jstar, astar, bstar).viewedInSRgb;
  }

  /// Sign of direction change needed to travel from one angle to another.
  ///
  /// [from] is the angle travel starts from in degrees. [to] is the ending
  /// angle, also in degrees.
  ///
  /// The return value is -1 if decreasing [from] leads to the shortest travel
  /// distance,  1 if increasing from leads to the shortest travel distance.
  static double _rotationDirection(double from, double to) {
    final a = to - from;
    final b = to - from + 360.0;
    final c = to - from - 360.0;

    final aAbs = a.abs();
    final bAbs = b.abs();
    final cAbs = c.abs();

    if (aAbs <= bAbs && aAbs <= cAbs) {
      return a >= 0.0 ? 1 : -1;
    } else if (bAbs <= aAbs && bAbs <= cAbs) {
      return b >= 0.0 ? 1 : -1;
    } else {
      return c >= 0.0 ? 1 : -1;
    }
  }
}
