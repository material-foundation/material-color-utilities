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

#include "cpp/cam/hct.h"

#include <tuple>

#include "testing/base/public/gmock.h"
#include "testing/base/public/gunit.h"
#include "cpp/cam/cam.h"
#include "cpp/utils/utils.h"

namespace material_color_utilities {

namespace {
using ::testing::Combine;
using ::testing::DoubleNear;
using ::testing::Eq;
using ::testing::Lt;
using ::testing::TestWithParam;
using ::testing::Values;

TEST(HctTest, LimitedToSRGB) {
  // Ensures that the HCT class can only represent sRGB colors.
  // An impossibly high chroma is used.
  Hct hct(/*hue=*/120.0, /*chroma=*/200.0, /*tone=*/50.0);
  Argb argb = hct.ToInt();

  // The hue, chroma, and tone members of hct should actually
  // represent the sRGB color.
  EXPECT_THAT(CamFromInt(argb).hue, Eq(hct.get_hue()));
  EXPECT_THAT(CamFromInt(argb).chroma, Eq(hct.get_chroma()));
  EXPECT_THAT(LstarFromArgb(argb), Eq(hct.get_tone()));
}

TEST(HctTest, TruncatesColors) {
  // Ensures that HCT truncates colors.
  Hct hct(/*hue=*/120.0, /*chroma=*/60.0, /*tone=*/50.0);
  double chroma = hct.get_chroma();
  EXPECT_THAT(chroma, Lt(60.0));

  // The new chroma should be lower than the original.
  hct.set_tone(180.0);
  EXPECT_THAT(hct.get_chroma(), Lt(chroma));
}

bool IsOnBoundary(int rgb_component) {
  return rgb_component == 0 || rgb_component == 255;
}

bool ColorIsOnBoundary(int argb) {
  return IsOnBoundary(RedFromInt(argb)) || IsOnBoundary(GreenFromInt(argb)) ||
         IsOnBoundary(BlueFromInt(argb));
}

using HctTest = TestWithParam<std::tuple<int, int, int>>;

TEST_P(HctTest, Correctness) {
  std::tuple<int, int, int> hctTuple = GetParam();
  int hue = std::get<0>(hctTuple);
  int chroma = std::get<1>(hctTuple);
  int tone = std::get<2>(hctTuple);

  Hct color(hue, chroma, tone);

  if (chroma > 0) {
    EXPECT_THAT(color.get_hue(), DoubleNear(hue, 4.0));
  }

  EXPECT_THAT(color.get_chroma(), Lt(chroma + 2.5));

  if (color.get_chroma() < chroma - 2.5) {
    EXPECT_TRUE(ColorIsOnBoundary(color.ToInt()));
  }

  EXPECT_THAT(color.get_tone(), DoubleNear(tone, 0.5));
}

INSTANTIATE_TEST_SUITE_P(
    HctTests, HctTest,
    Combine(/*hues*/ Values(15, 45, 75, 105, 135, 165, 195, 225, 255, 285, 315,
                            345),
            /*chromas*/ Values(0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100),
            /*tones*/ Values(20, 30, 40, 50, 60, 70, 80)));

}  // namespace
}  // namespace material_color_utilities
