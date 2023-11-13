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
import 'package:material_color_utilities/dynamiccolor/dynamic_scheme.dart';
import 'package:material_color_utilities/dynamiccolor/variant.dart';
import 'package:material_color_utilities/hct/hct.dart';
import 'package:material_color_utilities/palettes/tonal_palette.dart';
import 'package:material_color_utilities/utils/math_utils.dart';

/// A Dynamic Color theme that is intentionally detached from the input color.
class SchemeExpressive extends DynamicScheme {
  /// Hues used at breakpoints such that designers can specify a hue rotation
  /// that occurs at a given break point.
  static final hues = <double>[0, 21, 51, 121, 151, 191, 271, 321, 360];

  /// Hue rotations of the Secondary [TonalPalette], corresponding to the
  /// breakpoints in [hues].
  static final secondaryRotations = <double>[
    45,
    95,
    45,
    20,
    45,
    90,
    45,
    45,
    45
  ];

  /// Hue rotations of the Tertiary [TonalPalette], corresponding to the
  /// breakpoints in [hues].
  static final tertiaryRotations = <double>[
    120,
    120,
    20,
    45,
    20,
    15,
    20,
    120,
    120
  ];

  SchemeExpressive({
    required Hct sourceColorHct,
    required super.isDark,
    required super.contrastLevel,
  }) : super(
          sourceColorArgb: sourceColorHct.toInt(),
          variant: Variant.expressive,
          primaryPalette: TonalPalette.of(
            MathUtils.sanitizeDegreesDouble(sourceColorHct.hue + 240.0),
            40.0,
          ),
          secondaryPalette: TonalPalette.of(
            DynamicScheme.getRotatedHue(
                sourceColorHct, hues, secondaryRotations),
            24.0,
          ),
          tertiaryPalette: TonalPalette.of(
            DynamicScheme.getRotatedHue(
                sourceColorHct, hues, tertiaryRotations),
            32.0,
          ),
          neutralPalette: TonalPalette.of(sourceColorHct.hue + 15.0, 8.0),
          neutralVariantPalette:
              TonalPalette.of(sourceColorHct.hue + 15.0, 12.0),
        );
}
