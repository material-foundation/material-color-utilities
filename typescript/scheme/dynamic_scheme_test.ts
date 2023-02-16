/**
 * @license
 * Copyright 2022 Google LLC
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

import {DynamicScheme} from './dynamic_scheme.js';
import {Hct} from '../hct/hct.js';

describe('dynamic scheme test', () => {
  it('0 length input', () => {
    const hue = DynamicScheme.getRotatedHue(Hct.from(43, 16, 16), [], []);
    expect(hue).toBeCloseTo(43, 0.4);
  });

  it('1 length input no rotation', () => {
    const hue = DynamicScheme.getRotatedHue(Hct.from(43, 16, 16), [0], [0]);
    expect(hue).toBeCloseTo(43, 0.4);
  });

  it('input length mismatch asserts', () => {
    expect(() => {
      DynamicScheme.getRotatedHue(Hct.from(43, 16, 16), [0, 1], [0]);
    }).toThrow();
  });

  it('on boundary rotation correct', () => {
    const hue = DynamicScheme.getRotatedHue(
      Hct.from(43, 16, 16),
      [0, 42, 360],
      [0, 15, 0],
    );
    expect(hue).toBeCloseTo(43 + 15, 0.4);
  });

  it('rotation result larger than 360 degrees wraps', () => {
    const hue = DynamicScheme.getRotatedHue(
      Hct.from(43, 16, 16),
      [0, 42, 360],
      [0, 480, 0],
    );
    expect(hue).toBeCloseTo(163, 0.4);
  });
});
