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

import 'dart:math' as math;
import 'package:material_color_utilities/dislike/dislike_analyzer.dart';
import 'package:material_color_utilities/dynamiccolor/dynamic_color.dart';
import 'package:material_color_utilities/dynamiccolor/tone_delta_constraint.dart';
import 'package:material_color_utilities/hct/hct.dart';
import 'package:material_color_utilities/hct/viewing_conditions.dart';
import 'package:material_color_utilities/scheme/dynamic_scheme.dart';
import 'package:material_color_utilities/scheme/variant.dart';

bool _isFidelity(DynamicScheme scheme) =>
    scheme.variant == Variant.fidelity || scheme.variant == Variant.content;

/// Tokens, or named colors, in the Material Design system.
class MaterialDynamicColors {
  static const double contentAccentToneDelta = 15.0;
  static DynamicColor highestSurface(DynamicScheme s) {
    return s.isDark ? surfaceLight : surfaceDark;
  }

  static ViewingConditions viewingConditionsForAlbers(DynamicScheme scheme) {
    return ViewingConditions.make(backgroundLstar: scheme.isDark ? 30 : 80);
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

  static DynamicColor surfaceInverse = DynamicColor.fromPalette(
    palette: (s) => s.neutralPalette,
    tone: (s) => s.isDark ? 90 : 30,
  );

  static DynamicColor onSurfaceInverse = DynamicColor.fromPalette(
    palette: (s) => s.neutralPalette,
    tone: (s) => s.isDark ? 20 : 95,
    background: (s) => surfaceInverse,
  );

  static DynamicColor outline = DynamicColor.fromPalette(
    palette: (s) => s.neutralVariantPalette,
    tone: (s) => 50,
    background: (s) => highestSurface(s),
  );

  static DynamicColor outlineVariant = DynamicColor.fromPalette(
    palette: (s) => s.neutralVariantPalette,
    tone: (s) => s.isDark ? 30 : 80,
    background: (s) => highestSurface(s),
  );

  static DynamicColor shadow = DynamicColor.fromPalette(
    palette: (s) => s.neutralPalette,
    tone: (s) => 0,
  );

  static DynamicColor scrim = DynamicColor.fromPalette(
    palette: (s) => s.neutralPalette,
    tone: (s) => 0,
  );

  static DynamicColor surfaceTint = DynamicColor.fromPalette(
    palette: (s) => s.primaryPalette,
    tone: (s) => s.isDark ? 80 : 40,
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
    background: (s) => highestSurface(s),
    tone: (s) {
      if (!_isFidelity(s)) {
        return s.isDark ? 30 : 90;
      }
      return _performAlbers(s.sourceColorHct, s);
    },
  );

  static DynamicColor onPrimaryContainer = DynamicColor.fromPalette(
    palette: (s) => s.primaryPalette,
    background: (s) => primaryContainer,
    tone: (s) {
      if (!_isFidelity(s)) {
        return s.isDark ? 90 : 10;
      }
      return DynamicColor.foregroundTone(primaryContainer.tone(s), 4.5);
    },
  );

  static DynamicColor primaryInverse = DynamicColor.fromPalette(
    palette: (s) => s.primaryPalette,
    tone: (s) => s.isDark ? 40 : 80,
    background: (s) => surfaceInverse,
  );

  static DynamicColor onPrimaryInverse = DynamicColor.fromPalette(
    palette: (s) => s.primaryPalette,
    tone: (s) => s.isDark ? 100 : 20,
    background: (s) => primaryInverse,
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
    background: (s) => highestSurface(s),
    tone: (s) {
      final initialTone = s.isDark ? 30.0 : 90.0;
      if (!_isFidelity(s)) {
        return initialTone;
      }
      var answer = _findDesiredChromaByTone(s.secondaryPalette.hue,
          s.secondaryPalette.chroma, initialTone, s.isDark ? false : true);
      answer = _performAlbers(s.secondaryPalette.getHct(answer), s);
      return answer;
    },
  );

  static DynamicColor onSecondaryContainer = DynamicColor.fromPalette(
    palette: (s) => s.secondaryPalette,
    background: (s) => secondaryContainer,
    tone: (s) {
      if (!_isFidelity(s)) {
        return s.isDark ? 90 : 10;
      }
      return DynamicColor.foregroundTone(secondaryContainer.tone(s), 4.5);
    },
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
    background: (s) => highestSurface(s),
    tone: (s) {
      if (!_isFidelity(s)) {
        return s.isDark ? 30 : 90;
      }

      final albersTone =
          _performAlbers(s.tertiaryPalette.getHct(s.sourceColorHct.tone), s);
      final proposedHct = s.tertiaryPalette.getHct(albersTone);
      return DislikeAnalyzer.fixIfDisliked(proposedHct).tone;
    },
  );

  static DynamicColor onTertiaryContainer = DynamicColor.fromPalette(
    palette: (s) => s.tertiaryPalette,
    background: (s) => tertiaryContainer,
    tone: (s) {
      if (!_isFidelity(s)) {
        return s.isDark ? 90 : 10;
      }
      return DynamicColor.foregroundTone(tertiaryContainer.tone(s), 4.5);
    },
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

  static double _findDesiredChromaByTone(
      double hue, double chroma, double tone, bool byDecreasingTone) {
    var answer = tone;

    Hct closestToChroma = Hct.from(hue, chroma, tone);
    if (closestToChroma.chroma < chroma) {
      double chromaPeak = closestToChroma.chroma;
      while (closestToChroma.chroma < chroma) {
        answer += byDecreasingTone ? -1.0 : 1.0;
        final potentialSolution = Hct.from(hue, chroma, answer);
        if (chromaPeak > potentialSolution.chroma) {
          break;
        }
        if ((potentialSolution.chroma - chroma).abs() < 0.4) {
          break;
        }

        final potentialDelta = (potentialSolution.chroma - chroma).abs();
        final currentDelta = (closestToChroma.chroma - chroma).abs();
        if (potentialDelta < currentDelta) {
          closestToChroma = potentialSolution;
        }
        chromaPeak = math.max(chromaPeak, potentialSolution.chroma);
      }
    }

    return answer;
  }

  static double _performAlbers(Hct prealbers, DynamicScheme scheme) {
    final albersd =
        prealbers.inViewingConditions(viewingConditionsForAlbers(scheme));
    if (DynamicColor.tonePrefersLightForeground(prealbers.tone) &&
        !DynamicColor.toneAllowsLightForeground(albersd.tone)) {
      return DynamicColor.enableLightForeground(prealbers.tone);
    } else {
      return DynamicColor.enableLightForeground(albersd.tone);
    }
  }
}
