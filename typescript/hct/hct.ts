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

/**
 * A color system built using CAM16 hue and chroma, and L* from
 * L*a*b*.
 *
 * Using L* creates a link between the color system, contrast, and thus
 * accessibility. Contrast ratio depends on relative luminance, or Y in the XYZ
 * color space. L*, or perceptual luminance can be calculated from Y.
 *
 * Unlike Y, L* is linear to human perception, allowing trivial creation of
 * accurate color tones.
 *
 * Unlike contrast ratio, measuring contrast in L* is linear, and simple to
 * calculate. A difference of 40 in HCT tone guarantees a contrast ratio >= 3.0,
 * and a difference of 50 guarantees a contrast ratio >= 4.5.
 */

import * as utils from '../utils/color_utils';

import {Cam16} from './cam16';
import {HctSolver} from './hct_solver';


/**
 * HCT, hue, chroma, and tone. A color system that provides a perceptually
 * accurate color measurement system that can also accurately render what colors
 * will appear as in different lighting environments.
 */
export class Hct {
  /**
   * @param hue 0 <= hue < 360; invalid values are corrected.
   * @param chroma 0 <= chroma < ?; Informally, colorfulness. The color
   *     returned may be lower than the requested chroma. Chroma has a different
   *     maximum for any given hue and tone.
   * @param tone 0 <= tone <= 100; invalid values are corrected.
   * @return HCT representation of a color in default viewing conditions.
   */

  internalHue: number;
  internalChroma: number;
  internalTone: number;

  static from(hue: number, chroma: number, tone: number) {
    return new Hct(HctSolver.solveToInt(hue, chroma, tone));
  }

  /**
   * @param argb ARGB representation of a color.
   * @return HCT representation of a color in default viewing conditions
   */
  static fromInt(argb: number) {
    return new Hct(argb);
  }

  toInt(): number {
    return this.argb;
  }

  /**
   * A number, in degrees, representing ex. red, orange, yellow, etc.
   * Ranges from 0 <= hue < 360.
   */
  get hue(): number {
    return this.internalHue;
  }

  /**
   * @param newHue 0 <= newHue < 360; invalid values are corrected.
   * Chroma may decrease because chroma has a different maximum for any given
   * hue and tone.
   */
  set hue(newHue: number) {
    this.setInternalState(
        HctSolver.solveToInt(
            newHue,
            this.internalChroma,
            this.internalTone,
            ),
    );
  }

  get chroma(): number {
    return this.internalChroma;
  }

  /**
   * @param newChroma 0 <= newChroma < ?
   * Chroma may decrease because chroma has a different maximum for any given
   * hue and tone.
   */
  set chroma(newChroma: number) {
    this.setInternalState(
        HctSolver.solveToInt(
            this.internalHue,
            newChroma,
            this.internalTone,
            ),
    );
  }

  /** Lightness. Ranges from 0 to 100. */
  get tone(): number {
    return this.internalTone;
  }

  /**
   * @param newTone 0 <= newTone <= 100; invalid valids are corrected.
   * Chroma may decrease because chroma has a different maximum for any given
   * hue and tone.
   */
  set tone(newTone: number) {
    this.setInternalState(
        HctSolver.solveToInt(
            this.internalHue,
            this.internalChroma,
            newTone,
            ),
    );
  }

  private constructor(private argb: number) {
    const cam = Cam16.fromInt(argb);
    this.internalHue = cam.hue;
    this.internalChroma = cam.chroma;
    this.internalTone = utils.lstarFromArgb(argb);
    this.argb = argb;
  }

  private setInternalState(argb: number) {
    const cam = Cam16.fromInt(argb);
    this.internalHue = cam.hue;
    this.internalChroma = cam.chroma;
    this.internalTone = utils.lstarFromArgb(argb);
    this.argb = argb;
  }
}
