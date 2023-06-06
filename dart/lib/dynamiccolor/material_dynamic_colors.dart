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
import 'package:material_color_utilities/hct/hct.dart';
import 'package:material_color_utilities/hct/viewing_conditions.dart';
import 'package:material_color_utilities/scheme/dynamic_scheme.dart';
import 'package:material_color_utilities/scheme/variant.dart';

import 'dynamic_color.dart';
import 'src/tone_delta_constraint.dart';

bool _isFidelity(DynamicScheme scheme) =>
    scheme.variant == Variant.fidelity || scheme.variant == Variant.content;

bool _isMonochrome(DynamicScheme scheme) =>
    scheme.variant == Variant.monochrome;

/// Tokens, or named colors, in the Material Design system.
class MaterialDynamicColors {
  static const double contentAccentToneDelta = 15.0;
  static DynamicColor highestSurface(DynamicScheme s) {
    return s.isDark ? surfaceBright : surfaceDim;
  }

  static ViewingConditions viewingConditionsForAlbers(DynamicScheme scheme) {
    return ViewingConditions.make(backgroundLstar: scheme.isDark ? 30 : 80);
  }

  static DynamicColor primaryPaletteKeyColor = DynamicColor.fromPalette(
    palette: (s) => s.primaryPalette,
    tone: (s) => s.primaryPalette.keyColor.tone,
  );

  static DynamicColor secondaryPaletteKeyColor = DynamicColor.fromPalette(
    palette: (s) => s.secondaryPalette,
    tone: (s) => s.secondaryPalette.keyColor.tone,
  );

  static DynamicColor tertiaryPaletteKeyColor = DynamicColor.fromPalette(
    palette: (s) => s.tertiaryPalette,
    tone: (s) => s.tertiaryPalette.keyColor.tone,
  );

  static DynamicColor neutralPaletteKeyColor = DynamicColor.fromPalette(
    palette: (s) => s.neutralPalette,
    tone: (s) => s.neutralPalette.keyColor.tone,
  );

  static DynamicColor neutralVariantPaletteKeyColor = DynamicColor.fromPalette(
    palette: (s) => s.neutralVariantPalette,
    tone: (s) => s.neutralVariantPalette.keyColor.tone,
  );

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

  static DynamicColor surfaceDim = DynamicColor.fromPalette(
    palette: (s) => s.neutralPalette,
    tone: (s) => s.isDark ? 6 : 87,
  );

  static DynamicColor surfaceBright = DynamicColor.fromPalette(
    palette: (s) => s.neutralPalette,
    tone: (s) => s.isDark ? 24 : 98,
  );

  static DynamicColor surfaceContainerLowest = DynamicColor.fromPalette(
    palette: (s) => s.neutralPalette,
    tone: (s) => s.isDark ? 4 : 100,
  );

  static DynamicColor surfaceContainerLow = DynamicColor.fromPalette(
    palette: (s) => s.neutralPalette,
    tone: (s) => s.isDark ? 10 : 96,
  );

  static DynamicColor surfaceContainer = DynamicColor.fromPalette(
    palette: (s) => s.neutralPalette,
    tone: (s) => s.isDark ? 12 : 94,
  );

  static DynamicColor surfaceContainerHigh = DynamicColor.fromPalette(
    palette: (s) => s.neutralPalette,
    tone: (s) => s.isDark ? 17 : 92,
  );

  static DynamicColor surfaceContainerHighest = DynamicColor.fromPalette(
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

  static DynamicColor inverseSurface = DynamicColor.fromPalette(
    palette: (s) => s.neutralPalette,
    tone: (s) => s.isDark ? 90 : 20,
  );

  static DynamicColor inverseOnSurface = DynamicColor.fromPalette(
    palette: (s) => s.neutralPalette,
    tone: (s) => s.isDark ? 20 : 95,
    background: (s) => inverseSurface,
  );

  static DynamicColor outline = DynamicColor.fromPalette(
    palette: (s) => s.neutralVariantPalette,
    tone: (s) => s.isDark ? 60 : 50,
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
    tone: (s) {
      if (_isMonochrome(s)) {
        return s.isDark ? 100 : 0;
      }
      return s.isDark ? 80 : 40;
    },
    background: (s) => highestSurface(s),
    toneDeltaConstraint: (s) => ToneDeltaConstraint(
      delta: contentAccentToneDelta,
      keepAway: primaryContainer,
      keepAwayPolarity: s.isDark ? TonePolarity.darker : TonePolarity.lighter,
    ),
  );

  static DynamicColor onPrimary = DynamicColor.fromPalette(
    palette: (s) => s.primaryPalette,
    tone: (s) {
      if (_isMonochrome(s)) {
        return s.isDark ? 10 : 90;
      }
      return s.isDark ? 20 : 100;
    },
    background: (s) => primary,
  );

  static DynamicColor primaryContainer = DynamicColor.fromPalette(
    palette: (s) => s.primaryPalette,
    background: (s) => highestSurface(s),
    tone: (s) {
      if (_isFidelity(s)) {
        return _performAlbers(s.sourceColorHct, s);
      }
      if (_isMonochrome(s)) {
        return s.isDark ? 85 : 25;
      }
      return s.isDark ? 30 : 90;
    },
  );

  static DynamicColor onPrimaryContainer = DynamicColor.fromPalette(
    palette: (s) => s.primaryPalette,
    background: (s) => primaryContainer,
    tone: (s) {
      if (_isFidelity(s)) {
        return DynamicColor.foregroundTone(primaryContainer.tone(s), 4.5);
      }
      if (_isMonochrome(s)) {
        return s.isDark ? 0 : 100;
      }
      return s.isDark ? 90 : 10;
    },
  );

  static DynamicColor inversePrimary = DynamicColor.fromPalette(
    palette: (s) => s.primaryPalette,
    tone: (s) => s.isDark ? 40 : 80,
    background: (s) => inverseSurface,
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
    tone: (s) {
      if (_isMonochrome(s)) {
        return s.isDark ? 10 : 100;
      } else {
        return s.isDark ? 20 : 100;
      }
    },
    background: (s) => secondary,
  );

  static DynamicColor secondaryContainer = DynamicColor.fromPalette(
    palette: (s) => s.secondaryPalette,
    background: (s) => highestSurface(s),
    tone: (s) {
      if (_isMonochrome(s)) {
        return s.isDark ? 30 : 85;
      }
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
    tone: (s) {
      if (_isMonochrome(s)) {
        return s.isDark ? 90 : 25;
      }
      return s.isDark ? 80 : 40;
    },
    background: (s) => highestSurface(s),
    toneDeltaConstraint: (s) => ToneDeltaConstraint(
      delta: contentAccentToneDelta,
      keepAway: tertiaryContainer,
      keepAwayPolarity: s.isDark ? TonePolarity.darker : TonePolarity.lighter,
    ),
  );

  static DynamicColor onTertiary = DynamicColor.fromPalette(
    palette: (s) => s.tertiaryPalette,
    tone: (s) {
      if (_isMonochrome(s)) {
        return s.isDark ? 10 : 90;
      }
      return s.isDark ? 20 : 100;
    },
    background: (s) => tertiary,
  );

  static DynamicColor tertiaryContainer = DynamicColor.fromPalette(
    palette: (s) => s.tertiaryPalette,
    background: (s) => highestSurface(s),
    tone: (s) {
      if (_isMonochrome(s)) {
        return s.isDark ? 60 : 49;
      }
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
      if (_isMonochrome(s)) {
        return s.isDark ? 0 : 100;
      }
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

  static DynamicColor primaryFixed = DynamicColor.fromPalette(
      palette: (s) => s.primaryPalette,
      tone: (s) {
        if (_isMonochrome(s)) {
          return s.isDark ? 100.0 : 10.0;
        }
        return 90.0;
      },
      background: (s) => MaterialDynamicColors.highestSurface(s));

  static DynamicColor primaryFixedDim = DynamicColor.fromPalette(
      palette: (s) => s.primaryPalette,
      tone: (s) {
        if (_isMonochrome(s)) {
          return s.isDark ? 90.0 : 20.0;
        }
        return 80.0;
      },
      background: (s) => MaterialDynamicColors.highestSurface(s));

  static DynamicColor onPrimaryFixed = DynamicColor.fromPalette(
      palette: (s) => s.primaryPalette,
      tone: (s) {
        if (_isMonochrome(s)) {
          return s.isDark ? 10.0 : 90.0;
        }
        return 10.0;
      },
      background: (s) => primaryFixedDim);

  static DynamicColor onPrimaryFixedVariant = DynamicColor.fromPalette(
      palette: (s) => s.primaryPalette,
      tone: (s) {
        if (_isMonochrome(s)) {
          return s.isDark ? 30.0 : 70.0;
        }
        return 30.0;
      },
      background: (s) => primaryFixedDim);

  static DynamicColor secondaryFixed = DynamicColor.fromPalette(
      palette: (s) => s.secondaryPalette,
      tone: (s) => _isMonochrome(s) ? 80.0 : 90.0,
      background: (s) => MaterialDynamicColors.highestSurface(s));

  static DynamicColor secondaryFixedDim = DynamicColor.fromPalette(
      palette: (s) => s.secondaryPalette,
      tone: (s) => _isMonochrome(s) ? 70.0 : 80.0,
      background: (s) => MaterialDynamicColors.highestSurface(s));

  static DynamicColor onSecondaryFixed = DynamicColor.fromPalette(
      palette: (s) => s.secondaryPalette,
      tone: (s) => 10.0,
      background: (s) => secondaryFixedDim);

  static DynamicColor onSecondaryFixedVariant = DynamicColor.fromPalette(
      palette: (s) => s.secondaryPalette,
      tone: (s) => _isMonochrome(s) ? 25.0 : 30.0,
      background: (s) => secondaryFixedDim);

  static DynamicColor tertiaryFixed = DynamicColor.fromPalette(
      palette: (s) => s.tertiaryPalette,
      tone: (s) => _isMonochrome(s) ? 40.0 : 90.0,
      background: (s) => MaterialDynamicColors.highestSurface(s));

  static DynamicColor tertiaryFixedDim = DynamicColor.fromPalette(
      palette: (s) => s.tertiaryPalette,
      tone: (s) => _isMonochrome(s) ? 30.0 : 80.0,
      background: (s) => MaterialDynamicColors.highestSurface(s));

  static DynamicColor onTertiaryFixed = DynamicColor.fromPalette(
      palette: (s) => s.tertiaryPalette,
      tone: (s) => _isMonochrome(s) ? 90.0 : 10.0,
      background: (s) => tertiaryFixedDim);

  static DynamicColor onTertiaryFixedVariant = DynamicColor.fromPalette(
      palette: (s) => s.tertiaryPalette,
      tone: (s) => _isMonochrome(s) ? 70.0 : 30.0,
      background: (s) => tertiaryFixedDim);

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
