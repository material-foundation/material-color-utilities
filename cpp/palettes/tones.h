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

#ifndef CPP_PALETTES_TONES_H_
#define CPP_PALETTES_TONES_H_

#include "cpp/utils/utils.h"

namespace material_color_utilities {

class TonalPalette {
 public:
  explicit TonalPalette(Argb argb);
  TonalPalette(double hue, double chroma);

  /**
   * Returns the color for a given tone in this palette.
   *
   * @param tone 0.0 <= tone <= 100.0
   * @return a color as an integer, in ARGB format.
   */
  Argb get(double tone) const;

 private:
  double hue_;
  double chroma_;
};

}  // namespace material_color_utilities
#endif  // CPP_PALETTES_TONES_H_
