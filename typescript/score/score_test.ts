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

import 'jasmine';

import {Score} from './score.js';

describe('scoring', () => {
  it('prioritizes chroma', () => {
    const colorsToPopulation = new Map<number, number>();
    colorsToPopulation.set(0xff000000, 1);
    colorsToPopulation.set(0xffffffff, 1);
    colorsToPopulation.set(0xff0000ff, 1);

    const ranked = Score.score(colorsToPopulation, {desired: 4});

    expect(ranked.length).toBe(1);
    expect(ranked[0]).toBe(0xff0000ff);
  });

  it('prioritizes chroma when proportions equal', () => {
    const colorsToPopulation = new Map<number, number>();
    colorsToPopulation.set(0xffff0000, 1);
    colorsToPopulation.set(0xff00ff00, 1);
    colorsToPopulation.set(0xff0000ff, 1);

    const ranked = Score.score(colorsToPopulation, {desired: 4});

    expect(ranked.length).toBe(3);
    expect(ranked[0]).toBe(0xffff0000);
    expect(ranked[1]).toBe(0xff00ff00);
    expect(ranked[2]).toBe(0xff0000ff);
  });

  it('generates gBlue when no colors available', () => {
    const colorsToPopulation = new Map<number, number>();
    colorsToPopulation.set(0xff000000, 1);

    const ranked = Score.score(colorsToPopulation, {desired: 4});

    expect(ranked.length).toBe(1);
    expect(ranked[0]).toBe(0xff4285f4);
  });

  it('dedupes nearby hues', () => {
    const colorsToPopulation = new Map<number, number>();
    colorsToPopulation.set(0xff008772, 1);  // H 180 C 42 T 50
    colorsToPopulation.set(0xff318477, 1);  // H 184 C 35 T 50

    const ranked = Score.score(colorsToPopulation, {desired: 4});

    expect(ranked.length).toBe(1);
    expect(ranked[0]).toBe(0xff008772);
  });

  it('maximizes hue distance', () => {
    const colorsToPopulation = new Map<number, number>();
    colorsToPopulation.set(0xff008772, 1);  // H 180 C 42 T 50
    colorsToPopulation.set(0xff008587, 1);  // H 198 C 50 T 50
    colorsToPopulation.set(0xff007ebc, 1);  // H 245 C 50 T 50

    const ranked = Score.score(colorsToPopulation, {desired: 2});

    expect(ranked.length).toBe(2);
    expect(ranked[0]).toBe(0xff007ebc);
    expect(ranked[1]).toBe(0xff008772);
  });

  it('passes generated scenario one', () => {
    const colorsToPopulation = new Map<number, number>();
    colorsToPopulation.set(0xff7ea16d, 67);
    colorsToPopulation.set(0xffd8ccae, 67);
    colorsToPopulation.set(0xff835c0d, 49);
  
    const ranked = Score.score(colorsToPopulation, {desired: 3, fallbackColorARGB: 0xff8d3819, filter: false});
  
    expect(ranked.length).toBe(3);
    expect(ranked[0]).toBe(0xff7ea16d);
    expect(ranked[1]).toBe(0xffd8ccae);
    expect(ranked[2]).toBe(0xff835c0d);
  });
  
  it('passes generated scenario two', () => {
    const colorsToPopulation = new Map<number, number>();
    colorsToPopulation.set(0xffd33881, 14);
    colorsToPopulation.set(0xff3205cc, 77);
    colorsToPopulation.set(0xff0b48cf, 36);
    colorsToPopulation.set(0xffa08f5d, 81);
  
    const ranked = Score.score(colorsToPopulation, {desired: 4, fallbackColorARGB: 0xff7d772b, filter: true});
  
    expect(ranked.length).toBe(3);
    expect(ranked[0]).toBe(0xff3205cc);
    expect(ranked[1]).toBe(0xffa08f5d);
    expect(ranked[2]).toBe(0xffd33881);
  });
  
  it('passes generated scenario three', () => {
    const colorsToPopulation = new Map<number, number>();
    colorsToPopulation.set(0xffbe94a6, 23);
    colorsToPopulation.set(0xffc33fd7, 42);
    colorsToPopulation.set(0xff899f36, 90);
    colorsToPopulation.set(0xff94c574, 82);
  
    const ranked = Score.score(colorsToPopulation, {desired: 3, fallbackColorARGB: 0xffaa79a4, filter: true});
  
    expect(ranked.length).toBe(3);
    expect(ranked[0]).toBe(0xff94c574);
    expect(ranked[1]).toBe(0xffc33fd7);
    expect(ranked[2]).toBe(0xffbe94a6);
  });
  
  it('passes generated scenario four', () => {
    const colorsToPopulation = new Map<number, number>();
    colorsToPopulation.set(0xffdf241c, 85);
    colorsToPopulation.set(0xff685859, 44);
    colorsToPopulation.set(0xffd06d5f, 34);
    colorsToPopulation.set(0xff561c54, 27);
    colorsToPopulation.set(0xff713090, 88);
  
    const ranked = Score.score(colorsToPopulation, {desired: 5, fallbackColorARGB: 0xff58c19c, filter: false});
  
    expect(ranked.length).toBe(2);
    expect(ranked[0]).toBe(0xffdf241c);
    expect(ranked[1]).toBe(0xff561c54);
  });
  
  it('passes generated scenario five', () => {
    const colorsToPopulation = new Map<number, number>();
    colorsToPopulation.set(0xffbe66f8, 41);
    colorsToPopulation.set(0xff4bbda9, 88);
    colorsToPopulation.set(0xff80f6f9, 44);
    colorsToPopulation.set(0xffab8017, 43);
    colorsToPopulation.set(0xffe89307, 65);
  
    const ranked = Score.score(colorsToPopulation, {desired: 3, fallbackColorARGB: 0xff916691, filter: false});
  
    expect(ranked.length).toBe(3);
    expect(ranked[0]).toBe(0xffab8017);
    expect(ranked[1]).toBe(0xff4bbda9);
    expect(ranked[2]).toBe(0xffbe66f8);
  });
  
  it('passes generated scenario six', () => {
    const colorsToPopulation = new Map<number, number>();
    colorsToPopulation.set(0xff18ea8f, 93);
    colorsToPopulation.set(0xff327593, 18);
    colorsToPopulation.set(0xff066a18, 53);
    colorsToPopulation.set(0xfffa8a23, 74);
    colorsToPopulation.set(0xff04ca1f, 62);
  
    const ranked = Score.score(colorsToPopulation, {desired: 2, fallbackColorARGB: 0xff4c377a, filter: false});
  
    expect(ranked.length).toBe(2);
    expect(ranked[0]).toBe(0xff18ea8f);
    expect(ranked[1]).toBe(0xfffa8a23);
  });
  
  it('passes generated scenario seven', () => {
    const colorsToPopulation = new Map<number, number>();
    colorsToPopulation.set(0xff2e05ed, 23);
    colorsToPopulation.set(0xff153e55, 90);
    colorsToPopulation.set(0xff9ab220, 23);
    colorsToPopulation.set(0xff153379, 66);
    colorsToPopulation.set(0xff68bcc3, 81);
  
    const ranked = Score.score(colorsToPopulation, {desired: 2, fallbackColorARGB: 0xfff588dc, filter: true});
  
    expect(ranked.length).toBe(2);
    expect(ranked[0]).toBe(0xff2e05ed);
    expect(ranked[1]).toBe(0xff9ab220);
  });
  
  it('passes generated scenario eight', () => {
    const colorsToPopulation = new Map<number, number>();
    colorsToPopulation.set(0xff816ec5, 24);
    colorsToPopulation.set(0xff6dcb94, 19);
    colorsToPopulation.set(0xff3cae91, 98);
    colorsToPopulation.set(0xff5b542f, 25);
  
    const ranked = Score.score(colorsToPopulation, {desired: 1, fallbackColorARGB: 0xff84b0fd, filter: false});
  
    expect(ranked.length).toBe(1);
    expect(ranked[0]).toBe(0xff3cae91);
  });
  
  it('passes generated scenario nine', () => {
    const colorsToPopulation = new Map<number, number>();
    colorsToPopulation.set(0xff206f86, 52);
    colorsToPopulation.set(0xff4a620d, 96);
    colorsToPopulation.set(0xfff51401, 85);
    colorsToPopulation.set(0xff2b8ebf, 3);
    colorsToPopulation.set(0xff277766, 59);
  
    const ranked = Score.score(colorsToPopulation, {desired: 3, fallbackColorARGB: 0xff02b415, filter: true});
  
    expect(ranked.length).toBe(3);
    expect(ranked[0]).toBe(0xfff51401);
    expect(ranked[1]).toBe(0xff4a620d);
    expect(ranked[2]).toBe(0xff2b8ebf);
  });
  
  it('passes generated scenario ten', () => {
    const colorsToPopulation = new Map<number, number>();
    colorsToPopulation.set(0xff8b1d99, 54);
    colorsToPopulation.set(0xff27effe, 43);
    colorsToPopulation.set(0xff6f558d, 2);
    colorsToPopulation.set(0xff77fdf2, 78);
  
    const ranked = Score.score(colorsToPopulation, {desired: 4, fallbackColorARGB: 0xff5e7a10, filter: true});
  
    expect(ranked.length).toBe(3);
    expect(ranked[0]).toBe(0xff27effe);
    expect(ranked[1]).toBe(0xff8b1d99);
    expect(ranked[2]).toBe(0xff6f558d);
  });
});
