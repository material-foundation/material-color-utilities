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

import {Hct} from '../hct/hct.js';

/**
 *  A convenience class for retrieving colors that are constant in hue and
 *  chroma, but vary in tone.
 */
export class TonalPalette {
  private readonly cache = new Map<number, number>();

  /**
   * @param argb ARGB representation of a color
   * @return Tones matching that color's hue and chroma.
   */
  static fromInt(argb: number): TonalPalette {
    const hct = Hct.fromInt(argb);
    return TonalPalette.fromHct(hct);
  }

  /**
   * @param hct Hct
   * @return Tones matching that color's hue and chroma.
   */
  static fromHct(hct: Hct) {
    return new TonalPalette(hct.hue, hct.chroma, hct);
  }

  /**
   * @param hue HCT hue
   * @param chroma HCT chroma
   * @return Tones matching hue and chroma.
   */
  static fromHueAndChroma(hue: number, chroma: number): TonalPalette {
    return new TonalPalette(hue, chroma, TonalPalette.createKeyColor(hue, chroma));
  }

  private constructor(readonly hue: number, readonly chroma: number, readonly keyColor: Hct) {}

  private static createKeyColor(hue: number, chroma: number): Hct {
    const startTone = 50.0;
    let smallestDeltaHct = Hct.from(hue, chroma, startTone);
    let smallestDelta = Math.abs(smallestDeltaHct.chroma - chroma);
    // Starting from T50, check T+/-delta to see if they match the requested
    // chroma.
    //
    // Starts from T50 because T50 has the most chroma available, on
    // average. Thus it is most likely to have a direct answer and minimize
    // iteration.
    for (let delta = 1.0; delta < 50.0; delta += 1.0) {
      // Termination condition rounding instead of minimizing delta to avoid
      // case where requested chroma is 16.51, and the closest chroma is 16.49.
      // Error is minimized, but when rounded and displayed, requested chroma
      // is 17, key color's chroma is 16.
      if (Math.round(chroma) === Math.round(smallestDeltaHct.chroma)) {
        return smallestDeltaHct;
      }

      const hctAdd = Hct.from(hue, chroma, startTone + delta);
      const hctAddDelta = Math.abs(hctAdd.chroma - chroma);
      if (hctAddDelta < smallestDelta) {
        smallestDelta = hctAddDelta;
        smallestDeltaHct = hctAdd;
      }

      const hctSubtract = Hct.from(hue, chroma, startTone - delta);
      const hctSubtractDelta = Math.abs(hctSubtract.chroma - chroma);
      if (hctSubtractDelta < smallestDelta) {
        smallestDelta = hctSubtractDelta;
        smallestDeltaHct = hctSubtract;
      }
    }

    return smallestDeltaHct;
  }

  /**
   * @param tone HCT tone, measured from 0 to 100.
   * @return ARGB representation of a color with that tone.
   */
  tone(tone: number): number {
    let argb = this.cache.get(tone);
    if (argb === undefined) {
      argb = Hct.from(this.hue, this.chroma, tone).toInt();
      this.cache.set(tone, argb);
    }
    return argb;
  }

  /**
   * @param tone HCT tone.
   * @return HCT representation of a color with that tone.
   */
  getHct(tone: number): Hct {
    return Hct.fromInt(this.tone(tone));
  }
}
