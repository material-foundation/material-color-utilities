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

import 'package:material_color_utilities/contrast/contrast.dart';
import 'package:material_color_utilities/dynamiccolor/dynamic_color.dart';
import 'package:material_color_utilities/dynamiccolor/dynamic_scheme.dart';
import 'package:material_color_utilities/dynamiccolor/material_dynamic_colors.dart'
    show MaterialDynamicColors;
import 'package:material_color_utilities/dynamiccolor/src/contrast_curve.dart';
import 'package:material_color_utilities/dynamiccolor/src/tone_delta_pair.dart';
import 'package:material_color_utilities/dynamiccolor/variant.dart';
import 'package:material_color_utilities/hct/hct.dart';
import 'package:test/test.dart';

import 'utils/scheme_from_variant.dart';

abstract class _Constraint {
  /// Tests this constraint against [scheme], failing if constraint not met.
  void testAgainst(DynamicScheme scheme);
}

class _ContrastConstraint extends _Constraint {
  _ContrastConstraint(this.foreground, this.background,
      {required this.contrastCurve});
  final DynamicColor foreground;
  final DynamicColor background;
  final ContrastCurve contrastCurve;
  static const _contrastTolerance = 0.05;

  void testAgainst(DynamicScheme scheme) {
    final foregroundColor = foreground.getHct(scheme);
    final backgroundColor = background.getHct(scheme);
    final actualContrast =
        Contrast.ratioOfTones(foregroundColor.tone, backgroundColor.tone);
    final desiredContrast = contrastCurve.get(scheme.contrastLevel);

    if (desiredContrast <= 4.5) {
      // A requirement of <= 4.5 must be met (with tolerance)
      if (actualContrast < desiredContrast - _contrastTolerance) {
        fail('Dynamic scheme $scheme fails contrast constraint:\n'
            '${foreground.name} should have contrast at least ${desiredContrast} '
            'against ${background.name}, but has ${actualContrast}\n\n'
            'Foreground: ${foreground.name}\n'
            'Background: ${background.name}\n'
            'Scheme parameters:\n'
            '  Variant: ${scheme.variant}\n'
            '  Source color: ${scheme.sourceColorHct}\n'
            '  Brightness: ${scheme.isDark ? "dark" : "light"}\n'
            '  Contrast level: ${scheme.contrastLevel}\n'
            'Desired contrast: $desiredContrast\n'
            'Actual contrast: $actualContrast');
      }
    } else {
      if (actualContrast < 4.5 - _contrastTolerance) {
        fail('Dynamic scheme $scheme fails contrast constraint:\n'
            '${foreground.name} should have contrast at least 4.5 '
            'against ${background.name}, but has ${actualContrast}\n\n'
            'Foreground: ${foreground.name}\n'
            'Background: ${background.name}\n'
            'Scheme parameters:\n'
            '  Variant: ${scheme.variant}\n'
            '  Source color: ${scheme.sourceColorHct}\n'
            '  Brightness: ${scheme.isDark ? "dark" : "light"}\n'
            '  Contrast level: ${scheme.contrastLevel}\n'
            'Desired contrast: $desiredContrast\n'
            'Actual contrast: $actualContrast');
      } else if (actualContrast < desiredContrast - _contrastTolerance &&
          foregroundColor.tone != 100.0 &&
          foregroundColor.tone != 0.0) {
        fail('Dynamic scheme $scheme fails contrast constraint:\n'
            '${foreground.name} should have contrast at least ${desiredContrast} '
            'against ${background.name}, but has ${actualContrast}, and no color '
            'has a tone of 0 or 100\n\n'
            'Foreground: ${foreground.name}\n'
            'Background: ${background.name}\n'
            'Scheme parameters:\n'
            '  Variant: ${scheme.variant}\n'
            '  Source color: ${scheme.sourceColorHct}\n'
            '  Brightness: ${scheme.isDark ? "dark" : "light"}\n'
            '  Contrast level: ${scheme.contrastLevel}\n'
            'Desired contrast: $desiredContrast\n'
            'Actual contrast: $actualContrast');
      }
    }
  }
}

class _DeltaConstraint extends _Constraint {
  _DeltaConstraint(this.roleA, this.roleB,
      {required this.delta, required this.polarity});
  final DynamicColor roleA;
  final DynamicColor roleB;
  final double delta;
  final TonePolarity polarity;
  static const _deltaTolerance = 0.5;

  void testAgainst(DynamicScheme scheme) {
    final roleAColor = roleA.getHct(scheme);
    final roleBColor = roleB.getHct(scheme);
    final roleAShouldBeLighter = (polarity == TonePolarity.lighter) ||
        (polarity == TonePolarity.nearer && !scheme.isDark) ||
        (polarity == TonePolarity.farther && scheme.isDark);
    final lighterOrDarker = roleAShouldBeLighter ? 'lighter' : 'darker';

    final actualDelta = roleAShouldBeLighter
        ? roleAColor.tone - roleBColor.tone
        : roleBColor.tone - roleAColor.tone;
    if (actualDelta < delta - _deltaTolerance) {
      fail('Dynamic scheme $scheme fails delta constraint:\n'
          '${roleA.name} should be $delta $lighterOrDarker than ${roleB.name}, '
          'but they have tones ${roleAColor.tone} and ${roleBColor.tone}, respectively\n\n'
          'Role A: ${roleA.name}\n'
          'Role B: ${roleB.name}\n'
          'Scheme parameters:\n'
          '  Variant: ${scheme.variant}\n'
          '  Source color: ${scheme.sourceColorHct}\n'
          '  Brightness: ${scheme.isDark ? "dark" : "light"}\n'
          '  Contrast level: ${scheme.contrastLevel}\n'
          'Desired delta: $delta\n'
          'Actual delta: $actualDelta');
    }
  }
}

class _BackgroundConstraint extends _Constraint {
  _BackgroundConstraint(this.background);
  final DynamicColor background;

  void testAgainst(DynamicScheme scheme) {
    final color = background.getHct(scheme);
    if (color.tone >= 50.5 && color.tone < 59.5) {
      fail('Dynamic scheme $scheme fails background constraint:\n'
          '${background.name} has tone ${color.tone} which is in the '
          'forbidden zone 50.5 <= tone < 59.5\n\n'
          'Background: ${background.name}\n'
          'Scheme parameters:\n'
          '  Variant: ${scheme.variant}\n'
          '  Source color: ${scheme.sourceColorHct}\n'
          '  Brightness: ${scheme.isDark ? "dark" : "light"}\n'
          '  Contrast level: ${scheme.contrastLevel}\n'
          'Actual tone: ${color.tone}');
    }
  }
}

final constraints = [
  _ContrastConstraint(
      MaterialDynamicColors.onSurface, MaterialDynamicColors.surfaceDim,
      contrastCurve: ContrastCurve(4.5, 7, 11, 21)),
  _ContrastConstraint(
      MaterialDynamicColors.onSurface, MaterialDynamicColors.surfaceBright,
      contrastCurve: ContrastCurve(4.5, 7, 11, 21)),
  _ContrastConstraint(
      MaterialDynamicColors.primary, MaterialDynamicColors.surfaceDim,
      contrastCurve: ContrastCurve(3, 4.5, 7, 7)),
  _ContrastConstraint(
      MaterialDynamicColors.primary, MaterialDynamicColors.surfaceBright,
      contrastCurve: ContrastCurve(3, 4.5, 7, 7)),
  _ContrastConstraint(
      MaterialDynamicColors.secondary, MaterialDynamicColors.surfaceDim,
      contrastCurve: ContrastCurve(3, 4.5, 7, 7)),
  _ContrastConstraint(
      MaterialDynamicColors.secondary, MaterialDynamicColors.surfaceBright,
      contrastCurve: ContrastCurve(3, 4.5, 7, 7)),
  _ContrastConstraint(
      MaterialDynamicColors.tertiary, MaterialDynamicColors.surfaceDim,
      contrastCurve: ContrastCurve(3, 4.5, 7, 7)),
  _ContrastConstraint(
      MaterialDynamicColors.tertiary, MaterialDynamicColors.surfaceBright,
      contrastCurve: ContrastCurve(3, 4.5, 7, 7)),
  _ContrastConstraint(
      MaterialDynamicColors.error, MaterialDynamicColors.surfaceDim,
      contrastCurve: ContrastCurve(3, 4.5, 7, 7)),
  _ContrastConstraint(
      MaterialDynamicColors.error, MaterialDynamicColors.surfaceBright,
      contrastCurve: ContrastCurve(3, 4.5, 7, 7)),
  _ContrastConstraint(
      MaterialDynamicColors.onSurfaceVariant, MaterialDynamicColors.surfaceDim,
      contrastCurve: ContrastCurve(3, 4.5, 7, 11)),
  _ContrastConstraint(MaterialDynamicColors.onSurfaceVariant,
      MaterialDynamicColors.surfaceBright,
      contrastCurve: ContrastCurve(3, 4.5, 7, 11)),
  _ContrastConstraint(
      MaterialDynamicColors.outline, MaterialDynamicColors.surfaceDim,
      contrastCurve: ContrastCurve(1.5, 3, 4.5, 7)),
  _ContrastConstraint(
      MaterialDynamicColors.outline, MaterialDynamicColors.surfaceBright,
      contrastCurve: ContrastCurve(1.5, 3, 4.5, 7)),
  _ContrastConstraint(
      MaterialDynamicColors.primaryContainer, MaterialDynamicColors.surfaceDim,
      contrastCurve: ContrastCurve(0, 0, 3, 4.5)),
  _ContrastConstraint(MaterialDynamicColors.primaryContainer,
      MaterialDynamicColors.surfaceBright,
      contrastCurve: ContrastCurve(0, 0, 3, 4.5)),
  _ContrastConstraint(
      MaterialDynamicColors.primaryFixed, MaterialDynamicColors.surfaceDim,
      contrastCurve: ContrastCurve(0, 0, 3, 4.5)),
  _ContrastConstraint(
      MaterialDynamicColors.primaryFixed, MaterialDynamicColors.surfaceBright,
      contrastCurve: ContrastCurve(0, 0, 3, 4.5)),
  _ContrastConstraint(
      MaterialDynamicColors.primaryFixedDim, MaterialDynamicColors.surfaceDim,
      contrastCurve: ContrastCurve(0, 0, 3, 4.5)),
  _ContrastConstraint(MaterialDynamicColors.primaryFixedDim,
      MaterialDynamicColors.surfaceBright,
      contrastCurve: ContrastCurve(0, 0, 3, 4.5)),
  _ContrastConstraint(MaterialDynamicColors.secondaryContainer,
      MaterialDynamicColors.surfaceDim,
      contrastCurve: ContrastCurve(0, 0, 3, 4.5)),
  _ContrastConstraint(MaterialDynamicColors.secondaryContainer,
      MaterialDynamicColors.surfaceBright,
      contrastCurve: ContrastCurve(0, 0, 3, 4.5)),
  _ContrastConstraint(
      MaterialDynamicColors.secondaryFixed, MaterialDynamicColors.surfaceDim,
      contrastCurve: ContrastCurve(0, 0, 3, 4.5)),
  _ContrastConstraint(
      MaterialDynamicColors.secondaryFixed, MaterialDynamicColors.surfaceBright,
      contrastCurve: ContrastCurve(0, 0, 3, 4.5)),
  _ContrastConstraint(
      MaterialDynamicColors.secondaryFixedDim, MaterialDynamicColors.surfaceDim,
      contrastCurve: ContrastCurve(0, 0, 3, 4.5)),
  _ContrastConstraint(MaterialDynamicColors.secondaryFixedDim,
      MaterialDynamicColors.surfaceBright,
      contrastCurve: ContrastCurve(0, 0, 3, 4.5)),
  _ContrastConstraint(
      MaterialDynamicColors.tertiaryContainer, MaterialDynamicColors.surfaceDim,
      contrastCurve: ContrastCurve(0, 0, 3, 4.5)),
  _ContrastConstraint(MaterialDynamicColors.tertiaryContainer,
      MaterialDynamicColors.surfaceBright,
      contrastCurve: ContrastCurve(0, 0, 3, 4.5)),
  _ContrastConstraint(
      MaterialDynamicColors.tertiaryFixed, MaterialDynamicColors.surfaceDim,
      contrastCurve: ContrastCurve(0, 0, 3, 4.5)),
  _ContrastConstraint(
      MaterialDynamicColors.tertiaryFixed, MaterialDynamicColors.surfaceBright,
      contrastCurve: ContrastCurve(0, 0, 3, 4.5)),
  _ContrastConstraint(
      MaterialDynamicColors.tertiaryFixedDim, MaterialDynamicColors.surfaceDim,
      contrastCurve: ContrastCurve(0, 0, 3, 4.5)),
  _ContrastConstraint(MaterialDynamicColors.tertiaryFixedDim,
      MaterialDynamicColors.surfaceBright,
      contrastCurve: ContrastCurve(0, 0, 3, 4.5)),
  _ContrastConstraint(
      MaterialDynamicColors.errorContainer, MaterialDynamicColors.surfaceDim,
      contrastCurve: ContrastCurve(0, 0, 3, 4.5)),
  _ContrastConstraint(
      MaterialDynamicColors.errorContainer, MaterialDynamicColors.surfaceBright,
      contrastCurve: ContrastCurve(0, 0, 3, 4.5)),
  _ContrastConstraint(
      MaterialDynamicColors.outlineVariant, MaterialDynamicColors.surfaceDim,
      contrastCurve: ContrastCurve(0, 0, 3, 4.5)),
  _ContrastConstraint(
      MaterialDynamicColors.outlineVariant, MaterialDynamicColors.surfaceBright,
      contrastCurve: ContrastCurve(0, 0, 3, 4.5)),
  _ContrastConstraint(MaterialDynamicColors.inverseOnSurface,
      MaterialDynamicColors.inverseSurface,
      contrastCurve: ContrastCurve(4.5, 7, 11, 21)),
  _ContrastConstraint(MaterialDynamicColors.inversePrimary,
      MaterialDynamicColors.inverseSurface,
      contrastCurve: ContrastCurve(3, 4.5, 7, 7)),
  _ContrastConstraint(
      MaterialDynamicColors.onPrimary, MaterialDynamicColors.primary,
      contrastCurve: ContrastCurve(4.5, 7, 11, 21)),
  _ContrastConstraint(
      MaterialDynamicColors.onSecondary, MaterialDynamicColors.secondary,
      contrastCurve: ContrastCurve(4.5, 7, 11, 21)),
  _ContrastConstraint(
      MaterialDynamicColors.onTertiary, MaterialDynamicColors.tertiary,
      contrastCurve: ContrastCurve(4.5, 7, 11, 21)),
  _ContrastConstraint(
      MaterialDynamicColors.onError, MaterialDynamicColors.error,
      contrastCurve: ContrastCurve(4.5, 7, 11, 21)),
  _ContrastConstraint(MaterialDynamicColors.onPrimaryContainer,
      MaterialDynamicColors.primaryContainer,
      contrastCurve: ContrastCurve(4.5, 7, 11, 21)),
  _ContrastConstraint(MaterialDynamicColors.onSecondaryContainer,
      MaterialDynamicColors.secondaryContainer,
      contrastCurve: ContrastCurve(4.5, 7, 11, 21)),
  _ContrastConstraint(MaterialDynamicColors.onTertiaryContainer,
      MaterialDynamicColors.tertiaryContainer,
      contrastCurve: ContrastCurve(4.5, 7, 11, 21)),
  _ContrastConstraint(MaterialDynamicColors.onErrorContainer,
      MaterialDynamicColors.errorContainer,
      contrastCurve: ContrastCurve(4.5, 7, 11, 21)),
  _ContrastConstraint(
      MaterialDynamicColors.onPrimaryFixed, MaterialDynamicColors.primaryFixed,
      contrastCurve: ContrastCurve(4.5, 7, 11, 21)),
  _ContrastConstraint(MaterialDynamicColors.onPrimaryFixed,
      MaterialDynamicColors.primaryFixedDim,
      contrastCurve: ContrastCurve(4.5, 7, 11, 21)),
  _ContrastConstraint(MaterialDynamicColors.onSecondaryFixed,
      MaterialDynamicColors.secondaryFixed,
      contrastCurve: ContrastCurve(4.5, 7, 11, 21)),
  _ContrastConstraint(MaterialDynamicColors.onSecondaryFixed,
      MaterialDynamicColors.secondaryFixedDim,
      contrastCurve: ContrastCurve(4.5, 7, 11, 21)),
  _ContrastConstraint(MaterialDynamicColors.onTertiaryFixed,
      MaterialDynamicColors.tertiaryFixed,
      contrastCurve: ContrastCurve(4.5, 7, 11, 21)),
  _ContrastConstraint(MaterialDynamicColors.onTertiaryFixed,
      MaterialDynamicColors.tertiaryFixedDim,
      contrastCurve: ContrastCurve(4.5, 7, 11, 21)),
  _ContrastConstraint(MaterialDynamicColors.onPrimaryFixedVariant,
      MaterialDynamicColors.primaryFixed,
      contrastCurve: ContrastCurve(3, 4.5, 7, 11)),
  _ContrastConstraint(MaterialDynamicColors.onPrimaryFixedVariant,
      MaterialDynamicColors.primaryFixedDim,
      contrastCurve: ContrastCurve(3, 4.5, 7, 11)),
  _ContrastConstraint(MaterialDynamicColors.onSecondaryFixedVariant,
      MaterialDynamicColors.secondaryFixed,
      contrastCurve: ContrastCurve(3, 4.5, 7, 11)),
  _ContrastConstraint(MaterialDynamicColors.onSecondaryFixedVariant,
      MaterialDynamicColors.secondaryFixedDim,
      contrastCurve: ContrastCurve(3, 4.5, 7, 11)),
  _ContrastConstraint(MaterialDynamicColors.onTertiaryFixedVariant,
      MaterialDynamicColors.tertiaryFixed,
      contrastCurve: ContrastCurve(3, 4.5, 7, 11)),
  _ContrastConstraint(MaterialDynamicColors.onTertiaryFixedVariant,
      MaterialDynamicColors.tertiaryFixedDim,
      contrastCurve: ContrastCurve(3, 4.5, 7, 11)),
  _DeltaConstraint(
      MaterialDynamicColors.primary, MaterialDynamicColors.primaryContainer,
      delta: 10, polarity: TonePolarity.farther),
  _DeltaConstraint(
      MaterialDynamicColors.secondary, MaterialDynamicColors.secondaryContainer,
      delta: 10, polarity: TonePolarity.farther),
  _DeltaConstraint(
      MaterialDynamicColors.tertiary, MaterialDynamicColors.tertiaryContainer,
      delta: 10, polarity: TonePolarity.farther),
  _DeltaConstraint(
      MaterialDynamicColors.error, MaterialDynamicColors.errorContainer,
      delta: 10, polarity: TonePolarity.farther),
  _DeltaConstraint(
      MaterialDynamicColors.primaryFixedDim, MaterialDynamicColors.primaryFixed,
      delta: 10, polarity: TonePolarity.darker),
  _DeltaConstraint(MaterialDynamicColors.secondaryFixedDim,
      MaterialDynamicColors.secondaryFixed,
      delta: 10, polarity: TonePolarity.darker),
  _DeltaConstraint(MaterialDynamicColors.tertiaryFixedDim,
      MaterialDynamicColors.tertiaryFixed,
      delta: 10, polarity: TonePolarity.darker),
  _BackgroundConstraint(MaterialDynamicColors.background),
  _BackgroundConstraint(MaterialDynamicColors.error),
  _BackgroundConstraint(MaterialDynamicColors.errorContainer),
  _BackgroundConstraint(MaterialDynamicColors.primary),
  _BackgroundConstraint(MaterialDynamicColors.primaryContainer),
  _BackgroundConstraint(MaterialDynamicColors.primaryFixed),
  _BackgroundConstraint(MaterialDynamicColors.primaryFixedDim),
  _BackgroundConstraint(MaterialDynamicColors.secondary),
  _BackgroundConstraint(MaterialDynamicColors.secondaryContainer),
  _BackgroundConstraint(MaterialDynamicColors.secondaryFixed),
  _BackgroundConstraint(MaterialDynamicColors.secondaryFixedDim),
  _BackgroundConstraint(MaterialDynamicColors.surface),
  _BackgroundConstraint(MaterialDynamicColors.surfaceBright),
  _BackgroundConstraint(MaterialDynamicColors.surfaceContainer),
  _BackgroundConstraint(MaterialDynamicColors.surfaceContainerHigh),
  _BackgroundConstraint(MaterialDynamicColors.surfaceContainerHighest),
  _BackgroundConstraint(MaterialDynamicColors.surfaceContainerLow),
  _BackgroundConstraint(MaterialDynamicColors.surfaceContainerLowest),
  _BackgroundConstraint(MaterialDynamicColors.surfaceDim),
  _BackgroundConstraint(MaterialDynamicColors.surfaceTint),
  _BackgroundConstraint(MaterialDynamicColors.surfaceVariant),
  _BackgroundConstraint(MaterialDynamicColors.tertiary),
  _BackgroundConstraint(MaterialDynamicColors.tertiaryContainer),
  _BackgroundConstraint(MaterialDynamicColors.tertiaryFixed),
  _BackgroundConstraint(MaterialDynamicColors.tertiaryFixedDim),
];

void main() {
  group('scheme_correctness_test', () {
    for (final variant in Variant.values) {
      for (final contrastLevel in [-1.0, 0.0, 0.5, 1.0]) {
        // For each variant-contrast combination, tests across four
        // seed colors as well as two brightnesses.
        test('${variant.label}, ${contrastLevel}', () {
          for (final sourceColorArgb in [
            0xFF0000FF,
            0xFF00FF00,
            0xFFFFFF00,
            0xFFFF0000
          ]) {
            for (final isDark in [false, true]) {
              DynamicScheme s = schemeFromVariant(
                variant: variant,
                sourceColorHct: Hct.fromInt(sourceColorArgb),
                isDark: isDark,
                contrastLevel: contrastLevel,
              );
              // Ensures all constraints are satisfied.
              for (final constraint in constraints) {
                constraint.testAgainst(s);
              }
            }
          }
        });
      }
    }
  });
}
