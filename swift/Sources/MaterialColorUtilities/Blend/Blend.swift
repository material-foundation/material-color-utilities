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

/// Functions for blending in HCT and CAM16.
public class Blend {
  /// Blend the design color's HCT hue towards the key color's HCT
  /// hue, in a way that leaves the original color recognizable and
  /// recognizably shifted towards the key color.
  ///
  /// [designColor] ARGB representation of an arbitrary color.
  /// [sourceColor] ARGB representation of the main theme color.
  /// Returns The design color with a hue shifted towards the
  /// system's color, a slightly warmer/cooler variant of the design
  /// color's hue.
  public static func harmonize(_ designColor: Int, _ sourceColor: Int) -> Int {
    let fromHct = Hct.fromInt(designColor)
    let toHct = Hct.fromInt(sourceColor)
    let differenceDegrees = MathUtils.differenceDegrees(fromHct.hue, toHct.hue)
    let rotationDegrees = min(differenceDegrees * 0.5, 15.0)
    let outputHue = MathUtils.sanitizeDegreesDouble(
      fromHct.hue + rotationDegrees * MathUtils.rotationDirection(fromHct.hue, toHct.hue))
    return Hct.from(outputHue, fromHct.chroma, fromHct.tone).toInt()
  }

  /// Blends hue from one color into another. The chroma and tone of
  /// the original color are maintained.
  ///
  /// [from] ARGB representation of color
  /// [to] ARGB representation of color
  /// [amount] how much blending to perform; 0.0 >= and <= 1.0
  /// Returns from, with a hue blended towards to. Chroma and tone
  /// are constant.
  public static func hctHue(_ from: Int, _ to: Int, _ amount: Double) -> Int {
    let ucs = cam16Ucs(from, to, amount)
    let ucsCam = Cam16.fromInt(ucs)
    let fromCam = Cam16.fromInt(from)
    let blended = Hct.from(ucsCam.hue, fromCam.chroma, ColorUtils.lstarFromArgb(from))
    return blended.toInt()
  }

  /// Blend in CAM16-UCS space.
  ///
  /// [from] ARGB representation of color
  /// [to] ARGB representation of color
  /// [amount] how much blending to perform; 0.0 >= and <= 1.0
  /// Returns from, blended towards to. Hue, chroma, and tone will
  /// change.
  public static func cam16Ucs(_ from: Int, _ to: Int, _ amount: Double) -> Int {
    let fromCam = Cam16.fromInt(from)
    let toCam = Cam16.fromInt(to)
    let fromJ = fromCam.jstar
    let fromA = fromCam.astar
    let fromB = fromCam.bstar
    let toJ = toCam.jstar
    let toA = toCam.astar
    let toB = toCam.bstar
    let jstar = fromJ + (toJ - fromJ) * amount
    let astar = fromA + (toA - fromA) * amount
    let bstar = fromB + (toB - fromB) * amount
    return Cam16.fromUcs(jstar, astar, bstar).toInt()
  }
}
