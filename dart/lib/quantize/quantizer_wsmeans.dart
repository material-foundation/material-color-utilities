// Copyright 2021 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'dart:math' as math show Random, min;
import 'dart:typed_data';

import '../utils/color_utils.dart';

import 'quantizer.dart';
import 'src/point_provider.dart';
import 'src/lab_lut.dart';
import 'src/pixel_counts.dart';
import 'src/point_provider_lab.dart';

class DistanceAndIndex implements Comparable<DistanceAndIndex> {
  double distance;
  int index;

  DistanceAndIndex(this.distance, this.index);

  @override
  int compareTo(DistanceAndIndex other) {
    if (distance < other.distance) {
      return -1;
    } else if (distance > other.distance) {
      return 1;
    } else {
      return 0;
    }
  }
}

class QuantizerWsmeans {
  static const debug = false;

  static void debugLog(String log) {
    if (debug) {
      print(log);
    }
  }

  static QuantizerResult quantize(
    Iterable<int> inputPixels,
    int maxColors, {
    List<int> startingClusters = const [],
    PointProvider pointProvider = const PointProviderLab(),
    int maxIterations = 5,
    bool returnInputPixelToClusterPixel = false,
  }) {
    // The common case, k-means in L*a*b*, runs on flat typed arrays. It gives
    // exactly the same result as the general code below.
    if (identical(pointProvider, const PointProviderLab()) && maxColors > 0) {
      final pixels =
          inputPixels is List<int> ? inputPixels : inputPixels.toList();
      final pixelCounts = PixelCounts.tryCount(pixels);
      if (pixelCounts != null) {
        return _quantizeLab(
          pixelCounts,
          maxColors,
          startingClusters,
          maxIterations,
          returnInputPixelToClusterPixel,
        );
      }
      inputPixels = pixels;
    }

    final pixelToCount = <int, int>{};
    final points = <List<double>>[];
    final pixels = <int>[];
    var pointCount = 0;
    for (var inputPixel in inputPixels) {
      final pixelCount = pixelToCount.update(
        inputPixel,
        (value) => value + 1,
        ifAbsent: () => 1,
      );
      if (pixelCount == 1) {
        pointCount++;
        points.add(pointProvider.fromInt(inputPixel));
        pixels.add(inputPixel);
      }
    }

    final counts = List<int>.filled(pointCount, 0);
    for (var i = 0; i < pointCount; i++) {
      final pixel = pixels[i];
      final count = pixelToCount[pixel]!;
      counts[i] = count;
    }

    var clusterCount = math.min(maxColors, pointCount);

    final clusters =
        startingClusters.map((e) => pointProvider.fromInt(e)).toList();
    final additionalClustersNeeded = clusterCount - clusters.length;
    if (additionalClustersNeeded > 0) {
      final random = math.Random(0x42688);
      final indices = <int>[];
      for (var i = 0; i < additionalClustersNeeded; i++) {
        // Use existing points rather than generating random centroids.
        //
        // KMeans is extremely sensitive to initial clusters. This quantizer
        // is meant to be used with a Wu quantizer that provides initial
        // centroids, but Wu is very slow on unscaled images and when extracting
        // more than 256 colors.
        //
        // Here, we can safely assume that more than 256 colors were requested
        // for extraction. Generating random centroids tends to lead to many
        // "empty" centroids, as the random centroids are nowhere near any pixels
        // in the image, and the centroids from Wu are very refined and close
        // to pixels in the image.
        //
        // Rather than generate random centroids, we'll pick centroids that
        // are actual pixels in the image, and avoid duplicating centroids.

        var index = random.nextInt(points.length);
        while (indices.contains(index)) {
          index = random.nextInt(points.length);
        }
        indices.add(index);
      }

      for (var index in indices) {
        clusters.add(points[index]);
      }
    }
    debugLog(
      'have ${clusters.length} starting clusters, ${points.length} points',
    );
    final clusterIndices = List<int>.generate(
      pointCount,
      (index) => index % clusterCount,
    );
    final indexMatrix = List<List<int>>.generate(
      clusterCount,
      (_) => List.filled(clusterCount, 0),
    );

    final distanceToIndexMatrix = List<List<DistanceAndIndex>>.generate(
      clusterCount,
      (index) => List<DistanceAndIndex>.generate(
        clusterCount,
        (index) => DistanceAndIndex(0, index),
      ),
    );

    final pixelCountSums = List<int>.filled(clusterCount, 0);
    for (var iteration = 0; iteration < maxIterations; iteration++) {
      if (debug) {
        for (var i = 0; i < clusterCount; i++) {
          pixelCountSums[i] = 0;
        }
        for (var i = 0; i < pointCount; i++) {
          final clusterIndex = clusterIndices[i];
          final count = counts[i];
          pixelCountSums[clusterIndex] += count;
        }
        var emptyClusters = 0;
        for (var cluster = 0; cluster < clusterCount; cluster++) {
          if (pixelCountSums[cluster] == 0) {
            emptyClusters++;
          }
        }
        debugLog(
          'starting iteration ${iteration + 1}; $emptyClusters clusters are empty of $clusterCount',
        );
      }

      var pointsMoved = 0;
      for (var i = 0; i < clusterCount; i++) {
        for (var j = i + 1; j < clusterCount; j++) {
          final distance = pointProvider.distance(clusters[i], clusters[j]);
          distanceToIndexMatrix[j][i].distance = distance;
          distanceToIndexMatrix[j][i].index = i;
          distanceToIndexMatrix[i][j].distance = distance;
          distanceToIndexMatrix[i][j].index = j;
        }
        distanceToIndexMatrix[i].sort();
        for (var j = 0; j < clusterCount; j++) {
          indexMatrix[i][j] = distanceToIndexMatrix[i][j].index;
        }
      }

      for (var i = 0; i < pointCount; i++) {
        final point = points[i];
        final previousClusterIndex = clusterIndices[i];
        final previousCluster = clusters[previousClusterIndex];
        final previousDistance = pointProvider.distance(point, previousCluster);
        var minimumDistance = previousDistance;
        var newClusterIndex = -1;
        for (var j = 0; j < clusterCount; j++) {
          if (distanceToIndexMatrix[previousClusterIndex][j].distance >=
              4 * previousDistance) {
            continue;
          }
          final distance = pointProvider.distance(point, clusters[j]);
          if (distance < minimumDistance) {
            minimumDistance = distance;
            newClusterIndex = j;
          }
        }
        if (newClusterIndex != -1) {
          pointsMoved++;
          clusterIndices[i] = newClusterIndex;
        }
      }

      if (pointsMoved == 0 && iteration > 0) {
        debugLog('terminated after $iteration k-means iterations');
        break;
      }

      debugLog('iteration ${iteration + 1} moved $pointsMoved');
      final componentASums = List<double>.filled(clusterCount, 0);
      final componentBSums = List<double>.filled(clusterCount, 0);
      final componentCSums = List<double>.filled(clusterCount, 0);

      for (var i = 0; i < clusterCount; i++) {
        pixelCountSums[i] = 0;
      }
      for (var i = 0; i < pointCount; i++) {
        final clusterIndex = clusterIndices[i];
        final point = points[i];
        final count = counts[i];
        pixelCountSums[clusterIndex] += count;
        componentASums[clusterIndex] += point[0] * count;
        componentBSums[clusterIndex] += point[1] * count;
        componentCSums[clusterIndex] += point[2] * count;
      }
      for (var i = 0; i < clusterCount; i++) {
        final count = pixelCountSums[i];
        if (count == 0) {
          clusters[i] = [0.0, 0.0, 0.0];
          continue;
        }
        final a = componentASums[i] / count;
        final b = componentBSums[i] / count;
        final c = componentCSums[i] / count;
        clusters[i] = [a, b, c];
      }
    }

    final clusterArgbs = <int>[];
    final clusterPopulations = <int>[];
    for (var i = 0; i < clusterCount; i++) {
      final count = pixelCountSums[i];
      if (count == 0) {
        continue;
      }

      final possibleNewCluster = pointProvider.toInt(clusters[i]);
      if (clusterArgbs.contains(possibleNewCluster)) {
        continue;
      }

      clusterArgbs.add(possibleNewCluster);
      clusterPopulations.add(count);
    }
    debugLog(
      'kmeans finished and generated ${clusterArgbs.length} clusters; $clusterCount were requested',
    );

    final inputPixelToClusterPixel = <int, int>{};
    if (returnInputPixelToClusterPixel) {
      final stopwatch = Stopwatch()..start();
      for (var i = 0; i < pixels.length; i++) {
        final inputPixel = pixels[i];
        final clusterIndex = clusterIndices[i];
        final cluster = clusters[clusterIndex];
        final clusterPixel = pointProvider.toInt(cluster);
        inputPixelToClusterPixel[inputPixel] = clusterPixel;
      }
      debugLog(
        'took ${stopwatch.elapsedMilliseconds} ms to create input to cluster map',
      );
    }

    return QuantizerResult(
      Map.fromIterables(clusterArgbs, clusterPopulations),
      inputPixelToClusterPixel: inputPixelToClusterPixel,
    );
  }
  /// The same algorithm as [quantize], for [PointProviderLab] and a positive
  /// [maxColors], with the points, clusters and distances in flat typed
  /// arrays.
  ///
  /// Every value is computed with the same operations in the same order as in
  /// [quantize], and the same random numbers are drawn, so the result is the
  /// same. The sorted distance rows hold only distances: [quantize] never
  /// reads the cluster index that it sorts along with them, and equal
  /// distances cannot be told apart, so any sort gives the same rows.
  static QuantizerResult _quantizeLab(
    PixelCounts pixelCounts,
    int maxColors,
    List<int> startingClusters,
    int maxIterations,
    bool returnInputPixelToClusterPixel,
  ) {
    final pointCount = pixelCounts.size;
    final pixels = pixelCounts.colors;
    final counts = pixelCounts.counts;
    final points = Float64List(pointCount * 3);
    for (var i = 0; i < pointCount; i++) {
      labFromArgbInto(pixels[i], points, i * 3);
    }

    final clusterCount = math.min(maxColors, pointCount);
    final clusters = Float64List(clusterCount * 3);
    final startingClusterCount = math.min(
      clusterCount,
      startingClusters.length,
    );
    for (var i = 0; i < startingClusterCount; i++) {
      labFromArgbInto(startingClusters[i], clusters, i * 3);
    }
    final additionalClustersNeeded = clusterCount - startingClusters.length;
    if (additionalClustersNeeded > 0) {
      // The same random points as in [quantize].
      final random = math.Random(0x42688);
      final indices = <int>[];
      for (var i = 0; i < additionalClustersNeeded; i++) {
        var index = random.nextInt(pointCount);
        while (indices.contains(index)) {
          index = random.nextInt(pointCount);
        }
        indices.add(index);
      }
      for (var i = 0; i < additionalClustersNeeded; i++) {
        final cluster = (startingClusterCount + i) * 3;
        final point = indices[i] * 3;
        clusters[cluster] = points[point];
        clusters[cluster + 1] = points[point + 1];
        clusters[cluster + 2] = points[point + 2];
      }
    }
    final clusterIndices = Int32List(pointCount);
    for (var i = 0; i < pointCount; i++) {
      clusterIndices[i] = i % clusterCount;
    }

    // Row i holds the distances from cluster i to all clusters, sorted. As in
    // [quantize], each distance is written to the position of the other
    // cluster, so the position of cluster i keeps whatever value was sorted
    // there before (0 at first).
    final distances = List<Float64List>.generate(
      clusterCount,
      (_) => Float64List(clusterCount),
    );
    final pixelCountSums = Int32List(clusterCount);
    final componentASums = Float64List(clusterCount);
    final componentBSums = Float64List(clusterCount);
    final componentCSums = Float64List(clusterCount);
    for (var iteration = 0; iteration < maxIterations; iteration++) {
      for (var i = 0; i < clusterCount; i++) {
        final row = distances[i];
        final l = clusters[i * 3];
        final a = clusters[i * 3 + 1];
        final b = clusters[i * 3 + 2];
        for (var j = i + 1; j < clusterCount; j++) {
          final dL = l - clusters[j * 3];
          final dA = a - clusters[j * 3 + 1];
          final dB = b - clusters[j * 3 + 2];
          final distance = dL * dL + dA * dA + dB * dB;
          distances[j][i] = distance;
          row[j] = distance;
        }
        _sortDistances(row, 0, clusterCount - 1);
      }

      var pointsMoved = 0;
      for (var i = 0; i < pointCount; i++) {
        final l = points[i * 3];
        final a = points[i * 3 + 1];
        final b = points[i * 3 + 2];
        final previousClusterIndex = clusterIndices[i];
        final previousL = l - clusters[previousClusterIndex * 3];
        final previousA = a - clusters[previousClusterIndex * 3 + 1];
        final previousB = b - clusters[previousClusterIndex * 3 + 2];
        final previousDistance = previousL * previousL +
            previousA * previousA +
            previousB * previousB;
        var minimumDistance = previousDistance;
        var newClusterIndex = -1;
        final sortedDistances = distances[previousClusterIndex];
        final maximumDistance = 4 * previousDistance;
        for (var j = 0; j < clusterCount; j++) {
          // Rows are not written after they are sorted, so all the remaining
          // distances are too large as well: [quantize] skips them one by
          // one.
          if (sortedDistances[j] >= maximumDistance) {
            break;
          }
          final dL = l - clusters[j * 3];
          final dA = a - clusters[j * 3 + 1];
          final dB = b - clusters[j * 3 + 2];
          final distance = dL * dL + dA * dA + dB * dB;
          if (distance < minimumDistance) {
            minimumDistance = distance;
            newClusterIndex = j;
          }
        }
        if (newClusterIndex != -1) {
          pointsMoved++;
          clusterIndices[i] = newClusterIndex;
        }
      }

      if (pointsMoved == 0 && iteration > 0) {
        break;
      }

      componentASums.fillRange(0, clusterCount, 0.0);
      componentBSums.fillRange(0, clusterCount, 0.0);
      componentCSums.fillRange(0, clusterCount, 0.0);
      pixelCountSums.fillRange(0, clusterCount, 0);
      for (var i = 0; i < pointCount; i++) {
        final clusterIndex = clusterIndices[i];
        final count = counts[i];
        pixelCountSums[clusterIndex] += count;
        componentASums[clusterIndex] += points[i * 3] * count;
        componentBSums[clusterIndex] += points[i * 3 + 1] * count;
        componentCSums[clusterIndex] += points[i * 3 + 2] * count;
      }
      for (var i = 0; i < clusterCount; i++) {
        final count = pixelCountSums[i];
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

    final clusterArgbs = <int>[];
    final clusterPopulations = <int>[];
    for (var i = 0; i < clusterCount; i++) {
      final count = pixelCountSums[i];
      if (count == 0) {
        continue;
      }
      final possibleNewCluster = ColorUtils.argbFromLab(
        clusters[i * 3],
        clusters[i * 3 + 1],
        clusters[i * 3 + 2],
      );
      if (clusterArgbs.contains(possibleNewCluster)) {
        continue;
      }
      clusterArgbs.add(possibleNewCluster);
      clusterPopulations.add(count);
    }

    final inputPixelToClusterPixel = <int, int>{};
    if (returnInputPixelToClusterPixel) {
      for (var i = 0; i < pointCount; i++) {
        final clusterIndex = clusterIndices[i];
        inputPixelToClusterPixel[pixels[i]] = ColorUtils.argbFromLab(
          clusters[clusterIndex * 3],
          clusters[clusterIndex * 3 + 1],
          clusters[clusterIndex * 3 + 2],
        );
      }
    }

    return QuantizerResult(
      Map.fromIterables(clusterArgbs, clusterPopulations),
      inputPixelToClusterPixel: inputPixelToClusterPixel,
    );
  }
}

/// Sorts [list] in the range [lo, hi] in ascending order.
///
/// The values are finite distances, so the order is the same as with
/// `double.compareTo`, without the cost of calling a comparator.
void _sortDistances(Float64List list, int lo, int hi) {
  while (hi - lo > 16) {
    final x = list[lo];
    final y = list[lo + ((hi - lo) >> 1)];
    final z = list[hi];
    final double pivot;
    if (x < y) {
      pivot = y < z ? y : (x < z ? z : x);
    } else {
      pivot = x < z ? x : (y < z ? z : y);
    }
    var i = lo;
    var j = hi;
    while (i <= j) {
      while (list[i] < pivot) {
        i++;
      }
      while (list[j] > pivot) {
        j--;
      }
      if (i <= j) {
        final temp = list[i];
        list[i] = list[j];
        list[j] = temp;
        i++;
        j--;
      }
    }
    // Recurses into the smaller part, so the stack stays shallow.
    if (j - lo < hi - i) {
      _sortDistances(list, lo, j);
      lo = i;
    } else {
      _sortDistances(list, i, hi);
      hi = j;
    }
  }
  for (var i = lo + 1; i <= hi; i++) {
    final value = list[i];
    var j = i - 1;
    while (j >= lo && list[j] > value) {
      list[j + 1] = list[j];
      j--;
    }
    list[j + 1] = value;
  }
}
