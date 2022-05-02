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

import * as mathUtils from './math_utils';

function rotationDirection(from: number, to: number): number {
  const a = to - from;
  const b = to - from + 360.0;
  const c = to - from - 360.0;
  const aAbs = Math.abs(a);
  const bAbs = Math.abs(b);
  const cAbs = Math.abs(c);
  if (aAbs <= bAbs && aAbs <= cAbs) {
    return a >= 0.0 ? 1.0 : -1.0;
  } else if (bAbs <= aAbs && bAbs <= cAbs) {
    return b >= 0.0 ? 1.0 : -1.0;
  } else {
    return c >= 0.0 ? 1.0 : -1.0;
  }
}

describe('rotationDirection', () => {
  it('is identical to the original implementation', () => {
    for (let from = 0.0; from < 360.0; from += 15.0) {
      for (let to = 7.5; to < 360.0; to += 15.0) {
        const expectedAnswer = rotationDirection(from, to);
        const actualAnswer = mathUtils.rotationDirection(from, to);
        expect(actualAnswer).toBe(expectedAnswer);
        expect(Math.abs(actualAnswer)).toBe(1.0);
      }
    }
  });
});
