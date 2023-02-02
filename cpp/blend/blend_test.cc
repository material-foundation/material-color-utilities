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

#include "cpp/blend/blend.h"

#include "testing/base/public/gunit.h"
#include "cpp/utils/utils.h"

namespace material_color_utilities {

namespace {
TEST(BlendTest, RedToBlue) {
  int blended = BlendHctHue(0xffff0000, 0xff0000ff, 0.8);
  EXPECT_EQ(HexFromArgb(blended), "ff905eff");
}
}  // namespace

}  // namespace material_color_utilities
