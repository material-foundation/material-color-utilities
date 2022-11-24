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
import 'package:material_color_utilities/palettes/tonal_palette.dart';
import 'package:material_color_utilities/hct/hct.dart';
import 'package:material_color_utilities/utils/math_utils.dart';
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
}
