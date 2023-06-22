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

#include "cpp/scheme/scheme_fidelity.h"

#include "testing/base/public/gunit.h"
#include "cpp/cam/hct.h"
#include "cpp/dynamiccolor/material_dynamic_colors.h"

namespace material_color_utilities {

namespace {
TEST(SchemeFidelityTest, KeyColors) {
  SchemeFidelity scheme = SchemeFidelity(Hct(0xff0000ff), false, 0.0);
  EXPECT_EQ(MaterialDynamicColors::PrimaryPaletteKeyColor().GetArgb(scheme),
            0xff080cff);
  EXPECT_EQ(MaterialDynamicColors::SecondaryPaletteKeyColor().GetArgb(scheme),
            0xff656dd3);
  EXPECT_EQ(MaterialDynamicColors::TertiaryPaletteKeyColor().GetArgb(scheme),
            0xff9d0002);
  EXPECT_EQ(MaterialDynamicColors::NeutralPaletteKeyColor().GetArgb(scheme),
            0xff767684);
  EXPECT_EQ(
      MaterialDynamicColors::NeutralVariantPaletteKeyColor().GetArgb(scheme),
      0xff757589);
}

TEST(SchemeFidelityTest, lightTheme_minContrast_primary) {
  SchemeFidelity scheme = SchemeFidelity(Hct(0xff0000ff), false, -1.0);
  EXPECT_EQ(MaterialDynamicColors::Primary().GetArgb(scheme), 0xff5660ff);
}

TEST(SchemeFidelityTest, lightTheme_standardContrast_primary) {
  SchemeFidelity scheme = SchemeFidelity(Hct(0xff0000ff), false, 0.0);
  EXPECT_EQ(MaterialDynamicColors::Primary().GetArgb(scheme), 0xff0001c3);
}

TEST(SchemeFidelityTest, lightTheme_maxContrast_primary) {
  SchemeFidelity scheme = SchemeFidelity(Hct(0xff0000ff), false, 1.0);
  EXPECT_EQ(MaterialDynamicColors::Primary().GetArgb(scheme), 0xff000181);
}

TEST(SchemeFidelityTest, lightTheme_minContrast_primaryContainer) {
  SchemeFidelity scheme = SchemeFidelity(Hct(0xff0000ff), false, -1.0);
  EXPECT_EQ(MaterialDynamicColors::PrimaryContainer().GetArgb(scheme),
            0xffd5d6ff);
}

TEST(SchemeFidelityTest, lightTheme_standardContrast_primaryContainer) {
  SchemeFidelity scheme = SchemeFidelity(Hct(0xff0000ff), false, 0.0);
  EXPECT_EQ(MaterialDynamicColors::PrimaryContainer().GetArgb(scheme),
            0xff2d36ff);
}

TEST(SchemeFidelityTest, lightTheme_maxContrast_primaryContainer) {
  SchemeFidelity scheme = SchemeFidelity(Hct(0xff0000ff), false, 1.0);
  EXPECT_EQ(MaterialDynamicColors::PrimaryContainer().GetArgb(scheme),
            0xff0000e3);
}

TEST(SchemeFidelityTest, lightTheme_minContrast_tertiaryContainer) {
  SchemeFidelity scheme = SchemeFidelity(Hct(0xff0000ff), false, -1.0);
  EXPECT_EQ(MaterialDynamicColors::TertiaryContainer().GetArgb(scheme),
            0xffffcdc6);
}

TEST(SchemeFidelityTest, lightTheme_standardContrast_tertiaryContainer) {
  SchemeFidelity scheme = SchemeFidelity(Hct(0xff0000ff), false, 0.0);
  EXPECT_EQ(MaterialDynamicColors::TertiaryContainer().GetArgb(scheme),
            0xffb31910);
}

TEST(SchemeFidelityTest, lightTheme_maxContrast_tertiaryContainer) {
  SchemeFidelity scheme = SchemeFidelity(Hct(0xff0000ff), false, 1.0);
  EXPECT_EQ(MaterialDynamicColors::TertiaryContainer().GetArgb(scheme),
            0xff8c0002);
}

TEST(SchemeFidelityTest,
     lightTheme_minContrast_objectionableTertiaryContainerLightens) {
  SchemeFidelity scheme = SchemeFidelity(Hct(0xff850096), false, -1.0);
  EXPECT_EQ(MaterialDynamicColors::TertiaryContainer().GetArgb(scheme),
            0xffebd982);
}

TEST(SchemeFidelityTest,
     lightTheme_standardContrast_objectionableTertiaryContainerLightens) {
  SchemeFidelity scheme = SchemeFidelity(Hct(0xff850096), false, 0.0);
  EXPECT_EQ(MaterialDynamicColors::TertiaryContainer().GetArgb(scheme),
            0xffbcac5a);
}

TEST(SchemeFidelityTest,
     lightTheme_maxContrast_objectionableTertiaryContainerDarkens) {
  SchemeFidelity scheme = SchemeFidelity(Hct(0xff850096), false, 1.0);
  EXPECT_EQ(MaterialDynamicColors::TertiaryContainer().GetArgb(scheme),
            0xff4d4300);
}

TEST(SchemeFidelityTest, lightTheme_minContrast_onPrimaryContainer) {
  SchemeFidelity scheme = SchemeFidelity(Hct(0xff0000ff), false, -1.0);
  EXPECT_EQ(MaterialDynamicColors::OnPrimaryContainer().GetArgb(scheme),
            0xff333dff);
}

TEST(SchemeFidelityTest, lightTheme_standardContrast_onPrimaryContainer) {
  SchemeFidelity scheme = SchemeFidelity(Hct(0xff0000ff), false, 0.0);
  EXPECT_EQ(MaterialDynamicColors::OnPrimaryContainer().GetArgb(scheme),
            0xffffffff);
}

TEST(SchemeFidelityTest, lightTheme_maxContrast_onPrimaryContainer) {
  SchemeFidelity scheme = SchemeFidelity(Hct(0xff0000ff), false, 1.0);
  EXPECT_EQ(MaterialDynamicColors::OnPrimaryContainer().GetArgb(scheme),
            0xffffffff);
}

TEST(SchemeFidelityTest, lightTheme_minContrast_surface) {
  SchemeFidelity scheme = SchemeFidelity(Hct(0xff0000ff), false, -1.0);
  EXPECT_EQ(MaterialDynamicColors::Surface().GetArgb(scheme), 0xfffbf8ff);
}

TEST(SchemeFidelityTest, lightTheme_standardContrast_surface) {
  SchemeFidelity scheme = SchemeFidelity(Hct(0xff0000ff), false, 0.0);
  EXPECT_EQ(MaterialDynamicColors::Surface().GetArgb(scheme), 0xfffbf8ff);
}

TEST(SchemeFidelityTest, lightTheme_maxContrast_surface) {
  SchemeFidelity scheme = SchemeFidelity(Hct(0xff0000ff), false, 1.0);
  EXPECT_EQ(MaterialDynamicColors::Surface().GetArgb(scheme), 0xfffbf8ff);
}

TEST(SchemeFidelityTest, darkTheme_minContrast_primary) {
  SchemeFidelity scheme = SchemeFidelity(Hct(0xff0000ff), true, -1.0);
  EXPECT_EQ(MaterialDynamicColors::Primary().GetArgb(scheme), 0xff7c84ff);
}

TEST(SchemeFidelityTest, darkTheme_standardContrast_primary) {
  SchemeFidelity scheme = SchemeFidelity(Hct(0xff0000ff), true, 0.0);
  EXPECT_EQ(MaterialDynamicColors::Primary().GetArgb(scheme), 0xffbec2ff);
}

TEST(SchemeFidelityTest, darkTheme_maxContrast_primary) {
  SchemeFidelity scheme = SchemeFidelity(Hct(0xff0000ff), true, 1.0);
  EXPECT_EQ(MaterialDynamicColors::Primary().GetArgb(scheme), 0xfffdf9ff);
}

TEST(SchemeFidelityTest, darkTheme_minContrast_primaryContainer) {
  SchemeFidelity scheme = SchemeFidelity(Hct(0xff0000ff), true, -1.0);
  EXPECT_EQ(MaterialDynamicColors::PrimaryContainer().GetArgb(scheme),
            0xff0001c9);
}

TEST(SchemeFidelityTest, darkTheme_standardContrast_primaryContainer) {
  SchemeFidelity scheme = SchemeFidelity(Hct(0xff0000ff), true, 0.0);
  EXPECT_EQ(MaterialDynamicColors::PrimaryContainer().GetArgb(scheme),
            0xff0000e6);
}

TEST(SchemeFidelityTest, darkTheme_maxContrast_primaryContainer) {
  SchemeFidelity scheme = SchemeFidelity(Hct(0xff0000ff), true, 1.0);
  EXPECT_EQ(MaterialDynamicColors::PrimaryContainer().GetArgb(scheme),
            0xffc4c6ff);
}

TEST(SchemeFidelityTest, darkTheme_minContrast_onPrimaryContainer) {
  SchemeFidelity scheme = SchemeFidelity(Hct(0xff0000ff), true, -1.0);
  EXPECT_EQ(MaterialDynamicColors::OnPrimaryContainer().GetArgb(scheme),
            0xff949bff);
}

TEST(SchemeFidelityTest, darkTheme_standardContrast_onPrimaryContainer) {
  SchemeFidelity scheme = SchemeFidelity(Hct(0xff0000ff), true, 0.0);
  EXPECT_EQ(MaterialDynamicColors::OnPrimaryContainer().GetArgb(scheme),
            0xffd7d8ff);
}

TEST(SchemeFidelityTest, darkTheme_maxContrast_onPrimaryContainer) {
  SchemeFidelity scheme = SchemeFidelity(Hct(0xff0000ff), true, 1.0);
  EXPECT_EQ(MaterialDynamicColors::OnPrimaryContainer().GetArgb(scheme),
            0xff000000);
}

TEST(SchemeFidelityTest, darkTheme_minContrast_onTertiaryContainer) {
  SchemeFidelity scheme = SchemeFidelity(Hct(0xff0000ff), true, -1.0);
  EXPECT_EQ(MaterialDynamicColors::OnTertiaryContainer().GetArgb(scheme),
            0xffff7d6b);
}

TEST(SchemeFidelityTest, darkTheme_standardContrast_onTertiaryContainer) {
  SchemeFidelity scheme = SchemeFidelity(Hct(0xff0000ff), true, 0.0);
  EXPECT_EQ(MaterialDynamicColors::OnTertiaryContainer().GetArgb(scheme),
            0xffffcfc7);
}

TEST(SchemeFidelityTest, darkTheme_maxContrast_onTertiaryContainer) {
  SchemeFidelity scheme = SchemeFidelity(Hct(0xff0000ff), true, 1.0);
  EXPECT_EQ(MaterialDynamicColors::OnTertiaryContainer().GetArgb(scheme),
            0xff000000);
}

TEST(SchemeFidelityTest, darkTheme_minContrast_surface) {
  SchemeFidelity scheme = SchemeFidelity(Hct(0xff0000ff), true, -1.0);
  EXPECT_EQ(MaterialDynamicColors::Surface().GetArgb(scheme), 0xff12121d);
}

TEST(SchemeFidelityTest, darkTheme_standardContrast_surface) {
  SchemeFidelity scheme = SchemeFidelity(Hct(0xff0000ff), true, 0.0);
  EXPECT_EQ(MaterialDynamicColors::Surface().GetArgb(scheme), 0xff12121d);
}

TEST(SchemeFidelityTest, darkTheme_maxContrast_surface) {
  SchemeFidelity scheme = SchemeFidelity(Hct(0xff0000ff), true, 1.0);
  EXPECT_EQ(MaterialDynamicColors::Surface().GetArgb(scheme), 0xff12121d);
}

}  // namespace
}  // namespace material_color_utilities
