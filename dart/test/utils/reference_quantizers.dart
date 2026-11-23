// Copyright 2026 Google LLC
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

// ignore_for_file: omit_local_variable_types

/// Frozen copies of QuantizerWsmeans and QuantizerWu as they were before they
/// were sped up, for quantizer_equivalence_test.dart. Do not change them: the
/// test checks that the library still gives exactly their results.
library;

import 'dart:math' as math show Random, min;

import 'package:material_color_utilities/quantize/quantizer.dart';
import 'package:material_color_utilities/quantize/quantizer_map.dart';
import 'package:material_color_utilities/quantize/src/point_provider.dart';
import 'package:material_color_utilities/quantize/src/point_provider_lab.dart';
import 'package:material_color_utilities/utils/color_utils.dart';

/// QuantizerCelebi, with the frozen quantizers.
class ReferenceQuantizerCelebi {
  Future<QuantizerResult> quantize(
    Iterable<int> pixels,
    int maxColors, {
    bool returnInputPixelToClusterPixel = false,
  }) async {
    final wu = ReferenceQuantizerWu();
    final wuResult = await wu.quantize(pixels, maxColors);
    return ReferenceQuantizerWsmeans.quantize(
      pixels,
      maxColors,
      startingClusters: wuResult.colorToCount.keys.toList(),
      pointProvider: const PointProviderLab(),
      returnInputPixelToClusterPixel: returnInputPixelToClusterPixel,
    );
  }
}

class _DistanceAndIndex implements Comparable<_DistanceAndIndex> {
  double distance;
  int index;

  _DistanceAndIndex(this.distance, this.index);

  @override
  int compareTo(_DistanceAndIndex other) {
    if (distance < other.distance) {
      return -1;
    } else if (distance > other.distance) {
      return 1;
    } else {
      return 0;
    }
  }
}

class ReferenceQuantizerWsmeans {
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

    final distanceToIndexMatrix = List<List<_DistanceAndIndex>>.generate(
      clusterCount,
      (index) => List<_DistanceAndIndex>.generate(
        clusterCount,
        (index) => _DistanceAndIndex(0, index),
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
}


class ReferenceQuantizerWu implements Quantizer {
  List<int> weights = <int>[];
  List<int> momentsR = <int>[];
  List<int> momentsG = <int>[];
  List<int> momentsB = <int>[];
  List<double> moments = <double>[];
  List<_Box> cubes = <_Box>[];

  // A histogram of all the input colors is constructed. It has the shape of a
  // cube. The cube would be too large if it contained all 16 million colors:
  // historical best practice is to use 5 bits  of the 8 in each channel,
  // reducing the histogram to a volume of ~32,000.
  static const indexBits = 5;
  static final maxIndex = 32;
  static final sideLength = 33;
  static final totalSize = 35937;

  @override
  Future<QuantizerResult> quantize(Iterable<int> pixels, int colorCount) async {
    final result = await QuantizerMap().quantize(pixels, colorCount);
    constructHistogram(result.colorToCount);
    computeMoments();
    final createBoxesResult = createBoxes(colorCount);
    final results = createResult(createBoxesResult.resultCount);
    return QuantizerResult(Map.fromEntries(results.map((e) => MapEntry(e, 0))));
  }

  static int getIndex(int r, int g, int b) {
    return (r << (indexBits * 2)) +
        (r << (indexBits + 1)) +
        (g << indexBits) +
        r +
        g +
        b;
  }

  void constructHistogram(Map<int, int> pixels) {
    weights = List.filled(totalSize, 0, growable: false);
    momentsR = List.filled(totalSize, 0, growable: false);
    momentsG = List.filled(totalSize, 0, growable: false);
    momentsB = List.filled(totalSize, 0, growable: false);
    moments = List.filled(totalSize, 0, growable: false);
    for (var entry in pixels.entries) {
      final pixel = entry.key;
      final count = entry.value;
      final red = ColorUtils.redFromArgb(pixel);
      final green = ColorUtils.greenFromArgb(pixel);
      final blue = ColorUtils.blueFromArgb(pixel);
      final bitsToRemove = 8 - indexBits;
      final iR = (red >> bitsToRemove) + 1;
      final iG = (green >> bitsToRemove) + 1;
      final iB = (blue >> bitsToRemove) + 1;
      final index = getIndex(iR, iG, iB);
      weights[index] += count;
      momentsR[index] += red * count;
      momentsG[index] += green * count;
      momentsB[index] += blue * count;
      moments[index] += count * ((red * red) + (green * green) + (blue * blue));
    }
  }

  void computeMoments() {
    for (var r = 1; r < sideLength; ++r) {
      List<int> area = List.filled(sideLength, 0, growable: false);
      List<int> areaR = List.filled(sideLength, 0, growable: false);
      List<int> areaG = List.filled(sideLength, 0, growable: false);
      List<int> areaB = List.filled(sideLength, 0, growable: false);
      List<double> area2 = List.filled(sideLength, 0.0, growable: false);
      for (var g = 1; g < sideLength; g++) {
        int line = 0;
        int lineR = 0;
        int lineG = 0;
        int lineB = 0;
        double line2 = 0.0;
        for (var b = 1; b < sideLength; b++) {
          int index = getIndex(r, g, b);
          line += weights[index];
          lineR += momentsR[index];
          lineG += momentsG[index];
          lineB += momentsB[index];
          line2 += moments[index];

          area[b] += line;
          areaR[b] += lineR;
          areaG[b] += lineG;
          areaB[b] += lineB;
          area2[b] += line2;

          int previousIndex = getIndex(r - 1, g, b);
          weights[index] = weights[previousIndex] + area[b];
          momentsR[index] = momentsR[previousIndex] + areaR[b];
          momentsG[index] = momentsG[previousIndex] + areaG[b];
          momentsB[index] = momentsB[previousIndex] + areaB[b];
          moments[index] = moments[previousIndex] + area2[b];
        }
      }
    }
  }

  _CreateBoxesResult createBoxes(int maxColorCount) {
    cubes = List<_Box>.generate(maxColorCount, (index) => _Box());
    cubes[0] = _Box(
      r0: 0,
      r1: maxIndex,
      g0: 0,
      g1: maxIndex,
      b0: 0,
      b1: maxIndex,
      vol: 0,
    );

    List<double> volumeVariance = List.filled(
      maxColorCount,
      0.0,
      growable: false,
    );
    int next = 0;
    int generatedColorCount = maxColorCount;
    for (int i = 1; i < maxColorCount; i++) {
      if (cut(cubes[next], cubes[i])) {
        volumeVariance[next] =
            (cubes[next].vol > 1) ? variance(cubes[next]) : 0.0;
        volumeVariance[i] = (cubes[i].vol > 1) ? variance(cubes[i]) : 0.0;
      } else {
        volumeVariance[next] = 0.0;
        i--;
      }

      next = 0;
      double temp = volumeVariance[0];
      for (var j = 1; j <= i; j++) {
        if (volumeVariance[j] > temp) {
          temp = volumeVariance[j];
          next = j;
        }
      }
      if (temp <= 0.0) {
        generatedColorCount = i + 1;
        break;
      }
    }

    return _CreateBoxesResult(
      requestedCount: maxColorCount,
      resultCount: generatedColorCount,
    );
  }

  List<int> createResult(int colorCount) {
    List<int> colors = <int>[];
    for (int i = 0; i < colorCount; ++i) {
      final cube = cubes[i];
      int weight = volume(cube, weights);
      if (weight > 0) {
        int r = (volume(cube, momentsR) / weight).round();
        int g = (volume(cube, momentsG) / weight).round();
        int b = (volume(cube, momentsB) / weight).round();
        int color = ColorUtils.argbFromRgb(r, g, b);
        colors.add(color);
      }
    }
    return colors;
  }

  double variance(_Box cube) {
    final dr = volume(cube, momentsR);
    final dg = volume(cube, momentsG);
    final db = volume(cube, momentsB);
    final xx =
        moments[getIndex(cube.r1, cube.g1, cube.b1)] -
        moments[getIndex(cube.r1, cube.g1, cube.b0)] -
        moments[getIndex(cube.r1, cube.g0, cube.b1)] +
        moments[getIndex(cube.r1, cube.g0, cube.b0)] -
        moments[getIndex(cube.r0, cube.g1, cube.b1)] +
        moments[getIndex(cube.r0, cube.g1, cube.b0)] +
        moments[getIndex(cube.r0, cube.g0, cube.b1)] -
        moments[getIndex(cube.r0, cube.g0, cube.b0)];

    final hypotenuse = dr * dr + dg * dg + db * db;
    final volume_ = volume(cube, weights);
    return xx - hypotenuse / volume_;
  }

  bool cut(_Box one, _Box two) {
    final wholeR = volume(one, momentsR);
    final wholeG = volume(one, momentsG);
    final wholeB = volume(one, momentsB);
    final wholeW = volume(one, weights);

    final maxRResult = maximize(
      one,
      _Direction.red,
      one.r0 + 1,
      one.r1,
      wholeR,
      wholeG,
      wholeB,
      wholeW,
    );
    final maxGResult = maximize(
      one,
      _Direction.green,
      one.g0 + 1,
      one.g1,
      wholeR,
      wholeG,
      wholeB,
      wholeW,
    );
    final maxBResult = maximize(
      one,
      _Direction.blue,
      one.b0 + 1,
      one.b1,
      wholeR,
      wholeG,
      wholeB,
      wholeW,
    );

    _Direction cutDirection;
    final maxR = maxRResult.maximum;
    final maxG = maxGResult.maximum;
    final maxB = maxBResult.maximum;
    if (maxR >= maxG && maxR >= maxB) {
      cutDirection = _Direction.red;
      if (maxRResult.cutLocation < 0) {
        return false;
      }
    } else if (maxG >= maxR && maxG >= maxB) {
      cutDirection = _Direction.green;
    } else {
      cutDirection = _Direction.blue;
    }

    two.r1 = one.r1;
    two.g1 = one.g1;
    two.b1 = one.b1;

    switch (cutDirection) {
      case _Direction.red:
        one.r1 = maxRResult.cutLocation;
        two.r0 = one.r1;
        two.g0 = one.g0;
        two.b0 = one.b0;
        break;
      case _Direction.green:
        one.g1 = maxGResult.cutLocation;
        two.r0 = one.r0;
        two.g0 = one.g1;
        two.b0 = one.b0;
        break;
      case _Direction.blue:
        one.b1 = maxBResult.cutLocation;
        two.r0 = one.r0;
        two.g0 = one.g0;
        two.b0 = one.b1;
        break;
    }

    one.vol = (one.r1 - one.r0) * (one.g1 - one.g0) * (one.b1 - one.b0);
    two.vol = (two.r1 - two.r0) * (two.g1 - two.g0) * (two.b1 - two.b0);
    return true;
  }

  _MaximizeResult maximize(
    _Box cube,
    _Direction direction,
    int first,
    int last,
    int wholeR,
    int wholeG,
    int wholeB,
    int wholeW,
  ) {
    int bottomR = bottom(cube, direction, momentsR);
    int bottomG = bottom(cube, direction, momentsG);
    int bottomB = bottom(cube, direction, momentsB);
    int bottomW = bottom(cube, direction, weights);

    double max = 0.0;
    int cut = -1;

    for (int i = first; i < last; i++) {
      int halfR = bottomR + top(cube, direction, i, momentsR);
      int halfG = bottomG + top(cube, direction, i, momentsG);
      int halfB = bottomB + top(cube, direction, i, momentsB);
      int halfW = bottomW + top(cube, direction, i, weights);

      if (halfW == 0) {
        continue;
      }

      double tempNumerator =
          ((halfR * halfR) + (halfG * halfG) + (halfB * halfB)).toDouble();
      double tempDenominator = halfW.toDouble();
      double temp = tempNumerator / tempDenominator;

      halfR = wholeR - halfR;
      halfG = wholeG - halfG;
      halfB = wholeB - halfB;
      halfW = wholeW - halfW;
      if (halfW == 0) {
        continue;
      }
      tempNumerator =
          ((halfR * halfR) + (halfG * halfG) + (halfB * halfB)).toDouble();
      tempDenominator = halfW.toDouble();
      temp += tempNumerator / tempDenominator;

      if (temp > max) {
        max = temp;
        cut = i;
      }
    }
    return _MaximizeResult(cutLocation: cut, maximum: max);
  }

  static int volume(_Box cube, List<int> moment) {
    return moment[getIndex(cube.r1, cube.g1, cube.b1)] -
        moment[getIndex(cube.r1, cube.g1, cube.b0)] -
        moment[getIndex(cube.r1, cube.g0, cube.b1)] +
        moment[getIndex(cube.r1, cube.g0, cube.b0)] -
        moment[getIndex(cube.r0, cube.g1, cube.b1)] +
        moment[getIndex(cube.r0, cube.g1, cube.b0)] +
        moment[getIndex(cube.r0, cube.g0, cube.b1)] -
        moment[getIndex(cube.r0, cube.g0, cube.b0)];
  }

  static int bottom(_Box cube, _Direction direction, List<int> moment) {
    return switch (direction) {
      _Direction.red =>
        -moment[getIndex(cube.r0, cube.g1, cube.b1)] +
            moment[getIndex(cube.r0, cube.g1, cube.b0)] +
            moment[getIndex(cube.r0, cube.g0, cube.b1)] -
            moment[getIndex(cube.r0, cube.g0, cube.b0)],
      _Direction.green =>
        -moment[getIndex(cube.r1, cube.g0, cube.b1)] +
            moment[getIndex(cube.r1, cube.g0, cube.b0)] +
            moment[getIndex(cube.r0, cube.g0, cube.b1)] -
            moment[getIndex(cube.r0, cube.g0, cube.b0)],
      _Direction.blue =>
        -moment[getIndex(cube.r1, cube.g1, cube.b0)] +
            moment[getIndex(cube.r1, cube.g0, cube.b0)] +
            moment[getIndex(cube.r0, cube.g1, cube.b0)] -
            moment[getIndex(cube.r0, cube.g0, cube.b0)],
    };
  }

  static int top(
    _Box cube,
    _Direction direction,
    int position,
    List<int> moment,
  ) {
    return switch (direction) {
      _Direction.red =>
        moment[getIndex(position, cube.g1, cube.b1)] -
            moment[getIndex(position, cube.g1, cube.b0)] -
            moment[getIndex(position, cube.g0, cube.b1)] +
            moment[getIndex(position, cube.g0, cube.b0)],
      _Direction.green =>
        moment[getIndex(cube.r1, position, cube.b1)] -
            moment[getIndex(cube.r1, position, cube.b0)] -
            moment[getIndex(cube.r0, position, cube.b1)] +
            moment[getIndex(cube.r0, position, cube.b0)],
      _Direction.blue =>
        moment[getIndex(cube.r1, cube.g1, position)] -
            moment[getIndex(cube.r1, cube.g0, position)] -
            moment[getIndex(cube.r0, cube.g1, position)] +
            moment[getIndex(cube.r0, cube.g0, position)],
    };
  }
}

enum _Direction { red, green, blue }

class _MaximizeResult {
  // < 0 if cut impossible
  int cutLocation;
  double maximum;

  _MaximizeResult({required this.cutLocation, required this.maximum});
}

class _CreateBoxesResult {
  int requestedCount;
  int resultCount;

  _CreateBoxesResult({required this.requestedCount, required this.resultCount});
}

class _Box {
  int r0;
  int r1;
  int g0;
  int g1;
  int b0;
  int b1;
  int vol;

  _Box({
    this.r0 = 0,
    this.r1 = 0,
    this.g0 = 0,
    this.g1 = 0,
    this.b0 = 0,
    this.b1 = 0,
    this.vol = 0,
  });

  @override
  String toString() {
    return '_Box: R $r0 -> $r1 G  $g0 -> $g1 B $b0 -> $b1 VOL = $vol';
  }
}
