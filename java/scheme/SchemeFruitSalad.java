/*
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
package scheme;

import static dynamiccolor.DynamicScheme.Platform.PHONE;

import dynamiccolor.ColorSpec.SpecVersion;
import dynamiccolor.ColorSpecs;
import dynamiccolor.DynamicScheme;
import dynamiccolor.Variant;
import hct.Hct;

/** A playful theme - the source color's hue does not appear in the theme. */
public class SchemeFruitSalad extends DynamicScheme {
  public SchemeFruitSalad(Hct sourceColorHct, boolean isDark, double contrastLevel) {
    super(
        sourceColorHct,
        Variant.FRUIT_SALAD,
        isDark,
        contrastLevel,
        ColorSpecs.get(SpecVersion.SPEC_2021)
            .getPrimaryPalette(Variant.FRUIT_SALAD, sourceColorHct, isDark, PHONE, contrastLevel),
        ColorSpecs.get(SpecVersion.SPEC_2021)
            .getSecondaryPalette(Variant.FRUIT_SALAD, sourceColorHct, isDark, PHONE, contrastLevel),
        ColorSpecs.get(SpecVersion.SPEC_2021)
            .getTertiaryPalette(Variant.FRUIT_SALAD, sourceColorHct, isDark, PHONE, contrastLevel),
        ColorSpecs.get(SpecVersion.SPEC_2021)
            .getNeutralPalette(Variant.FRUIT_SALAD, sourceColorHct, isDark, PHONE, contrastLevel),
        ColorSpecs.get(SpecVersion.SPEC_2021)
            .getNeutralVariantPalette(
                Variant.FRUIT_SALAD, sourceColorHct, isDark, PHONE, contrastLevel),
        ColorSpecs.get(SpecVersion.SPEC_2021)
            .getErrorPalette(Variant.FRUIT_SALAD, sourceColorHct, isDark, PHONE, contrastLevel));
  }
}