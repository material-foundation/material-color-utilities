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
  'surfaceDark': MaterialDynamicColors.surfaceDark,
  'surfaceLight': MaterialDynamicColors.surfaceLight,
  'surfaceSub2': MaterialDynamicColors.surfaceSub2,
  'surfaceSub1': MaterialDynamicColors.surfaceSub1,
  'surfaceContainer': MaterialDynamicColors.surfaceContainer,
  'surfaceAdd1': MaterialDynamicColors.surfaceAdd1,
  'surfaceAdd2': MaterialDynamicColors.surfaceAdd2,
  'onSurface': MaterialDynamicColors.onSurface,
  'surfaceVariant': MaterialDynamicColors.surfaceVariant,
  'onSurfaceVariant': MaterialDynamicColors.onSurfaceVariant,
  'surfaceInverse': MaterialDynamicColors.surfaceInverse,
  'onSurfaceInverse': MaterialDynamicColors.onSurfaceInverse,
  'outline': MaterialDynamicColors.outline,
  'outlineVariant': MaterialDynamicColors.outlineVariant,
  'shadow': MaterialDynamicColors.shadow,
  'scrim': MaterialDynamicColors.scrim,
  'surfaceTint': MaterialDynamicColors.surfaceTint,
  'primary': MaterialDynamicColors.primary,
  'onPrimary': MaterialDynamicColors.onPrimary,
  'primaryContainer': MaterialDynamicColors.primaryContainer,
  'onPrimaryContainer': MaterialDynamicColors.onPrimaryContainer,
  'primaryInverse': MaterialDynamicColors.primaryInverse,
  'onPrimaryInverse': MaterialDynamicColors.onPrimaryInverse,
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
  _Pair('onSurfaceInverse', 'surfaceInverse'),
  _Pair('onPrimaryInverse', 'primaryInverse'),
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
      MaterialDynamicColors.surfaceInverse.getArgb(SchemeContent(
          sourceColorHct: Hct.fromInt(0xFF0000FF),
          isDark: false,
          contrastLevel: 0.0)),
      equals(0xFF464652),
    );
    expect(
      MaterialDynamicColors.primaryInverse.getArgb(SchemeContent(
          sourceColorHct: Hct.fromInt(0xFFFF0000),
          isDark: false,
          contrastLevel: -0.5)),
      equals(0xFFFF8C7A),
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
}
