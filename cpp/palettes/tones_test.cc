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

#include "testing/base/public/gunit.h"
#include "cpp/cam/hct.h"
#include "cpp/utils/utils.h"

namespace material_color_utilities {

namespace {

TEST(TonesTest, Blue) {
  Argb color = 0xff0000ff;
  TonalPalette tonal_palette = TonalPalette(color);
  EXPECT_EQ(HexFromArgb(tonal_palette.get(100)), "ffffffff");
  EXPECT_EQ(HexFromArgb(tonal_palette.get(95)), "fff1efff");
  EXPECT_EQ(HexFromArgb(tonal_palette.get(90)), "ffe0e0ff");
  EXPECT_EQ(HexFromArgb(tonal_palette.get(80)), "ffbec2ff");
  EXPECT_EQ(HexFromArgb(tonal_palette.get(70)), "ff9da3ff");
  EXPECT_EQ(HexFromArgb(tonal_palette.get(60)), "ff7c84ff");
  EXPECT_EQ(HexFromArgb(tonal_palette.get(50)), "ff5a64ff");
  EXPECT_EQ(HexFromArgb(tonal_palette.get(40)), "ff343dff");
  EXPECT_EQ(HexFromArgb(tonal_palette.get(30)), "ff0000ef");
  EXPECT_EQ(HexFromArgb(tonal_palette.get(20)), "ff0001ac");
  EXPECT_EQ(HexFromArgb(tonal_palette.get(10)), "ff00006e");
  EXPECT_EQ(HexFromArgb(tonal_palette.get(0)), "ff000000");
}

TEST(KeyColorTests, ExactChromaAvailable) {
  // Requested chroma is exactly achievable at a certain tone.
  TonalPalette palette = TonalPalette(50.0, 60.0);
  Hct result = palette.get_key_color();

  EXPECT_NEAR(result.get_hue(), 50.0, 10.0);
  EXPECT_NEAR(result.get_chroma(), 60.0, 0.5);
  // Tone might vary, but should be within the range from 0 to 100.
  EXPECT_GT(result.get_tone(), 0);
  EXPECT_LT(result.get_tone(), 100);
}

TEST(KeyColorTests, UnusuallyHighChroma) {
  // Requested chroma is above what is achievable. For Hue 149, chroma peak
  // is 89.6 at Tone 87.9. The result key color's chroma should be close to the
  // chroma peak.
  TonalPalette palette = TonalPalette(149.0, 200.0);
  Hct result = palette.get_key_color();

  EXPECT_NEAR(result.get_hue(), 149.0, 10.0);
  EXPECT_GT(result.get_chroma(), 89.0);
  // Tone might vary, but should be within the range from 0 to 100.
  EXPECT_GT(result.get_tone(), 0);
  EXPECT_LT(result.get_tone(), 100);
}

TEST(KeyColorTests, UnusuallyLowChroma) {
  // By definition, the key color should be the first tone, starting from Tone
  // 50, matching the given hue and chroma. When requesting a very low chroma,
  // the result should be close to Tone 50, since most tones can produce a low
  // chroma.
  TonalPalette palette = TonalPalette(50.0, 3.0);
  Hct result = palette.get_key_color();

  // Higher error tolerance for hue when the requested chroma is unusually low.
  EXPECT_NEAR(result.get_hue(), 50.0, 10.0);
  EXPECT_NEAR(result.get_chroma(), 3.0, 0.5);
  EXPECT_NEAR(result.get_tone(), 50.0, 0.5);
}

}  // namespace
}  // namespace material_color_utilities
