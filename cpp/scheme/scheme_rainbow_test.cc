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

#include "cpp/scheme/scheme_rainbow.h"

#include "testing/base/public/gunit.h"
#include "cpp/cam/hct.h"
#include "cpp/dynamiccolor/material_dynamic_colors.h"

namespace material_color_utilities {

namespace {
TEST(SchemeRainbowTest, KeyColors) {
  SchemeRainbow scheme = SchemeRainbow(Hct(0xff0000ff), false, 0.0);
  EXPECT_EQ(MaterialDynamicColors::PrimaryPaletteKeyColor().GetArgb(scheme),
            0xff696FC4);
  EXPECT_EQ(MaterialDynamicColors::SecondaryPaletteKeyColor().GetArgb(scheme),
            0xff75758B);
  EXPECT_EQ(MaterialDynamicColors::TertiaryPaletteKeyColor().GetArgb(scheme),
            0xff936B84);
  EXPECT_EQ(MaterialDynamicColors::NeutralPaletteKeyColor().GetArgb(scheme),
            0xff070707);
  EXPECT_EQ(
      MaterialDynamicColors::NeutralVariantPaletteKeyColor().GetArgb(scheme),
      0xff070707);
}

TEST(SchemeRainbowTest, lightTheme_minContrast_primary) {
  SchemeRainbow scheme = SchemeRainbow(Hct(0xff0000ff), false, -1.0);
  EXPECT_EQ(MaterialDynamicColors::Primary().GetArgb(scheme), 0xff676DC1);
}

TEST(SchemeRainbowTest, lightTheme_standardContrast_primary) {
  SchemeRainbow scheme = SchemeRainbow(Hct(0xff0000ff), false, 0.0);
  EXPECT_EQ(MaterialDynamicColors::Primary().GetArgb(scheme), 0xff5056A9);
}

TEST(SchemeRainbowTest, lightTheme_maxContrast_primary) {
  SchemeRainbow scheme = SchemeRainbow(Hct(0xff0000ff), false, 1.0);
  EXPECT_EQ(MaterialDynamicColors::Primary().GetArgb(scheme), 0xff0F136A);
}

TEST(SchemeRainbowTest, lightTheme_minContrast_primaryContainer) {
  SchemeRainbow scheme = SchemeRainbow(Hct(0xff0000ff), false, -1.0);
  EXPECT_EQ(MaterialDynamicColors::PrimaryContainer().GetArgb(scheme),
            0xffd5d6ff);
}

TEST(SchemeRainbowTest, lightTheme_standardContrast_primaryContainer) {
  SchemeRainbow scheme = SchemeRainbow(Hct(0xff0000ff), false, 0.0);
  EXPECT_EQ(MaterialDynamicColors::PrimaryContainer().GetArgb(scheme),
            0xffE0E0FF);
}

TEST(SchemeRainbowTest, lightTheme_maxContrast_primaryContainer) {
  SchemeRainbow scheme = SchemeRainbow(Hct(0xff0000ff), false, 1.0);
  EXPECT_EQ(MaterialDynamicColors::PrimaryContainer().GetArgb(scheme),
            0xff34398B);
}

TEST(SchemeRainbowTest, lightTheme_minContrast_tertiaryContainer) {
  SchemeRainbow scheme = SchemeRainbow(Hct(0xff0000ff), false, -1.0);
  EXPECT_EQ(MaterialDynamicColors::TertiaryContainer().GetArgb(scheme),
            0xfffbcbe7);
}

TEST(SchemeRainbowTest, lightTheme_standardContrast_tertiaryContainer) {
  SchemeRainbow scheme = SchemeRainbow(Hct(0xff0000ff), false, 0.0);
  EXPECT_EQ(MaterialDynamicColors::TertiaryContainer().GetArgb(scheme),
            0xffffd8ee);
}

TEST(SchemeRainbowTest, lightTheme_maxContrast_tertiaryContainer) {
  SchemeRainbow scheme = SchemeRainbow(Hct(0xff0000ff), false, 1.0);
  EXPECT_EQ(MaterialDynamicColors::TertiaryContainer().GetArgb(scheme),
            0xff5A384E);
}

TEST(SchemeRainbowTest, lightTheme_minContrast_onPrimaryContainer) {
  SchemeRainbow scheme = SchemeRainbow(Hct(0xff0000ff), false, -1.0);
  EXPECT_EQ(MaterialDynamicColors::OnPrimaryContainer().GetArgb(scheme),
            0xff5056a9);
}

TEST(SchemeRainbowTest, lightTheme_standardContrast_onPrimaryContainer) {
  SchemeRainbow scheme = SchemeRainbow(Hct(0xff0000ff), false, 0.0);
  EXPECT_EQ(MaterialDynamicColors::OnPrimaryContainer().GetArgb(scheme),
            0xff050865);
}

TEST(SchemeRainbowTest, lightTheme_maxContrast_onPrimaryContainer) {
  SchemeRainbow scheme = SchemeRainbow(Hct(0xff0000ff), false, 1.0);
  EXPECT_EQ(MaterialDynamicColors::OnPrimaryContainer().GetArgb(scheme),
            0xffffffff);
}

TEST(SchemeRainbowTest, lightTheme_minContrast_surface) {
  SchemeRainbow scheme = SchemeRainbow(Hct(0xff0000ff), false, -1.0);
  EXPECT_EQ(MaterialDynamicColors::Surface().GetArgb(scheme), 0xfff9f9f9);
}

TEST(SchemeRainbowTest, lightTheme_standardContrast_surface) {
  SchemeRainbow scheme = SchemeRainbow(Hct(0xff0000ff), false, 0.0);
  EXPECT_EQ(MaterialDynamicColors::Surface().GetArgb(scheme), 0xfff9f9f9);
}

TEST(SchemeRainbowTest, lightTheme_maxContrast_surface) {
  SchemeRainbow scheme = SchemeRainbow(Hct(0xff0000ff), false, 1.0);
  EXPECT_EQ(MaterialDynamicColors::Surface().GetArgb(scheme), 0xfff9f9f9);
}

TEST(SchemeRainbowTest, lightTheme_standardContrast_secondary) {
  SchemeRainbow scheme = SchemeRainbow(Hct(0xff0000ff), false, 0.0);
  EXPECT_EQ(MaterialDynamicColors::Secondary().GetArgb(scheme), 0xff5c5d72);
}

TEST(SchemeRainbowTest, lightTheme_standardContrast_secondaryContainer) {
  SchemeRainbow scheme = SchemeRainbow(Hct(0xff0000ff), false, 0.0);
  EXPECT_EQ(MaterialDynamicColors::SecondaryContainer().GetArgb(scheme),
            0xffe1e0f9);
}

TEST(SchemeRainbowTest, darkTheme_minContrast_primary) {
  SchemeRainbow scheme = SchemeRainbow(Hct(0xff0000ff), true, -1.0);
  EXPECT_EQ(MaterialDynamicColors::Primary().GetArgb(scheme), 0xff8389e0);
}

TEST(SchemeRainbowTest, darkTheme_standardContrast_primary) {
  SchemeRainbow scheme = SchemeRainbow(Hct(0xff0000ff), true, 0.0);
  EXPECT_EQ(MaterialDynamicColors::Primary().GetArgb(scheme), 0xffbec2ff);
}

TEST(SchemeRainbowTest, darkTheme_maxContrast_primary) {
  SchemeRainbow scheme = SchemeRainbow(Hct(0xff0000ff), true, 1.0);
  EXPECT_EQ(MaterialDynamicColors::Primary().GetArgb(scheme), 0xfffdf9ff);
}

TEST(SchemeRainbowTest, darkTheme_minContrast_primaryContainer) {
  SchemeRainbow scheme = SchemeRainbow(Hct(0xff0000ff), true, -1.0);
  EXPECT_EQ(MaterialDynamicColors::PrimaryContainer().GetArgb(scheme),
            0xff2a3082);
}

TEST(SchemeRainbowTest, darkTheme_standardContrast_primaryContainer) {
  SchemeRainbow scheme = SchemeRainbow(Hct(0xff0000ff), true, 0.0);
  EXPECT_EQ(MaterialDynamicColors::PrimaryContainer().GetArgb(scheme),
            0xff383E8F);
}

TEST(SchemeRainbowTest, darkTheme_maxContrast_primaryContainer) {
  SchemeRainbow scheme = SchemeRainbow(Hct(0xff0000ff), true, 1.0);
  EXPECT_EQ(MaterialDynamicColors::PrimaryContainer().GetArgb(scheme),
            0xffc4c6ff);
}

TEST(SchemeRainbowTest, darkTheme_minContrast_onPrimaryContainer) {
  SchemeRainbow scheme = SchemeRainbow(Hct(0xff0000ff), true, -1.0);
  EXPECT_EQ(MaterialDynamicColors::OnPrimaryContainer().GetArgb(scheme),
            0xff969cf5);
}

TEST(SchemeRainbowTest, darkTheme_standardContrast_onPrimaryContainer) {
  SchemeRainbow scheme = SchemeRainbow(Hct(0xff0000ff), true, 0.0);
  EXPECT_EQ(MaterialDynamicColors::OnPrimaryContainer().GetArgb(scheme),
            0xffe0e0ff);
}

TEST(SchemeRainbowTest, darkTheme_maxContrast_onPrimaryContainer) {
  SchemeRainbow scheme = SchemeRainbow(Hct(0xff0000ff), true, 1.0);
  EXPECT_EQ(MaterialDynamicColors::OnPrimaryContainer().GetArgb(scheme),
            0xff000000);
}

TEST(SchemeRainbowTest, darkTheme_minContrast_onTertiaryContainer) {
  SchemeRainbow scheme = SchemeRainbow(Hct(0xff0000ff), true, -1.0);
  EXPECT_EQ(MaterialDynamicColors::OnTertiaryContainer().GetArgb(scheme),
            0xffc397b2);
}

TEST(SchemeRainbowTest, darkTheme_standardContrast_onTertiaryContainer) {
  SchemeRainbow scheme = SchemeRainbow(Hct(0xff0000ff), true, 0.0);
  EXPECT_EQ(MaterialDynamicColors::OnTertiaryContainer().GetArgb(scheme),
            0xffffd8ee);
}

TEST(SchemeRainbowTest, darkTheme_maxContrast_onTertiaryContainer) {
  SchemeRainbow scheme = SchemeRainbow(Hct(0xff0000ff), true, 1.0);
  EXPECT_EQ(MaterialDynamicColors::OnTertiaryContainer().GetArgb(scheme),
            0xff000000);
}

TEST(SchemeRainbowTest, darkTheme_minContrast_surface) {
  SchemeRainbow scheme = SchemeRainbow(Hct(0xff0000ff), true, -1.0);
  EXPECT_EQ(MaterialDynamicColors::Surface().GetArgb(scheme), 0xff131313);
}

TEST(SchemeRainbowTest, darkTheme_standardContrast_surface) {
  SchemeRainbow scheme = SchemeRainbow(Hct(0xff0000ff), true, 0.0);
  EXPECT_EQ(MaterialDynamicColors::Surface().GetArgb(scheme), 0xff131313);
}

TEST(SchemeRainbowTest, darkTheme_maxContrast_surface) {
  SchemeRainbow scheme = SchemeRainbow(Hct(0xff0000ff), true, 1.0);
  EXPECT_EQ(MaterialDynamicColors::Surface().GetArgb(scheme), 0xff131313);
}

TEST(SchemeRainbowTest, darkTheme_standardContrast_secondary) {
  SchemeRainbow scheme = SchemeRainbow(Hct(0xff0000ff), true, 0.0);
  EXPECT_EQ(MaterialDynamicColors::Secondary().GetArgb(scheme), 0xffc5c4dd);
}

TEST(SchemeRainbowTest, darkTheme_standardContrast_secondaryContainer) {
  SchemeRainbow scheme = SchemeRainbow(Hct(0xff0000ff), true, 0.0);
  EXPECT_EQ(MaterialDynamicColors::SecondaryContainer().GetArgb(scheme),
            0xff444559);
}

}  // namespace
}  // namespace material_color_utilities
