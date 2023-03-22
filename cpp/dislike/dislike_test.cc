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

#include "cpp/dislike/dislike.h"

#include "testing/base/public/gunit.h"
#include "cpp/cam/hct.h"

namespace material_color_utilities {

namespace {

using testing::TestWithParam;
using testing::Values;
using SkinToneTest = TestWithParam<int>;

TEST_P(SkinToneTest, MonkSkinToneScaleColorsLiked) {
  int argb = GetParam();

  EXPECT_FALSE(IsDisliked(Hct(argb)));
}

INSTANTIATE_TEST_SUITE_P(DislikeTest, SkinToneTest,
                         Values(0xfff6ede4, 0xfff3e7db, 0xfff7ead0, 0xffeadaba,
                                0xffd7bd96, 0xffa07e56, 0xff825c43, 0xff604134,
                                0xff3a312a, 0xff292420));

using BileTest = TestWithParam<int>;

TEST_P(BileTest, BileColorsDisliked) {
  int argb = GetParam();

  EXPECT_TRUE(IsDisliked(Hct(argb)));
}

INSTANTIATE_TEST_SUITE_P(DislikeTest, BileTest,
                         Values(0xff95884B, 0xff716B40, 0xffB08E00, 0xff4C4308,
                                0xff464521));

using BileFixingTest = TestWithParam<int>;

TEST_P(BileFixingTest, BileColorsFixed) {
  int argb = GetParam();

  Hct bile_color = Hct(argb);
  EXPECT_TRUE(IsDisliked(bile_color));
  Hct fixed_bile_color = FixIfDisliked(bile_color);
  EXPECT_FALSE(IsDisliked(fixed_bile_color));
}

INSTANTIATE_TEST_SUITE_P(DislikeTest, BileFixingTest,
                         Values(0xff95884B, 0xff716B40, 0xffB08E00, 0xff4C4308,
                                0xff464521));


TEST(DislikeTest, Tone67Liked) {
  Hct color = Hct(100.0, 50.0, 67.0);
  EXPECT_FALSE(IsDisliked(color));
  EXPECT_EQ(FixIfDisliked(color).ToInt(), color.ToInt());
}

}  // namespace

}  // namespace material_color_utilities
