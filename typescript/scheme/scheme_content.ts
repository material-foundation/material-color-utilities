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

import {DislikeAnalyzer} from '../dislike/dislike_analyzer.js';
import {Hct} from '../hct/hct.js';
import {TonalPalette} from '../palettes/tonal_palette.js';
import {TemperatureCache} from '../temperature/temperature_cache.js';

import {DynamicScheme} from './dynamic_scheme.js';
import {Variant} from './variant.js';

/**
 * A scheme that places the source color in `Scheme.primaryContainer`.
 *
 * Primary Container is the source color, adjusted for color relativity.
 * It maintains constant appearance in light mode and dark mode.
 * This adds ~5 tone in light mode, and subtracts ~5 tone in dark mode.
 * Tertiary Container is the complement to the source color, using
 * `TemperatureCache`. It also maintains constant appearance.
 */
export class SchemeContent extends DynamicScheme {
  constructor(sourceColorHct: Hct, isDark: boolean, contrastLevel: number) {
    super({
      sourceColorArgb: sourceColorHct.toInt(),
      variant: Variant.CONTENT,
      contrastLevel,
      isDark,
      primaryPalette: TonalPalette.fromHueAndChroma(
          sourceColorHct.hue, sourceColorHct.chroma),
      secondaryPalette: TonalPalette.fromHueAndChroma(
          sourceColorHct.hue,
          Math.max(sourceColorHct.chroma - 32.0, sourceColorHct.chroma * 0.5)),
      tertiaryPalette: TonalPalette.fromInt(
          DislikeAnalyzer
              .fixIfDisliked(
                  new TemperatureCache(sourceColorHct).analogous(3, 6)[2])
              .toInt()),
      neutralPalette: TonalPalette.fromHueAndChroma(
          sourceColorHct.hue, sourceColorHct.chroma / 8.0),
      neutralVariantPalette: TonalPalette.fromHueAndChroma(
          sourceColorHct.hue, sourceColorHct.chroma / 8.0 + 4.0),
    });
  }
}
