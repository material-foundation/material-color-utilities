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

import 'package:material_color_utilities/dynamiccolor/dynamic_color.dart';
import 'package:material_color_utilities/dynamiccolor/tone_delta_constraint.dart';
import 'package:material_color_utilities/scheme/dynamic_scheme.dart';

/// Tokens, or named colors, in the Material Design system.
class MaterialDynamicColors {
  static const double contentAccentToneDelta = 15.0;
  static DynamicColor highestSurface(DynamicScheme s) {
    return s.isDark ? surfaceLight : surfaceDark;
  }

  static DynamicColor background = DynamicColor.fromPalette(
    palette: (s) => s.neutralPalette,
    tone: (s) => s.isDark ? 6 : 98,
  );

  static DynamicColor onBackground = DynamicColor.fromPalette(
    palette: (s) => s.neutralPalette,
    tone: (s) => s.isDark ? 90 : 10,
    background: (_) => background,
  );

  static DynamicColor surface = DynamicColor.fromPalette(
    palette: (s) => s.neutralPalette,
    tone: (s) => s.isDark ? 6 : 98,
  );

  static DynamicColor surfaceDark = DynamicColor.fromPalette(
    palette: (s) => s.neutralPalette,
    tone: (s) => s.isDark ? 6 : 87,
  );

  static DynamicColor surfaceLight = DynamicColor.fromPalette(
    palette: (s) => s.neutralPalette,
    tone: (s) => s.isDark ? 24 : 98,
  );

  static DynamicColor surfaceSub2 = DynamicColor.fromPalette(
    palette: (s) => s.neutralPalette,
    tone: (s) => s.isDark ? 4 : 100,
  );

  static DynamicColor surfaceSub1 = DynamicColor.fromPalette(
    palette: (s) => s.neutralPalette,
    tone: (s) => s.isDark ? 10 : 96,
  );

  static DynamicColor surfaceContainer = DynamicColor.fromPalette(
    palette: (s) => s.neutralPalette,
    tone: (s) => s.isDark ? 12 : 94,
  );

  static DynamicColor surfaceAdd1 = DynamicColor.fromPalette(
    palette: (s) => s.neutralPalette,
    tone: (s) => s.isDark ? 17 : 92,
  );

  static DynamicColor surfaceAdd2 = DynamicColor.fromPalette(
    palette: (s) => s.neutralPalette,
    tone: (s) => s.isDark ? 22 : 90,
  );

  static DynamicColor onSurface = DynamicColor.fromPalette(
    palette: (s) => s.neutralPalette,
    tone: (s) => s.isDark ? 90 : 10,
    background: (s) => highestSurface(s),
  );

  static DynamicColor surfaceVariant = DynamicColor.fromPalette(
    palette: (s) => s.neutralVariantPalette,
    tone: (s) => s.isDark ? 30 : 90,
  );

  static DynamicColor onSurfaceVariant = DynamicColor.fromPalette(
    palette: (s) => s.neutralVariantPalette,
    tone: (s) => s.isDark ? 80 : 30,
    background: (s) => surfaceVariant,
  );

  static DynamicColor outline = DynamicColor.fromPalette(
    palette: (s) => s.neutralVariantPalette,
    tone: (s) => 50,
    background: (s) => highestSurface(s),
  );

  static DynamicColor primary = DynamicColor.fromPalette(
    palette: (s) => s.primaryPalette,
    tone: (s) => s.isDark ? 80 : 40,
    background: (s) => highestSurface(s),
    toneDeltaConstraint: (s) => ToneDeltaConstraint(
      delta: contentAccentToneDelta,
      keepAway: primaryContainer,
      keepAwayPolarity: s.isDark ? TonePolarity.darker : TonePolarity.lighter,
    ),
  );

  static DynamicColor onPrimary = DynamicColor.fromPalette(
    palette: (s) => s.primaryPalette,
    tone: (s) => s.isDark ? 20 : 100,
    background: (s) => primary,
  );

  static DynamicColor primaryContainer = DynamicColor.fromPalette(
    palette: (s) => s.primaryPalette,
    tone: (s) => s.isDark ? 30 : 90,
    background: (s) => highestSurface(s),
  );

  static DynamicColor onPrimaryContainer = DynamicColor.fromPalette(
    palette: (s) => s.primaryPalette,
    tone: (s) => s.isDark ? 90 : 10,
    background: (s) => primaryContainer,
  );

  static DynamicColor secondary = DynamicColor.fromPalette(
    palette: (s) => s.secondaryPalette,
    tone: (s) => s.isDark ? 80 : 40,
    background: (s) => highestSurface(s),
    toneDeltaConstraint: (s) => ToneDeltaConstraint(
      delta: contentAccentToneDelta,
      keepAway: secondaryContainer,
      keepAwayPolarity: s.isDark ? TonePolarity.darker : TonePolarity.lighter,
    ),
  );

  static DynamicColor onSecondary = DynamicColor.fromPalette(
    palette: (s) => s.secondaryPalette,
    tone: (s) => s.isDark ? 20 : 100,
    background: (s) => secondary,
  );

  static DynamicColor secondaryContainer = DynamicColor.fromPalette(
    palette: (s) => s.secondaryPalette,
    tone: (s) => s.isDark ? 30 : 90,
    background: (s) => highestSurface(s),
  );

  static DynamicColor onSecondaryContainer = DynamicColor.fromPalette(
    palette: (s) => s.secondaryPalette,
    tone: (s) => s.isDark ? 90 : 10,
    background: (s) => secondaryContainer,
  );

  static DynamicColor tertiary = DynamicColor.fromPalette(
    palette: (s) => s.tertiaryPalette,
    tone: (s) => s.isDark ? 80 : 40,
    background: (s) => highestSurface(s),
    toneDeltaConstraint: (s) => ToneDeltaConstraint(
      delta: contentAccentToneDelta,
      keepAway: tertiaryContainer,
      keepAwayPolarity: s.isDark ? TonePolarity.darker : TonePolarity.lighter,
    ),
  );

  static DynamicColor onTertiary = DynamicColor.fromPalette(
    palette: (s) => s.tertiaryPalette,
    tone: (s) => s.isDark ? 20 : 100,
    background: (s) => tertiary,
  );

  static DynamicColor tertiaryContainer = DynamicColor.fromPalette(
    palette: (s) => s.tertiaryPalette,
    tone: (s) => s.isDark ? 30 : 90,
    background: (s) => highestSurface(s),
  );

  static DynamicColor onTertiaryContainer = DynamicColor.fromPalette(
    palette: (s) => s.tertiaryPalette,
    tone: (s) => s.isDark ? 90 : 10,
    background: (s) => tertiaryContainer,
  );

  static DynamicColor error = DynamicColor.fromPalette(
    palette: (s) => s.errorPalette,
    tone: (s) => s.isDark ? 80 : 40,
    background: (s) => highestSurface(s),
    toneDeltaConstraint: (s) => ToneDeltaConstraint(
      delta: contentAccentToneDelta,
      keepAway: errorContainer,
      keepAwayPolarity: s.isDark ? TonePolarity.darker : TonePolarity.lighter,
    ),
  );

  static DynamicColor onError = DynamicColor.fromPalette(
    palette: (s) => s.errorPalette,
    tone: (s) => s.isDark ? 20 : 100,
    background: (s) => error,
  );

  static DynamicColor errorContainer = DynamicColor.fromPalette(
    palette: (s) => s.errorPalette,
    tone: (s) => s.isDark ? 30 : 90,
    background: (s) => highestSurface(s),
  );

  static DynamicColor onErrorContainer = DynamicColor.fromPalette(
    palette: (s) => s.errorPalette,
    tone: (s) => s.isDark ? 90 : 10,
    background: (s) => errorContainer,
  );
}
