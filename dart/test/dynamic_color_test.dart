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
  'onBackground': MaterialDynamicColors.onBackground,
  'surface': MaterialDynamicColors.surface,
  'surfaceDim': MaterialDynamicColors.surfaceDim,
  'surfaceBright': MaterialDynamicColors.surfaceBright,
  'surfaceContainerLowest': MaterialDynamicColors.surfaceContainerLowest,
  'surfaceContainerLow': MaterialDynamicColors.surfaceContainerLow,
  'surfaceContainer': MaterialDynamicColors.surfaceContainer,
  'surfaceContainerHigh': MaterialDynamicColors.surfaceContainerHigh,
  'surfaceContainerHighest': MaterialDynamicColors.surfaceContainerHighest,
  'onSurface': MaterialDynamicColors.onSurface,
  'surfaceVariant': MaterialDynamicColors.surfaceVariant,
  'onSurfaceVariant': MaterialDynamicColors.onSurfaceVariant,
  'inverseSurface': MaterialDynamicColors.inverseSurface,
  'inverseOnSurface': MaterialDynamicColors.inverseOnSurface,
  'outline': MaterialDynamicColors.outline,
  'outlineVariant': MaterialDynamicColors.outlineVariant,
  'shadow': MaterialDynamicColors.shadow,
  'scrim': MaterialDynamicColors.scrim,
  'surfaceTint': MaterialDynamicColors.surfaceTint,
  'primary': MaterialDynamicColors.primary,
  'onPrimary': MaterialDynamicColors.onPrimary,
  'primaryContainer': MaterialDynamicColors.primaryContainer,
  'onPrimaryContainer': MaterialDynamicColors.onPrimaryContainer,
  'inversePrimary': MaterialDynamicColors.inversePrimary,
  'secondary': MaterialDynamicColors.secondary,
  'onSecondary': MaterialDynamicColors.onSecondary,
  'secondaryContainer': MaterialDynamicColors.secondaryContainer,
  'onSecondaryContainer': MaterialDynamicColors.onSecondaryContainer,
  'tertiary': MaterialDynamicColors.tertiary,
  'onTertiary': MaterialDynamicColors.onTertiary,
  'tertiaryContainer': MaterialDynamicColors.tertiaryContainer,
  'onTertiaryContainer': MaterialDynamicColors.onTertiaryContainer,
  'error': MaterialDynamicColors.error,
  'onError': MaterialDynamicColors.onError,
  'errorContainer': MaterialDynamicColors.errorContainer,
  'onErrorContainer': MaterialDynamicColors.onErrorContainer,
};

final _textSurfacePairs = [
  _Pair('onPrimary', 'primary'),
  _Pair('onPrimaryContainer', 'primaryContainer'),
  _Pair('onSecondary', 'secondary'),
  _Pair('onSecondaryContainer', 'secondaryContainer'),
  _Pair('onTertiary', 'tertiary'),
  _Pair('onTertiaryContainer', 'tertiaryContainer'),
  _Pair('onError', 'error'),
  _Pair('onErrorContainer', 'errorContainer'),
  _Pair('onBackground', 'background'),
  _Pair('onSurfaceVariant', 'surfaceVariant'),
  _Pair('inverseOnSurface', 'inverseSurface'),
];

void main() {
  test('Values are correct', () {
    expect(
      MaterialDynamicColors.onPrimaryContainer.getArgb(SchemeFidelity(
        sourceColorHct: Hct.fromInt(0xFFFF0000),
        isDark: false,
        contrastLevel: 0.5,
      )),
      equals(0xFFFFE5E1),
    );
    expect(
      MaterialDynamicColors.onSecondaryContainer.getArgb(SchemeContent(
        sourceColorHct: Hct.fromInt(0xFF0000FF),
        isDark: false,
        contrastLevel: 0.5,
      )),
      equals(0xFFFFFCFF),
    );
    expect(
      MaterialDynamicColors.onTertiaryContainer.getArgb(SchemeContent(
        sourceColorHct: Hct.fromInt(0xFFFFFF00),
        isDark: true,
        contrastLevel: -0.5,
      )),
      equals(0xFF616600),
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
      equals(0xFFFF907F),
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
      closeTo(10.0, 1.0),
    );
    expect(
      MaterialDynamicColors.primaryFixedDim.getHct(scheme).tone,
      closeTo(20.0, 1.0),
    );
    expect(
      MaterialDynamicColors.onPrimaryFixed.getHct(scheme).tone,
      closeTo(90.0, 1.0),
    );
    expect(
      MaterialDynamicColors.onPrimaryFixedVariant.getHct(scheme).tone,
      closeTo(70.0, 1.0),
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
      closeTo(90.0, 1.0),
    );
    expect(
      MaterialDynamicColors.onTertiaryFixedVariant.getHct(scheme).tone,
      closeTo(70.0, 1.0),
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
      closeTo(100.0, 1.0),
    );
    expect(
      MaterialDynamicColors.primaryFixedDim.getHct(scheme).tone,
      closeTo(90.0, 1.0),
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
      closeTo(90.0, 1.0),
    );
    expect(
      MaterialDynamicColors.onTertiaryFixedVariant.getHct(scheme).tone,
      closeTo(70.0, 1.0),
    );
  });
}
