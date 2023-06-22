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

#include "cpp/scheme/scheme_tonal_spot.h"

#include "testing/base/public/gunit.h"
#include "cpp/cam/hct.h"
#include "cpp/dynamiccolor/material_dynamic_colors.h"

namespace material_color_utilities {

namespace {
TEST(SchemeTonalSpotTest, KeyColors) {
  SchemeTonalSpot scheme = SchemeTonalSpot(Hct(0xff0000ff), false, 0.0);
  EXPECT_EQ(MaterialDynamicColors::PrimaryPaletteKeyColor().GetArgb(scheme),
            0xff6E72AC);
  EXPECT_EQ(MaterialDynamicColors::SecondaryPaletteKeyColor().GetArgb(scheme),
            0xff75758B);
  EXPECT_EQ(MaterialDynamicColors::TertiaryPaletteKeyColor().GetArgb(scheme),
            0xff936B84);
  EXPECT_EQ(MaterialDynamicColors::NeutralPaletteKeyColor().GetArgb(scheme),
            0xff77767d);
  EXPECT_EQ(
      MaterialDynamicColors::NeutralVariantPaletteKeyColor().GetArgb(scheme),
      0xff777680);
}

TEST(SchemeTonalSpotTest, lightTheme_minContrast_primary) {
  SchemeTonalSpot scheme = SchemeTonalSpot(Hct(0xff0000ff), false, -1.0);
  EXPECT_EQ(MaterialDynamicColors::Primary().GetArgb(scheme), 0xff6c70aa);
}

TEST(SchemeTonalSpotTest, lightTheme_standardContrast_primary) {
  SchemeTonalSpot scheme = SchemeTonalSpot(Hct(0xff0000ff), false, 0.0);
  EXPECT_EQ(MaterialDynamicColors::Primary().GetArgb(scheme), 0xff555992);
}

TEST(SchemeTonalSpotTest, lightTheme_maxContrast_primary) {
  SchemeTonalSpot scheme = SchemeTonalSpot(Hct(0xff0000ff), false, 1.0);
  EXPECT_EQ(MaterialDynamicColors::Primary().GetArgb(scheme), 0xff181c51);
}

TEST(SchemeTonalSpotTest, lightTheme_minContrast_primaryContainer) {
  SchemeTonalSpot scheme = SchemeTonalSpot(Hct(0xff0000ff), false, -1.0);
  EXPECT_EQ(MaterialDynamicColors::PrimaryContainer().GetArgb(scheme),
            0xffd5d6ff);
}

TEST(SchemeTonalSpotTest, lightTheme_standardContrast_primaryContainer) {
  SchemeTonalSpot scheme = SchemeTonalSpot(Hct(0xff0000ff), false, 0.0);
  EXPECT_EQ(MaterialDynamicColors::PrimaryContainer().GetArgb(scheme),
            0xffe0e0ff);
}

TEST(SchemeTonalSpotTest, lightTheme_maxContrast_primaryContainer) {
  SchemeTonalSpot scheme = SchemeTonalSpot(Hct(0xff0000ff), false, 1.0);
  EXPECT_EQ(MaterialDynamicColors::PrimaryContainer().GetArgb(scheme),
            0xff3a3e74);
}

TEST(SchemeTonalSpotTest, lightTheme_minContrast_onPrimaryContainer) {
  SchemeTonalSpot scheme = SchemeTonalSpot(Hct(0xff0000ff), false, -1.0);
  EXPECT_EQ(MaterialDynamicColors::OnPrimaryContainer().GetArgb(scheme),
            0xff555992);
}

TEST(SchemeTonalSpotTest, lightTheme_standardContrast_onPrimaryContainer) {
  SchemeTonalSpot scheme = SchemeTonalSpot(Hct(0xff0000ff), false, 0.0);
  EXPECT_EQ(MaterialDynamicColors::OnPrimaryContainer().GetArgb(scheme),
            0xff11144B);
}

TEST(SchemeTonalSpotTest, lightTheme_maxContrast_onPrimaryContainer) {
  SchemeTonalSpot scheme = SchemeTonalSpot(Hct(0xff0000ff), false, 1.0);
  EXPECT_EQ(MaterialDynamicColors::OnPrimaryContainer().GetArgb(scheme),
            0xffffffff);
}

TEST(SchemeTonalSpotTest, lightTheme_minContrast_surface) {
  SchemeTonalSpot scheme = SchemeTonalSpot(Hct(0xff0000ff), false, -1.0);
  EXPECT_EQ(MaterialDynamicColors::Surface().GetArgb(scheme), 0xfffbf8ff);
}

TEST(SchemeTonalSpotTest, lightTheme_standardContrast_surface) {
  SchemeTonalSpot scheme = SchemeTonalSpot(Hct(0xff0000ff), false, 0.0);
  EXPECT_EQ(MaterialDynamicColors::Surface().GetArgb(scheme), 0xfffbf8ff);
}

TEST(SchemeTonalSpotTest, lightTheme_maxContrast_surface) {
  SchemeTonalSpot scheme = SchemeTonalSpot(Hct(0xff0000ff), false, 1.0);
  EXPECT_EQ(MaterialDynamicColors::Surface().GetArgb(scheme), 0xfffbf8ff);
}

TEST(SchemeTonalSpotTest, lightTheme_minContrast_onSurface) {
  SchemeTonalSpot scheme = SchemeTonalSpot(Hct(0xff0000ff), false, -1.0);
  EXPECT_EQ(MaterialDynamicColors::OnSurface().GetArgb(scheme), 0xff5f5e65);
}

TEST(SchemeTonalSpotTest, lightTheme_standardContrast_onSurface) {
  SchemeTonalSpot scheme = SchemeTonalSpot(Hct(0xff0000ff), false, 0.0);
  EXPECT_EQ(MaterialDynamicColors::OnSurface().GetArgb(scheme), 0xff1b1b21);
}

TEST(SchemeTonalSpotTest, lightTheme_maxContrast_onSurface) {
  SchemeTonalSpot scheme = SchemeTonalSpot(Hct(0xff0000ff), false, 1.0);
  EXPECT_EQ(MaterialDynamicColors::OnSurface().GetArgb(scheme), 0xff000000);
}

TEST(SchemeTonalSpotTest, lightTheme_minContrast_onSecondary) {
  SchemeTonalSpot scheme = SchemeTonalSpot(Hct(0xff0000ff), false, -1.0);
  EXPECT_EQ(MaterialDynamicColors::OnSecondary().GetArgb(scheme), 0xfffffbff);
}

TEST(SchemeTonalSpotTest, lightTheme_standardContrast_onSecondary) {
  SchemeTonalSpot scheme = SchemeTonalSpot(Hct(0xff0000ff), false, 0.0);
  EXPECT_EQ(MaterialDynamicColors::OnSecondary().GetArgb(scheme), 0xffffffff);
}

TEST(SchemeTonalSpotTest, lightTheme_maxContrast_onSecondary) {
  SchemeTonalSpot scheme = SchemeTonalSpot(Hct(0xff0000ff), false, 1.0);
  EXPECT_EQ(MaterialDynamicColors::OnSecondary().GetArgb(scheme), 0xffffffff);
}

TEST(SchemeTonalSpotTest, lightTheme_minContrast_onTertiary) {
  SchemeTonalSpot scheme = SchemeTonalSpot(Hct(0xff0000ff), false, -1.0);
  EXPECT_EQ(MaterialDynamicColors::OnTertiary().GetArgb(scheme), 0xfffffbff);
}

TEST(SchemeTonalSpotTest, lightTheme_standardContrast_onTertiary) {
  SchemeTonalSpot scheme = SchemeTonalSpot(Hct(0xff0000ff), false, 0.0);
  EXPECT_EQ(MaterialDynamicColors::OnTertiary().GetArgb(scheme), 0xffffffff);
}

TEST(SchemeTonalSpotTest, lightTheme_maxContrast_onTertiary) {
  SchemeTonalSpot scheme = SchemeTonalSpot(Hct(0xff0000ff), false, 1.0);
  EXPECT_EQ(MaterialDynamicColors::OnTertiary().GetArgb(scheme), 0xffffffff);
}

TEST(SchemeTonalSpotTest, lightTheme_minContrast_onError) {
  SchemeTonalSpot scheme = SchemeTonalSpot(Hct(0xff0000ff), false, -1.0);
  EXPECT_EQ(MaterialDynamicColors::OnError().GetArgb(scheme), 0xfffffbff);
}

TEST(SchemeTonalSpotTest, lightTheme_standardContrast_onError) {
  SchemeTonalSpot scheme = SchemeTonalSpot(Hct(0xff0000ff), false, 0.0);
  EXPECT_EQ(MaterialDynamicColors::OnError().GetArgb(scheme), 0xffffffff);
}

TEST(SchemeTonalSpotTest, lightTheme_maxContrast_onError) {
  SchemeTonalSpot scheme = SchemeTonalSpot(Hct(0xff0000ff), false, 1.0);
  EXPECT_EQ(MaterialDynamicColors::OnError().GetArgb(scheme), 0xffffffff);
}

TEST(SchemeTonalSpotTest, darkTheme_minContrast_primary) {
  SchemeTonalSpot scheme = SchemeTonalSpot(Hct(0xff0000ff), true, -1.0);
  EXPECT_EQ(MaterialDynamicColors::Primary().GetArgb(scheme), 0xff888cc8);
}

TEST(SchemeTonalSpotTest, darkTheme_standardContrast_primary) {
  SchemeTonalSpot scheme = SchemeTonalSpot(Hct(0xff0000ff), true, 0.0);
  EXPECT_EQ(MaterialDynamicColors::Primary().GetArgb(scheme), 0xffbec2ff);
}

TEST(SchemeTonalSpotTest, darkTheme_maxContrast_primary) {
  SchemeTonalSpot scheme = SchemeTonalSpot(Hct(0xff0000ff), true, 1.0);
  EXPECT_EQ(MaterialDynamicColors::Primary().GetArgb(scheme), 0xfffdf9ff);
}

TEST(SchemeTonalSpotTest, darkTheme_minContrast_primaryContainer) {
  SchemeTonalSpot scheme = SchemeTonalSpot(Hct(0xff0000ff), true, -1.0);
  EXPECT_EQ(MaterialDynamicColors::PrimaryContainer().GetArgb(scheme),
            0xff31356b);
}

TEST(SchemeTonalSpotTest, darkTheme_standardContrast_primaryContainer) {
  SchemeTonalSpot scheme = SchemeTonalSpot(Hct(0xff0000ff), true, 0.0);
  EXPECT_EQ(MaterialDynamicColors::PrimaryContainer().GetArgb(scheme),
            0xff3E4278);
}

TEST(SchemeTonalSpotTest, darkTheme_maxContrast_primaryContainer) {
  SchemeTonalSpot scheme = SchemeTonalSpot(Hct(0xff0000ff), true, 1.0);
  EXPECT_EQ(MaterialDynamicColors::PrimaryContainer().GetArgb(scheme),
            0xffc4c6ff);
}

TEST(SchemeTonalSpotTest, darkTheme_minContrast_onPrimaryContainer) {
  SchemeTonalSpot scheme = SchemeTonalSpot(Hct(0xff0000ff), true, -1.0);
  EXPECT_EQ(MaterialDynamicColors::OnPrimaryContainer().GetArgb(scheme),
            0xff9b9fdd);
}

TEST(SchemeTonalSpotTest, darkTheme_standardContrast_onPrimaryContainer) {
  SchemeTonalSpot scheme = SchemeTonalSpot(Hct(0xff0000ff), true, 0.0);
  EXPECT_EQ(MaterialDynamicColors::OnPrimaryContainer().GetArgb(scheme),
            0xffe0e0ff);
}

TEST(SchemeTonalSpotTest, darkTheme_maxContrast_onPrimaryContainer) {
  SchemeTonalSpot scheme = SchemeTonalSpot(Hct(0xff0000ff), true, 1.0);
  EXPECT_EQ(MaterialDynamicColors::OnPrimaryContainer().GetArgb(scheme),
            0xff000000);
}

TEST(SchemeTonalSpotTest, darkTheme_minContrast_onTertiaryContainer) {
  SchemeTonalSpot scheme = SchemeTonalSpot(Hct(0xff0000ff), true, -1.0);
  EXPECT_EQ(MaterialDynamicColors::OnTertiaryContainer().GetArgb(scheme),
            0xffc397b2);
}

TEST(SchemeTonalSpotTest, darkTheme_standardContrast_onTertiaryContainer) {
  SchemeTonalSpot scheme = SchemeTonalSpot(Hct(0xff0000ff), true, 0.0);
  EXPECT_EQ(MaterialDynamicColors::OnTertiaryContainer().GetArgb(scheme),
            0xffffd8ee);
}

TEST(SchemeTonalSpotTest, darkTheme_maxContrast_onTertiaryContainer) {
  SchemeTonalSpot scheme = SchemeTonalSpot(Hct(0xff0000ff), true, 1.0);
  EXPECT_EQ(MaterialDynamicColors::OnTertiaryContainer().GetArgb(scheme),
            0xff000000);
}

TEST(SchemeTonalSpotTest, darkTheme_minContrast_onSecondary) {
  SchemeTonalSpot scheme = SchemeTonalSpot(Hct(0xff0000ff), true, -1.0);
  EXPECT_EQ(MaterialDynamicColors::OnSecondary().GetArgb(scheme), 0xff27283b);
}

TEST(SchemeTonalSpotTest, darkTheme_standardContrast_onSecondary) {
  SchemeTonalSpot scheme = SchemeTonalSpot(Hct(0xff0000ff), true, 0.0);
  EXPECT_EQ(MaterialDynamicColors::OnSecondary().GetArgb(scheme), 0xff2e2f42);
}

TEST(SchemeTonalSpotTest, darkTheme_maxContrast_onSecondary) {
  SchemeTonalSpot scheme = SchemeTonalSpot(Hct(0xff0000ff), true, 1.0);
  EXPECT_EQ(MaterialDynamicColors::OnSecondary().GetArgb(scheme), 0xff000000);
}

TEST(SchemeTonalSpotTest, darkTheme_minContrast_onTertiary) {
  SchemeTonalSpot scheme = SchemeTonalSpot(Hct(0xff0000ff), true, -1.0);
  EXPECT_EQ(MaterialDynamicColors::OnTertiary().GetArgb(scheme), 0xff3e1f34);
}

TEST(SchemeTonalSpotTest, darkTheme_standardContrast_onTertiary) {
  SchemeTonalSpot scheme = SchemeTonalSpot(Hct(0xff0000ff), true, 0.0);
  EXPECT_EQ(MaterialDynamicColors::OnTertiary().GetArgb(scheme), 0xff46263b);
}

TEST(SchemeTonalSpotTest, darkTheme_maxContrast_onTertiary) {
  SchemeTonalSpot scheme = SchemeTonalSpot(Hct(0xff0000ff), true, 1.0);
  EXPECT_EQ(MaterialDynamicColors::OnTertiary().GetArgb(scheme), 0xff000000);
}

TEST(SchemeTonalSpotTest, darkTheme_minContrast_onError) {
  SchemeTonalSpot scheme = SchemeTonalSpot(Hct(0xff0000ff), true, -1.0);
  EXPECT_EQ(MaterialDynamicColors::OnError().GetArgb(scheme), 0xff5c0003);
}

TEST(SchemeTonalSpotTest, darkTheme_standardContrast_onError) {
  SchemeTonalSpot scheme = SchemeTonalSpot(Hct(0xff0000ff), true, 0.0);
  EXPECT_EQ(MaterialDynamicColors::OnError().GetArgb(scheme), 0xff690005);
}

TEST(SchemeTonalSpotTest, darkTheme_maxContrast_onError) {
  SchemeTonalSpot scheme = SchemeTonalSpot(Hct(0xff0000ff), true, 1.0);
  EXPECT_EQ(MaterialDynamicColors::OnError().GetArgb(scheme), 0xff000000);
}

TEST(SchemeTonalSpotTest, darkTheme_minContrast_surface) {
  SchemeTonalSpot scheme = SchemeTonalSpot(Hct(0xff0000ff), true, -1.0);
  EXPECT_EQ(MaterialDynamicColors::Surface().GetArgb(scheme), 0xff131318);
}

TEST(SchemeTonalSpotTest, darkTheme_standardContrast_surface) {
  SchemeTonalSpot scheme = SchemeTonalSpot(Hct(0xff0000ff), true, 0.0);
  EXPECT_EQ(MaterialDynamicColors::Surface().GetArgb(scheme), 0xff131318);
}

TEST(SchemeTonalSpotTest, darkTheme_maxContrast_surface) {
  SchemeTonalSpot scheme = SchemeTonalSpot(Hct(0xff0000ff), true, 1.0);
  EXPECT_EQ(MaterialDynamicColors::Surface().GetArgb(scheme), 0xff131318);
}

TEST(SchemeTonalSpotTest, darkTheme_minContrast_onSurface) {
  SchemeTonalSpot scheme = SchemeTonalSpot(Hct(0xff0000ff), true, -1.0);
  EXPECT_EQ(MaterialDynamicColors::OnSurface().GetArgb(scheme), 0xffa4a2a9);
}

TEST(SchemeTonalSpotTest, darkTheme_standardContrast_onSurface) {
  SchemeTonalSpot scheme = SchemeTonalSpot(Hct(0xff0000ff), true, 0.0);
  EXPECT_EQ(MaterialDynamicColors::OnSurface().GetArgb(scheme), 0xffe4e1e9);
}

TEST(SchemeTonalSpotTest, darkTheme_maxContrast_onSurface) {
  SchemeTonalSpot scheme = SchemeTonalSpot(Hct(0xff0000ff), true, 1.0);
  EXPECT_EQ(MaterialDynamicColors::OnSurface().GetArgb(scheme), 0xffffffff);
}

}  // namespace
}  // namespace material_color_utilities
