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

import 'dart:math' as math show Random, min, sqrt;

import 'point_provider.dart';
import 'point_provider_lab.dart';
import 'quantizer.dart';

class DistanceAndIndex implements Comparable<DistanceAndIndex> {
  double distance;
  int index;

  DistanceAndIndex(this.distance, this.index);

  @override
  int compareTo(DistanceAndIndex other) {
    if (distance < other.distance) {
      return 1;
    } else if (distance > other.distance) {
      return -1;
    } else {
      return 0;
    }
  }
}

class QuantizerWsmeans {
  static const maxIterations = 10;
  static const minMovementDistance = 3.0;

  static QuantizerResult quantize(
    Iterable<int> inputPixels,
    int maxColors, {
    List<int> startingClusters = const [],
    PointProvider pointProvider = const PointProviderLab(),
  }) {
    final pixelToCount = <int, int>{};
    final points = <List<double>>[];
    final pixels = <int>[];
    var pointCount = 0;
    inputPixels.forEach((inputPixel) {
      final pixelCount = pixelToCount.update(inputPixel, (value) => value + 1,
          ifAbsent: () => 1);
      if (pixelCount == 1) {
        pointCount++;
        points.add(pointProvider.fromInt(inputPixel));
        pixels.add(inputPixel);
      }
    });

    final counts = List<int>.filled(pointCount, 0);
    for (var i = 0; i < pointCount; i++) {
      final pixel = pixels[i];
      final count = pixelToCount[pixel]!;
      counts[i] = count;
    }

    var clusterCount = math.min(maxColors, pointCount);
    if (startingClusters.isNotEmpty) {
      clusterCount = math.min(clusterCount, startingClusters.length);
    }

    final clusters =
        startingClusters.map((e) => pointProvider.fromInt(e)).toList();
    final additionalClustersNeeded = clusterCount - clusters.length;
    if (startingClusters.isEmpty && additionalClustersNeeded > 0) {
      final random = math.Random(0x42688);
      for (var i = 0; i < additionalClustersNeeded; i++) {
        final a = -100.0 + random.nextDouble() * 200.0;
        final b = -100.0 + random.nextDouble() * 200.0;
        final l = 0.0 + random.nextDouble() * 100.0;

        clusters.add([l, a, b]);
      }
    }

    final clusterIndexRandom = math.Random(0x42688);
    final clusterIndices =
        List<int>.generate(pointCount, (index) => index % clusterCount);
    final indexMatrix = List<List<int>>.generate(
        clusterCount, (_) => List.filled(clusterCount, 0));

    final distanceToIndexMatrix = List<List<DistanceAndIndex>>.generate(
        clusterCount,
        (index) => List<DistanceAndIndex>.generate(
            clusterCount, (index) => DistanceAndIndex(0, index)));

    final pixelCountSums = List<int>.filled(clusterCount, 0);
    for (var iteration = 0; iteration < maxIterations; iteration++) {
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
          final distanceChange =
              (math.sqrt(minimumDistance) - math.sqrt(previousDistance)).abs();
          if (distanceChange > minMovementDistance) {
            pointsMoved++;
            clusterIndices[i] = newClusterIndex;
          }
        }
      }

      if (pointsMoved == 0 && iteration != 0) {
        break;
      }

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
        componentASums[clusterIndex] += (point[0] * count);
        componentBSums[clusterIndex] += (point[1] * count);
        componentCSums[clusterIndex] += (point[2] * count);
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

    return QuantizerResult(Map.fromIterables(clusterArgbs, clusterPopulations));
  }
}
