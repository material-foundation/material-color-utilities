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

import {ColorSpecDelegateImpl2025} from './color_spec_2025.js';
import {DynamicColor} from './dynamic_color.js';
import type {DynamicScheme} from './dynamic_scheme';

/**
 * DynamicColors for the colors in the Material Design system.
 */
// Material Color Utilities namespaces the various utilities it provides.
// tslint:disable-next-line:class-as-namespace
export class MaterialDynamicColors {
  static contentAccentToneDelta = 15.0;

  private static readonly colorSpec = new ColorSpecDelegateImpl2025();

  highestSurface(s: DynamicScheme): DynamicColor {
    return MaterialDynamicColors.colorSpec.highestSurface(s);
  }

  ////////////////////////////////////////////////////////////////
  // Main Palettes                                              //
  ////////////////////////////////////////////////////////////////

  primaryPaletteKeyColor(): DynamicColor {
    return MaterialDynamicColors.colorSpec.primaryPaletteKeyColor();
  }

  secondaryPaletteKeyColor(): DynamicColor {
    return MaterialDynamicColors.colorSpec.secondaryPaletteKeyColor();
  }

  tertiaryPaletteKeyColor(): DynamicColor {
    return MaterialDynamicColors.colorSpec.tertiaryPaletteKeyColor();
  }

  neutralPaletteKeyColor(): DynamicColor {
    return MaterialDynamicColors.colorSpec.neutralPaletteKeyColor();
  }

  neutralVariantPaletteKeyColor(): DynamicColor {
    return MaterialDynamicColors.colorSpec.neutralVariantPaletteKeyColor();
  }

  errorPaletteKeyColor(): DynamicColor {
    return MaterialDynamicColors.colorSpec.errorPaletteKeyColor();
  }

  ////////////////////////////////////////////////////////////////
  // Surfaces [S]                                               //
  ////////////////////////////////////////////////////////////////

  background(): DynamicColor {
    return MaterialDynamicColors.colorSpec.background();
  }

  onBackground(): DynamicColor {
    return MaterialDynamicColors.colorSpec.onBackground();
  }

  surface(): DynamicColor {
    return MaterialDynamicColors.colorSpec.surface();
  }

  surfaceDim(): DynamicColor {
    return MaterialDynamicColors.colorSpec.surfaceDim();
  }

  surfaceBright(): DynamicColor {
    return MaterialDynamicColors.colorSpec.surfaceBright();
  }

  surfaceContainerLowest(): DynamicColor {
    return MaterialDynamicColors.colorSpec.surfaceContainerLowest();
  }

  surfaceContainerLow(): DynamicColor {
    return MaterialDynamicColors.colorSpec.surfaceContainerLow();
  }

  surfaceContainer(): DynamicColor {
    return MaterialDynamicColors.colorSpec.surfaceContainer();
  }

  surfaceContainerHigh(): DynamicColor {
    return MaterialDynamicColors.colorSpec.surfaceContainerHigh();
  }

  surfaceContainerHighest(): DynamicColor {
    return MaterialDynamicColors.colorSpec.surfaceContainerHighest();
  }

  onSurface(): DynamicColor {
    return MaterialDynamicColors.colorSpec.onSurface();
  }

  surfaceVariant(): DynamicColor {
    return MaterialDynamicColors.colorSpec.surfaceVariant();
  }

  onSurfaceVariant(): DynamicColor {
    return MaterialDynamicColors.colorSpec.onSurfaceVariant();
  }

  outline(): DynamicColor {
    return MaterialDynamicColors.colorSpec.outline();
  }

  outlineVariant(): DynamicColor {
    return MaterialDynamicColors.colorSpec.outlineVariant();
  }

  inverseSurface(): DynamicColor {
    return MaterialDynamicColors.colorSpec.inverseSurface();
  }

  inverseOnSurface(): DynamicColor {
    return MaterialDynamicColors.colorSpec.inverseOnSurface();
  }

  shadow(): DynamicColor {
    return MaterialDynamicColors.colorSpec.shadow();
  }

  scrim(): DynamicColor {
    return MaterialDynamicColors.colorSpec.scrim();
  }

  surfaceTint(): DynamicColor {
    return MaterialDynamicColors.colorSpec.surfaceTint();
  }

  ////////////////////////////////////////////////////////////////
  // Primaries [P]                                              //
  ////////////////////////////////////////////////////////////////

  primary(): DynamicColor {
    return MaterialDynamicColors.colorSpec.primary();
  }

  primaryDim(): DynamicColor|undefined {
    return MaterialDynamicColors.colorSpec.primaryDim();
  }

  onPrimary(): DynamicColor {
    return MaterialDynamicColors.colorSpec.onPrimary();
  }

  primaryContainer(): DynamicColor {
    return MaterialDynamicColors.colorSpec.primaryContainer();
  }

  onPrimaryContainer(): DynamicColor {
    return MaterialDynamicColors.colorSpec.onPrimaryContainer();
  }

  inversePrimary(): DynamicColor {
    return MaterialDynamicColors.colorSpec.inversePrimary();
  }

  /////////////////////////////////////////////////////////////////
  // Primary Fixed [PF]                                          //
  /////////////////////////////////////////////////////////////////

  primaryFixed(): DynamicColor {
    return MaterialDynamicColors.colorSpec.primaryFixed();
  }

  primaryFixedDim(): DynamicColor {
    return MaterialDynamicColors.colorSpec.primaryFixedDim();
  }

  onPrimaryFixed(): DynamicColor {
    return MaterialDynamicColors.colorSpec.onPrimaryFixed();
  }

  onPrimaryFixedVariant(): DynamicColor {
    return MaterialDynamicColors.colorSpec.onPrimaryFixedVariant();
  }

  ////////////////////////////////////////////////////////////////
  // Secondaries [Q]                                            //
  ////////////////////////////////////////////////////////////////

  secondary(): DynamicColor {
    return MaterialDynamicColors.colorSpec.secondary();
  }

  secondaryDim(): DynamicColor|undefined {
    return MaterialDynamicColors.colorSpec.secondaryDim();
  }

  onSecondary(): DynamicColor {
    return MaterialDynamicColors.colorSpec.onSecondary();
  }

  secondaryContainer(): DynamicColor {
    return MaterialDynamicColors.colorSpec.secondaryContainer();
  }

  onSecondaryContainer(): DynamicColor {
    return MaterialDynamicColors.colorSpec.onSecondaryContainer();
  }

  /////////////////////////////////////////////////////////////////
  // Secondary Fixed [QF]                                        //
  /////////////////////////////////////////////////////////////////

  secondaryFixed(): DynamicColor {
    return MaterialDynamicColors.colorSpec.secondaryFixed();
  }

  secondaryFixedDim(): DynamicColor {
    return MaterialDynamicColors.colorSpec.secondaryFixedDim();
  }

  onSecondaryFixed(): DynamicColor {
    return MaterialDynamicColors.colorSpec.onSecondaryFixed();
  }

  onSecondaryFixedVariant(): DynamicColor {
    return MaterialDynamicColors.colorSpec.onSecondaryFixedVariant();
  }

  ////////////////////////////////////////////////////////////////
  // Tertiaries [T]                                             //
  ////////////////////////////////////////////////////////////////

  tertiary(): DynamicColor {
    return MaterialDynamicColors.colorSpec.tertiary();
  }

  tertiaryDim(): DynamicColor|undefined {
    return MaterialDynamicColors.colorSpec.tertiaryDim();
  }

  onTertiary(): DynamicColor {
    return MaterialDynamicColors.colorSpec.onTertiary();
  }

  tertiaryContainer(): DynamicColor {
    return MaterialDynamicColors.colorSpec.tertiaryContainer();
  }

  onTertiaryContainer(): DynamicColor {
    return MaterialDynamicColors.colorSpec.onTertiaryContainer();
  }

  /////////////////////////////////////////////////////////////////
  // Tertiary Fixed [TF]                                         //
  /////////////////////////////////////////////////////////////////

  tertiaryFixed(): DynamicColor {
    return MaterialDynamicColors.colorSpec.tertiaryFixed();
  }

  tertiaryFixedDim(): DynamicColor {
    return MaterialDynamicColors.colorSpec.tertiaryFixedDim();
  }

  onTertiaryFixed(): DynamicColor {
    return MaterialDynamicColors.colorSpec.onTertiaryFixed();
  }

  onTertiaryFixedVariant(): DynamicColor {
    return MaterialDynamicColors.colorSpec.onTertiaryFixedVariant();
  }

  ////////////////////////////////////////////////////////////////
  // Errors [E]                                                 //
  ////////////////////////////////////////////////////////////////

  error(): DynamicColor {
    return MaterialDynamicColors.colorSpec.error();
  }

  errorDim(): DynamicColor|undefined {
    return MaterialDynamicColors.colorSpec.errorDim();
  }

  onError(): DynamicColor {
    return MaterialDynamicColors.colorSpec.onError();
  }

  errorContainer(): DynamicColor {
    return MaterialDynamicColors.colorSpec.errorContainer();
  }

  onErrorContainer(): DynamicColor {
    return MaterialDynamicColors.colorSpec.onErrorContainer();
  }

  ////////////////////////////////////////////////////////////////
  // All Colors                                                 //
  ////////////////////////////////////////////////////////////////

  allColors: DynamicColor[] = [
    this.background(),
    this.onBackground(),
    this.surface(),
    this.surfaceDim(),
    this.surfaceBright(),
    this.surfaceContainerLowest(),
    this.surfaceContainerLow(),
    this.surfaceContainer(),
    this.surfaceContainerHigh(),
    this.surfaceContainerHighest(),
    this.onSurface(),
    this.onSurfaceVariant(),
    this.outline(),
    this.outlineVariant(),
    this.inverseSurface(),
    this.inverseOnSurface(),
    this.primary(),
    this.primaryDim(),
    this.onPrimary(),
    this.primaryContainer(),
    this.onPrimaryContainer(),
    this.primaryFixed(),
    this.primaryFixedDim(),
    this.onPrimaryFixed(),
    this.onPrimaryFixedVariant(),
    this.inversePrimary(),
    this.secondary(),
    this.secondaryDim(),
    this.onSecondary(),
    this.secondaryContainer(),
    this.onSecondaryContainer(),
    this.secondaryFixed(),
    this.secondaryFixedDim(),
    this.onSecondaryFixed(),
    this.onSecondaryFixedVariant(),
    this.tertiary(),
    this.tertiaryDim(),
    this.onTertiary(),
    this.tertiaryContainer(),
    this.onTertiaryContainer(),
    this.tertiaryFixed(),
    this.tertiaryFixedDim(),
    this.onTertiaryFixed(),
    this.onTertiaryFixedVariant(),
    this.error(),
    this.errorDim(),
    this.onError(),
    this.errorContainer(),
    this.onErrorContainer(),
  ].filter((c) => c !== undefined);

  // Static variables are deprecated. Use the instance methods to get correct
  // specs based on request.

  /** @deprecated Use highestSurface() instead. */
  static highestSurface(s: DynamicScheme): DynamicColor {
    return MaterialDynamicColors.colorSpec.highestSurface(s);
  }

  /** @deprecated Use primaryPaletteKeyColor() instead. */
  static primaryPaletteKeyColor =
      MaterialDynamicColors.colorSpec.primaryPaletteKeyColor();

  /** @deprecated Use secondaryPaletteKeyColor() instead. */
  static secondaryPaletteKeyColor =
      MaterialDynamicColors.colorSpec.secondaryPaletteKeyColor();

  /** @deprecated Use tertiaryPaletteKeyColor() instead. */
  static tertiaryPaletteKeyColor =
      MaterialDynamicColors.colorSpec.tertiaryPaletteKeyColor();

  /** @deprecated Use neutralPaletteKeyColor() instead. */
  static neutralPaletteKeyColor =
      MaterialDynamicColors.colorSpec.neutralPaletteKeyColor();

  /** @deprecated Use neutralVariantPaletteKeyColor() instead. */
  static neutralVariantPaletteKeyColor =
      MaterialDynamicColors.colorSpec.neutralVariantPaletteKeyColor();

  /** @deprecated Use background() instead. */
  static background = MaterialDynamicColors.colorSpec.background();

  /** @deprecated Use background() instead. */
  static onBackground = MaterialDynamicColors.colorSpec.onBackground();

  /** @deprecated Use surface() instead. */
  static surface = MaterialDynamicColors.colorSpec.surface();

  /** @deprecated Use surfaceDim() instead. */
  static surfaceDim = MaterialDynamicColors.colorSpec.surfaceDim();

  /** @deprecated Use surfaceBright() instead. */
  static surfaceBright = MaterialDynamicColors.colorSpec.surfaceBright();

  /** @deprecated Use surfaceContainerLowest() instead. */
  static surfaceContainerLowest =
      MaterialDynamicColors.colorSpec.surfaceContainerLowest();

  /** @deprecated Use surfaceContainerLow() instead. */
  static surfaceContainerLow =
      MaterialDynamicColors.colorSpec.surfaceContainerLow();

  /** @deprecated Use surfaceContainer() instead. */
  static surfaceContainer = MaterialDynamicColors.colorSpec.surfaceContainer();

  /** @deprecated Use surfaceContainerHigh() instead. */
  static surfaceContainerHigh =
      MaterialDynamicColors.colorSpec.surfaceContainerHigh();

  /** @deprecated Use surfaceContainerHighest() instead. */
  static surfaceContainerHighest =
      MaterialDynamicColors.colorSpec.surfaceContainerHighest();

  /** @deprecated Use onSurface() instead. */
  static onSurface = MaterialDynamicColors.colorSpec.onSurface();

  /** @deprecated Use surfaceVariant() instead. */
  static surfaceVariant = MaterialDynamicColors.colorSpec.surfaceVariant();

  /** @deprecated Use onSurfaceVariant() instead. */
  static onSurfaceVariant = MaterialDynamicColors.colorSpec.onSurfaceVariant();

  /** @deprecated Use inverseSurface() instead. */
  static inverseSurface = MaterialDynamicColors.colorSpec.inverseSurface();

  /** @deprecated Use inverseOnSurface() instead. */
  static inverseOnSurface = MaterialDynamicColors.colorSpec.inverseOnSurface();

  /** @deprecated Use outline() instead. */
  static outline = MaterialDynamicColors.colorSpec.outline();

  /** @deprecated Use outlineVariant() instead. */
  static outlineVariant = MaterialDynamicColors.colorSpec.outlineVariant();

  /** @deprecated Use shadow() instead. */
  static shadow = MaterialDynamicColors.colorSpec.shadow();

  /** @deprecated Use scrim() instead. */
  static scrim = MaterialDynamicColors.colorSpec.scrim();

  /** @deprecated Use surfaceTint() instead. */
  static surfaceTint = MaterialDynamicColors.colorSpec.surfaceTint();

  /** @deprecated Use primary() instead. */
  static primary = MaterialDynamicColors.colorSpec.primary();

  /** @deprecated Use onPrimary() instead. */
  static onPrimary = MaterialDynamicColors.colorSpec.onPrimary();

  /** @deprecated Use primaryContainer() instead. */
  static primaryContainer = MaterialDynamicColors.colorSpec.primaryContainer();

  /** @deprecated Use onPrimaryContainer() instead. */
  static onPrimaryContainer =
      MaterialDynamicColors.colorSpec.onPrimaryContainer();

  /** @deprecated Use inversePrimary() instead. */
  static inversePrimary = MaterialDynamicColors.colorSpec.inversePrimary();

  /** @deprecated Use secondary() instead. */
  static secondary = MaterialDynamicColors.colorSpec.secondary();

  /** @deprecated Use onSecondary() instead. */
  static onSecondary = MaterialDynamicColors.colorSpec.onSecondary();

  /** @deprecated Use secondaryContainer() instead. */
  static secondaryContainer =
      MaterialDynamicColors.colorSpec.secondaryContainer();

  /** @deprecated Use onSecondaryContainer() instead. */
  static onSecondaryContainer =
      MaterialDynamicColors.colorSpec.onSecondaryContainer();

  /** @deprecated Use tertiary() instead. */
  static tertiary = MaterialDynamicColors.colorSpec.tertiary();

  /** @deprecated Use onTertiary() instead. */
  static onTertiary = MaterialDynamicColors.colorSpec.onTertiary();

  /** @deprecated Use tertiaryContainer() instead. */
  static tertiaryContainer = MaterialDynamicColors.colorSpec.tertiaryContainer();

  /** @deprecated Use onTertiaryContainer() instead. */
  static onTertiaryContainer =
      MaterialDynamicColors.colorSpec.onTertiaryContainer();

  /** @deprecated Use error() instead. */
  static error = MaterialDynamicColors.colorSpec.error();

  /** @deprecated Use onError() instead. */
  static onError = MaterialDynamicColors.colorSpec.onError();

  /** @deprecated Use errorContainer() instead. */
  static errorContainer = MaterialDynamicColors.colorSpec.errorContainer();

  /** @deprecated Use onErrorContainer() instead. */
  static onErrorContainer = MaterialDynamicColors.colorSpec.onErrorContainer();

  /** @deprecated Use primaryFixed() instead. */
  static primaryFixed = MaterialDynamicColors.colorSpec.primaryFixed();

  /** @deprecated Use primaryFixedDim() instead. */
  static primaryFixedDim = MaterialDynamicColors.colorSpec.primaryFixedDim();

  /** @deprecated Use onPrimaryFixed() instead. */
  static onPrimaryFixed = MaterialDynamicColors.colorSpec.onPrimaryFixed();

  /** @deprecated Use onPrimaryFixedVariant() instead. */
  static onPrimaryFixedVariant =
      MaterialDynamicColors.colorSpec.onPrimaryFixedVariant();

  /** @deprecated Use secondaryFixed() instead. */
  static secondaryFixed = MaterialDynamicColors.colorSpec.secondaryFixed();

  /** @deprecated Use secondaryFixedDim() instead. */
  static secondaryFixedDim = MaterialDynamicColors.colorSpec.secondaryFixedDim();

  /** @deprecated Use onSecondaryFixed() instead. */
  static onSecondaryFixed = MaterialDynamicColors.colorSpec.onSecondaryFixed();

  /** @deprecated Use onSecondaryFixedVariant() instead. */
  static onSecondaryFixedVariant =
      MaterialDynamicColors.colorSpec.onSecondaryFixedVariant();

  /** @deprecated Use tertiaryFixed() instead. */
  static tertiaryFixed = MaterialDynamicColors.colorSpec.tertiaryFixed();

  /** @deprecated Use tertiaryFixedDim() instead. */
  static tertiaryFixedDim = MaterialDynamicColors.colorSpec.tertiaryFixedDim();

  /** @deprecated Use onTertiaryFixed() instead. */
  static onTertiaryFixed = MaterialDynamicColors.colorSpec.onTertiaryFixed();

  /** @deprecated Use onTertiaryFixedVariant() instead. */
  static onTertiaryFixedVariant =
      MaterialDynamicColors.colorSpec.onTertiaryFixedVariant();
}
