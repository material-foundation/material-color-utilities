/**
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

import {CorePalette} from 'palettes/core_palette';

/**
 * Represents a Material color scheme, a mapping of color roles to colors.
 */
export class Scheme {
  get primary(): number {
    return this.props.primary;
  }

  get primaryContainer(): number {
    return this.props.primaryContainer;
  }

  get onPrimary(): number {
    return this.props.onPrimary;
  }

  get onPrimaryContainer(): number {
    return this.props.onPrimaryContainer;
  }

  get secondary(): number {
    return this.props.secondary;
  }

  get secondaryContainer(): number {
    return this.props.secondaryContainer;
  }

  get onSecondary(): number {
    return this.props.onSecondary;
  }

  get onSecondaryContainer(): number {
    return this.props.onSecondaryContainer;
  }

  get tertiary(): number {
    return this.props.tertiary;
  }

  get onTertiary(): number {
    return this.props.onSecondary;
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

  get outline(): number {
    return this.props.outline;
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

  get inverseSurface(): number {
    return this.props.inverseSurface;
  }

  get inverseOnSurface(): number {
    return this.props.inverseOnSurface;
  }

  /**
   * @param argb ARGB representation of a color.
   * @return Light Material color scheme, based on the color's hue.
   */
  static light(argb: number): Scheme {
    const core = CorePalette.of(argb);
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
      outline: core.n2.tone(50),
      background: core.n1.tone(90),
      onBackground: core.n1.tone(10),
      surface: core.n1.tone(99),
      onSurface: core.n1.tone(0),
      surfaceVariant: core.n2.tone(90),
      onSurfaceVariant: core.n2.tone(30),
      inverseSurface: core.n1.tone(20),
      inverseOnSurface: core.n1.tone(95),
    });
  }

  /**
   * @param argb ARGB representation of a color.
   * @return Dark Material color scheme, based on the color's hue.
   */
  static dark(argb: number): Scheme {
    const core = CorePalette.of(argb);
    return new Scheme({
      primary: core.a1.tone(80),
      onPrimary: core.a1.tone(20),
      primaryContainer: core.a1.tone(70),
      onPrimaryContainer: core.a1.tone(10),
      secondary: core.a2.tone(80),
      onSecondary: core.a2.tone(20),
      secondaryContainer: core.a2.tone(70),
      onSecondaryContainer: core.a2.tone(10),
      tertiary: core.a3.tone(80),
      onTertiary: core.a3.tone(20),
      tertiaryContainer: core.a3.tone(70),
      onTertiaryContainer: core.a3.tone(10),
      error: core.error.tone(80),
      onError: core.error.tone(20),
      errorContainer: core.error.tone(70),
      onErrorContainer: core.error.tone(10),
      outline: core.n2.tone(60),
      background: core.n1.tone(10),
      onBackground: core.n1.tone(90),
      surface: core.n1.tone(10),
      onSurface: core.n1.tone(100),
      surfaceVariant: core.n2.tone(30),
      onSurfaceVariant: core.n2.tone(80),
      inverseSurface: core.n1.tone(90),
      inverseOnSurface: core.n1.tone(20)
    });
  }

  private constructor(private readonly props: {
    primary: number,
    primaryContainer: number,
    onPrimary: number,
    onPrimaryContainer: number,
    secondary: number,
    secondaryContainer: number,
    onSecondary: number,
    onSecondaryContainer: number,
    tertiary: number,
    tertiaryContainer: number,
    onTertiary: number,
    onTertiaryContainer: number,
    error: number,
    errorContainer: number,
    onError: number,
    onErrorContainer: number,
    outline: number,
    background: number,
    onBackground: number,
    surface: number,
    onSurface: number,
    surfaceVariant: number,
    onSurfaceVariant: number,
    inverseSurface: number,
    inverseOnSurface: number
  }) {}
}
