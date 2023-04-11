/**
 * @license
 * Copyright 2023 Google LLC
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

import {Hct} from '../hct/hct.js';

import {TemperatureCache} from './temperature_cache.js';

describe('TemperatureCache', () => {
  it('computes raw temperatures correctly', () => {
    const blueTemp = TemperatureCache.rawTemperature(Hct.fromInt(0xff0000ff));
    expect(blueTemp).toBeCloseTo(-1.393, 3);

    const redTemp = TemperatureCache.rawTemperature(Hct.fromInt(0xffff0000));
    expect(redTemp).toBeCloseTo(2.351, 3);

    const greenTemp = TemperatureCache.rawTemperature(Hct.fromInt(0xff00ff00));
    expect(greenTemp).toBeCloseTo(-0.267, 3);

    const whiteTemp = TemperatureCache.rawTemperature(Hct.fromInt(0xffffffff));
    expect(whiteTemp).toBeCloseTo(-0.5, 3);

    const blackTemp = TemperatureCache.rawTemperature(Hct.fromInt(0xff000000));
    expect(blackTemp).toBeCloseTo(-0.5, 3);
  });

  it('relative temperature', () => {
    const blueTemp =
        new TemperatureCache(Hct.fromInt(0xff0000ff)).inputRelativeTemperature;
    expect(blueTemp).toBeCloseTo(0.0, 3);

    const redTemp =
        new TemperatureCache(Hct.fromInt(0xffff0000)).inputRelativeTemperature;
    expect(redTemp).toBeCloseTo(1.0, 3);

    const greenTemp =
        new TemperatureCache(Hct.fromInt(0xff00ff00)).inputRelativeTemperature;
    expect(greenTemp).toBeCloseTo(0.467, 3);

    const whiteTemp =
        new TemperatureCache(Hct.fromInt(0xffffffff)).inputRelativeTemperature;
    expect(whiteTemp).toBeCloseTo(0.5, 3);

    const blackTemp =
        new TemperatureCache(Hct.fromInt(0xff000000)).inputRelativeTemperature;
    expect(blackTemp).toBeCloseTo(0.5, 3);
  });

  it('complement', () => {
    const blueComplement =
        new TemperatureCache(Hct.fromInt(0xff0000ff)).complement.toInt();
    expect(blueComplement).toBe(0xff9D0002);

    const redComplement =
        new TemperatureCache(Hct.fromInt(0xffff0000)).complement.toInt();
    expect(redComplement).toBe(0xff007BFC);

    const greenComplement =
        new TemperatureCache(Hct.fromInt(0xff00ff00)).complement.toInt();
    expect(greenComplement).toBe(0xffFFD2C9);

    const whiteComplement =
        new TemperatureCache(Hct.fromInt(0xffffffff)).complement.toInt();
    expect(whiteComplement).toBe(0xffffffff);

    const blackComplement =
        new TemperatureCache(Hct.fromInt(0xff000000)).complement.toInt();
    expect(blackComplement).toBe(0xff000000);
  });

  it('analogous', () => {
    const blueAnalogous = new TemperatureCache(Hct.fromInt(0xff0000ff))
                              .analogous()
                              .map((e) => e.toInt());
    expect(blueAnalogous[0]).toBe(0xff00590C);
    expect(blueAnalogous[1]).toBe(0xff00564E);
    expect(blueAnalogous[2]).toBe(0xff0000ff);
    expect(blueAnalogous[3]).toBe(0xff6700CC);
    expect(blueAnalogous[4]).toBe(0xff81009F);

    const redAnalogous = new TemperatureCache(Hct.fromInt(0xffff0000))
                             .analogous()
                             .map((e) => e.toInt());
    expect(redAnalogous[0]).toBe(0xffF60082);
    expect(redAnalogous[1]).toBe(0xffFC004C);
    expect(redAnalogous[2]).toBe(0xffff0000);
    expect(redAnalogous[3]).toBe(0xffD95500);
    expect(redAnalogous[4]).toBe(0xffAF7200);

    const greenAnalogous = new TemperatureCache(Hct.fromInt(0xff00ff00))
                               .analogous()
                               .map((e) => e.toInt());
    expect(greenAnalogous[0]).toBe(0xffCEE900);
    expect(greenAnalogous[1]).toBe(0xff92F500);
    expect(greenAnalogous[2]).toBe(0xff00ff00);
    expect(greenAnalogous[3]).toBe(0xff00FD6F);
    expect(greenAnalogous[4]).toBe(0xff00FAB3);

    const blackAnalogous = new TemperatureCache(Hct.fromInt(0xff000000))
                               .analogous()
                               .map((e) => e.toInt());
    expect(blackAnalogous[0]).toBe(0xff000000);
    expect(blackAnalogous[1]).toBe(0xff000000);
    expect(blackAnalogous[2]).toBe(0xff000000);
    expect(blackAnalogous[3]).toBe(0xff000000);
    expect(blackAnalogous[4]).toBe(0xff000000);

    const whiteAnalogous = new TemperatureCache(Hct.fromInt(0xffffffff))
                               .analogous()
                               .map((e) => e.toInt());
    expect(whiteAnalogous[0]).toBe(0xffffffff);
    expect(whiteAnalogous[1]).toBe(0xffffffff);
    expect(whiteAnalogous[2]).toBe(0xffffffff);
    expect(whiteAnalogous[3]).toBe(0xffffffff);
    expect(whiteAnalogous[4]).toBe(0xffffffff);
  });
});
