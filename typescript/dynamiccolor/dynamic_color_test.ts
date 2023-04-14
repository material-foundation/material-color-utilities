/**
 * @license
 * Copyright 2023 Google LLC
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

import 'jasmine';

import {Contrast} from '../contrast/contrast.js';
import {DynamicColor} from '../dynamiccolor/dynamic_color.js';
import {MaterialDynamicColors} from '../dynamiccolor/material_dynamic_colors.js';
import {Hct} from '../hct/hct.js';
import {SchemeMonochrome} from '../scheme/scheme_monochrome.js';
import {SchemeTonalSpot} from '../scheme/scheme_tonal_spot.js';

const seedColors = [
  Hct.fromInt(0xFFFF0000),
  Hct.fromInt(0xFFFFFF00),
  Hct.fromInt(0xFF00FF00),
  Hct.fromInt(0xFF0000FF),
];

const contrastLevels = [-1.0, -0.5, 0.0, 0.5, 1.0];

class Pair {
  constructor(public fgName: string, public bgName: string) {}
}

const colors: Record<string, DynamicColor> = {
  'background': MaterialDynamicColors.background,
  'onBackground': MaterialDynamicColors.onBackground,
  'surface': MaterialDynamicColors.surface,
  'surfaceDim': MaterialDynamicColors.surfaceDim,
  'surfaceBright': MaterialDynamicColors.surfaceBright,
  'surfaceContainerLowest': MaterialDynamicColors.surfaceContainerLowest,
  'surfaceContainerLow': MaterialDynamicColors.surfaceContainerLow,
  'surfaceContainer': MaterialDynamicColors.surfaceContainer,
  'surfaceContainerHigh': MaterialDynamicColors.surfaceContainerHigh,
  'surfaceContainerHighest': MaterialDynamicColors.surfaceContainerHighest,
  'onSurface': MaterialDynamicColors.onSurface,
  'surfaceVariant': MaterialDynamicColors.surfaceVariant,
  'onSurfaceVariant': MaterialDynamicColors.onSurfaceVariant,
  'outline': MaterialDynamicColors.outline,
  'primary': MaterialDynamicColors.primary,
  'onPrimary': MaterialDynamicColors.onPrimary,
  'primaryContainer': MaterialDynamicColors.primaryContainer,
  'onPrimaryContainer': MaterialDynamicColors.onPrimaryContainer,
  'secondary': MaterialDynamicColors.secondary,
  'onSecondary': MaterialDynamicColors.onSecondary,
  'secondaryContainer': MaterialDynamicColors.secondaryContainer,
  'onSecondaryContainer': MaterialDynamicColors.onSecondaryContainer,
  'tertiary': MaterialDynamicColors.tertiary,
  'onTertiary': MaterialDynamicColors.onTertiary,
  'tertiaryContainer': MaterialDynamicColors.tertiaryContainer,
  'onTertiaryContainer': MaterialDynamicColors.onTertiaryContainer,
  'error': MaterialDynamicColors.error,
  'onError': MaterialDynamicColors.onError,
  'errorContainer': MaterialDynamicColors.errorContainer,
  'onErrorContainer': MaterialDynamicColors.onErrorContainer,
};

const textSurfacePairs = [
  new Pair('onPrimary', 'primary'),
  new Pair('onPrimaryContainer', 'primaryContainer'),
  new Pair('onSecondary', 'secondary'),
  new Pair('onSecondaryContainer', 'secondaryContainer'),
  new Pair('onTertiary', 'tertiary'),
  new Pair('onTertiaryContainer', 'tertiaryContainer'),
  new Pair('onError', 'error'),
  new Pair('onErrorContainer', 'errorContainer'),
  new Pair('onBackground', 'background'),
  new Pair('onSurfaceVariant', 'surfaceVariant'),
];

describe('DynamicColor', () => {
  // Parametric test, ensuring that dynamic schemes respect contrast
  // between text-surface pairs.

  it('generates colors respecting contrast', () => {
    for (const color of seedColors) {
      for (const contrastLevel of contrastLevels) {
        for (const isDark of [false, true]) {
          for (const scheme
                   of [new SchemeMonochrome(color, isDark, contrastLevel),
                       new SchemeTonalSpot(color, isDark, contrastLevel)]) {
            for (const pair of textSurfacePairs) {
              // Expect that each text-surface pair has a
              // minimum contrast of 4.5 (unreduced contrast), or 3.0
              // (reduced contrast).
              const fgName = pair.fgName;
              const bgName = pair.bgName;
              const foregroundTone = colors[fgName].getHct(scheme).tone;
              const backgroundTone = colors[bgName].getHct(scheme).tone;
              const contrast =
                  Contrast.ratioOfTones(foregroundTone, backgroundTone);

              const minimumRequirement = contrastLevel >= 0.0 ? 4.5 : 3.0;

              expect(contrast).toBeGreaterThanOrEqual(minimumRequirement);
            }
          }
        }
      }
    }
  });
});
