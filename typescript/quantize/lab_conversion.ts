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

import * as utils from '../utils/color_utils.js';

/** utils.linearized() of each 8-bit channel value. */
const LINEARIZED = (() => {
  const table = new Float64Array(256);
  for (let i = 0; i < 256; i++) {
    table[i] = utils.linearized(i);
  }
  return table;
})();

/** Same as the private labF() in color_utils. */
function labF(t: number): number {
  const e = 216.0 / 24389.0;
  const kappa = 24389.0 / 27.0;
  if (t > e) {
    // Not Math.cbrt(t): it can differ from Math.pow(t, 1 / 3) in the last bit.
    return Math.pow(t, 1.0 / 3.0);
  } else {
    return (kappa * t + 16) / 116;
  }
}

/**
 * Converts a color from ARGB to L*a*b* and writes L*, a* and b* to
 * out[offset], out[offset + 1] and out[offset + 2].
 *
 * Gives exactly the same values as utils.labFromArgb(), but looks up the
 * linearized channels in a table and does not allocate an array.
 */
export function labFromArgbInto(
    argb: number, out: Float64Array, offset: number) {
  const linearR = LINEARIZED[argb >> 16 & 255];
  const linearG = LINEARIZED[argb >> 8 & 255];
  const linearB = LINEARIZED[argb & 255];
  // The same constants and operation order as SRGB_TO_XYZ and WHITE_POINT_D65
  // in utils.labFromArgb().
  const x = 0.41233895 * linearR + 0.35762064 * linearG + 0.18051042 * linearB;
  const y = 0.2126 * linearR + 0.7152 * linearG + 0.0722 * linearB;
  const z = 0.01932141 * linearR + 0.11916382 * linearG + 0.95034478 * linearB;
  const fx = labF(x / 95.047);
  const fy = labF(y / 100.0);
  const fz = labF(z / 108.883);
  out[offset] = 116.0 * fy - 16;
  out[offset + 1] = 500.0 * (fx - fy);
  out[offset + 2] = 200.0 * (fy - fz);
}
