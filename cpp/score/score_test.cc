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

#include <cstdint>
#include <map>
#include <vector>

#include "testing/base/public/gunit.h"
#include "cpp/utils/utils.h"

namespace material_color_utilities {

namespace {

TEST(ScoreTest, PrioritizesChroma) {
  std::map<Argb, uint32_t> argb_to_population = {
      {0xff000000, 1}, {0xffffffff, 1}, {0xff0000ff, 1}};

  std::vector<Argb> ranked =
      RankedSuggestions(argb_to_population, {.desired = 4});

  EXPECT_EQ(ranked.size(), 1u);
  EXPECT_EQ(ranked[0], 0xff0000ff);
}

TEST(ScoreTest, PrioritizesChromaWhenProportionsEqual) {
  std::map<Argb, uint32_t> argb_to_population = {
      {0xffff0000, 1}, {0xff00ff00, 1}, {0xff0000ff, 1}};

  std::vector<Argb> ranked =
      RankedSuggestions(argb_to_population, {.desired = 4});

  EXPECT_EQ(ranked.size(), 3u);
  EXPECT_EQ(ranked[0], 0xffff0000);
  EXPECT_EQ(ranked[1], 0xff00ff00);
  EXPECT_EQ(ranked[2], 0xff0000ff);
}

TEST(ScoreTest, GeneratesGblueWhenNoColorsAvailable) {
  std::map<Argb, uint32_t> argb_to_population = {{0xff000000, 1}};

  std::vector<Argb> ranked =
      RankedSuggestions(argb_to_population, {.desired = 4});

  EXPECT_EQ(ranked.size(), 1u);
  EXPECT_EQ(ranked[0], 0xff4285f4);
}

TEST(ScoreTest, DedupesNearbyHues) {
  std::map<Argb, uint32_t> argb_to_population = {
      {0xff008772, 1},  // H 180 C 42 T 50
      {0xff318477, 1}   // H 184 C 35 T 50
  };

  std::vector<Argb> ranked =
      RankedSuggestions(argb_to_population, {.desired = 4});

  EXPECT_EQ(ranked.size(), 1u);
  EXPECT_EQ(ranked[0], 0xff008772);
}

TEST(ScoreTest, MaximizesHueDistance) {
  std::map<Argb, uint32_t> argb_to_population = {
      {0xff008772, 1},  // H 180 C 42 T 50
      {0xff008587, 1},  // H 198 C 50 T 50
      {0xff007ebc, 1}   // H 245 C 50 T 50
  };

  std::vector<Argb> ranked =
      RankedSuggestions(argb_to_population, {.desired = 2});

  EXPECT_EQ(ranked.size(), 2u);
  EXPECT_EQ(ranked[0], 0xff007ebc);
  EXPECT_EQ(ranked[1], 0xff008772);
}

TEST(ScoreTest, GeneratedScenarioOne) {
  std::map<Argb, uint32_t> argb_to_population = {
      {0xff7ea16d, 67},
      {0xffd8ccae, 67},
      {0xff835c0d, 49},
  };

  std::vector<Argb> ranked = RankedSuggestions(
      argb_to_population,
      {.desired = 3, .fallback_color_argb = (int)0xff8d3819, .filter = false});

  EXPECT_EQ(ranked.size(), 3u);
  EXPECT_EQ(ranked[0], 0xff7ea16d);
  EXPECT_EQ(ranked[1], 0xffd8ccae);
  EXPECT_EQ(ranked[2], 0xff835c0d);
}

TEST(ScoreTest, GeneratedScenarioTwo) {
  std::map<Argb, uint32_t> argb_to_population = {
      {0xffd33881, 14},
      {0xff3205cc, 77},
      {0xff0b48cf, 36},
      {0xffa08f5d, 81},
  };

  std::vector<Argb> ranked = RankedSuggestions(
      argb_to_population,
      {.desired = 4, .fallback_color_argb = (int)0xff7d772b, .filter = true});

  EXPECT_EQ(ranked.size(), 3u);
  EXPECT_EQ(ranked[0], 0xff3205cc);
  EXPECT_EQ(ranked[1], 0xffa08f5d);
  EXPECT_EQ(ranked[2], 0xffd33881);
}

TEST(ScoreTest, GeneratedScenarioThree) {
  std::map<Argb, uint32_t> argb_to_population = {
      {0xffbe94a6, 23},
      {0xffc33fd7, 42},
      {0xff899f36, 90},
      {0xff94c574, 82},
  };

  std::vector<Argb> ranked = RankedSuggestions(
      argb_to_population,
      {.desired = 3, .fallback_color_argb = (int)0xffaa79a4, .filter = true});

  EXPECT_EQ(ranked.size(), 3u);
  EXPECT_EQ(ranked[0], 0xff94c574);
  EXPECT_EQ(ranked[1], 0xffc33fd7);
  EXPECT_EQ(ranked[2], 0xffbe94a6);
}

TEST(ScoreTest, GeneratedScenarioFour) {
  std::map<Argb, uint32_t> argb_to_population = {
      {0xffdf241c, 85}, {0xff685859, 44}, {0xffd06d5f, 34},
      {0xff561c54, 27}, {0xff713090, 88},
  };

  std::vector<Argb> ranked = RankedSuggestions(
      argb_to_population,
      {.desired = 5, .fallback_color_argb = (int)0xff58c19c, .filter = false});

  EXPECT_EQ(ranked.size(), 2u);
  EXPECT_EQ(ranked[0], 0xffdf241c);
  EXPECT_EQ(ranked[1], 0xff561c54);
}

TEST(ScoreTest, GeneratedScenarioFive) {
  std::map<Argb, uint32_t> argb_to_population = {
      {0xffbe66f8, 41}, {0xff4bbda9, 88}, {0xff80f6f9, 44},
      {0xffab8017, 43}, {0xffe89307, 65},
  };

  std::vector<Argb> ranked = RankedSuggestions(
      argb_to_population,
      {.desired = 3, .fallback_color_argb = (int)0xff916691, .filter = false});

  EXPECT_EQ(ranked.size(), 3u);
  EXPECT_EQ(ranked[0], 0xffab8017);
  EXPECT_EQ(ranked[1], 0xff4bbda9);
  EXPECT_EQ(ranked[2], 0xffbe66f8);
}

TEST(ScoreTest, GeneratedScenarioSix) {
  std::map<Argb, uint32_t> argb_to_population = {
      {0xff18ea8f, 93}, {0xff327593, 18}, {0xff066a18, 53},
      {0xfffa8a23, 74}, {0xff04ca1f, 62},
  };

  std::vector<Argb> ranked = RankedSuggestions(
      argb_to_population,
      {.desired = 2, .fallback_color_argb = (int)0xff4c377a, .filter = false});

  EXPECT_EQ(ranked.size(), 2u);
  EXPECT_EQ(ranked[0], 0xff18ea8f);
  EXPECT_EQ(ranked[1], 0xfffa8a23);
}

TEST(ScoreTest, GeneratedScenarioSeven) {
  std::map<Argb, uint32_t> argb_to_population = {
      {0xff2e05ed, 23}, {0xff153e55, 90}, {0xff9ab220, 23},
      {0xff153379, 66}, {0xff68bcc3, 81},
  };

  std::vector<Argb> ranked = RankedSuggestions(
      argb_to_population,
      {.desired = 2, .fallback_color_argb = (int)0xfff588dc, .filter = true});

  EXPECT_EQ(ranked.size(), 2u);
  EXPECT_EQ(ranked[0], 0xff2e05ed);
  EXPECT_EQ(ranked[1], 0xff9ab220);
}

TEST(ScoreTest, GeneratedScenarioEight) {
  std::map<Argb, uint32_t> argb_to_population = {
      {0xff816ec5, 24},
      {0xff6dcb94, 19},
      {0xff3cae91, 98},
      {0xff5b542f, 25},
  };

  std::vector<Argb> ranked = RankedSuggestions(
      argb_to_population,
      {.desired = 1, .fallback_color_argb = (int)0xff84b0fd, .filter = false});

  EXPECT_EQ(ranked.size(), 1u);
  EXPECT_EQ(ranked[0], 0xff3cae91);
}

TEST(ScoreTest, GeneratedScenarioNine) {
  std::map<Argb, uint32_t> argb_to_population = {
      {0xff206f86, 52}, {0xff4a620d, 96}, {0xfff51401, 85},
      {0xff2b8ebf, 3},  {0xff277766, 59},
  };

  std::vector<Argb> ranked = RankedSuggestions(
      argb_to_population,
      {.desired = 3, .fallback_color_argb = (int)0xff02b415, .filter = true});

  EXPECT_EQ(ranked.size(), 3u);
  EXPECT_EQ(ranked[0], 0xfff51401);
  EXPECT_EQ(ranked[1], 0xff4a620d);
  EXPECT_EQ(ranked[2], 0xff2b8ebf);
}

TEST(ScoreTest, GeneratedScenarioTen) {
  std::map<Argb, uint32_t> argb_to_population = {
      {0xff8b1d99, 54},
      {0xff27effe, 43},
      {0xff6f558d, 2},
      {0xff77fdf2, 78},
  };

  std::vector<Argb> ranked = RankedSuggestions(
      argb_to_population,
      {.desired = 4, .fallback_color_argb = (int)0xff5e7a10, .filter = true});

  EXPECT_EQ(ranked.size(), 3u);
  EXPECT_EQ(ranked[0], 0xff27effe);
  EXPECT_EQ(ranked[1], 0xff8b1d99);
  EXPECT_EQ(ranked[2], 0xff6f558d);
}

}  // namespace
}  // namespace material_color_utilities
