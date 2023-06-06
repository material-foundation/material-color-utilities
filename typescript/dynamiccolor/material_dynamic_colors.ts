/**
 * @license
 * Copyright 2022 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import {DislikeAnalyzer} from '../dislike/dislike_analyzer.js';
import {Hct} from '../hct/hct.js';
import {ViewingConditions} from '../hct/viewing_conditions.js';
import {DynamicScheme} from '../scheme/dynamic_scheme.js';
import {Variant} from '../scheme/variant.js';

import {DynamicColor} from './dynamic_color.js';
import {ToneDeltaConstraint} from './tone_delta_constraint.js';

function isFidelity(scheme: DynamicScheme): boolean {
  return scheme.variant === Variant.FIDELITY ||
      scheme.variant === Variant.CONTENT;
}

function isMonochrome(scheme: DynamicScheme): boolean {
  return scheme.variant === Variant.MONOCHROME;
}

function findDesiredChromaByTone(
    hue: number, chroma: number, tone: number,
    byDecreasingTone: boolean): number {
  let answer = tone;

  let closestToChroma = Hct.from(hue, chroma, tone);
  if (closestToChroma.chroma < chroma) {
    let chromaPeak = closestToChroma.chroma;
    while (closestToChroma.chroma < chroma) {
      answer += byDecreasingTone ? -1.0 : 1.0;
      const potentialSolution = Hct.from(hue, chroma, answer);
      if (chromaPeak > potentialSolution.chroma) {
        break;
      }
      if (Math.abs(potentialSolution.chroma - chroma) < 0.4) {
        break;
      }

      const potentialDelta = Math.abs(potentialSolution.chroma - chroma);
      const currentDelta = Math.abs(closestToChroma.chroma - chroma);
      if (potentialDelta < currentDelta) {
        closestToChroma = potentialSolution;
      }
      chromaPeak = Math.max(chromaPeak, potentialSolution.chroma);
    }
  }

  return answer;
}

function viewingConditionsForAlbers(scheme: DynamicScheme): ViewingConditions {
  return ViewingConditions.make(
      /*whitePoint=*/ undefined,
      /*adaptingLuminance=*/ undefined,
      /*backgroundLstar=*/ scheme.isDark ? 30 : 80,
      /*surround=*/ undefined,
      /*discountingIlluminant=*/ undefined,
  );
}

function performAlbers(prealbers: Hct, scheme: DynamicScheme): number {
  const albersd =
      prealbers.inViewingConditions(viewingConditionsForAlbers(scheme));
  if (DynamicColor.tonePrefersLightForeground(prealbers.tone) &&
      !DynamicColor.toneAllowsLightForeground(albersd.tone)) {
    return DynamicColor.enableLightForeground(prealbers.tone);
  } else {
    return DynamicColor.enableLightForeground(albersd.tone);
  }
}

/**
 * DynamicColors for the colors in the Material Design system.
 */
// Material Color Utilities namespaces the various utilities it provides.
// tslint:disable-next-line:class-as-namespace
export class MaterialDynamicColors {
  static contentAccentToneDelta = 15.0;
  static highestSurface(s: DynamicScheme): DynamicColor {
    return s.isDark ? MaterialDynamicColors.surfaceBright :
                      MaterialDynamicColors.surfaceDim;
  }

  static primaryPaletteKeyColor = DynamicColor.fromPalette({
    palette: (s) => s.primaryPalette,
    tone: (s) => s.primaryPalette.keyColor.tone,
  });

  static secondaryPaletteKeyColor = DynamicColor.fromPalette({
    palette: (s) => s.secondaryPalette,
    tone: (s) => s.secondaryPalette.keyColor.tone,
  });

  static tertiaryPaletteKeyColor = DynamicColor.fromPalette({
    palette: (s) => s.tertiaryPalette,
    tone: (s) => s.tertiaryPalette.keyColor.tone,
  });

  static neutralPaletteKeyColor = DynamicColor.fromPalette({
    palette: (s) => s.neutralPalette,
    tone: (s) => s.neutralPalette.keyColor.tone,
  });

  static neutralVariantPaletteKeyColor = DynamicColor.fromPalette({
    palette: (s) => s.neutralVariantPalette,
    tone: (s) => s.neutralVariantPalette.keyColor.tone,
  });

  static background = DynamicColor.fromPalette({
    palette: (s) => s.neutralPalette,
    tone: (s) => s.isDark ? 6 : 98,
  });

  static onBackground = DynamicColor.fromPalette({
    palette: (s) => s.neutralPalette,
    tone: (s) => s.isDark ? 90 : 10,
    background: (s) => MaterialDynamicColors.background,
  });

  static surface = DynamicColor.fromPalette({
    palette: (s) => s.neutralPalette,
    tone: (s) => s.isDark ? 6 : 98,
  });

  static surfaceDim = DynamicColor.fromPalette({
    palette: (s) => s.neutralPalette,
    tone: (s) => s.isDark ? 6 : 87,
  });

  static surfaceBright = DynamicColor.fromPalette({
    palette: (s) => s.neutralPalette,
    tone: (s) => s.isDark ? 24 : 98,
  });

  static surfaceContainerLowest = DynamicColor.fromPalette({
    palette: (s) => s.neutralPalette,
    tone: (s) => s.isDark ? 4 : 100,
  });

  static surfaceContainerLow = DynamicColor.fromPalette({
    palette: (s) => s.neutralPalette,
    tone: (s) => s.isDark ? 10 : 96,
  });

  static surfaceContainer = DynamicColor.fromPalette({
    palette: (s) => s.neutralPalette,
    tone: (s) => s.isDark ? 12 : 94,
  });

  static surfaceContainerHigh = DynamicColor.fromPalette({
    palette: (s) => s.neutralPalette,
    tone: (s) => s.isDark ? 17 : 92,
  });

  static surfaceContainerHighest = DynamicColor.fromPalette({
    palette: (s) => s.neutralPalette,
    tone: (s) => s.isDark ? 22 : 90,
  });

  static onSurface = DynamicColor.fromPalette({
    palette: (s) => s.neutralPalette,
    tone: (s) => s.isDark ? 90 : 10,
    background: (s) => MaterialDynamicColors.highestSurface(s),
  });

  static surfaceVariant = DynamicColor.fromPalette({
    palette: (s) => s.neutralVariantPalette,
    tone: (s) => s.isDark ? 30 : 90,
  });

  static onSurfaceVariant = DynamicColor.fromPalette({
    palette: (s) => s.neutralVariantPalette,
    tone: (s) => s.isDark ? 80 : 30,
    background: (s) => MaterialDynamicColors.surfaceVariant,
  });

  static inverseSurface = DynamicColor.fromPalette({
    palette: (s) => s.neutralPalette,
    tone: (s) => s.isDark ? 90 : 20,
  });

  static inverseOnSurface = DynamicColor.fromPalette({
    palette: (s) => s.neutralPalette,
    tone: (s) => s.isDark ? 20 : 95,
    background: (s) => MaterialDynamicColors.inverseSurface,
  });

  static outline = DynamicColor.fromPalette({
    palette: (s) => s.neutralVariantPalette,
    tone: (s) => s.isDark ? 60 : 50,
    background: (s) => MaterialDynamicColors.highestSurface(s),
  });

  static outlineVariant = DynamicColor.fromPalette({
    palette: (s) => s.neutralVariantPalette,
    tone: (s) => s.isDark ? 30 : 80,
    background: (s) => MaterialDynamicColors.highestSurface(s),
  });

  static shadow = DynamicColor.fromPalette({
    palette: (s) => s.neutralPalette,
    tone: (s) => 0,
  });

  static scrim = DynamicColor.fromPalette({
    palette: (s) => s.neutralPalette,
    tone: (s) => 0,
  });

  static surfaceTintColor = DynamicColor.fromPalette({
    palette: (s) => s.primaryPalette,
    tone: (s) => s.isDark ? 80 : 40,
  });

  static primary = DynamicColor.fromPalette({
    palette: (s) => s.primaryPalette,
    tone:
        (s) => {
          if (isMonochrome(s)) {
            return s.isDark ? 100 : 0;
          }
          return s.isDark ? 80 : 40;
        },
    background: (s) => MaterialDynamicColors.highestSurface(s),
    toneDeltaConstraint: (s) => new ToneDeltaConstraint(
        MaterialDynamicColors.contentAccentToneDelta,
        MaterialDynamicColors.primaryContainer,
        s.isDark? 'darker': 'lighter',
        ),
  });

  static onPrimary = DynamicColor.fromPalette({
    palette: (s) => s.primaryPalette,
    tone:
        (s) => {
          if (isMonochrome(s)) {
            return s.isDark ? 10 : 90;
          }
          return s.isDark ? 20 : 100;
        },
    background: (s) => MaterialDynamicColors.primary,
  });

  static primaryContainer = DynamicColor.fromPalette({
    palette: (s) => s.primaryPalette,
    tone:
        (s) => {
          if (isFidelity(s)) {
            return performAlbers(s.sourceColorHct, s);
          }
          if (isMonochrome(s)) {
            return s.isDark ? 85 : 25;
          }
          return s.isDark ? 30 : 90;
        },
    background: (s) => MaterialDynamicColors.highestSurface(s),
  });

  static onPrimaryContainer = DynamicColor.fromPalette({
    palette: (s) => s.primaryPalette,
    tone:
        (s) => {
          if (isFidelity(s)) {
            return DynamicColor.foregroundTone(
                MaterialDynamicColors.primaryContainer.tone(s), 4.5);
          }
          if (isMonochrome(s)) {
            return s.isDark ? 0 : 100;
          }
          return s.isDark ? 90 : 10;
        },
    background: (s) => MaterialDynamicColors.primaryContainer,
  });

  static inversePrimary = DynamicColor.fromPalette({
    palette: (s) => s.primaryPalette,
    tone: (s) => s.isDark ? 40 : 80,
    background: (s) => MaterialDynamicColors.inverseSurface,
  });

  static secondary = DynamicColor.fromPalette({
    palette: (s) => s.secondaryPalette,
    tone: (s) => s.isDark ? 80 : 40,
    background: (s) => MaterialDynamicColors.highestSurface(s),
    toneDeltaConstraint: (s) => new ToneDeltaConstraint(
        MaterialDynamicColors.contentAccentToneDelta,
        MaterialDynamicColors.secondaryContainer,
        s.isDark? 'darker': 'lighter'),
  });

  static onSecondary = DynamicColor.fromPalette({
    palette: (s) => s.secondaryPalette,
    tone:
        (s) => {
          if (isMonochrome(s)) {
            return s.isDark ? 10 : 100;
          } else {
            return s.isDark ? 20 : 100;
          }
        },
    background: (s) => MaterialDynamicColors.secondary,
  });

  static secondaryContainer = DynamicColor.fromPalette({
    palette: (s) => s.secondaryPalette,
    tone:
        (s) => {
          const initialTone = s.isDark ? 30 : 90;
          if (isMonochrome(s)) {
            return s.isDark ? 30 : 85;
          }
          if (!isFidelity(s)) {
            return initialTone;
          }
          let answer = findDesiredChromaByTone(
              s.secondaryPalette.hue, s.secondaryPalette.chroma, initialTone,
              s.isDark ? false : true);
          answer = performAlbers(s.secondaryPalette.getHct(answer), s);
          return answer;
        },
    background: (s) => MaterialDynamicColors.highestSurface(s),
  });

  static onSecondaryContainer = DynamicColor.fromPalette({
    palette: (s) => s.secondaryPalette,
    tone:
        (s) => {
          if (!isFidelity(s)) {
            return s.isDark ? 90 : 10;
          }
          return DynamicColor.foregroundTone(
              MaterialDynamicColors.secondaryContainer.tone(s), 4.5);
        },

    background: (s) => MaterialDynamicColors.secondaryContainer,
  });

  static tertiary = DynamicColor.fromPalette({
    palette: (s) => s.tertiaryPalette,
    tone:
        (s) => {
          if (isMonochrome(s)) {
            return s.isDark ? 90 : 25;
          }
          return s.isDark ? 80 : 40;
        },
    background: (s) => MaterialDynamicColors.highestSurface(s),
    toneDeltaConstraint: (s) => new ToneDeltaConstraint(
        MaterialDynamicColors.contentAccentToneDelta,
        MaterialDynamicColors.tertiaryContainer, s.isDark? 'darker': 'lighter'),
  });

  static onTertiary = DynamicColor.fromPalette({
    palette: (s) => s.tertiaryPalette,
    tone:
        (s) => {
          if (isMonochrome(s)) {
            return s.isDark ? 10 : 90;
          }
          return s.isDark ? 20 : 100;
        },
    background: (s) => MaterialDynamicColors.tertiary,
  });

  static tertiaryContainer = DynamicColor.fromPalette({
    palette: (s) => s.tertiaryPalette,
    tone:
        (s) => {
          if (isMonochrome(s)) {
            return s.isDark ? 60 : 49;
          }
          if (!isFidelity(s)) {
            return s.isDark ? 30 : 90;
          }
          const albersTone =
              performAlbers(s.tertiaryPalette.getHct(s.sourceColorHct.tone), s);
          const proposedHct = s.tertiaryPalette.getHct(albersTone);
          return DislikeAnalyzer.fixIfDisliked(proposedHct).tone;
        },
    background: (s) => MaterialDynamicColors.highestSurface(s),
  });

  static onTertiaryContainer = DynamicColor.fromPalette({
    palette: (s) => s.tertiaryPalette,
    tone:
        (s) => {
          if (isMonochrome(s)) {
            return s.isDark ? 0 : 100;
          }
          if (!isFidelity(s)) {
            return s.isDark ? 90 : 10;
          }
          return DynamicColor.foregroundTone(
              MaterialDynamicColors.tertiaryContainer.tone(s), 4.5);
        },
    background: (s) => MaterialDynamicColors.tertiaryContainer,
  });

  static error = DynamicColor.fromPalette({
    palette: (s) => s.errorPalette,
    tone: (s) => s.isDark ? 80 : 40,
    background: (s) => MaterialDynamicColors.highestSurface(s),
    toneDeltaConstraint: (s) => new ToneDeltaConstraint(
        MaterialDynamicColors.contentAccentToneDelta,
        MaterialDynamicColors.errorContainer,
        s.isDark? 'darker': 'lighter',
        ),
  });

  static onError = DynamicColor.fromPalette({
    palette: (s) => s.errorPalette,
    tone: (s) => s.isDark ? 20 : 100,
    background: (s) => MaterialDynamicColors.error,
  });

  static errorContainer = DynamicColor.fromPalette({
    palette: (s) => s.errorPalette,
    tone: (s) => s.isDark ? 30 : 90,
    background: (s) => MaterialDynamicColors.highestSurface(s),
  });

  static onErrorContainer = DynamicColor.fromPalette({
    palette: (s) => s.errorPalette,
    tone: (s) => s.isDark ? 90 : 10,
    background: (s) => MaterialDynamicColors.errorContainer,
  });

  static primaryFixed = DynamicColor.fromPalette({
    palette: (s) => s.primaryPalette,
    tone:
        (s) => {
          if (isMonochrome(s)) {
            return s.isDark ? 100.0 : 10.0;
          }
          return 90.0;
        },
    background: (s) => MaterialDynamicColors.highestSurface(s),
  });

  static primaryFixedDim = DynamicColor.fromPalette({
    palette: (s) => s.primaryPalette,
    tone:
        (s) => {
          if (isMonochrome(s)) {
            return s.isDark ? 90.0 : 20.0;
          }
          return 80.0;
        },
    background: (s) => MaterialDynamicColors.highestSurface(s),
  });

  static onPrimaryFixed = DynamicColor.fromPalette({
    palette: (s) => s.primaryPalette,
    tone:
        (s) => {
          if (isMonochrome(s)) {
            return s.isDark ? 10.0 : 90.0;
          }
          return 10.0;
        },
    background: (s) => MaterialDynamicColors.primaryFixedDim,
  });

  static onPrimaryFixedVariant = DynamicColor.fromPalette({
    palette: (s) => s.primaryPalette,
    tone:
        (s) => {
          if (isMonochrome(s)) {
            return s.isDark ? 30.0 : 70.0;
          }
          return 30.0;
        },
    background: (s) => MaterialDynamicColors.primaryFixedDim,
  });

  static secondaryFixed = DynamicColor.fromPalette({
    palette: (s) => s.secondaryPalette,
    tone: (s) => isMonochrome(s) ? 80.0 : 90.0,
    background: (s) => MaterialDynamicColors.highestSurface(s),
  });

  static secondaryFixedDim = DynamicColor.fromPalette({
    palette: (s) => s.secondaryPalette,
    tone: (s) => isMonochrome(s) ? 70.0 : 80.0,
    background: (s) => MaterialDynamicColors.highestSurface(s),
  });

  static onSecondaryFixed = DynamicColor.fromPalette({
    palette: (s) => s.secondaryPalette,
    tone: (s) => 10.0,
    background: (s) => MaterialDynamicColors.secondaryFixedDim,
  });

  static onSecondaryFixedVariant = DynamicColor.fromPalette({
    palette: (s) => s.secondaryPalette,
    tone: (s) => isMonochrome(s) ? 25.0 : 30.0,
    background: (s) => MaterialDynamicColors.secondaryFixedDim,
  });

  static tertiaryFixed = DynamicColor.fromPalette({
    palette: (s) => s.tertiaryPalette,
    tone: (s) => isMonochrome(s) ? 40.0 : 90.0,
    background: (s) => MaterialDynamicColors.highestSurface(s),
  });

  static tertiaryFixedDim = DynamicColor.fromPalette({
    palette: (s) => s.tertiaryPalette,
    tone: (s) => isMonochrome(s) ? 30.0 : 80.0,
    background: (s) => MaterialDynamicColors.highestSurface(s),
  });

  static onTertiaryFixed = DynamicColor.fromPalette({
    palette: (s) => s.tertiaryPalette,
    tone: (s) => isMonochrome(s) ? 90.0 : 10.0,
    background: (s) => MaterialDynamicColors.tertiaryFixedDim,
  });

  static onTertiaryFixedVariant = DynamicColor.fromPalette({
    palette: (s) => s.tertiaryPalette,
    tone: (s) => isMonochrome(s) ? 70.0 : 30.0,
    background: (s) => MaterialDynamicColors.tertiaryFixedDim,
  });
}
