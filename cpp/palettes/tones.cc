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

#include "cpp/palettes/tones.h"

#include <cstdlib>

#include "cpp/cam/cam.h"

namespace material_color_utilities {

TonalPalette::TonalPalette(Argb argb) {
  Cam cam = CamFromInt(argb);
  hue_ = cam.hue;
  chroma_ = cam.chroma;
}

TonalPalette::TonalPalette(double hue, double chroma) {
  hue_ = hue;
  chroma_ = chroma;
}

Argb TonalPalette::get(double tone) const {
  return IntFromHcl(hue_, chroma_, tone);
}

}  // namespace material_color_utilities
