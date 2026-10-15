/**
 * @license
 * Copyright 2025 Google LLC
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

import {Hct} from '../hct/hct.js';
import {TonalPalette} from '../palettes/tonal_palette.js';
import * as math from '../utils/math_utils.js';

import {ColorSpecDelegateImpl2021} from './color_spec_2021.js';
import {ContrastCurve} from './contrast_curve.js';
import {DynamicColor, extendSpecVersion} from './dynamic_color';
import type {DynamicScheme} from './dynamic_scheme';
import {ToneDeltaPair} from './tone_delta_pair.js';
import {Variant} from './variant.js';

/**
 * Returns the maximum tone for a given chroma in the palette.
 *
 * @param palette The tonal palette to use.
 * @param lowerBound The lower bound of the tone.
 * @param upperBound The upper bound of the tone.
 */
function tMaxC(
    palette: TonalPalette, lowerBound: number = 0, upperBound: number = 100,
    chromaMultiplier: number = 1): number {
  let answer = findBestToneForChroma(
      palette.hue, palette.chroma * chromaMultiplier, 100, true);
  return math.clampDouble(lowerBound, upperBound, answer);
}

/**
 * Returns the minimum tone for a given chroma in the palette.
 *
 * @param palette The tonal palette to use.
 * @param lowerBound The lower bound of the tone.
 * @param upperBound The upper bound of the tone.
 */
function tMinC(
    palette: TonalPalette, lowerBound: number = 0,
    upperBound: number = 100): number {
  let answer = findBestToneForChroma(palette.hue, palette.chroma, 0, false);
  return math.clampDouble(lowerBound, upperBound, answer);
}

/**
 * Searches for the best tone with a given chroma from a given tone at a
 * specific hue.
 *
 * @param hue The given hue.
 * @param chroma The target chroma.
 * @param tone The tone to start with.
 * @param byDecreasingTone Whether to search for lower tones.
 */
function findBestToneForChroma(
    hue: number, chroma: number, tone: number,
    byDecreasingTone: boolean): number {
  let answer = tone;
  let bestCandidate = Hct.from(hue, chroma, answer);
  while (bestCandidate.chroma < chroma) {
    if (tone < 0 || tone > 100) {
      break;
    }
    tone += byDecreasingTone ? -1.0 : 1.0;
    const newCandidate = Hct.from(hue, chroma, tone);
    if (bestCandidate.chroma < newCandidate.chroma) {
      bestCandidate = newCandidate;
      answer = tone;
    }
  }

  return answer;
}

/**
 * Returns whether the given HCT color's chroma is within 0.4 of the target
 * chroma.
 *
 * @param hct The HCT color to check.
 * @param chroma The target chroma.
 */
function isCloseToChroma(hct: Hct, chroma: number): boolean {
  return Math.abs(hct.chroma - chroma) < 0.4;
}

/**
 * Searches for a tone between startingTone and endingTone that achieves the
 * desired chroma at the given hue.
 *
 * @param hue The given hue.
 * @param chroma The target chroma.
 * @param startingTone The tone to start searching from.
 * @param endingTone The tone bound to stop searching at.
 */
function findDesiredChromaByTone(
    hue: number, chroma: number, startingTone: number,
    endingTone: number): number {
  if (endingTone === startingTone) {
    return startingTone;
  }

  let answer = startingTone;
  let potentialAnswer = answer;
  const increment = endingTone < startingTone ? -1.0 : 1.0;

  let closestToChroma = Hct.from(hue, chroma, startingTone);
  while (closestToChroma.chroma < chroma &&
         !isCloseToChroma(closestToChroma, chroma)) {
    potentialAnswer += increment;
    if (potentialAnswer < endingTone && endingTone < startingTone) {
      return answer;
    } else if (potentialAnswer > endingTone && endingTone > startingTone) {
      return answer;
    }
    const potentialSolution = Hct.from(hue, chroma, potentialAnswer);
    if (isCloseToChroma(potentialSolution, chroma)) {
      return potentialAnswer;
    }

    const potentialDelta = Math.abs(potentialSolution.chroma - chroma);
    const currentDelta = Math.abs(closestToChroma.chroma - chroma);
    if (potentialDelta < currentDelta) {
      closestToChroma = potentialSolution;
      answer = potentialAnswer;
    }
  }

  return answer;
}

/**
 * Returns the Watch main accent tone for a given tonal palette and maximum
 * starting tone.
 *
 * @param tonalPalette The tonal palette to use.
 * @param maxTone The maximum starting tone.
 */
function mainTone(tonalPalette: TonalPalette, maxTone: number): number {
  const endingTone = DynamicColor.foregroundTone(25.0, /* ratio= */ 7.0);
  return findDesiredChromaByTone(
      tonalPalette.hue, tonalPalette.chroma, maxTone, endingTone);
}

/**
 * Returns the Watch dim accent tone for a given tonal palette and maximum
 * starting tone.
 *
 * @param tonalPalette The tonal palette to use.
 * @param maxTone The maximum starting tone.
 */
function dimTone(tonalPalette: TonalPalette, maxTone: number): number {
  const initialTone = Math.min(mainTone(tonalPalette, maxTone) - 5.0, maxTone);
  const endingTone = DynamicColor.foregroundTone(25.0, /* ratio= */ 4.5);
  return findDesiredChromaByTone(
      tonalPalette.hue, tonalPalette.chroma, initialTone, endingTone);
}

/**
 * Returns the Watch container accent tone for a given tonal palette and maximum
 * starting tone.
 *
 * @param tonalPalette The tonal palette to use.
 * @param maxTone The maximum starting tone.
 */
function containerTone(tonalPalette: TonalPalette, maxTone: number): number {
  const initialTone = Math.min(dimTone(tonalPalette, maxTone) - 5.0, maxTone);
  const endingTone = DynamicColor.foregroundTone(0.0, /* ratio= */ 7.0);
  return findDesiredChromaByTone(
      tonalPalette.hue, tonalPalette.chroma, initialTone, endingTone);
}

/**
 * Returns the contrast curve for a given default contrast.
 *
 * @param defaultContrast The default contrast to use.
 */
function getCurve(defaultContrast: number): ContrastCurve {
  if (defaultContrast === 1.5) {
    return new ContrastCurve(1.5, 1.5, 3, 5.5);
  } else if (defaultContrast === 3) {
    return new ContrastCurve(3, 3, 4.5, 7);
  } else if (defaultContrast === 4.5) {
    return new ContrastCurve(4.5, 4.5, 7, 11);
  } else if (defaultContrast === 6) {
    return new ContrastCurve(6, 6, 7, 11);
  } else if (defaultContrast === 7) {
    return new ContrastCurve(7, 7, 11, 21);
  } else if (defaultContrast === 9) {
    return new ContrastCurve(9, 9, 11, 21);
  } else if (defaultContrast === 11) {
    return new ContrastCurve(11, 11, 21, 21);
  } else if (defaultContrast === 21) {
    return new ContrastCurve(21, 21, 21, 21);
  } else {
    // Shouldn't happen.
    return new ContrastCurve(defaultContrast, defaultContrast, 7, 21);
  }
}

/**
 * A delegate for the dynamic color spec of a DynamicScheme in the 2025 spec.
 */
export class ColorSpecDelegateImpl2025 extends ColorSpecDelegateImpl2021 {
  ////////////////////////////////////////////////////////////////
  // Surfaces [S]                                               //
  ////////////////////////////////////////////////////////////////

  override surface(): DynamicColor {
    const color2025: DynamicColor = DynamicColor.fromPalette({
      name: 'surface',
      palette: (s) => s.neutralPalette,
      tone: (s) => {
        super.surface().tone(s);
        if (s.platform === 'phone') {
          if (s.isDark) {
            return 4;
          } else {
            if (Hct.isYellow(s.neutralPalette.hue)) {
              return 99;
            } else if (s.variant === Variant.VIBRANT) {
              return 97;
            } else {
              return 98;
            }
          }
        } else {
          return 0;
        }
      },
      isBackground: true,
    });
    return extendSpecVersion(super.surface(), '2025', color2025);
  }

  override surfaceDim(): DynamicColor {
    const color2025: DynamicColor = DynamicColor.fromPalette({
      name: 'surface_dim',
      palette: (s) => s.neutralPalette,
      tone: (s) => {
        if (s.isDark || s.platform === 'watch') {
          return 4;
        } else {
          if (Hct.isYellow(s.neutralPalette.hue)) {
            return 90;
          } else if (s.variant === Variant.VIBRANT) {
            return 85;
          } else {
            return 87;
          }
        }
      },
      isBackground: true,
      chromaMultiplier: (s) => {
        if (!s.isDark && s.platform === 'phone') {
          if (s.variant === Variant.NEUTRAL) {
            return 2.5;
          } else if (s.variant === Variant.TONAL_SPOT) {
            return 1.7;
          } else if (s.variant === Variant.EXPRESSIVE) {
            return Hct.isYellow(s.neutralPalette.hue) ? 2.7 : 1.75;
          } else if (s.variant === Variant.VIBRANT) {
            return 1.36;
          }
        }
        return 1;
      },
    });
    return extendSpecVersion(super.surfaceDim(), '2025', color2025);
  }

  override surfaceBright(): DynamicColor {
    const color2025: DynamicColor = DynamicColor.fromPalette({
      name: 'surface_bright',
      palette: (s) => s.neutralPalette,
      tone: (s) => {
        if (s.isDark || s.platform === 'watch') {
          return 18;
        } else {
          if (Hct.isYellow(s.neutralPalette.hue)) {
            return 99;
          } else if (s.variant === Variant.VIBRANT) {
            return 97;
          } else {
            return 98;
          }
        }
      },
      isBackground: true,
      chromaMultiplier: (s) => {
        if (s.isDark || s.platform === 'watch') {
          if (s.variant === Variant.NEUTRAL) {
            return 2.5;
          } else if (s.variant === Variant.TONAL_SPOT) {
            return 1.7;
          } else if (s.variant === Variant.EXPRESSIVE) {
            return Hct.isYellow(s.neutralPalette.hue) ? 2.7 : 1.75;
          } else if (s.variant === Variant.VIBRANT) {
            return 1.36;
          }
        }
        return 1;
      },
    });
    return extendSpecVersion(super.surfaceBright(), '2025', color2025);
  }

  override surfaceContainerLowest(): DynamicColor {
    const color2025: DynamicColor = DynamicColor.fromPalette({
      name: 'surface_container_lowest',
      palette: (s) => s.neutralPalette,
      tone: (s) => (s.isDark || s.platform === 'watch') ? 0 : 100,
      isBackground: true,
    });
    return extendSpecVersion(super.surfaceContainerLowest(), '2025', color2025);
  }

  override surfaceContainerLow(): DynamicColor {
    const color2025: DynamicColor = DynamicColor.fromPalette({
      name: 'surface_container_low',
      palette: (s) => s.neutralPalette,
      tone: (s) => {
        if (s.platform === 'phone') {
          if (s.isDark) {
            return 6;
          } else {
            if (Hct.isYellow(s.neutralPalette.hue)) {
              return 98;
            } else if (s.variant === Variant.VIBRANT) {
              return 95;
            } else {
              return 96;
            }
          }
        } else {
          return 15;
        }
      },
      isBackground: true,
      chromaMultiplier: (s) => {
        if (s.platform === 'phone') {
          if (s.variant === Variant.NEUTRAL) {
            return 1.3;
          } else if (s.variant === Variant.TONAL_SPOT) {
            return 1.25;
          } else if (s.variant === Variant.EXPRESSIVE) {
            return Hct.isYellow(s.neutralPalette.hue) ? 1.3 : 1.15;
          } else if (s.variant === Variant.VIBRANT) {
            return 1.08;
          }
        }
        return 1;
      },
    });
    return extendSpecVersion(super.surfaceContainerLow(), '2025', color2025);
  }

  override surfaceContainer(): DynamicColor {
    const color2025: DynamicColor = DynamicColor.fromPalette({
      name: 'surface_container',
      palette: (s) => s.neutralPalette,
      tone: (s) => {
        if (s.platform === 'phone') {
          if (s.isDark) {
            return 9;
          } else {
            if (Hct.isYellow(s.neutralPalette.hue)) {
              return 96;
            } else if (s.variant === Variant.VIBRANT) {
              return 92;
            } else {
              return 94;
            }
          }
        } else {
          return 20;
        }
      },
      isBackground: true,
      chromaMultiplier: (s) => {
        if (s.platform === 'phone') {
          if (s.variant === Variant.NEUTRAL) {
            return 1.6;
          } else if (s.variant === Variant.TONAL_SPOT) {
            return 1.4;
          } else if (s.variant === Variant.EXPRESSIVE) {
            return Hct.isYellow(s.neutralPalette.hue) ? 1.6 : 1.3;
          } else if (s.variant === Variant.VIBRANT) {
            return 1.15;
          }
        }
        return 1;
      },
    });
    return extendSpecVersion(super.surfaceContainer(), '2025', color2025);
  }

  override surfaceContainerHigh(): DynamicColor {
    const color2025: DynamicColor = DynamicColor.fromPalette({
      name: 'surface_container_high',
      palette: (s) => s.neutralPalette,
      tone: (s) => {
        if (s.platform === 'phone') {
          if (s.isDark) {
            return 12;
          } else {
            if (Hct.isYellow(s.neutralPalette.hue)) {
              return 94;
            } else if (s.variant === Variant.VIBRANT) {
              return 90;
            } else {
              return 92;
            }
          }
        } else {
          return 25;
        }
      },
      isBackground: true,
      chromaMultiplier: (s) => {
        if (s.platform === 'phone') {
          if (s.variant === Variant.NEUTRAL) {
            return 1.9;
          } else if (s.variant === Variant.TONAL_SPOT) {
            return 1.5;
          } else if (s.variant === Variant.EXPRESSIVE) {
            return Hct.isYellow(s.neutralPalette.hue) ? 1.95 : 1.45;
          } else if (s.variant === Variant.VIBRANT) {
            return 1.22;
          }
        }
        return 1;
      },
    });
    return extendSpecVersion(super.surfaceContainerHigh(), '2025', color2025);
  }

  override surfaceContainerHighest(): DynamicColor {
    const color2025: DynamicColor = DynamicColor.fromPalette({
      name: 'surface_container_highest',
      palette: (s) => s.neutralPalette,
      tone: (s) => {
        if (s.isDark || s.platform === 'watch') {
          return 15;
        } else {
          if (Hct.isYellow(s.neutralPalette.hue)) {
            return 92;
          } else if (s.variant === Variant.VIBRANT) {
            return 88;
          } else {
            return 90;
          }
        }
      },
      isBackground: true,
      chromaMultiplier: (s) => {
        if (s.variant === Variant.NEUTRAL) {
          return 2.2;
        } else if (s.variant === Variant.TONAL_SPOT) {
          return 1.7;
        } else if (s.variant === Variant.EXPRESSIVE) {
          return Hct.isYellow(s.neutralPalette.hue) ? 2.3 : 1.6;
        } else if (s.variant === Variant.VIBRANT) {
          return 1.29;
        } else {  // default
          return 1;
        }
      },
    });
    return extendSpecVersion(
        super.surfaceContainerHighest(), '2025', color2025);
  }

  override onSurface(): DynamicColor {
    const color2025: DynamicColor = DynamicColor.fromPalette({
      name: 'on_surface',
      palette: (s) => s.neutralPalette,
      tone: (s) => {
        if (s.platform === 'phone' && s.variant === Variant.VIBRANT) {
          return tMaxC(s.neutralPalette, 0, 100, 1.1);
        } else {
          // For all other variants, the initial tone should be the default
          // tone, which is the same as the background color.
          return DynamicColor.getInitialToneFromBackground(
              (s) => s.platform === 'phone' ? this.highestSurface(s) :
                                              this.surfaceContainerHigh())(s);
        }
      },
      chromaMultiplier: (s) => {
        if (s.platform === 'phone') {
          if (s.variant === Variant.NEUTRAL) {
            return 2.2;
          } else if (s.variant === Variant.TONAL_SPOT) {
            return 1.7;
          } else if (s.variant === Variant.EXPRESSIVE) {
            return Hct.isYellow(s.neutralPalette.hue) ? (s.isDark ? 3.0 : 2.3) :
                                                        1.6;
          }
        }
        return 1;
      },
      background: (s) => s.platform === 'phone' ? this.highestSurface(s) :
                                                  this.surfaceContainerHigh(),
      contrastCurve: (s) => s.platform === 'phone' ?
          (s.isDark ? getCurve(11) : getCurve(9)) :
          new ContrastCurve(4.5, 9.0, 11.0, 21.0),
    });
    return extendSpecVersion(super.onSurface(), '2025', color2025);
  }

  override onSurfaceVariant(): DynamicColor {
    const color2025: DynamicColor = DynamicColor.fromPalette({
      name: 'on_surface_variant',
      palette: (s) =>
          s.platform === 'watch' ? s.neutralVariantPalette : s.neutralPalette,
      chromaMultiplier: (s) => {
        if (s.platform === 'phone') {
          if (s.variant === Variant.NEUTRAL) {
            return 2.2;
          } else if (s.variant === Variant.TONAL_SPOT) {
            return 1.7;
          } else if (s.variant === Variant.EXPRESSIVE) {
            return Hct.isYellow(s.neutralPalette.hue) ? (s.isDark ? 3.0 : 2.3) :
                                                        1.6;
          }
        }
        return 1;
      },
      background: (s) => s.platform === 'phone' ? this.highestSurface(s) :
                                                  this.surfaceContainerHigh(),
      contrastCurve: (s) => s.platform === 'phone' ?
          (s.isDark ? getCurve(6) : getCurve(4.5)) :
          new ContrastCurve(3.0, 7.0, 7.0, 11.0),
    });
    return extendSpecVersion(super.onSurfaceVariant(), '2025', color2025);
  }

  override outline(): DynamicColor {
    const color2025: DynamicColor = DynamicColor.fromPalette({
      name: 'outline',
      palette: (s) =>
          s.platform === 'watch' ? s.neutralVariantPalette : s.neutralPalette,
      chromaMultiplier: (s) => {
        if (s.platform === 'phone') {
          if (s.variant === Variant.NEUTRAL) {
            return 2.2;
          } else if (s.variant === Variant.TONAL_SPOT) {
            return 1.7;
          } else if (s.variant === Variant.EXPRESSIVE) {
            return Hct.isYellow(s.neutralPalette.hue) ? (s.isDark ? 3.0 : 2.3) :
                                                        1.6;
          }
        }
        return 1;
      },
      background: (s) => s.platform === 'phone' ? this.highestSurface(s) :
                                                  this.surfaceContainerHigh(),
      contrastCurve: (s) => s.platform === 'phone' ?
          getCurve(3) :
          new ContrastCurve(1.5, 4.5, 4.5, 7.0),
    });
    return extendSpecVersion(super.outline(), '2025', color2025);
  }

  override outlineVariant(): DynamicColor {
    const color2025: DynamicColor = DynamicColor.fromPalette({
      name: 'outline_variant',
      palette: (s) =>
          s.platform === 'watch' ? s.neutralVariantPalette : s.neutralPalette,
      chromaMultiplier: (s) => {
        if (s.platform === 'phone') {
          if (s.variant === Variant.NEUTRAL) {
            return 2.2;
          } else if (s.variant === Variant.TONAL_SPOT) {
            return 1.7;
          } else if (s.variant === Variant.EXPRESSIVE) {
            return Hct.isYellow(s.neutralPalette.hue) ? (s.isDark ? 3.0 : 2.3) :
                                                        1.6;
          }
        }
        return 1;
      },
      background: (s) => s.platform === 'phone' ? this.highestSurface(s) :
                                                  this.surfaceContainerHigh(),
      contrastCurve: (s) => s.platform === 'phone' ?
          getCurve(1.5) :
          new ContrastCurve(1.0, 3.0, 3.0, 4.5),
    });
    return extendSpecVersion(super.outlineVariant(), '2025', color2025);
  }

  override inverseSurface(): DynamicColor {
    const color2025: DynamicColor = DynamicColor.fromPalette({
      name: 'inverse_surface',
      palette: (s) => s.neutralPalette,
      tone: (s) => (s.isDark || s.platform === 'watch') ? 98 : 4,
      isBackground: true,
    });
    return extendSpecVersion(super.inverseSurface(), '2025', color2025);
  }

  override inverseOnSurface(): DynamicColor {
    const color2025: DynamicColor = DynamicColor.fromPalette({
      name: 'inverse_on_surface',
      palette: (s) => s.neutralPalette,
      background: (s) => this.inverseSurface(),
      contrastCurve: (s) => getCurve(7),
    });
    return extendSpecVersion(super.inverseOnSurface(), '2025', color2025);
  }

  ////////////////////////////////////////////////////////////////
  // Primaries [P]                                              //
  ////////////////////////////////////////////////////////////////

  override primary(): DynamicColor {
    const color2025: DynamicColor = DynamicColor.fromPalette({
      name: 'primary',
      palette: (s) => s.primaryPalette,
      tone: (s) => {
        if (s.platform === 'watch') {
          return s.variant === Variant.NEUTRAL ?
              90 :
              mainTone(
                  s.primaryPalette,
                  s.variant === Variant.TONAL_SPOT ? 90 : 100);
        } else if (s.variant === Variant.NEUTRAL) {
          return s.isDark ? 80 : 40;
        } else if (s.variant === Variant.TONAL_SPOT) {
          return s.isDark ? 80 : tMaxC(s.primaryPalette);
        } else if (s.variant === Variant.EXPRESSIVE) {
          return tMaxC(
              s.primaryPalette, 0,
              s.isDark ? (Hct.isCyan(s.primaryPalette.hue) ? 88 : 98) :
                         (Hct.isYellow(s.primaryPalette.hue) ? 25 : 98));
        } else {  // VIBRANT
          return tMaxC(
              s.primaryPalette, 0, Hct.isCyan(s.primaryPalette.hue) ? 88 : 98);
        }
      },
      isBackground: true,
      background: (s) => s.platform === 'phone' ? this.highestSurface(s) :
                                                  this.surfaceContainerHigh(),
      contrastCurve: (s) =>
          s.platform === 'phone' ? getCurve(4.5) : getCurve(7),
      toneDeltaPair: (s) => s.platform === 'phone' ?
          new ToneDeltaPair(
              this.primaryContainer(), this.primary(), 5, 'relative_lighter',
              true, 'farther') :
          undefined,
    });
    return extendSpecVersion(super.primary(), '2025', color2025);
  }

  override primaryDim(): DynamicColor {
    return DynamicColor.fromPalette({
      name: 'primary_dim',
      palette: (s) => s.primaryPalette,
      tone: (s) => {
        if (s.platform === 'watch') {
          return s.variant === Variant.NEUTRAL ?
              85 :
              dimTone(
                  s.primaryPalette,
                  s.variant === Variant.TONAL_SPOT ? 90 : 100);
        } else if (s.variant === Variant.NEUTRAL) {
          return 85;
        } else if (s.variant === Variant.TONAL_SPOT) {
          return tMaxC(s.primaryPalette, 0, 90);
        } else {
          return tMaxC(s.primaryPalette);
        }
      },
      isBackground: true,
      background: (s) => this.surfaceContainerHigh(),
      contrastCurve: (s) => s.platform === 'watch' ?
          new ContrastCurve(4.5, 4.5, 4.5, 4.5) :
          getCurve(4.5),
      toneDeltaPair: (s) => s.platform === 'watch' ?
          undefined :
          new ToneDeltaPair(
              this.primaryDim(), this.primary(), 5, 'darker', true, 'farther'),
    });
  }

  override onPrimary(): DynamicColor {
    const color2025: DynamicColor = DynamicColor.fromPalette({
      name: 'on_primary',
      palette: (s) => s.primaryPalette,
      background: (s) =>
          s.platform === 'phone' ? this.primary() : this.primaryDim(),
      contrastCurve: (s) => s.platform === 'phone' ? getCurve(6) : getCurve(7),
    });
    return extendSpecVersion(super.onPrimary(), '2025', color2025);
  }

  override primaryContainer(): DynamicColor {
    const color2025: DynamicColor = DynamicColor.fromPalette({
      name: 'primary_container',
      palette: (s) => s.primaryPalette,
      tone: (s) => {
        if (s.platform === 'watch') {
          return 30;
        } else if (s.variant === Variant.NEUTRAL) {
          return s.isDark ? 30 : 90;
        } else if (s.variant === Variant.TONAL_SPOT) {
          return s.isDark ? tMinC(s.primaryPalette, 35, 93) :
                            tMaxC(s.primaryPalette, 0, 90);
        } else if (s.variant === Variant.EXPRESSIVE) {
          return s.isDark ? tMinC(s.primaryPalette, 30, 93) :
                            tMaxC(
                                s.primaryPalette, 78,
                                Hct.isCyan(s.primaryPalette.hue) ? 88 : 90);
        } else {  // VIBRANT
          return s.isDark ? tMinC(s.primaryPalette, 66, 93) :
                            tMaxC(
                                s.primaryPalette, 66,
                                Hct.isCyan(s.primaryPalette.hue) ? 88 : 93);
        }
      },
      isBackground: true,
      background: (s) => s.platform === 'phone' ? this.highestSurface(s) :
                                                  this.surfaceContainerHigh(),
      toneDeltaPair: (s) => s.platform === 'phone' ?
          undefined :
          new ToneDeltaPair(
              this.primaryContainer(), this.primaryDim(), 10, 'darker', true,
              'farther'),
      contrastCurve: (s) => s.platform === 'phone' ?
          (s.contrastLevel > 0 ? getCurve(1.5) : undefined) :
          new ContrastCurve(1.0, 1.0, 3.0, 4.5),
    });
    return extendSpecVersion(super.primaryContainer(), '2025', color2025);
  }

  override onPrimaryContainer(): DynamicColor {
    const color2025: DynamicColor = DynamicColor.fromPalette({
      name: 'on_primary_container',
      palette: (s) => s.primaryPalette,
      background: (s) => this.primaryContainer(),
      contrastCurve: (s) => s.platform === 'phone' ?
          getCurve(6) :
          new ContrastCurve(3.0, 7.0, 7.0, 11.0),
    });
    return extendSpecVersion(super.onPrimaryContainer(), '2025', color2025);
  }

  override primaryFixed(): DynamicColor {
    const color2025: DynamicColor = DynamicColor.fromPalette({
      name: 'primary_fixed',
      palette: (s) => s.primaryPalette,
      tone: (s) => {
        if (s.platform === 'watch') {
          return s.variant === Variant.NEUTRAL ?
              90 :
              mainTone(
                  s.primaryPalette,
                  s.variant === Variant.TONAL_SPOT ? 90 : 100);
        }
        let tempS = Object.assign({}, s, {isDark: false, contrastLevel: 0});
        return this.primaryContainer().getTone(tempS);
      },
      isBackground: true,
      background: (s) => s.platform === 'phone' ? this.highestSurface(s) :
                                                  this.surfaceContainerHigh(),
      contrastCurve: (s) => s.platform === 'phone' ?
          (s.contrastLevel > 0 ? getCurve(1.5) : undefined) :
          new ContrastCurve(7.0, 7.0, 7.0, 7.0),
    });
    return extendSpecVersion(super.primaryFixed(), '2025', color2025);
  }

  override primaryFixedDim(): DynamicColor {
    const color2025: DynamicColor = DynamicColor.fromPalette({
      name: 'primary_fixed_dim',
      palette: (s) => s.primaryPalette,
      tone: (s) => s.platform === 'watch' ?
          (s.variant === Variant.NEUTRAL ?
               85 :
               dimTone(
                   s.primaryPalette,
                   s.variant === Variant.TONAL_SPOT ? 90 : 100)) :
          this.primaryFixed().getTone(s),
      isBackground: true,
      background: (s) =>
          s.platform === 'watch' ? this.surfaceContainerHigh() : undefined,
      contrastCurve: (s) => s.platform === 'watch' ?
          new ContrastCurve(4.5, 4.5, 4.5, 4.5) :
          undefined,
      toneDeltaPair: (s) => s.platform === 'watch' ?
          undefined :
          new ToneDeltaPair(
              this.primaryFixedDim(), this.primaryFixed(), 5, 'darker', true,
              'exact'),
    });
    return extendSpecVersion(super.primaryFixedDim(), '2025', color2025);
  }

  override onPrimaryFixed(): DynamicColor {
    const color2025: DynamicColor = DynamicColor.fromPalette({
      name: 'on_primary_fixed',
      palette: (s) => s.primaryPalette,
      background: (s) => this.primaryFixedDim(),
      secondBackground: (s) =>
          s.platform === 'watch' ? this.primaryFixed() : undefined,
      contrastCurve: (s) => s.platform === 'watch' ?
          new ContrastCurve(4.5, 7.0, 11.0, 21.0) :
          getCurve(7),
    });
    return extendSpecVersion(super.onPrimaryFixed(), '2025', color2025);
  }

  override onPrimaryFixedVariant(): DynamicColor {
    const color2025: DynamicColor = DynamicColor.fromPalette({
      name: 'on_primary_fixed_variant',
      palette: (s) => s.primaryPalette,
      tone: (s) => s.platform === 'watch' ?
          30 :
          DynamicColor.getInitialToneFromBackground(
              (scheme) => this.primaryFixedDim())(s),
      background: (s) => this.primaryFixedDim(),
      secondBackground: (s) =>
          s.platform === 'watch' ? this.primaryFixed() : undefined,
      contrastCurve: (s) => s.platform === 'watch' ?
          new ContrastCurve(3.0, 4.5, 7.0, 11.0) :
          getCurve(4.5),
    });
    return extendSpecVersion(super.onPrimaryFixedVariant(), '2025', color2025);
  }

  override inversePrimary(): DynamicColor {
    const color2025: DynamicColor = DynamicColor.fromPalette({
      name: 'inverse_primary',
      palette: (s) => s.primaryPalette,
      tone: (s) => tMaxC(s.primaryPalette),
      background: (s) => this.inverseSurface(),
      contrastCurve: (s) => s.platform === 'phone' ? getCurve(6) : getCurve(7),
    });
    return extendSpecVersion(super.inversePrimary(), '2025', color2025);
  }

  ////////////////////////////////////////////////////////////////
  // Secondaries [Q]                                            //
  ////////////////////////////////////////////////////////////////

  override secondary(): DynamicColor {
    const color2025: DynamicColor = DynamicColor.fromPalette({
      name: 'secondary',
      palette: (s) => s.secondaryPalette,
      tone: (s) => {
        if (s.platform === 'watch') {
          return s.variant === Variant.NEUTRAL ?
              90 :
              mainTone(s.secondaryPalette, 90);
        } else if (s.variant === Variant.NEUTRAL) {
          return s.isDark ? tMinC(s.secondaryPalette, 0, 98) :
                            tMaxC(s.secondaryPalette);
        } else if (s.variant === Variant.VIBRANT) {
          return tMaxC(s.secondaryPalette, 0, s.isDark ? 90 : 98);
        } else {  // EXPRESSIVE and TONAL_SPOT
          return s.isDark ? 80 : tMaxC(s.secondaryPalette);
        }
      },
      isBackground: true,
      background: (s) => s.platform === 'phone' ? this.highestSurface(s) :
                                                  this.surfaceContainerHigh(),
      contrastCurve: (s) =>
          s.platform === 'phone' ? getCurve(4.5) : getCurve(7),
      toneDeltaPair: (s) => s.platform === 'phone' ?
          new ToneDeltaPair(
              this.secondaryContainer(), this.secondary(), 5,
              'relative_lighter', true, 'farther') :
          undefined,
    });
    return extendSpecVersion(super.secondary(), '2025', color2025);
  }

  override secondaryDim(): DynamicColor {
    return DynamicColor.fromPalette({
      name: 'secondary_dim',
      palette: (s) => s.secondaryPalette,
      tone: (s) => {
        if (s.platform === 'watch') {
          return s.variant === Variant.NEUTRAL ?
              85 :
              dimTone(s.secondaryPalette, 90);
        } else if (s.variant === Variant.NEUTRAL) {
          return 85;
        } else {
          return tMaxC(s.secondaryPalette, 0, 90);
        }
      },
      isBackground: true,
      background: (s) => this.surfaceContainerHigh(),
      contrastCurve: (s) => s.platform === 'watch' ?
          new ContrastCurve(4.5, 4.5, 4.5, 4.5) :
          getCurve(4.5),
      toneDeltaPair: (s) => s.platform === 'watch' ?
          undefined :
          new ToneDeltaPair(
              this.secondaryDim(), this.secondary(), 5, 'darker', true,
              'farther'),
    });
  }

  override onSecondary(): DynamicColor {
    const color2025: DynamicColor = DynamicColor.fromPalette({
      name: 'on_secondary',
      palette: (s) => s.secondaryPalette,
      background: (s) =>
          s.platform === 'phone' ? this.secondary() : this.secondaryDim(),
      contrastCurve: (s) => s.platform === 'phone' ? getCurve(6) : getCurve(7),
    });
    return extendSpecVersion(super.onSecondary(), '2025', color2025);
  }

  override secondaryContainer(): DynamicColor {
    const color2025: DynamicColor = DynamicColor.fromPalette({
      name: 'secondary_container',
      palette: (s) => s.secondaryPalette,
      tone: (s) => {
        if (s.platform === 'watch') {
          return 30;
        } else if (s.variant === Variant.VIBRANT) {
          return s.isDark ? tMinC(s.secondaryPalette, 30, 40) :
                            tMaxC(s.secondaryPalette, 84, 90);
        } else if (s.variant === Variant.EXPRESSIVE) {
          return s.isDark ? 15 : tMaxC(s.secondaryPalette, 90, 95);
        } else {
          return s.isDark ? 25 : 90;
        }
      },
      isBackground: true,
      background: (s) => s.platform === 'phone' ? this.highestSurface(s) :
                                                  this.surfaceContainerHigh(),
      toneDeltaPair: (s) => s.platform === 'watch' ?
          new ToneDeltaPair(
              this.secondaryContainer(), this.secondaryDim(), 10, 'darker',
              true, 'farther') :
          undefined,
      contrastCurve: (s) => s.platform === 'phone' ?
          (s.contrastLevel > 0 ? getCurve(1.5) : undefined) :
          new ContrastCurve(1.0, 1.0, 3.0, 4.5),
    });
    return extendSpecVersion(super.secondaryContainer(), '2025', color2025);
  }

  override onSecondaryContainer(): DynamicColor {
    const color2025: DynamicColor = DynamicColor.fromPalette({
      name: 'on_secondary_container',
      palette: (s) => s.secondaryPalette,
      background: (s) => this.secondaryContainer(),
      contrastCurve: (s) => s.platform === 'phone' ?
          getCurve(6) :
          new ContrastCurve(3.0, 7.0, 7.0, 11.0),
    });
    return extendSpecVersion(super.onSecondaryContainer(), '2025', color2025);
  }

  override secondaryFixed(): DynamicColor {
    const color2025: DynamicColor = DynamicColor.fromPalette({
      name: 'secondary_fixed',
      palette: (s) => s.secondaryPalette,
      tone: (s) => {
        if (s.platform === 'watch') {
          return s.variant === Variant.NEUTRAL ?
              90 :
              mainTone(s.secondaryPalette, 90);
        }
        let tempS = Object.assign({}, s, {isDark: false, contrastLevel: 0});
        return this.secondaryContainer().getTone(tempS);
      },
      isBackground: true,
      background: (s) => s.platform === 'phone' ? this.highestSurface(s) :
                                                  this.surfaceContainerHigh(),
      contrastCurve: (s) => s.platform === 'phone' ?
          (s.contrastLevel > 0 ? getCurve(1.5) : undefined) :
          new ContrastCurve(7.0, 7.0, 7.0, 7.0),
    });
    return extendSpecVersion(super.secondaryFixed(), '2025', color2025);
  }

  override secondaryFixedDim(): DynamicColor {
    const color2025: DynamicColor = DynamicColor.fromPalette({
      name: 'secondary_fixed_dim',
      palette: (s) => s.secondaryPalette,
      tone: (s) => s.platform === 'watch' ?
          (s.variant === Variant.NEUTRAL ? 85 :
                                           dimTone(s.secondaryPalette, 90)) :
          this.secondaryFixed().getTone(s),
      isBackground: true,
      background: (s) =>
          s.platform === 'watch' ? this.surfaceContainerHigh() : undefined,
      contrastCurve: (s) => s.platform === 'watch' ?
          new ContrastCurve(4.5, 4.5, 4.5, 4.5) :
          undefined,
      toneDeltaPair: (s) => s.platform === 'watch' ?
          undefined :
          new ToneDeltaPair(
              this.secondaryFixedDim(), this.secondaryFixed(), 5, 'darker',
              true, 'exact'),
    });
    return extendSpecVersion(super.secondaryFixedDim(), '2025', color2025);
  }

  override onSecondaryFixed(): DynamicColor {
    const color2025: DynamicColor = DynamicColor.fromPalette({
      name: 'on_secondary_fixed',
      palette: (s) => s.secondaryPalette,
      background: (s) => this.secondaryFixedDim(),
      secondBackground: (s) =>
          s.platform === 'watch' ? this.secondaryFixed() : undefined,
      contrastCurve: (s) => s.platform === 'watch' ?
          new ContrastCurve(4.5, 7.0, 11.0, 21.0) :
          getCurve(7),
    });
    return extendSpecVersion(super.onSecondaryFixed(), '2025', color2025);
  }

  override onSecondaryFixedVariant(): DynamicColor {
    const color2025: DynamicColor = DynamicColor.fromPalette({
      name: 'on_secondary_fixed_variant',
      palette: (s) => s.secondaryPalette,
      tone: (s) => s.platform === 'watch' ?
          30 :
          DynamicColor.getInitialToneFromBackground(
              (scheme) => this.secondaryFixedDim())(s),
      background: (s) => this.secondaryFixedDim(),
      secondBackground: (s) =>
          s.platform === 'watch' ? this.secondaryFixed() : undefined,
      contrastCurve: (s) => s.platform === 'watch' ?
          new ContrastCurve(3.0, 4.5, 7.0, 11.0) :
          getCurve(4.5),
    });
    return extendSpecVersion(
        super.onSecondaryFixedVariant(), '2025', color2025);
  }

  ////////////////////////////////////////////////////////////////
  // Tertiaries [T]                                             //
  ////////////////////////////////////////////////////////////////

  override tertiary(): DynamicColor {
    const color2025: DynamicColor = DynamicColor.fromPalette({
      name: 'tertiary',
      palette: (s) => s.tertiaryPalette,
      tone: (s) => {
        if (s.platform === 'watch') {
          return mainTone(
              s.tertiaryPalette, s.variant === Variant.TONAL_SPOT ? 90 : 100);
        } else if (
            s.variant === Variant.EXPRESSIVE || s.variant === Variant.VIBRANT) {
          return tMaxC(
              s.tertiaryPalette, 0,
              Hct.isCyan(s.tertiaryPalette.hue) ? 88 : (s.isDark ? 98 : 100));
        } else {  // NEUTRAL and TONAL_SPOT
          return s.isDark ? tMaxC(s.tertiaryPalette, 0, 98) :
                            tMaxC(s.tertiaryPalette);
        }
      },
      isBackground: true,
      background: (s) => s.platform === 'phone' ? this.highestSurface(s) :
                                                  this.surfaceContainerHigh(),
      contrastCurve: (s) =>
          s.platform === 'phone' ? getCurve(4.5) : getCurve(7),
      toneDeltaPair: (s) => s.platform === 'phone' ?
          new ToneDeltaPair(
              this.tertiaryContainer(), this.tertiary(), 5, 'relative_lighter',
              true, 'farther') :
          undefined,
    });
    return extendSpecVersion(super.tertiary(), '2025', color2025);
  }

  override tertiaryDim(): DynamicColor {
    return DynamicColor.fromPalette({
      name: 'tertiary_dim',
      palette: (s) => s.tertiaryPalette,
      tone: (s) => {
        if (s.platform === 'watch') {
          return dimTone(
              s.tertiaryPalette, s.variant === Variant.TONAL_SPOT ? 90 : 100);
        } else if (s.variant === Variant.TONAL_SPOT) {
          return tMaxC(s.tertiaryPalette, 0, 90);
        } else {
          return tMaxC(s.tertiaryPalette);
        }
      },
      isBackground: true,
      background: (s) => this.surfaceContainerHigh(),
      contrastCurve: (s) => s.platform === 'watch' ?
          new ContrastCurve(4.5, 4.5, 4.5, 4.5) :
          getCurve(4.5),
      toneDeltaPair: (s) => s.platform === 'watch' ?
          undefined :
          new ToneDeltaPair(
              this.tertiaryDim(), this.tertiary(), 5, 'darker', true,
              'farther'),
    });
  }

  override onTertiary(): DynamicColor {
    const color2025: DynamicColor = DynamicColor.fromPalette({
      name: 'on_tertiary',
      palette: (s) => s.tertiaryPalette,
      background: (s) =>
          s.platform === 'phone' ? this.tertiary() : this.tertiaryDim(),
      contrastCurve: (s) => s.platform === 'phone' ? getCurve(6) : getCurve(7),
    });
    return extendSpecVersion(super.onTertiary(), '2025', color2025);
  }

  override tertiaryContainer(): DynamicColor {
    const color2025: DynamicColor = DynamicColor.fromPalette({
      name: 'tertiary_container',
      palette: (s) => s.tertiaryPalette,
      tone: (s) => {
        if (s.platform === 'watch') {
          return containerTone(
              s.tertiaryPalette, s.variant === Variant.TONAL_SPOT ? 90 : 100);
        } else {
          if (s.variant === Variant.NEUTRAL) {
            return s.isDark ? tMaxC(s.tertiaryPalette, 0, 93) :
                              tMaxC(s.tertiaryPalette, 0, 96);
          } else if (s.variant === Variant.TONAL_SPOT) {
            return tMaxC(s.tertiaryPalette, 0, s.isDark ? 93 : 100);
          } else if (s.variant === Variant.EXPRESSIVE) {
            return tMaxC(
                s.tertiaryPalette, 75,
                Hct.isCyan(s.tertiaryPalette.hue) ? 88 : (s.isDark ? 93 : 100));
          } else {  // VIBRANT
            return s.isDark ? tMaxC(s.tertiaryPalette, 0, 93) :
                              tMaxC(s.tertiaryPalette, 72, 100);
          }
        }
      },
      isBackground: true,
      background: (s) => s.platform === 'phone' ? this.highestSurface(s) :
                                                  this.surfaceContainerHigh(),
      contrastCurve: (s) => s.platform === 'phone' ?
          (s.contrastLevel > 0 ? getCurve(1.5) : undefined) :
          new ContrastCurve(1.0, 1.0, 3.0, 4.5),
    });
    return extendSpecVersion(super.tertiaryContainer(), '2025', color2025);
  }

  override onTertiaryContainer(): DynamicColor {
    const color2025: DynamicColor = DynamicColor.fromPalette({
      name: 'on_tertiary_container',
      palette: (s) => s.tertiaryPalette,
      background: (s) => this.tertiaryContainer(),
      contrastCurve: (s) => s.platform === 'phone' ?
          getCurve(6) :
          new ContrastCurve(3.0, 7.0, 7.0, 11.0),
    });
    return extendSpecVersion(super.onTertiaryContainer(), '2025', color2025);
  }

  override tertiaryFixed(): DynamicColor {
    const color2025: DynamicColor = DynamicColor.fromPalette({
      name: 'tertiary_fixed',
      palette: (s) => s.tertiaryPalette,
      tone: (s) => {
        if (s.platform === 'watch') {
          return mainTone(
              s.tertiaryPalette, s.variant === Variant.TONAL_SPOT ? 90 : 100);
        }
        let tempS = Object.assign({}, s, {isDark: false, contrastLevel: 0});
        return this.tertiaryContainer().getTone(tempS);
      },
      isBackground: true,
      background: (s) => s.platform === 'phone' ? this.highestSurface(s) :
                                                  this.surfaceContainerHigh(),
      contrastCurve: (s) => s.platform === 'phone' ?
          (s.contrastLevel > 0 ? getCurve(1.5) : undefined) :
          new ContrastCurve(7.0, 7.0, 7.0, 7.0),
    });
    return extendSpecVersion(super.tertiaryFixed(), '2025', color2025);
  }

  override tertiaryFixedDim(): DynamicColor {
    const color2025: DynamicColor = DynamicColor.fromPalette({
      name: 'tertiary_fixed_dim',
      palette: (s) => s.tertiaryPalette,
      tone: (s) => s.platform === 'watch' ?
          dimTone(
              s.tertiaryPalette, s.variant === Variant.TONAL_SPOT ? 90 : 100) :
          this.tertiaryFixed().getTone(s),
      isBackground: true,
      background: (s) =>
          s.platform === 'watch' ? this.surfaceContainerHigh() : undefined,
      contrastCurve: (s) => s.platform === 'watch' ?
          new ContrastCurve(4.5, 4.5, 4.5, 4.5) :
          undefined,
      toneDeltaPair: (s) => s.platform === 'watch' ?
          undefined :
          new ToneDeltaPair(
              this.tertiaryFixedDim(), this.tertiaryFixed(), 5, 'darker', true,
              'exact'),
    });
    return extendSpecVersion(super.tertiaryFixedDim(), '2025', color2025);
  }

  override onTertiaryFixed(): DynamicColor {
    const color2025: DynamicColor = DynamicColor.fromPalette({
      name: 'on_tertiary_fixed',
      palette: (s) => s.tertiaryPalette,
      background: (s) => this.tertiaryFixedDim(),
      secondBackground: (s) =>
          s.platform === 'watch' ? this.tertiaryFixed() : undefined,
      contrastCurve: (s) => s.platform === 'watch' ?
          new ContrastCurve(4.5, 7.0, 11.0, 21.0) :
          getCurve(7),
    });
    return extendSpecVersion(super.onTertiaryFixed(), '2025', color2025);
  }

  override onTertiaryFixedVariant(): DynamicColor {
    const color2025: DynamicColor = DynamicColor.fromPalette({
      name: 'on_tertiary_fixed_variant',
      palette: (s) => s.tertiaryPalette,
      tone: (s) => s.platform === 'watch' ?
          30 :
          DynamicColor.getInitialToneFromBackground(
              (scheme) => this.tertiaryFixedDim())(s),
      background: (s) => this.tertiaryFixedDim(),
      secondBackground: (s) =>
          s.platform === 'watch' ? this.tertiaryFixed() : undefined,
      contrastCurve: (s) => s.platform === 'watch' ?
          new ContrastCurve(3.0, 4.5, 7.0, 11.0) :
          getCurve(4.5),
    });
    return extendSpecVersion(super.onTertiaryFixedVariant(), '2025', color2025);
  }

  ////////////////////////////////////////////////////////////////
  // Errors [E]                                                 //
  ////////////////////////////////////////////////////////////////

  override error(): DynamicColor {
    const color2025: DynamicColor = DynamicColor.fromPalette({
      name: 'error',
      palette: (s) => s.errorPalette,
      tone: (s) => {
        if (s.platform === 'phone') {
          return s.isDark ? tMinC(s.errorPalette, 0, 98) :
                            tMaxC(s.errorPalette);
        } else {
          const startingTone =
              DynamicColor.foregroundTone(25.0, /* ratio= */ 7.0);
          return findDesiredChromaByTone(
              s.errorPalette.hue, s.errorPalette.chroma, startingTone, 100.0);
        }
      },
      isBackground: true,
      background: (s) => s.platform === 'phone' ? this.highestSurface(s) :
                                                  this.surfaceContainerHigh(),
      contrastCurve: (s) => s.platform === 'phone' ?
          getCurve(4.5) :
          new ContrastCurve(3.0, 7.0, 7.0, 7.0),
      toneDeltaPair: (s) => s.platform === 'phone' ?
          new ToneDeltaPair(
              this.errorContainer(), this.error(), 5, 'relative_lighter', true,
              'farther') :
          undefined,
    });
    return extendSpecVersion(super.error(), '2025', color2025);
  }

  override errorDim(): DynamicColor {
    return DynamicColor.fromPalette({
      name: 'error_dim',
      palette: (s) => s.errorPalette,
      tone: (s) => tMinC(s.errorPalette),
      isBackground: true,
      background: (s) => this.surfaceContainerHigh(),
      contrastCurve: (s) => getCurve(4.5),
      toneDeltaPair: (s) => new ToneDeltaPair(
          this.errorDim(), this.error(), 5, 'darker', true, 'farther'),
    });
  }

  override onError(): DynamicColor {
    const color2025: DynamicColor = DynamicColor.fromPalette({
      name: 'on_error',
      palette: (s) => s.errorPalette,
      background: (s) =>
          s.platform === 'phone' ? this.error() : this.errorDim(),
      contrastCurve: (s) => s.platform === 'phone' ?
          getCurve(6) :
          new ContrastCurve(4.5, 7.0, 11.0, 21.0),
    });
    return extendSpecVersion(super.onError(), '2025', color2025);
  }

  override errorContainer(): DynamicColor {
    const color2025: DynamicColor = DynamicColor.fromPalette({
      name: 'error_container',
      palette: (s) => s.errorPalette,
      tone: (s) => {
        if (s.platform === 'watch') {
          return 30;
        } else {
          return s.isDark ? tMinC(s.errorPalette, 30, 93) :
                            tMaxC(s.errorPalette, 0, 90);
        }
      },
      isBackground: true,
      background: (s) => s.platform === 'phone' ? this.highestSurface(s) :
                                                  this.surfaceContainerHigh(),
      toneDeltaPair: (s) => s.platform === 'watch' ?
          new ToneDeltaPair(
              this.errorContainer(), this.errorDim(), 10, 'darker', true,
              'farther') :
          undefined,
      contrastCurve: (s) => s.platform === 'phone' ?
          (s.contrastLevel > 0 ? getCurve(1.5) : undefined) :
          new ContrastCurve(1.0, 1.0, 3.0, 4.5),
    });
    return extendSpecVersion(super.errorContainer(), '2025', color2025);
  }

  override onErrorContainer(): DynamicColor {
    const color2025: DynamicColor = DynamicColor.fromPalette({
      name: 'on_error_container',
      palette: (s) => s.errorPalette,
      background: (s) => this.errorContainer(),
      contrastCurve: (s) => s.platform === 'phone' ?
          getCurve(4.5) :
          new ContrastCurve(3.0, 7.0, 7.0, 11.0),
    });
    return extendSpecVersion(super.onErrorContainer(), '2025', color2025);
  }

  /////////////////////////////////////////////////////////////////
  // Remapped Colors                                             //
  /////////////////////////////////////////////////////////////////

  override surfaceVariant(): DynamicColor {
    const color2025: DynamicColor = Object.assign(
        this.surfaceContainerHighest().clone(), {name: 'surface_variant'});
    return extendSpecVersion(super.surfaceVariant(), '2025', color2025);
  }

  override surfaceTint(): DynamicColor {
    const color2025: DynamicColor =
        Object.assign(this.primary().clone(), {name: 'surface_tint'});
    return extendSpecVersion(super.surfaceTint(), '2025', color2025);
  }

  override background(): DynamicColor {
    const color2025: DynamicColor =
        Object.assign(this.surface().clone(), {name: 'background'});
    return extendSpecVersion(super.background(), '2025', color2025);
  }

  override onBackground(): DynamicColor {
    const color2025: DynamicColor = Object.assign(this.onSurface().clone(), {
      name: 'on_background',
      tone: (s: DynamicScheme) => {
        return s.platform === 'watch' ? 100.0 : this.onSurface().getTone(s);
      }
    });
    return extendSpecVersion(super.onBackground(), '2025', color2025);
  }
}
