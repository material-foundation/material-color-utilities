/**
 * @license
 * Copyright 2021 Google LLC
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

import {CorePalette} from '../palettes/core_palette.js';

/**
 * Represents an Android 12 color scheme, a mapping of color roles to colors.
 */
export class SchemeAndroid {
  get colorAccentPrimary(): number {
    return this.props.colorAccentPrimary;
  }

  get colorAccentPrimaryVariant(): number {
    return this.props.colorAccentPrimaryVariant;
  }

  get colorAccentSecondary(): number {
    return this.props.colorAccentSecondary;
  }

  get colorAccentSecondaryVariant(): number {
    return this.props.colorAccentSecondaryVariant;
  }

  get colorAccentTertiary(): number {
    return this.props.colorAccentTertiary;
  }

  get colorAccentTertiaryVariant(): number {
    return this.props.colorAccentTertiaryVariant;
  }

  get textColorPrimary(): number {
    return this.props.textColorPrimary;
  }

  get textColorSecondary(): number {
    return this.props.textColorSecondary;
  }

  get textColorTertiary(): number {
    return this.props.textColorTertiary;
  }

  get textColorPrimaryInverse(): number {
    return this.props.textColorPrimaryInverse;
  }

  get textColorSecondaryInverse(): number {
    return this.props.textColorSecondaryInverse;
  }

  get textColorTertiaryInverse(): number {
    return this.props.textColorTertiaryInverse;
  }

  get colorBackground(): number {
    return this.props.colorBackground;
  }

  get colorBackgroundFloating(): number {
    return this.props.colorBackgroundFloating;
  }

  get colorSurface(): number {
    return this.props.colorSurface;
  }

  get colorSurfaceVariant(): number {
    return this.props.colorSurfaceVariant;
  }

  get colorSurfaceHighlight(): number {
    return this.props.colorSurfaceHighlight;
  }

  get surfaceHeader(): number {
    return this.props.surfaceHeader;
  }

  get underSurface(): number {
    return this.props.underSurface;
  }

  get offState(): number {
    return this.props.offState;
  }

  get accentSurface(): number {
    return this.props.accentSurface;
  }

  get textPrimaryOnAccent(): number {
    return this.props.textPrimaryOnAccent;
  }

  get textSecondaryOnAccent(): number {
    return this.props.textSecondaryOnAccent;
  }

  get volumeBackground(): number {
    return this.props.volumeBackground;
  }

  get scrim(): number {
    return this.props.scrim;
  }

  /**
   * @param argb ARGB representation of a color.
   * @return Light Material color scheme, based on the color's hue.
   */
  static light(argb: number): SchemeAndroid {
    const core = CorePalette.of(argb);
    return SchemeAndroid.lightFromCorePalette(core);
  }

  /**
   * @param argb ARGB representation of a color.
   * @return Dark Material color scheme, based on the color's hue.
   */
  static dark(argb: number): SchemeAndroid {
    const core = CorePalette.of(argb);
    return SchemeAndroid.darkFromCorePalette(core);
  }

  /**
   * @param argb ARGB representation of a color.
   * @return Light Android color scheme, based on the color's hue.
   */
  static lightContent(argb: number): SchemeAndroid {
    const core = CorePalette.contentOf(argb);
    return SchemeAndroid.lightFromCorePalette(core);
  }

  /**
   * @param argb ARGB representation of a color.
   * @return Dark Android color scheme, based on the color's hue.
   */
  static darkContent(argb: number): SchemeAndroid {
    const core = CorePalette.contentOf(argb);
    return SchemeAndroid.darkFromCorePalette(core);
  }

  /**
   * Light scheme from core palette
   */
  static lightFromCorePalette(core: CorePalette): SchemeAndroid {
    return new SchemeAndroid({
      colorAccentPrimary: core.a1.tone(90),
      colorAccentPrimaryVariant: core.a1.tone(40),
      colorAccentSecondary: core.a2.tone(90),
      colorAccentSecondaryVariant: core.a2.tone(40),
      colorAccentTertiary: core.a3.tone(90),
      colorAccentTertiaryVariant: core.a3.tone(40),
      textColorPrimary: core.n1.tone(10),
      textColorSecondary: core.n2.tone(30),
      textColorTertiary: core.n2.tone(50),
      textColorPrimaryInverse: core.n1.tone(95),
      textColorSecondaryInverse: core.n1.tone(80),
      textColorTertiaryInverse: core.n1.tone(60),
      colorBackground: core.n1.tone(95),
      colorBackgroundFloating: core.n1.tone(98),
      colorSurface: core.n1.tone(98),
      colorSurfaceVariant: core.n1.tone(90),
      colorSurfaceHighlight: core.n1.tone(100),
      surfaceHeader: core.n1.tone(90),
      underSurface: core.n1.tone(0),
      offState: core.n1.tone(20),
      accentSurface: core.a2.tone(95),
      textPrimaryOnAccent: core.n1.tone(10),
      textSecondaryOnAccent: core.n2.tone(30),
      volumeBackground: core.n1.tone(25),
      scrim: core.n1.tone(80),
    });
  }

  /**
   * Dark scheme from core palette
   */
  static darkFromCorePalette(core: CorePalette): SchemeAndroid {
    return new SchemeAndroid({
      colorAccentPrimary: core.a1.tone(90),
      colorAccentPrimaryVariant: core.a1.tone(70),
      colorAccentSecondary: core.a2.tone(90),
      colorAccentSecondaryVariant: core.a2.tone(70),
      colorAccentTertiary: core.a3.tone(90),
      colorAccentTertiaryVariant: core.a3.tone(70),
      textColorPrimary: core.n1.tone(95),
      textColorSecondary: core.n2.tone(80),
      textColorTertiary: core.n2.tone(60),
      textColorPrimaryInverse: core.n1.tone(10),
      textColorSecondaryInverse: core.n1.tone(30),
      textColorTertiaryInverse: core.n1.tone(50),
      colorBackground: core.n1.tone(10),
      colorBackgroundFloating: core.n1.tone(10),
      colorSurface: core.n1.tone(20),
      colorSurfaceVariant: core.n1.tone(30),
      colorSurfaceHighlight: core.n1.tone(35),
      surfaceHeader: core.n1.tone(30),
      underSurface: core.n1.tone(0),
      offState: core.n1.tone(20),
      accentSurface: core.a2.tone(95),
      textPrimaryOnAccent: core.n1.tone(10),
      textSecondaryOnAccent: core.n2.tone(30),
      volumeBackground: core.n1.tone(25),
      scrim: core.n1.tone(80),
    });
  }

  private constructor(private readonly props: {
    colorAccentPrimary: number,
    colorAccentPrimaryVariant: number,
    colorAccentSecondary: number,
    colorAccentSecondaryVariant: number,
    colorAccentTertiary: number,
    colorAccentTertiaryVariant: number,
    textColorPrimary: number,
    textColorSecondary: number,
    textColorTertiary: number,
    textColorPrimaryInverse: number,
    textColorSecondaryInverse: number,
    textColorTertiaryInverse: number,
    colorBackground: number,
    colorBackgroundFloating: number,
    colorSurface: number,
    colorSurfaceVariant: number,
    colorSurfaceHighlight: number,
    surfaceHeader: number,
    underSurface: number,
    offState: number,
    accentSurface: number,
    textPrimaryOnAccent: number,
    textSecondaryOnAccent: number,
    volumeBackground: number,
    scrim: number
  }) {}

  toJSON() {
    return {...this.props};
  }
}
