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

#include "cpp/scheme/scheme_vibrant.h"

#include "testing/base/public/gunit.h"
#include "cpp/cam/hct.h"
#include "cpp/dynamiccolor/material_dynamic_colors.h"

namespace material_color_utilities {

namespace {
TEST(SchemeVibrantTest, KeyColors) {
  SchemeVibrant scheme = SchemeVibrant(Hct(0xff0000ff), false, 0.0);
  EXPECT_EQ(MaterialDynamicColors::PrimaryPaletteKeyColor().GetArgb(scheme),
            0xff080cff);
  EXPECT_EQ(MaterialDynamicColors::SecondaryPaletteKeyColor().GetArgb(scheme),
            0xff7B7296);
  EXPECT_EQ(MaterialDynamicColors::TertiaryPaletteKeyColor().GetArgb(scheme),
            0xff886C9D);
  EXPECT_EQ(MaterialDynamicColors::NeutralPaletteKeyColor().GetArgb(scheme),
            0xff777682);
  EXPECT_EQ(
      MaterialDynamicColors::NeutralVariantPaletteKeyColor().GetArgb(scheme),
      0xff767685);
}
TEST(SchemeVibrantTest, lightTheme_minContrast_primary) {
  SchemeVibrant scheme = SchemeVibrant(Hct(0xff0000ff), false, -1.0);
  EXPECT_EQ(MaterialDynamicColors::Primary().GetArgb(scheme), 0xff5660ff);
}
TEST(SchemeVibrantTest, lightTheme_standardContrast_primary) {
  SchemeVibrant scheme = SchemeVibrant(Hct(0xff0000ff), false, 0.0);
  EXPECT_EQ(MaterialDynamicColors::Primary().GetArgb(scheme), 0xff343dff);
}
TEST(SchemeVibrantTest, lightTheme_maxContrast_primary) {
  SchemeVibrant scheme = SchemeVibrant(Hct(0xff0000ff), false, 1.0);
  EXPECT_EQ(MaterialDynamicColors::Primary().GetArgb(scheme), 0xff000181);
}
TEST(SchemeVibrantTest, lightTheme_minContrast_primaryContainer) {
  SchemeVibrant scheme = SchemeVibrant(Hct(0xff0000ff), false, -1.0);
  EXPECT_EQ(MaterialDynamicColors::PrimaryContainer().GetArgb(scheme),
            0xffe0e0ff);
}
TEST(SchemeVibrantTest, lightTheme_standardContrast_primaryContainer) {
  SchemeVibrant scheme = SchemeVibrant(Hct(0xff0000ff), false, 0.0);
  EXPECT_EQ(MaterialDynamicColors::PrimaryContainer().GetArgb(scheme),
            0xffe0e0ff);
}
TEST(SchemeVibrantTest, lightTheme_maxContrast_primaryContainer) {
  SchemeVibrant scheme = SchemeVibrant(Hct(0xff0000ff), false, 1.0);
  EXPECT_EQ(MaterialDynamicColors::PrimaryContainer().GetArgb(scheme),
            0xff0000e3);
}
TEST(SchemeVibrantTest, lightTheme_minContrast_onPrimaryContainer) {
  SchemeVibrant scheme = SchemeVibrant(Hct(0xff0000ff), false, -1.0);
  EXPECT_EQ(MaterialDynamicColors::OnPrimaryContainer().GetArgb(scheme),
            0xff3e47ff);
}
TEST(SchemeVibrantTest, lightTheme_standardContrast_onPrimaryContainer) {
  SchemeVibrant scheme = SchemeVibrant(Hct(0xff0000ff), false, 0.0);
  EXPECT_EQ(MaterialDynamicColors::OnPrimaryContainer().GetArgb(scheme),
            0xff00006e);
}
TEST(SchemeVibrantTest, lightTheme_maxContrast_onPrimaryContainer) {
  SchemeVibrant scheme = SchemeVibrant(Hct(0xff0000ff), false, 1.0);
  EXPECT_EQ(MaterialDynamicColors::OnPrimaryContainer().GetArgb(scheme),
            0xffd6d6ff);
}
TEST(SchemeVibrantTest, lightTheme_minContrast_surface) {
  SchemeVibrant scheme = SchemeVibrant(Hct(0xff0000ff), false, -1.0);
  EXPECT_EQ(MaterialDynamicColors::Surface().GetArgb(scheme), 0xfffbf8ff);
}
TEST(SchemeVibrantTest, lightTheme_standardContrast_surface) {
  SchemeVibrant scheme = SchemeVibrant(Hct(0xff0000ff), false, 0.0);
  EXPECT_EQ(MaterialDynamicColors::Surface().GetArgb(scheme), 0xfffbf8ff);
}
TEST(SchemeVibrantTest, lightTheme_maxContrast_surface) {
  SchemeVibrant scheme = SchemeVibrant(Hct(0xff0000ff), false, 1.0);
  EXPECT_EQ(MaterialDynamicColors::Surface().GetArgb(scheme), 0xfffbf8ff);
}
TEST(SchemeVibrantTest, darkTheme_minContrast_primary) {
  SchemeVibrant scheme = SchemeVibrant(Hct(0xff0000ff), true, -1.0);
  EXPECT_EQ(MaterialDynamicColors::Primary().GetArgb(scheme), 0xff5660ff);
}
TEST(SchemeVibrantTest, darkTheme_standardContrast_primary) {
  SchemeVibrant scheme = SchemeVibrant(Hct(0xff0000ff), true, 0.0);
  EXPECT_EQ(MaterialDynamicColors::Primary().GetArgb(scheme), 0xffbec2ff);
}
TEST(SchemeVibrantTest, darkTheme_maxContrast_primary) {
  SchemeVibrant scheme = SchemeVibrant(Hct(0xff0000ff), true, 1.0);
  EXPECT_EQ(MaterialDynamicColors::Primary().GetArgb(scheme), 0xfff6f4ff);
}
TEST(SchemeVibrantTest, darkTheme_minContrast_primaryContainer) {
  SchemeVibrant scheme = SchemeVibrant(Hct(0xff0000ff), true, -1.0);
  EXPECT_EQ(MaterialDynamicColors::PrimaryContainer().GetArgb(scheme),
            0xff0000ef);
}
TEST(SchemeVibrantTest, darkTheme_standardContrast_primaryContainer) {
  SchemeVibrant scheme = SchemeVibrant(Hct(0xff0000ff), true, 0.0);
  EXPECT_EQ(MaterialDynamicColors::PrimaryContainer().GetArgb(scheme),
            0xff0000ef);
}
TEST(SchemeVibrantTest, darkTheme_maxContrast_primaryContainer) {
  SchemeVibrant scheme = SchemeVibrant(Hct(0xff0000ff), true, 1.0);
  EXPECT_EQ(MaterialDynamicColors::PrimaryContainer().GetArgb(scheme),
            0xffc4c6ff);
}
TEST(SchemeVibrantTest, darkTheme_minContrast_onPrimaryContainer) {
  SchemeVibrant scheme = SchemeVibrant(Hct(0xff0000ff), true, -1.0);
  EXPECT_EQ(MaterialDynamicColors::OnPrimaryContainer().GetArgb(scheme),
            0xffa9afff);
}
TEST(SchemeVibrantTest, darkTheme_standardContrast_onPrimaryContainer) {
  SchemeVibrant scheme = SchemeVibrant(Hct(0xff0000ff), true, 0.0);
  EXPECT_EQ(MaterialDynamicColors::OnPrimaryContainer().GetArgb(scheme),
            0xffe0e0ff);
}
TEST(SchemeVibrantTest, darkTheme_maxContrast_onPrimaryContainer) {
  SchemeVibrant scheme = SchemeVibrant(Hct(0xff0000ff), true, 1.0);
  EXPECT_EQ(MaterialDynamicColors::OnPrimaryContainer().GetArgb(scheme),
            0xff0001c6);
}
TEST(SchemeVibrantTest, darkTheme_minContrast_onTertiaryContainer) {
  SchemeVibrant scheme = SchemeVibrant(Hct(0xff0000ff), true, -1.0);
  EXPECT_EQ(MaterialDynamicColors::OnTertiaryContainer().GetArgb(scheme),
            0xffc9a9df);
}
TEST(SchemeVibrantTest, darkTheme_standardContrast_onTertiaryContainer) {
  SchemeVibrant scheme = SchemeVibrant(Hct(0xff0000ff), true, 0.0);
  EXPECT_EQ(MaterialDynamicColors::OnTertiaryContainer().GetArgb(scheme),
            0xfff2daff);
}
TEST(SchemeVibrantTest, darkTheme_maxContrast_onTertiaryContainer) {
  SchemeVibrant scheme = SchemeVibrant(Hct(0xff0000ff), true, 1.0);
  EXPECT_EQ(MaterialDynamicColors::OnTertiaryContainer().GetArgb(scheme),
            0xff472e5b);
}
TEST(SchemeVibrantTest, darkTheme_minContrast_surface) {
  SchemeVibrant scheme = SchemeVibrant(Hct(0xff0000ff), true, -1.0);
  EXPECT_EQ(MaterialDynamicColors::Surface().GetArgb(scheme), 0xff12131c);
}
TEST(SchemeVibrantTest, darkTheme_standardContrast_surface) {
  SchemeVibrant scheme = SchemeVibrant(Hct(0xff0000ff), true, 0.0);
  EXPECT_EQ(MaterialDynamicColors::Surface().GetArgb(scheme), 0xff12131c);
}
TEST(SchemeVibrantTest, darkTheme_maxContrast_surface) {
  SchemeVibrant scheme = SchemeVibrant(Hct(0xff0000ff), true, 1.0);
  EXPECT_EQ(MaterialDynamicColors::Surface().GetArgb(scheme), 0xff12131c);
}
}  // namespace
}  // namespace material_color_utilities
