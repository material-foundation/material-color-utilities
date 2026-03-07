/*
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
package scheme;

import dynamiccolor.ColorSpec.SpecVersion;
import dynamiccolor.ColorSpecs;
import dynamiccolor.DynamicScheme;
import dynamiccolor.Variant;
import hct.Hct;
import java.util.Collections;
import java.util.List;

/** A calm theme, sedated colors that aren't particularly chromatic. */
public class SchemeTonalSpot extends DynamicScheme {

  public SchemeTonalSpot(Hct sourceColorHct, boolean isDark, double contrastLevel) {
    this(sourceColorHct, isDark, contrastLevel, DEFAULT_SPEC_VERSION, DEFAULT_PLATFORM);
  }

  public SchemeTonalSpot(
      Hct sourceColorHct,
      boolean isDark,
      double contrastLevel,
      SpecVersion specVersion,
      Platform platform) {
    this(Collections.singletonList(sourceColorHct), isDark, contrastLevel, specVersion, platform);
  }

  public SchemeTonalSpot(List<Hct> sourceColorHctList, boolean isDark, double contrastLevel) {
    this(sourceColorHctList, isDark, contrastLevel, DEFAULT_SPEC_VERSION, DEFAULT_PLATFORM);
  }

  public SchemeTonalSpot(
      List<Hct> sourceColorHctList,
      boolean isDark,
      double contrastLevel,
      SpecVersion specVersion,
      Platform platform) {
    super(
        sourceColorHctList,
        Variant.TONAL_SPOT,
        isDark,
        contrastLevel,
        platform,
        specVersion,
        ColorSpecs.get(specVersion)
            .getPrimaryPalette(
                Variant.TONAL_SPOT, sourceColorHctList.get(0), isDark, platform, contrastLevel),
        ColorSpecs.get(specVersion)
            .getSecondaryPalette(
                Variant.TONAL_SPOT, sourceColorHctList.get(0), isDark, platform, contrastLevel),
        ColorSpecs.get(specVersion)
            .getTertiaryPalette(
                Variant.TONAL_SPOT, sourceColorHctList.get(0), isDark, platform, contrastLevel),
        ColorSpecs.get(specVersion)
            .getNeutralPalette(
                Variant.TONAL_SPOT, sourceColorHctList.get(0), isDark, platform, contrastLevel),
        ColorSpecs.get(specVersion)
            .getNeutralVariantPalette(
                Variant.TONAL_SPOT, sourceColorHctList.get(0), isDark, platform, contrastLevel),
        ColorSpecs.get(specVersion)
            .getErrorPalette(
                Variant.TONAL_SPOT, sourceColorHctList.get(0), isDark, platform, contrastLevel));
  }
}

