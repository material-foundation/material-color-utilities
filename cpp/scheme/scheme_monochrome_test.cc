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
