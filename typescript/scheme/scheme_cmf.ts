/**
 * @license
 * Copyright 2026 Google LLC
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

import {SpecVersion} from '../dynamiccolor/color_spec.js';
import {DynamicScheme, Platform} from '../dynamiccolor/dynamic_scheme';
import {Variant} from '../dynamiccolor/variant.js';
import {Hct} from '../hct/hct.js';
import {TonalPalette} from '../palettes/tonal_palette.js';

/**
 * A Dynamic Color theme with 2 source colors.
 */
export class SchemeCmf extends DynamicScheme {
  constructor(
      sourceColorHct: Hct, isDark: boolean, contrastLevel: number,
      specVersion?: SpecVersion, platform?: Platform);
  constructor(
      sourceColorHcts: Hct[], isDark: boolean, contrastLevel: number,
      specVersion?: SpecVersion, platform?: Platform);
  constructor(
      sourceColorOrList: Hct|Hct[], isDark: boolean, contrastLevel: number,
      specVersion: SpecVersion = '2026',
      platform: Platform = DynamicScheme.DEFAULT_PLATFORM) {
    if (specVersion !== '2026') {
      throw new Error('SchemeCmf can only be used with spec version 2026.');
    }
    const isArray = Array.isArray(sourceColorOrList);
    const sourceColorHct = isArray ? sourceColorOrList[0] : sourceColorOrList;
    const extraSourceColorsHct = isArray ? sourceColorOrList.slice(1) : [];
    
    const secondarySourceColorHct = extraSourceColorsHct[0] ?? sourceColorHct;

    const primaryPalette = TonalPalette.fromHueAndChroma(
        sourceColorHct.hue, sourceColorHct.chroma);
    const secondaryPalette = TonalPalette.fromHueAndChroma(
        sourceColorHct.hue, sourceColorHct.chroma * 0.5);
    const tertiaryPalette =
        sourceColorHct.toInt() === secondarySourceColorHct.toInt() ?
        TonalPalette.fromHueAndChroma(
            sourceColorHct.hue, sourceColorHct.chroma * 0.75) :
        TonalPalette.fromHueAndChroma(
            secondarySourceColorHct.hue, secondarySourceColorHct.chroma);
    const neutralPalette = TonalPalette.fromHueAndChroma(
        sourceColorHct.hue, sourceColorHct.chroma * 0.2);
    const neutralVariantPalette = TonalPalette.fromHueAndChroma(
        sourceColorHct.hue, sourceColorHct.chroma * 0.2);
    const errorPalette = TonalPalette.fromHueAndChroma(
        SchemeCmf.getErrorHue(sourceColorHct.hue, secondarySourceColorHct.hue),
        Math.max(sourceColorHct.chroma, 50.0));
    super({
      sourceColorHcts: isArray ? sourceColorOrList : [sourceColorOrList],
      variant: Variant.CMF,
      contrastLevel,
      isDark,
      platform,
      specVersion,
      primaryPalette,
      secondaryPalette,
      tertiaryPalette,
      neutralPalette,
      neutralVariantPalette,
      errorPalette,
    });
  }

  static getErrorHue(primaryHue: number, tertiaryHue: number): number {
    if (primaryHue <= 8) {
      return tertiaryHue <= 24 ? 28 : (tertiaryHue <= 32 ? 16 : 20);
    } else if (primaryHue <= 16) {
      return tertiaryHue <= 24 ? 32 : (tertiaryHue <= 32 ? 20 : 24);
    } else if (primaryHue <= 20) {
      return tertiaryHue <= 28 ? 32 : (tertiaryHue <= 32 ? 24 : 28);
    } else if (primaryHue <= 28) {
      return tertiaryHue <= 24 ? 32 : 16;
    } else if (primaryHue <= 32) {
      return tertiaryHue <= 20 ? 24 : (tertiaryHue <= 28 ? 16 : 20);
    } else if (primaryHue <= 40) {
      return (tertiaryHue > 20 && tertiaryHue <= 28) ? 16 : 24;
    } else if (primaryHue <= 152) {
      return (tertiaryHue > 24 && tertiaryHue <= 36) ? 20 : 32;
    } else if (primaryHue <= 272) {
      return (tertiaryHue > 20 && tertiaryHue <= 28) ? 16 : 24;
    } else {
      return (tertiaryHue > 12 && tertiaryHue <= 28) ? 32 : 16;
    }
  }
}