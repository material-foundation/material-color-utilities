/*
 * Copyright 2021 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package blend;

import static java.lang.Math.min;

import hct.Cam16;
import hct.Hct;
import utils.ColorUtils;
import utils.MathUtils;

/** Functions for blending in HCT and CAM16. */
public final class Blend {
  private static final double HARMONIZE_MAX_DEGREES = 15.0;
  private static final double HARMONIZE_PERCENTAGE = 0.5;

  private Blend() {}

  /**
   * Blend the design color's HCT hue towards the key color's HCT hue, in a way that leaves the
   * original color recognizable and recognizably shifted towards the key color.
   *
   * @param designColor ARGB representation of an arbitrary color.
   * @param sourceColor ARGB representation of the main theme color.
   * @return The design color with a hue shifted towards the system's color, a slightly
   *     warmer/cooler variant of the design color's hue.
   */
  public static int harmonize(int designColor, int sourceColor) {
    Hct fromHct = Hct.fromInt(designColor);
    Hct toHct = Hct.fromInt(sourceColor);
    double differenceDegrees = MathUtils.differenceDegrees(fromHct.getHue(), toHct.getHue());
    double rotationDegrees = min(differenceDegrees * HARMONIZE_PERCENTAGE, HARMONIZE_MAX_DEGREES);
    double outputHue =
        MathUtils.sanitizeDegreesDouble(
            fromHct.getHue()
                + rotationDegrees * rotationDirection(fromHct.getHue(), toHct.getHue()));
    return Hct.from(outputHue, fromHct.getChroma(), fromHct.getTone()).toInt();
  }

  /**
   * Blends hue from one color into another. The chroma and tone of the original color are
   * maintained.
   *
   * @param from ARGB representation of color
   * @param to ARGB representation of color
   * @param amount how much blending to perform; 0.0 >= and <= 1.0
   * @return from, with a hue blended towards to. Chroma and tone are constant.
   */
  public static int blendHctHue(int from, int to, double amount) {
    int ucs = blendCam16Ucs(from, to, amount);
    Cam16 ucsCam = Cam16.fromInt(ucs);
    Cam16 fromCam = Cam16.fromInt(from);
    return Hct.from(ucsCam.getHue(), fromCam.getChroma(), ColorUtils.lstarFromArgb(from)).toInt();
  }

  /**
   * Blend in CAM16-UCS space.
   *
   * @param from ARGB representation of color
   * @param to ARGB representation of color
   * @param amount how much blending to perform; 0.0 >= and <= 1.0
   * @return from, blended towards to. Hue, chroma, and tone will change.
   */
  public static int blendCam16Ucs(int from, int to, double amount) {
    Cam16 fromCam = Cam16.fromInt(from);
    Cam16 toCam = Cam16.fromInt(to);

    double aJ = fromCam.getJStar();
    double aA = fromCam.getAStar();
    double aB = fromCam.getBStar();

    double bJ = toCam.getJStar();
    double bA = toCam.getAStar();
    double bB = toCam.getBStar();

    double j = aJ + (bJ - aJ) * amount;
    double a = aA + (bA - aA) * amount;
    double b = aB + (bB - aB) * amount;

    Cam16 blended = Cam16.fromUcs(j, a, b);
    return blended.getInt();
  }

  /**
   * Sign of direction change needed to travel from one angle to another.
   *
   * @param from The angle travel starts from, in degrees.
   * @param to The angle travel ends at, in degrees.
   * @return -1 if decreasing from leads to the shortest travel distance, 1 if increasing from leads
   *     to the shortest travel distance.
   */
  private static double rotationDirection(double from, double to) {
    double a = to - from;
    double b = to - from + 360.0;
    double c = to - from - 360.0;

    double aAbs = Math.abs(a);
    double bAbs = Math.abs(b);
    double cAbs = Math.abs(c);

    if (aAbs <= bAbs && aAbs <= cAbs) {
      return a >= 0.0 ? 1 : -1;
    } else if (bAbs <= aAbs && bAbs <= cAbs) {
      return b >= 0.0 ? 1 : -1;
    } else {
      return c >= 0.0 ? 1 : -1;
    }
  }
}
