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

#include "cpp/cam/hct_solver.h"

#include "testing/base/public/gmock.h"
#include "testing/base/public/gunit.h"
#include "cpp/cam/cam.h"
#include "cpp/utils/utils.h"

namespace material_color_utilities {

namespace {
using testing::Eq;

TEST(HctSolverTest, Red) {
  // Compute HCT
  Argb color = 0xFFFE0315;
  Cam cam = CamFromInt(color);
  double tone = LstarFromArgb(color);

  // Compute input
  Argb recovered = SolveToInt(cam.hue, cam.chroma, tone);
  EXPECT_THAT(recovered, Eq(color));
}

TEST(HctSolverTest, Green) {
  // Compute HCT
  Argb color = 0xFF15FE03;
  Cam cam = CamFromInt(color);
  double tone = LstarFromArgb(color);

  // Compute input
  Argb recovered = SolveToInt(cam.hue, cam.chroma, tone);
  EXPECT_THAT(recovered, Eq(color));
}

TEST(HctSolverTest, Blue) {
  // Compute HCT
  Argb color = 0xFF0315FE;
  Cam cam = CamFromInt(color);
  double tone = LstarFromArgb(color);

  // Compute input
  Argb recovered = SolveToInt(cam.hue, cam.chroma, tone);
  EXPECT_THAT(recovered, Eq(color));
}

TEST(HctSolverTest, Exhaustive) {
  for (int colorIndex = 0; colorIndex <= 0xFFFFFF; colorIndex++) {
    Argb color = 0xFF000000 | colorIndex;
    Cam cam = CamFromInt(color);
    double tone = LstarFromArgb(color);

    // Compute input
    Argb recovered = SolveToInt(cam.hue, cam.chroma, tone);
    EXPECT_THAT(recovered, Eq(color));
  }
}
}  // namespace
}  // namespace material_color_utilities
