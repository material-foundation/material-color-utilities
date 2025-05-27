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

import 'package:material_color_utilities/dynamiccolor/dynamic_scheme.dart';
import 'package:material_color_utilities/dynamiccolor/variant.dart';
import 'package:material_color_utilities/hct/hct.dart';
import 'package:material_color_utilities/scheme/scheme_content.dart';
import 'package:material_color_utilities/scheme/scheme_expressive.dart';
import 'package:material_color_utilities/scheme/scheme_fidelity.dart';
import 'package:material_color_utilities/scheme/scheme_fruit_salad.dart';
import 'package:material_color_utilities/scheme/scheme_monochrome.dart';
import 'package:material_color_utilities/scheme/scheme_neutral.dart';
import 'package:material_color_utilities/scheme/scheme_rainbow.dart';
import 'package:material_color_utilities/scheme/scheme_tonal_spot.dart';
import 'package:material_color_utilities/scheme/scheme_vibrant.dart';

DynamicScheme schemeFromVariant({
  required Variant variant,
  required Hct sourceColorHct,
  required bool isDark,
  required double contrastLevel,
}) {
  return switch (variant) {
    Variant.content => SchemeContent(
      sourceColorHct: sourceColorHct,
      isDark: isDark,
      contrastLevel: contrastLevel,
    ),
    Variant.expressive => SchemeExpressive(
      sourceColorHct: sourceColorHct,
      isDark: isDark,
      contrastLevel: contrastLevel,
    ),
    Variant.fidelity => SchemeFidelity(
      sourceColorHct: sourceColorHct,
      isDark: isDark,
      contrastLevel: contrastLevel,
    ),
    Variant.fruitSalad => SchemeFruitSalad(
      sourceColorHct: sourceColorHct,
      isDark: isDark,
      contrastLevel: contrastLevel,
    ),
    Variant.monochrome => SchemeMonochrome(
      sourceColorHct: sourceColorHct,
      isDark: isDark,
      contrastLevel: contrastLevel,
    ),
    Variant.neutral => SchemeNeutral(
      sourceColorHct: sourceColorHct,
      isDark: isDark,
      contrastLevel: contrastLevel,
    ),
    Variant.rainbow => SchemeRainbow(
      sourceColorHct: sourceColorHct,
      isDark: isDark,
      contrastLevel: contrastLevel,
    ),
    Variant.tonalSpot => SchemeTonalSpot(
      sourceColorHct: sourceColorHct,
      isDark: isDark,
      contrastLevel: contrastLevel,
    ),
    Variant.vibrant => SchemeVibrant(
      sourceColorHct: sourceColorHct,
      isDark: isDark,
      contrastLevel: contrastLevel,
    ),
  };
}
