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

#include "cpp/palettes/core.h"

#include <cmath>

#include "cpp/cam/cam.h"
#include "cpp/palettes/tones.h"

namespace material_color_utilities {

namespace {

double PrimaryChroma(double chroma, bool is_content) {
  return is_content ? chroma : fmax(chroma, 48);
}

double SecondaryChroma(double chroma, bool is_content) {
  return is_content ? chroma / 3 : 16;
}

double TertiaryChroma(double chroma, bool is_content) {
  return is_content ? chroma / 2 : 24;
}

double NeutralChroma(double chroma, bool is_content) {
  return is_content ? fmin(chroma / 12, 4) : 4;
}

double NeutralVariantChroma(double chroma, bool is_content) {
  return is_content ? fmin(chroma / 6, 8) : 8;
}

}  // namespace

CorePalette::CorePalette(double hue, double chroma, bool is_content)
    : primary_(hue, PrimaryChroma(chroma, is_content)),
      secondary_(hue, SecondaryChroma(chroma, is_content)),
      tertiary_(hue + 60, TertiaryChroma(chroma, is_content)),
      neutral_(hue, NeutralChroma(chroma, is_content)),
      neutral_variant_(hue, NeutralVariantChroma(chroma, is_content)),
      error_(25, 84) {}

CorePalette CorePalette::Of(double hue, double chroma) {
  return CorePalette(hue, chroma, false);
}

CorePalette CorePalette::ContentOf(double hue, double chroma) {
  return CorePalette(hue, chroma, true);
}

CorePalette CorePalette::Of(int argb) {
  Cam cam = CamFromInt(argb);
  return CorePalette(cam.hue, cam.chroma, false);
}

CorePalette CorePalette::ContentOf(int argb) {
  Cam cam = CamFromInt(argb);
  return CorePalette(cam.hue, cam.chroma, true);
}

TonalPalette CorePalette::primary() { return primary_; }

TonalPalette CorePalette::secondary() { return secondary_; }

TonalPalette CorePalette::tertiary() { return tertiary_; }

TonalPalette CorePalette::neutral() { return neutral_; }

TonalPalette CorePalette::neutral_variant() { return neutral_variant_; }

TonalPalette CorePalette::error() { return error_; }

}  // namespace material_color_utilities
