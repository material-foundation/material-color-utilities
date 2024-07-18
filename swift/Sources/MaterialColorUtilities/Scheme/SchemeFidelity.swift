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

/// A Dynamic Color theme that places the source color in [Scheme.primaryContainer].
///
/// Primary Container is the source color, adjusted for color relativity.
/// It maintains constant appearance in both light and dark mode by adjusting the source color's
/// tone by adding 5 tones in light mode and subtracting 5 tone in dark mode.
///
/// Tertiary Container is the complement to the source color, using [TemperatureCache]. It also
/// maintains constant appearance.
public class SchemeFidelity: DynamicScheme {
  public convenience init(sourceColorHct: Hct, isDark: Bool, contrastLevel: Double) {
    let palettes = CorePalettesFidelity(sourceColorHct: sourceColorHct)
    self.init(
      sourceColorHct: sourceColorHct,
      palettes: palettes,
      isDark: isDark,
      contrastLevel: contrastLevel
    )
  }

  fileprivate init(
    sourceColorHct: Hct, palettes: CorePalettes, isDark: Bool, contrastLevel: Double
  ) {
    super.init(
      sourceColorHct: sourceColorHct,
      variant: .fidelity,
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

/// Use [SchemeFidelityProvider] when you need to create multiple [SchemeFidelity] instances from
/// the same source color.
///
/// This provider reduces overlapped computation by reusing tonal palettes.
public struct SchemeFidelityProvider: DynamicSchemeProvider {
  private let sourceColorHct: Hct
  private let palettes: CorePalettes

  public init(sourceColorHct: Hct) {
    self.sourceColorHct = sourceColorHct
    self.palettes = CorePalettesFidelity(sourceColorHct: sourceColorHct)
  }

  public func scheme(isDark: Bool, contrastLevel: Double) -> DynamicScheme {
    SchemeFidelity(
      sourceColorHct: sourceColorHct,
      palettes: palettes,
      isDark: isDark,
      contrastLevel: contrastLevel
    )
  }
}

/// Core palettes of [SchemeFidelity].
private struct CorePalettesFidelity: CorePalettes {
  let primary: TonalPalette
  let secondary: TonalPalette
  let tertiary: TonalPalette
  let neutral: TonalPalette
  let neutralVariant: TonalPalette

  init(sourceColorHct: Hct) {
    self.primary = TonalPalette.of(sourceColorHct.hue, sourceColorHct.chroma)
    self.secondary = TonalPalette.of(
      sourceColorHct.hue,
      max(sourceColorHct.chroma - 32.0, sourceColorHct.chroma * 0.5)
    )
    self.tertiary = TonalPalette.fromHct(
      DislikeAnalyzer.fixIfDisliked(
        TemperatureCache(sourceColorHct).complement
      )
    )
    self.neutral = TonalPalette.of(sourceColorHct.hue, sourceColorHct.chroma / 8.0)
    self.neutralVariant = TonalPalette.of(sourceColorHct.hue, (sourceColorHct.chroma / 8.0) + 4.0)
  }
}
