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

#include "cpp/contrast/contrast.h"

#include "testing/base/public/gunit.h"

namespace material_color_utilities {

namespace {
TEST(ContrastTest, RatioOfTonesOutOfBoundsInput) {
  EXPECT_NEAR(RatioOfTones(-10.0, 110.0), 21.0, 0.001);
}

TEST(ContrastTest, LighterImpossibleRatioErrors) {
  EXPECT_NEAR(Lighter(90.0, 10.0), -1.0, 0.001);
}

TEST(ContrastTest, LighterOutOfBoundsInputAboveErrors) {
  EXPECT_NEAR(Lighter(110.0, 2.0), -1.0, 0.001);
}

TEST(ContrastTest, LighterOutOfBoundsInputBelowErrors) {
  EXPECT_NEAR(Lighter(-10.0, 2.0), -1.0, 0.001);
}

TEST(ContrastTest, LighterUnsafeReturnsMaxTone) {
  EXPECT_NEAR(LighterUnsafe(100.0, 2.0), 100, 0.001);
}

TEST(ContrastTest, DarkerImpossibleRatioErrors) {
  EXPECT_NEAR(Darker(10.0, 20.0), -1.0, 0.001);
}

TEST(ContrastTest, DarkerOutOfBoundsInputAboveErrors) {
  EXPECT_NEAR(Darker(110.0, 2.0), -1.0, 0.001);
}

TEST(ContrastTest, DarkerOutOfBoundsInputBelowErrors) {
  EXPECT_NEAR(Darker(-10.0, 2.0), -1.0, 0.001);
}

TEST(ContrastTest, DarkerUnsafeReturnsMinTone) {
  EXPECT_NEAR(DarkerUnsafe(0.0, 2.0), 0.0, 0.001);
}
}  // namespace

}  // namespace material_color_utilities
