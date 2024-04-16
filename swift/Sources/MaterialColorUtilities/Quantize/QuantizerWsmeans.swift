// Copyright 2023 Google LLC
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

import Foundation

class DistanceAndIndex: Comparable {
  func compareTo(_ other: DistanceAndIndex) -> Int {
    if distance < other.distance {
      return -1
    } else if distance > other.distance {
      return 1
    } else {
      return 0
    }
  }

  static func < (lhs: DistanceAndIndex, rhs: DistanceAndIndex) -> Bool {
    return lhs.distance < rhs.distance
  }

  static func == (lhs: DistanceAndIndex, rhs: DistanceAndIndex) -> Bool {
    return lhs.distance != rhs.distance
  }

  var distance: Double
  var index: Int

  init(_ distance: Double, _ index: Int) {
    self.distance = distance
    self.index = index
  }
}

public class QuantizerWsmeans {
  static var debug: Bool = false

  static func debugLog(_ log: String) {
    if debug {
      print(log)
    }
  }

  public static func quantize(
    _ inputPixels: [Int],
    _ maxColors: Int,
    startingClusters: [Int] = [],
    pointProvider: PointProvider = PointProviderLab(),
    maxIterations: Int = 5,
    returnInputPixelToClusterPixel: Bool = false
  ) -> QuantizerResult {
    var pixelToCount: [Int: Int] = [:]
    var points: [[Double]] = []
    var pixels: [Int] = []
    var pointCount = 0
    for inputPixel in inputPixels {
      var pixelCount = pixelToCount[inputPixel]
      if pixelCount == nil {
        pixelCount = 1
        pixelToCount[inputPixel] = pixelCount
      } else {
        pixelCount = pixelCount! + 1
        pixelToCount[inputPixel] = pixelCount
      }
      if pixelCount == 1 {
        pointCount = pointCount + 1
        points.append(pointProvider.fromInt(inputPixel))
        pixels.append(inputPixel)
      }
    }

    var counts = [Int](repeating: 0, count: pointCount)
    for i in 0..<pointCount {
      let pixel = pixels[i]
      let count = pixelToCount[pixel]
      counts[i] = count!
    }

    let clusterCount = min(maxColors, pointCount)

    var clusters = startingClusters.map { pointProvider.fromInt($0) }
    let additionalClustersNeeded = clusterCount - clusters.count
    if additionalClustersNeeded > 0 {
      var seedGenerator = RandomNumberWithSeed(0x42688)
      var indices: [Int] = []
      for _ in 0..<additionalClustersNeeded {
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
        var index = Int.random(in: 0..<points.count, using: &seedGenerator)
        while indices.contains(index) {
          index = Int.random(in: 0..<points.count, using: &seedGenerator)
        }
        indices.append(index)
      }

      for index in indices {
        clusters.append(points[index])
      }
    }
    QuantizerWsmeans.debugLog("have \(clusters.count) starting clusters, \(points.count) points")
    var clusterIndices = fillArray(pointCount) { index in
      index % clusterCount
    }
    var indexMatrix = [[Int]](
      repeating: [Int](repeating: 0, count: clusterCount), count: clusterCount)
    var distanceToIndexMatrix: [[DistanceAndIndex]] = fillArray(clusterCount) { _ in
      fillArray(clusterCount) { index in
        DistanceAndIndex(0, index)
      }
    }
    var pixelCountSums = [Int](repeating: 0, count: clusterCount)
    for iteration in 0..<maxIterations {
      if QuantizerWsmeans.debug {
        for i in 0..<clusterCount {
          pixelCountSums[i] = 0
        }
        for i in 0..<pointCount {
          let clusterIndex = clusterIndices[i]
          let count = counts[i]
          pixelCountSums[clusterIndex] = pixelCountSums[clusterIndex] + count
        }
        var emptyClusters = 0
        for cluster in 0..<clusterCount {
          if pixelCountSums[cluster] == 0 {
            emptyClusters = emptyClusters + 1
          }
        }
        QuantizerWsmeans.debugLog(
          "starting iteration \(iteration + 1); \(emptyClusters) clusters are empty of \(clusterCount)"
        )
      }

      var pointsMoved = 0
      for i in 0..<clusterCount {
        for j in (i + 1)..<clusterCount {
          let distance = pointProvider.distance(clusters[i], clusters[j])
          distanceToIndexMatrix[j][i].distance = distance
          distanceToIndexMatrix[j][i].index = i
          distanceToIndexMatrix[i][j].distance = distance
          distanceToIndexMatrix[i][j].index = j
        }
        distanceToIndexMatrix[i].sort()
        for j in 0..<clusterCount {
          indexMatrix[i][j] = distanceToIndexMatrix[i][j].index
        }
      }

      for i in 0..<pointCount {
        let point = points[i]
        let previousClusterIndex = clusterIndices[i]
        let previousCluster = clusters[previousClusterIndex]
        let previousDistance = pointProvider.distance(point, previousCluster)
        var minimumDistance = previousDistance
        var newClusterIndex = -1
        for j in 0..<clusterCount {
          if distanceToIndexMatrix[previousClusterIndex][j].distance >= 4 * previousDistance {
            continue
          }
          let distance = pointProvider.distance(point, clusters[j])
          if distance < minimumDistance {
            minimumDistance = distance
            newClusterIndex = j
          }
        }
        if newClusterIndex != -1 {
          pointsMoved = pointsMoved + 1
          clusterIndices[i] = newClusterIndex
        }
      }

      if pointsMoved == 0 && iteration > 0 {
        QuantizerWsmeans.debugLog("terminated after \(iteration) k-means iterations")
        break
      }

      QuantizerWsmeans.debugLog("iteration \(iteration + 1) moved \(pointsMoved)")
      var componentASums = [Double](repeating: 0, count: clusterCount)
      var componentBSums = [Double](repeating: 0, count: clusterCount)
      var componentCSums = [Double](repeating: 0, count: clusterCount)

      for i in 0..<clusterCount {
        pixelCountSums[i] = 0
      }

      for i in 0..<pointCount {
        let clusterIndex = clusterIndices[i]
        let point = points[i]
        let count = counts[i]
        pixelCountSums[clusterIndex] = pixelCountSums[clusterIndex] + count
        componentASums[clusterIndex] = componentASums[clusterIndex] + (point[0] * Double(count))
        componentBSums[clusterIndex] = componentBSums[clusterIndex] + (point[1] * Double(count))
        componentCSums[clusterIndex] = componentCSums[clusterIndex] + (point[2] * Double(count))
      }

      for i in 0..<clusterCount {
        let count = pixelCountSums[i]
        if count == 0 {
          clusters[i] = [0, 0, 0]
          continue
        }
        let a = componentASums[i] / Double(count)
        let b = componentBSums[i] / Double(count)
        let c = componentCSums[i] / Double(count)
        clusters[i] = [a, b, c]
      }
    }

    var clusterArgbs: [Int] = []
    var clusterPopulations: [Int] = []
    for i in 0..<clusterCount {
      let count = pixelCountSums[i]
      if count == 0 {
        continue
      }

      let possibleNewCluster = pointProvider.toInt(clusters[i])
      if clusterArgbs.contains(possibleNewCluster) {
        continue
      }

      clusterArgbs.append(possibleNewCluster)
      clusterPopulations.append(count)
    }

    QuantizerWsmeans.debugLog(
      "kmeans finished and generated \(clusterArgbs.count) clusters; \(clusterCount) were requested"
    )

    var inputPixelToClusterPixel: [Int: Int] = [:]
    if returnInputPixelToClusterPixel {
      let startTime = Date()
      for i in 0..<pixels.count {
        let inputPixel = pixels[i]
        let clusterIndex = clusterIndices[i]
        let cluster = clusters[clusterIndex]
        let clusterPixel = pointProvider.toInt(cluster)
        inputPixelToClusterPixel[inputPixel] = clusterPixel
      }
      let timeElapsed = abs(startTime.timeIntervalSinceNow)
      QuantizerWsmeans.debugLog("took \(timeElapsed) ms to create input to cluster map")
    }

    var colorToCount: [Int: Int] = [:]
    for i in 0..<clusterArgbs.count {
      let key = clusterArgbs[i]
      let value = clusterPopulations[i]
      colorToCount[key] = value
    }
    return QuantizerResult(colorToCount, inputPixelToClusterPixel: inputPixelToClusterPixel)
  }
}

private func fillArray<T>(_ count: Int, _ callback: (_ index: Int) -> T) -> [T] {
  var results: [T] = []
  for index in 0..<count {
    results.append(callback(index))
  }
  return results
}

private class RandomNumberWithSeed: RandomNumberGenerator {
  init(_ seed: Int) {
    srand48(seed)
  }

  func next() -> UInt64 {
    return UInt64(drand48() * Double(Int.max))
  }
}
