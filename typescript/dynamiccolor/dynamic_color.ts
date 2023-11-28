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

import {Contrast} from '../contrast/contrast.js';
import {Hct} from '../hct/hct.js';
import {TonalPalette} from '../palettes/tonal_palette.js';
import {DynamicScheme} from '../scheme/dynamic_scheme.js';
import * as math from '../utils/math_utils.js';

import {ContrastCurve} from './contrast_curve.js';
import {ToneDeltaPair} from './tone_delta_pair.js';

/**
 * @param name The name of the dynamic color. Defaults to empty.
 * @param palette Function that provides a TonalPalette given
 * DynamicScheme. A TonalPalette is defined by a hue and chroma, so this
 * replaces the need to specify hue/chroma. By providing a tonal palette, when
 * contrast adjustments are made, intended chroma can be preserved.
 * @param tone Function that provides a tone given DynamicScheme.
 * @param isBackground Whether this dynamic color is a background, with
 * some other color as the foreground. Defaults to false.
 * @param background The background of the dynamic color (as a function of a
 *     `DynamicScheme`), if it exists.
 * @param secondBackground A second background of the dynamic color (as a
 *     function of a `DynamicScheme`), if it
 * exists.
 * @param contrastCurve A `ContrastCurve` object specifying how its contrast
 * against its background should behave in various contrast levels options.
 * @param toneDeltaPair A `ToneDeltaPair` object specifying a tone delta
 * constraint between two colors. One of them must be the color being
 * constructed.
 */
interface FromPaletteOptions {
  name?: string;
  palette: (scheme: DynamicScheme) => TonalPalette;
  tone: (scheme: DynamicScheme) => number;
  isBackground?: boolean;
  background?: (scheme: DynamicScheme) => DynamicColor;
  secondBackground?: (scheme: DynamicScheme) => DynamicColor;
  contrastCurve?: ContrastCurve;
  toneDeltaPair?: (scheme: DynamicScheme) => ToneDeltaPair;
}

/**
 * A color that adjusts itself based on UI state provided by DynamicScheme.
 *
 * Colors without backgrounds do not change tone when contrast changes. Colors
 * with backgrounds become closer to their background as contrast lowers, and
 * further when contrast increases.
 *
 * Prefer static constructors. They require either a hexcode, a palette and
 * tone, or a hue and chroma. Optionally, they can provide a background
 * DynamicColor.
 */
export class DynamicColor {
  private readonly hctCache = new Map<DynamicScheme, Hct>();

  /**
   * Create a DynamicColor defined by a TonalPalette and HCT tone.
   *
   * @param args Functions with DynamicScheme as input. Must provide a palette
   * and tone. May provide a background DynamicColor and ToneDeltaConstraint.
   */
  static fromPalette(args: FromPaletteOptions): DynamicColor {
    return new DynamicColor(
        args.name ?? '',
        args.palette,
        args.tone,
        args.isBackground ?? false,
        args.background,
        args.secondBackground,
        args.contrastCurve,
        args.toneDeltaPair,
    );
  }

  /**
   * The base constructor for DynamicColor.
   *
   * _Strongly_ prefer using one of the convenience constructors. This class is
   * arguably too flexible to ensure it can support any scenario. Functional
   * arguments allow  overriding without risks that come with subclasses.
   *
   * For example, the default behavior of adjust tone at max contrast
   * to be at a 7.0 ratio with its background is principled and
   * matches accessibility guidance. That does not mean it's the desired
   * approach for _every_ design system, and every color pairing,
   * always, in every case.
   *
   * @param name The name of the dynamic color. Defaults to empty.
   * @param palette Function that provides a TonalPalette given
   * DynamicScheme. A TonalPalette is defined by a hue and chroma, so this
   * replaces the need to specify hue/chroma. By providing a tonal palette, when
   * contrast adjustments are made, intended chroma can be preserved.
   * @param tone Function that provides a tone, given a DynamicScheme.
   * @param isBackground Whether this dynamic color is a background, with
   * some other color as the foreground. Defaults to false.
   * @param background The background of the dynamic color (as a function of a
   *     `DynamicScheme`), if it exists.
   * @param secondBackground A second background of the dynamic color (as a
   *     function of a `DynamicScheme`), if it
   * exists.
   * @param contrastCurve A `ContrastCurve` object specifying how its contrast
   * against its background should behave in various contrast levels options.
   * @param toneDeltaPair A `ToneDeltaPair` object specifying a tone delta
   * constraint between two colors. One of them must be the color being
   * constructed.
   */
  constructor(
      readonly name: string,
      readonly palette: (scheme: DynamicScheme) => TonalPalette,
      readonly tone: (scheme: DynamicScheme) => number,
      readonly isBackground: boolean,
      readonly background?: (scheme: DynamicScheme) => DynamicColor,
      readonly secondBackground?: (scheme: DynamicScheme) => DynamicColor,
      readonly contrastCurve?: ContrastCurve,
      readonly toneDeltaPair?: (scheme: DynamicScheme) => ToneDeltaPair,
  ) {
    if ((!background) && secondBackground) {
      throw new Error(
          `Color ${name} has secondBackground` +
          `defined, but background is not defined.`);
    }
    if ((!background) && contrastCurve) {
      throw new Error(
          `Color ${name} has contrastCurve` +
          `defined, but background is not defined.`);
    }
    if (background && !contrastCurve) {
      throw new Error(
          `Color ${name} has background` +
          `defined, but contrastCurve is not defined.`);
    }
  }

  /**
   * Return a ARGB integer (i.e. a hex code).
   *
   * @param scheme Defines the conditions of the user interface, for example,
   * whether or not it is dark mode or light mode, and what the desired
   * contrast level is.
   */
  getArgb(scheme: DynamicScheme): number {
    return this.getHct(scheme).toInt();
  }

  /**
   * Return a color, expressed in the HCT color space, that this
   * DynamicColor is under the conditions in scheme.
   *
   * @param scheme Defines the conditions of the user interface, for example,
   * whether or not it is dark mode or light mode, and what the desired
   * contrast level is.
   */
  getHct(scheme: DynamicScheme): Hct {
    const cachedAnswer = this.hctCache.get(scheme);
    if (cachedAnswer != null) {
      return cachedAnswer;
    }
    const tone = this.getTone(scheme);
    const answer = this.palette(scheme).getHct(tone);
    if (this.hctCache.size > 4) {
      this.hctCache.clear();
    }
    this.hctCache.set(scheme, answer);
    return answer;
  }

  /**
   * Return a tone, T in the HCT color space, that this DynamicColor is under
   * the conditions in scheme.
   *
   * @param scheme Defines the conditions of the user interface, for example,
   * whether or not it is dark mode or light mode, and what the desired
   * contrast level is.
   */
  getTone(scheme: DynamicScheme): number {
    const decreasingContrast = scheme.contrastLevel < 0;

    // Case 1: dual foreground, pair of colors with delta constraint.
    if (this.toneDeltaPair) {
      const toneDeltaPair = this.toneDeltaPair(scheme);
      const roleA = toneDeltaPair.roleA;
      const roleB = toneDeltaPair.roleB;
      const delta = toneDeltaPair.delta;
      const polarity = toneDeltaPair.polarity;
      const stayTogether = toneDeltaPair.stayTogether;

      const bg = this.background!(scheme);
      const bgTone = bg.getTone(scheme);

      const aIsNearer =
          (polarity === 'nearer' ||
           (polarity === 'lighter' && !scheme.isDark) ||
           (polarity === 'darker' && scheme.isDark));
      const nearer = aIsNearer ? roleA : roleB;
      const farther = aIsNearer ? roleB : roleA;
      const amNearer = this.name === nearer.name;
      const expansionDir = scheme.isDark ? 1 : -1;

      // 1st round: solve to min, each
      const nContrast = nearer.contrastCurve!.get(scheme.contrastLevel);
      const fContrast = farther.contrastCurve!.get(scheme.contrastLevel);

      // If a color is good enough, it is not adjusted.
      // Initial and adjusted tones for `nearer`
      const nInitialTone = nearer.tone(scheme);
      let nTone = Contrast.ratioOfTones(bgTone, nInitialTone) >= nContrast ?
          nInitialTone :
          DynamicColor.foregroundTone(bgTone, nContrast);
      // Initial and adjusted tones for `farther`
      const fInitialTone = farther.tone(scheme);
      let fTone = Contrast.ratioOfTones(bgTone, fInitialTone) >= fContrast ?
          fInitialTone :
          DynamicColor.foregroundTone(bgTone, fContrast);

      if (decreasingContrast) {
        // If decreasing contrast, adjust color to the "bare minimum"
        // that satisfies contrast.
        nTone = DynamicColor.foregroundTone(bgTone, nContrast);
        fTone = DynamicColor.foregroundTone(bgTone, fContrast);
      }

      if ((fTone - nTone) * expansionDir >= delta) {
        // Good! Tones satisfy the constraint; no change needed.
      } else {
        // 2nd round: expand farther to match delta.
        fTone = math.clampDouble(0, 100, nTone + delta * expansionDir);
        if ((fTone - nTone) * expansionDir >= delta) {
          // Good! Tones now satisfy the constraint; no change needed.
        } else {
          // 3rd round: contract nearer to match delta.
          nTone = math.clampDouble(0, 100, fTone - delta * expansionDir);
        }
      }

      // Avoids the 50-59 awkward zone.
      if (50 <= nTone && nTone < 60) {
        // If `nearer` is in the awkward zone, move it away, together with
        // `farther`.
        if (expansionDir > 0) {
          nTone = 60;
          fTone = Math.max(fTone, nTone + delta * expansionDir);
        } else {
          nTone = 49;
          fTone = Math.min(fTone, nTone + delta * expansionDir);
        }
      } else if (50 <= fTone && fTone < 60) {
        if (stayTogether) {
          // Fixes both, to avoid two colors on opposite sides of the "awkward
          // zone".
          if (expansionDir > 0) {
            nTone = 60;
            fTone = Math.max(fTone, nTone + delta * expansionDir);
          } else {
            nTone = 49;
            fTone = Math.min(fTone, nTone + delta * expansionDir);
          }
        } else {
          // Not required to stay together; fixes just one.
          if (expansionDir > 0) {
            fTone = 60;
          } else {
            fTone = 49;
          }
        }
      }

      // Returns `nTone` if this color is `nearer`, otherwise `fTone`.
      return amNearer ? nTone : fTone;
    }

    else {
      // Case 2: No contrast pair; just solve for itself.
      let answer = this.tone(scheme);

      if (this.background == null) {
        return answer;  // No adjustment for colors with no background.
      }

      const bgTone = this.background(scheme).getTone(scheme);

      const desiredRatio = this.contrastCurve!.get(scheme.contrastLevel);

      if (Contrast.ratioOfTones(bgTone, answer) >= desiredRatio) {
        // Don't "improve" what's good enough.
      } else {
        // Rough improvement.
        answer = DynamicColor.foregroundTone(bgTone, desiredRatio);
      }

      if (decreasingContrast) {
        answer = DynamicColor.foregroundTone(bgTone, desiredRatio);
      }

      if (this.isBackground && 50 <= answer && answer < 60) {
        // Must adjust
        if (Contrast.ratioOfTones(49, bgTone) >= desiredRatio) {
          answer = 49;
        } else {
          answer = 60;
        }
      }

      if (this.secondBackground) {
        // Case 3: Adjust for dual backgrounds.

        const [bg1, bg2] = [this.background, this.secondBackground];
        const [bgTone1, bgTone2] =
            [bg1(scheme).getTone(scheme), bg2(scheme).getTone(scheme)];
        const [upper, lower] =
            [Math.max(bgTone1, bgTone2), Math.min(bgTone1, bgTone2)];

        if (Contrast.ratioOfTones(upper, answer) >= desiredRatio &&
            Contrast.ratioOfTones(lower, answer) >= desiredRatio) {
          return answer;
        }

        // The darkest light tone that satisfies the desired ratio,
        // or -1 if such ratio cannot be reached.
        const lightOption = Contrast.lighter(upper, desiredRatio);

        // The lightest dark tone that satisfies the desired ratio,
        // or -1 if such ratio cannot be reached.
        const darkOption = Contrast.darker(lower, desiredRatio);

        // Tones suitable for the foreground.
        const availables = [];
        if (lightOption !== -1) availables.push(lightOption);
        if (darkOption !== -1) availables.push(darkOption);

        const prefersLight = DynamicColor.tonePrefersLightForeground(bgTone1) ||
            DynamicColor.tonePrefersLightForeground(bgTone2);
        if (prefersLight) {
          return (lightOption < 0) ? 100 : lightOption;
        }
        if (availables.length === 1) {
          return availables[0];
        }
        return (darkOption < 0) ? 0 : darkOption;
      }

      return answer;
    }
  }

  /**
   * Given a background tone, find a foreground tone, while ensuring they reach
   * a contrast ratio that is as close to [ratio] as possible.
   *
   * @param bgTone Tone in HCT. Range is 0 to 100, undefined behavior when it
   *     falls outside that range.
   * @param ratio The contrast ratio desired between bgTone and the return
   *     value.
   */
  static foregroundTone(bgTone: number, ratio: number): number {
    const lighterTone = Contrast.lighterUnsafe(bgTone, ratio);
    const darkerTone = Contrast.darkerUnsafe(bgTone, ratio);
    const lighterRatio = Contrast.ratioOfTones(lighterTone, bgTone);
    const darkerRatio = Contrast.ratioOfTones(darkerTone, bgTone);
    const preferLighter = DynamicColor.tonePrefersLightForeground(bgTone);

    if (preferLighter) {
      // This handles an edge case where the initial contrast ratio is high
      // (ex. 13.0), and the ratio passed to the function is that high
      // ratio, and both the lighter and darker ratio fails to pass that
      // ratio.
      //
      // This was observed with Tonal Spot's On Primary Container turning
      // black momentarily between high and max contrast in light mode. PC's
      // standard tone was T90, OPC's was T10, it was light mode, and the
      // contrast value was 0.6568521221032331.
      const negligibleDifference = Math.abs(lighterRatio - darkerRatio) < 0.1 &&
          lighterRatio < ratio && darkerRatio < ratio;
      return lighterRatio >= ratio || lighterRatio >= darkerRatio ||
              negligibleDifference ?
          lighterTone :
          darkerTone;
    } else {
      return darkerRatio >= ratio || darkerRatio >= lighterRatio ? darkerTone :
                                                                   lighterTone;
    }
  }

  /**
   * Returns whether [tone] prefers a light foreground.
   *
   * People prefer white foregrounds on ~T60-70. Observed over time, and also
   * by Andrew Somers during research for APCA.
   *
   * T60 used as to create the smallest discontinuity possible when skipping
   * down to T49 in order to ensure light foregrounds.
   * Since `tertiaryContainer` in dark monochrome scheme requires a tone of
   * 60, it should not be adjusted. Therefore, 60 is excluded here.
   */
  static tonePrefersLightForeground(tone: number): boolean {
    return Math.round(tone) < 60.0;
  }

  /**
   * Returns whether [tone] can reach a contrast ratio of 4.5 with a lighter
   * color.
   */
  static toneAllowsLightForeground(tone: number): boolean {
    return Math.round(tone) <= 49.0;
  }

  /**
   * Adjust a tone such that white has 4.5 contrast, if the tone is
   * reasonably close to supporting it.
   */
  static enableLightForeground(tone: number): number {
    if (DynamicColor.tonePrefersLightForeground(tone) &&
        !DynamicColor.toneAllowsLightForeground(tone)) {
      return 49.0;
    }
    return tone;
  }
}
