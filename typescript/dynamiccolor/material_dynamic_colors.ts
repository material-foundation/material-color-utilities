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
import {DynamicScheme} from '../scheme/dynamic_scheme.js';
import {Variant} from '../scheme/variant.js';

import {ContrastCurve} from './contrast_curve.js';
import {DynamicColor} from './dynamic_color.js';
import {ToneDeltaPair} from './tone_delta_pair.js';

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
    name: 'primary_palette_key_color',
    palette: (s) => s.primaryPalette,
    tone: (s) => s.primaryPalette.keyColor.tone,
  });

  static secondaryPaletteKeyColor = DynamicColor.fromPalette({
    name: 'secondary_palette_key_color',
    palette: (s) => s.secondaryPalette,
    tone: (s) => s.secondaryPalette.keyColor.tone,
  });

  static tertiaryPaletteKeyColor = DynamicColor.fromPalette({
    name: 'tertiary_palette_key_color',
    palette: (s) => s.tertiaryPalette,
    tone: (s) => s.tertiaryPalette.keyColor.tone,
  });

  static neutralPaletteKeyColor = DynamicColor.fromPalette({
    name: 'neutral_palette_key_color',
    palette: (s) => s.neutralPalette,
    tone: (s) => s.neutralPalette.keyColor.tone,
  });

  static neutralVariantPaletteKeyColor = DynamicColor.fromPalette({
    name: 'neutral_variant_palette_key_color',
    palette: (s) => s.neutralVariantPalette,
    tone: (s) => s.neutralVariantPalette.keyColor.tone,
  });

  static background = DynamicColor.fromPalette({
    name: 'background',
    palette: (s) => s.neutralPalette,
    tone: (s) => s.isDark ? 6 : 98,
    isBackground: true,
  });

  static onBackground = DynamicColor.fromPalette({
    name: 'on_background',
    palette: (s) => s.neutralPalette,
    tone: (s) => s.isDark ? 90 : 10,
    background: (s) => MaterialDynamicColors.background,
    contrastCurve: new ContrastCurve(3, 3, 4.5, 7),
  });

  static surface = DynamicColor.fromPalette({
    name: 'surface',
    palette: (s) => s.neutralPalette,
    tone: (s) => s.isDark ? 6 : 98,
    isBackground: true,
  });

  static surfaceDim = DynamicColor.fromPalette({
    name: 'surface_dim',
    palette: (s) => s.neutralPalette,
    tone: (s) =>
        s.isDark ? 6 : new ContrastCurve(87, 87, 80, 75).get(s.contrastLevel),
    isBackground: true,
  });

  static surfaceBright = DynamicColor.fromPalette({
    name: 'surface_bright',
    palette: (s) => s.neutralPalette,
    tone: (s) =>
        s.isDark ? new ContrastCurve(24, 24, 29, 34).get(s.contrastLevel) : 98,
    isBackground: true,
  });

  static surfaceContainerLowest = DynamicColor.fromPalette({
    name: 'surface_container_lowest',
    palette: (s) => s.neutralPalette,
    tone: (s) =>
        s.isDark ? new ContrastCurve(4, 4, 2, 0).get(s.contrastLevel) : 100,
    isBackground: true,
  });

  static surfaceContainerLow = DynamicColor.fromPalette({
    name: 'surface_container_low',
    palette: (s) => s.neutralPalette,
    tone: (s) => s.isDark ?
        new ContrastCurve(10, 10, 11, 12).get(s.contrastLevel) :
        new ContrastCurve(96, 96, 96, 95).get(s.contrastLevel),
    isBackground: true,
  });

  static surfaceContainer = DynamicColor.fromPalette({
    name: 'surface_container',
    palette: (s) => s.neutralPalette,
    tone: (s) => s.isDark ?
        new ContrastCurve(12, 12, 16, 20).get(s.contrastLevel) :
        new ContrastCurve(94, 94, 92, 90).get(s.contrastLevel),
    isBackground: true,
  });

  static surfaceContainerHigh = DynamicColor.fromPalette({
    name: 'surface_container_high',
    palette: (s) => s.neutralPalette,
    tone: (s) => s.isDark ?
        new ContrastCurve(17, 17, 21, 25).get(s.contrastLevel) :
        new ContrastCurve(92, 92, 88, 85).get(s.contrastLevel),
    isBackground: true,
  });

  static surfaceContainerHighest = DynamicColor.fromPalette({
    name: 'surface_container_highest',
    palette: (s) => s.neutralPalette,
    tone: (s) => s.isDark ?
        new ContrastCurve(22, 22, 26, 30).get(s.contrastLevel) :
        new ContrastCurve(90, 90, 84, 80).get(s.contrastLevel),
    isBackground: true,
  });

  static onSurface = DynamicColor.fromPalette({
    name: 'on_surface',
    palette: (s) => s.neutralPalette,
    tone: (s) => s.isDark ? 90 : 10,
    background: (s) => MaterialDynamicColors.highestSurface(s),
    contrastCurve: new ContrastCurve(4.5, 7, 11, 21),
  });

  static surfaceVariant = DynamicColor.fromPalette({
    name: 'surface_variant',
    palette: (s) => s.neutralVariantPalette,
    tone: (s) => s.isDark ? 30 : 90,
    isBackground: true,
  });

  static onSurfaceVariant = DynamicColor.fromPalette({
    name: 'on_surface_variant',
    palette: (s) => s.neutralVariantPalette,
    tone: (s) => s.isDark ? 80 : 30,
    background: (s) => MaterialDynamicColors.highestSurface(s),
    contrastCurve: new ContrastCurve(3, 4.5, 7, 11),
  });

  static inverseSurface = DynamicColor.fromPalette({
    name: 'inverse_surface',
    palette: (s) => s.neutralPalette,
    tone: (s) => s.isDark ? 90 : 20,
  });

  static inverseOnSurface = DynamicColor.fromPalette({
    name: 'inverse_on_surface',
    palette: (s) => s.neutralPalette,
    tone: (s) => s.isDark ? 20 : 95,
    background: (s) => MaterialDynamicColors.inverseSurface,
    contrastCurve: new ContrastCurve(4.5, 7, 11, 21),
  });

  static outline = DynamicColor.fromPalette({
    name: 'outline',
    palette: (s) => s.neutralVariantPalette,
    tone: (s) => s.isDark ? 60 : 50,
    background: (s) => MaterialDynamicColors.highestSurface(s),
    contrastCurve: new ContrastCurve(1.5, 3, 4.5, 7),
  });

  static outlineVariant = DynamicColor.fromPalette({
    name: 'outline_variant',
    palette: (s) => s.neutralVariantPalette,
    tone: (s) => s.isDark ? 30 : 80,
    background: (s) => MaterialDynamicColors.highestSurface(s),
    contrastCurve: new ContrastCurve(1, 1, 3, 4.5),
  });

  static shadow = DynamicColor.fromPalette({
    name: 'shadow',
    palette: (s) => s.neutralPalette,
    tone: (s) => 0,
  });

  static scrim = DynamicColor.fromPalette({
    name: 'scrim',
    palette: (s) => s.neutralPalette,
    tone: (s) => 0,
  });

  static surfaceTint = DynamicColor.fromPalette({
    name: 'surface_tint',
    palette: (s) => s.primaryPalette,
    tone: (s) => s.isDark ? 80 : 40,
    isBackground: true,
  });

  static primary = DynamicColor.fromPalette({
    name: 'primary',
    palette: (s) => s.primaryPalette,
    tone:
        (s) => {
          if (isMonochrome(s)) {
            return s.isDark ? 100 : 0;
          }
          return s.isDark ? 80 : 40;
        },
    isBackground: true,
    background: (s) => MaterialDynamicColors.highestSurface(s),
    contrastCurve: new ContrastCurve(3, 4.5, 7, 7),
    toneDeltaPair: (s) => new ToneDeltaPair(
        MaterialDynamicColors.primaryContainer, MaterialDynamicColors.primary,
        10, 'nearer', false),
  });

  static onPrimary = DynamicColor.fromPalette({
    name: 'on_primary',
    palette: (s) => s.primaryPalette,
    tone:
        (s) => {
          if (isMonochrome(s)) {
            return s.isDark ? 10 : 90;
          }
          return s.isDark ? 20 : 100;
        },
    background: (s) => MaterialDynamicColors.primary,
    contrastCurve: new ContrastCurve(4.5, 7, 11, 21),
  });

  static primaryContainer = DynamicColor.fromPalette({
    name: 'primary_container',
    palette: (s) => s.primaryPalette,
    tone:
        (s) => {
          if (isFidelity(s)) {
            return s.sourceColorHct.tone;
          }
          if (isMonochrome(s)) {
            return s.isDark ? 85 : 25;
          }
          return s.isDark ? 30 : 90;
        },
    isBackground: true,
    background: (s) => MaterialDynamicColors.highestSurface(s),
    contrastCurve: new ContrastCurve(1, 1, 3, 4.5),
    toneDeltaPair: (s) => new ToneDeltaPair(
        MaterialDynamicColors.primaryContainer, MaterialDynamicColors.primary,
        10, 'nearer', false),
  });

  static onPrimaryContainer = DynamicColor.fromPalette({
    name: 'on_primary_container',
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
    contrastCurve: new ContrastCurve(4.5, 7, 11, 21),
  });

  static inversePrimary = DynamicColor.fromPalette({
    name: 'inverse_primary',
    palette: (s) => s.primaryPalette,
    tone: (s) => s.isDark ? 40 : 80,
    background: (s) => MaterialDynamicColors.inverseSurface,
    contrastCurve: new ContrastCurve(3, 4.5, 7, 7),
  });

  static secondary = DynamicColor.fromPalette({
    name: 'secondary',
    palette: (s) => s.secondaryPalette,
    tone: (s) => s.isDark ? 80 : 40,
    isBackground: true,
    background: (s) => MaterialDynamicColors.highestSurface(s),
    contrastCurve: new ContrastCurve(3, 4.5, 7, 7),
    toneDeltaPair: (s) => new ToneDeltaPair(
        MaterialDynamicColors.secondaryContainer,
        MaterialDynamicColors.secondary, 10, 'nearer', false),
  });

  static onSecondary = DynamicColor.fromPalette({
    name: 'on_secondary',
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
    contrastCurve: new ContrastCurve(4.5, 7, 11, 21),
  });

  static secondaryContainer = DynamicColor.fromPalette({
    name: 'secondary_container',
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
          return findDesiredChromaByTone(
              s.secondaryPalette.hue, s.secondaryPalette.chroma, initialTone,
              s.isDark ? false : true);
        },
    isBackground: true,
    background: (s) => MaterialDynamicColors.highestSurface(s),
    contrastCurve: new ContrastCurve(1, 1, 3, 4.5),
    toneDeltaPair: (s) => new ToneDeltaPair(
        MaterialDynamicColors.secondaryContainer,
        MaterialDynamicColors.secondary, 10, 'nearer', false),
  });

  static onSecondaryContainer = DynamicColor.fromPalette({
    name: 'on_secondary_container',
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
    contrastCurve: new ContrastCurve(4.5, 7, 11, 21),
  });

  static tertiary = DynamicColor.fromPalette({
    name: 'tertiary',
    palette: (s) => s.tertiaryPalette,
    tone:
        (s) => {
          if (isMonochrome(s)) {
            return s.isDark ? 90 : 25;
          }
          return s.isDark ? 80 : 40;
        },
    isBackground: true,
    background: (s) => MaterialDynamicColors.highestSurface(s),
    contrastCurve: new ContrastCurve(3, 4.5, 7, 7),
    toneDeltaPair: (s) => new ToneDeltaPair(
        MaterialDynamicColors.tertiaryContainer, MaterialDynamicColors.tertiary,
        10, 'nearer', false),
  });

  static onTertiary = DynamicColor.fromPalette({
    name: 'on_tertiary',
    palette: (s) => s.tertiaryPalette,
    tone:
        (s) => {
          if (isMonochrome(s)) {
            return s.isDark ? 10 : 90;
          }
          return s.isDark ? 20 : 100;
        },
    background: (s) => MaterialDynamicColors.tertiary,
    contrastCurve: new ContrastCurve(4.5, 7, 11, 21),
  });

  static tertiaryContainer = DynamicColor.fromPalette({
    name: 'tertiary_container',
    palette: (s) => s.tertiaryPalette,
    tone:
        (s) => {
          if (isMonochrome(s)) {
            return s.isDark ? 60 : 49;
          }
          if (!isFidelity(s)) {
            return s.isDark ? 30 : 90;
          }
          const proposedHct = s.tertiaryPalette.getHct(s.sourceColorHct.tone);
          return DislikeAnalyzer.fixIfDisliked(proposedHct).tone;
        },
    isBackground: true,
    background: (s) => MaterialDynamicColors.highestSurface(s),
    contrastCurve: new ContrastCurve(1, 1, 3, 4.5),
    toneDeltaPair: (s) => new ToneDeltaPair(
        MaterialDynamicColors.tertiaryContainer, MaterialDynamicColors.tertiary,
        10, 'nearer', false),
  });

  static onTertiaryContainer = DynamicColor.fromPalette({
    name: 'on_tertiary_container',
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
    contrastCurve: new ContrastCurve(4.5, 7, 11, 21),
  });

  static error = DynamicColor.fromPalette({
    name: 'error',
    palette: (s) => s.errorPalette,
    tone: (s) => s.isDark ? 80 : 40,
    isBackground: true,
    background: (s) => MaterialDynamicColors.highestSurface(s),
    contrastCurve: new ContrastCurve(3, 4.5, 7, 7),
    toneDeltaPair: (s) => new ToneDeltaPair(
        MaterialDynamicColors.errorContainer, MaterialDynamicColors.error, 10,
        'nearer', false),
  });

  static onError = DynamicColor.fromPalette({
    name: 'on_error',
    palette: (s) => s.errorPalette,
    tone: (s) => s.isDark ? 20 : 100,
    background: (s) => MaterialDynamicColors.error,
    contrastCurve: new ContrastCurve(4.5, 7, 11, 21),
  });

  static errorContainer = DynamicColor.fromPalette({
    name: 'error_container',
    palette: (s) => s.errorPalette,
    tone: (s) => s.isDark ? 30 : 90,
    isBackground: true,
    background: (s) => MaterialDynamicColors.highestSurface(s),
    contrastCurve: new ContrastCurve(1, 1, 3, 4.5),
    toneDeltaPair: (s) => new ToneDeltaPair(
        MaterialDynamicColors.errorContainer, MaterialDynamicColors.error, 10,
        'nearer', false),
  });

  static onErrorContainer = DynamicColor.fromPalette({
    name: 'on_error_container',
    palette: (s) => s.errorPalette,
    tone: (s) => s.isDark ? 90 : 10,
    background: (s) => MaterialDynamicColors.errorContainer,
    contrastCurve: new ContrastCurve(4.5, 7, 11, 21),
  });

  static primaryFixed = DynamicColor.fromPalette({
    name: 'primary_fixed',
    palette: (s) => s.primaryPalette,
    tone: (s) => isMonochrome(s) ? 40.0 : 90.0,
    isBackground: true,
    background: (s) => MaterialDynamicColors.highestSurface(s),
    contrastCurve: new ContrastCurve(1, 1, 3, 4.5),
    toneDeltaPair: (s) => new ToneDeltaPair(
        MaterialDynamicColors.primaryFixed,
        MaterialDynamicColors.primaryFixedDim, 10, 'lighter', true),
  });

  static primaryFixedDim = DynamicColor.fromPalette({
    name: 'primary_fixed_dim',
    palette: (s) => s.primaryPalette,
    tone: (s) => isMonochrome(s) ? 30.0 : 80.0,
    isBackground: true,
    background: (s) => MaterialDynamicColors.highestSurface(s),
    contrastCurve: new ContrastCurve(1, 1, 3, 4.5),
    toneDeltaPair: (s) => new ToneDeltaPair(
        MaterialDynamicColors.primaryFixed,
        MaterialDynamicColors.primaryFixedDim, 10, 'lighter', true),
  });

  static onPrimaryFixed = DynamicColor.fromPalette({
    name: 'on_primary_fixed',
    palette: (s) => s.primaryPalette,
    tone: (s) => isMonochrome(s) ? 100.0 : 10.0,
    background: (s) => MaterialDynamicColors.primaryFixedDim,
    secondBackground: (s) => MaterialDynamicColors.primaryFixed,
    contrastCurve: new ContrastCurve(4.5, 7, 11, 21),
  });

  static onPrimaryFixedVariant = DynamicColor.fromPalette({
    name: 'on_primary_fixed_variant',
    palette: (s) => s.primaryPalette,
    tone: (s) => isMonochrome(s) ? 90.0 : 30.0,
    background: (s) => MaterialDynamicColors.primaryFixedDim,
    secondBackground: (s) => MaterialDynamicColors.primaryFixed,
    contrastCurve: new ContrastCurve(3, 4.5, 7, 11),
  });

  static secondaryFixed = DynamicColor.fromPalette({
    name: 'secondary_fixed',
    palette: (s) => s.secondaryPalette,
    tone: (s) => isMonochrome(s) ? 80.0 : 90.0,
    isBackground: true,
    background: (s) => MaterialDynamicColors.highestSurface(s),
    contrastCurve: new ContrastCurve(1, 1, 3, 4.5),
    toneDeltaPair: (s) => new ToneDeltaPair(
        MaterialDynamicColors.secondaryFixed,
        MaterialDynamicColors.secondaryFixedDim, 10, 'lighter', true),
  });

  static secondaryFixedDim = DynamicColor.fromPalette({
    name: 'secondary_fixed_dim',
    palette: (s) => s.secondaryPalette,
    tone: (s) => isMonochrome(s) ? 70.0 : 80.0,
    isBackground: true,
    background: (s) => MaterialDynamicColors.highestSurface(s),
    contrastCurve: new ContrastCurve(1, 1, 3, 4.5),
    toneDeltaPair: (s) => new ToneDeltaPair(
        MaterialDynamicColors.secondaryFixed,
        MaterialDynamicColors.secondaryFixedDim, 10, 'lighter', true),
  });

  static onSecondaryFixed = DynamicColor.fromPalette({
    name: 'on_secondary_fixed',
    palette: (s) => s.secondaryPalette,
    tone: (s) => 10.0,
    background: (s) => MaterialDynamicColors.secondaryFixedDim,
    secondBackground: (s) => MaterialDynamicColors.secondaryFixed,
    contrastCurve: new ContrastCurve(4.5, 7, 11, 21),
  });

  static onSecondaryFixedVariant = DynamicColor.fromPalette({
    name: 'on_secondary_fixed_variant',
    palette: (s) => s.secondaryPalette,
    tone: (s) => isMonochrome(s) ? 25.0 : 30.0,
    background: (s) => MaterialDynamicColors.secondaryFixedDim,
    secondBackground: (s) => MaterialDynamicColors.secondaryFixed,
    contrastCurve: new ContrastCurve(3, 4.5, 7, 11),
  });

  static tertiaryFixed = DynamicColor.fromPalette({
    name: 'tertiary_fixed',
    palette: (s) => s.tertiaryPalette,
    tone: (s) => isMonochrome(s) ? 40.0 : 90.0,
    isBackground: true,
    background: (s) => MaterialDynamicColors.highestSurface(s),
    contrastCurve: new ContrastCurve(1, 1, 3, 4.5),
    toneDeltaPair: (s) => new ToneDeltaPair(
        MaterialDynamicColors.tertiaryFixed,
        MaterialDynamicColors.tertiaryFixedDim, 10, 'lighter', true),
  });

  static tertiaryFixedDim = DynamicColor.fromPalette({
    name: 'tertiary_fixed_dim',
    palette: (s) => s.tertiaryPalette,
    tone: (s) => isMonochrome(s) ? 30.0 : 80.0,
    isBackground: true,
    background: (s) => MaterialDynamicColors.highestSurface(s),
    contrastCurve: new ContrastCurve(1, 1, 3, 4.5),
    toneDeltaPair: (s) => new ToneDeltaPair(
        MaterialDynamicColors.tertiaryFixed,
        MaterialDynamicColors.tertiaryFixedDim, 10, 'lighter', true),
  });

  static onTertiaryFixed = DynamicColor.fromPalette({
    name: 'on_tertiary_fixed',
    palette: (s) => s.tertiaryPalette,
    tone: (s) => isMonochrome(s) ? 100.0 : 10.0,
    background: (s) => MaterialDynamicColors.tertiaryFixedDim,
    secondBackground: (s) => MaterialDynamicColors.tertiaryFixed,
    contrastCurve: new ContrastCurve(4.5, 7, 11, 21),
  });

  static onTertiaryFixedVariant = DynamicColor.fromPalette({
    name: 'on_tertiary_fixed_variant',
    palette: (s) => s.tertiaryPalette,
    tone: (s) => isMonochrome(s) ? 90.0 : 30.0,
    background: (s) => MaterialDynamicColors.tertiaryFixedDim,
    secondBackground: (s) => MaterialDynamicColors.tertiaryFixed,
    contrastCurve: new ContrastCurve(3, 4.5, 7, 11),
  });
}
