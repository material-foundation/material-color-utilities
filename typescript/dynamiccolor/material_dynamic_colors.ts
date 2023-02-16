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

import {DynamicScheme} from '../scheme/dynamic_scheme.js';

import {DynamicColor} from './dynamic_color.js';
import {ToneDeltaConstraint} from './tone_delta_constraint.js';


/**
 * DynamicColors for the colors in the Material Design system.
 */
// Material Color Utilities namespaces the various utilities it provides.
// tslint:disable-next-line:class-as-namespace
export class MaterialDynamicColors {
  static contentAccentToneDelta: number = 15.0;
  static highestSurface(s: DynamicScheme): DynamicColor {
    return s.isDark ? MaterialDynamicColors.surfaceLight :
                      MaterialDynamicColors.surfaceDark;
  }

  static background = DynamicColor.fromPalette({
    palette: (s) => s.neutralPalette,
    tone: (s) => s.isDark ? 6 : 98,
  });

  static onBackground = DynamicColor.fromPalette({
    palette: (s) => s.neutralPalette,
    tone: (s) => s.isDark ? 90 : 10,
    background: (s) => MaterialDynamicColors.background,
  });

  static surface = DynamicColor.fromPalette({
    palette: (s) => s.neutralPalette,
    tone: (s) => s.isDark ? 6 : 98,
  });

  static surfaceDark = DynamicColor.fromPalette({
    palette: (s) => s.neutralPalette,
    tone: (s) => s.isDark ? 6 : 87,
  });

  static surfaceLight = DynamicColor.fromPalette({
    palette: (s) => s.neutralPalette,
    tone: (s) => s.isDark ? 24 : 98,
  });

  static surfaceSub2 = DynamicColor.fromPalette({
    palette: (s) => s.neutralPalette,
    tone: (s) => s.isDark ? 4 : 100,
  });

  static surfaceSub1 = DynamicColor.fromPalette({
    palette: (s) => s.neutralPalette,
    tone: (s) => s.isDark ? 10 : 96,
  });

  static surfaceContainer = DynamicColor.fromPalette({
    palette: (s) => s.neutralPalette,
    tone: (s) => s.isDark ? 12 : 94,
  });

  static surfaceAdd1 = DynamicColor.fromPalette({
    palette: (s) => s.neutralPalette,
    tone: (s) => s.isDark ? 17 : 92,
  });

  static surfaceAdd2 = DynamicColor.fromPalette({
    palette: (s) => s.neutralPalette,
    tone: (s) => s.isDark ? 22 : 90,
  });

  static onSurface = DynamicColor.fromPalette({
    palette: (s) => s.neutralPalette,
    tone: (s) => s.isDark ? 90 : 10,
    background: (s) => MaterialDynamicColors.highestSurface(s),
  });

  static surfaceVariant = DynamicColor.fromPalette({
    palette: (s) => s.neutralVariantPalette,
    tone: (s) => s.isDark ? 30 : 90,
  });

  static onSurfaceVariant = DynamicColor.fromPalette({
    palette: (s) => s.neutralVariantPalette,
    tone: (s) => s.isDark ? 80 : 30,
    background: (s) => MaterialDynamicColors.surfaceVariant,
  });

  static outline = DynamicColor.fromPalette({
    palette: (s) => s.neutralVariantPalette,
    tone: (s) => 50,
    background: (s) => MaterialDynamicColors.highestSurface(s),
  });

  static primary = DynamicColor.fromPalette({
    palette: (s) => s.primaryPalette,
    tone: (s) => s.isDark ? 80 : 40,
    background: (s) => MaterialDynamicColors.highestSurface(s),
    toneDeltaConstraint: (s) => new ToneDeltaConstraint(
        MaterialDynamicColors.contentAccentToneDelta,
        MaterialDynamicColors.primaryContainer,
        s.isDark? 'darker': 'lighter',
        ),
  });

  static onPrimary = DynamicColor.fromPalette({
    palette: (s) => s.primaryPalette,
    tone: (s) => s.isDark ? 20 : 100,
    background: (s) => MaterialDynamicColors.primary,
  });

  static primaryContainer = DynamicColor.fromPalette({
    palette: (s) => s.primaryPalette,
    tone: (s) => s.isDark ? 30 : 90,
    background: (s) => MaterialDynamicColors.highestSurface(s),
  });

  static onPrimaryContainer = DynamicColor.fromPalette({
    palette: (s) => s.primaryPalette,
    tone: (s) => s.isDark ? 90 : 10,
    background: (s) => MaterialDynamicColors.primaryContainer,
  });

  static secondary = DynamicColor.fromPalette({
    palette: (s) => s.secondaryPalette,
    tone: (s) => s.isDark ? 80 : 40,
    background: (s) => MaterialDynamicColors.highestSurface(s),
    toneDeltaConstraint: (s) => new ToneDeltaConstraint(
        MaterialDynamicColors.contentAccentToneDelta,
        MaterialDynamicColors.secondaryContainer,
        s.isDark? 'darker': 'lighter'),
  });

  static onSecondary = DynamicColor.fromPalette({
    palette: (s) => s.secondaryPalette,
    tone: (s) => s.isDark ? 20 : 100,
    background: (s) => MaterialDynamicColors.secondary,
  });

  static secondaryContainer = DynamicColor.fromPalette({
    palette: (s) => s.secondaryPalette,
    tone: (s) => s.isDark ? 30 : 90,
    background: (s) => MaterialDynamicColors.highestSurface(s),
  });

  static onSecondaryContainer = DynamicColor.fromPalette({
    palette: (s) => s.secondaryPalette,
    tone: (s) => s.isDark ? 90 : 10,
    background: (s) => MaterialDynamicColors.secondaryContainer,
  });

  static tertiary = DynamicColor.fromPalette({
    palette: (s) => s.tertiaryPalette,
    tone: (s) => s.isDark ? 80 : 40,
    background: (s) => MaterialDynamicColors.highestSurface(s),
    toneDeltaConstraint: (s) => new ToneDeltaConstraint(
        MaterialDynamicColors.contentAccentToneDelta,
        MaterialDynamicColors.tertiaryContainer, s.isDark? 'darker': 'lighter'),
  });

  static onTertiary = DynamicColor.fromPalette({
    palette: (s) => s.tertiaryPalette,
    tone: (s) => s.isDark ? 20 : 100,
    background: (s) => MaterialDynamicColors.tertiary,
  });

  static tertiaryContainer = DynamicColor.fromPalette({
    palette: (s) => s.tertiaryPalette,
    tone: (s) => s.isDark ? 30 : 90,
    background: (s) => MaterialDynamicColors.highestSurface(s),
  });

  static onTertiaryContainer = DynamicColor.fromPalette({
    palette: (s) => s.tertiaryPalette,
    tone: (s) => s.isDark ? 90 : 10,
    background: (s) => MaterialDynamicColors.tertiaryContainer,
  });

  static error = DynamicColor.fromPalette({
    palette: (s) => s.errorPalette,
    tone: (s) => s.isDark ? 80 : 40,
    background: (s) => MaterialDynamicColors.highestSurface(s),
    toneDeltaConstraint: (s) => new ToneDeltaConstraint(
        MaterialDynamicColors.contentAccentToneDelta,
        MaterialDynamicColors.errorContainer,
        s.isDark? 'darker': 'lighter',
        ),
  });

  static onError = DynamicColor.fromPalette({
    palette: (s) => s.errorPalette,
    tone: (s) => s.isDark ? 20 : 100,
    background: (s) => MaterialDynamicColors.error,
  });

  static errorContainer = DynamicColor.fromPalette({
    palette: (s) => s.errorPalette,
    tone: (s) => s.isDark ? 30 : 90,
    background: (s) => MaterialDynamicColors.highestSurface(s),
  });

  static onErrorContainer = DynamicColor.fromPalette({
    palette: (s) => s.errorPalette,
    tone: (s) => s.isDark ? 90 : 10,
    background: (s) => MaterialDynamicColors.errorContainer,
  });
}
