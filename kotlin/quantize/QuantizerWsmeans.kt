/*
 * Copyright 2025 Google LLC
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
package quantize

import utils.ColorUtils
import java.util.LinkedHashMap
import java.util.Random
import kotlin.math.abs
import kotlin.math.min
import kotlin.math.sqrt

/**
 * An image quantizer that improves on the speed of a standard K-Means algorithm by implementing
 * several optimizations, including deduping identical pixels and a triangle inequality rule that
 * reduces the number of comparisons needed to identify which cluster a point should be moved to.
 *
 * Wsmeans stands for Weighted Square Means.
 *
 * This algorithm was designed by M. Emre Celebi, and was found in their 2011 paper, Improving the
 * Performance of K-Means for Color Quantization. https://arxiv.org/abs/1101.0395
 */
object QuantizerWsmeans {
  private const val MAX_ITERATIONS = 10
  private const val MIN_MOVEMENT_DISTANCE = 3.0

  /**
   * Reduce the number of colors needed to represented the input, minimizing the difference between
   * the original image and the recolored image.
   *
   * @param inputPixels Colors in ARGB format.
   * @param startingClusters Defines the initial state of the quantizer: the colors that the
   *   clusters start from. Passing an array that is the result of Wu quantization leads to higher
   *   quality results. It must not be empty unless [inputPixels] is, and must not hold more colors
   *   than [maxColors] or than [inputPixels] has distinct colors.
   * @param maxColors The number of colors to divide the image into. A lower number of colors may be
   *   returned. It must be positive, or 0 if [inputPixels] is empty.
   * @return Map with keys of colors in ARGB format, values of how many of the input pixels belong
   *   to the color.
   */
  fun quantize(inputPixels: IntArray, startingClusters: IntArray, maxColors: Int): Map<Int, Int> {
    // Uses a seeded random number generator to ensure consistent results.
    val random = Random(0x42688L)
    // The distinct pixels, in order of first appearance, as points in L*a*b*: three coordinates
    // each, in a flat array.
    val pixelCounts = PixelCounts(inputPixels)
    val pointCount = pixelCounts.size
    val counts = pixelCounts.counts
    val points = DoubleArray(pointCount * 3)
    for (i in 0 until pointCount) {
      PointProviderLab.labFromArgb(pixelCounts.colors[i], points, i * 3)
    }
    var clusterCount = min(maxColors, pointCount)
    if (startingClusters.isNotEmpty()) {
      clusterCount = min(clusterCount, startingClusters.size)
    }
    if (clusterCount < 0) {
      // Throw the NegativeArraySizeException that a negative maxColors has always thrown, before
      // clusterCount * 3 can overflow.
      throw NegativeArraySizeException("maxColors is negative: $maxColors")
    }
    val clusters = DoubleArray(clusterCount * 3)
    for (i in startingClusters.indices) {
      PointProviderLab.labFromArgb(startingClusters[i], clusters, i * 3)
    }
    val clusterIndices = IntArray(pointCount) { random.nextInt(clusterCount) }
    if (startingClusters.isEmpty() && clusterCount > 0) {
      // Without starting clusters, the clusters have no coordinates to start from. Throw the
      // NullPointerException that this case has always thrown.
      throw NullPointerException("QuantizerWsmeans needs starting clusters")
    }
    // Row i holds the distances from cluster i to the other clusters, sorted ascending. Each row is
    // updated in place, by position, and sorted again; its entry at index i is never updated, and
    // keeps whatever the previous sort left there. The scan below pairs the j-th smallest distance
    // with cluster j. Both quirks shape the results, so they are kept.
    val distanceMatrix = Array(clusterCount) { DoubleArray(clusterCount) { -1.0 } }
    val pixelCountSums = IntArray(clusterCount)
    val componentASums = DoubleArray(clusterCount)
    val componentBSums = DoubleArray(clusterCount)
    val componentCSums = DoubleArray(clusterCount)
    for (iteration in 0 until MAX_ITERATIONS) {
      for (i in 0 until clusterCount) {
        val row = distanceMatrix[i]
        val iL = clusters[i * 3]
        val iA = clusters[i * 3 + 1]
        val iB = clusters[i * 3 + 2]
        for (j in i + 1 until clusterCount) {
          val dL = iL - clusters[j * 3]
          val dA = iA - clusters[j * 3 + 1]
          val dB = iB - clusters[j * 3 + 2]
          val distance = dL * dL + dA * dA + dB * dB
          distanceMatrix[j][i] = distance
          row[j] = distance
        }
        row.sort()
      }
      var pointsMoved = 0
      for (i in 0 until pointCount) {
        val pointL = points[i * 3]
        val pointA = points[i * 3 + 1]
        val pointB = points[i * 3 + 2]
        val previousClusterIndex = clusterIndices[i]
        val previousL = pointL - clusters[previousClusterIndex * 3]
        val previousA = pointA - clusters[previousClusterIndex * 3 + 1]
        val previousB = pointB - clusters[previousClusterIndex * 3 + 2]
        val previousDistance = previousL * previousL + previousA * previousA + previousB * previousB
        var minimumDistance = previousDistance
        var newClusterIndex = -1
        val sortedDistances = distanceMatrix[previousClusterIndex]
        val maximumDistance = 4 * previousDistance
        for (j in 0 until clusterCount) {
          // The distances are sorted, so once one reaches the maximum, all the following ones do.
          if (sortedDistances[j] >= maximumDistance) {
            break
          }
          val dL = pointL - clusters[j * 3]
          val dA = pointA - clusters[j * 3 + 1]
          val dB = pointB - clusters[j * 3 + 2]
          val distance = dL * dL + dA * dA + dB * dB
          if (distance < minimumDistance) {
            minimumDistance = distance
            newClusterIndex = j
          }
        }
        if (newClusterIndex != -1) {
          val distanceChange = abs(sqrt(minimumDistance) - sqrt(previousDistance))
          if (distanceChange > MIN_MOVEMENT_DISTANCE) {
            pointsMoved++
            clusterIndices[i] = newClusterIndex
          }
        }
      }
      if (pointsMoved == 0 && iteration != 0) {
        break
      }
      componentASums.fill(0.0)
      componentBSums.fill(0.0)
      componentCSums.fill(0.0)
      pixelCountSums.fill(0)
      for (i in 0 until pointCount) {
        val clusterIndex = clusterIndices[i]
        val count = counts[i]
        pixelCountSums[clusterIndex] += count
        componentASums[clusterIndex] += points[i * 3] * count
        componentBSums[clusterIndex] += points[i * 3 + 1] * count
        componentCSums[clusterIndex] += points[i * 3 + 2] * count
      }
      for (i in 0 until clusterCount) {
        val count = pixelCountSums[i]
        if (count == 0) {
          clusters[i * 3] = 0.0
          clusters[i * 3 + 1] = 0.0
          clusters[i * 3 + 2] = 0.0
          continue
        }
        clusters[i * 3] = componentASums[i] / count
        clusters[i * 3 + 1] = componentBSums[i] / count
        clusters[i * 3 + 2] = componentCSums[i] / count
      }
    }
    val argbToPopulation: MutableMap<Int, Int> = LinkedHashMap()
    for (i in 0 until clusterCount) {
      val count = pixelCountSums[i]
      if (count == 0) {
        continue
      }
      val possibleNewCluster =
        ColorUtils.argbFromLab(clusters[i * 3], clusters[i * 3 + 1], clusters[i * 3 + 2])
      if (argbToPopulation.containsKey(possibleNewCluster)) {
        continue
      }
      argbToPopulation[possibleNewCluster] = count
    }
    return argbToPopulation
  }
}
