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

#include "cpp/palettes/core.h"

#include "testing/base/public/gunit.h"
#include "cpp/cam/cam.h"
#include "cpp/palettes/tones.h"
#include "cpp/utils/utils.h"

namespace material_color_utilities {

namespace {

TEST(TonesTest, HueRotatesRed) {
  int color = 0xffff0000;

  CorePalette palette = CorePalette::Of(color);

  double delta_hue = DiffDegrees(CamFromInt(palette.tertiary().get(50)).hue,
                                 CamFromInt(palette.primary().get(50)).hue);
  ASSERT_NEAR(delta_hue, 60.0, 2.0);
}

TEST(TonesTest, HueRotatesGreen) {
  int color = 0xff00ff00;

  CorePalette palette = CorePalette::Of(color);

  double delta_hue = DiffDegrees(CamFromInt(palette.tertiary().get(50)).hue,
                                 CamFromInt(palette.primary().get(50)).hue);
  ASSERT_NEAR(delta_hue, 60.0, 2.0);
}

TEST(TonesTest, HueRotatesBlue) {
  int color = 0xff0000ff;

  CorePalette palette = CorePalette::Of(color);

  double delta_hue = DiffDegrees(CamFromInt(palette.tertiary().get(50)).hue,
                                 CamFromInt(palette.primary().get(50)).hue);
  ASSERT_NEAR(delta_hue, 60.0, 1.0);
}

TEST(TonesTest, HueWrapsWhenRotating) {
  Cam cam = CamFromInt(IntFromHcl(350, 48, 50));

  CorePalette palette = CorePalette::Of(cam.hue, cam.chroma);

  double a1_hue = CamFromInt(palette.primary().get(50)).hue;
  double a3_hue = CamFromInt(palette.tertiary().get(50)).hue;
  ASSERT_NEAR(DiffDegrees(a1_hue, a3_hue), 60.0, 1.0);
  ASSERT_NEAR(a3_hue, 50, 1.0);
}

}  // namespace
}  // namespace material_color_utilities
