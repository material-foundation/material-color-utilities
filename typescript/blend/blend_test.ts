/**
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

import {Blend} from 'blend/blend';
import * as utils from 'utils/color_utils';

const RED = 0xffff0000;
const BLUE = 0xff0000ff;

describe('blend red to blue', () => {
  it('cam16-ucs', () => {
    const answer = Blend.cam16ucs(RED, BLUE, 0.8);
    expect(utils.hexFromInt(answer)).toBe('#6440b4');
  });

  it('hct hue', () => {
    const answer = Blend.hctHue(RED, BLUE, 0.8);
    expect(utils.hexFromInt(answer)).toBe('#925dff');
  });

  it('harmonize', () => {
    const answer = Blend.harmonize(RED, BLUE);
    expect(utils.hexFromInt(answer)).toBe('#fb005a');
  });
});
