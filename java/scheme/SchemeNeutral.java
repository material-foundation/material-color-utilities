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

/** A theme that's slightly more chromatic than monochrome, which is purely black / white / gray. */
public class SchemeNeutral extends DynamicScheme {

  public SchemeNeutral(Hct sourceColorHct, boolean isDark, double contrastLevel) {
    this(sourceColorHct, isDark, contrastLevel, DEFAULT_SPEC_VERSION, DEFAULT_PLATFORM);
  }

  public SchemeNeutral(
      Hct sourceColorHct,
      boolean isDark,
      double contrastLevel,
      SpecVersion specVersion,
      Platform platform) {
    this(Collections.singletonList(sourceColorHct), isDark, contrastLevel, specVersion, platform);
  }

  public SchemeNeutral(List<Hct> sourceColorHctList, boolean isDark, double contrastLevel) {
    this(sourceColorHctList, isDark, contrastLevel, DEFAULT_SPEC_VERSION, DEFAULT_PLATFORM);
  }

  public SchemeNeutral(
      List<Hct> sourceColorHctList,
      boolean isDark,
      double contrastLevel,
      SpecVersion specVersion,
      Platform platform) {
    super(
        sourceColorHctList,
        Variant.NEUTRAL,
        isDark,
        contrastLevel,
        platform,
        specVersion,
        ColorSpecs.get(specVersion)
            .getPrimaryPalette(
                Variant.NEUTRAL, sourceColorHctList.get(0), isDark, platform, contrastLevel),
        ColorSpecs.get(specVersion)
            .getSecondaryPalette(
                Variant.NEUTRAL, sourceColorHctList.get(0), isDark, platform, contrastLevel),
        ColorSpecs.get(specVersion)
            .getTertiaryPalette(
                Variant.NEUTRAL, sourceColorHctList.get(0), isDark, platform, contrastLevel),
        ColorSpecs.get(specVersion)
            .getNeutralPalette(
                Variant.NEUTRAL, sourceColorHctList.get(0), isDark, platform, contrastLevel),
        ColorSpecs.get(specVersion)
            .getNeutralVariantPalette(
                Variant.NEUTRAL, sourceColorHctList.get(0), isDark, platform, contrastLevel),
        ColorSpecs.get(specVersion)
            .getErrorPalette(
                Variant.NEUTRAL, sourceColorHctList.get(0), isDark, platform, contrastLevel));
  }
}

