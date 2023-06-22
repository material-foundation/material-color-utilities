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

import 'package:material_color_utilities/hct/hct.dart';
import 'package:material_color_utilities/contrast/contrast.dart';
import 'package:material_color_utilities/dynamiccolor/dynamic_color.dart';
import 'package:material_color_utilities/dynamiccolor/material_dynamic_colors.dart';
import 'package:material_color_utilities/scheme/scheme_content.dart';
import 'package:material_color_utilities/scheme/scheme_fidelity.dart';
import 'package:material_color_utilities/scheme/scheme_monochrome.dart';
import 'package:material_color_utilities/scheme/scheme_tonal_spot.dart';

import 'package:test/test.dart';

final seedColors = [
  Hct.fromInt(0xFFFF0000),
  Hct.fromInt(0xFFFFFF00),
  Hct.fromInt(0xFF00FF00),
  Hct.fromInt(0xFF0000FF),
];

final contrastLevels = [-1.0, -0.5, 0.0, 0.5, 1.0];

class _Pair {
  final String fgName;
  final String bgName;

  _Pair(this.fgName, this.bgName);
}

final red = Hct.fromInt(0xFFFF0000);

final _colors = <String, DynamicColor>{
  'background': MaterialDynamicColors.background,
  'on_background': MaterialDynamicColors.onBackground,
  'surface': MaterialDynamicColors.surface,
  'surface_dim': MaterialDynamicColors.surfaceDim,
  'surface_bright': MaterialDynamicColors.surfaceBright,
  'surface_container_lowest': MaterialDynamicColors.surfaceContainerLowest,
  'surface_container_low': MaterialDynamicColors.surfaceContainerLow,
  'surface_container': MaterialDynamicColors.surfaceContainer,
  'surface_container_high': MaterialDynamicColors.surfaceContainerHigh,
  'surface_container_highest': MaterialDynamicColors.surfaceContainerHighest,
  'on_surface': MaterialDynamicColors.onSurface,
  'surface_variant': MaterialDynamicColors.surfaceVariant,
  'on_surface_variant': MaterialDynamicColors.onSurfaceVariant,
  'inverse_surface': MaterialDynamicColors.inverseSurface,
  'inverse_on_surface': MaterialDynamicColors.inverseOnSurface,
  'outline': MaterialDynamicColors.outline,
  'outline_variant': MaterialDynamicColors.outlineVariant,
  'shadow': MaterialDynamicColors.shadow,
  'scrim': MaterialDynamicColors.scrim,
  'surface_tint': MaterialDynamicColors.surfaceTint,
  'primary': MaterialDynamicColors.primary,
  'on_primary': MaterialDynamicColors.onPrimary,
  'primary_container': MaterialDynamicColors.primaryContainer,
  'on_primary_container': MaterialDynamicColors.onPrimaryContainer,
  'inverse_primary': MaterialDynamicColors.inversePrimary,
  'secondary': MaterialDynamicColors.secondary,
  'on_secondary': MaterialDynamicColors.onSecondary,
  'secondary_container': MaterialDynamicColors.secondaryContainer,
  'on_secondary_container': MaterialDynamicColors.onSecondaryContainer,
  'tertiary': MaterialDynamicColors.tertiary,
  'on_tertiary': MaterialDynamicColors.onTertiary,
  'tertiary_container': MaterialDynamicColors.tertiaryContainer,
  'on_tertiary_container': MaterialDynamicColors.onTertiaryContainer,
  'error': MaterialDynamicColors.error,
  'on_error': MaterialDynamicColors.onError,
  'error_container': MaterialDynamicColors.errorContainer,
  'on_error_container': MaterialDynamicColors.onErrorContainer,
};

final _textSurfacePairs = [
  _Pair('on_primary', 'primary'),
  _Pair('on_primary_container', 'primary_container'),
  _Pair('on_secondary', 'secondary'),
  _Pair('on_secondary_container', 'secondary_container'),
  _Pair('on_tertiary', 'tertiary'),
  _Pair('on_tertiary_container', 'tertiary_container'),
  _Pair('on_error', 'error'),
  _Pair('on_error_container', 'error_container'),
  _Pair('on_background', 'background'),
  _Pair('on_surface_variant', 'surface_bright'),
  _Pair('on_surface_variant', 'surface_dim'),
  _Pair('inverse_on_surface', 'inverse_surface'),
];

void main() {
  test('Values are correct', () {
    expect(
      MaterialDynamicColors.onPrimaryContainer.getArgb(SchemeFidelity(
        sourceColorHct: Hct.fromInt(0xFFFF0000),
        isDark: false,
        contrastLevel: 0.5,
      )),
      equals(0xFFFFFFFF),
    );
    expect(
      MaterialDynamicColors.onSecondaryContainer.getArgb(SchemeContent(
        sourceColorHct: Hct.fromInt(0xFF0000FF),
        isDark: false,
        contrastLevel: 0.5,
      )),
      equals(0xFFFFFFFF),
    );
    expect(
      MaterialDynamicColors.onTertiaryContainer.getArgb(SchemeContent(
        sourceColorHct: Hct.fromInt(0xFFFFFF00),
        isDark: true,
        contrastLevel: -0.5,
      )),
      equals(0xffbac040),
    );
    expect(
      MaterialDynamicColors.inverseSurface.getArgb(SchemeContent(
          sourceColorHct: Hct.fromInt(0xFF0000FF),
          isDark: false,
          contrastLevel: 0.0)),
      equals(0xFF2F2F3B),
    );
    expect(
      MaterialDynamicColors.inversePrimary.getArgb(SchemeContent(
          sourceColorHct: Hct.fromInt(0xFFFF0000),
          isDark: false,
          contrastLevel: -0.5)),
      equals(0xffff422f),
    );
    expect(
      MaterialDynamicColors.outlineVariant.getArgb(SchemeContent(
          sourceColorHct: Hct.fromInt(0xFFFFFF00),
          isDark: true,
          contrastLevel: 0.0)),
      equals(0xFF484831),
    );
  });

  // Parametric test, ensuring that dynamic schemes respect contrast
  // between text-surface pairs.

  for (final color in seedColors) {
    for (final contrastLevel in contrastLevels) {
      for (final isDark in [false, true]) {
        for (final scheme in [
          SchemeContent(
              sourceColorHct: color,
              isDark: isDark,
              contrastLevel: contrastLevel),
          SchemeMonochrome(
              sourceColorHct: color,
              isDark: isDark,
              contrastLevel: contrastLevel),
          SchemeTonalSpot(
              sourceColorHct: color,
              isDark: isDark,
              contrastLevel: contrastLevel),
          SchemeFidelity(
              sourceColorHct: color,
              isDark: isDark,
              contrastLevel: contrastLevel),
        ]) {
          test(
              'Scheme: $scheme; Seed color: $color; '
              'Contrast level: $contrastLevel; Dark: $isDark', () {
            for (final pair in _textSurfacePairs) {
              // Expect that each text-surface pair has a
              // minimum contrast of 4.5 (unreduced contrast), or 3.0
              // (reduced contrast).
              final fgName = pair.fgName;
              final bgName = pair.bgName;
              final foregroundTone = _colors[fgName]!.getHct(scheme).tone;
              final backgroundTone = _colors[bgName]!.getHct(scheme).tone;
              final contrast =
                  Contrast.ratioOfTones(foregroundTone, backgroundTone);

              final minimumRequirement = contrastLevel >= 0.0 ? 4.5 : 3.0;

              expect(
                contrast,
                greaterThanOrEqualTo(minimumRequirement),
                reason: 'Contrast $contrast is too low between '
                    'foreground ($fgName; $foregroundTone) and '
                    'background ($bgName; $backgroundTone)',
              );
            }
          });
        }
      }
    }
  }

  // Tests for fixed colors.
  test('fixed colors in non-monochrome schemes', () {
    final scheme = SchemeTonalSpot(
      sourceColorHct: Hct.fromInt(0xFFFF0000),
      isDark: true,
      contrastLevel: 0.0,
    );

    expect(
      MaterialDynamicColors.primaryFixed.getHct(scheme).tone,
      closeTo(90.0, 1.0),
    );
    expect(
      MaterialDynamicColors.primaryFixedDim.getHct(scheme).tone,
      closeTo(80.0, 1.0),
    );
    expect(
      MaterialDynamicColors.onPrimaryFixed.getHct(scheme).tone,
      closeTo(10.0, 1.0),
    );
    expect(
      MaterialDynamicColors.onPrimaryFixedVariant.getHct(scheme).tone,
      closeTo(30.0, 1.0),
    );
    expect(
      MaterialDynamicColors.secondaryFixed.getHct(scheme).tone,
      closeTo(90.0, 1.0),
    );
    expect(
      MaterialDynamicColors.secondaryFixedDim.getHct(scheme).tone,
      closeTo(80.0, 1.0),
    );
    expect(
      MaterialDynamicColors.onSecondaryFixed.getHct(scheme).tone,
      closeTo(10.0, 1.0),
    );
    expect(
      MaterialDynamicColors.onSecondaryFixedVariant.getHct(scheme).tone,
      closeTo(30.0, 1.0),
    );
    expect(
      MaterialDynamicColors.tertiaryFixed.getHct(scheme).tone,
      closeTo(90.0, 1.0),
    );
    expect(
      MaterialDynamicColors.tertiaryFixedDim.getHct(scheme).tone,
      closeTo(80.0, 1.0),
    );
    expect(
      MaterialDynamicColors.onTertiaryFixed.getHct(scheme).tone,
      closeTo(10.0, 1.0),
    );
    expect(
      MaterialDynamicColors.onTertiaryFixedVariant.getHct(scheme).tone,
      closeTo(30.0, 1.0),
    );
  });

  test('fixed colors in light monochrome schemes', () {
    final scheme = SchemeMonochrome(
      sourceColorHct: Hct.fromInt(0xFFFF0000),
      isDark: false,
      contrastLevel: 0.0,
    );

    expect(
      MaterialDynamicColors.primaryFixed.getHct(scheme).tone,
      closeTo(40.0, 1.0),
    );
    expect(
      MaterialDynamicColors.primaryFixedDim.getHct(scheme).tone,
      closeTo(30.0, 1.0),
    );
    expect(
      MaterialDynamicColors.onPrimaryFixed.getHct(scheme).tone,
      closeTo(100.0, 1.0),
    );
    expect(
      MaterialDynamicColors.onPrimaryFixedVariant.getHct(scheme).tone,
      closeTo(90.0, 1.0),
    );
    expect(
      MaterialDynamicColors.secondaryFixed.getHct(scheme).tone,
      closeTo(80.0, 1.0),
    );
    expect(
      MaterialDynamicColors.secondaryFixedDim.getHct(scheme).tone,
      closeTo(70.0, 1.0),
    );
    expect(
      MaterialDynamicColors.onSecondaryFixed.getHct(scheme).tone,
      closeTo(10.0, 1.0),
    );
    expect(
      MaterialDynamicColors.onSecondaryFixedVariant.getHct(scheme).tone,
      closeTo(25.0, 1.0),
    );
    expect(
      MaterialDynamicColors.tertiaryFixed.getHct(scheme).tone,
      closeTo(40.0, 1.0),
    );
    expect(
      MaterialDynamicColors.tertiaryFixedDim.getHct(scheme).tone,
      closeTo(30.0, 1.0),
    );
    expect(
      MaterialDynamicColors.onTertiaryFixed.getHct(scheme).tone,
      closeTo(100.0, 1.0),
    );
    expect(
      MaterialDynamicColors.onTertiaryFixedVariant.getHct(scheme).tone,
      closeTo(90.0, 1.0),
    );
  });

  test('fixed colors in dark monochrome schemes', () {
    final scheme = SchemeMonochrome(
      sourceColorHct: Hct.fromInt(0xFFFF0000),
      isDark: true,
      contrastLevel: 0.0,
    );

    expect(
      MaterialDynamicColors.primaryFixed.getHct(scheme).tone,
      closeTo(40.0, 1.0),
    );
    expect(
      MaterialDynamicColors.primaryFixedDim.getHct(scheme).tone,
      closeTo(30.0, 1.0),
    );
    expect(
      MaterialDynamicColors.onPrimaryFixed.getHct(scheme).tone,
      closeTo(100.0, 1.0),
    );
    expect(
      MaterialDynamicColors.onPrimaryFixedVariant.getHct(scheme).tone,
      closeTo(90.0, 1.0),
    );
    expect(
      MaterialDynamicColors.secondaryFixed.getHct(scheme).tone,
      closeTo(80.0, 1.0),
    );
    expect(
      MaterialDynamicColors.secondaryFixedDim.getHct(scheme).tone,
      closeTo(70.0, 1.0),
    );
    expect(
      MaterialDynamicColors.onSecondaryFixed.getHct(scheme).tone,
      closeTo(10.0, 1.0),
    );
    expect(
      MaterialDynamicColors.onSecondaryFixedVariant.getHct(scheme).tone,
      closeTo(25.0, 1.0),
    );
    expect(
      MaterialDynamicColors.tertiaryFixed.getHct(scheme).tone,
      closeTo(40.0, 1.0),
    );
    expect(
      MaterialDynamicColors.tertiaryFixedDim.getHct(scheme).tone,
      closeTo(30.0, 1.0),
    );
    expect(
      MaterialDynamicColors.onTertiaryFixed.getHct(scheme).tone,
      closeTo(100.0, 1.0),
    );
    expect(
      MaterialDynamicColors.onTertiaryFixedVariant.getHct(scheme).tone,
      closeTo(90.0, 1.0),
    );
  });
}
