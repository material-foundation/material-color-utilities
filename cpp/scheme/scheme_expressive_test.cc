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

#include "cpp/scheme/scheme_expressive.h"

#include "testing/base/public/gunit.h"
#include "cpp/cam/hct.h"
#include "cpp/dynamiccolor/material_dynamic_colors.h"

namespace material_color_utilities {

namespace {
TEST(SchemeExpressiveTest, KeyColors) {
  SchemeExpressive scheme = SchemeExpressive(Hct(0xff0000ff), false, 0.0);
  EXPECT_EQ(MaterialDynamicColors::PrimaryPaletteKeyColor().GetArgb(scheme),
            0xff35855f);
  EXPECT_EQ(MaterialDynamicColors::SecondaryPaletteKeyColor().GetArgb(scheme),
            0xff8c6d8c);
  EXPECT_EQ(MaterialDynamicColors::TertiaryPaletteKeyColor().GetArgb(scheme),
            0xff806ea1);
  EXPECT_EQ(MaterialDynamicColors::NeutralPaletteKeyColor().GetArgb(scheme),
            0xff79757f);
  EXPECT_EQ(
      MaterialDynamicColors::NeutralVariantPaletteKeyColor().GetArgb(scheme),
      0xff7a7585);
}

TEST(SchemeExpressiveTest, lightTheme_minContrast_primary) {
  SchemeExpressive scheme = SchemeExpressive(Hct(0xff0000ff), false, -1.0);
  EXPECT_EQ(MaterialDynamicColors::Primary().GetArgb(scheme), 0xff32835d);
}

TEST(SchemeExpressiveTest, lightTheme_standardContrast_primary) {
  SchemeExpressive scheme = SchemeExpressive(Hct(0xff0000ff), false, 0.0);
  EXPECT_EQ(MaterialDynamicColors::Primary().GetArgb(scheme), 0xff146c48);
}

TEST(SchemeExpressiveTest, lightTheme_maxContrast_primary) {
  SchemeExpressive scheme = SchemeExpressive(Hct(0xff0000ff), false, 1.0);
  EXPECT_EQ(MaterialDynamicColors::Primary().GetArgb(scheme), 0xff002818);
}

TEST(SchemeExpressiveTest, lightTheme_minContrast_primaryContainer) {
  SchemeExpressive scheme = SchemeExpressive(Hct(0xff0000ff), false, -1.0);
  EXPECT_EQ(MaterialDynamicColors::PrimaryContainer().GetArgb(scheme),
            0xff99eabd);
}

TEST(SchemeExpressiveTest, lightTheme_standardContrast_primaryContainer) {
  SchemeExpressive scheme = SchemeExpressive(Hct(0xff0000ff), false, 0.0);
  EXPECT_EQ(MaterialDynamicColors::PrimaryContainer().GetArgb(scheme),
            0xffa2f4c6);
}

TEST(SchemeExpressiveTest, lightTheme_maxContrast_primaryContainer) {
  SchemeExpressive scheme = SchemeExpressive(Hct(0xff0000ff), false, 1.0);
  EXPECT_EQ(MaterialDynamicColors::PrimaryContainer().GetArgb(scheme),
            0xff004d31);
}

TEST(SchemeExpressiveTest, lightTheme_minContrast_onPrimaryContainer) {
  SchemeExpressive scheme = SchemeExpressive(Hct(0xff0000ff), false, -1.0);
  EXPECT_EQ(MaterialDynamicColors::OnPrimaryContainer().GetArgb(scheme),
            0xff146c48);
}

TEST(SchemeExpressiveTest, lightTheme_standardContrast_onPrimaryContainer) {
  SchemeExpressive scheme = SchemeExpressive(Hct(0xff0000ff), false, 0.0);
  EXPECT_EQ(MaterialDynamicColors::OnPrimaryContainer().GetArgb(scheme),
            0xff002112);
}

TEST(SchemeExpressiveTest, lightTheme_maxContrast_onPrimaryContainer) {
  SchemeExpressive scheme = SchemeExpressive(Hct(0xff0000ff), false, 1.0);
  EXPECT_EQ(MaterialDynamicColors::OnPrimaryContainer().GetArgb(scheme),
            0xffffffff);
}

TEST(SchemeExpressiveTest, lightTheme_minContrast_surface) {
  SchemeExpressive scheme = SchemeExpressive(Hct(0xff0000ff), false, -1.0);
  EXPECT_EQ(MaterialDynamicColors::Surface().GetArgb(scheme), 0xfffdf7ff);
}

TEST(SchemeExpressiveTest, lightTheme_standardContrast_surface) {
  SchemeExpressive scheme = SchemeExpressive(Hct(0xff0000ff), false, 0.0);
  EXPECT_EQ(MaterialDynamicColors::Surface().GetArgb(scheme), 0xfffdf7ff);
}

TEST(SchemeExpressiveTest, lightTheme_maxContrast_surface) {
  SchemeExpressive scheme = SchemeExpressive(Hct(0xff0000ff), false, 1.0);
  EXPECT_EQ(MaterialDynamicColors::Surface().GetArgb(scheme), 0xfffdf7ff);
}

TEST(SchemeExpressiveTest, darkTheme_minContrast_primary) {
  SchemeExpressive scheme = SchemeExpressive(Hct(0xff0000ff), true, -1.0);
  EXPECT_EQ(MaterialDynamicColors::Primary().GetArgb(scheme), 0xff51a078);
}

TEST(SchemeExpressiveTest, darkTheme_standardContrast_primary) {
  SchemeExpressive scheme = SchemeExpressive(Hct(0xff0000ff), true, 0.0);
  EXPECT_EQ(MaterialDynamicColors::Primary().GetArgb(scheme), 0xff87d7ab);
}

TEST(SchemeExpressiveTest, darkTheme_maxContrast_primary) {
  SchemeExpressive scheme = SchemeExpressive(Hct(0xff0000ff), true, 1.0);
  EXPECT_EQ(MaterialDynamicColors::Primary().GetArgb(scheme), 0xffeefff2);
}

TEST(SchemeExpressiveTest, darkTheme_minContrast_primaryContainer) {
  SchemeExpressive scheme = SchemeExpressive(Hct(0xff0000ff), true, -1.0);
  EXPECT_EQ(MaterialDynamicColors::PrimaryContainer().GetArgb(scheme),
            0xff00432a);
}

TEST(SchemeExpressiveTest, darkTheme_standardContrast_primaryContainer) {
  SchemeExpressive scheme = SchemeExpressive(Hct(0xff0000ff), true, 0.0);
  EXPECT_EQ(MaterialDynamicColors::PrimaryContainer().GetArgb(scheme),
            0xff005234);
}

TEST(SchemeExpressiveTest, darkTheme_maxContrast_primaryContainer) {
  SchemeExpressive scheme = SchemeExpressive(Hct(0xff0000ff), true, 1.0);
  EXPECT_EQ(MaterialDynamicColors::PrimaryContainer().GetArgb(scheme),
            0xff8bdbaf);
}

TEST(SchemeExpressiveTest, darkTheme_minContrast_onPrimaryContainer) {
  SchemeExpressive scheme = SchemeExpressive(Hct(0xff0000ff), true, -1.0);
  EXPECT_EQ(MaterialDynamicColors::OnPrimaryContainer().GetArgb(scheme),
            0xff64b48a);
}

TEST(SchemeExpressiveTest, darkTheme_standardContrast_onPrimaryContainer) {
  SchemeExpressive scheme = SchemeExpressive(Hct(0xff0000ff), true, 0.0);
  EXPECT_EQ(MaterialDynamicColors::OnPrimaryContainer().GetArgb(scheme),
            0xffa2f4c6);
}

TEST(SchemeExpressiveTest, darkTheme_maxContrast_onPrimaryContainer) {
  SchemeExpressive scheme = SchemeExpressive(Hct(0xff0000ff), true, 1.0);
  EXPECT_EQ(MaterialDynamicColors::OnPrimaryContainer().GetArgb(scheme),
            0xff000000);
}

TEST(SchemeExpressiveTest, darkTheme_minContrast_surface) {
  SchemeExpressive scheme = SchemeExpressive(Hct(0xff0000ff), true, -1.0);
  EXPECT_EQ(MaterialDynamicColors::Surface().GetArgb(scheme), 0xff14121a);
}

TEST(SchemeExpressiveTest, darkTheme_standardContrast_surface) {
  SchemeExpressive scheme = SchemeExpressive(Hct(0xff0000ff), true, 0.0);
  EXPECT_EQ(MaterialDynamicColors::Surface().GetArgb(scheme), 0xff14121a);
}

TEST(SchemeExpressiveTest, darkTheme_maxContrast_surface) {
  SchemeExpressive scheme = SchemeExpressive(Hct(0xff0000ff), true, 1.0);
  EXPECT_EQ(MaterialDynamicColors::Surface().GetArgb(scheme), 0xff14121a);
}
}  // namespace
}  // namespace material_color_utilities
