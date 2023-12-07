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

#include "cpp/quantize/celebi.h"

#include <cstdint>
#include <vector>

#include "testing/base/public/gunit.h"

namespace material_color_utilities {

namespace {

TEST(CelebiTest, FullImage) {
  std::vector<Argb> pixels(12544);
  for (size_t i = 0; i < pixels.size(); i++) {
    // Creates 128 distinct colors
    pixels[i] = i % 8000;
  }

  int iterations = 1;
  uint16_t max_colors = 128;
  double sum = 0;

  for (int i = 0; i < iterations; i++) {
    clock_t begin = clock();
    QuantizeCelebi(pixels, max_colors);
    clock_t end = clock();
    double time_spent = static_cast<double>(end - begin) / CLOCKS_PER_SEC;
    sum += time_spent;
  }
}

TEST(CelebiTest, OneRed) {
  std::vector<Argb> pixels;
  pixels.push_back(0xffff0000);
  QuantizerResult result = QuantizeCelebi(pixels, 256);
  EXPECT_EQ(result.color_to_count.size(), 1u);
  EXPECT_EQ(result.color_to_count[0xffff0000], 1u);
}

TEST(CelebiTest, OneGreen) {
  std::vector<Argb> pixels;
  pixels.push_back(0xff00ff00);
  QuantizerResult result = QuantizeCelebi(pixels, 256);
  EXPECT_EQ(result.color_to_count.size(), 1u);
  EXPECT_EQ(result.color_to_count[0xff00ff00], 1u);
}

TEST(CelebiTest, OneBlue) {
  std::vector<Argb> pixels;
  pixels.push_back(0xff0000ff);
  QuantizerResult result = QuantizeCelebi(pixels, 256);
  EXPECT_EQ(result.color_to_count.size(), 1u);
  EXPECT_EQ(result.color_to_count[0xff0000ff], 1u);
}

TEST(CelebiTest, FiveBlue) {
  std::vector<Argb> pixels;
  for (int i = 0; i < 5; i++) {
    pixels.push_back(0xff0000ff);
  }
  QuantizerResult result = QuantizeCelebi(pixels, 256);
  EXPECT_EQ(result.color_to_count.size(), 1u);
  EXPECT_EQ(result.color_to_count[0xff0000ff], 5u);
}

TEST(CelebiTest, OneRedOneGreenOneBlue) {
  std::vector<Argb> pixels;
  pixels.push_back(0xffff0000);
  pixels.push_back(0xff00ff00);
  pixels.push_back(0xff0000ff);
  QuantizerResult result = QuantizeCelebi(pixels, 256);
  EXPECT_EQ(result.color_to_count.size(), 3u);
  EXPECT_EQ(result.color_to_count[0xffff0000], 1u);
  EXPECT_EQ(result.color_to_count[0xff00ff00], 1u);
  EXPECT_EQ(result.color_to_count[0xff0000ff], 1u);
}

TEST(CelebiTest, TwoRedThreeGreen) {
  std::vector<Argb> pixels;
  pixels.push_back(0xffff0000);
  pixels.push_back(0xffff0000);
  pixels.push_back(0xff00ff00);
  pixels.push_back(0xff00ff00);
  pixels.push_back(0xff00ff00);
  QuantizerResult result = QuantizeCelebi(pixels, 256);
  EXPECT_EQ(result.color_to_count.size(), 2u);
  EXPECT_EQ(result.color_to_count[0xffff0000], 2u);
  EXPECT_EQ(result.color_to_count[0xff00ff00], 3u);
}

TEST(CelebiTest, NoColors) {
  std::vector<Argb> pixels;
  pixels.push_back(0xFFFFFFFF);
  QuantizerResult result = QuantizeCelebi(pixels, 0);
  EXPECT_TRUE(result.color_to_count.empty());
  EXPECT_TRUE(result.input_pixel_to_cluster_pixel.empty());
}

TEST(CelebiTest, SingleTransparent) {
  std::vector<Argb> pixels;
  pixels.push_back(0x20F93013);
  QuantizerResult result = QuantizeCelebi(pixels, 1);
  EXPECT_TRUE(result.color_to_count.empty());
  EXPECT_TRUE(result.input_pixel_to_cluster_pixel.empty());
}

TEST(CelebiTest, TooManyColors) {
  std::vector<Argb> pixels;
  QuantizerResult result = QuantizeCelebi(pixels, 32767);
  EXPECT_TRUE(result.color_to_count.empty());
  EXPECT_TRUE(result.input_pixel_to_cluster_pixel.empty());
}

}  // namespace
}  // namespace material_color_utilities
