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

#ifndef CPP_PALETTES_CORE_H_
#define CPP_PALETTES_CORE_H_

#include "cpp/palettes/tones.h"

namespace material_color_utilities {

/**
 * An intermediate concept between the key color for a UI theme, and a full
 * color scheme. 5 tonal palettes are generated, all except one use the same
 * hue as the key color, and all vary in chroma.
 */
class CorePalette {
 public:
  /**
   * Creates a CorePalette from a hue and a chroma.
   */
  static CorePalette Of(double hue, double chroma);

  /**
   * Creates a CorePalette from a source color in ARGB format.
   */
  static CorePalette Of(int argb);

  /**
   * Creates a content CorePalette from a hue and a chroma.
   */
  static CorePalette ContentOf(double hue, double chroma);

  /**
   * Creates a content CorePalette from a source color in ARGB format.
   */
  static CorePalette ContentOf(int argb);

  TonalPalette primary();
  TonalPalette secondary();
  TonalPalette tertiary();
  TonalPalette neutral();
  TonalPalette neutral_variant();
  TonalPalette error();

 private:
  CorePalette(double hue, double chroma, bool is_content);

  TonalPalette primary_;
  TonalPalette secondary_;
  TonalPalette tertiary_;
  TonalPalette neutral_;
  TonalPalette neutral_variant_;
  TonalPalette error_;
};

}  // namespace material_color_utilities

#endif  // CPP_PALETTES_CORE_H_
