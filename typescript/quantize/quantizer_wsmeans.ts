/**
 * @license
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

import {LabPointProvider} from './lab_point_provider.js';

const MAX_ITERATIONS = 10;
const MIN_MOVEMENT_DISTANCE = 3.0;

/**
 * An image quantizer that improves on the speed of a standard K-Means algorithm
 * by implementing several optimizations, including deduping identical pixels
 * and a triangle inequality rule that reduces the number of comparisons needed
 * to identify which cluster a point should be moved to.
 *
 * Wsmeans stands for Weighted Square Means.
 *
 * This algorithm was designed by M. Emre Celebi, and was found in their 2011
 * paper, Improving the Performance of K-Means for Color Quantization.
 * https://arxiv.org/abs/1101.0395
 */
// material_color_utilities is designed to have a consistent API across
// platforms and modular components that can be moved around easily. Using a
// class as a namespace facilitates this.
//
// tslint:disable-next-line:class-as-namespace
export class QuantizerWsmeans {
  /**
   * @param inputPixels Colors in ARGB format.
   * @param startingClusters Defines the initial state of the quantizer. Passing
   *     an empty array is fine, the implementation will create its own initial
   *     state that leads to reproducible results for the same inputs.
   *     Passing an array that is the result of Wu quantization leads to higher
   *     quality results.
   * @param maxColors The number of colors to divide the image into. A lower
   *     number of colors may be returned.
   * @return Colors in ARGB format.
   */
  static quantize(
      inputPixels: number[], startingClusters: number[],
      maxColors: number): Map<number, number> {
    // Uses a seeded random number generator to ensure consistent results,
    // matching java.util.Random(0x42688) in the Java/Kotlin ports.
    const random = new SeededRandom(0x42688);

    const pixelToCount = new Map<number, number>();
    const points = new Array<number[]>();
    const pixels = new Array<number>();
    const pointProvider = new LabPointProvider();
    let pointCount = 0;
    for (let i = 0; i < inputPixels.length; i++) {
      const inputPixel = inputPixels[i];
      const pixelCount = pixelToCount.get(inputPixel);
      if (pixelCount === undefined) {
        pointCount++;
        points.push(pointProvider.fromInt(inputPixel));
        pixels.push(inputPixel);
        pixelToCount.set(inputPixel, 1);
      } else {
        pixelToCount.set(inputPixel, pixelCount + 1);
      }
    }

    const counts = new Array<number>();
    for (let i = 0; i < pointCount; i++) {
      const pixel = pixels[i];
      const count = pixelToCount.get(pixel);
      if (count !== undefined) {
        counts[i] = count;
      }
    }

    let clusterCount = Math.min(maxColors, pointCount);
    if (startingClusters.length > 0) {
      clusterCount = Math.min(clusterCount, startingClusters.length);
    }

    const clusters = new Array<number[]>();
    for (let i = 0; i < startingClusters.length; i++) {
      clusters.push(pointProvider.fromInt(startingClusters[i]));
    }
    const additionalClustersNeeded = clusterCount - clusters.length;
    if (startingClusters.length === 0 && additionalClustersNeeded > 0) {
      for (let i = 0; i < additionalClustersNeeded; i++) {
        const l = random.nextDouble() * 100.0;
        const a = random.nextDouble() * (100.0 - (-100.0) + 1) + -100;
        const b = random.nextDouble() * (100.0 - (-100.0) + 1) + -100;

        clusters.push(new Array(l, a, b));
      }
    }

    const clusterIndices = new Array<number>();
    for (let i = 0; i < pointCount; i++) {
      clusterIndices.push(random.nextInt(clusterCount));
    }

    const indexMatrix = new Array<number[]>();
    for (let i = 0; i < clusterCount; i++) {
      indexMatrix.push(new Array<number>());
      for (let j = 0; j < clusterCount; j++) {
        indexMatrix[i].push(0);
      }
    }

    const distanceToIndexMatrix = new Array<DistanceAndIndex[]>();
    for (let i = 0; i < clusterCount; i++) {
      distanceToIndexMatrix.push(new Array<DistanceAndIndex>());
      for (let j = 0; j < clusterCount; j++) {
        distanceToIndexMatrix[i].push(new DistanceAndIndex());
      }
    }


    const pixelCountSums = new Array<number>();
    for (let i = 0; i < clusterCount; i++) {
      pixelCountSums.push(0);
    }
    for (let iteration = 0; iteration < MAX_ITERATIONS; iteration++) {
      for (let i = 0; i < clusterCount; i++) {
        for (let j = i + 1; j < clusterCount; j++) {
          const distance = pointProvider.distance(clusters[i], clusters[j]);
          distanceToIndexMatrix[j][i].distance = distance;
          distanceToIndexMatrix[j][i].index = i;
          distanceToIndexMatrix[i][j].distance = distance;
          distanceToIndexMatrix[i][j].index = j;
        }
        distanceToIndexMatrix[i].sort();
        for (let j = 0; j < clusterCount; j++) {
          indexMatrix[i][j] = distanceToIndexMatrix[i][j].index;
        }
      }

      let pointsMoved = 0;
      for (let i = 0; i < pointCount; i++) {
        const point = points[i];
        const previousClusterIndex = clusterIndices[i];
        const previousCluster = clusters[previousClusterIndex];
        const previousDistance = pointProvider.distance(point, previousCluster);
        let minimumDistance = previousDistance;
        let newClusterIndex = -1;
        for (let j = 0; j < clusterCount; j++) {
          if (distanceToIndexMatrix[previousClusterIndex][j].distance >=
              4 * previousDistance) {
            continue;
          }
          const distance = pointProvider.distance(point, clusters[j]);
          if (distance < minimumDistance) {
            minimumDistance = distance;
            newClusterIndex = j;
          }
        }
        if (newClusterIndex !== -1) {
          const distanceChange = Math.abs(
              (Math.sqrt(minimumDistance) - Math.sqrt(previousDistance)));
          if (distanceChange > MIN_MOVEMENT_DISTANCE) {
            pointsMoved++;
            clusterIndices[i] = newClusterIndex;
          }
        }
      }

      if (pointsMoved === 0 && iteration !== 0) {
        break;
      }

      const componentASums = new Array<number>(clusterCount).fill(0);
      const componentBSums = new Array<number>(clusterCount).fill(0);
      const componentCSums = new Array<number>(clusterCount).fill(0);

      for (let i = 0; i < clusterCount; i++) {
        pixelCountSums[i] = 0;
      }
      for (let i = 0; i < pointCount; i++) {
        const clusterIndex = clusterIndices[i];
        const point = points[i];
        const count = counts[i];
        pixelCountSums[clusterIndex] += count;
        componentASums[clusterIndex] += (point[0] * count);
        componentBSums[clusterIndex] += (point[1] * count);
        componentCSums[clusterIndex] += (point[2] * count);
      }

      for (let i = 0; i < clusterCount; i++) {
        const count = pixelCountSums[i];
        if (count === 0) {
          clusters[i] = [0.0, 0.0, 0.0];
          continue;
        }
        const a = componentASums[i] / count;
        const b = componentBSums[i] / count;
        const c = componentCSums[i] / count;
        clusters[i] = [a, b, c];
      }
    }

    const argbToPopulation = new Map<number, number>();
    for (let i = 0; i < clusterCount; i++) {
      const count = pixelCountSums[i];
      if (count === 0) {
        continue;
      }

      const possibleNewCluster = pointProvider.toInt(clusters[i]);
      if (argbToPopulation.has(possibleNewCluster)) {
        continue;
      }

      argbToPopulation.set(possibleNewCluster, count);
    }
    return argbToPopulation;
  }
}

/**
 *  A wrapper for maintaining a table of distances between K-Means clusters.
 */
class DistanceAndIndex {
  distance: number = -1;
  index: number = -1;
}

/**
 * Deterministic 48-bit LCG matching `java.util.Random` using two 24-bit words
 * so all intermediate products stay exact in IEEE-754 numbers (< 2^53).
 */
class SeededRandom {
  private lo: number;
  private hi: number;

  constructor(seed: number) {
    this.lo = (seed & 0xffffff) ^ 0xece66d;
    this.hi = ((seed >>> 24) & 0xffffff) ^ 0x5de;
  }

  private nextBits(bits: number): number {
    const loProduct = this.lo * 0xece66d + 0xb;
    const carry = Math.floor(loProduct / 0x1000000);
    const nextLo = loProduct % 0x1000000;
    const hiProduct = this.hi * 0xece66d + this.lo * 0x5de + carry;
    this.lo = nextLo;
    this.hi = hiProduct & 0xffffff;
    const shift = 48 - bits;
    return (this.hi << (24 - shift)) | (this.lo >>> shift);
  }

  nextInt(bound: number): number {
    if (bound <= 0) {
      return 0;
    }
    if ((bound & -bound) === bound) {
      return Math.floor((bound * this.nextBits(31)) / 0x80000000);
    }
    let bits: number;
    let val: number;
    do {
      bits = this.nextBits(31);
      val = bits % bound;
    } while (bits - val + (bound - 1) >= 0x80000000);
    return val;
  }

  nextDouble(): number {
    return (
      (this.nextBits(26) * 0x8000000 + this.nextBits(27)) / 0x20000000000000
    );
  }
}
