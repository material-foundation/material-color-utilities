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

#include "cpp/quantize/wu.h"

#include <cstdint>
#include <vector>

#include "testing/base/public/gunit.h"

namespace material_color_utilities {

namespace {

TEST(WuTest, FullImage) {
  std::vector<Argb> pixels(12544);
  for (size_t i = 0; i < pixels.size(); i++) {
    // Creates 128 distinct colors
    pixels[i] = i % 8000;
  }

  uint16_t max_colors = 128;

  QuantizeWu(pixels, max_colors);
}

TEST(WuTest, TwoRedThreeGreen) {
  std::vector<Argb> pixels;
  pixels.push_back(0xffff0000);
  pixels.push_back(0xffff0000);
  pixels.push_back(0xffff0000);
  pixels.push_back(0xff00ff00);
  pixels.push_back(0xff00ff00);
  std::vector<Argb> result = QuantizeWu(pixels, 256);
  EXPECT_EQ(result.size(), 2u);
}

TEST(WuTest, OneRed) {
  std::vector<Argb> pixels;
  pixels.push_back(0xffff0000);
  std::vector<Argb> result = QuantizeWu(pixels, 256);
  EXPECT_EQ(result.size(), 1u);
  EXPECT_EQ(result[0], 0xffff0000);
}

TEST(WuTest, OneGreen) {
  std::vector<Argb> pixels;
  pixels.push_back(0xff00ff00);
  std::vector<Argb> result = QuantizeWu(pixels, 256);
  EXPECT_EQ(result.size(), 1u);
  EXPECT_EQ(result[0], 0xff00ff00);
}

TEST(WuTest, OneBlue) {
  std::vector<Argb> pixels;
  pixels.push_back(0xff0000ff);
  std::vector<Argb> result = QuantizeWu(pixels, 256);
  EXPECT_EQ(result.size(), 1u);
  EXPECT_EQ(result[0], 0xff0000ff);
}

TEST(WuTest, FiveBlue) {
  std::vector<Argb> pixels;
  for (int i = 0; i < 5; i++) {
    pixels.push_back(0xff0000ff);
  }
  std::vector<Argb> result = QuantizeWu(pixels, 256);
  EXPECT_EQ(result.size(), 1u);
  EXPECT_EQ(result[0], 0xff0000ff);
}

TEST(WuTest, OneRedAndO) {
  std::vector<Argb> pixels;
  pixels.push_back(0xff141216);
  std::vector<Argb> result = QuantizeWu(pixels, 256);
  EXPECT_EQ(result.size(), 1u);
  EXPECT_EQ(result[0], 0xff141216);
}

TEST(WuTest, RedGreenBlue) {
  std::vector<Argb> pixels;
  pixels.push_back(0xffff0000);
  pixels.push_back(0xff00ff00);
  pixels.push_back(0xff0000ff);
  std::vector<Argb> result = QuantizeWu(pixels, 256);
  EXPECT_EQ(result.size(), 3u);
  EXPECT_EQ(result[0], 0xff0000ff);
  EXPECT_EQ(result[1], 0xffff0000);
  EXPECT_EQ(result[2], 0xff00ff00);
}

TEST(WuTest, Testonly) {
  std::vector<Argb> pixels;
  pixels.push_back(0xff010203);
  pixels.push_back(0xff665544);
  pixels.push_back(0xff708090);
  pixels.push_back(0xffc0ffee);
  pixels.push_back(0xfffedcba);
  std::vector<Argb> result = QuantizeWu(pixels, 256);
}

}  // namespace
}  // namespace material_color_utilities
