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

import 'jasmine';

import * as utils from '../utils/color_utils.js';

import {labFromArgbInto} from './lab_conversion.js';
import {QuantizerCelebi} from './quantizer_celebi.js';
import {QuantizerWsmeans} from './quantizer_wsmeans.js';
import {QuantizerWu} from './quantizer_wu.js';
import {ReferenceQuantizerCelebi, ReferenceQuantizerWsmeans, ReferenceQuantizerWu} from './reference_quantizers';

/**
 * Checks that the optimized quantizers return exactly what the frozen copies
 * of the previous code in reference_quantizers.ts return: the same colors, with
 * the same counts, in the same order, and the same kind of error.
 */

/** A small deterministic random number generator for test images. */
class TestRandom {
  private state: number;

  constructor(seed: number) {
    this.state = seed >>> 0;
  }

  /** Returns a random integer in [0, bound). */
  nextInt(bound: number): number {
    this.state = (Math.imul(this.state, 1664525) + 1013904223) >>> 0;
    return Math.floor((this.state / 0x100000000) * bound);
  }
}

/** Returns the result, or the name of the type of the error thrown. */
function outcome<T>(f: () => T): T|string {
  try {
    return f();
  } catch (e: unknown) {
    return `throws ${(e as Error).constructor.name}`;
  }
}

/** Checks that two calls return equal results, with Maps in the same order. */
function expectSameOutcome<T>(
    expected: () => T, actual: () => T, description: string) {
  const expectedOutcome = outcome(expected);
  const actualOutcome = outcome(actual);
  if (expectedOutcome instanceof Map && actualOutcome instanceof Map) {
    expect([...actualOutcome.entries()]).withContext(description).toEqual([
      ...expectedOutcome.entries()
    ]);
  } else {
    expect(actualOutcome).withContext(description).toEqual(expectedOutcome);
  }
}

function opaque(red: number, green: number, blue: number): number {
  return utils.argbFromRgb(red, green, blue);
}

/** Pixels with random colors, almost all distinct. */
function noiseImage(random: TestRandom, size: number): number[] {
  const pixels: number[] = [];
  for (let i = 0; i < size; i++) {
    pixels.push(
        opaque(random.nextInt(256), random.nextInt(256), random.nextInt(256)));
  }
  return pixels;
}

/** Pixels that use a few random colors. */
function paletteImage(
    random: TestRandom, size: number, colorCount: number): number[] {
  const palette = noiseImage(random, colorCount);
  const pixels: number[] = [];
  for (let i = 0; i < size; i++) {
    pixels.push(palette[random.nextInt(colorCount)]);
  }
  return pixels;
}

/** Smooth gradients with some noise, like a photo. */
function photoImage(random: TestRandom, width: number, height: number) {
  const pixels: number[] = [];
  const clamp = (value: number) =>
      Math.max(0, Math.min(255, Math.round(value)));
  for (let y = 0; y < height; y++) {
    for (let x = 0; x < width; x++) {
      const noise = () => random.nextInt(9) - 4;
      pixels.push(opaque(
          clamp((x * 255) / width + noise()),
          clamp(128 + 100 * Math.sin(y / 9) + noise()),
          clamp(((x + y) * 255) / (width + height) + noise())));
    }
  }
  return pixels;
}

/** The same colors, as signed 32-bit integers. */
function signed(pixels: number[]): number[] {
  return pixels.map((pixel) => pixel | 0);
}

/** The same colors, some signed and some unsigned. */
function mixedSign(random: TestRandom, pixels: number[]): number[] {
  return pixels.map(
      (pixel) => random.nextInt(2) === 0 ? pixel | 0 : pixel >>> 0);
}

/** The same colors, with random alpha values. */
function randomAlpha(random: TestRandom, pixels: number[]): number[] {
  return pixels.map(
      (pixel) => ((pixel & 0xffffff) | (random.nextInt(256) << 24)) >>> 0);
}

function testImages(): Array<[string, number[]]> {
  const random = new TestRandom(0x5eed);
  const photo = photoImage(random, 128, 96);
  return [
    ['empty', []],
    ['one pixel', [opaque(12, 34, 56)]],
    ['one color', new Array<number>(500).fill(opaque(200, 10, 10))],
    ['black and white', [opaque(0, 0, 0), opaque(255, 255, 255)]],
    ['3 colors', paletteImage(random, 300, 3)],
    ['40 colors', paletteImage(random, 4000, 40)],
    ['400 colors', paletteImage(random, 8000, 400)],
    ['noise', noiseImage(random, 6000)],
    ['photo', photo],
    ['photo, signed', signed(photo)],
    ['photo, mixed sign', mixedSign(random, photo)],
    ['photo, random alpha', randomAlpha(random, photo)],
    ['large photo', photoImage(random, 256, 256)],
    // Not valid colors, but the same as with a Map of pixels to counts.
    [
      'NaN, zeros and missing pixels',
      [NaN, 0, -0, NaN, undefined, opaque(1, 2, 3), undefined, 0] as unknown as
          number[]
    ],
  ];
}

describe('QuantizerEquivalence', () => {
  it('converts every color to Lab exactly like labFromArgb', () => {
    const lab = new Float64Array(3);
    let mismatches = 0;
    for (let rgb = 0; rgb < 0x1000000; rgb++) {
      const argb = (0xff000000 | rgb) >>> 0;
      const expected = utils.labFromArgb(argb);
      labFromArgbInto(argb, lab, 0);
      if (!Object.is(lab[0], expected[0]) || !Object.is(lab[1], expected[1]) ||
          !Object.is(lab[2], expected[2])) {
        mismatches++;
      }
    }
    expect(mismatches).toBe(0);
  });

  it('QuantizerCelebi returns the same results', () => {
    for (const [name, pixels] of testImages()) {
      for (const maxColors of [128, 16, 1, 2, 3, 255, 256]) {
        expectSameOutcome(
            () => ReferenceQuantizerCelebi.quantize(pixels, maxColors),
            () => QuantizerCelebi.quantize(pixels, maxColors),
            `${name}, maxColors ${maxColors}`);
      }
    }
  });

  it('QuantizerWu returns the same results', () => {
    for (const [name, pixels] of testImages()) {
      for (const maxColors of [128, 16, 1, 256]) {
        expectSameOutcome(
            () => new ReferenceQuantizerWu().quantize(pixels, maxColors),
            () => new QuantizerWu().quantize(pixels, maxColors),
            `${name}, maxColors ${maxColors}`);
      }
    }
  });

  it('QuantizerWsmeans returns the same results for any starting clusters',
     () => {
       const random = new TestRandom(0xc105);
       for (const [name, pixels] of testImages()) {
         const startingClusterLists: Array<[string, number[]]> = [
           ['no starting clusters', []],
           ['1 starting cluster', noiseImage(random, 1)],
           ['duplicate starting clusters', paletteImage(random, 40, 5)],
           ['too many starting clusters', noiseImage(random, 300)],
           ['starting clusters from the image', pixels.slice(0, 20)],
         ];
         for (const [clustersName, startingClusters] of startingClusterLists) {
           for (const maxColors of [128, 16, 1, 256]) {
             expectSameOutcome(
                 () => ReferenceQuantizerWsmeans.quantize(
                     pixels, startingClusters, maxColors),
                 () => QuantizerWsmeans.quantize(
                     pixels, startingClusters, maxColors),
                 `${name}, ${clustersName}, maxColors ${maxColors}`);
           }
         }
       }
     });

  it('throws the same errors for invalid maxColors', () => {
    const random = new TestRandom(0xe7707);
    const images: Array<[string, number[]]> = [
      ['empty', []],
      ['one pixel', [opaque(1, 2, 3)]],
      ['40 colors', paletteImage(random, 400, 40)],
    ];
    for (const [name, pixels] of images) {
      for (const maxColors of [0, -1, -128, NaN]) {
        expectSameOutcome(
            () => ReferenceQuantizerCelebi.quantize(pixels, maxColors),
            () => QuantizerCelebi.quantize(pixels, maxColors),
            `QuantizerCelebi, ${name}, maxColors ${maxColors}`);
        for (const startingClusters of [[], [opaque(9, 9, 9)]]) {
          expectSameOutcome(
              () => ReferenceQuantizerWsmeans.quantize(
                  pixels, startingClusters, maxColors),
              () => QuantizerWsmeans.quantize(
                  pixels, startingClusters, maxColors),
              `QuantizerWsmeans, ${name}, ${
                  startingClusters.length} starting clusters, maxColors ${
                  maxColors}`);
        }
      }
    }
  });

  it('throws for non-integer maxColors, as before', () => {
    // The kind of error used to depend on the random cluster indices, so only
    // check that both throw.
    const random = new TestRandom(0xf2ac);
    const pixels = paletteImage(random, 400, 40);
    for (const maxColors of [0.5, 1.5, 2.5]) {
      for (const startingClusters of [[], noiseImage(random, 5)]) {
        const description = `${startingClusters.length} starting clusters, ` +
            `maxColors ${maxColors}`;
        expect(
            () => ReferenceQuantizerWsmeans.quantize(
                pixels, startingClusters, maxColors))
            .withContext(description)
            .toThrow();
        expect(
            () =>
                QuantizerWsmeans.quantize(pixels, startingClusters, maxColors))
            .withContext(description)
            .toThrow();
      }
    }
  });
});
