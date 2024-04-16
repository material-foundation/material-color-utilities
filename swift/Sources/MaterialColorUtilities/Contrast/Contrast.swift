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

/// Utility methods for calculating contrast given two colors, or calculating a
/// color given one color and a contrast ratio.
///
/// Contrast ratio is calculated using XYZ's Y. When linearized to match human
/// perception, Y becomes HCT's tone and L*a*b*'s' L*. Informally, this is the
/// lightness of a color.
///
/// Methods refer to tone, T in the the HCT color space.
/// Tone is equivalent to L* in the L*a*b* color space, or L in the LCH color
/// space.
public class Contrast {
  /// Returns a contrast ratio, which ranges from 1 to 21.
  /// [toneA] Tone between 0 and 100. Values outside will be clamped.
  /// [toneB] Tone between 0 and 100. Values outside will be clamped.
  public static func ratioOfTones(_ toneA: Double, _ toneB: Double) -> Double {
    let toneA = MathUtils.clampDouble(0, 100, toneA)
    let toneB = MathUtils.clampDouble(0, 100, toneB)
    return ratioOfYs(ColorUtils.yFromLstar(toneA), ColorUtils.yFromLstar(toneB))
  }

  static private func ratioOfYs(_ y1: Double, _ y2: Double) -> Double {
    let lighter = y1 > y2 ? y1 : y2
    let darker = lighter == y2 ? y1 : y2
    return (lighter + 5.0) / (darker + 5.0)
  }

  /// Returns a tone >= [tone] that ensures [ratio].
  /// Return value is between 0 and 100.
  /// Returns -1 if [ratio] cannot be achieved with [tone].
  ///
  /// [tone] Tone return value must contrast with.
  /// Range is 0 to 100. Invalid values will result in -1 being returned.
  /// [ratio] Contrast ratio of return value and [tone].
  /// Range is 1 to 21, invalid values have undefined behavior.
  public static func lighter(tone: Double, ratio: Double) -> Double {
    if tone < 0 || tone > 100 {
      return -1
    }

    let darkY = ColorUtils.yFromLstar(tone)
    let lightY = ratio * (darkY + 5.0) - 5.0
    let realContrast = ratioOfYs(lightY, darkY)
    let delta = abs(realContrast - ratio)
    if realContrast < ratio && delta > 0.04 {
      return -1
    }

    // Ensure gamut mapping, which requires a 'range' on tone, will still result
    // the correct ratio by darkening slightly.
    let returnValue = ColorUtils.lstarFromY(lightY) + 0.4
    if returnValue < 0 || returnValue > 100 {
      return -1
    }
    return returnValue
  }

  /// Returns a tone <= [tone] that ensures [ratio].
  /// Return value is between 0 and 100.
  /// Returns -1 if [ratio] cannot be achieved with [tone].
  ///
  /// [tone] Tone return value must contrast with.
  /// Range is 0 to 100. Invalid values will result in -1 being returned.
  /// [ratio] Contrast ratio of return value and [tone].
  /// Range is 1 to 21, invalid values have undefined behavior.
  public static func darker(tone: Double, ratio: Double) -> Double {
    if tone < 0 || tone > 100 {
      return -1
    }

    let lightY = ColorUtils.yFromLstar(tone)
    let darkY = ((lightY + 5.0) / ratio) - 5.0
    let realContrast = ratioOfYs(lightY, darkY)

    let delta = abs(realContrast - ratio)
    if realContrast < ratio && delta > 0.04 {
      return -1
    }

    // Ensure gamut mapping, which requires a 'range' on tone, will still result
    // the correct ratio by darkening slightly.
    let returnValue = ColorUtils.lstarFromY(darkY) - 0.4
    if returnValue < 0 || returnValue > 100 {
      return -1
    }
    return returnValue
  }

  /// Returns a tone >= [tone] that ensures [ratio].
  /// Return value is between 0 and 100.
  /// Returns 100 if [ratio] cannot be achieved with [tone].
  ///
  /// This method is unsafe because the returned value is guaranteed to be in
  /// bounds for tone, i.e. between 0 and 100. However, that value may not reach
  /// the [ratio] with [tone]. For example, there is no color lighter than T100.
  ///
  /// [tone] Tone return value must contrast with.
  /// Range is 0 to 100. Invalid values will result in 100 being returned.
  /// [ratio] Desired contrast ratio of return value and tone parameter.
  /// Range is 1 to 21, invalid values have undefined behavior.
  public static func lighterUnsafe(tone: Double, ratio: Double) -> Double {
    let lighterSafe = lighter(tone: tone, ratio: ratio)
    return lighterSafe < 0 ? 100 : lighterSafe
  }

  /// Returns a tone <= [tone] that ensures [ratio].
  /// Return value is between 0 and 100.
  /// Returns 0 if [ratio] cannot be achieved with [tone].
  ///
  /// This method is unsafe because the returned value is guaranteed to be in
  /// bounds for tone, i.e. between 0 and 100. However, that value may not reach
  /// the [ratio] with [tone]. For example, there is no color darker than T0.
  ///
  /// [tone] Tone return value must contrast with.
  /// Range is 0 to 100. Invalid values will result in 0 being returned.
  /// [ratio] Desired contrast ratio of return value and tone parameter.
  /// Range is 1 to 21, invalid values have undefined behavior.
  public static func darkerUnsafe(tone: Double, ratio: Double) -> Double {
    let darkerSafe = darker(tone: tone, ratio: ratio)
    return darkerSafe < 0 ? 0 : darkerSafe
  }
}
