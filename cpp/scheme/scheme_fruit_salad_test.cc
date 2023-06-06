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

#include "cpp/scheme/scheme_fruit_salad.h"

#include "testing/base/public/gunit.h"
#include "cpp/cam/hct.h"
#include "cpp/dynamiccolor/material_dynamic_colors.h"

namespace material_color_utilities {

namespace {
TEST(SchemeFruitSaladTest, KeyColors) {
  SchemeFruitSalad scheme = SchemeFruitSalad(Hct(0xff0000ff), false, 0.0);
  EXPECT_EQ(MaterialDynamicColors::PrimaryPaletteKeyColor().GetArgb(scheme),
            0xff0091C0);
  EXPECT_EQ(MaterialDynamicColors::SecondaryPaletteKeyColor().GetArgb(scheme),
            0xff3A7E9E);
  EXPECT_EQ(MaterialDynamicColors::TertiaryPaletteKeyColor().GetArgb(scheme),
            0xff6E72AC);
  EXPECT_EQ(MaterialDynamicColors::NeutralPaletteKeyColor().GetArgb(scheme),
            0xff777682);
  EXPECT_EQ(
      MaterialDynamicColors::NeutralVariantPaletteKeyColor().GetArgb(scheme),
      0xff75758B);
}

TEST(SchemeFruitSaladTest, lightTheme_minContrast_primary) {
  SchemeFruitSalad scheme = SchemeFruitSalad(Hct(0xff0000ff), false, -1.0);
  EXPECT_EQ(MaterialDynamicColors::Primary().GetArgb(scheme), 0xff007ea7);
}

TEST(SchemeFruitSaladTest, lightTheme_standardContrast_primary) {
  SchemeFruitSalad scheme = SchemeFruitSalad(Hct(0xff0000ff), false, 0.0);
  EXPECT_EQ(MaterialDynamicColors::Primary().GetArgb(scheme), 0xff006688);
}

TEST(SchemeFruitSaladTest, lightTheme_maxContrast_primary) {
  SchemeFruitSalad scheme = SchemeFruitSalad(Hct(0xff0000ff), false, 1.0);
  EXPECT_EQ(MaterialDynamicColors::Primary().GetArgb(scheme), 0xff002635);
}

TEST(SchemeFruitSaladTest, lightTheme_minContrast_primaryContainer) {
  SchemeFruitSalad scheme = SchemeFruitSalad(Hct(0xff0000ff), false, -1.0);
  EXPECT_EQ(MaterialDynamicColors::PrimaryContainer().GetArgb(scheme),
            0xffC2E8FF);
}

TEST(SchemeFruitSaladTest, lightTheme_standardContrast_primaryContainer) {
  SchemeFruitSalad scheme = SchemeFruitSalad(Hct(0xff0000ff), false, 0.0);
  EXPECT_EQ(MaterialDynamicColors::PrimaryContainer().GetArgb(scheme),
            0xffC2E8FF);
}

TEST(SchemeFruitSaladTest, lightTheme_maxContrast_primaryContainer) {
  SchemeFruitSalad scheme = SchemeFruitSalad(Hct(0xff0000ff), false, 1.0);
  EXPECT_EQ(MaterialDynamicColors::PrimaryContainer().GetArgb(scheme),
            0xff004862);
}

TEST(SchemeFruitSaladTest, lightTheme_minContrast_tertiaryContainer) {
  SchemeFruitSalad scheme = SchemeFruitSalad(Hct(0xff0000ff), false, -1.0);
  EXPECT_EQ(MaterialDynamicColors::TertiaryContainer().GetArgb(scheme),
            0xffE0E0FF);
}

TEST(SchemeFruitSaladTest, lightTheme_standardContrast_tertiaryContainer) {
  SchemeFruitSalad scheme = SchemeFruitSalad(Hct(0xff0000ff), false, 0.0);
  EXPECT_EQ(MaterialDynamicColors::TertiaryContainer().GetArgb(scheme),
            0xffE0E0FF);
}

TEST(SchemeFruitSaladTest, lightTheme_maxContrast_tertiaryContainer) {
  SchemeFruitSalad scheme = SchemeFruitSalad(Hct(0xff0000ff), false, 1.0);
  EXPECT_EQ(MaterialDynamicColors::TertiaryContainer().GetArgb(scheme),
            0xFF3A3E74);
}

TEST(SchemeFruitSaladTest, lightTheme_minContrast_onPrimaryContainer) {
  SchemeFruitSalad scheme = SchemeFruitSalad(Hct(0xff0000ff), false, -1.0);
  EXPECT_EQ(MaterialDynamicColors::OnPrimaryContainer().GetArgb(scheme),
            0xff006C90);
}

TEST(SchemeFruitSaladTest, lightTheme_standardContrast_onPrimaryContainer) {
  SchemeFruitSalad scheme = SchemeFruitSalad(Hct(0xff0000ff), false, 0.0);
  EXPECT_EQ(MaterialDynamicColors::OnPrimaryContainer().GetArgb(scheme),
            0xff001E2B);
}

TEST(SchemeFruitSaladTest, lightTheme_maxContrast_onPrimaryContainer) {
  SchemeFruitSalad scheme = SchemeFruitSalad(Hct(0xff0000ff), false, 1.0);
  EXPECT_EQ(MaterialDynamicColors::OnPrimaryContainer().GetArgb(scheme),
            0xffACE1FF);
}

TEST(SchemeFruitSaladTest, lightTheme_minContrast_surface) {
  SchemeFruitSalad scheme = SchemeFruitSalad(Hct(0xff0000ff), false, -1.0);
  EXPECT_EQ(MaterialDynamicColors::Surface().GetArgb(scheme), 0xfffbf8ff);
}

TEST(SchemeFruitSaladTest, lightTheme_standardContrast_surface) {
  SchemeFruitSalad scheme = SchemeFruitSalad(Hct(0xff0000ff), false, 0.0);
  EXPECT_EQ(MaterialDynamicColors::Surface().GetArgb(scheme), 0xfffbf8ff);
}

TEST(SchemeFruitSaladTest, lightTheme_maxContrast_surface) {
  SchemeFruitSalad scheme = SchemeFruitSalad(Hct(0xff0000ff), false, 1.0);
  EXPECT_EQ(MaterialDynamicColors::Surface().GetArgb(scheme), 0xfffbf8ff);
}

TEST(SchemeFruitSaladTest, lightTheme_standardContrast_secondary) {
  SchemeFruitSalad scheme = SchemeFruitSalad(Hct(0xff0000ff), false, 0.0);
  EXPECT_EQ(MaterialDynamicColors::Secondary().GetArgb(scheme), 0xff196584);
}

TEST(SchemeFruitSaladTest, lightTheme_standardContrast_secondaryContainer) {
  SchemeFruitSalad scheme = SchemeFruitSalad(Hct(0xff0000ff), false, 0.0);
  EXPECT_EQ(MaterialDynamicColors::SecondaryContainer().GetArgb(scheme),
            0xffc2e8ff);
}

TEST(SchemeFruitSaladTest, darkTheme_minContrast_primary) {
  SchemeFruitSalad scheme = SchemeFruitSalad(Hct(0xff0000ff), true, -1.0);
  EXPECT_EQ(MaterialDynamicColors::Primary().GetArgb(scheme), 0xff007EA7);
}

TEST(SchemeFruitSaladTest, darkTheme_standardContrast_primary) {
  SchemeFruitSalad scheme = SchemeFruitSalad(Hct(0xff0000ff), true, 0.0);
  EXPECT_EQ(MaterialDynamicColors::Primary().GetArgb(scheme), 0xFF76D1FF);
}

TEST(SchemeFruitSaladTest, darkTheme_maxContrast_primary) {
  SchemeFruitSalad scheme = SchemeFruitSalad(Hct(0xff0000ff), true, 1.0);
  EXPECT_EQ(MaterialDynamicColors::Primary().GetArgb(scheme), 0xFFECF7FF);
}

TEST(SchemeFruitSaladTest, darkTheme_minContrast_primaryContainer) {
  SchemeFruitSalad scheme = SchemeFruitSalad(Hct(0xff0000ff), true, -1.0);
  EXPECT_EQ(MaterialDynamicColors::PrimaryContainer().GetArgb(scheme),
            0xFF004D67);
}

TEST(SchemeFruitSaladTest, darkTheme_standardContrast_primaryContainer) {
  SchemeFruitSalad scheme = SchemeFruitSalad(Hct(0xff0000ff), true, 0.0);
  EXPECT_EQ(MaterialDynamicColors::PrimaryContainer().GetArgb(scheme),
            0xFF004D67);
}

TEST(SchemeFruitSaladTest, darkTheme_maxContrast_primaryContainer) {
  SchemeFruitSalad scheme = SchemeFruitSalad(Hct(0xff0000ff), true, 1.0);
  EXPECT_EQ(MaterialDynamicColors::PrimaryContainer().GetArgb(scheme),
            0xFF83D5FF);
}

TEST(SchemeFruitSaladTest, darkTheme_minContrast_onPrimaryContainer) {
  SchemeFruitSalad scheme = SchemeFruitSalad(Hct(0xff0000ff), true, -1.0);
  EXPECT_EQ(MaterialDynamicColors::OnPrimaryContainer().GetArgb(scheme),
            0xff55C0F2);
}

TEST(SchemeFruitSaladTest, darkTheme_standardContrast_onPrimaryContainer) {
  SchemeFruitSalad scheme = SchemeFruitSalad(Hct(0xff0000ff), true, 0.0);
  EXPECT_EQ(MaterialDynamicColors::OnPrimaryContainer().GetArgb(scheme),
            0xffC2E8FF);
}

TEST(SchemeFruitSaladTest, darkTheme_maxContrast_onPrimaryContainer) {
  SchemeFruitSalad scheme = SchemeFruitSalad(Hct(0xff0000ff), true, 1.0);
  EXPECT_EQ(MaterialDynamicColors::OnPrimaryContainer().GetArgb(scheme),
            0xff003E54);
}

TEST(SchemeFruitSaladTest, darkTheme_minContrast_onTertiaryContainer) {
  SchemeFruitSalad scheme = SchemeFruitSalad(Hct(0xff0000ff), true, -1.0);
  EXPECT_EQ(MaterialDynamicColors::OnTertiaryContainer().GetArgb(scheme),
            0xffADB0EF);
}

TEST(SchemeFruitSaladTest, darkTheme_standardContrast_onTertiaryContainer) {
  SchemeFruitSalad scheme = SchemeFruitSalad(Hct(0xff0000ff), true, 0.0);
  EXPECT_EQ(MaterialDynamicColors::OnTertiaryContainer().GetArgb(scheme),
            0xffe0e0ff);
}

TEST(SchemeFruitSaladTest, darkTheme_maxContrast_onTertiaryContainer) {
  SchemeFruitSalad scheme = SchemeFruitSalad(Hct(0xff0000ff), true, 1.0);
  EXPECT_EQ(MaterialDynamicColors::OnTertiaryContainer().GetArgb(scheme),
            0xff30346A);
}

TEST(SchemeFruitSaladTest, darkTheme_minContrast_surface) {
  SchemeFruitSalad scheme = SchemeFruitSalad(Hct(0xff0000ff), true, -1.0);
  EXPECT_EQ(MaterialDynamicColors::Surface().GetArgb(scheme), 0xff12131c);
}

TEST(SchemeFruitSaladTest, darkTheme_standardContrast_surface) {
  SchemeFruitSalad scheme = SchemeFruitSalad(Hct(0xff0000ff), true, 0.0);
  EXPECT_EQ(MaterialDynamicColors::Surface().GetArgb(scheme), 0xff12131c);
}

TEST(SchemeFruitSaladTest, darkTheme_maxContrast_surface) {
  SchemeFruitSalad scheme = SchemeFruitSalad(Hct(0xff0000ff), true, 1.0);
  EXPECT_EQ(MaterialDynamicColors::Surface().GetArgb(scheme), 0xff12131c);
}

TEST(SchemeFruitSaladTest, darkTheme_standardContrast_secondary) {
  SchemeFruitSalad scheme = SchemeFruitSalad(Hct(0xff0000ff), true, 0.0);
  EXPECT_EQ(MaterialDynamicColors::Secondary().GetArgb(scheme), 0xff8ecff2);
}

TEST(SchemeFruitSaladTest, darkTheme_standardContrast_secondaryContainer) {
  SchemeFruitSalad scheme = SchemeFruitSalad(Hct(0xff0000ff), true, 0.0);
  EXPECT_EQ(MaterialDynamicColors::SecondaryContainer().GetArgb(scheme),
            0xff004d67);
}

}  // namespace
}  // namespace material_color_utilities
