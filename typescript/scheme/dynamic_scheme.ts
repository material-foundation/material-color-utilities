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

import {Hct} from '../hct/hct';
import {TonalPalette} from '../palettes/tonal_palette';
import * as math from '../utils/math_utils';

/**
 * Constructed by a set of values representing the current UI state (such as
 * whether or not its dark theme, what the theme style is, etc.), and
 * provides a set of TonalPalettes that can create colors that fit in
 * with the theme style. Used by DynamicColor to resolve into a color.
 */
export class DynamicScheme {
  /**
   * The source color of the theme as an HCT color.
   */
  sourceColorHct: Hct;
  /**
   * Given a tone, produces a reddish, colorful, color.
   */
  errorPalette: TonalPalette;
  /**
   * @param sourceColorArgb The source color of the theme as an ARGB integer.
   * @param variant The variant, or style, of the theme.
   * @param contrastLevel Value from -1 to 1. -1 represents minimum contrast,
   * 0 represents standard (i.e. the design as spec'd), and 1 represents maximum
   * contrast.
   * @param isDark Whether the scheme is in dark mode or light mode.
   * @param primaryPalette Given a tone, produces a color. Hue and chroma of the
   * color are specified in the design specification of the variant. Usually
   * colorful.
   * @param secondaryPalette Given a tone, produces a color. Hue and chroma of
   * the color are specified in the design specification of the variant. Usually
   * less colorful.
   * @param tertiaryPalette Given a tone, produces a color. Hue and chroma of
   * the color are specified in the design specification of the variant. Usually
   * a different hue from primary and colorful.
   * @param neutralPalette Given a tone, produces a color. Hue and chroma of the
   * color are specified in the design specification of the variant. Usually not
   * colorful at all, intended for background & surface colors.
   * @param neutralVariantPalette Given a tone, produces a color. Hue and chroma
   * of the color are specified in the design specification of the variant.
   * Usually not colorful, but slightly more colorful than Neutral. Intended for
   * backgrounds & surfaces.
   */
  constructor(
      readonly sourceColorArgb: number,
      readonly variant: Variant,
      readonly contrastLevel: number,
      readonly isDark: boolean,
      readonly primaryPalette: TonalPalette,
      readonly secondaryPalette: TonalPalette,
      readonly tertiaryPalette: TonalPalette,
      readonly neutralPalette: TonalPalette,
      readonly neutralVariantPalette: TonalPalette,
  ) {
    this.sourceColorArgb = sourceColorArgb;
    this.variant = variant;
    this.contrastLevel = contrastLevel;
    this.isDark = isDark;
    this.sourceColorHct = Hct.fromInt(sourceColorArgb);
    this.primaryPalette = primaryPalette;
    this.secondaryPalette = secondaryPalette;
    this.tertiaryPalette = tertiaryPalette;
    this.neutralPalette = neutralPalette;
    this.neutralVariantPalette = neutralVariantPalette;
    this.errorPalette = TonalPalette.fromHueAndChroma(25.0, 84.0);
  }

  /**
   * Support design spec'ing Dynamic Color by schemes that specify hue
   * rotations that should be applied at certain breakpoints.
   * @param sourceColor the source color of the theme, in HCT.
   * @param hues The "breakpoints", i.e. the hues at which a rotation should
   * be apply.
   * @param rotations The rotation that should be applied when source color's
   * hue is >= the same index in hues array, and <= the hue at the next index
   * in hues array.
   */
  static getRotatedHue(sourceColor: Hct, hues: number[], rotations: number[]):
      number {
    const sourceHue = sourceColor.hue;
    if (hues.length !== rotations.length) {
      throw new Error(`mismatch between hue length ${hues.length} & rotations ${
          rotations.length}`);
    }
    if (rotations.length === 1) {
      return math.sanitizeDegreesDouble(sourceColor.hue + rotations[0]);
    }
    const size = hues.length;
    for (let i = 0; i <= (size - 2); i++) {
      const thisHue = hues[i];
      const nextHue = hues[i + 1];
      if (thisHue < sourceHue && sourceHue < nextHue) {
        return math.sanitizeDegreesDouble(sourceHue + rotations[i]);
      }
    }
    // If this statement executes, something is wrong, there should have been a
    // rotation found using the arrays.
    return sourceHue;
  }
}