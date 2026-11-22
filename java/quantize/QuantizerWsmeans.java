/*
 * Copyright 2021 Google LLC
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

package quantize;

import static java.lang.Math.min;

import utils.ColorUtils;
import java.util.Arrays;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.Random;

/**
 * An image quantizer that improves on the speed of a standard K-Means algorithm by implementing
 * several optimizations, including deduping identical pixels and a triangle inequality rule that
 * reduces the number of comparisons needed to identify which cluster a point should be moved to.
 *
 * <p>Wsmeans stands for Weighted Square Means.
 *
 * <p>This algorithm was designed by M. Emre Celebi, and was found in their 2011 paper, Improving
 * the Performance of K-Means for Color Quantization. https://arxiv.org/abs/1101.0395
 */
public final class QuantizerWsmeans {
  private QuantizerWsmeans() {}

  private static final int MAX_ITERATIONS = 10;
  private static final double MIN_MOVEMENT_DISTANCE = 3.0;

  /**
   * Reduce the number of colors needed to represented the input, minimizing the difference between
   * the original image and the recolored image.
   *
   * @param inputPixels Colors in ARGB format.
   * @param startingClusters Defines the initial state of the quantizer, in ARGB format. Must not be
   *     empty for a non-empty image, and must not have more colors than maxColors or than the image
   *     has distinct colors. Passing the result of Wu quantization leads to high quality results.
   * @param maxColors The number of colors to divide the image into. Must be positive for a
   *     non-empty image. A lower number of colors may be returned.
   * @return Map with keys of colors in ARGB format, values of how many of the input pixels belong
   *     to the color.
   */
  public static Map<Integer, Integer> quantize(
      int[] inputPixels, int[] startingClusters, int maxColors) {
    // Uses a seeded random number generator to ensure consistent results.
    Random random = new Random(0x42688);

    // The distinct colors, in the order in which they first appear, as L*a*b* points: the L*, a*
    // and b* of point i are at indices 3 * i, 3 * i + 1 and 3 * i + 2. The clusters are stored the
    // same way.
    PixelCounts pixelCounts = new PixelCounts(inputPixels);
    int pointCount = pixelCounts.size();
    int[] pixels = pixelCounts.colors();
    int[] counts = pixelCounts.counts();
    double[] points = new double[pointCount * 3];
    for (int i = 0; i < pointCount; i++) {
      PointProviderLab.labFromArgb(pixels[i], points, i * 3);
    }

    int clusterCount = min(maxColors, pointCount);
    if (startingClusters.length != 0) {
      clusterCount = min(clusterCount, startingClusters.length);
    }

    // Throws NegativeArraySizeException for a negative cluster count before clusterCount * 3 can
    // overflow.
    int[] pixelCountSums = new int[clusterCount];
    double[] clusters = new double[clusterCount * 3];
    // Throws ArrayIndexOutOfBoundsException for more starting clusters than clusters.
    for (int i = 0; i < startingClusters.length; i++) {
      PointProviderLab.labFromArgb(startingClusters[i], clusters, i * 3);
    }
    if (startingClusters.length == 0 && clusterCount > 0) {
      // Without starting clusters, the clusters have no coordinates to start from. Throw the
      // NullPointerException that this case has always thrown.
      throw new NullPointerException("QuantizerWsmeans needs starting clusters");
    }

    int[] clusterIndices = new int[pointCount];
    for (int i = 0; i < pointCount; i++) {
      clusterIndices[i] = random.nextInt(clusterCount);
    }

    // Row i holds the distances from cluster i to the other clusters, sorted ascending. Each row is
    // updated in place, by position, and sorted again; its entry at index i is never updated, and
    // keeps whatever the previous sort left there. The scan below pairs the j-th smallest distance
    // with cluster j. Both quirks shape the results, so they are kept.
    double[][] distanceMatrix = new double[clusterCount][clusterCount];
    for (double[] row : distanceMatrix) {
      Arrays.fill(row, -1.0);
    }

    double[] componentASums = new double[clusterCount];
    double[] componentBSums = new double[clusterCount];
    double[] componentCSums = new double[clusterCount];
    for (int iteration = 0; iteration < MAX_ITERATIONS; iteration++) {
      for (int i = 0; i < clusterCount; i++) {
        double[] row = distanceMatrix[i];
        double iL = clusters[i * 3];
        double iA = clusters[i * 3 + 1];
        double iB = clusters[i * 3 + 2];
        for (int j = i + 1; j < clusterCount; j++) {
          double dL = iL - clusters[j * 3];
          double dA = iA - clusters[j * 3 + 1];
          double dB = iB - clusters[j * 3 + 2];
          double distance = dL * dL + dA * dA + dB * dB;
          distanceMatrix[j][i] = distance;
          row[j] = distance;
        }
        Arrays.sort(row);
      }

      int pointsMoved = 0;
      for (int i = 0; i < pointCount; i++) {
        double pointL = points[i * 3];
        double pointA = points[i * 3 + 1];
        double pointB = points[i * 3 + 2];
        int previousClusterIndex = clusterIndices[i];
        double previousL = pointL - clusters[previousClusterIndex * 3];
        double previousA = pointA - clusters[previousClusterIndex * 3 + 1];
        double previousB = pointB - clusters[previousClusterIndex * 3 + 2];
        double previousDistance =
            previousL * previousL + previousA * previousA + previousB * previousB;

        double minimumDistance = previousDistance;
        int newClusterIndex = -1;
        double[] sortedDistances = distanceMatrix[previousClusterIndex];
        double maximumDistance = 4 * previousDistance;
        for (int j = 0; j < clusterCount; j++) {
          // The distances are sorted, so once one reaches the maximum, all the following ones do.
          if (sortedDistances[j] >= maximumDistance) {
            break;
          }
          double dL = pointL - clusters[j * 3];
          double dA = pointA - clusters[j * 3 + 1];
          double dB = pointB - clusters[j * 3 + 2];
          double distance = dL * dL + dA * dA + dB * dB;
          if (distance < minimumDistance) {
            minimumDistance = distance;
            newClusterIndex = j;
          }
        }
        if (newClusterIndex != -1) {
          double distanceChange =
              Math.abs(Math.sqrt(minimumDistance) - Math.sqrt(previousDistance));
          if (distanceChange > MIN_MOVEMENT_DISTANCE) {
            pointsMoved++;
            clusterIndices[i] = newClusterIndex;
          }
        }
      }

      if (pointsMoved == 0 && iteration != 0) {
        break;
      }

      Arrays.fill(componentASums, 0.0);
      Arrays.fill(componentBSums, 0.0);
      Arrays.fill(componentCSums, 0.0);
      Arrays.fill(pixelCountSums, 0);
      for (int i = 0; i < pointCount; i++) {
        int clusterIndex = clusterIndices[i];
        int count = counts[i];
        pixelCountSums[clusterIndex] += count;
        componentASums[clusterIndex] += (points[i * 3] * count);
        componentBSums[clusterIndex] += (points[i * 3 + 1] * count);
        componentCSums[clusterIndex] += (points[i * 3 + 2] * count);
      }

      for (int i = 0; i < clusterCount; i++) {
        int count = pixelCountSums[i];
        if (count == 0) {
          clusters[i * 3] = 0.0;
          clusters[i * 3 + 1] = 0.0;
          clusters[i * 3 + 2] = 0.0;
          continue;
        }
        clusters[i * 3] = componentASums[i] / count;
        clusters[i * 3 + 1] = componentBSums[i] / count;
        clusters[i * 3 + 2] = componentCSums[i] / count;
      }
    }

    Map<Integer, Integer> argbToPopulation = new LinkedHashMap<>();
    for (int i = 0; i < clusterCount; i++) {
      int count = pixelCountSums[i];
      if (count == 0) {
        continue;
      }

      int possibleNewCluster =
          ColorUtils.argbFromLab(clusters[i * 3], clusters[i * 3 + 1], clusters[i * 3 + 2]);
      if (argbToPopulation.containsKey(possibleNewCluster)) {
        continue;
      }

      argbToPopulation.put(possibleNewCluster, count);
    }

    return argbToPopulation;
  }
}
