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

/// Constructed by a set of values representing the current UI state (such as
/// whether or not its dark theme, what the theme style is, etc.), and
/// provides a set of [TonalPalette]s that can create colors that fit in
/// with the theme style. Used by [DynamicColor] to resolve into a color.
class DynamicScheme: Equatable, Hashable {
  /// The source color of the theme as an ARGB integer.
  let sourceColorArgb: Int

  /// The source color of the theme in HCT.
  let sourceColorHct: Hct

  /// The variant, or style, of the theme.
  let variant: Variant

  /// Whether or not the scheme is in 'dark mode' or 'light mode'.
  let isDark: Bool

  /// Value from -1 to 1. -1 represents minimum contrast, 0 represents
  /// standard (i.e. the design as spec'd), and 1 represents maximum contrast.
  let contrastLevel: Double

  /// Given a tone, produces a color. Hue and chroma of the color are specified
  /// in the design specification of the variant. Usually colorful.
  let primaryPalette: TonalPalette

  /// Given a tone, produces a color. Hue and chroma of the color are specified
  /// in the design specification of the variant. Usually less colorful.
  let secondaryPalette: TonalPalette

  /// Given a tone, produces a color. Hue and chroma of the color are specified
  /// in the design specification of the variant. Usually a different hue from
  /// primary and colorful.
  let tertiaryPalette: TonalPalette

  /// Given a tone, produces a color. Hue and chroma of the color are specified
  /// in the design specification of the variant. Usually not colorful at all,
  /// intended for background & surface colors.
  let neutralPalette: TonalPalette

  /// Given a tone, produces a color. Hue and chroma of the color are specified
  /// in the design specification of the variant. Usually not colorful, but
  /// slightly more colorful than Neutral. Intended for backgrounds & surfaces.
  let neutralVariantPalette: TonalPalette

  /// Given a tone, produces a reddish, colorful, color.
  let errorPalette: TonalPalette

  init(
    sourceColorArgb: Int, sourceColorHct: Hct? = nil, variant: Variant, isDark: Bool,
    contrastLevel: Double = 0, primaryPalette: TonalPalette, secondaryPalette: TonalPalette,
    tertiaryPalette: TonalPalette, neutralPalette: TonalPalette,
    neutralVariantPalette: TonalPalette, errorPalette: TonalPalette? = nil
  ) {
    self.sourceColorArgb = sourceColorArgb
    self.sourceColorHct = sourceColorHct ?? Hct.fromInt(sourceColorArgb)
    self.variant = variant
    self.isDark = isDark
    self.contrastLevel = contrastLevel
    self.primaryPalette = primaryPalette
    self.secondaryPalette = secondaryPalette
    self.tertiaryPalette = tertiaryPalette
    self.neutralPalette = neutralPalette
    self.neutralVariantPalette = neutralVariantPalette
    self.errorPalette = errorPalette ?? TonalPalette.of(25.0, 84.0)
  }

  static func getRotatedHue(_ sourceColor: Hct, _ hues: [Double], _ rotations: [Double]) -> Double {
    let sourceHue = sourceColor.hue
    assert(hues.count == rotations.count)
    if rotations.count == 1 {
      return MathUtils.sanitizeDegreesDouble(sourceColor.hue + rotations[0])
    }
    let size = hues.count
    var i = 0
    while i <= (size - 2) {
      let thisHue = hues[i]
      let nextHue = hues[i + 1]
      if thisHue < sourceHue && sourceHue < nextHue {
        return MathUtils.sanitizeDegreesDouble(sourceHue + rotations[i])
      }
      i += 1
    }
    // If this statement executes, something is wrong, there should have been a rotation
    // found using the arrays.
    return sourceHue
  }

  func isEqual(to other: DynamicScheme) -> Bool {
    return sourceColorArgb == other.sourceColorArgb
      && sourceColorHct == other.sourceColorHct
      && variant == other.variant
      && isDark == other.isDark
      && contrastLevel == other.contrastLevel
      && primaryPalette == other.primaryPalette
      && secondaryPalette == other.secondaryPalette
      && tertiaryPalette == other.tertiaryPalette
      && neutralPalette == other.neutralPalette
      && neutralVariantPalette == other.neutralVariantPalette
      && errorPalette == other.errorPalette
  }

  static func == (lhs: DynamicScheme, rhs: DynamicScheme) -> Bool {
    return type(of: lhs) == type(of: rhs) && lhs.isEqual(to: rhs)
  }

  func hash(into hasher: inout Hasher) {
    hasher.combine(sourceColorArgb)
    hasher.combine(sourceColorHct)
    hasher.combine(variant)
    hasher.combine(isDark)
    hasher.combine(contrastLevel)
    hasher.combine(primaryPalette)
    hasher.combine(secondaryPalette)
    hasher.combine(tertiaryPalette)
    hasher.combine(neutralPalette)
    hasher.combine(neutralVariantPalette)
    hasher.combine(errorPalette)
  }
}
