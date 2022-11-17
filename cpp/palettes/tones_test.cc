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

}  // namespace
}  // namespace material_color_utilities
