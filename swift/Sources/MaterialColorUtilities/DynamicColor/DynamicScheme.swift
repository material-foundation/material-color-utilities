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
public class DynamicScheme: Equatable, Hashable {
  /// The source color of the theme as an ARGB integer.
  public let sourceColorArgb: Int

  /// The source color of the theme in HCT.
  public let sourceColorHct: Hct

  /// The variant, or style, of the theme.
  public let variant: Variant

  /// Whether or not the scheme is in 'dark mode' or 'light mode'.
  public let isDark: Bool

  /// Value from -1 to 1. -1 represents minimum contrast, 0 represents
  /// standard (i.e. the design as spec'd), and 1 represents maximum contrast.
  public let contrastLevel: Double

  /// Given a tone, produces a color. Hue and chroma of the color are specified
  /// in the design specification of the variant. Usually colorful.
  public let primaryPalette: TonalPalette

  /// Given a tone, produces a color. Hue and chroma of the color are specified
  /// in the design specification of the variant. Usually less colorful.
  public let secondaryPalette: TonalPalette

  /// Given a tone, produces a color. Hue and chroma of the color are specified
  /// in the design specification of the variant. Usually a different hue from
  /// primary and colorful.
  public let tertiaryPalette: TonalPalette

  /// Given a tone, produces a color. Hue and chroma of the color are specified
  /// in the design specification of the variant. Usually not colorful at all,
  /// intended for background & surface colors.
  public let neutralPalette: TonalPalette

  /// Given a tone, produces a color. Hue and chroma of the color are specified
  /// in the design specification of the variant. Usually not colorful, but
  /// slightly more colorful than Neutral. Intended for backgrounds & surfaces.
  public let neutralVariantPalette: TonalPalette

  /// Given a tone, produces a reddish, colorful, color.
  let errorPalette: TonalPalette

  public init(
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

  public static func getRotatedHue(_ sourceColor: Hct, _ hues: [Double], _ rotations: [Double])
    -> Double
  {
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

  public static func == (lhs: DynamicScheme, rhs: DynamicScheme) -> Bool {
    return type(of: lhs) == type(of: rhs) && lhs.isEqual(to: rhs)
  }

  public func hash(into hasher: inout Hasher) {
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

  public var primaryPaletteKeyColor: Int {
    MaterialDynamicColors.primaryPaletteKeyColor.getArgb(self)
  }
  public var secondaryPaletteKeyColor: Int {
    MaterialDynamicColors.secondaryPaletteKeyColor.getArgb(self)
  }
  public var tertiaryPaletteKeyColor: Int {
    MaterialDynamicColors.tertiaryPaletteKeyColor.getArgb(self)
  }
  public var neutralPaletteKeyColor: Int {
    MaterialDynamicColors.neutralPaletteKeyColor.getArgb(self)
  }
  public var neutralVariantPaletteKeyColor: Int {
    MaterialDynamicColors.neutralVariantPaletteKeyColor.getArgb(self)
  }
  public var background: Int {
    MaterialDynamicColors.background.getArgb(self)
  }
  public var onBackground: Int {
    MaterialDynamicColors.onBackground.getArgb(self)
  }
  public var surface: Int {
    MaterialDynamicColors.surface.getArgb(self)
  }
  public var surfaceDim: Int {
    MaterialDynamicColors.surfaceDim.getArgb(self)
  }
  public var surfaceBright: Int {
    MaterialDynamicColors.surfaceBright.getArgb(self)
  }
  public var surfaceContainerLowest: Int {
    MaterialDynamicColors.surfaceContainerLowest.getArgb(self)
  }
  public var surfaceContainerLow: Int {
    MaterialDynamicColors.surfaceContainerLow.getArgb(self)
  }
  public var surfaceContainer: Int {
    MaterialDynamicColors.surfaceContainer.getArgb(self)
  }
  public var surfaceContainerHigh: Int {
    MaterialDynamicColors.surfaceContainerHigh.getArgb(self)
  }
  public var surfaceContainerHighest: Int {
    MaterialDynamicColors.surfaceContainerHighest.getArgb(self)
  }
  public var onSurface: Int {
    MaterialDynamicColors.onSurface.getArgb(self)
  }
  public var surfaceVariant: Int {
    MaterialDynamicColors.surfaceVariant.getArgb(self)
  }
  public var onSurfaceVariant: Int {
    MaterialDynamicColors.onSurfaceVariant.getArgb(self)
  }
  public var inverseSurface: Int {
    MaterialDynamicColors.inverseSurface.getArgb(self)
  }
  public var inverseOnSurface: Int {
    MaterialDynamicColors.inverseOnSurface.getArgb(self)
  }
  public var outline: Int {
    MaterialDynamicColors.outline.getArgb(self)
  }
  public var outlineVariant: Int {
    MaterialDynamicColors.outlineVariant.getArgb(self)
  }
  public var shadow: Int {
    MaterialDynamicColors.shadow.getArgb(self)
  }
  public var scrim: Int {
    MaterialDynamicColors.scrim.getArgb(self)
  }
  public var surfaceTint: Int {
    MaterialDynamicColors.surfaceTint.getArgb(self)
  }
  public var primary: Int {
    MaterialDynamicColors.primary.getArgb(self)
  }
  public var onPrimary: Int {
    MaterialDynamicColors.onPrimary.getArgb(self)
  }
  public var primaryContainer: Int {
    MaterialDynamicColors.primaryContainer.getArgb(self)
  }
  public var onPrimaryContainer: Int {
    MaterialDynamicColors.onPrimaryContainer.getArgb(self)
  }
  public var inversePrimary: Int {
    MaterialDynamicColors.inversePrimary.getArgb(self)
  }
  public var secondary: Int {
    MaterialDynamicColors.secondary.getArgb(self)
  }
  public var onSecondary: Int {
    MaterialDynamicColors.onSecondary.getArgb(self)
  }
  public var secondaryContainer: Int {
    MaterialDynamicColors.secondaryContainer.getArgb(self)
  }
  public var onSecondaryContainer: Int {
    MaterialDynamicColors.onSecondaryContainer.getArgb(self)
  }
  public var tertiary: Int {
    MaterialDynamicColors.tertiary.getArgb(self)
  }
  public var onTertiary: Int {
    MaterialDynamicColors.onTertiary.getArgb(self)
  }
  public var tertiaryContainer: Int {
    MaterialDynamicColors.tertiaryContainer.getArgb(self)
  }
  public var onTertiaryContainer: Int {
    MaterialDynamicColors.onTertiaryContainer.getArgb(self)
  }
  public var error: Int {
    MaterialDynamicColors.error.getArgb(self)
  }
  public var onError: Int {
    MaterialDynamicColors.onError.getArgb(self)
  }
  public var errorContainer: Int {
    MaterialDynamicColors.errorContainer.getArgb(self)
  }
  public var onErrorContainer: Int {
    MaterialDynamicColors.onErrorContainer.getArgb(self)
  }
  public var primaryFixed: Int {
    MaterialDynamicColors.primaryFixed.getArgb(self)
  }
  public var primaryFixedDim: Int {
    MaterialDynamicColors.primaryFixedDim.getArgb(self)
  }
  public var onPrimaryFixed: Int {
    MaterialDynamicColors.onPrimaryFixed.getArgb(self)
  }
  public var onPrimaryFixedVariant: Int {
    MaterialDynamicColors.onPrimaryFixedVariant.getArgb(self)
  }
  public var secondaryFixed: Int {
    MaterialDynamicColors.secondaryFixed.getArgb(self)
  }
  public var secondaryFixedDim: Int {
    MaterialDynamicColors.secondaryFixedDim.getArgb(self)
  }
  public var onSecondaryFixed: Int {
    MaterialDynamicColors.onSecondaryFixed.getArgb(self)
  }
  public var onSecondaryFixedVariant: Int {
    MaterialDynamicColors.onSecondaryFixedVariant.getArgb(self)
  }
  public var tertiaryFixed: Int {
    MaterialDynamicColors.tertiaryFixed.getArgb(self)
  }
  public var tertiaryFixedDim: Int {
    MaterialDynamicColors.tertiaryFixedDim.getArgb(self)
  }
  public var onTertiaryFixed: Int {
    MaterialDynamicColors.onTertiaryFixed.getArgb(self)
  }
  public var onTertiaryFixedVariant: Int {
    MaterialDynamicColors.onTertiaryFixedVariant.getArgb(self)
  }
}
