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

import {DynamicScheme} from './dynamic_scheme.js';
import {Variant} from './variant.js';

/**
 * A Dynamic Color theme with low to medium colorfulness and a Tertiary
 * TonalPalette with a hue related to the source color.
 *
 * The default Material You theme on Android 12 and 13.
 */
export class SchemeTonalSpot extends DynamicScheme {
  constructor(sourceColorHct: Hct, isDark: boolean, contrastLevel: number) {
    super({
      sourceColorArgb: sourceColorHct.toInt(),
      variant: Variant.TONAL_SPOT,
      contrastLevel,
      isDark,
      primaryPalette: TonalPalette.fromHueAndChroma(sourceColorHct.hue, 36.0),
      secondaryPalette: TonalPalette.fromHueAndChroma(sourceColorHct.hue, 16.0),
      tertiaryPalette: TonalPalette.fromHueAndChroma(
          math.sanitizeDegreesDouble(sourceColorHct.hue + 60.0),
          24.0,
          ),
      neutralPalette: TonalPalette.fromHueAndChroma(sourceColorHct.hue, 6.0),
      neutralVariantPalette:
          TonalPalette.fromHueAndChroma(sourceColorHct.hue, 8.0),
    });
  }
}
