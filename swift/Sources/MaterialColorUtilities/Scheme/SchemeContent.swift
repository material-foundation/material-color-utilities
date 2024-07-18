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

/// A scheme that places the source color in [Scheme.primaryContainer].
///
/// Primary Container is the source color, adjusted for color relativity.
/// It maintains constant appearance in light mode and dark mode.
/// This adds ~5 tone in light mode, and subtracts ~5 tone in dark mode.
///
/// Tertiary Container is an analogous color, specifically, the analog of a
/// color wheel divided into 6, and the precise analog is the one found by
/// increasing hue. It also maintains constant appearance.
public class SchemeContent: DynamicScheme {
  public convenience init(sourceColorHct: Hct, isDark: Bool, contrastLevel: Double) {
    let palettes = CorePalettesContent(sourceColorHct: sourceColorHct)
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
      variant: .content,
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

/// Use [SchemeContentProvider] when you need to create multiple [SchemeContent] from the same
/// source color.
///
/// This provider reduces overlapped computation by reusing tonal palettes.
public struct SchemeContentProvider: DynamicSchemeProvider {
  private let sourceColorHct: Hct
  private let palettes: CorePalettes

  public init(sourceColorHct: Hct) {
    self.sourceColorHct = sourceColorHct
    self.palettes = CorePalettesContent(sourceColorHct: sourceColorHct)
  }

  public func scheme(isDark: Bool, contrastLevel: Double) -> DynamicScheme {
    SchemeContent(
      sourceColorHct: sourceColorHct,
      palettes: palettes,
      isDark: isDark,
      contrastLevel: contrastLevel)
  }
}

/// Core palettes of [SchemeContent].
struct CorePalettesContent: CorePalettes {
  let primary: TonalPalette
  let secondary: TonalPalette
  let tertiary: TonalPalette
  let neutral: TonalPalette
  let neutralVariant: TonalPalette

  init(sourceColorHct: Hct) {
    self.primary = TonalPalette.of(sourceColorHct.hue, sourceColorHct.chroma)
    self.secondary = TonalPalette.of(
      sourceColorHct.hue,
      max(sourceColorHct.chroma - 32, sourceColorHct.chroma * 0.5)
    )
    self.tertiary = TonalPalette.fromHct(
      DislikeAnalyzer.fixIfDisliked(
        TemperatureCache(sourceColorHct)
          .analogous(count: 3, divisions: 6)
          .last!
      )
    )
    self.neutral = TonalPalette.of(sourceColorHct.hue, sourceColorHct.chroma / 8)
    self.neutralVariant = TonalPalette.of(sourceColorHct.hue, (sourceColorHct.chroma / 8) + 4)
  }
}
