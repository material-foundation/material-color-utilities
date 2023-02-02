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

#include <map>
#include <vector>

#include "testing/base/public/gunit.h"

namespace material_color_utilities {

namespace {

TEST(ScoreTest, MostChromaWins) {
  std::map<Argb, int> argb_to_population = {
      {0xff000000, 1}, {0xffffffff, 1}, {0xff0000ff, 1}};

  std::vector<Argb> ranked = RankedSuggestions(argb_to_population);

  EXPECT_EQ(ranked.size(), 1u);
  EXPECT_EQ(ranked[0], 0xff0000ff);
}

TEST(ScoreTest, MostChromaWins2) {
  std::map<Argb, int> argb_to_population = {
      {0xffff0000, 1}, {0xff00ff00, 1}, {0xff0000ff, 1}};

  std::vector<Argb> ranked = RankedSuggestions(argb_to_population);

  EXPECT_EQ(ranked.size(), 3u);
  EXPECT_EQ(ranked[0], 0xffff0000);
  EXPECT_EQ(ranked[1], 0xff00ff00);
  EXPECT_EQ(ranked[2], 0xff0000ff);
}

TEST(ScoreTest, DedupesNearbyHues) {
  std::map<Argb, int> argb_to_population = {{0xff008772, 1}, {0xff318477, 1}};

  std::vector<Argb> ranked = RankedSuggestions(argb_to_population);

  EXPECT_EQ(ranked.size(), 1u);
  EXPECT_EQ(ranked[0], 0xff008772);
}

TEST(ScoreTest, UsesGblueFallback) {
  std::map<Argb, int> argb_to_population = {{0xff000000, 1}};

  std::vector<Argb> ranked = RankedSuggestions(argb_to_population);

  EXPECT_EQ(ranked.size(), 1u);
  EXPECT_EQ(ranked[0], 0xff4285f4);
}

}  // namespace
}  // namespace material_color_utilities
