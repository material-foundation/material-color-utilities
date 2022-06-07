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

import * as colorUtils from '../utils/color_utils';

import {Cam16} from './cam16';
import {Hct} from './hct';
import {ViewingConditions} from './viewing_conditions';

const RED = 0xffff0000;
const GREEN = 0xff00ff00;
const BLUE = 0xff0000ff;
const WHITE = 0xffffffff;
const BLACK = 0xff000000;

describe('CAM to ARGB', () => {
  it('red', () => {
    const cam = Cam16.fromInt(RED);

    expect(cam.hue).toBeCloseTo(27.408, 3);
    expect(cam.chroma).toBeCloseTo(113.358, 3);
    expect(cam.j).toBeCloseTo(46.445, 3);
    expect(cam.m).toBeCloseTo(89.494, 3);
    expect(cam.s).toBeCloseTo(91.890, 3);
    expect(cam.q).toBeCloseTo(105.989, 3);
  });

  it('green', () => {
    const cam = Cam16.fromInt(GREEN);

    expect(cam.hue).toBeCloseTo(142.140, 3);
    expect(cam.chroma).toBeCloseTo(108.410, 3);
    expect(cam.j).toBeCloseTo(79.332, 3);
    expect(cam.m).toBeCloseTo(85.588, 3);
    expect(cam.s).toBeCloseTo(78.605, 3);
    expect(cam.q).toBeCloseTo(138.520, 3);
  });

  it('blue', () => {
    const cam = Cam16.fromInt(BLUE);

    expect(cam.hue).toBeCloseTo(282.788, 3);
    expect(cam.chroma).toBeCloseTo(87.231, 3);
    expect(cam.j).toBeCloseTo(25.466, 3);
    expect(cam.m).toBeCloseTo(68.867, 3);
    expect(cam.s).toBeCloseTo(93.675, 3);
    expect(cam.q).toBeCloseTo(78.481, 3);
  });

  it('white', () => {
    const cam = Cam16.fromInt(WHITE);

    expect(cam.hue).toBeCloseTo(209.492, 3);
    expect(cam.chroma).toBeCloseTo(2.869, 3);
    expect(cam.j).toBeCloseTo(100.0, 3);
    expect(cam.m).toBeCloseTo(2.265, 3);
    expect(cam.s).toBeCloseTo(12.068, 3);
    expect(cam.q).toBeCloseTo(155.521, 3);
  });

  it('black', () => {
    const cam = Cam16.fromInt(BLACK);

    expect(cam.hue).toBeCloseTo(0.0, 3);
    expect(cam.chroma).toBeCloseTo(0.0, 3);
    expect(cam.j).toBeCloseTo(0.0, 3);
    expect(cam.m).toBeCloseTo(0.0, 3);
    expect(cam.s).toBeCloseTo(0.0, 3);
    expect(cam.q).toBeCloseTo(0.0, 3);
  });
});

describe('CAM to ARGB to CAM', () => {
  it('red', () => {
    const cam = Cam16.fromInt(RED);
    const argb = cam.toInt();
    expect(argb).toEqual(RED);
  });

  it('green', () => {
    const cam = Cam16.fromInt(GREEN);
    const argb = cam.toInt();
    expect(argb).toEqual(GREEN);
  });

  it('blue', () => {
    const cam = Cam16.fromInt(BLUE);
    const argb = cam.toInt();
    expect(argb).toEqual(BLUE);
  });
});

describe('ARGB to HCT', () => {
  it('green', () => {
    const hct = Hct.fromInt(GREEN);
    expect(hct.hue).toBeCloseTo(142.139, 2);
    expect(hct.chroma).toBeCloseTo(108.410, 2);
    expect(hct.tone).toBeCloseTo(87.737, 2);
  });

  it('blue', () => {
    const hct = Hct.fromInt(BLUE);
    expect(hct.hue).toBeCloseTo(282.788, 2);
    expect(hct.chroma).toBeCloseTo(87.230, 2);
    expect(hct.tone).toBeCloseTo(32.302, 2);
  });

  it('blue tone 90', () => {
    const hct = Hct.from(282.788, 87.230, 90.0);
    expect(hct.hue).toBeCloseTo(282.239, 2);
    expect(hct.chroma).toBeCloseTo(19.144, 2);
    expect(hct.tone).toBeCloseTo(90.035, 2);
  });
});


describe('viewing conditions', () => {
  it('default', () => {
    const vc = ViewingConditions.DEFAULT;
    expect(vc.n).toBeCloseTo(0.184, 3);
    expect(vc.aw).toBeCloseTo(29.981, 3);
    expect(vc.nbb).toBeCloseTo(1.017, 3);
    expect(vc.ncb).toBeCloseTo(1.017, 3);
    expect(vc.c).toBeCloseTo(0.69, 3);
    expect(vc.nc).toBeCloseTo(1.0, 3);
    expect(vc.rgbD[0]).toBeCloseTo(1.021, 3);
    expect(vc.rgbD[1]).toBeCloseTo(0.986, 3);
    expect(vc.rgbD[2]).toBeCloseTo(0.934, 3);
    expect(vc.fl).toBeCloseTo(0.388, 3);
    expect(vc.fLRoot).toBeCloseTo(0.789, 3);
    expect(vc.z).toBeCloseTo(1.909, 3);
  });
});

function colorIsOnBoundary(argb: number): boolean {
  return colorUtils.redFromArgb(argb) === 0 ||
      colorUtils.redFromArgb(argb) === 255 ||
      colorUtils.greenFromArgb(argb) === 0 ||
      colorUtils.greenFromArgb(argb) === 255 ||
      colorUtils.blueFromArgb(argb) === 0 ||
      colorUtils.blueFromArgb(argb) === 255;
}

describe('CamSolver', () => {
  it('returns a sufficiently close color', () => {
    for (let hue = 15; hue < 360; hue += 30) {
      for (let chroma = 0; chroma <= 100; chroma += 10) {
        for (let tone = 20; tone <= 80; tone += 10) {
          const hctColor = Hct.from(hue, chroma, tone);

          if (chroma > 0) {
            expect(Math.abs(hctColor.hue - hue)).toBeLessThanOrEqual(4.0);
          }

          expect(hctColor.chroma).toBeGreaterThanOrEqual(0);
          expect(hctColor.chroma).toBeLessThanOrEqual(chroma + 2.5);

          if (hctColor.chroma < chroma - 2.5) {
            expect(colorIsOnBoundary(hctColor.toInt())).toBe(true);
          }

          expect(Math.abs(hctColor.tone - tone)).toBeLessThanOrEqual(0.5);
        }
      }
    }
  });
});
