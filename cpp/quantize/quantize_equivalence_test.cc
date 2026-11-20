/*
 * Copyright 2026 Google LLC
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

// Checks that the optimized quantizers return exactly what the reference
// implementations below return. The reference implementations are frozen
// copies of `LabFromInt`, `QuantizeWsmeans` and `QuantizeCelebi` from before
// they were optimized, including their use of `srand()` and `rand()`.

#include <algorithm>
#include <cmath>
#include <cstdint>
#include <cstdlib>
#include <cstring>
#include <map>
#include <random>
#include <vector>

#include "testing/base/public/gunit.h"
#include "absl/container/flat_hash_map.h"
#include "cpp/quantize/celebi.h"
#include "cpp/quantize/lab.h"
#include "cpp/quantize/wsmeans.h"
#include "cpp/quantize/wu.h"
#include "cpp/utils/utils.h"

namespace material_color_utilities {
namespace {

// ---------------------------------------------------------------------------
// Reference implementations. Do not change them: they define the expected
// output.
// ---------------------------------------------------------------------------

Lab ReferenceLabFromInt(const Argb argb) {
  int red = (argb & 0x00ff0000) >> 16;
  int green = (argb & 0x0000ff00) >> 8;
  int blue = (argb & 0x000000ff);
  double red_l = Linearized(red);
  double green_l = Linearized(green);
  double blue_l = Linearized(blue);
  double x = 0.41233895 * red_l + 0.35762064 * green_l + 0.18051042 * blue_l;
  double y = 0.2126 * red_l + 0.7152 * green_l + 0.0722 * blue_l;
  double z = 0.01932141 * red_l + 0.11916382 * green_l + 0.95034478 * blue_l;
  double y_normalized = y / kWhitePointD65[1];
  double e = 216.0 / 24389.0;
  double kappa = 24389.0 / 27.0;
  double fy;
  if (y_normalized > e) {
    fy = pow(y_normalized, 1.0 / 3.0);
  } else {
    fy = (kappa * y_normalized + 16) / 116;
  }

  double x_normalized = x / kWhitePointD65[0];
  double fx;
  if (x_normalized > e) {
    fx = pow(x_normalized, 1.0 / 3.0);
  } else {
    fx = (kappa * x_normalized + 16) / 116;
  }

  double z_normalized = z / kWhitePointD65[2];
  double fz;
  if (z_normalized > e) {
    fz = pow(z_normalized, 1.0 / 3.0);
  } else {
    fz = (kappa * z_normalized + 16) / 116;
  }

  double l = 116.0 * fy - 16;
  double a = 500.0 * (fx - fy);
  double b = 200.0 * (fy - fz);
  return {l, a, b};
}

struct ReferenceSwatch {
  Argb argb = 0;
  int population = 0;

  bool operator<(const ReferenceSwatch& b) const {
    return population > b.population;
  }
};

struct ReferenceDistanceToIndex {
  double distance = 0.0;
  int index = 0;

  bool operator<(const ReferenceDistanceToIndex& a) const {
    return distance < a.distance;
  }
};

QuantizerResult ReferenceQuantizeWsmeans(
    const std::vector<Argb>& input_pixels,
    const std::vector<Argb>& starting_clusters, uint16_t max_colors) {
  constexpr int kMaxIterations = 100;
  constexpr double kMinDeltaE = 3.0;

  if (max_colors == 0 || input_pixels.empty()) {
    return QuantizerResult();
  }

  if (max_colors > 256) {
    max_colors = 256;
  }

  uint32_t pixel_count = input_pixels.size();
  absl::flat_hash_map<Argb, int> pixel_to_count;
  std::vector<uint32_t> pixels;
  pixels.reserve(pixel_count);
  std::vector<Lab> points;
  points.reserve(pixel_count);
  for (Argb pixel : input_pixels) {
    absl::flat_hash_map<Argb, int>::iterator it = pixel_to_count.find(pixel);
    if (it != pixel_to_count.end()) {
      it->second++;

    } else {
      pixels.push_back(pixel);
      points.push_back(ReferenceLabFromInt(pixel));
      pixel_to_count[pixel] = 1;
    }
  }

  int cluster_count = std::min((int)max_colors, (int)points.size());

  if (!starting_clusters.empty()) {
    cluster_count = std::min(cluster_count, (int)starting_clusters.size());
  }

  int pixel_count_sums[256] = {};
  std::vector<Lab> clusters;
  clusters.reserve(starting_clusters.size());
  for (int argb : starting_clusters) {
    clusters.push_back(ReferenceLabFromInt(argb));
  }

  srand(42688);
  int additional_clusters_needed = cluster_count - clusters.size();
  if (starting_clusters.empty() && additional_clusters_needed > 0) {
    for (int i = 0; i < additional_clusters_needed; i++) {
      double l = rand() / (static_cast<double>(RAND_MAX)) * (100.0) + 0.0;
      double a =
          rand() / (static_cast<double>(RAND_MAX)) * (100.0 - -100.0) - 100.0;
      double b =
          rand() / (static_cast<double>(RAND_MAX)) * (100.0 - -100.0) - 100.0;
      clusters.push_back({l, a, b});
    }
  }

  std::vector<int> cluster_indices;
  cluster_indices.reserve(points.size());

  srand(42688);
  for (size_t i = 0; i < points.size(); i++) {
    cluster_indices.push_back(rand() % cluster_count);
  }

  std::vector<std::vector<int>> index_matrix(
      cluster_count, std::vector<int>(cluster_count, 0));

  std::vector<std::vector<ReferenceDistanceToIndex>> distance_to_index_matrix(
      cluster_count, std::vector<ReferenceDistanceToIndex>(cluster_count));

  for (int iteration = 0; iteration < kMaxIterations; iteration++) {
    for (int i = 0; i < cluster_count; i++) {
      distance_to_index_matrix[i][i].distance = 0;
      distance_to_index_matrix[i][i].index = i;
      for (int j = i + 1; j < cluster_count; j++) {
        double distance = clusters[i].DeltaE(clusters[j]);

        distance_to_index_matrix[j][i].distance = distance;
        distance_to_index_matrix[j][i].index = i;
        distance_to_index_matrix[i][j].distance = distance;
        distance_to_index_matrix[i][j].index = j;
      }

      std::vector<ReferenceDistanceToIndex> row = distance_to_index_matrix[i];
      std::sort(row.begin(), row.end());

      for (int j = 0; j < cluster_count; j++) {
        index_matrix[i][j] = row[j].index;
      }
    }

    bool color_moved = false;
    for (size_t i = 0; i < points.size(); i++) {
      Lab point = points[i];

      int previous_cluster_index = cluster_indices[i];
      Lab previous_cluster = clusters[previous_cluster_index];
      double previous_distance = point.DeltaE(previous_cluster);
      double minimum_distance = previous_distance;
      int new_cluster_index = -1;

      for (int j = 0; j < cluster_count; j++) {
        if (distance_to_index_matrix[previous_cluster_index][j].distance >=
            4 * previous_distance) {
          continue;
        }
        double distance = point.DeltaE(clusters[j]);
        if (distance < minimum_distance) {
          minimum_distance = distance;
          new_cluster_index = j;
        }
      }
      if (new_cluster_index != -1) {
        double distanceChange =
            abs(sqrt(minimum_distance) - sqrt(previous_distance));
        if (distanceChange > kMinDeltaE) {
          color_moved = true;
          cluster_indices[i] = new_cluster_index;
        }
      }
    }

    if (!color_moved && (iteration != 0)) {
      break;
    }

    double component_a_sums[256] = {};
    double component_b_sums[256] = {};
    double component_c_sums[256] = {};
    for (int i = 0; i < cluster_count; i++) {
      pixel_count_sums[i] = 0;
    }

    for (size_t i = 0; i < points.size(); i++) {
      int clusterIndex = cluster_indices[i];
      Lab point = points[i];
      int count = pixel_to_count[pixels[i]];

      pixel_count_sums[clusterIndex] += count;
      component_a_sums[clusterIndex] += (point.l * count);
      component_b_sums[clusterIndex] += (point.a * count);
      component_c_sums[clusterIndex] += (point.b * count);
    }

    for (int i = 0; i < cluster_count; i++) {
      int count = pixel_count_sums[i];
      if (count == 0) {
        clusters[i] = {0, 0, 0};
        continue;
      }
      double a = component_a_sums[i] / count;
      double b = component_b_sums[i] / count;
      double c = component_c_sums[i] / count;
      clusters[i] = {a, b, c};
    }
  }

  std::vector<ReferenceSwatch> swatches;
  std::vector<Argb> cluster_argbs;
  std::vector<Argb> all_cluster_argbs;
  for (int i = 0; i < cluster_count; i++) {
    Argb possible_new_cluster = IntFromLab(clusters[i]);
    all_cluster_argbs.push_back(possible_new_cluster);

    int count = pixel_count_sums[i];
    if (count == 0) {
      continue;
    }
    int use_new_cluster = 1;
    for (size_t j = 0; j < swatches.size(); j++) {
      if (swatches[j].argb == possible_new_cluster) {
        swatches[j].population += count;
        use_new_cluster = 0;
        break;
      }
    }

    if (use_new_cluster == 0) {
      continue;
    }
    cluster_argbs.push_back(possible_new_cluster);
    swatches.push_back({possible_new_cluster, count});
  }
  std::sort(swatches.begin(), swatches.end());

  std::map<Argb, uint32_t> color_to_count;
  for (size_t i = 0; i < swatches.size(); i++) {
    color_to_count[swatches[i].argb] = swatches[i].population;
  }

  std::map<Argb, Argb> input_pixel_to_cluster_pixel;
  for (size_t i = 0; i < points.size(); i++) {
    int pixel = pixels[i];
    int cluster_index = cluster_indices[i];
    int cluster_argb = all_cluster_argbs[cluster_index];
    input_pixel_to_cluster_pixel[pixel] = cluster_argb;
  }

  return {color_to_count, input_pixel_to_cluster_pixel};
}

QuantizerResult ReferenceQuantizeCelebi(const std::vector<Argb>& pixels,
                                        uint16_t max_colors) {
  if (max_colors == 0 || pixels.empty()) {
    return QuantizerResult();
  }

  if (max_colors > 256) {
    max_colors = 256;
  }

  int pixel_count = pixels.size();

  std::vector<Argb> opaque_pixels;
  opaque_pixels.reserve(pixel_count);
  for (int i = 0; i < pixel_count; i++) {
    int pixel = pixels[i];
    if (!IsOpaque(pixel)) {
      continue;
    }
    opaque_pixels.push_back(pixel);
  }

  std::vector<Argb> wu_result = QuantizeWu(opaque_pixels, max_colors);

  QuantizerResult result =
      ReferenceQuantizeWsmeans(opaque_pixels, wu_result, max_colors);

  return result;
}

// ---------------------------------------------------------------------------
// Test inputs and checks.
// ---------------------------------------------------------------------------

constexpr uint16_t kMaxColors[] = {0, 1, 2, 3, 16, 128, 255, 256, 257, 65535};

void ExpectSameResult(const QuantizerResult& expected,
                      const QuantizerResult& actual) {
  EXPECT_EQ(actual.color_to_count, expected.color_to_count);
  EXPECT_EQ(actual.input_pixel_to_cluster_pixel,
            expected.input_pixel_to_cluster_pixel);
}

void ExpectSameCelebi(const std::vector<Argb>& pixels) {
  for (uint16_t max_colors : kMaxColors) {
    SCOPED_TRACE(testing::Message() << "max_colors=" << max_colors);
    ExpectSameResult(ReferenceQuantizeCelebi(pixels, max_colors),
                     QuantizeCelebi(pixels, max_colors));
  }
}

void ExpectSameWsmeans(const std::vector<Argb>& pixels,
                       const std::vector<Argb>& starting_clusters) {
  for (uint16_t max_colors : kMaxColors) {
    SCOPED_TRACE(testing::Message() << "max_colors=" << max_colors);
    ExpectSameResult(
        ReferenceQuantizeWsmeans(pixels, starting_clusters, max_colors),
        QuantizeWsmeans(pixels, starting_clusters, max_colors));
  }
}

enum class ImageKind {
  kRandom,         // Any ARGB value, so mostly distinct colors.
  kPalette,        // A few hundred colors, each used many times.
  kNoisyPalette,   // Palette colors with low-bit noise.
  kGradient,       // Smooth ramps, as in photos of skies.
  kBlackAndWhite,  // Two colors that are far apart.
  kAlphaVariants,  // One RGB color with different alpha values.
};

constexpr ImageKind kImageKinds[] = {
    ImageKind::kRandom,   ImageKind::kPalette,       ImageKind::kNoisyPalette,
    ImageKind::kGradient, ImageKind::kBlackAndWhite, ImageKind::kAlphaVariants,
};

std::vector<Argb> MakeImage(ImageKind kind, int size, std::mt19937& random) {
  std::vector<Argb> palette(1 + random() % 300);
  for (Argb& color : palette) {
    color = random();
  }
  std::vector<Argb> pixels(size);
  for (int i = 0; i < size; i++) {
    switch (kind) {
      case ImageKind::kRandom:
        pixels[i] = random();
        break;
      case ImageKind::kPalette:
        pixels[i] = palette[random() % palette.size()];
        break;
      case ImageKind::kNoisyPalette:
        pixels[i] = palette[random() % palette.size()] ^ (random() & 0x070707);
        break;
      case ImageKind::kGradient:
        pixels[i] = 0xff000000 | ((i * 7) & 0xff) << 16 |
                    ((i / 3) & 0xff) << 8 | (i & 0xff);
        break;
      case ImageKind::kBlackAndWhite:
        pixels[i] = random() % 2 == 0 ? 0xff000000 : 0xffffffff;
        break;
      case ImageKind::kAlphaVariants:
        pixels[i] = (palette[0] & 0x00ffffff) | (random() % 4) << 30;
        break;
    }
  }
  return pixels;
}

TEST(QuantizeEquivalenceTest, LinearizedTableMatchesEveryRgbColor) {
  // LabFromInt linearizes each channel with a table. Every RGB color must give
  // bit-identical Lab values. Alpha is ignored by both.
  for (uint32_t rgb = 0; rgb < (1u << 24); rgb++) {
    Argb argb = 0xff000000 | rgb;
    Lab expected = ReferenceLabFromInt(argb);
    Lab actual = LabFromInt(argb);
    if (std::memcmp(&expected.l, &actual.l, sizeof(double)) != 0 ||
        std::memcmp(&expected.a, &actual.a, sizeof(double)) != 0 ||
        std::memcmp(&expected.b, &actual.b, sizeof(double)) != 0) {
      FAIL() << "LabFromInt differs for " << HexFromArgb(argb);
    }
  }
}

TEST(QuantizeEquivalenceTest, CelebiRandomImages) {
  std::mt19937 random(0x42688);
  for (ImageKind kind : kImageKinds) {
    for (int size : {1, 2, 3, 100, 1000, 128 * 128}) {
      SCOPED_TRACE(testing::Message()
                   << "kind=" << static_cast<int>(kind) << " size=" << size);
      ExpectSameCelebi(MakeImage(kind, size, random));
    }
  }
}

TEST(QuantizeEquivalenceTest, CelebiEmptyImage) { ExpectSameCelebi({}); }

TEST(QuantizeEquivalenceTest, WsmeansStartingClusters) {
  std::mt19937 random(12345);
  std::vector<Argb> pixels =
      MakeImage(ImageKind::kNoisyPalette, 64 * 64, random);
  std::vector<Argb> random_clusters(300);
  for (Argb& color : random_clusters) {
    color = random();
  }
  std::vector<Argb> duplicate_clusters = {0xff0000ff, 0xff00ff00, 0xff0000ff,
                                          0xffff0000, 0xff00ff00, 0xff0000ff};
  // Wu colors are the usual starting clusters.
  std::vector<Argb> wu_clusters = QuantizeWu(pixels, 128);
  // More starting clusters than distinct colors.
  std::vector<Argb> few_pixels = {0xff112233, 0xff445566, 0xff112233};

  ExpectSameWsmeans(pixels, {});
  ExpectSameWsmeans(pixels, {pixels[0]});
  ExpectSameWsmeans(pixels, random_clusters);
  ExpectSameWsmeans(pixels, duplicate_clusters);
  ExpectSameWsmeans(pixels, wu_clusters);
  ExpectSameWsmeans(few_pixels, random_clusters);
  ExpectSameWsmeans({}, random_clusters);
}

}  // namespace
}  // namespace material_color_utilities
