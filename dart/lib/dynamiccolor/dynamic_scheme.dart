// Copyright 2022 Google LLC
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
import 'package:material_color_utilities/hct/hct.dart';
import 'package:material_color_utilities/palettes/tonal_palette.dart';
import 'package:material_color_utilities/utils/math_utils.dart';

import 'dynamic_color.dart';
import 'material_dynamic_colors.dart';
import 'variant.dart';

/// Constructed by a set of values representing the current UI state (such as
/// whether or not its dark theme, what the theme style is, etc.), and
/// provides a set of [TonalPalette]s that can create colors that fit in
/// with the theme style. Used by [DynamicColor] to resolve into a color.
class DynamicScheme {
  /// The source color of the theme as an ARGB integer.
  final int sourceColorArgb;

  /// The source color of the theme in HCT.
  final Hct sourceColorHct;

  /// The variant, or style, of the theme.
  final Variant variant;

  /// Whether or not the scheme is in 'dark mode' or 'light mode'.
  final bool isDark;

  /// Value from -1 to 1. -1 represents minimum contrast, 0 represents
  /// standard (i.e. the design as spec'd), and 1 represents maximum contrast.
  final double contrastLevel;

  /// Given a tone, produces a color. Hue and chroma of the color are specified
  /// in the design specification of the variant. Usually colorful.
  final TonalPalette primaryPalette;

  /// Given a tone, produces a color. Hue and chroma of the color are specified
  /// in the design specification of the variant. Usually less colorful.
  final TonalPalette secondaryPalette;

  /// Given a tone, produces a color. Hue and chroma of the color are specified
  /// in the design specification of the variant. Usually a different hue from
  /// primary and colorful.
  final TonalPalette tertiaryPalette;

  /// Given a tone, produces a color. Hue and chroma of the color are specified
  /// in the design specification of the variant. Usually not colorful at all,
  /// intended for background & surface colors.
  final TonalPalette neutralPalette;

  /// Given a tone, produces a color. Hue and chroma of the color are specified
  /// in the design specification of the variant. Usually not colorful, but
  /// slightly more colorful than Neutral. Intended for backgrounds & surfaces.
  final TonalPalette neutralVariantPalette;

  /// Given a tone, produces a reddish, colorful, color.
  final TonalPalette errorPalette;

  DynamicScheme({
    required this.sourceColorArgb,
    required this.variant,
    this.contrastLevel = 0.0,
    required this.isDark,
    required this.primaryPalette,
    required this.secondaryPalette,
    required this.tertiaryPalette,
    required this.neutralPalette,
    required this.neutralVariantPalette,
  })  : sourceColorHct = Hct.fromInt(sourceColorArgb),
        errorPalette = TonalPalette.of(25.0, 84.0);

  static double getRotatedHue(
      Hct sourceColor, List<double> hues, List<double> rotations) {
    final sourceHue = sourceColor.hue;
    assert(hues.length == rotations.length);
    if (rotations.length == 1) {
      return MathUtils.sanitizeDegreesDouble(sourceColor.hue + rotations[0]);
    }
    final size = hues.length;
    for (var i = 0; i <= (size - 2); i++) {
      final thisHue = hues[i];
      final nextHue = hues[i + 1];
      if (thisHue < sourceHue && sourceHue < nextHue) {
        return MathUtils.sanitizeDegreesDouble(sourceHue + rotations[i]);
      }
    }
    // If this statement executes, something is wrong, there should have been a rotation
    // found using the arrays.
    return sourceHue;
  }

  Hct getHct(DynamicColor dynamicColor) => dynamicColor.getHct(this);
  int getArgb(DynamicColor dynamicColor) => dynamicColor.getArgb(this);

  // Getters.
  int get primaryPaletteKeyColor =>
      getArgb(MaterialDynamicColors.primaryPaletteKeyColor);
  int get secondaryPaletteKeyColor =>
      getArgb(MaterialDynamicColors.secondaryPaletteKeyColor);
  int get tertiaryPaletteKeyColor =>
      getArgb(MaterialDynamicColors.tertiaryPaletteKeyColor);
  int get neutralPaletteKeyColor =>
      getArgb(MaterialDynamicColors.neutralPaletteKeyColor);
  int get neutralVariantPaletteKeyColor =>
      getArgb(MaterialDynamicColors.neutralVariantPaletteKeyColor);
  int get background => getArgb(MaterialDynamicColors.background);
  int get onBackground => getArgb(MaterialDynamicColors.onBackground);
  int get surface => getArgb(MaterialDynamicColors.surface);
  int get surfaceDim => getArgb(MaterialDynamicColors.surfaceDim);
  int get surfaceBright => getArgb(MaterialDynamicColors.surfaceBright);
  int get surfaceContainerLowest =>
      getArgb(MaterialDynamicColors.surfaceContainerLowest);
  int get surfaceContainerLow =>
      getArgb(MaterialDynamicColors.surfaceContainerLow);
  int get surfaceContainer => getArgb(MaterialDynamicColors.surfaceContainer);
  int get surfaceContainerHigh =>
      getArgb(MaterialDynamicColors.surfaceContainerHigh);
  int get surfaceContainerHighest =>
      getArgb(MaterialDynamicColors.surfaceContainerHighest);
  int get onSurface => getArgb(MaterialDynamicColors.onSurface);
  int get surfaceVariant => getArgb(MaterialDynamicColors.surfaceVariant);
  int get onSurfaceVariant => getArgb(MaterialDynamicColors.onSurfaceVariant);
  int get inverseSurface => getArgb(MaterialDynamicColors.inverseSurface);
  int get inverseOnSurface => getArgb(MaterialDynamicColors.inverseOnSurface);
  int get outline => getArgb(MaterialDynamicColors.outline);
  int get outlineVariant => getArgb(MaterialDynamicColors.outlineVariant);
  int get shadow => getArgb(MaterialDynamicColors.shadow);
  int get scrim => getArgb(MaterialDynamicColors.scrim);
  int get surfaceTint => getArgb(MaterialDynamicColors.surfaceTint);
  int get primary => getArgb(MaterialDynamicColors.primary);
  int get onPrimary => getArgb(MaterialDynamicColors.onPrimary);
  int get primaryContainer => getArgb(MaterialDynamicColors.primaryContainer);
  int get onPrimaryContainer =>
      getArgb(MaterialDynamicColors.onPrimaryContainer);
  int get inversePrimary => getArgb(MaterialDynamicColors.inversePrimary);
  int get secondary => getArgb(MaterialDynamicColors.secondary);
  int get onSecondary => getArgb(MaterialDynamicColors.onSecondary);
  int get secondaryContainer =>
      getArgb(MaterialDynamicColors.secondaryContainer);
  int get onSecondaryContainer =>
      getArgb(MaterialDynamicColors.onSecondaryContainer);
  int get tertiary => getArgb(MaterialDynamicColors.tertiary);
  int get onTertiary => getArgb(MaterialDynamicColors.onTertiary);
  int get tertiaryContainer => getArgb(MaterialDynamicColors.tertiaryContainer);
  int get onTertiaryContainer =>
      getArgb(MaterialDynamicColors.onTertiaryContainer);
  int get error => getArgb(MaterialDynamicColors.error);
  int get onError => getArgb(MaterialDynamicColors.onError);
  int get errorContainer => getArgb(MaterialDynamicColors.errorContainer);
  int get onErrorContainer => getArgb(MaterialDynamicColors.onErrorContainer);
  int get primaryFixed => getArgb(MaterialDynamicColors.primaryFixed);
  int get primaryFixedDim => getArgb(MaterialDynamicColors.primaryFixedDim);
  int get onPrimaryFixed => getArgb(MaterialDynamicColors.onPrimaryFixed);
  int get onPrimaryFixedVariant =>
      getArgb(MaterialDynamicColors.onPrimaryFixedVariant);
  int get secondaryFixed => getArgb(MaterialDynamicColors.secondaryFixed);
  int get secondaryFixedDim => getArgb(MaterialDynamicColors.secondaryFixedDim);
  int get onSecondaryFixed => getArgb(MaterialDynamicColors.onSecondaryFixed);
  int get onSecondaryFixedVariant =>
      getArgb(MaterialDynamicColors.onSecondaryFixedVariant);
  int get tertiaryFixed => getArgb(MaterialDynamicColors.tertiaryFixed);
  int get tertiaryFixedDim => getArgb(MaterialDynamicColors.tertiaryFixedDim);
  int get onTertiaryFixed => getArgb(MaterialDynamicColors.onTertiaryFixed);
  int get onTertiaryFixedVariant =>
      getArgb(MaterialDynamicColors.onTertiaryFixedVariant);
}
