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

#include "cpp/quantize/wsmeans.h"

#include <vector>

#include "testing/base/public/gunit.h"

namespace material_color_utilities {

namespace {
TEST(WsmeansTest, FullImage) {
  std::vector<Argb> pixels(12544);
  for (size_t i = 0; i < pixels.size(); i++) {
    // Creates 128 distinct colors
    pixels[i] = i % 8000;
  }
  std::vector<Argb> starting_clusters;

  int iterations = 1;
  int max_colors = 128;

  double sum = 0;

  for (int i = 0; i < iterations; i++) {
    clock_t begin = clock();
    QuantizeWsmeans(pixels, starting_clusters, max_colors);
    clock_t end = clock();
    double time_spent = static_cast<double>(end - begin) / CLOCKS_PER_SEC;
    sum += time_spent;
  }
}

TEST(WsmeansTest, OneRedAndO) {
  std::vector<Argb> pixels;
  pixels.push_back(0xff141216);
  std::vector<Argb> starting_clusters;
  QuantizerResult result = QuantizeWsmeans(pixels, starting_clusters, 256);
  EXPECT_EQ(result.color_to_count.size(), 1u);
  EXPECT_EQ(result.color_to_count[0xff141216], 1);
}

TEST(WsmeansTest, OneRed) {
  std::vector<Argb> pixels;
  pixels.push_back(0xffff0000);
  std::vector<Argb> starting_clusters;
  QuantizerResult result = QuantizeWsmeans(pixels, starting_clusters, 256);
  EXPECT_EQ(result.color_to_count.size(), 1u);
  EXPECT_EQ(result.color_to_count[0xffff0000], 1);
}

TEST(WsmeansTest, OneGreen) {
  std::vector<Argb> pixels;
  pixels.push_back(0xff00ff00);
  std::vector<Argb> starting_clusters;
  QuantizerResult result = QuantizeWsmeans(pixels, starting_clusters, 256);
  EXPECT_EQ(result.color_to_count.size(), 1u);
  EXPECT_EQ(result.color_to_count[0xff00ff00], 1);
}

TEST(WsmeansTest, OneBlue) {
  std::vector<Argb> pixels;
  pixels.push_back(0xff0000ff);
  std::vector<Argb> starting_clusters;
  QuantizerResult result = QuantizeWsmeans(pixels, starting_clusters, 256);
  EXPECT_EQ(result.color_to_count.size(), 1u);
  EXPECT_EQ(result.color_to_count[0xff0000ff], 1);
}

TEST(WsmeansTest, FiveBlue) {
  std::vector<Argb> pixels;
  for (int i = 0; i < 5; i++) {
    pixels.push_back(0xff0000ff);
  }
  std::vector<Argb> starting_clusters;
  QuantizerResult result = QuantizeWsmeans(pixels, starting_clusters, 256);
  EXPECT_EQ(result.color_to_count.size(), 1u);
  EXPECT_EQ(result.color_to_count[0xff0000ff], 5);
}

}  // namespace
}  // namespace material_color_utilities
