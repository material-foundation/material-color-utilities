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

import {Hct} from '../hct/hct.js';
import {TonalPalette} from '../palettes/tonal_palette.js';
import * as math from '../utils/math_utils.js';

import {DynamicColor} from './dynamic_color.js';
import {MaterialDynamicColors} from './material_dynamic_colors.js';
import {Variant} from './variant.js';

/**
 * @param sourceColorArgb The source color of the theme as an ARGB 32-bit
 *     integer.
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
interface DynamicSchemeOptions {
  sourceColorHct: Hct;
  variant: Variant;
  contrastLevel: number;
  isDark: boolean;
  primaryPalette: TonalPalette;
  secondaryPalette: TonalPalette;
  tertiaryPalette: TonalPalette;
  neutralPalette: TonalPalette;
  neutralVariantPalette: TonalPalette;
  errorPalette?: TonalPalette;
}

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

  /** The source color of the theme as an ARGB 32-bit integer. */
  readonly sourceColorArgb: number;

  /** The variant, or style, of the theme. */
  readonly variant: Variant;

  /**
   * Value from -1 to 1. -1 represents minimum contrast. 0 represents standard
   * (i.e. the design as spec'd), and 1 represents maximum contrast.
   */
  readonly contrastLevel: number;

  /** Whether the scheme is in dark mode or light mode. */
  readonly isDark: boolean;

  /**
   * Given a tone, produces a color. Hue and chroma of the
   * color are specified in the design specification of the variant. Usually
   * colorful.
   */
  readonly primaryPalette: TonalPalette;

  /**
   * Given a tone, produces a color. Hue and chroma of
   * the color are specified in the design specification of the variant. Usually
   * less colorful.
   */
  readonly secondaryPalette: TonalPalette;

  /**
   * Given a tone, produces a color. Hue and chroma of
   * the color are specified in the design specification of the variant. Usually
   * a different hue from primary and colorful.
   */
  readonly tertiaryPalette: TonalPalette;

  /**
   * Given a tone, produces a color. Hue and chroma of the
   * color are specified in the design specification of the variant. Usually not
   * colorful at all, intended for background & surface colors.
   */
  readonly neutralPalette: TonalPalette;

  /**
   * Given a tone, produces a color. Hue and chroma
   * of the color are specified in the design specification of the variant.
   * Usually not colorful, but slightly more colorful than Neutral. Intended for
   * backgrounds & surfaces.
   */
  readonly neutralVariantPalette: TonalPalette;

  constructor(args: DynamicSchemeOptions) {
    this.sourceColorArgb = args.sourceColorHct.toInt();
    this.variant = args.variant;
    this.contrastLevel = args.contrastLevel;
    this.isDark = args.isDark;
    this.sourceColorHct = args.sourceColorHct;
    this.primaryPalette = args.primaryPalette;
    this.secondaryPalette = args.secondaryPalette;
    this.tertiaryPalette = args.tertiaryPalette;
    this.neutralPalette = args.neutralPalette;
    this.neutralVariantPalette = args.neutralVariantPalette;
    this.errorPalette =
        args.errorPalette ?? TonalPalette.fromHueAndChroma(25.0, 84.0);
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
    for (let i = 0; i <= size - 2; i++) {
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


  getArgb(dynamicColor: DynamicColor): number {
    return dynamicColor.getArgb(this);
  }

  getHct(dynamicColor: DynamicColor): Hct {
    return dynamicColor.getHct(this);
  }

  get primaryPaletteKeyColor(): number {
    return this.getArgb(MaterialDynamicColors.primaryPaletteKeyColor);
  }

  get secondaryPaletteKeyColor(): number {
    return this.getArgb(MaterialDynamicColors.secondaryPaletteKeyColor);
  }

  get tertiaryPaletteKeyColor(): number {
    return this.getArgb(MaterialDynamicColors.tertiaryPaletteKeyColor);
  }

  get neutralPaletteKeyColor(): number {
    return this.getArgb(MaterialDynamicColors.neutralPaletteKeyColor);
  }

  get neutralVariantPaletteKeyColor(): number {
    return this.getArgb(MaterialDynamicColors.neutralVariantPaletteKeyColor);
  }

  get background(): number {
    return this.getArgb(MaterialDynamicColors.background);
  }

  get onBackground(): number {
    return this.getArgb(MaterialDynamicColors.onBackground);
  }

  get surface(): number {
    return this.getArgb(MaterialDynamicColors.surface);
  }

  get surfaceDim(): number {
    return this.getArgb(MaterialDynamicColors.surfaceDim);
  }

  get surfaceBright(): number {
    return this.getArgb(MaterialDynamicColors.surfaceBright);
  }

  get surfaceContainerLowest(): number {
    return this.getArgb(MaterialDynamicColors.surfaceContainerLowest);
  }

  get surfaceContainerLow(): number {
    return this.getArgb(MaterialDynamicColors.surfaceContainerLow);
  }

  get surfaceContainer(): number {
    return this.getArgb(MaterialDynamicColors.surfaceContainer);
  }

  get surfaceContainerHigh(): number {
    return this.getArgb(MaterialDynamicColors.surfaceContainerHigh);
  }

  get surfaceContainerHighest(): number {
    return this.getArgb(MaterialDynamicColors.surfaceContainerHighest);
  }

  get onSurface(): number {
    return this.getArgb(MaterialDynamicColors.onSurface);
  }

  get surfaceVariant(): number {
    return this.getArgb(MaterialDynamicColors.surfaceVariant);
  }

  get onSurfaceVariant(): number {
    return this.getArgb(MaterialDynamicColors.onSurfaceVariant);
  }

  get inverseSurface(): number {
    return this.getArgb(MaterialDynamicColors.inverseSurface);
  }

  get inverseOnSurface(): number {
    return this.getArgb(MaterialDynamicColors.inverseOnSurface);
  }

  get outline(): number {
    return this.getArgb(MaterialDynamicColors.outline);
  }

  get outlineVariant(): number {
    return this.getArgb(MaterialDynamicColors.outlineVariant);
  }

  get shadow(): number {
    return this.getArgb(MaterialDynamicColors.shadow);
  }

  get scrim(): number {
    return this.getArgb(MaterialDynamicColors.scrim);
  }

  get surfaceTint(): number {
    return this.getArgb(MaterialDynamicColors.surfaceTint);
  }

  get primary(): number {
    return this.getArgb(MaterialDynamicColors.primary);
  }

  get onPrimary(): number {
    return this.getArgb(MaterialDynamicColors.onPrimary);
  }

  get primaryContainer(): number {
    return this.getArgb(MaterialDynamicColors.primaryContainer);
  }

  get onPrimaryContainer(): number {
    return this.getArgb(MaterialDynamicColors.onPrimaryContainer);
  }

  get inversePrimary(): number {
    return this.getArgb(MaterialDynamicColors.inversePrimary);
  }

  get secondary(): number {
    return this.getArgb(MaterialDynamicColors.secondary);
  }

  get onSecondary(): number {
    return this.getArgb(MaterialDynamicColors.onSecondary);
  }

  get secondaryContainer(): number {
    return this.getArgb(MaterialDynamicColors.secondaryContainer);
  }

  get onSecondaryContainer(): number {
    return this.getArgb(MaterialDynamicColors.onSecondaryContainer);
  }

  get tertiary(): number {
    return this.getArgb(MaterialDynamicColors.tertiary);
  }

  get onTertiary(): number {
    return this.getArgb(MaterialDynamicColors.onTertiary);
  }

  get tertiaryContainer(): number {
    return this.getArgb(MaterialDynamicColors.tertiaryContainer);
  }

  get onTertiaryContainer(): number {
    return this.getArgb(MaterialDynamicColors.onTertiaryContainer);
  }

  get error(): number {
    return this.getArgb(MaterialDynamicColors.error);
  }

  get onError(): number {
    return this.getArgb(MaterialDynamicColors.onError);
  }

  get errorContainer(): number {
    return this.getArgb(MaterialDynamicColors.errorContainer);
  }

  get onErrorContainer(): number {
    return this.getArgb(MaterialDynamicColors.onErrorContainer);
  }

  get primaryFixed(): number {
    return this.getArgb(MaterialDynamicColors.primaryFixed);
  }

  get primaryFixedDim(): number {
    return this.getArgb(MaterialDynamicColors.primaryFixedDim);
  }

  get onPrimaryFixed(): number {
    return this.getArgb(MaterialDynamicColors.onPrimaryFixed);
  }

  get onPrimaryFixedVariant(): number {
    return this.getArgb(MaterialDynamicColors.onPrimaryFixedVariant);
  }

  get secondaryFixed(): number {
    return this.getArgb(MaterialDynamicColors.secondaryFixed);
  }

  get secondaryFixedDim(): number {
    return this.getArgb(MaterialDynamicColors.secondaryFixedDim);
  }

  get onSecondaryFixed(): number {
    return this.getArgb(MaterialDynamicColors.onSecondaryFixed);
  }

  get onSecondaryFixedVariant(): number {
    return this.getArgb(MaterialDynamicColors.onSecondaryFixedVariant);
  }

  get tertiaryFixed(): number {
    return this.getArgb(MaterialDynamicColors.tertiaryFixed);
  }

  get tertiaryFixedDim(): number {
    return this.getArgb(MaterialDynamicColors.tertiaryFixedDim);
  }

  get onTertiaryFixed(): number {
    return this.getArgb(MaterialDynamicColors.onTertiaryFixed);
  }

  get onTertiaryFixedVariant(): number {
    return this.getArgb(MaterialDynamicColors.onTertiaryFixedVariant);
  }
}
