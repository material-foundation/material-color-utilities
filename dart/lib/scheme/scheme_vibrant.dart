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
import '../dynamiccolor/dynamic_scheme.dart';
import '../dynamiccolor/variant.dart';
import '../palettes/tonal_palette.dart';

/// A Dynamic Color theme that maxes out colorfulness at each position in the
/// Primary [TonalPalette].
class SchemeVibrant extends DynamicScheme {
  /// Hues used at breakpoints such that designers can specify a hue rotation
  /// that occurs at a given break point.
  static const _hues = <double>[0, 41, 61, 101, 131, 181, 251, 301, 360];

  /// Hue rotations of the Secondary [TonalPalette], corresponding to the
  /// breakpoints in [_hues].
  static const _secondaryRotations = <double>[
    18,
    15,
    10,
    12,
    15,
    18,
    15,
    12,
    12,
  ];

  /// Hue rotations of the Tertiary [TonalPalette], corresponding to the
  /// breakpoints in [_hues].
  static const _tertiaryRotations = <double>[
    35,
    30,
    20,
    25,
    30,
    35,
    30,
    25,
    25,
  ];

  SchemeVibrant({
    required super.sourceColorHct,
    required super.isDark,
    required super.contrastLevel,
  }) : super(
         variant: Variant.vibrant,
         primaryPalette: TonalPalette.of(sourceColorHct.hue, 200.0),
         secondaryPalette: TonalPalette.of(
           DynamicScheme.getRotatedHue(
             sourceColorHct,
             _hues,
             _secondaryRotations,
           ),
           24.0,
         ),
         tertiaryPalette: TonalPalette.of(
           DynamicScheme.getRotatedHue(
             sourceColorHct,
             _hues,
             _tertiaryRotations,
           ),
           32.0,
         ),
         neutralPalette: TonalPalette.of(sourceColorHct.hue, 10.0),
         neutralVariantPalette: TonalPalette.of(sourceColorHct.hue, 12.0),
       );
}
