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

#include "cpp/scheme/dynamic_scheme.h"

#include "cpp/cam/hct.h"
#include "cpp/palettes/tones.h"
#include "cpp/scheme/variant.h"
#include "cpp/utils/utils.h"

namespace material_color_utilities {

DynamicScheme::DynamicScheme(Argb source_color_argb, Variant variant,
                             double contrast_level, bool is_dark,
                             TonalPalette primary_palette,
                             TonalPalette secondary_palette,
                             TonalPalette tertiary_palette,
                             TonalPalette neutral_palette,
                             TonalPalette neutral_variant_palette)
    : source_color_hct(Hct(source_color_argb)),
      variant(variant),
      is_dark(is_dark),
      contrast_level(contrast_level),
      primary_palette(primary_palette),
      secondary_palette(secondary_palette),
      tertiary_palette(tertiary_palette),
      neutral_palette(neutral_palette),
      neutral_variant_palette(neutral_variant_palette),
      error_palette(TonalPalette(25.0, 84.0)) {}

double DynamicScheme::GetRotatedHue(Hct source_color, std::vector<double> hues,
                                    std::vector<double> rotations) {
  double source_hue = source_color.get_hue();

  if (rotations.size() == 1) {
    return SanitizeDegreesDouble(source_color.get_hue() + rotations[0]);
  }
  int size = hues.size();
  for (int i = 0; i <= (size - 2); i++) {
    double this_hue = hues[i];
    double next_hue = hues[i + 1];
    if (this_hue < source_hue && source_hue < next_hue) {
      return SanitizeDegreesDouble(source_hue + rotations[i]);
    }
  }

  return source_hue;
}

Argb DynamicScheme::SourceColorArgb() const { return source_color_hct.ToInt(); }

}  // namespace material_color_utilities
