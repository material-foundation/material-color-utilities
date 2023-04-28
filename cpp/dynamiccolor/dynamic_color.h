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

#ifndef CPP_DYNAMICCOLOR_DYNAMIC_COLOR_H_
#define CPP_DYNAMICCOLOR_DYNAMIC_COLOR_H_

#include <functional>
#include <optional>

#include "cpp/cam/hct.h"
#include "cpp/scheme/dynamic_scheme.h"
#include "cpp/utils/utils.h"

namespace material_color_utilities {

class ToneDeltaConstraint;

/**
 * Given a background tone, find a foreground tone, while ensuring they reach
 * a contrast ratio that is as close to [ratio] as possible.
 *
 * [bgTone] Tone in HCT. Range is 0 to 100, undefined behavior when it falls
 * outside that range.
 * [ratio] The contrast ratio desired between [bgTone] and the return value.
 */
double ForegroundTone(double bg_tone, double ratio);

/**
 * Adjust a tone such that white has 4.5 contrast, if the tone is
 * reasonably close to supporting it.
 */
double EnableLightForeground(double tone);

/**
 * Returns whether [tone] prefers a light foreground.
 *
 * People prefer white foregrounds on ~T60-70. Observed over time, and also
 * by Andrew Somers during research for APCA.
 *
 * T60 used as to create the smallest discontinuity possible when skipping
 * down to T49 in order to ensure light foregrounds.
 *
 * Since `tertiaryContainer` in dark monochrome scheme requires a tone of
 * 60, it should not be adjusted. Therefore, 60 is excluded here.
 */
bool TonePrefersLightForeground(double tone);

/**
 * Returns whether [tone] can reach a contrast ratio of 4.5 with a lighter
 * color.
 */
bool ToneAllowsLightForeground(double tone);

struct DynamicColor {
  std::function<double(const DynamicScheme&)> hue;
  std::function<double(const DynamicScheme&)> chroma;
  std::function<double(const DynamicScheme&)> tone;

  std::function<std::optional<DynamicColor>(const DynamicScheme&)> background;
  std::function<double(const DynamicScheme&)> tone_min_contrast;
  std::function<double(const DynamicScheme&)> tone_max_contrast;
  std::optional<std::function<ToneDeltaConstraint(const DynamicScheme&)>>
      tone_delta_constraint;

  static DynamicColor FromPalette(
      std::function<TonalPalette(const DynamicScheme&)> palette,
      std::function<double(const DynamicScheme&)> tone,
      std::optional<
          std::function<std::optional<DynamicColor>(const DynamicScheme&)>>
          background,
      std::optional<std::function<ToneDeltaConstraint(const DynamicScheme&)>>
          tone_delta_constraint);

  Argb GetArgb(const DynamicScheme& scheme);

  Hct GetHct(const DynamicScheme& scheme);

  double GetTone(const DynamicScheme& scheme);

 private:
  DynamicColor(
      std::function<double(const DynamicScheme&)> hue,
      std::function<double(const DynamicScheme&)> chroma,
      std::function<double(const DynamicScheme&)> tone,
      std::function<std::optional<DynamicColor>(const DynamicScheme&)>
          background,
      std::function<double(const DynamicScheme&)> tone_min_contrast,
      std::function<double(const DynamicScheme&)> tone_max_contrast,
      std::optional<std::function<ToneDeltaConstraint(const DynamicScheme&)>>
          tone_delta_constraint);
};

}  // namespace material_color_utilities

#endif  // CPP_DYNAMICCOLOR_DYNAMIC_COLOR_H_
