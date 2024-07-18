// Copyright 2023-2024 Google LLC
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

/// A Dynamic Color theme that maxes out colorfulness at each position in the
/// Primary [TonalPalette].
public class SchemeVibrant: DynamicScheme {
  public convenience init(sourceColorHct: Hct, isDark: Bool, contrastLevel: Double) {
    let palettes = CorePalettesVibrant(sourceColorHct: sourceColorHct)
    self.init(
      sourceColorHct: sourceColorHct,
      palettes: palettes,
      isDark: isDark,
      contrastLevel: contrastLevel)
  }

  fileprivate init(
    sourceColorHct: Hct, palettes: CorePalettes, isDark: Bool, contrastLevel: Double
  ) {
    super.init(
      sourceColorHct: sourceColorHct,
      variant: .vibrant,
      isDark: isDark,
      contrastLevel: contrastLevel,
      primaryPalette: palettes.primary,
      secondaryPalette: palettes.secondary,
      tertiaryPalette: palettes.tertiary,
      neutralPalette: palettes.neutral,
      neutralVariantPalette: palettes.neutralVariant
    )
  }
}

/// Use [SchemeVibrantProvider] when you need to create multiple [SchemeVibrant] from the same
/// source color.
///
/// This provider reduces overlapped computation by reusing tonal palettes.
public struct SchemeVibrantProvider: DynamicSchemeProvider {
  private let sourceColorHct: Hct
  private let palettes: CorePalettes

  public init(sourceColorHct: Hct) {
    self.sourceColorHct = sourceColorHct
    self.palettes = CorePalettesVibrant(sourceColorHct: sourceColorHct)
  }

  public func scheme(isDark: Bool, contrastLevel: Double) -> DynamicScheme {
    SchemeVibrant(
      sourceColorHct: sourceColorHct,
      palettes: palettes,
      isDark: isDark,
      contrastLevel: contrastLevel)
  }
}

/// Core palettes of [SchemeVibrant].
private struct CorePalettesVibrant: CorePalettes {
  let primary: TonalPalette
  let secondary: TonalPalette
  let tertiary: TonalPalette
  let neutral: TonalPalette
  let neutralVariant: TonalPalette

  /// Hues used at breakpoints such that designers can specify a hue rotation that occurs at a
  ///given break point.
  private let hues: [Double] = [0, 41, 61, 101, 131, 181, 251, 301, 360]

  /// Hue rotations of the Secondary [TonalPalette], corresponding to the breakpoints in [hues].
  private let secondaryRotations: [Double] = [
    18,
    15,
    10,
    12,
    15,
    18,
    15,
    12,
    12,
  ]

  /// Hue rotations of the Tertiary [TonalPalette], corresponding to the breakpoints in [hues].
  private let tertiaryRotations: [Double] = [35, 30, 20, 25, 30, 35, 30, 25, 25]

  init(sourceColorHct: Hct) {
    self.primary = TonalPalette.of(sourceColorHct.hue, 200.0)
    self.secondary = TonalPalette.of(
      DynamicScheme.getRotatedHue(
        sourceColorHct, hues, secondaryRotations),
      24.0
    )
    self.tertiary = TonalPalette.of(
      DynamicScheme.getRotatedHue(
        sourceColorHct, hues, tertiaryRotations),
      32.0
    )
    self.neutral = TonalPalette.of(sourceColorHct.hue, 10.0)
    self.neutralVariant = TonalPalette.of(sourceColorHct.hue, 12.0)
  }
}
