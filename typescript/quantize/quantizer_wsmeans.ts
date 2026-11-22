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

import * as utils from '../utils/color_utils.js';

import {labFromArgbInto} from './lab_conversion.js';

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
   *     number of colors may be returned. Should be a positive integer: other
   *     values throw an error for most inputs.
   * @return Colors in ARGB format.
   */
  static quantize(
      inputPixels: number[], startingClusters: number[],
      maxColors: number): Map<number, number> {
    // Uses a seeded random number generator to ensure consistent results,
    // matching java.util.Random(0x42688) in the Java/Kotlin ports.
    const random = new SeededRandom(0x42688);

    // Counts the distinct pixels in order of first appearance, in a flat
    // open-addressing hash table. Keys are kept as they are and compared like
    // Map keys (SameValueZero), so the result is the same as with a Map.
    let mask = 1023;
    let slots = new Int32Array(mask + 1);
    const pixels: number[] = [];
    const counts: number[] = [];
    let pointCount = 0;
    for (let i = 0; i < inputPixels.length; i++) {
      const pixel = inputPixels[i];
      let slot = hashSlot(pixel, mask);
      let entry = 0;
      while ((entry = slots[slot]) !== 0) {
        const existing = pixels[entry - 1];
        if (existing === pixel || (existing !== existing && pixel !== pixel)) {
          break;
        }
        slot = (slot + 1) & mask;
      }
      if (entry !== 0) {
        counts[entry - 1]++;
        continue;
      }
      pixels.push(pixel);
      counts.push(1);
      pointCount++;
      slots[slot] = pointCount;
      if (pointCount * 2 > mask) {
        mask = mask * 2 + 1;
        slots = new Int32Array(mask + 1);
        for (let p = 0; p < pointCount; p++) {
          let s = hashSlot(pixels[p], mask);
          while (slots[s] !== 0) s = (s + 1) & mask;
          slots[s] = p + 1;
        }
      }
    }

    const points = new Float64Array(pointCount * 3);
    for (let i = 0; i < pointCount; i++) {
      labFromArgbInto(pixels[i], points, i * 3);
    }

    let clusterCount = Math.min(maxColors, pointCount);
    if (startingClusters.length > 0) {
      clusterCount = Math.min(clusterCount, startingClusters.length);
    }

    // Invalid cluster counts throw as they did when clusters were arrays: a
    // point that is assigned to a missing cluster throws a TypeError, and an
    // invalid array length throws a RangeError. This gives the same kind of
    // error for integer and NaN counts. Non-integer counts always threw, too,
    // but the kind of error depended on the random cluster indices.
    if (!(clusterCount >= 0) || !Number.isInteger(clusterCount)) {
      if (pointCount > 0 &&
          (startingClusters.length === 0 || Number.isNaN(clusterCount))) {
        throw new TypeError('maxColors must be a positive integer');
      }
      throw new RangeError('maxColors must be a positive integer');
    }
    if (clusterCount === 0) {
      if (pointCount > 0 && startingClusters.length === 0) {
        throw new TypeError('maxColors must be a positive integer');
      }
      return new Map<number, number>();
    }

    const clusters =
        new Float64Array(Math.max(startingClusters.length, clusterCount) * 3);
    for (let i = 0; i < startingClusters.length; i++) {
      labFromArgbInto(startingClusters[i], clusters, i * 3);
    }
    const additionalClustersNeeded = clusterCount - startingClusters.length;
    if (startingClusters.length === 0 && additionalClustersNeeded > 0) {
      for (let i = 0; i < additionalClustersNeeded; i++) {
        const l = random.nextDouble() * 100.0;
        const a = random.nextDouble() * (100.0 - (-100.0) + 1) + -100;
        const b = random.nextDouble() * (100.0 - (-100.0) + 1) + -100;
        clusters[i * 3] = l;
        clusters[i * 3 + 1] = a;
        clusters[i * 3 + 2] = b;
      }
    }

    const clusterIndices = new Int32Array(pointCount);
    for (let i = 0; i < pointCount; i++) {
      clusterIndices[i] = random.nextInt(clusterCount);
    }

    // distances[i * clusterCount + j] is the distance between clusters i and j,
    // and -1 for i == j. The previous implementation called sort() without a
    // comparator on each row of objects. That compares their strings, which
    // are all equal, so the stable sort kept the rows in index order. The rows
    // are therefore left unsorted here, and the scan below checks every entry.
    const distances = new Float64Array(clusterCount * clusterCount).fill(-1);

    const pixelCountSums = new Float64Array(clusterCount);
    const componentASums = new Float64Array(clusterCount);
    const componentBSums = new Float64Array(clusterCount);
    const componentCSums = new Float64Array(clusterCount);
    for (let iteration = 0; iteration < MAX_ITERATIONS; iteration++) {
      for (let i = 0; i < clusterCount; i++) {
        const iL = clusters[i * 3];
        const iA = clusters[i * 3 + 1];
        const iB = clusters[i * 3 + 2];
        for (let j = i + 1; j < clusterCount; j++) {
          const dL = iL - clusters[j * 3];
          const dA = iA - clusters[j * 3 + 1];
          const dB = iB - clusters[j * 3 + 2];
          const distance = dL * dL + dA * dA + dB * dB;
          distances[j * clusterCount + i] = distance;
          distances[i * clusterCount + j] = distance;
        }
      }

      let pointsMoved = 0;
      for (let i = 0; i < pointCount; i++) {
        const pL = points[i * 3];
        const pA = points[i * 3 + 1];
        const pB = points[i * 3 + 2];
        const previousClusterIndex = clusterIndices[i];
        const dL0 = pL - clusters[previousClusterIndex * 3];
        const dA0 = pA - clusters[previousClusterIndex * 3 + 1];
        const dB0 = pB - clusters[previousClusterIndex * 3 + 2];
        const previousDistance = dL0 * dL0 + dA0 * dA0 + dB0 * dB0;
        const limit = 4 * previousDistance;
        const row = previousClusterIndex * clusterCount;
        let minimumDistance = previousDistance;
        let newClusterIndex = -1;
        for (let j = 0; j < clusterCount; j++) {
          if (distances[row + j] >= limit) {
            continue;
          }
          const dL = pL - clusters[j * 3];
          const dA = pA - clusters[j * 3 + 1];
          const dB = pB - clusters[j * 3 + 2];
          const distance = dL * dL + dA * dA + dB * dB;
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

      pixelCountSums.fill(0);
      componentASums.fill(0);
      componentBSums.fill(0);
      componentCSums.fill(0);
      for (let i = 0; i < pointCount; i++) {
        const clusterIndex = clusterIndices[i];
        const count = counts[i];
        pixelCountSums[clusterIndex] += count;
        componentASums[clusterIndex] += (points[i * 3] * count);
        componentBSums[clusterIndex] += (points[i * 3 + 1] * count);
        componentCSums[clusterIndex] += (points[i * 3 + 2] * count);
      }

      for (let i = 0; i < clusterCount; i++) {
        const count = pixelCountSums[i];
        if (count === 0) {
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

    const argbToPopulation = new Map<number, number>();
    for (let i = 0; i < clusterCount; i++) {
      const count = pixelCountSums[i];
      if (count === 0) {
        continue;
      }

      const possibleNewCluster = utils.argbFromLab(
          clusters[i * 3], clusters[i * 3 + 1], clusters[i * 3 + 2]);
      if (argbToPopulation.has(possibleNewCluster)) {
        continue;
      }

      argbToPopulation.set(possibleNewCluster, count);
    }
    return argbToPopulation;
  }
}

/** Returns the first slot to probe for a pixel in a table of mask + 1 slots. */
function hashSlot(pixel: number, mask: number): number {
  const h = Math.imul(pixel | 0, 0x9e3779b1);
  return (h ^ (h >>> 15)) & mask;
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
