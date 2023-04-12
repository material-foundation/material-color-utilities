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

import {ToneDeltaConstraint} from './tone_delta_constraint.js';

/**
 * @param palette Function that provides a TonalPalette given
 * DynamicScheme. A TonalPalette is defined by a hue and chroma, so this
 * replaces the need to specify hue/chroma. By providing a tonal palette, when
 * contrast adjustments are made, intended chroma can be preserved.
 * @param tone Function that provides a tone given DynamicScheme. (useful
 * for dark vs. light mode)
 */
interface FromPaletteOptions extends BaseOptions {
  palette: (scheme: DynamicScheme) => TonalPalette;
  tone: (scheme: DynamicScheme) => number;
}

/**
 * @param hue Function with DynamicScheme input and HCT hue output.
 * @param chroma Function with DynamicScheme input and HCT chroma output.
 * @param tone Function with DynamicScheme input and HCT tone output.
 */
interface FromHueAndChromaOptions extends BaseOptions {
  hue: (scheme: DynamicScheme) => number;
  chroma: (scheme: DynamicScheme) => number;
  tone: (scheme: DynamicScheme) => number;
}

/**
 * @param argb Function with DynamicScheme input and ARGB/hex code output.
 * @param [tone=null] Function with DynamicScheme input and HCT tone output. If
 * provided, overrides tone of argb parameter.
 */
interface FromArgbOptions extends BaseOptions {
  argb: (scheme: DynamicScheme) => number;
  tone?: (scheme: DynamicScheme) => number;
}

/**
 * @param tone The tone standard.
 * @param scheme The scheme in which to adjust the tone.
 */
interface ToneContrastOptions extends BaseOptions {
  tone: (scheme: DynamicScheme) => number;
  scheme: DynamicScheme;
}

/**
 * @param [background=null] Function that provides background
 * DynamicColor given DynamicScheme. Useful for contrast, given a background,
 * colors can adjust to increase/decrease contrast.
 * @param [toneDeltaConstraint=null] Function that provides a
 * ToneDeltaConstraint given DynamicScheme. Useful for ensuring lightness
 * difference between colors that don't require contrast or have a formal
 * background/foreground relationship.
 */
interface BaseOptions {
  background?: (scheme: DynamicScheme) => DynamicColor;
  toneDeltaConstraint?: (scheme: DynamicScheme) => ToneDeltaConstraint;
}

/**
 * @param scheme Defines the conditions of the user interface, for example,
 * whether or not it is dark mode or light mode, and what the desired
 * contrast level is.
 * @param toneStandard Function with input of DynamicScheme that outputs the
 * tone to be used at default contrast.
 * @param toneToJudge Function with input of DynamicColor that outputs tone the
 * color is in the current UI state. Used to determine the tone of the
 * background.
 * @param desiredTone Function with inputs of contrast ratio with background at
 * default contrast and the background tone at current contrast level. Outputs
 * tone.
 * @param [background] Optional, function with input of DynamicScheme that
 * returns a DynamicColor that is the background of the color whose tone is
 * being calculated.
 * @param [constraint] Optional, function with input of DynamicScheme that
 * returns a ToneDeltaConstraint. If provided, the ToneDeltaConstraint is
 * enforced.
 * @param [minRatio] Optional, function with input of DynamicScheme that returns
 * the minimum contrast ratio between background and the color whose tone is
 * being calculated.
 * @param [maxRatio] Optional, function with input of DynamicScheme that returns
 * the maximum contrast ratio between background and the color whose tone is
 * being calculated.
 */
interface CalculateDynamicToneOptions {
  scheme: DynamicScheme;
  toneStandard: (scheme: DynamicScheme) => number;
  toneToJudge: (dynamicColor: DynamicColor) => number;
  desiredTone: (standardRatio: number, bgTone: number) => number;
  background?: (scheme: DynamicScheme) => DynamicColor;
  toneDeltaConstraint?: (scheme: DynamicScheme) => ToneDeltaConstraint;
  minRatio?: (scheme: number) => number;
  maxRatio?: (scheme: number) => number;
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
        (scheme) => args.palette(scheme).hue,
        (scheme) => args.palette(scheme).chroma, args.tone,
        (scheme) => DynamicColor.toneMinContrastDefault({
          tone: args.tone,
          scheme,
          background: args.background,
          toneDeltaConstraint: args.toneDeltaConstraint,
        }),
        (scheme) => DynamicColor.toneMaxContrastDefault({
          tone: args.tone,
          scheme,
          background: args.background,
          toneDeltaConstraint: args.toneDeltaConstraint,
        }),
        args.background, args.toneDeltaConstraint);
  }

  /**
   * Create a DynamicColor defined by a HCT hue, chroma, and tone.
   *
   * @param args Functions with DynamicScheme as input. Must provide hue,
   * chroma, and tone. May provide background DynamicColor and
   * ToneDeltaConstraint.
   */
  static fromHueAndChroma(args: FromHueAndChromaOptions): DynamicColor {
    return new DynamicColor(
        args.hue, args.chroma, args.tone,
        (scheme) => DynamicColor.toneMinContrastDefault({
          tone: args.tone,
          scheme,
          background: args.background,
          toneDeltaConstraint: args.toneDeltaConstraint,
        }),
        (scheme) => DynamicColor.toneMaxContrastDefault({
          tone: args.tone,
          scheme,
          background: args.background,
          toneDeltaConstraint: args.toneDeltaConstraint,
        }),
        args.background, args.toneDeltaConstraint);
  }

  /**
   * Create a DynamicColor from a ARGB color (hex code).
   *
   * @param args Functions with DynamicScheme as input. Must provide ARGB (hex
   * code). May provide tone that overrides hex code's, background DynamicColor,
   * and ToneDeltaConstraint.
   */
  static fromArgb(args: FromArgbOptions): DynamicColor {
    return new DynamicColor(
        (scheme) => {
          const hct = Hct.fromInt(args.argb(scheme));
          return hct.hue;
        },
        (scheme) => {
          const hct = Hct.fromInt(args.argb(scheme));
          return hct.chroma;
        },
        (scheme) => {
          return args.tone?.(scheme) ?? Hct.fromInt(args.argb(scheme)).tone;
        },
        (scheme) => {
          return DynamicColor.toneMinContrastDefault({
            tone: (scheme) =>
                args.tone?.(scheme) ?? Hct.fromInt(args.argb(scheme)).tone,
            scheme,
            background: args.background,
            toneDeltaConstraint: args.toneDeltaConstraint,
          });
        },
        (scheme) => {
          return DynamicColor.toneMaxContrastDefault({
            tone: (scheme) =>
                args.tone?.(scheme) ?? Hct.fromInt(args.argb(scheme)).tone,
            scheme,
            background: args.background,
            toneDeltaConstraint: args.toneDeltaConstraint,
          });
        },
        args.background, args.toneDeltaConstraint);
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
   * @param hue given DynamicScheme, return the hue in HCT of the output
   * color.
   * @param chroma given DynamicScheme, return chroma in HCT of the output
   * color.
   * @param tone given DynamicScheme, return tone in HCT of the output color.
   * This tone is used for standard contrast.
   * @param toneMinContrast given DynamicScheme, return tone in HCT this color
   * should be at minimum contrast. See toneMinContrastDefault for the default
   * behavior, and strongly consider using it unless you have strong opinions
   * on color and accessibility. The convenience constructors use it.
   * @param toneMaxContrast given DynamicScheme, return tone in HCT this color
   * should be at maximum contrast. See toneMaxContrastDefault for the default
   * behavior, and strongly consider using it unless you have strong opinions
   * on color and accessibility. The convenience constructors use it.
   * @param background given DynamicScheme, return the DynamicColor that is
   * the background of this DynamicColor. When this is provided,
   * automated adjustments to lower and raise contrast are made.
   * @param toneDeltaConstraint given DynamicScheme, return a
   * ToneDeltaConstraint that describes a requirement that this
   * DynamicColor must always have some difference in tone from another
   * DynamicColor.
   *
   * Unlikely to be useful unless a design system has some distortions
   * where colors that don't have a background/foreground relationship
   * don't want to have a formal relationship or a principled value for their
   * tone distance based on common contrast / tone delta values, yet, want
   * tone distance.
   */
  constructor(
      readonly hue: (scheme: DynamicScheme) => number,
      readonly chroma: (scheme: DynamicScheme) => number,
      readonly tone: (scheme: DynamicScheme) => number,
      readonly toneMinContrast: (scheme: DynamicScheme) => number,
      readonly toneMaxContrast: (scheme: DynamicScheme) => number,
      readonly background?: (scheme: DynamicScheme) => DynamicColor,
      readonly toneDeltaConstraint?:
          (scheme: DynamicScheme) => ToneDeltaConstraint) {}

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
    const answer =
        Hct.from(this.hue(scheme), this.chroma(scheme), this.getTone(scheme));
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
    let answer = this.tone(scheme);
    const decreasingContrast = scheme.contrastLevel < 0.0;
    if (scheme.contrastLevel !== 0.0) {
      const startTone = this.tone(scheme);
      const endTone = decreasingContrast ? this.toneMinContrast(scheme) :
                                           this.toneMaxContrast(scheme);
      const delta = (endTone - startTone) * Math.abs(scheme.contrastLevel);
      answer = delta + startTone;
    }

    const bg = this.background?.(scheme);
    let standardRatio: number|null;
    let minRatio: number|null;
    let maxRatio: number|null;
    if (bg != null) {
      const bgHasBg = bg?.background?.(scheme) != null;
      standardRatio = Contrast.ratioOfTones(this.tone(scheme), bg.tone(scheme));
      if (decreasingContrast) {
        const minContrastRatio = Contrast.ratioOfTones(
            this.toneMinContrast(scheme), bg.toneMinContrast(scheme));
        minRatio = bgHasBg ? minContrastRatio : null;
        maxRatio = standardRatio;
      } else {
        const maxContrastRatio = Contrast.ratioOfTones(
            this.toneMaxContrast(scheme), bg.toneMaxContrast(scheme));
        minRatio = bgHasBg ? Math.min(maxContrastRatio, standardRatio) : null;
        maxRatio = bgHasBg ? Math.max(maxContrastRatio, standardRatio) : null;
      }
    }

    answer = DynamicColor.calculateDynamicTone({
      scheme,
      toneStandard: this.tone,
      toneToJudge: (c) => c.getTone(scheme),
      desiredTone: (s, t) => answer,
      background: bg != null ? (s) => bg : undefined,
      toneDeltaConstraint: this.toneDeltaConstraint,
      minRatio: (s) => minRatio ?? 1.0,
      maxRatio: (s) => maxRatio ?? 21.0,
    });

    return answer;
  }

  /**
   * Enforce a ToneDeltaConstraint between two DynamicColors.
   *
   * @param tone The desired tone of the color.
   * @param toneStandard The tone of the color at standard contrast.
   * @param scheme Defines the conditions of the user interface, for example,
   * whether or not it is dark mode or light mode, and what the desired
   * contrast level is.
   * @param constraintProvider Given a DynamicScheme, return a
   * ToneDeltaConstraint or null.
   * @param toneToDistanceFrom Given a DynamicColor, return a tone that the
   * ToneDeltaConstraint should enforce a delta from.
   */
  static ensureToneDelta(
      tone: number, toneStandard: number, scheme: DynamicScheme,
      constraintProvider?: (scheme: DynamicScheme) => ToneDeltaConstraint |
          null,
      toneToDistanceFrom?: (color: DynamicColor) => number): number {
    const constraint = constraintProvider ? constraintProvider(scheme) : null;
    if (constraint == null || toneToDistanceFrom == null) {
      return tone;
    }

    const requiredDelta = constraint.delta;
    const keepAwayTone = toneToDistanceFrom(constraint.keepAway);
    const delta = Math.abs(tone - keepAwayTone);
    if (delta > requiredDelta) {
      return tone;
    }
    switch (constraint.keepAwayPolarity) {
      case 'darker':
        return math.clampDouble(0.0, 100.0, keepAwayTone + requiredDelta);
      case 'lighter':
        return math.clampDouble(0.0, 100.0, keepAwayTone - requiredDelta);

      case 'no-preference':
        const keepAwayToneStandard = constraint.keepAway.tone(scheme);
        const preferLighten = toneStandard > keepAwayToneStandard;
        const alterAmount = Math.abs(delta - requiredDelta);
        const lighten =
            preferLighten ? tone + alterAmount <= 100.0 : tone < alterAmount;
        return lighten ? tone + alterAmount : tone - alterAmount;

      default:
        return tone;
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
   * Core method for calculating a tone for under dynamic contrast.
   *
   * It calculates tone while enforcing these properties:
   * #1. Desired contrast ratio is reached.
   * #2. Darken to enable light foregrounds on midtones.
   * #3. Enforce tone delta constraint, if needed.
   */
  static calculateDynamicTone(args: CalculateDynamicToneOptions): number {
    const background = args.background;
    const scheme = args.scheme;
    const toneStandard = args.toneStandard;
    const toneToJudge = args.toneToJudge;
    const desiredTone = args.desiredTone;
    const minRatio = args.minRatio;
    const maxRatio = args.maxRatio;
    const toneDeltaConstraint = args.toneDeltaConstraint;

    // Start with the tone with no adjustment for contrast.
    // If there is no background, don't perform any adjustment, return
    // immediately.
    const toneStd = toneStandard(scheme);
    let answer = toneStd;
    const bgDynamic = background?.(scheme);
    if (bgDynamic == null) {
      return answer;
    }
    const bgToneStd = bgDynamic.tone(scheme);
    const stdRatio = Contrast.ratioOfTones(toneStd, bgToneStd);

    // If there is a background, determine its tone.
    // Then, calculate tone that ensures the desired contrast ratio is met.
    const bgTone = toneToJudge(bgDynamic);
    const myDesiredTone = desiredTone(stdRatio, bgTone);
    const currentRatio = Contrast.ratioOfTones(bgTone, myDesiredTone);
    const desiredRatio = math.clampDouble(
        minRatio?.(stdRatio) ?? 1.0, maxRatio?.(stdRatio) ?? 21.0,
        currentRatio);
    if (desiredRatio === currentRatio) {
      answer = myDesiredTone;
    } else {
      answer = DynamicColor.foregroundTone(bgTone, desiredRatio);
    }

    // If the background has no background, adjust calculated tone to ensure it
    // is dark enough to have a light foreground.
    if (bgDynamic.background?.(scheme) == null) {
      answer = DynamicColor.enableLightForeground(answer);
    }

    // If there is a tone delta constraint, enforce it.
    answer = DynamicColor.ensureToneDelta(
        answer, toneStd, scheme, toneDeltaConstraint, (c) => toneToJudge(c));

    return answer;
  }

  /**
   * Default algorithm for calculating the tone of a color at maximum contrast.
   *
   * If the color's background has a background, reach contrast 7.0.
   * If it doesn't, maintain the original contrast ratio.
   */
  static toneMaxContrastDefault(args: ToneContrastOptions): number {
    return DynamicColor.calculateDynamicTone({
      scheme: args.scheme,
      toneStandard: args.tone,
      toneToJudge: (c: DynamicColor) => c.toneMaxContrast(args.scheme),
      desiredTone: (stdRatio: number, bgTone: number) => {
        const backgroundHasBackground =
            args.background?.(args.scheme)?.background?.(args.scheme) != null;
        if (backgroundHasBackground) {
          return DynamicColor.foregroundTone(bgTone, 7.0);
        } else {
          return DynamicColor.foregroundTone(bgTone, Math.max(7.0, stdRatio));
        }
      },
      background: args.background,
      toneDeltaConstraint: args.toneDeltaConstraint,
    });
  }

  /**
   * Default algorithm for calculating the tone of a color at minimum contrast.
   *
   * If the original contrast ratio was >= 7.0, reach contrast 4.5.
   * If the original contrast ratio was >= 3.0, reach contrast 3.0.
   * If the original contrast ratio was < 3.0, reach that ratio.
   */
  static toneMinContrastDefault(args: ToneContrastOptions): number {
    return DynamicColor.calculateDynamicTone({
      scheme: args.scheme,
      toneStandard: args.tone,
      toneToJudge: (c: DynamicColor) => c.toneMinContrast(args.scheme),
      desiredTone: (stdRatio: number, bgTone: number) => {
        let answer: number = args.tone(args.scheme);
        if (stdRatio >= 7.0) {
          answer = DynamicColor.foregroundTone(bgTone, 4.5);
        } else if (stdRatio >= 3.0) {
          answer = DynamicColor.foregroundTone(bgTone, 3.0);
        } else {
          const backgroundHasBackground =
              args.background?.(args.scheme)?.background?.(args.scheme) != null;
          if (backgroundHasBackground) {
            answer = DynamicColor.foregroundTone(bgTone, stdRatio);
          }
        }
        return answer;
      },
      background: args.background,
      toneDeltaConstraint: args.toneDeltaConstraint,
      minRatio: (standardRatio: number) => 1.0,
      maxRatio: (standardRatio: number) => standardRatio,
    });
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
