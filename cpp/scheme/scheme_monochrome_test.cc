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

#include "cpp/scheme/scheme_monochrome.h"

#include "testing/base/public/gunit.h"
#include "cpp/cam/hct.h"
#include "cpp/dynamiccolor/material_dynamic_colors.h"

namespace material_color_utilities {

namespace {
TEST(SchemeMonochromeTest, KeyColors) {
  SchemeMonochrome scheme = SchemeMonochrome(Hct(0xff0000ff), false, 0.0);
  EXPECT_EQ(MaterialDynamicColors::PrimaryPaletteKeyColor().GetArgb(scheme),
            0xff070707);
  EXPECT_EQ(MaterialDynamicColors::SecondaryPaletteKeyColor().GetArgb(scheme),
            0xff070707);
  EXPECT_EQ(MaterialDynamicColors::TertiaryPaletteKeyColor().GetArgb(scheme),
            0xff070707);
  EXPECT_EQ(MaterialDynamicColors::NeutralPaletteKeyColor().GetArgb(scheme),
            0xff070707);
  EXPECT_EQ(
      MaterialDynamicColors::NeutralVariantPaletteKeyColor().GetArgb(scheme),
      0xff070707);
}

TEST(SchemeMonochromeTest, lightTheme_minContrast_primary) {
  SchemeMonochrome scheme = SchemeMonochrome(Hct(0xff0000ff), false, -1);
  EXPECT_EQ(MaterialDynamicColors::Primary().GetArgb(scheme), 0xff3c3c3c);
}

TEST(SchemeMonochromeTest, lightTheme_standardContrast_primary) {
  SchemeMonochrome scheme = SchemeMonochrome(Hct(0xff0000ff), false, 0.0);
  EXPECT_EQ(MaterialDynamicColors::Primary().GetArgb(scheme), 0xff000000);
}

TEST(SchemeMonochromeTest, lightTheme_maxContrast_primary) {
  SchemeMonochrome scheme = SchemeMonochrome(Hct(0xff0000ff), false, 1);
  EXPECT_EQ(MaterialDynamicColors::Primary().GetArgb(scheme), 0xff000000);
}

TEST(SchemeMonochromeTest, lightTheme_minContrast_primaryContainer) {
  SchemeMonochrome scheme = SchemeMonochrome(Hct(0xff0000ff), false, -1);
  EXPECT_EQ(MaterialDynamicColors::PrimaryContainer().GetArgb(scheme),
            0xff5f5f5f);
}

TEST(SchemeMonochromeTest, lightTheme_standardContrast_primaryContainer) {
  SchemeMonochrome scheme = SchemeMonochrome(Hct(0xff0000ff), false, 0.0);
  EXPECT_EQ(MaterialDynamicColors::PrimaryContainer().GetArgb(scheme),
            0xff3b3b3b);
}

TEST(SchemeMonochromeTest, lightTheme_maxContrast_primaryContainer) {
  SchemeMonochrome scheme = SchemeMonochrome(Hct(0xff0000ff), false, 1);
  EXPECT_EQ(MaterialDynamicColors::PrimaryContainer().GetArgb(scheme),
            0xff3a3a3a);
}

TEST(SchemeMonochromeTest, lightTheme_minContrast_onPrimaryContainer) {
  SchemeMonochrome scheme = SchemeMonochrome(Hct(0xff0000ff), false, -1);
  EXPECT_EQ(MaterialDynamicColors::OnPrimaryContainer().GetArgb(scheme),
            0xffd9d9d9);
}

TEST(SchemeMonochromeTest, lightTheme_standardContrast_onPrimaryContainer) {
  SchemeMonochrome scheme = SchemeMonochrome(Hct(0xff0000ff), false, 0.0);
  EXPECT_EQ(MaterialDynamicColors::OnPrimaryContainer().GetArgb(scheme),
            0xffffffff);
}

TEST(SchemeMonochromeTest, lightTheme_maxContrast_onPrimaryContainer) {
  SchemeMonochrome scheme = SchemeMonochrome(Hct(0xff0000ff), false, 1);
  EXPECT_EQ(MaterialDynamicColors::OnPrimaryContainer().GetArgb(scheme),
            0xffcdcdcd);
}

TEST(SchemeMonochromeTest, lightTheme_minContrast_surface) {
  SchemeMonochrome scheme = SchemeMonochrome(Hct(0xff0000ff), false, -1);
  EXPECT_EQ(MaterialDynamicColors::Surface().GetArgb(scheme), 0xfff9f9f9);
}

TEST(SchemeMonochromeTest, lightTheme_standardContrast_surface) {
  SchemeMonochrome scheme = SchemeMonochrome(Hct(0xff0000ff), false, 0.0);
  EXPECT_EQ(MaterialDynamicColors::Surface().GetArgb(scheme), 0xfff9f9f9);
}

TEST(SchemeMonochromeTest, lightTheme_maxContrast_surface) {
  SchemeMonochrome scheme = SchemeMonochrome(Hct(0xff0000ff), false, 1);
  EXPECT_EQ(MaterialDynamicColors::Surface().GetArgb(scheme), 0xfff9f9f9);
}

TEST(SchemeMonochromeTest, darkTheme_minContrast_primary) {
  SchemeMonochrome scheme = SchemeMonochrome(Hct(0xff0000ff), true, -1);
  EXPECT_EQ(MaterialDynamicColors::Primary().GetArgb(scheme), 0xffcccccc);
}

TEST(SchemeMonochromeTest, darkTheme_standardContrast_primary) {
  SchemeMonochrome scheme = SchemeMonochrome(Hct(0xff0000ff), true, 0.0);
  EXPECT_EQ(MaterialDynamicColors::Primary().GetArgb(scheme), 0xffffffff);
}

TEST(SchemeMonochromeTest, darkTheme_maxContrast_primary) {
  SchemeMonochrome scheme = SchemeMonochrome(Hct(0xff0000ff), true, 1);
  EXPECT_EQ(MaterialDynamicColors::Primary().GetArgb(scheme), 0xffffffff);
}

TEST(SchemeMonochromeTest, darkTheme_minContrast_primaryContainer) {
  SchemeMonochrome scheme = SchemeMonochrome(Hct(0xff0000ff), true, -1);
  EXPECT_EQ(MaterialDynamicColors::PrimaryContainer().GetArgb(scheme),
            0xffa3a3a3);
}

TEST(SchemeMonochromeTest, darkTheme_standardContrast_primaryContainer) {
  SchemeMonochrome scheme = SchemeMonochrome(Hct(0xff0000ff), true, 0.0);
  EXPECT_EQ(MaterialDynamicColors::PrimaryContainer().GetArgb(scheme),
            0xffd4d4d4);
}

TEST(SchemeMonochromeTest, darkTheme_maxContrast_primaryContainer) {
  SchemeMonochrome scheme = SchemeMonochrome(Hct(0xff0000ff), true, 1);
  EXPECT_EQ(MaterialDynamicColors::PrimaryContainer().GetArgb(scheme),
            0xffd5d5d5);
}

TEST(SchemeMonochromeTest, darkTheme_minContrast_onPrimaryContainer) {
  SchemeMonochrome scheme = SchemeMonochrome(Hct(0xff0000ff), true, -1);
  EXPECT_EQ(MaterialDynamicColors::OnPrimaryContainer().GetArgb(scheme),
            0xff393939);
}

TEST(SchemeMonochromeTest, darkTheme_standardContrast_onPrimaryContainer) {
  SchemeMonochrome scheme = SchemeMonochrome(Hct(0xff0000ff), true, 0.0);
  EXPECT_EQ(MaterialDynamicColors::OnPrimaryContainer().GetArgb(scheme),
            0xff000000);
}

TEST(SchemeMonochromeTest, darkTheme_maxContrast_onPrimaryContainer) {
  SchemeMonochrome scheme = SchemeMonochrome(Hct(0xff0000ff), true, 1);
  EXPECT_EQ(MaterialDynamicColors::OnPrimaryContainer().GetArgb(scheme),
            0xff404040);
}

TEST(SchemeMonochromeTest, darkTheme_minContrast_onTertiaryContainer) {
  SchemeMonochrome scheme = SchemeMonochrome(Hct(0xff0000ff), true, -1);
  EXPECT_EQ(MaterialDynamicColors::OnTertiaryContainer().GetArgb(scheme),
            0xffd1d1d1);
}

TEST(SchemeMonochromeTest, darkTheme_standardContrast_onTertiaryContainer) {
  SchemeMonochrome scheme = SchemeMonochrome(Hct(0xff0000ff), true, 0.0);
  EXPECT_EQ(MaterialDynamicColors::OnTertiaryContainer().GetArgb(scheme),
            0xff000000);
}

TEST(SchemeMonochromeTest, darkTheme_maxContrast_onTertiaryContainer) {
  SchemeMonochrome scheme = SchemeMonochrome(Hct(0xff0000ff), true, 1);
  EXPECT_EQ(MaterialDynamicColors::OnTertiaryContainer().GetArgb(scheme),
            0xff393939);
}

TEST(SchemeMonochromeTest, darkTheme_minContrast_surface) {
  SchemeMonochrome scheme = SchemeMonochrome(Hct(0xff0000ff), true, -1);
  EXPECT_EQ(MaterialDynamicColors::Surface().GetArgb(scheme), 0xff131313);
}

TEST(SchemeMonochromeTest, darkTheme_standardContrast_surface) {
  SchemeMonochrome scheme = SchemeMonochrome(Hct(0xff0000ff), true, 0.0);
  EXPECT_EQ(MaterialDynamicColors::Surface().GetArgb(scheme), 0xff131313);
}

TEST(SchemeMonochromeTest, darkTheme_maxContrast_surface) {
  SchemeMonochrome scheme = SchemeMonochrome(Hct(0xff0000ff), true, 1);
  EXPECT_EQ(MaterialDynamicColors::Surface().GetArgb(scheme), 0xff131313);
}

TEST(SchemeMonochromeTest, darkTheme_monochromeSpec) {
  SchemeMonochrome scheme = SchemeMonochrome(Hct(0xff0000ff), true, 0.0);
  EXPECT_NEAR(MaterialDynamicColors::Primary().GetHct(scheme).get_tone(), 100.0,
              1.0);
  EXPECT_NEAR(MaterialDynamicColors::OnPrimary().GetHct(scheme).get_tone(),
              10.0, 1.0);
  EXPECT_NEAR(
      MaterialDynamicColors::PrimaryContainer().GetHct(scheme).get_tone(), 85.0,
      1.0);
  EXPECT_NEAR(
      MaterialDynamicColors::OnPrimaryContainer().GetHct(scheme).get_tone(),
      0.0, 1.0);
  EXPECT_NEAR(MaterialDynamicColors::Secondary().GetHct(scheme).get_tone(),
              80.0, 1.0);
  EXPECT_NEAR(MaterialDynamicColors::OnSecondary().GetHct(scheme).get_tone(),
              10.0, 1.0);
  EXPECT_NEAR(
      MaterialDynamicColors::SecondaryContainer().GetHct(scheme).get_tone(),
      30.0, 1.0);
  EXPECT_NEAR(
      MaterialDynamicColors::OnSecondaryContainer().GetHct(scheme).get_tone(),
      90.0, 1.0);
  EXPECT_NEAR(MaterialDynamicColors::Tertiary().GetHct(scheme).get_tone(), 90.0,
              1.0);
  EXPECT_NEAR(MaterialDynamicColors::OnTertiary().GetHct(scheme).get_tone(),
              10.0, 1.0);
  EXPECT_NEAR(
      MaterialDynamicColors::TertiaryContainer().GetHct(scheme).get_tone(),
      60.0, 1.0);
  EXPECT_NEAR(
      MaterialDynamicColors::OnTertiaryContainer().GetHct(scheme).get_tone(),
      0.0, 1.0);
}

TEST(SchemeMonochromeTest, lightTheme_monochromeSpec) {
  SchemeMonochrome scheme = SchemeMonochrome(Hct(0xff0000ff), false, 0.0);
  EXPECT_NEAR(MaterialDynamicColors::Primary().GetHct(scheme).get_tone(), 0.0,
              1.0);
  EXPECT_NEAR(MaterialDynamicColors::OnPrimary().GetHct(scheme).get_tone(),
              90.0, 1.0);
  EXPECT_NEAR(
      MaterialDynamicColors::PrimaryContainer().GetHct(scheme).get_tone(), 25.0,
      1.0);
  EXPECT_NEAR(
      MaterialDynamicColors::OnPrimaryContainer().GetHct(scheme).get_tone(),
      100.0, 1.0);
  EXPECT_NEAR(MaterialDynamicColors::Secondary().GetHct(scheme).get_tone(),
              40.0, 1.0);
  EXPECT_NEAR(MaterialDynamicColors::OnSecondary().GetHct(scheme).get_tone(),
              100.0, 1.0);
  EXPECT_NEAR(
      MaterialDynamicColors::SecondaryContainer().GetHct(scheme).get_tone(),
      85.0, 1.0);
  EXPECT_NEAR(
      MaterialDynamicColors::OnSecondaryContainer().GetHct(scheme).get_tone(),
      10.0, 1.0);
  EXPECT_NEAR(MaterialDynamicColors::Tertiary().GetHct(scheme).get_tone(), 25.0,
              1.0);
  EXPECT_NEAR(MaterialDynamicColors::OnTertiary().GetHct(scheme).get_tone(),
              90.0, 1.0);
  EXPECT_NEAR(
      MaterialDynamicColors::TertiaryContainer().GetHct(scheme).get_tone(),
      49.0, 1.0);
  EXPECT_NEAR(
      MaterialDynamicColors::OnTertiaryContainer().GetHct(scheme).get_tone(),
      100.0, 1.0);
}

}  // namespace
}  // namespace material_color_utilities
