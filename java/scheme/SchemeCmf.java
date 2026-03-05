/*
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

package scheme;

import dynamiccolor.ColorSpec.SpecVersion;
import dynamiccolor.DynamicScheme;
import dynamiccolor.Variant;
import hct.Hct;
import palettes.TonalPalette;
import java.util.Collections;
import java.util.List;
import java.util.Optional;

/** A Dynamic Color theme with 2 source colors. */
public class SchemeCmf extends DynamicScheme {

  public SchemeCmf(Hct sourceColorHct, boolean isDark, double contrastLevel) {
    this(sourceColorHct, isDark, contrastLevel, SpecVersion.SPEC_2026, DEFAULT_PLATFORM);
  }

  public SchemeCmf(
      Hct sourceColorHct,
      boolean isDark,
      double contrastLevel,
      SpecVersion specVersion,
      Platform platform) {
    this(Collections.singletonList(sourceColorHct), isDark, contrastLevel, specVersion, platform);
  }

  public SchemeCmf(List<Hct> sourceColorHctList, boolean isDark, double contrastLevel) {
    this(sourceColorHctList, isDark, contrastLevel, SpecVersion.SPEC_2026, DEFAULT_PLATFORM);
  }

  public SchemeCmf(
      List<Hct> sourceColorHctList,
      boolean isDark,
      double contrastLevel,
      SpecVersion specVersion,
      Platform platform) {
    super(
        sourceColorHctList,
        Variant.CMF,
        isDark,
        contrastLevel,
        platform,
        specVersion,
        TonalPalette.fromHueAndChroma(
            sourceColorHctList.get(0).getHue(), sourceColorHctList.get(0).getChroma()),
        TonalPalette.fromHueAndChroma(
            sourceColorHctList.get(0).getHue(), sourceColorHctList.get(0).getChroma() * 0.5),
        tertiaryPalette(sourceColorHctList),
        TonalPalette.fromHueAndChroma(
            sourceColorHctList.get(0).getHue(), sourceColorHctList.get(0).getChroma() * 0.2),
        TonalPalette.fromHueAndChroma(
            sourceColorHctList.get(0).getHue(), sourceColorHctList.get(0).getChroma() * 0.2),
        Optional.of(
            TonalPalette.fromHueAndChroma(
                getErrorHue(
                    sourceColorHctList.get(0).getHue(),
                    tertiaryPalette(sourceColorHctList).getHue()),
                Math.max(sourceColorHctList.get(0).getChroma(), 50.0))));
    if (specVersion != SpecVersion.SPEC_2026) {
      throw new IllegalArgumentException("SchemeCmf can only be used with spec version 2026.");
    }
  }

  private static TonalPalette tertiaryPalette(List<Hct> sourceColorHctList) {
    Hct sourceColorHct = sourceColorHctList.get(0);
    Hct secondarySourceColorHct =
        sourceColorHctList.size() > 1 ? sourceColorHctList.get(1) : sourceColorHct;
    if (sourceColorHct.toInt() == secondarySourceColorHct.toInt()) {
      return TonalPalette.fromHueAndChroma(
          sourceColorHct.getHue(), sourceColorHct.getChroma() * 0.75);
    } else {
      return TonalPalette.fromHueAndChroma(
          secondarySourceColorHct.getHue(), secondarySourceColorHct.getChroma());
    }
  }

  private static double getErrorHue(double primaryHue, double tertiaryHue) {
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
