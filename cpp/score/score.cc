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

#include "cpp/score/score.h"

#include <algorithm>
#include <cmath>
#include <cstdlib>
#include <map>
#include <vector>

#include "cpp/cam/cam.h"
#include "cpp/utils/utils.h"

namespace material_color_utilities {

constexpr double kCutoffChroma = 15.0;
constexpr double kCutoffExcitedProportion = 0.01;
constexpr double kCutoffTone = 10.0;
constexpr double kTargetChroma = 48.0;  // A1 Chroma
constexpr double kWeightProportion = 0.7;
constexpr double kWeightChromaAbove = 0.3;
constexpr double kWeightChromaBelow = 0.1;

struct AnnotatedColor {
  Argb argb = 0;
  Cam cam;
  double excited_proportion = 0.0;
  double score = 0.0;
};

bool ArgbAndScoreComparator(const AnnotatedColor& a, const AnnotatedColor& b) {
  return a.score > b.score;
}

bool IsAcceptableColor(const AnnotatedColor& color) {
  return color.cam.chroma >= kCutoffChroma &&
         LstarFromArgb(color.argb) >= kCutoffTone &&
         color.excited_proportion >= kCutoffExcitedProportion;
}

bool ColorsAreTooClose(const AnnotatedColor& color_one,
                       const AnnotatedColor& color_two) {
  return DiffDegrees(color_one.cam.hue, color_two.cam.hue) < 15;
}

std::vector<Argb> RankedSuggestions(
    const std::map<Argb, int>& argb_to_population) {
  double population_sum = 0;
  int input_size = argb_to_population.size();

  std::vector<Argb> argbs;
  std::vector<int> populations;

  argbs.reserve(input_size);
  populations.reserve(input_size);

  for (auto const& pair : argb_to_population) {
    argbs.push_back(pair.first);
    populations.push_back(pair.second);
  }

  for (int i = 0; i < input_size; i++) {
    population_sum += populations[i];
  }

  double hue_proportions[361] = {};
  std::vector<AnnotatedColor> colors;

  for (int i = 0; i < input_size; i++) {
    double proportion = populations[i] / population_sum;

    Cam cam = CamFromInt(argbs[i]);

    int hue = SanitizeDegreesInt(round(cam.hue));
    hue_proportions[hue] += proportion;

    colors.push_back({argbs[i], cam, 0, -1});
  }

  for (int i = 0; i < input_size; i++) {
    int hue = round(colors[i].cam.hue);
    for (int j = (hue - 15); j < (hue + 15); j++) {
      int sanitized_hue = SanitizeDegreesInt(j);
      colors[i].excited_proportion += hue_proportions[sanitized_hue];
    }
  }

  for (int i = 0; i < input_size; i++) {
    double proportion_score =
        colors[i].excited_proportion * 100.0 * kWeightProportion;

    double chroma = colors[i].cam.chroma;
    double chroma_weight =
        (chroma > kTargetChroma ? kWeightChromaAbove : kWeightChromaBelow);
    double chroma_score = (chroma - kTargetChroma) * chroma_weight;

    colors[i].score = chroma_score + proportion_score;
  }

  std::sort(colors.begin(), colors.end(), ArgbAndScoreComparator);

  std::vector<AnnotatedColor> selected_colors;

  for (int i = 0; i < input_size; i++) {
    if (!IsAcceptableColor(colors[i])) {
      continue;
    }

    bool is_duplicate_color = false;
    for (size_t j = 0; j < selected_colors.size(); j++) {
      if (ColorsAreTooClose(selected_colors[j], colors[i])) {
        is_duplicate_color = true;
        break;
      }
    }

    if (is_duplicate_color) {
      continue;
    }

    selected_colors.push_back(colors[i]);
  }

  // Use google blue if no colors are selected.
  if (selected_colors.empty()) {
    selected_colors.push_back({0xFF4285F4, {}, 0.0, 0.0});
  }

  std::vector<Argb> return_value(selected_colors.size());

  for (size_t j = 0; j < selected_colors.size(); j++) {
    return_value[j] = selected_colors[j].argb;
  }

  return return_value;
}

}  // namespace material_color_utilities
