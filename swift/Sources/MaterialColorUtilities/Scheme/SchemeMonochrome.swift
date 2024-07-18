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

/// A Dynamic Color theme that is grayscale.
public class SchemeMonochrome: DynamicScheme {
  public convenience init(sourceColorHct: Hct, isDark: Bool, contrastLevel: Double) {
    let palettes = CorePalettesMonochrome(sourceColorHct: sourceColorHct)
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
      variant: .monochrome,
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

/// Use [SchemeMonochromeProvider] when you need to create multiple [SchemeMonochrome] from the same
/// source color.
///
/// This provider reduces overlapped computation by reusing tonal palettes.
public struct SchemeMonochromeProvider: DynamicSchemeProvider {
  private let sourceColorHct: Hct
  private let palettes: CorePalettes

  public init(sourceColorHct: Hct) {
    self.sourceColorHct = sourceColorHct
    self.palettes = CorePalettesMonochrome(sourceColorHct: sourceColorHct)
  }

  public func scheme(isDark: Bool, contrastLevel: Double) -> DynamicScheme {
    SchemeMonochrome(
      sourceColorHct: sourceColorHct,
      palettes: palettes,
      isDark: isDark,
      contrastLevel: contrastLevel)
  }
}

/// Core palettes of [SchemeMonochrome].
private struct CorePalettesMonochrome: CorePalettes {
  let primary: TonalPalette
  let secondary: TonalPalette
  let tertiary: TonalPalette
  let neutral: TonalPalette
  let neutralVariant: TonalPalette

  init(sourceColorHct: Hct) {
    let zeroChromaPalette = TonalPalette.of(sourceColorHct.hue, 0.0)

    self.primary = zeroChromaPalette
    self.secondary = zeroChromaPalette
    self.tertiary = zeroChromaPalette
    self.neutral = zeroChromaPalette
    self.neutralVariant = zeroChromaPalette
  }
}
