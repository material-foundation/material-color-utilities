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

/// A Dynamic Color theme that is intentionally detached from the input color to offer an expressive
/// visual expression.
public class SchemeExpressive: DynamicScheme {
  public convenience init(sourceColorHct: Hct, isDark: Bool, contrastLevel: Double) {
    let palettes = CorePalettesExpressive(sourceColorHct: sourceColorHct)
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
      variant: .expressive,
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

/// Use [SchemeExpressiveProvider] when you need to create multiple [SchemeExpressive] from the same
/// source color.
///
/// This provider reduces overlapped computation by reusing core palettes.
public struct SchemeExpressiveProvider: DynamicSchemeProvider {
  private let sourceColorHct: Hct
  private let palettes: CorePalettes

  public init(sourceColorHct: Hct) {
    self.sourceColorHct = sourceColorHct
    self.palettes = CorePalettesExpressive(sourceColorHct: sourceColorHct)
  }

  public func scheme(isDark: Bool, contrastLevel: Double) -> DynamicScheme {
    SchemeExpressive(
      sourceColorHct: sourceColorHct,
      palettes: palettes,
      isDark: isDark,
      contrastLevel: contrastLevel
    )
  }
}

/// Core palettes of [SchemeExpressive].
private struct CorePalettesExpressive: CorePalettes {
  /// Hues used at breakpoints for hue rotation adjustments.
  private let hues: [Double] = [0, 21, 51, 121, 151, 191, 271, 321, 360]

  /// Hue rotations of the Secondary [TonalPalette] corresponding to the breakpoints in [hues].
  private let secondaryRotations: [Double] = [45, 95, 45, 20, 45, 90, 45, 45, 45]

  /// Hue rotations of the Tertiary [TonalPalette] corresponding to the breakpoints in [hues].
  private let tertiaryRotations: [Double] = [120, 120, 20, 45, 20, 15, 20, 120, 120]

  let primary: TonalPalette
  let secondary: TonalPalette
  let tertiary: TonalPalette
  let neutral: TonalPalette
  let neutralVariant: TonalPalette

  init(sourceColorHct: Hct) {
    self.primary = TonalPalette.of(
      MathUtils.sanitizeDegreesDouble(sourceColorHct.hue + 240.0),
      40.0
    )
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
    self.neutral = TonalPalette.of(sourceColorHct.hue + 15, 8.0)
    self.neutralVariant = TonalPalette.of(sourceColorHct.hue + 15, 12.0)
  }
}
