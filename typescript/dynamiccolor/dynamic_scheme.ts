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
import {TonalPalette} from '../palettes/tonal_palette.js';
import {TemperatureCache} from '../temperature/temperature_cache.js';
import * as math from '../utils/math_utils.js';

import {SpecVersion} from './color_spec.js';
import {DynamicColor} from './dynamic_color.js';
import {MaterialDynamicColors} from './material_dynamic_colors.js';
import {Variant} from './variant.js';

/**
 * The platform on which this scheme is intended to be used. Only used in the
 * 2025 spec.
 */
export type Platform = 'phone'|'watch';

/**
 * @param sourceColorHct The primary source color of the theme as an HCT color.
 * @param sourceColorHcts The source colors of the theme as HCT colors.
 * @param variant The variant, or style, of the theme.
 * @param contrastLevel Value from -1 to 1. -1 represents minimum contrast, 0
 *     represents standard (i.e. the design as spec'd), and 1 represents maximum
 *     contrast.
 * @param isDark Whether the scheme is in dark mode or light mode.
 * @param platform The platform on which this scheme is intended to be used.
 * @param specVersion The version of the design spec that this scheme is based
 *     on.
 * @param primaryPalette Given a tone, produces a color. Hue and chroma of the
 *     color are specified in the design specification of the variant. Usually
 *     colorful.
 * @param secondaryPalette Given a tone, produces a color. Hue and chroma of the
 *     color are specified in the design specification of the variant. Usually
 *     less colorful.
 * @param tertiaryPalette Given a tone, produces a color. Hue and chroma of the
 *     color are specified in the design specification of the variant. Usually a
 *     different hue from primary and colorful.
 * @param neutralPalette Given a tone, produces a color. Hue and chroma of the
 *     color are specified in the design specification of the variant. Usually
 *     not colorful at all, intended for background & surface colors.
 * @param neutralVariantPalette Given a tone, produces a color. Hue and chroma
 *     of the color are specified in the design specification of the variant.
 *     Usually not colorful, but slightly more colorful than Neutral. Intended
 *     for backgrounds & surfaces.
 * @param errorPalette Given a tone, produces a reddish, colorful, color.
 */
interface DynamicSchemeOptions {
  sourceColorHct?: Hct;
  sourceColorHcts?: Hct[];
  variant: Variant;
  contrastLevel: number;
  isDark: boolean;
  platform?: Platform;
  specVersion?: SpecVersion;
  primaryPalette?: TonalPalette;
  secondaryPalette?: TonalPalette;
  tertiaryPalette?: TonalPalette;
  neutralPalette?: TonalPalette;
  neutralVariantPalette?: TonalPalette;
  errorPalette?: TonalPalette;
  
}

/**
 * A delegate that provides the palettes of a DynamicScheme.
 *
 * This is used to allow different implementations of the palette calculation
 * logic for different spec versions.
 */
interface DynamicSchemePalettesDelegate {
  getPrimaryPalette:
      (variant: Variant, sourceColorHct: Hct, isDark: boolean,
       platform: Platform, contrastLevel: number) => TonalPalette;

  getSecondaryPalette:
      (variant: Variant, sourceColorHct: Hct, isDark: boolean,
       platform: Platform, contrastLevel: number) => TonalPalette;

  getTertiaryPalette:
      (variant: Variant, sourceColorHct: Hct, isDark: boolean,
       platform: Platform, contrastLevel: number) => TonalPalette;

  getNeutralPalette:
      (variant: Variant, sourceColorHct: Hct, isDark: boolean,
       platform: Platform, contrastLevel: number) => TonalPalette;

  getNeutralVariantPalette:
      (variant: Variant, sourceColorHct: Hct, isDark: boolean,
       platform: Platform, contrastLevel: number) => TonalPalette;

  getErrorPalette:
      (variant: Variant, sourceColorHct: Hct, isDark: boolean,
       platform: Platform, contrastLevel: number) => TonalPalette | undefined;
}

/**
 * Constructed by a set of values representing the current UI state (such as
 * whether or not its dark theme, what the theme style is, etc.), and
 * provides a set of TonalPalettes that can create colors that fit in
 * with the theme style. Used by DynamicColor to resolve into a color.
 */
export class DynamicScheme {
  static readonly DEFAULT_SPEC_VERSION = '2021';
  static readonly DEFAULT_PLATFORM = 'phone';

  /**
   * The source color of the theme as an HCT color.
   */
  sourceColorHct: Hct;

  /**
   * The source colors of the theme as HCT colors.
   *
   * If provided, `sourceColorHct` will be the first color in this list. Any
   * other colors will be used to generate multicolored palettes.
   *
   * If not provided, `sourceColorHcts` will be a list containing only
   * `sourceColorHct`.
   */
  sourceColorHcts: Hct[];


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

  /** The platform on which this scheme is intended to be used. */
  readonly platform: Platform;

  /** The version of the design spec that this scheme is based on. */
  readonly specVersion: SpecVersion;

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

  /**
   * Given a tone, produces a reddish, colorful, color.
   */
  errorPalette: TonalPalette;

  readonly colors: MaterialDynamicColors;

  private static maybeFallbackSpecVersion(
      specVersion: SpecVersion, variant: Variant): SpecVersion {
    if (variant === Variant.CMF) {
      return specVersion;
    }
    if (variant === Variant.EXPRESSIVE || variant === Variant.VIBRANT ||
        variant === Variant.TONAL_SPOT || variant === Variant.NEUTRAL) {
      return specVersion === '2026' ? '2025' : specVersion;
    }
    return '2021';
  }

  constructor(args: DynamicSchemeOptions) {
    if (args.sourceColorHcts) {
      if (args.sourceColorHcts.length === 0) {
        throw new Error('sourceColorHcts cannot be empty');
      }
      this.sourceColorHct = args.sourceColorHcts[0];

      this.sourceColorHcts = args.sourceColorHcts;
    } else if (args.sourceColorHct) {
      this.sourceColorHct = args.sourceColorHct;

      this.sourceColorHcts = [args.sourceColorHct];
    } else {
      throw new Error('sourceColorHct or sourceColorHcts required');
    }
    this.sourceColorArgb = this.sourceColorHct.toInt();
    this.variant = args.variant;
    this.contrastLevel = args.contrastLevel;
    this.isDark = args.isDark;
    this.platform = args.platform ?? 'phone';
    this.specVersion = DynamicScheme.maybeFallbackSpecVersion(
        args.specVersion ?? '2021', this.variant);
    this.primaryPalette = args.primaryPalette ??
        getSpec(this.specVersion)
            .getPrimaryPalette(
                this.variant, this.sourceColorHct, this.isDark, this.platform,
                this.contrastLevel);
    this.secondaryPalette = args.secondaryPalette ??
        getSpec(this.specVersion)
            .getSecondaryPalette(
                this.variant, this.sourceColorHct, this.isDark, this.platform,
                this.contrastLevel);
    this.tertiaryPalette = args.tertiaryPalette ??
        getSpec(this.specVersion)
            .getTertiaryPalette(
                this.variant, this.sourceColorHct, this.isDark, this.platform,
                this.contrastLevel);
    this.neutralPalette = args.neutralPalette ??
        getSpec(this.specVersion)
            .getNeutralPalette(
                this.variant, this.sourceColorHct, this.isDark, this.platform,
                this.contrastLevel);
    this.neutralVariantPalette = args.neutralVariantPalette ??
        getSpec(this.specVersion)
            .getNeutralVariantPalette(
                this.variant, this.sourceColorHct, this.isDark, this.platform,
                this.contrastLevel);
    this.errorPalette = args.errorPalette ??
        getSpec(this.specVersion)
            .getErrorPalette(
                this.variant, this.sourceColorHct, this.isDark, this.platform,
                this.contrastLevel) ??
        TonalPalette.fromHueAndChroma(25.0, 84.0);

    this.colors = new MaterialDynamicColors();
  }

  toString(): string {
    const extraColors = this.sourceColorHcts.length <= 1 ?
        '' :
        `sourceColorHctList=[${
            this.sourceColorHcts.map((hct) => hct.toString()).join(', ')}], `;
    return `Scheme: ` +
        `variant=${Variant[this.variant]}, ` +
        `mode=${this.isDark ? 'dark' : 'light'}, ` +
        `platform=${this.platform}, ` +
        `contrastLevel=${this.contrastLevel.toFixed(1)}, ` +
        `seed=${this.sourceColorHct.toString()}, ` + extraColors +
        `specVersion=${this.specVersion}`;
  }

  /**
   * Returns a new hue based on a piecewise function and input color hue.
   *
   * For example, for the following function:
   * result = 26 if 0 <= hue < 101
   * result = 39 if 101 <= hue < 210
   * result = 28 if 210 <= hue < 360
   *
   * call the function as:
   *
   * const hueBreakpoints = [0, 101, 210, 360];
   * const hues = [26, 39, 28];
   * const result = scheme.piecewise(hue, hueBreakpoints, hues);
   *
   * @param sourceColorHct The input value.
   * @param hueBreakpoints The breakpoints, in sorted order. No default lower or
   *     upper bounds are assumed.
   * @param hues The hues that should be applied when source color's hue is >=
   *     the same index in hueBrakpoints array, and < the hue at the next index
   *     in hueBrakpoints array. Otherwise, the source color's hue is returned.
   */
  static getPiecewiseHue(
      sourceColorHct: Hct, hueBreakpoints: number[], hues: number[]): number {
    const size = Math.min(hueBreakpoints.length - 1, hues.length);
    const sourceHue = sourceColorHct.hue;
    for (let i = 0; i < size; i++) {
      if (sourceHue >= hueBreakpoints[i] && sourceHue < hueBreakpoints[i + 1]) {
        return math.sanitizeDegreesDouble(hues[i]);
      }
    }
    // No condition matched, return the source hue.
    return sourceHue;
  }

  /**
   * Returns a shifted hue based on a piecewise function and input color hue.
   *
   * For example, for the following function:
   * result = hue + 26 if 0 <= hue < 101
   * result = hue - 39 if 101 <= hue < 210
   * result = hue + 28 if 210 <= hue < 360
   *
   * call the function as:
   *
   * const hueBreakpoints = [0, 101, 210, 360];
   * const hues = [26, -39, 28];
   * const result = scheme.getRotatedHue(hue, hueBreakpoints, hues);
   *
   * @param sourceColorHct the source color of the theme, in HCT.
   * @param hueBreakpoints The "breakpoints", i.e. the hues at which a rotation
   *     should be apply. No default lower or upper bounds are assumed.
   * @param rotations The rotation that should be applied when source color's
   *     hue is >= the same index in hues array, and < the hue at the next
   *     index in hues array. Otherwise, the source color's hue is returned.
   */
  static getRotatedHue(
      sourceColorHct: Hct, hueBreakpoints: number[],
      rotations: number[]): number {
    let rotation = DynamicScheme.getPiecewiseHue(
        sourceColorHct, hueBreakpoints, rotations);
    if (Math.min(hueBreakpoints.length - 1, rotations.length) <= 0) {
      // No condition matched, return the source hue.
      rotation = 0;
    }
    return math.sanitizeDegreesDouble(sourceColorHct.hue + rotation);
  }

  getArgb(dynamicColor: DynamicColor): number {
    return dynamicColor.getArgb(this);
  }

  getHct(dynamicColor: DynamicColor): Hct {
    return dynamicColor.getHct(this);
  }

  // Palette key colors

  get primaryPaletteKeyColor(): number {
    return this.getArgb(this.colors.primaryPaletteKeyColor());
  }

  get secondaryPaletteKeyColor(): number {
    return this.getArgb(this.colors.secondaryPaletteKeyColor());
  }

  get tertiaryPaletteKeyColor(): number {
    return this.getArgb(this.colors.tertiaryPaletteKeyColor());
  }

  get neutralPaletteKeyColor(): number {
    return this.getArgb(this.colors.neutralPaletteKeyColor());
  }

  get neutralVariantPaletteKeyColor(): number {
    return this.getArgb(this.colors.neutralVariantPaletteKeyColor());
  }

  get errorPaletteKeyColor(): number {
    return this.getArgb(this.colors.errorPaletteKeyColor());
  }

  // Surface colors

  get background(): number {
    return this.getArgb(this.colors.background());
  }

  get onBackground(): number {
    return this.getArgb(this.colors.onBackground());
  }

  get surface(): number {
    return this.getArgb(this.colors.surface());
  }

  get surfaceDim(): number {
    return this.getArgb(this.colors.surfaceDim());
  }

  get surfaceBright(): number {
    return this.getArgb(this.colors.surfaceBright());
  }

  get surfaceContainerLowest(): number {
    return this.getArgb(this.colors.surfaceContainerLowest());
  }

  get surfaceContainerLow(): number {
    return this.getArgb(this.colors.surfaceContainerLow());
  }

  get surfaceContainer(): number {
    return this.getArgb(this.colors.surfaceContainer());
  }

  get surfaceContainerHigh(): number {
    return this.getArgb(this.colors.surfaceContainerHigh());
  }

  get surfaceContainerHighest(): number {
    return this.getArgb(this.colors.surfaceContainerHighest());
  }

  get onSurface(): number {
    return this.getArgb(this.colors.onSurface());
  }

  get surfaceVariant(): number {
    return this.getArgb(this.colors.surfaceVariant());
  }

  get onSurfaceVariant(): number {
    return this.getArgb(this.colors.onSurfaceVariant());
  }

  get inverseSurface(): number {
    return this.getArgb(this.colors.inverseSurface());
  }

  get inverseOnSurface(): number {
    return this.getArgb(this.colors.inverseOnSurface());
  }

  get outline(): number {
    return this.getArgb(this.colors.outline());
  }

  get outlineVariant(): number {
    return this.getArgb(this.colors.outlineVariant());
  }

  get shadow(): number {
    return this.getArgb(this.colors.shadow());
  }

  get scrim(): number {
    return this.getArgb(this.colors.scrim());
  }

  get surfaceTint(): number {
    return this.getArgb(this.colors.surfaceTint());
  }

  // Primary colors

  get primary(): number {
    return this.getArgb(this.colors.primary());
  }

  get primaryDim(): number {
    const primaryDim = this.colors.primaryDim();
    if (primaryDim === undefined) {
      throw new Error('`primaryDim` color is undefined prior to 2025 spec.');
    }
    return this.getArgb(primaryDim);
  }

  get onPrimary(): number {
    return this.getArgb(this.colors.onPrimary());
  }

  get primaryContainer(): number {
    return this.getArgb(this.colors.primaryContainer());
  }

  get onPrimaryContainer(): number {
    return this.getArgb(this.colors.onPrimaryContainer());
  }

  get primaryFixed(): number {
    return this.getArgb(this.colors.primaryFixed());
  }

  get primaryFixedDim(): number {
    return this.getArgb(this.colors.primaryFixedDim());
  }

  get onPrimaryFixed(): number {
    return this.getArgb(this.colors.onPrimaryFixed());
  }

  get onPrimaryFixedVariant(): number {
    return this.getArgb(this.colors.onPrimaryFixedVariant());
  }

  get inversePrimary(): number {
    return this.getArgb(this.colors.inversePrimary());
  }

  // Secondary colors

  get secondary(): number {
    return this.getArgb(this.colors.secondary());
  }

  get secondaryDim(): number {
    const secondaryDim = this.colors.secondaryDim();
    if (secondaryDim === undefined) {
      throw new Error('`secondaryDim` color is undefined prior to 2025 spec.');
    }
    return this.getArgb(secondaryDim);
  }

  get onSecondary(): number {
    return this.getArgb(this.colors.onSecondary());
  }

  get secondaryContainer(): number {
    return this.getArgb(this.colors.secondaryContainer());
  }

  get onSecondaryContainer(): number {
    return this.getArgb(this.colors.onSecondaryContainer());
  }

  get secondaryFixed(): number {
    return this.getArgb(this.colors.secondaryFixed());
  }

  get secondaryFixedDim(): number {
    return this.getArgb(this.colors.secondaryFixedDim());
  }

  get onSecondaryFixed(): number {
    return this.getArgb(this.colors.onSecondaryFixed());
  }

  get onSecondaryFixedVariant(): number {
    return this.getArgb(this.colors.onSecondaryFixedVariant());
  }

  // Tertiary colors

  get tertiary(): number {
    return this.getArgb(this.colors.tertiary());
  }

  get tertiaryDim(): number {
    const tertiaryDim = this.colors.tertiaryDim();
    if (tertiaryDim === undefined) {
      throw new Error('`tertiaryDim` color is undefined prior to 2025 spec.');
    }
    return this.getArgb(tertiaryDim);
  }

  get onTertiary(): number {
    return this.getArgb(this.colors.onTertiary());
  }

  get tertiaryContainer(): number {
    return this.getArgb(this.colors.tertiaryContainer());
  }

  get onTertiaryContainer(): number {
    return this.getArgb(this.colors.onTertiaryContainer());
  }

  get tertiaryFixed(): number {
    return this.getArgb(this.colors.tertiaryFixed());
  }

  get tertiaryFixedDim(): number {
    return this.getArgb(this.colors.tertiaryFixedDim());
  }

  get onTertiaryFixed(): number {
    return this.getArgb(this.colors.onTertiaryFixed());
  }

  get onTertiaryFixedVariant(): number {
    return this.getArgb(this.colors.onTertiaryFixedVariant());
  }

  // Error colors

  get error(): number {
    return this.getArgb(this.colors.error());
  }

  get errorDim(): number {
    const errorDim = this.colors.errorDim();
    if (errorDim === undefined) {
      throw new Error('`errorDim` color is undefined prior to 2025 spec.');
    }
    return this.getArgb(errorDim);
  }

  get onError(): number {
    return this.getArgb(this.colors.onError());
  }

  get errorContainer(): number {
    return this.getArgb(this.colors.errorContainer());
  }

  get onErrorContainer(): number {
    return this.getArgb(this.colors.onErrorContainer());
  }
}

/**
 * A delegate for the palettes of a DynamicScheme in the 2021 spec.
 */
class DynamicSchemePalettesDelegateImpl2021 implements
    DynamicSchemePalettesDelegate {
  //////////////////////////////////////////////////////////////////
  // Scheme Palettes                                              //
  //////////////////////////////////////////////////////////////////

  getPrimaryPalette(
      variant: Variant, sourceColorHct: Hct, isDark: boolean,
      platform: Platform, contrastLevel: number): TonalPalette {
    switch (variant) {
      case Variant.CONTENT:
      case Variant.FIDELITY:
        return TonalPalette.fromHueAndChroma(
            sourceColorHct.hue, sourceColorHct.chroma);
      case Variant.FRUIT_SALAD:
        return TonalPalette.fromHueAndChroma(
            math.sanitizeDegreesDouble(sourceColorHct.hue - 50.0), 48.0);
      case Variant.MONOCHROME:
        return TonalPalette.fromHueAndChroma(sourceColorHct.hue, 0.0);
      case Variant.NEUTRAL:
        return TonalPalette.fromHueAndChroma(sourceColorHct.hue, 12.0);
      case Variant.RAINBOW:
        return TonalPalette.fromHueAndChroma(sourceColorHct.hue, 48.0);
      case Variant.TONAL_SPOT:
        return TonalPalette.fromHueAndChroma(sourceColorHct.hue, 36.0);
      case Variant.EXPRESSIVE:
        return TonalPalette.fromHueAndChroma(
            math.sanitizeDegreesDouble(sourceColorHct.hue + 240), 40);
      case Variant.VIBRANT:
        return TonalPalette.fromHueAndChroma(sourceColorHct.hue, 200.0);
      default:
        throw new Error(`Unsupported variant: ${variant}`);
    }
  }

  getSecondaryPalette(
      variant: Variant, sourceColorHct: Hct, isDark: boolean,
      platform: Platform, contrastLevel: number): TonalPalette {
    switch (variant) {
      case Variant.CONTENT:
      case Variant.FIDELITY:
        return TonalPalette.fromHueAndChroma(
            sourceColorHct.hue,
            Math.max(
                sourceColorHct.chroma - 32.0, sourceColorHct.chroma * 0.5));
      case Variant.FRUIT_SALAD:
        return TonalPalette.fromHueAndChroma(
            math.sanitizeDegreesDouble(sourceColorHct.hue - 50.0), 36.0);
      case Variant.MONOCHROME:
        return TonalPalette.fromHueAndChroma(sourceColorHct.hue, 0.0);
      case Variant.NEUTRAL:
        return TonalPalette.fromHueAndChroma(sourceColorHct.hue, 8.0);
      case Variant.RAINBOW:
        return TonalPalette.fromHueAndChroma(sourceColorHct.hue, 16.0);
      case Variant.TONAL_SPOT:
        return TonalPalette.fromHueAndChroma(sourceColorHct.hue, 16.0);
      case Variant.EXPRESSIVE:
        return TonalPalette.fromHueAndChroma(
            DynamicScheme.getRotatedHue(
                sourceColorHct, [0, 21, 51, 121, 151, 191, 271, 321, 360],
                [45, 95, 45, 20, 45, 90, 45, 45, 45]),
            24.0);
      case Variant.VIBRANT:
        return TonalPalette.fromHueAndChroma(
            DynamicScheme.getRotatedHue(
                sourceColorHct, [0, 41, 61, 101, 131, 181, 251, 301, 360],
                [18, 15, 10, 12, 15, 18, 15, 12, 12]),
            24.0);
      default:
        throw new Error(`Unsupported variant: ${variant}`);
    }
  }

  getTertiaryPalette(
      variant: Variant, sourceColorHct: Hct, isDark: boolean,
      platform: Platform, contrastLevel: number): TonalPalette {
    switch (variant) {
      case Variant.CONTENT:
        return TonalPalette.fromHct(DislikeAnalyzer.fixIfDisliked(
            new TemperatureCache(sourceColorHct)
                .analogous(/* count= */ 3, /* divisions= */ 6)[2]));
      case Variant.FIDELITY:
        return TonalPalette.fromHct(DislikeAnalyzer.fixIfDisliked(
            new TemperatureCache(sourceColorHct).complement));
      case Variant.FRUIT_SALAD:
        return TonalPalette.fromHueAndChroma(sourceColorHct.hue, 36.0);
      case Variant.MONOCHROME:
        return TonalPalette.fromHueAndChroma(sourceColorHct.hue, 0.0);
      case Variant.NEUTRAL:
        return TonalPalette.fromHueAndChroma(sourceColorHct.hue, 16.0);
      case Variant.RAINBOW:
      case Variant.TONAL_SPOT:
        return TonalPalette.fromHueAndChroma(
            math.sanitizeDegreesDouble(sourceColorHct.hue + 60.0), 24.0);
      case Variant.EXPRESSIVE:
        return TonalPalette.fromHueAndChroma(
            DynamicScheme.getRotatedHue(
                sourceColorHct, [0, 21, 51, 121, 151, 191, 271, 321, 360],
                [120, 120, 20, 45, 20, 15, 20, 120, 120]),
            32.0);
      case Variant.VIBRANT:
        return TonalPalette.fromHueAndChroma(
            DynamicScheme.getRotatedHue(
                sourceColorHct, [0, 41, 61, 101, 131, 181, 251, 301, 360],
                [35, 30, 20, 25, 30, 35, 30, 25, 25]),
            32.0);
      default:
        throw new Error(`Unsupported variant: ${variant}`);
    }
  }

  getNeutralPalette(
      variant: Variant, sourceColorHct: Hct, isDark: boolean,
      platform: Platform, contrastLevel: number): TonalPalette {
    switch (variant) {
      case Variant.CONTENT:
      case Variant.FIDELITY:
        return TonalPalette.fromHueAndChroma(
            sourceColorHct.hue, sourceColorHct.chroma / 8.0);
      case Variant.FRUIT_SALAD:
        return TonalPalette.fromHueAndChroma(sourceColorHct.hue, 10.0);
      case Variant.MONOCHROME:
        return TonalPalette.fromHueAndChroma(sourceColorHct.hue, 0.0);
      case Variant.NEUTRAL:
        return TonalPalette.fromHueAndChroma(sourceColorHct.hue, 2.0);
      case Variant.RAINBOW:
        return TonalPalette.fromHueAndChroma(sourceColorHct.hue, 0.0);
      case Variant.TONAL_SPOT:
        return TonalPalette.fromHueAndChroma(sourceColorHct.hue, 6.0);
      case Variant.EXPRESSIVE:
        return TonalPalette.fromHueAndChroma(
            math.sanitizeDegreesDouble(sourceColorHct.hue + 15), 8);
      case Variant.VIBRANT:
        return TonalPalette.fromHueAndChroma(sourceColorHct.hue, 10);
      default:
        throw new Error(`Unsupported variant: ${variant}`);
    }
  }

  getNeutralVariantPalette(
      variant: Variant, sourceColorHct: Hct, isDark: boolean,
      platform: Platform, contrastLevel: number): TonalPalette {
    switch (variant) {
      case Variant.CONTENT:
        return TonalPalette.fromHueAndChroma(
            sourceColorHct.hue, (sourceColorHct.chroma / 8.0) + 4.0);
      case Variant.FIDELITY:
        return TonalPalette.fromHueAndChroma(
            sourceColorHct.hue, (sourceColorHct.chroma / 8.0) + 4.0);
      case Variant.FRUIT_SALAD:
        return TonalPalette.fromHueAndChroma(sourceColorHct.hue, 16.0);
      case Variant.MONOCHROME:
        return TonalPalette.fromHueAndChroma(sourceColorHct.hue, 0.0);
      case Variant.NEUTRAL:
        return TonalPalette.fromHueAndChroma(sourceColorHct.hue, 2.0);
      case Variant.RAINBOW:
        return TonalPalette.fromHueAndChroma(sourceColorHct.hue, 0.0);
      case Variant.TONAL_SPOT:
        return TonalPalette.fromHueAndChroma(sourceColorHct.hue, 8.0);
      case Variant.EXPRESSIVE:
        return TonalPalette.fromHueAndChroma(
            math.sanitizeDegreesDouble(sourceColorHct.hue + 15), 12);
      case Variant.VIBRANT:
        return TonalPalette.fromHueAndChroma(sourceColorHct.hue, 12);
      default:
        throw new Error(`Unsupported variant: ${variant}`);
    }
  }

  getErrorPalette(
      variant: Variant, sourceColorHct: Hct, isDark: boolean,
      platform: Platform, contrastLevel: number): TonalPalette|undefined {
    return undefined;
  }
}

/**
 * A delegate for the palettes of a DynamicScheme in the 2025 spec.
 */
class DynamicSchemePalettesDelegateImpl2025 extends
    DynamicSchemePalettesDelegateImpl2021 {
  //////////////////////////////////////////////////////////////////
  // Scheme Palettes                                              //
  //////////////////////////////////////////////////////////////////

  override getPrimaryPalette(
      variant: Variant, sourceColorHct: Hct, isDark: boolean,
      platform: Platform, contrastLevel: number): TonalPalette {
    switch (variant) {
      case Variant.NEUTRAL:
        return TonalPalette.fromHueAndChroma(
            sourceColorHct.hue,
            platform === 'phone' ? (Hct.isBlue(sourceColorHct.hue) ? 12 : 8) :
                                   (Hct.isBlue(sourceColorHct.hue) ? 16 : 12));
      case Variant.TONAL_SPOT:
        return TonalPalette.fromHueAndChroma(
            sourceColorHct.hue, platform === 'phone' && isDark ? 26 : 32);
      case Variant.EXPRESSIVE:
        return TonalPalette.fromHueAndChroma(
            sourceColorHct.hue, platform === 'phone' ? (isDark ? 36 : 48) : 40);
      case Variant.VIBRANT:
        return TonalPalette.fromHueAndChroma(
            sourceColorHct.hue, platform === 'phone' ? 74 : 56);
      default:
        return super.getPrimaryPalette(
            variant, sourceColorHct, isDark, platform, contrastLevel);
    }
  }

  override getSecondaryPalette(
      variant: Variant, sourceColorHct: Hct, isDark: boolean,
      platform: Platform, contrastLevel: number): TonalPalette {
    switch (variant) {
      case Variant.NEUTRAL:
        return TonalPalette.fromHueAndChroma(
            sourceColorHct.hue,
            platform === 'phone' ? (Hct.isBlue(sourceColorHct.hue) ? 6 : 4) :
                                   (Hct.isBlue(sourceColorHct.hue) ? 10 : 6));
      case Variant.TONAL_SPOT:
        return TonalPalette.fromHueAndChroma(sourceColorHct.hue, 16);
      case Variant.EXPRESSIVE:
        return TonalPalette.fromHueAndChroma(
            DynamicScheme.getRotatedHue(
                sourceColorHct, [0, 105, 140, 204, 253, 278, 300, 333, 360],
                [-160, 155, -100, 96, -96, -156, -165, -160]),
            platform === 'phone' ? (isDark ? 16 : 24) : 24);
      case Variant.VIBRANT:
        return TonalPalette.fromHueAndChroma(
            DynamicScheme.getRotatedHue(
                sourceColorHct, [0, 38, 105, 140, 333, 360],
                [-14, 10, -14, 10, -14]),
            platform === 'phone' ? 56 : 36);
      default:
        return super.getSecondaryPalette(
            variant, sourceColorHct, isDark, platform, contrastLevel);
    }
  }

  override getTertiaryPalette(
      variant: Variant, sourceColorHct: Hct, isDark: boolean,
      platform: Platform, contrastLevel: number): TonalPalette {
    switch (variant) {
      case Variant.NEUTRAL:
        return TonalPalette.fromHueAndChroma(
            DynamicScheme.getRotatedHue(
                sourceColorHct, [0, 38, 105, 161, 204, 278, 333, 360],
                [-32, 26, 10, -39, 24, -15, -32]),
            platform === 'phone' ? 20 : 36);
      case Variant.TONAL_SPOT:
        return TonalPalette.fromHueAndChroma(
            DynamicScheme.getRotatedHue(
                sourceColorHct, [0, 20, 71, 161, 333, 360],
                [-40, 48, -32, 40, -32]),
            platform === 'phone' ? 28 : 32);
      case Variant.EXPRESSIVE:
        return TonalPalette.fromHueAndChroma(
            DynamicScheme.getRotatedHue(
                sourceColorHct, [0, 105, 140, 204, 253, 278, 300, 333, 360],
                [-165, 160, -105, 101, -101, -160, -170, -165]),
            48);
      case Variant.VIBRANT:
        return TonalPalette.fromHueAndChroma(
            DynamicScheme.getRotatedHue(
                sourceColorHct, [0, 38, 71, 105, 140, 161, 253, 333, 360],
                [-72, 35, 24, -24, 62, 50, 62, -72]),
            56);
      default:
        return super.getTertiaryPalette(
            variant, sourceColorHct, isDark, platform, contrastLevel);
    }
  }

  private static getExpressiveNeutralHue(sourceColorHct: Hct): number {
    const hue = DynamicScheme.getRotatedHue(
        sourceColorHct, [0, 71, 124, 253, 278, 300, 360],
        [10, 0, 10, 0, 10, 0]);
    return hue;
  }

  private static getExpressiveNeutralChroma(
      sourceColorHct: Hct, isDark: boolean, platform: Platform): number {
    const neutralHue =
        DynamicSchemePalettesDelegateImpl2025.getExpressiveNeutralHue(
            sourceColorHct);
    return platform === 'phone' ?
        (isDark ? (Hct.isYellow(neutralHue) ? 6 : 14) : 18) :
        12;
  }

  private static getVibrantNeutralHue(sourceColorHct: Hct): number {
    return DynamicScheme.getRotatedHue(
        sourceColorHct, [0, 38, 105, 140, 333, 360], [-14, 10, -14, 10, -14]);
  }

  private static getVibrantNeutralChroma(
      sourceColorHct: Hct, platform: Platform): number {
    const neutralHue =
        DynamicSchemePalettesDelegateImpl2025.getVibrantNeutralHue(
            sourceColorHct);
    return platform === 'phone' ? 28 : (Hct.isBlue(neutralHue) ? 28 : 20);
  }

  override getNeutralPalette(
      variant: Variant, sourceColorHct: Hct, isDark: boolean,
      platform: Platform, contrastLevel: number): TonalPalette {
    switch (variant) {
      case Variant.NEUTRAL:
        return TonalPalette.fromHueAndChroma(
            sourceColorHct.hue, platform === 'phone' ? 1.4 : 6);
      case Variant.TONAL_SPOT:
        return TonalPalette.fromHueAndChroma(
            sourceColorHct.hue, platform === 'phone' ? 5 : 10);
      case Variant.EXPRESSIVE:
        return TonalPalette.fromHueAndChroma(
            DynamicSchemePalettesDelegateImpl2025.getExpressiveNeutralHue(
                sourceColorHct),
            DynamicSchemePalettesDelegateImpl2025.getExpressiveNeutralChroma(
                sourceColorHct, isDark, platform));
      case Variant.VIBRANT:
        return TonalPalette.fromHueAndChroma(
            DynamicSchemePalettesDelegateImpl2025.getVibrantNeutralHue(
                sourceColorHct),
            DynamicSchemePalettesDelegateImpl2025.getVibrantNeutralChroma(
                sourceColorHct, platform));
      default:
        return super.getNeutralPalette(
            variant, sourceColorHct, isDark, platform, contrastLevel);
    }
  }

  override getNeutralVariantPalette(
      variant: Variant, sourceColorHct: Hct, isDark: boolean,
      platform: Platform, contrastLevel: number): TonalPalette {
    switch (variant) {
      case Variant.NEUTRAL:
        return TonalPalette.fromHueAndChroma(
            sourceColorHct.hue, (platform === 'phone' ? 1.4 : 6) * 2.2);
      case Variant.TONAL_SPOT:
        return TonalPalette.fromHueAndChroma(
            sourceColorHct.hue, (platform === 'phone' ? 5 : 10) * 1.7);
      case Variant.EXPRESSIVE:
        const expressiveNeutralHue =
            DynamicSchemePalettesDelegateImpl2025.getExpressiveNeutralHue(
                sourceColorHct);
        const expressiveNeutralChroma =
            DynamicSchemePalettesDelegateImpl2025.getExpressiveNeutralChroma(
                sourceColorHct, isDark, platform);
        return TonalPalette.fromHueAndChroma(
            expressiveNeutralHue,
            expressiveNeutralChroma *
                (expressiveNeutralHue >= 105 && expressiveNeutralHue < 125 ?
                     1.6 :
                     2.3),
        );
      case Variant.VIBRANT:
        const vibrantNeutralHue =
            DynamicSchemePalettesDelegateImpl2025.getVibrantNeutralHue(
                sourceColorHct);
        const vibrantNeutralChroma =
            DynamicSchemePalettesDelegateImpl2025.getVibrantNeutralChroma(
                sourceColorHct, platform);
        return TonalPalette.fromHueAndChroma(
            vibrantNeutralHue, vibrantNeutralChroma * 1.29);
      default:
        return super.getNeutralVariantPalette(
            variant, sourceColorHct, isDark, platform, contrastLevel);
    }
  }

  override getErrorPalette(
      variant: Variant, sourceColorHct: Hct, isDark: boolean,
      platform: Platform, contrastLevel: number): TonalPalette|undefined {
    const errorHue = DynamicScheme.getPiecewiseHue(
        sourceColorHct, [0, 3, 13, 23, 33, 43, 153, 273, 360],
        [12, 22, 32, 12, 22, 32, 22, 12]);
    switch (variant) {
      case Variant.NEUTRAL:
        return TonalPalette.fromHueAndChroma(
            errorHue, platform === 'phone' ? 50 : 40);
      case Variant.TONAL_SPOT:
        return TonalPalette.fromHueAndChroma(
            errorHue, platform === 'phone' ? 60 : 48);
      case Variant.EXPRESSIVE:
        return TonalPalette.fromHueAndChroma(
            errorHue, platform === 'phone' ? 64 : 48);
      case Variant.VIBRANT:
        return TonalPalette.fromHueAndChroma(
            errorHue, platform === 'phone' ? 80 : 60);
      default:
        return super.getErrorPalette(
            variant, sourceColorHct, isDark, platform, contrastLevel);
    }
  }
}

const spec2021 = new DynamicSchemePalettesDelegateImpl2021();
const spec2025 = new DynamicSchemePalettesDelegateImpl2025();

/**
 * Returns the DynamicSchemePalettesDelegate for the given spec version.
 */
function getSpec(specVersion: SpecVersion):
    DynamicSchemePalettesDelegate {
  return specVersion === '2025' ? spec2025 : spec2021;
}
