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

#include "cpp/scheme/scheme_neutral.h"

#include "testing/base/public/gunit.h"
#include "cpp/cam/hct.h"
#include "cpp/dynamiccolor/material_dynamic_colors.h"

namespace material_color_utilities {

namespace {
TEST(SchemeNeutralTest, KeyColors) {
  SchemeNeutral scheme = SchemeNeutral(Hct(0xff0000ff), false, 0.0);
  EXPECT_EQ(MaterialDynamicColors::PrimaryPaletteKeyColor().GetArgb(scheme),
            0xff767685);
  EXPECT_EQ(MaterialDynamicColors::SecondaryPaletteKeyColor().GetArgb(scheme),
            0xff777680);
  EXPECT_EQ(MaterialDynamicColors::TertiaryPaletteKeyColor().GetArgb(scheme),
            0xff75758B);
  EXPECT_EQ(MaterialDynamicColors::NeutralPaletteKeyColor().GetArgb(scheme),
            0xff787678);
  EXPECT_EQ(
      MaterialDynamicColors::NeutralVariantPaletteKeyColor().GetArgb(scheme),
      0xff787678);
}

TEST(SchemeNeutralTest, lightTheme_minContrast_primary) {
  SchemeNeutral scheme = SchemeNeutral(Hct(0xff0000ff), false, -1.0);
  EXPECT_EQ(MaterialDynamicColors::Primary().GetArgb(scheme), 0xff737383);
}

TEST(SchemeNeutralTest, lightTheme_standardContrast_primary) {
  SchemeNeutral scheme = SchemeNeutral(Hct(0xff0000ff), false, 0.0);
  EXPECT_EQ(MaterialDynamicColors::Primary().GetArgb(scheme), 0xff5d5d6c);
}

TEST(SchemeNeutralTest, lightTheme_maxContrast_primary) {
  SchemeNeutral scheme = SchemeNeutral(Hct(0xff0000ff), false, 1.0);
  EXPECT_EQ(MaterialDynamicColors::Primary().GetArgb(scheme), 0xff21212e);
}

TEST(SchemeNeutralTest, lightTheme_minContrast_primaryContainer) {
  SchemeNeutral scheme = SchemeNeutral(Hct(0xff0000ff), false, -1.0);
  EXPECT_EQ(MaterialDynamicColors::PrimaryContainer().GetArgb(scheme),
            0xffe2e1f3);
}

TEST(SchemeNeutralTest, lightTheme_standardContrast_primaryContainer) {
  SchemeNeutral scheme = SchemeNeutral(Hct(0xff0000ff), false, 0.0);
  EXPECT_EQ(MaterialDynamicColors::PrimaryContainer().GetArgb(scheme),
            0xffe2e1f3);
}

TEST(SchemeNeutralTest, lightTheme_maxContrast_primaryContainer) {
  SchemeNeutral scheme = SchemeNeutral(Hct(0xff0000ff), false, 1.0);
  EXPECT_EQ(MaterialDynamicColors::PrimaryContainer().GetArgb(scheme),
            0xff414250);
}

TEST(SchemeNeutralTest, lightTheme_minContrast_onPrimaryContainer) {
  SchemeNeutral scheme = SchemeNeutral(Hct(0xff0000ff), false, -1.0);
  EXPECT_EQ(MaterialDynamicColors::OnPrimaryContainer().GetArgb(scheme),
            0xff636372);
}

TEST(SchemeNeutralTest, lightTheme_standardContrast_onPrimaryContainer) {
  SchemeNeutral scheme = SchemeNeutral(Hct(0xff0000ff), false, 0.0);
  EXPECT_EQ(MaterialDynamicColors::OnPrimaryContainer().GetArgb(scheme),
            0xff1a1b27);
}

TEST(SchemeNeutralTest, lightTheme_maxContrast_onPrimaryContainer) {
  SchemeNeutral scheme = SchemeNeutral(Hct(0xff0000ff), false, 1.0);
  EXPECT_EQ(MaterialDynamicColors::OnPrimaryContainer().GetArgb(scheme),
            0xffd9d8ea);
}

TEST(SchemeNeutralTest, lightTheme_minContrast_surface) {
  SchemeNeutral scheme = SchemeNeutral(Hct(0xff0000ff), false, -1.0);
  EXPECT_EQ(MaterialDynamicColors::Surface().GetArgb(scheme), 0xfffcf8fa);
}

TEST(SchemeNeutralTest, lightTheme_standardContrast_surface) {
  SchemeNeutral scheme = SchemeNeutral(Hct(0xff0000ff), false, 0.0);
  EXPECT_EQ(MaterialDynamicColors::Surface().GetArgb(scheme), 0xfffcf8fa);
}

TEST(SchemeNeutralTest, lightTheme_maxContrast_surface) {
  SchemeNeutral scheme = SchemeNeutral(Hct(0xff0000ff), false, 1.0);
  EXPECT_EQ(MaterialDynamicColors::Surface().GetArgb(scheme), 0xfffcf8fa);
}

TEST(SchemeNeutralTest, darkTheme_minContrast_primary) {
  SchemeNeutral scheme = SchemeNeutral(Hct(0xff0000ff), true, -1.0);
  EXPECT_EQ(MaterialDynamicColors::Primary().GetArgb(scheme), 0xff737383);
}

TEST(SchemeNeutralTest, darkTheme_standardContrast_primary) {
  SchemeNeutral scheme = SchemeNeutral(Hct(0xff0000ff), true, 0.0);
  EXPECT_EQ(MaterialDynamicColors::Primary().GetArgb(scheme), 0xffc6c5d6);
}

TEST(SchemeNeutralTest, darkTheme_maxContrast_primary) {
  SchemeNeutral scheme = SchemeNeutral(Hct(0xff0000ff), true, 1.0);
  EXPECT_EQ(MaterialDynamicColors::Primary().GetArgb(scheme), 0xfff6f4ff);
}

TEST(SchemeNeutralTest, darkTheme_minContrast_primaryContainer) {
  SchemeNeutral scheme = SchemeNeutral(Hct(0xff0000ff), true, -1.0);
  EXPECT_EQ(MaterialDynamicColors::PrimaryContainer().GetArgb(scheme),
            0xff454654);
}

TEST(SchemeNeutralTest, darkTheme_standardContrast_primaryContainer) {
  SchemeNeutral scheme = SchemeNeutral(Hct(0xff0000ff), true, 0.0);
  EXPECT_EQ(MaterialDynamicColors::PrimaryContainer().GetArgb(scheme),
            0xff454654);
}

TEST(SchemeNeutralTest, darkTheme_maxContrast_primaryContainer) {
  SchemeNeutral scheme = SchemeNeutral(Hct(0xff0000ff), true, 1.0);
  EXPECT_EQ(MaterialDynamicColors::PrimaryContainer().GetArgb(scheme),
            0xffcac9da);
}

TEST(SchemeNeutralTest, darkTheme_minContrast_onPrimaryContainer) {
  SchemeNeutral scheme = SchemeNeutral(Hct(0xff0000ff), true, -1.0);
  EXPECT_EQ(MaterialDynamicColors::OnPrimaryContainer().GetArgb(scheme),
            0xffb5b3c4);
}

TEST(SchemeNeutralTest, darkTheme_standardContrast_onPrimaryContainer) {
  SchemeNeutral scheme = SchemeNeutral(Hct(0xff0000ff), true, 0.0);
  EXPECT_EQ(MaterialDynamicColors::OnPrimaryContainer().GetArgb(scheme),
            0xffe2e1f3);
}

TEST(SchemeNeutralTest, darkTheme_maxContrast_onPrimaryContainer) {
  SchemeNeutral scheme = SchemeNeutral(Hct(0xff0000ff), true, 1.0);
  EXPECT_EQ(MaterialDynamicColors::OnPrimaryContainer().GetArgb(scheme),
            0xff373846);
}

TEST(SchemeNeutralTest, darkTheme_minContrast_onTertiaryContainer) {
  SchemeNeutral scheme = SchemeNeutral(Hct(0xff0000ff), true, -1.0);
  EXPECT_EQ(MaterialDynamicColors::OnTertiaryContainer().GetArgb(scheme),
            0xffb3b3cb);
}

TEST(SchemeNeutralTest, darkTheme_standardContrast_onTertiaryContainer) {
  SchemeNeutral scheme = SchemeNeutral(Hct(0xff0000ff), true, 0.0);
  EXPECT_EQ(MaterialDynamicColors::OnTertiaryContainer().GetArgb(scheme),
            0xffe1e0f9);
}

TEST(SchemeNeutralTest, darkTheme_maxContrast_onTertiaryContainer) {
  SchemeNeutral scheme = SchemeNeutral(Hct(0xff0000ff), true, 1.0);
  EXPECT_EQ(MaterialDynamicColors::OnTertiaryContainer().GetArgb(scheme),
            0xff37374b);
}

TEST(SchemeNeutralTest, darkTheme_minContrast_surface) {
  SchemeNeutral scheme = SchemeNeutral(Hct(0xff0000ff), true, -1.0);
  EXPECT_EQ(MaterialDynamicColors::Surface().GetArgb(scheme), 0xff131315);
}

TEST(SchemeNeutralTest, darkTheme_standardContrast_surface) {
  SchemeNeutral scheme = SchemeNeutral(Hct(0xff0000ff), true, 0.0);
  EXPECT_EQ(MaterialDynamicColors::Surface().GetArgb(scheme), 0xff131315);
}

TEST(SchemeNeutralTest, darkTheme_maxContrast_surface) {
  SchemeNeutral scheme = SchemeNeutral(Hct(0xff0000ff), true, 1.0);
  EXPECT_EQ(MaterialDynamicColors::Surface().GetArgb(scheme), 0xff131315);
}

}  // namespace
}  // namespace material_color_utilities
