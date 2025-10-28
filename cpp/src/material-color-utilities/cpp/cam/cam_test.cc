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

#include "cpp/cam/cam.h"

#include "testing/base/public/gmock.h"
#include "testing/base/public/gunit.h"

namespace material_color_utilities {

namespace {
using testing::DoubleNear;

using testing::Eq;

Argb RED = 0xffff0000;
Argb GREEN = 0xff00ff00;
Argb BLUE = 0xff0000ff;
Argb WHITE = 0xffffffff;
Argb BLACK = 0xff000000;

TEST(CamTest, Red) {
  Cam cam = CamFromInt(RED);

  EXPECT_THAT(cam.hue, DoubleNear(27.408, 0.001));
  EXPECT_THAT(cam.chroma, DoubleNear(113.357, 0.001));
  EXPECT_THAT(cam.j, DoubleNear(46.445, 0.001));
  EXPECT_THAT(cam.m, DoubleNear(89.494, 0.001));
  EXPECT_THAT(cam.s, DoubleNear(91.889, 0.001));
  EXPECT_THAT(cam.q, DoubleNear(105.988, 0.001));
}

TEST(CamTest, Green) {
  Cam cam = CamFromInt(GREEN);

  EXPECT_THAT(cam.hue, DoubleNear(142.139, 0.001));
  EXPECT_THAT(cam.chroma, DoubleNear(108.410, 0.001));
  EXPECT_THAT(cam.j, DoubleNear(79.331, 0.001));
  EXPECT_THAT(cam.m, DoubleNear(85.587, 0.001));
  EXPECT_THAT(cam.s, DoubleNear(78.604, 0.001));
  EXPECT_THAT(cam.q, DoubleNear(138.520, 0.001));
}

TEST(CamTest, Blue) {
  Cam cam = CamFromInt(BLUE);

  EXPECT_THAT(cam.hue, DoubleNear(282.788, 0.001));
  EXPECT_THAT(cam.chroma, DoubleNear(87.230, 0.001));
  EXPECT_THAT(cam.j, DoubleNear(25.465, 0.001));
  EXPECT_THAT(cam.m, DoubleNear(68.867, 0.001));
  EXPECT_THAT(cam.s, DoubleNear(93.674, 0.001));
  EXPECT_THAT(cam.q, DoubleNear(78.481, 0.001));
}

TEST(CamTest, White) {
  Cam cam = CamFromInt(WHITE);

  EXPECT_THAT(cam.hue, DoubleNear(209.492, 0.001));
  EXPECT_THAT(cam.chroma, DoubleNear(2.869, 0.001));
  EXPECT_THAT(cam.j, DoubleNear(100.0, 0.001));
  EXPECT_THAT(cam.m, DoubleNear(2.265, 0.001));
  EXPECT_THAT(cam.s, DoubleNear(12.068, 0.001));
  EXPECT_THAT(cam.q, DoubleNear(155.521, 0.001));
}

TEST(CamTest, Black) {
  Cam cam = CamFromInt(BLACK);

  EXPECT_THAT(cam.hue, DoubleNear(0.0, 0.001));
  EXPECT_THAT(cam.chroma, DoubleNear(0.0, 0.001));
  EXPECT_THAT(cam.j, DoubleNear(0.0, 0.001));
  EXPECT_THAT(cam.m, DoubleNear(0.0, 0.001));
  EXPECT_THAT(cam.s, DoubleNear(0.0, 0.001));
  EXPECT_THAT(cam.q, DoubleNear(0.0, 0.001));
}

TEST(CamTest, RedRoundTrip) {
  Cam cam = CamFromInt(RED);
  Argb argb = IntFromCam(cam);
  EXPECT_THAT(argb, Eq(RED));
}

TEST(CamTest, GreenRoundTrip) {
  Cam cam = CamFromInt(GREEN);
  Argb argb = IntFromCam(cam);
  EXPECT_THAT(argb, Eq(GREEN));
}

TEST(CamTest, BlueRoundTrip) {
  Cam cam = CamFromInt(BLUE);
  Argb argb = IntFromCam(cam);
  EXPECT_THAT(argb, Eq(BLUE));
}
}  // namespace

}  // namespace material_color_utilities
