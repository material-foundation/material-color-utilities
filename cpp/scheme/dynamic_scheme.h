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

#ifndef CPP_SCHEME_DYNAMIC_SCHEME_H_
#define CPP_SCHEME_DYNAMIC_SCHEME_H_

#include <vector>

#include "cpp/cam/hct.h"
#include "cpp/palettes/tones.h"
#include "cpp/scheme/variant.h"

namespace material_color_utilities {

struct DynamicScheme {
  Hct source_color_hct;
  Variant variant;
  bool is_dark;
  double contrast_level;

  TonalPalette primary_palette;
  TonalPalette secondary_palette;
  TonalPalette tertiary_palette;
  TonalPalette neutral_palette;
  TonalPalette neutral_variant_palette;
  TonalPalette error_palette;

  DynamicScheme(Argb source_color_argb, Variant variant, double contrast_level,
                bool is_dark, TonalPalette primary_palette,
                TonalPalette secondary_palette, TonalPalette tertiary_palette,
                TonalPalette neutral_palette,
                TonalPalette neutral_variant_palette);

  static double GetRotatedHue(Hct source_color, std::vector<double> hues,
                              std::vector<double> rotations);

  Argb SourceColorArgb() const;
};

}  // namespace material_color_utilities

#endif  // CPP_SCHEME_DYNAMIC_SCHEME_H_
