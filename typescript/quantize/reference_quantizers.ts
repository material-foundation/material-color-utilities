/**
 * @license
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

/**
 * @fileoverview Frozen copies of QuantizerMap, QuantizerWu, QuantizerWsmeans
 * and QuantizerCelebi as they were before they were optimized. The equivalence
 * test checks that the optimized quantizers return exactly the same results.
 * Do not change this file, except to fix it if it is not an exact copy.
 */

import * as utils from '../utils/color_utils.js';

import {LabPointProvider} from './lab_point_provider.js';

/**
 * Quantizes an image into a map, with keys of ARGB colors, and values of the
 * number of times that color appears in the image.
 */
// material_color_utilities is designed to have a consistent API across
// platforms and modular components that can be moved around easily. Using a
// class as a namespace facilitates this.
//
// tslint:disable-next-line:class-as-namespace
export class ReferenceQuantizerMap {
  /**
   * @param pixels Colors in ARGB format.
   * @return A Map with keys of ARGB colors, and values of the number of times
   *     the color appears in the image.
   */
  static quantize(pixels: number[]): Map<number, number> {
    const countByColor = new Map<number, number>();
    for (let i = 0; i < pixels.length; i++) {
      const pixel = pixels[i];
      const alpha = utils.alphaFromArgb(pixel);
      if (alpha < 255) {
        continue;
      }
      countByColor.set(pixel, (countByColor.get(pixel) ?? 0) + 1);
    }
    return countByColor;
  }
}

const INDEX_BITS = 5;
const SIDE_LENGTH = 33;    // ((1 << INDEX_INDEX_BITS) + 1)
const TOTAL_SIZE = 35937;  // SIDE_LENGTH * SIDE_LENGTH * SIDE_LENGTH

const DIRECTIONS = {
  RED: 'red',
  GREEN: 'green',
  BLUE: 'blue',
};

/**
 * An image quantizer that divides the image's pixels into clusters by
 * recursively cutting an RGB cube, based on the weight of pixels in each area
 * of the cube.
 *
 * The algorithm was described by Xiaolin Wu in Graphic Gems II, published in
 * 1991.
 */
export class ReferenceQuantizerWu {
  constructor(
      private weights: number[] = [], private momentsR: number[] = [],
      private momentsG: number[] = [], private momentsB: number[] = [],
      private moments: number[] = [], private cubes: ReferenceBox[] = []) {}

  /**
   * @param pixels Colors in ARGB format.
   * @param maxColors The number of colors to divide the image into. A lower
   *     number of colors may be returned.
   * @return Colors in ARGB format.
   */
  quantize(pixels: number[], maxColors: number): number[] {
    this.constructHistogram(pixels);
    this.computeMoments();
    const createBoxesResult = this.createBoxes(maxColors);
    const results = this.createResult(createBoxesResult.resultCount);
    return results;
  }

  private constructHistogram(pixels: number[]) {
    this.weights = Array.from<number>({length: TOTAL_SIZE}).fill(0);
    this.momentsR = Array.from<number>({length: TOTAL_SIZE}).fill(0);
    this.momentsG = Array.from<number>({length: TOTAL_SIZE}).fill(0);
    this.momentsB = Array.from<number>({length: TOTAL_SIZE}).fill(0);
    this.moments = Array.from<number>({length: TOTAL_SIZE}).fill(0);

    const countByColor = ReferenceQuantizerMap.quantize(pixels);

    for (const [pixel, count] of countByColor.entries()) {
      const red = utils.redFromArgb(pixel);
      const green = utils.greenFromArgb(pixel);
      const blue = utils.blueFromArgb(pixel);

      const bitsToRemove = 8 - INDEX_BITS;
      const iR = (red >> bitsToRemove) + 1;
      const iG = (green >> bitsToRemove) + 1;
      const iB = (blue >> bitsToRemove) + 1;
      const index = this.getIndex(iR, iG, iB);

      this.weights[index] = (this.weights[index] ?? 0) + count;
      this.momentsR[index] += count * red;
      this.momentsG[index] += count * green;
      this.momentsB[index] += count * blue;
      this.moments[index] += count * (red * red + green * green + blue * blue);
    }
  }

  private computeMoments() {
    for (let r = 1; r < SIDE_LENGTH; r++) {
      const area = Array.from<number>({length: SIDE_LENGTH}).fill(0);
      const areaR = Array.from<number>({length: SIDE_LENGTH}).fill(0);
      const areaG = Array.from<number>({length: SIDE_LENGTH}).fill(0);
      const areaB = Array.from<number>({length: SIDE_LENGTH}).fill(0);
      const area2 = Array.from<number>({length: SIDE_LENGTH}).fill(0.0);
      for (let g = 1; g < SIDE_LENGTH; g++) {
        let line = 0;
        let lineR = 0;
        let lineG = 0;
        let lineB = 0;
        let line2 = 0.0;
        for (let b = 1; b < SIDE_LENGTH; b++) {
          const index = this.getIndex(r, g, b);
          line += this.weights[index];
          lineR += this.momentsR[index];
          lineG += this.momentsG[index];
          lineB += this.momentsB[index];
          line2 += this.moments[index];

          area[b] += line;
          areaR[b] += lineR;
          areaG[b] += lineG;
          areaB[b] += lineB;
          area2[b] += line2;

          const previousIndex = this.getIndex(r - 1, g, b);
          this.weights[index] = this.weights[previousIndex] + area[b];
          this.momentsR[index] = this.momentsR[previousIndex] + areaR[b];
          this.momentsG[index] = this.momentsG[previousIndex] + areaG[b];
          this.momentsB[index] = this.momentsB[previousIndex] + areaB[b];
          this.moments[index] = this.moments[previousIndex] + area2[b];
        }
      }
    }
  }

  private createBoxes(maxColors: number): ReferenceCreateBoxesResult {
    this.cubes = Array.from<number>({length: maxColors})
                     .fill(0)
                     .map(() => new ReferenceBox());
    const volumeVariance = Array.from<number>({length: maxColors}).fill(0.0);
    this.cubes[0].r0 = 0;
    this.cubes[0].g0 = 0;
    this.cubes[0].b0 = 0;

    this.cubes[0].r1 = SIDE_LENGTH - 1;
    this.cubes[0].g1 = SIDE_LENGTH - 1;
    this.cubes[0].b1 = SIDE_LENGTH - 1;

    let generatedColorCount = maxColors;
    let next = 0;
    for (let i = 1; i < maxColors; i++) {
      if (this.cut(this.cubes[next], this.cubes[i])) {
        volumeVariance[next] =
            this.cubes[next].vol > 1 ? this.variance(this.cubes[next]) : 0.0;
        volumeVariance[i] =
            this.cubes[i].vol > 1 ? this.variance(this.cubes[i]) : 0.0;
      } else {
        volumeVariance[next] = 0.0;
        i--;
      }

      next = 0;
      let temp = volumeVariance[0];
      for (let j = 1; j <= i; j++) {
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
    return new ReferenceCreateBoxesResult(maxColors, generatedColorCount);
  }

  private createResult(colorCount: number): number[] {
    const colors: number[] = [];
    for (let i = 0; i < colorCount; ++i) {
      const cube = this.cubes[i];
      const weight = this.volume(cube, this.weights);
      if (weight > 0) {
        const r = Math.round(this.volume(cube, this.momentsR) / weight);
        const g = Math.round(this.volume(cube, this.momentsG) / weight);
        const b = Math.round(this.volume(cube, this.momentsB) / weight);
        const color = (255 << 24) | ((r & 0x0ff) << 16) | ((g & 0x0ff) << 8) |
            (b & 0x0ff);
        colors.push(color);
      }
    }
    return colors;
  }

  private variance(cube: ReferenceBox) {
    const dr = this.volume(cube, this.momentsR);
    const dg = this.volume(cube, this.momentsG);
    const db = this.volume(cube, this.momentsB);
    const xx = this.moments[this.getIndex(cube.r1, cube.g1, cube.b1)] -
        this.moments[this.getIndex(cube.r1, cube.g1, cube.b0)] -
        this.moments[this.getIndex(cube.r1, cube.g0, cube.b1)] +
        this.moments[this.getIndex(cube.r1, cube.g0, cube.b0)] -
        this.moments[this.getIndex(cube.r0, cube.g1, cube.b1)] +
        this.moments[this.getIndex(cube.r0, cube.g1, cube.b0)] +
        this.moments[this.getIndex(cube.r0, cube.g0, cube.b1)] -
        this.moments[this.getIndex(cube.r0, cube.g0, cube.b0)];
    const hypotenuse = dr * dr + dg * dg + db * db;
    const volume = this.volume(cube, this.weights);
    return xx - hypotenuse / volume;
  }

  private cut(one: ReferenceBox, two: ReferenceBox) {
    const wholeR = this.volume(one, this.momentsR);
    const wholeG = this.volume(one, this.momentsG);
    const wholeB = this.volume(one, this.momentsB);
    const wholeW = this.volume(one, this.weights);

    const maxRResult = this.maximize(
        one, DIRECTIONS.RED, one.r0 + 1, one.r1, wholeR, wholeG, wholeB,
        wholeW);
    const maxGResult = this.maximize(
        one, DIRECTIONS.GREEN, one.g0 + 1, one.g1, wholeR, wholeG, wholeB,
        wholeW);
    const maxBResult = this.maximize(
        one, DIRECTIONS.BLUE, one.b0 + 1, one.b1, wholeR, wholeG, wholeB,
        wholeW);

    let direction;
    const maxR = maxRResult.maximum;
    const maxG = maxGResult.maximum;
    const maxB = maxBResult.maximum;
    if (maxR >= maxG && maxR >= maxB) {
      if (maxRResult.cutLocation < 0) {
        return false;
      }
      direction = DIRECTIONS.RED;
    } else if (maxG >= maxR && maxG >= maxB) {
      direction = DIRECTIONS.GREEN;
    } else {
      direction = DIRECTIONS.BLUE;
    }

    two.r1 = one.r1;
    two.g1 = one.g1;
    two.b1 = one.b1;

    switch (direction) {
      case DIRECTIONS.RED:
        one.r1 = maxRResult.cutLocation;
        two.r0 = one.r1;
        two.g0 = one.g0;
        two.b0 = one.b0;
        break;
      case DIRECTIONS.GREEN:
        one.g1 = maxGResult.cutLocation;
        two.r0 = one.r0;
        two.g0 = one.g1;
        two.b0 = one.b0;
        break;
      case DIRECTIONS.BLUE:
        one.b1 = maxBResult.cutLocation;
        two.r0 = one.r0;
        two.g0 = one.g0;
        two.b0 = one.b1;
        break;
      default:
        throw new Error('unexpected direction ' + direction);
    }

    one.vol = (one.r1 - one.r0) * (one.g1 - one.g0) * (one.b1 - one.b0);
    two.vol = (two.r1 - two.r0) * (two.g1 - two.g0) * (two.b1 - two.b0);
    return true;
  }

  private maximize(
      cube: ReferenceBox, direction: string, first: number, last: number,
      wholeR: number, wholeG: number, wholeB: number, wholeW: number) {
    const bottomR = this.bottom(cube, direction, this.momentsR);
    const bottomG = this.bottom(cube, direction, this.momentsG);
    const bottomB = this.bottom(cube, direction, this.momentsB);
    const bottomW = this.bottom(cube, direction, this.weights);

    let max = 0.0;
    let cut = -1;

    let halfR = 0;
    let halfG = 0;
    let halfB = 0;
    let halfW = 0;
    for (let i = first; i < last; i++) {
      halfR = bottomR + this.top(cube, direction, i, this.momentsR);
      halfG = bottomG + this.top(cube, direction, i, this.momentsG);
      halfB = bottomB + this.top(cube, direction, i, this.momentsB);
      halfW = bottomW + this.top(cube, direction, i, this.weights);
      if (halfW === 0) {
        continue;
      }

      let tempNumerator = (halfR * halfR + halfG * halfG + halfB * halfB) * 1.0;
      let tempDenominator = halfW * 1.0;
      let temp = tempNumerator / tempDenominator;

      halfR = wholeR - halfR;
      halfG = wholeG - halfG;
      halfB = wholeB - halfB;
      halfW = wholeW - halfW;
      if (halfW === 0) {
        continue;
      }

      tempNumerator = (halfR * halfR + halfG * halfG + halfB * halfB) * 1.0;
      tempDenominator = halfW * 1.0;
      temp += tempNumerator / tempDenominator;

      if (temp > max) {
        max = temp;
        cut = i;
      }
    }
    return new ReferenceMaximizeResult(cut, max);
  }

  private volume(cube: ReferenceBox, moment: number[]) {
    return (
        moment[this.getIndex(cube.r1, cube.g1, cube.b1)] -
        moment[this.getIndex(cube.r1, cube.g1, cube.b0)] -
        moment[this.getIndex(cube.r1, cube.g0, cube.b1)] +
        moment[this.getIndex(cube.r1, cube.g0, cube.b0)] -
        moment[this.getIndex(cube.r0, cube.g1, cube.b1)] +
        moment[this.getIndex(cube.r0, cube.g1, cube.b0)] +
        moment[this.getIndex(cube.r0, cube.g0, cube.b1)] -
        moment[this.getIndex(cube.r0, cube.g0, cube.b0)]);
  }

  private bottom(cube: ReferenceBox, direction: string, moment: number[]) {
    switch (direction) {
      case DIRECTIONS.RED:
        return (
            -moment[this.getIndex(cube.r0, cube.g1, cube.b1)] +
            moment[this.getIndex(cube.r0, cube.g1, cube.b0)] +
            moment[this.getIndex(cube.r0, cube.g0, cube.b1)] -
            moment[this.getIndex(cube.r0, cube.g0, cube.b0)]);
      case DIRECTIONS.GREEN:
        return (
            -moment[this.getIndex(cube.r1, cube.g0, cube.b1)] +
            moment[this.getIndex(cube.r1, cube.g0, cube.b0)] +
            moment[this.getIndex(cube.r0, cube.g0, cube.b1)] -
            moment[this.getIndex(cube.r0, cube.g0, cube.b0)]);
      case DIRECTIONS.BLUE:
        return (
            -moment[this.getIndex(cube.r1, cube.g1, cube.b0)] +
            moment[this.getIndex(cube.r1, cube.g0, cube.b0)] +
            moment[this.getIndex(cube.r0, cube.g1, cube.b0)] -
            moment[this.getIndex(cube.r0, cube.g0, cube.b0)]);
      default:
        throw new Error('unexpected direction $direction');
    }
  }

  private top(
      cube: ReferenceBox, direction: string, position: number,
      moment: number[]) {
    switch (direction) {
      case DIRECTIONS.RED:
        return (
            moment[this.getIndex(position, cube.g1, cube.b1)] -
            moment[this.getIndex(position, cube.g1, cube.b0)] -
            moment[this.getIndex(position, cube.g0, cube.b1)] +
            moment[this.getIndex(position, cube.g0, cube.b0)]);
      case DIRECTIONS.GREEN:
        return (
            moment[this.getIndex(cube.r1, position, cube.b1)] -
            moment[this.getIndex(cube.r1, position, cube.b0)] -
            moment[this.getIndex(cube.r0, position, cube.b1)] +
            moment[this.getIndex(cube.r0, position, cube.b0)]);
      case DIRECTIONS.BLUE:
        return (
            moment[this.getIndex(cube.r1, cube.g1, position)] -
            moment[this.getIndex(cube.r1, cube.g0, position)] -
            moment[this.getIndex(cube.r0, cube.g1, position)] +
            moment[this.getIndex(cube.r0, cube.g0, position)]);
      default:
        throw new Error('unexpected direction $direction');
    }
  }

  private getIndex(r: number, g: number, b: number): number {
    return (r << (INDEX_BITS * 2)) + (r << (INDEX_BITS + 1)) + r +
        (g << INDEX_BITS) + g + b;
  }
}

/**
 * Keeps track of the state of each box created as the Wu  quantization
 * algorithm progresses through dividing the image's pixels as plotted in RGB.
 */
class ReferenceBox {
  constructor(
      public r0: number = 0, public r1: number = 0, public g0: number = 0,
      public g1: number = 0, public b0: number = 0, public b1: number = 0,
      public vol: number = 0) {}
}

/**
 * Represents final result of Wu algorithm.
 */
class ReferenceCreateBoxesResult {
  /**
   * @param requestedCount how many colors the caller asked to be returned from
   *     quantization.
   * @param resultCount the actual number of colors achieved from quantization.
   *     May be lower than the requested count.
   */
  constructor(public requestedCount: number, public resultCount: number) {}
}

/**
 * Represents the result of calculating where to cut an existing box in such
 * a way to maximize variance between the two new boxes created by a cut.
 */
class ReferenceMaximizeResult {
  constructor(public cutLocation: number, public maximum: number) {}
}

const REFERENCE_MAX_ITERATIONS = 10;
const REFERENCE_MIN_MOVEMENT_DISTANCE = 3.0;

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
export class ReferenceQuantizerWsmeans {
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
    const random = new ReferenceSeededRandom(0x42688);

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

    const distanceToIndexMatrix = new Array<ReferenceDistanceAndIndex[]>();
    for (let i = 0; i < clusterCount; i++) {
      distanceToIndexMatrix.push(new Array<ReferenceDistanceAndIndex>());
      for (let j = 0; j < clusterCount; j++) {
        distanceToIndexMatrix[i].push(new ReferenceDistanceAndIndex());
      }
    }


    const pixelCountSums = new Array<number>();
    for (let i = 0; i < clusterCount; i++) {
      pixelCountSums.push(0);
    }
    for (let iteration = 0; iteration < REFERENCE_MAX_ITERATIONS; iteration++) {
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
          if (distanceChange > REFERENCE_MIN_MOVEMENT_DISTANCE) {
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
class ReferenceDistanceAndIndex {
  distance: number = -1;
  index: number = -1;
}

/**
 * Deterministic 48-bit LCG matching `java.util.Random` using two 24-bit words
 * so all intermediate products stay exact in IEEE-754 numbers (< 2^53).
 */
class ReferenceSeededRandom {
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
        (this.nextBits(26) * 0x8000000 + this.nextBits(27)) / 0x20000000000000);
  }
}

/**
 * An image quantizer that improves on the quality of a standard K-Means
 * algorithm by setting the K-Means initial state to the output of a Wu
 * quantizer, instead of random centroids. Improves on speed by several
 * optimizations, as implemented in Wsmeans, or Weighted Square Means, K-Means
 * with those optimizations.
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
export class ReferenceQuantizerCelebi {
  /**
   * @param pixels Colors in ARGB format.
   * @param maxColors The number of colors to divide the image into. A lower
   *     number of colors may be returned.
   * @return Map with keys of colors in ARGB format, and values of number of
   *     pixels in the original image that correspond to the color in the
   *     quantized image.
   */
  static quantize(pixels: number[], maxColors: number): Map<number, number> {
    const wu = new ReferenceQuantizerWu();
    const wuResult = wu.quantize(pixels, maxColors);
    return ReferenceQuantizerWsmeans.quantize(pixels, wuResult, maxColors);
  }
}
