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

#include "cpp/scheme/scheme_content.h"

#include "testing/base/public/gunit.h"
#include "cpp/cam/hct.h"
#include "cpp/dynamiccolor/material_dynamic_colors.h"

namespace material_color_utilities {

namespace {
TEST(SchemeContentTest, KeyColors) {
  SchemeContent scheme = SchemeContent(Hct(0xff0000ff), false, 0.0);
  EXPECT_EQ(MaterialDynamicColors::PrimaryPaletteKeyColor().GetArgb(scheme),
            0xff080cff);
  EXPECT_EQ(MaterialDynamicColors::SecondaryPaletteKeyColor().GetArgb(scheme),
            0xff656dd3);
  EXPECT_EQ(MaterialDynamicColors::TertiaryPaletteKeyColor().GetArgb(scheme),
            0xff81009f);
  EXPECT_EQ(MaterialDynamicColors::NeutralPaletteKeyColor().GetArgb(scheme),
            0xff767684);
  EXPECT_EQ(
      MaterialDynamicColors::NeutralVariantPaletteKeyColor().GetArgb(scheme),
      0xff757589);
}

TEST(SchemeContentTest, lightTheme_minContrast_primary) {
  SchemeContent scheme = SchemeContent(Hct(0xff0000ff), false, -1.0);
  EXPECT_EQ(MaterialDynamicColors::Primary().GetArgb(scheme), 0xff5660ff);
}

TEST(SchemeContentTest, lightTheme_standardContrast_primary) {
  SchemeContent scheme = SchemeContent(Hct(0xff0000ff), false, 0.0);
  EXPECT_EQ(MaterialDynamicColors::Primary().GetArgb(scheme), 0xff0001c3);
}

TEST(SchemeContentTest, lightTheme_maxContrast_primary) {
  SchemeContent scheme = SchemeContent(Hct(0xff0000ff), false, 1.0);
  EXPECT_EQ(MaterialDynamicColors::Primary().GetArgb(scheme), 0xff000181);
}

TEST(SchemeContentTest, lightTheme_minContrast_primaryContainer) {
  SchemeContent scheme = SchemeContent(Hct(0xff0000ff), false, -1.0);
  EXPECT_EQ(MaterialDynamicColors::PrimaryContainer().GetArgb(scheme),
            0xffd5d6ff);
}

TEST(SchemeContentTest, lightTheme_standardContrast_primaryContainer) {
  SchemeContent scheme = SchemeContent(Hct(0xff0000ff), false, 0.0);
  EXPECT_EQ(MaterialDynamicColors::PrimaryContainer().GetArgb(scheme),
            0xff2d36ff);
}

TEST(SchemeContentTest, lightTheme_maxContrast_primaryContainer) {
  SchemeContent scheme = SchemeContent(Hct(0xff0000ff), false, 1.0);
  EXPECT_EQ(MaterialDynamicColors::PrimaryContainer().GetArgb(scheme),
            0xff0000e3);
}

TEST(SchemeContentTest, lightTheme_minContrast_tertiaryContainer) {
  SchemeContent scheme = SchemeContent(Hct(0xff0000ff), false, -1.0);
  EXPECT_EQ(MaterialDynamicColors::TertiaryContainer().GetArgb(scheme),
            0xfffac9ff);
}

TEST(SchemeContentTest, lightTheme_standardContrast_tertiaryContainer) {
  SchemeContent scheme = SchemeContent(Hct(0xff0000ff), false, 0.0);
  EXPECT_EQ(MaterialDynamicColors::TertiaryContainer().GetArgb(scheme),
            0xff9221af);
}

TEST(SchemeContentTest, lightTheme_maxContrast_tertiaryContainer) {
  SchemeContent scheme = SchemeContent(Hct(0xff0000ff), false, 1.0);
  EXPECT_EQ(MaterialDynamicColors::TertiaryContainer().GetArgb(scheme),
            0xff73008e);
}

TEST(SchemeContentTest,
     lightTheme_minContrast_objectionableTertiaryContainerLightens) {
  SchemeContent scheme = SchemeContent(Hct(0xff850096), false, -1.0);
  EXPECT_EQ(MaterialDynamicColors::TertiaryContainer().GetArgb(scheme),
            0xffffccd7);
}

TEST(SchemeContentTest,
     lightTheme_standardContrast_objectionableTertiaryContainerLightens) {
  SchemeContent scheme = SchemeContent(Hct(0xff850096), false, 0.0);
  EXPECT_EQ(MaterialDynamicColors::TertiaryContainer().GetArgb(scheme),
            0xffac1b57);
}

TEST(SchemeContentTest,
     lightTheme_maxContrast_objectionableTertiaryContainerDarkens) {
  SchemeContent scheme = SchemeContent(Hct(0xff850096), false, 1.0);
  EXPECT_EQ(MaterialDynamicColors::TertiaryContainer().GetArgb(scheme),
            0xff870040);
}

TEST(SchemeContentTest, lightTheme_minContrast_onPrimaryContainer) {
  SchemeContent scheme = SchemeContent(Hct(0xff0000ff), false, -1.0);
  EXPECT_EQ(MaterialDynamicColors::OnPrimaryContainer().GetArgb(scheme),
            0xff333dff);
}

TEST(SchemeContentTest, lightTheme_standardContrast_onPrimaryContainer) {
  SchemeContent scheme = SchemeContent(Hct(0xff0000ff), false, 0.0);
  EXPECT_EQ(MaterialDynamicColors::OnPrimaryContainer().GetArgb(scheme),
            0xffffffff);
}

TEST(SchemeContentTest, lightTheme_maxContrast_onPrimaryContainer) {
  SchemeContent scheme = SchemeContent(Hct(0xff0000ff), false, 1.0);
  EXPECT_EQ(MaterialDynamicColors::OnPrimaryContainer().GetArgb(scheme),
            0xffffffff);
}

TEST(SchemeContentTest, lightTheme_minContrast_surface) {
  SchemeContent scheme = SchemeContent(Hct(0xff0000ff), false, -1);
  EXPECT_EQ(MaterialDynamicColors::Surface().GetArgb(scheme), 0xfffbf8ff);
}

TEST(SchemeContentTest, lightTheme_standardContrast_surface) {
  SchemeContent scheme = SchemeContent(Hct(0xff0000ff), false, 0.0);
  EXPECT_EQ(MaterialDynamicColors::Surface().GetArgb(scheme), 0xfffbf8ff);
}

TEST(SchemeContentTest, lightTheme_maxContrast_surface) {
  SchemeContent scheme = SchemeContent(Hct(0xff0000ff), false, 1.0);
  EXPECT_EQ(MaterialDynamicColors::Surface().GetArgb(scheme), 0xfffbf8ff);
}

TEST(SchemeContentTest, darkTheme_minContrast_primary) {
  SchemeContent scheme = SchemeContent(Hct(0xff0000ff), true, -1.0);
  EXPECT_EQ(MaterialDynamicColors::Primary().GetArgb(scheme), 0xff7c84ff);
}

TEST(SchemeContentTest, darkTheme_standardContrast_primary) {
  SchemeContent scheme = SchemeContent(Hct(0xff0000ff), true, 0.0);
  EXPECT_EQ(MaterialDynamicColors::Primary().GetArgb(scheme), 0xffbec2ff);
}

TEST(SchemeContentTest, darkTheme_maxContrast_primary) {
  SchemeContent scheme = SchemeContent(Hct(0xff0000ff), true, 1.0);
  EXPECT_EQ(MaterialDynamicColors::Primary().GetArgb(scheme), 0xfffdf9ff);
}

TEST(SchemeContentTest, darkTheme_minContrast_primaryContainer) {
  SchemeContent scheme = SchemeContent(Hct(0xff0000ff), true, -1.0);
  EXPECT_EQ(MaterialDynamicColors::PrimaryContainer().GetArgb(scheme),
            0xff0001c9);
}

TEST(SchemeContentTest, darkTheme_standardContrast_primaryContainer) {
  SchemeContent scheme = SchemeContent(Hct(0xff0000ff), true, 0.0);
  EXPECT_EQ(MaterialDynamicColors::PrimaryContainer().GetArgb(scheme),
            0xff0000e6);
}

TEST(SchemeContentTest, darkTheme_maxContrast_primaryContainer) {
  SchemeContent scheme = SchemeContent(Hct(0xff0000ff), true, 1.0);
  EXPECT_EQ(MaterialDynamicColors::PrimaryContainer().GetArgb(scheme),
            0xffc4c6ff);
}

TEST(SchemeContentTest, darkTheme_minContrast_onPrimaryContainer) {
  SchemeContent scheme = SchemeContent(Hct(0xff0000ff), true, -1.0);
  EXPECT_EQ(MaterialDynamicColors::OnPrimaryContainer().GetArgb(scheme),
            0xff949bff);
}

TEST(SchemeContentTest, darkTheme_standardContrast_onPrimaryContainer) {
  SchemeContent scheme = SchemeContent(Hct(0xff0000ff), true, 0.0);
  EXPECT_EQ(MaterialDynamicColors::OnPrimaryContainer().GetArgb(scheme),
            0xffd7d8ff);
}

TEST(SchemeContentTest, darkTheme_maxContrast_onPrimaryContainer) {
  SchemeContent scheme = SchemeContent(Hct(0xff0000ff), true, 1.0);
  EXPECT_EQ(MaterialDynamicColors::OnPrimaryContainer().GetArgb(scheme),
            0xff000000);
}

TEST(SchemeContentTest, darkTheme_minContrast_onTertiaryContainer) {
  SchemeContent scheme = SchemeContent(Hct(0xff0000ff), true, -1.0);
  EXPECT_EQ(MaterialDynamicColors::OnTertiaryContainer().GetArgb(scheme),
            0xffe577ff);
}

TEST(SchemeContentTest, darkTheme_standardContrast_onTertiaryContainer) {
  SchemeContent scheme = SchemeContent(Hct(0xff0000ff), true, 0.0);
  EXPECT_EQ(MaterialDynamicColors::OnTertiaryContainer().GetArgb(scheme),
            0xfffbccff);
}

TEST(SchemeContentTest, darkTheme_maxContrast_onTertiaryContainer) {
  SchemeContent scheme = SchemeContent(Hct(0xff0000ff), true, 1.0);
  EXPECT_EQ(MaterialDynamicColors::OnTertiaryContainer().GetArgb(scheme),
            0xff000000);
}

TEST(SchemeContentTest, darkTheme_minContrast_surface) {
  SchemeContent scheme = SchemeContent(Hct(0xff0000ff), true, -1.0);
  EXPECT_EQ(MaterialDynamicColors::Surface().GetArgb(scheme), 0xff12121d);
}

TEST(SchemeContentTest, darkTheme_standardContrast_surface) {
  SchemeContent scheme = SchemeContent(Hct(0xff0000ff), true, 0.0);
  EXPECT_EQ(MaterialDynamicColors::Surface().GetArgb(scheme), 0xff12121d);
}

TEST(SchemeContentTest, darkTheme_maxContrast_surface) {
  SchemeContent scheme = SchemeContent(Hct(0xff0000ff), true, 1.0);
  EXPECT_EQ(MaterialDynamicColors::Surface().GetArgb(scheme), 0xff12121d);
}

}  // namespace
}  // namespace material_color_utilities
