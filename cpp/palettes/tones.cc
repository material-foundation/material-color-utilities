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

#include <cmath>

#include "cpp/cam/cam.h"
#include "cpp/cam/hct.h"

namespace material_color_utilities {

TonalPalette::TonalPalette(Argb argb) : key_color_(0.0, 0.0, 0.0) {
  Cam cam = CamFromInt(argb);
  hue_ = cam.hue;
  chroma_ = cam.chroma;
  key_color_ = createKeyColor(cam.hue, cam.chroma);
}

TonalPalette::TonalPalette(Hct hct)
    : key_color_(hct.get_hue(), hct.get_chroma(), hct.get_tone()) {
  hue_ = hct.get_hue();
  chroma_ = hct.get_chroma();
}

TonalPalette::TonalPalette(double hue, double chroma)
    : key_color_(hue, chroma, 0.0) {
  hue_ = hue;
  chroma_ = chroma;
  key_color_ = createKeyColor(hue, chroma);
}

TonalPalette::TonalPalette(double hue, double chroma, Hct key_color)
    : key_color_(key_color.get_hue(), key_color.get_chroma(),
                 key_color.get_tone()) {
  hue_ = hue;
  chroma_ = chroma;
}

Argb TonalPalette::get(double tone) const {
  return IntFromHcl(hue_, chroma_, tone);
}

Hct TonalPalette::createKeyColor(double hue, double chroma) {
  double start_tone = 50.0;
  Hct smallest_delta_hct(hue, chroma, start_tone);
  double smallest_delta = abs(smallest_delta_hct.get_chroma() - chroma);
  // Starting from T50, check T+/-delta to see if they match the requested
  // chroma.
  //
  // Starts from T50 because T50 has the most chroma available, on
  // average. Thus it is most likely to have a direct answer and minimize
  // iteration.
  for (double delta = 1.0; delta < 50.0; delta += 1.0) {
    // Termination condition rounding instead of minimizing delta to avoid
    // case where requested chroma is 16.51, and the closest chroma is 16.49.
    // Error is minimized, but when rounded and displayed, requested chroma
    // is 17, key color's chroma is 16.
    if (round(chroma) == round(smallest_delta_hct.get_chroma())) {
      return smallest_delta_hct;
    }
    Hct hct_add(hue, chroma, start_tone + delta);
    double hct_add_delta = abs(hct_add.get_chroma() - chroma);
    if (hct_add_delta < smallest_delta) {
      smallest_delta = hct_add_delta;
      smallest_delta_hct = hct_add;
    }
    Hct hct_subtract(hue, chroma, start_tone - delta);
    double hct_subtract_delta = abs(hct_subtract.get_chroma() - chroma);
    if (hct_subtract_delta < smallest_delta) {
      smallest_delta = hct_subtract_delta;
      smallest_delta_hct = hct_subtract;
    }
  }
  return smallest_delta_hct;
}

}  // namespace material_color_utilities
