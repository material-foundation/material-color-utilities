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

#include "cpp/dynamiccolor/dynamic_color.h"

#include "testing/base/public/gunit.h"
#include "cpp/cam/hct.h"
#include "cpp/dynamiccolor/material_dynamic_colors.h"
#include "cpp/scheme/scheme_vibrant.h"

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

namespace material_color_utilities {

namespace {
TEST(DynamicColorTest, One) {
  const SchemeVibrant s = SchemeVibrant(Hct(0xFFFF0000), false, 0.5);

  EXPECT_EQ((unsigned int)(MaterialDynamicColors::Background().GetArgb(s)),
            0xfffff8f6);
  EXPECT_EQ((unsigned int)(MaterialDynamicColors::OnBackground().GetArgb(s)),
            0xff261715);
  EXPECT_EQ((unsigned int)(MaterialDynamicColors::Surface().GetArgb(s)),
            0xfffff8f6);
  EXPECT_EQ((unsigned int)(MaterialDynamicColors::SurfaceDim().GetArgb(s)),
            0xfff0d4cf);
  EXPECT_EQ((unsigned int)(MaterialDynamicColors::SurfaceBright().GetArgb(s)),
            0xfffff8f6);
  EXPECT_EQ(
      (unsigned int)(MaterialDynamicColors::SurfaceContainerLowest().GetArgb(
          s)),
      0xffffffff);
  EXPECT_EQ(
      (unsigned int)(MaterialDynamicColors::SurfaceContainerLow().GetArgb(s)),
      0xfffff0ee);
  EXPECT_EQ(
      (unsigned int)(MaterialDynamicColors::SurfaceContainer().GetArgb(s)),
      0xffffe9e6);
  EXPECT_EQ(
      (unsigned int)(MaterialDynamicColors::SurfaceContainerHigh().GetArgb(s)),
      0xffffe2dd);
  EXPECT_EQ(
      (unsigned int)(MaterialDynamicColors::SurfaceContainerHighest().GetArgb(
          s)),
      0xfff9dcd8);
  EXPECT_EQ((unsigned int)(MaterialDynamicColors::OnSurface().GetArgb(s)),
            0xff261715);
  EXPECT_EQ((unsigned int)(MaterialDynamicColors::SurfaceVariant().GetArgb(s)),
            0xfffddbd5);
  EXPECT_EQ(
      (unsigned int)(MaterialDynamicColors::OnSurfaceVariant().GetArgb(s)),
      0xff58413d);
  EXPECT_EQ((unsigned int)(MaterialDynamicColors::InverseSurface().GetArgb(s)),
            0xff3d2c29);
  EXPECT_EQ(
      (unsigned int)(MaterialDynamicColors::InverseOnSurface().GetArgb(s)),
      0xffffedeb);
  EXPECT_EQ((unsigned int)(MaterialDynamicColors::Outline().GetArgb(s)),
            0xff6f5652);
  EXPECT_EQ((unsigned int)(MaterialDynamicColors::OutlineVariant().GetArgb(s)),
            0xff896e6a);
  EXPECT_EQ((unsigned int)(MaterialDynamicColors::Shadow().GetArgb(s)),
            0xff000000);
  EXPECT_EQ((unsigned int)(MaterialDynamicColors::Scrim().GetArgb(s)),
            0xff000000);
  EXPECT_EQ((unsigned int)(MaterialDynamicColors::SurfaceTint().GetArgb(s)),
            0xffc00100);
  EXPECT_EQ((unsigned int)(MaterialDynamicColors::Primary().GetArgb(s)),
            0xff850100);
  EXPECT_EQ((unsigned int)(MaterialDynamicColors::OnPrimary().GetArgb(s)),
            0xffffc8bf);
  EXPECT_EQ(
      (unsigned int)(MaterialDynamicColors::PrimaryContainer().GetArgb(s)),
      0xffeb0000);
  EXPECT_EQ(
      (unsigned int)(MaterialDynamicColors::OnPrimaryContainer().GetArgb(s)),
      0xffffffff);
  EXPECT_EQ((unsigned int)(MaterialDynamicColors::InversePrimary().GetArgb(s)),
            0xffffb5a9);
  EXPECT_EQ((unsigned int)(MaterialDynamicColors::Secondary().GetArgb(s)),
            0xff5c3521);
  EXPECT_EQ((unsigned int)(MaterialDynamicColors::OnSecondary().GetArgb(s)),
            0xffffcab0);
  EXPECT_EQ(
      (unsigned int)(MaterialDynamicColors::SecondaryContainer().GetArgb(s)),
      0xff996952);
  EXPECT_EQ(
      (unsigned int)(MaterialDynamicColors::OnSecondaryContainer().GetArgb(s)),
      0xffffffff);
  EXPECT_EQ((unsigned int)(MaterialDynamicColors::Tertiary().GetArgb(s)),
            0xff5e3506);
  EXPECT_EQ((unsigned int)(MaterialDynamicColors::OnTertiary().GetArgb(s)),
            0xffffcb9d);
  EXPECT_EQ(
      (unsigned int)(MaterialDynamicColors::TertiaryContainer().GetArgb(s)),
      0xff9d6937);
  EXPECT_EQ(
      (unsigned int)(MaterialDynamicColors::OnTertiaryContainer().GetArgb(s)),
      0xffffffff);
  EXPECT_EQ((unsigned int)(MaterialDynamicColors::Error().GetArgb(s)),
            0xff850008);
  EXPECT_EQ((unsigned int)(MaterialDynamicColors::OnError().GetArgb(s)),
            0xffffc8c1);
  EXPECT_EQ((unsigned int)(MaterialDynamicColors::ErrorContainer().GetArgb(s)),
            0xffda342e);
  EXPECT_EQ(
      (unsigned int)(MaterialDynamicColors::OnErrorContainer().GetArgb(s)),
      0xffffffff);
}

}  // namespace

}  // namespace material_color_utilities
