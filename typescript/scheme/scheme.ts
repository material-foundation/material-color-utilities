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

// This file is automatically generated. Do not modify it.

import {CorePalette} from '../palettes/core_palette.js';

/**
 * Represents a Material color scheme, a mapping of color roles to colors.
 */
export class Scheme {
  get primary(): number {
    return this.props.primary;
  }

  get onPrimary(): number {
    return this.props.onPrimary;
  }

  get primaryContainer(): number {
    return this.props.primaryContainer;
  }

  get onPrimaryContainer(): number {
    return this.props.onPrimaryContainer;
  }

  get secondary(): number {
    return this.props.secondary;
  }

  get onSecondary(): number {
    return this.props.onSecondary;
  }

  get secondaryContainer(): number {
    return this.props.secondaryContainer;
  }

  get onSecondaryContainer(): number {
    return this.props.onSecondaryContainer;
  }

  get tertiary(): number {
    return this.props.tertiary;
  }

  get onTertiary(): number {
    return this.props.onTertiary;
  }

  get tertiaryContainer(): number {
    return this.props.tertiaryContainer;
  }

  get onTertiaryContainer(): number {
    return this.props.onTertiaryContainer;
  }

  get error(): number {
    return this.props.error;
  }

  get onError(): number {
    return this.props.onError;
  }

  get errorContainer(): number {
    return this.props.errorContainer;
  }

  get onErrorContainer(): number {
    return this.props.onErrorContainer;
  }

  get background(): number {
    return this.props.background;
  }

  get onBackground(): number {
    return this.props.onBackground;
  }

  get surface(): number {
    return this.props.surface;
  }

  get onSurface(): number {
    return this.props.onSurface;
  }

  get surfaceVariant(): number {
    return this.props.surfaceVariant;
  }

  get onSurfaceVariant(): number {
    return this.props.onSurfaceVariant;
  }

  get outline(): number {
    return this.props.outline;
  }

  get outlineVariant(): number {
    return this.props.outlineVariant;
  }

  get shadow(): number {
    return this.props.shadow;
  }

  get scrim(): number {
    return this.props.scrim;
  }

  get inverseSurface(): number {
    return this.props.inverseSurface;
  }

  get inverseOnSurface(): number {
    return this.props.inverseOnSurface;
  }

  get inversePrimary(): number {
    return this.props.inversePrimary;
  }

  get surfaceContainerLowest(): number {
    return this.props.surfaceContainerLowest;
  }

  get surfaceContainerLow(): number {
    return this.props.surfaceContainerLow;
  }

  get surfaceContainer(): number {
    return this.props.surfaceContainer;
  }

  get surfaceContainerHigh(): number {
    return this.props.surfaceContainerHigh;
  }

  get surfaceContainerHighest(): number {
    return this.props.surfaceContainerHighest;
  }

  get primaryFixed(): number {
    return this.props.primaryFixed;
  }

  get onPrimaryFixed(): number {
    return this.props.onPrimaryFixed;
  }

  get primaryFixedDim(): number {
    return this.props.primaryFixedDim;
  }

  get onPrimaryFixedVariant(): number {
    return this.props.onPrimaryFixedVariant;
  }

  get secondaryFixed(): number {
    return this.props.secondaryFixed;
  }

  get onSecondaryFixed(): number {
    return this.props.onSecondaryFixed;
  }

  get secondaryFixedDim(): number {
    return this.props.secondaryFixedDim;
  }

  get onSecondaryFixedVariant(): number {
    return this.props.onSecondaryFixedVariant;
  }

  get tertiaryFixed(): number {
    return this.props.tertiaryFixed;
  }

  get onTertiaryFixed(): number {
    return this.props.onTertiaryFixed;
  }

  get tertiaryFixedDim(): number {
    return this.props.tertiaryFixedDim;
  }

  get onTertiaryFixedVariant(): number {
    return this.props.onTertiaryFixedVariant;
  }

  get surfaceBright(): number {
    return this.props.surfaceBright;
  }

  get surfaceDim(): number {
    return this.props.surfaceDim;
  }

  get surfaceTint(): number {
    return this.props.surfaceTint;
  }

  /**
   * @param argb ARGB representation of a color.
   * @return Light Material color scheme, based on the color's hue.
   */
  static light(argb: number): Scheme {
    return Scheme.lightFromCorePalette(CorePalette.of(argb));
  }

  /**
   * @param argb ARGB representation of a color.
   * @return Dark Material color scheme, based on the color's hue.
   */
  static dark(argb: number): Scheme {
    return Scheme.darkFromCorePalette(CorePalette.of(argb));
  }

  /**
   * @param argb ARGB representation of a color.
   * @return Light Material content color scheme, based on the color's hue.
   */
  static lightContent(argb: number): Scheme {
    return Scheme.lightFromCorePalette(CorePalette.contentOf(argb));
  }

  /**
   * @param argb ARGB representation of a color.
   * @return Dark Material content color scheme, based on the color's hue.
   */
  static darkContent(argb: number): Scheme {
    return Scheme.darkFromCorePalette(CorePalette.contentOf(argb));
  }

  /**
   * Light scheme from core palette
   */
  static lightFromCorePalette(core: CorePalette): Scheme {
    return new Scheme({
      primary: core.a1.tone(40),
      onPrimary: core.a1.tone(100),
      primaryContainer: core.a1.tone(90),
      onPrimaryContainer: core.a1.tone(10),
      secondary: core.a2.tone(40),
      onSecondary: core.a2.tone(100),
      secondaryContainer: core.a2.tone(90),
      onSecondaryContainer: core.a2.tone(10),
      tertiary: core.a3.tone(40),
      onTertiary: core.a3.tone(100),
      tertiaryContainer: core.a3.tone(90),
      onTertiaryContainer: core.a3.tone(10),
      error: core.error.tone(40),
      onError: core.error.tone(100),
      errorContainer: core.error.tone(90),
      onErrorContainer: core.error.tone(10),
      background: core.n1.tone(98),
      onBackground: core.n1.tone(10),
      surface: core.n1.tone(98),
      onSurface: core.n1.tone(10),
      surfaceVariant: core.n2.tone(90),
      onSurfaceVariant: core.n2.tone(30),
      outline: core.n2.tone(50),
      outlineVariant: core.n2.tone(80),
      shadow: core.n1.tone(0),
      scrim: core.n1.tone(0),
      inverseSurface: core.n1.tone(20),
      inverseOnSurface: core.n1.tone(95),
      inversePrimary: core.a1.tone(80),
      surfaceContainerLowest: core.n1.tone(100),
      surfaceContainerLow: core.n1.tone(96),
      surfaceContainer: core.n1.tone(94),
      surfaceContainerHigh: core.n1.tone(92),
      surfaceContainerHighest: core.n1.tone(90),
      primaryFixed: core.a1.tone(90),
      onPrimaryFixed: core.a1.tone(10),
      primaryFixedDim: core.a1.tone(80),
      onPrimaryFixedVariant: core.a1.tone(30),
      secondaryFixed: core.a2.tone(90),
      onSecondaryFixed: core.a2.tone(10),
      secondaryFixedDim: core.a2.tone(80),
      onSecondaryFixedVariant: core.a2.tone(30),  
      tertiaryFixed: core.a3.tone(90),
      onTertiaryFixed: core.a3.tone(10),
      tertiaryFixedDim: core.a3.tone(80),
      onTertiaryFixedVariant: core.a3.tone(30),
      surfaceBright: core.n1.tone(98),
      surfaceDim: core.n1.tone(87),
      surfaceTint: core.a1.tone(40),
    });
  }

  /**
   * Dark scheme from core palette
   */
  static darkFromCorePalette(core: CorePalette): Scheme {
    return new Scheme({
      primary: core.a1.tone(80),
      onPrimary: core.a1.tone(20),
      primaryContainer: core.a1.tone(30),
      onPrimaryContainer: core.a1.tone(90),
      secondary: core.a2.tone(80),
      onSecondary: core.a2.tone(20),
      secondaryContainer: core.a2.tone(30),
      onSecondaryContainer: core.a2.tone(90),
      tertiary: core.a3.tone(80),
      onTertiary: core.a3.tone(20),
      tertiaryContainer: core.a3.tone(30),
      onTertiaryContainer: core.a3.tone(90),
      error: core.error.tone(80),
      onError: core.error.tone(20),
      errorContainer: core.error.tone(30),
      onErrorContainer: core.error.tone(90),
      background: core.n1.tone(6),
      onBackground: core.n1.tone(90),
      surface: core.n1.tone(6),
      onSurface: core.n1.tone(90),
      surfaceVariant: core.n2.tone(30),
      onSurfaceVariant: core.n2.tone(80),
      outline: core.n2.tone(60),
      outlineVariant: core.n2.tone(30),
      shadow: core.n1.tone(0),
      scrim: core.n1.tone(0),
      inverseSurface: core.n1.tone(90),
      inverseOnSurface: core.n1.tone(20),
      inversePrimary: core.a1.tone(40),
      surfaceContainerLowest: core.n1.tone(4),
      surfaceContainerLow: core.n1.tone(10),
      surfaceContainer: core.n1.tone(12),
      surfaceContainerHigh: core.n1.tone(17),
      surfaceContainerHighest: core.n1.tone(22),
      primaryFixed: core.a1.tone(90),
      onPrimaryFixed: core.a1.tone(10),
      primaryFixedDim: core.a1.tone(80),
      onPrimaryFixedVariant: core.a1.tone(30),
      secondaryFixed: core.a2.tone(90),
      onSecondaryFixed: core.a2.tone(10),
      secondaryFixedDim: core.a2.tone(80),
      onSecondaryFixedVariant: core.a2.tone(30),  
      tertiaryFixed: core.a3.tone(90),
      onTertiaryFixed: core.a3.tone(10),
      tertiaryFixedDim: core.a3.tone(80),
      onTertiaryFixedVariant: core.a3.tone(30),
      surfaceBright: core.n1.tone(24),
      surfaceDim: core.n1.tone(6),
      surfaceTint: core.a1.tone(80),
    });
  }

  private constructor(private readonly props: {
    primary: number,
    onPrimary: number,
    primaryContainer: number,
    onPrimaryContainer: number,
    secondary: number,
    onSecondary: number,
    secondaryContainer: number,
    onSecondaryContainer: number,
    tertiary: number,
    onTertiary: number,
    tertiaryContainer: number,
    onTertiaryContainer: number,
    error: number,
    onError: number,
    errorContainer: number,
    onErrorContainer: number,
    background: number,
    onBackground: number,
    surface: number,
    onSurface: number,
    surfaceVariant: number,
    onSurfaceVariant: number,
    outline: number,
    outlineVariant: number,
    shadow: number,
    scrim: number,
    inverseSurface: number,
    inverseOnSurface: number,
    inversePrimary: number,
    surfaceContainerLowest: number,
    surfaceContainerLow: number,
    surfaceContainer: number,
    surfaceContainerHigh: number,
    surfaceContainerHighest: number,
    primaryFixed: number,
    onPrimaryFixed: number,
    primaryFixedDim: number,
    onPrimaryFixedVariant: number,
    secondaryFixed: number,
    onSecondaryFixed: number,
    secondaryFixedDim: number,
    onSecondaryFixedVariant: number  
    tertiaryFixed: number,
    onTertiaryFixed: number,
    tertiaryFixedDim: number,
    onTertiaryFixedVariant: number,
    surfaceBright: number,
    surfaceDim: number,
    surfaceTint: number,
  }) {}

  toJSON() {
    return {
      ...this.props
    };
  }
}
