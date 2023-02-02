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

import {Contrast} from './contrast.js';

describe('contrast', () => {
  it('ratioOfTones_outOfBoundsInput', () => {
    expect(21.0).toBeCloseTo(Contrast.ratioOfTones(-10.0, 110.0), 0.001);
  });

  it('lighter_impossibleRatioErrors', () => {
    expect(-1.0).toBeCloseTo(Contrast.lighter(90.0, 10.0), 0.001);
  });

  it('lighter_outOfBoundsInputAboveErrors', () => {
    expect(-1.0).toBeCloseTo(Contrast.lighter(110.0, 2.0), 0.001);
  });

  it('lighter_outOfBoundsInputBelowErrors', () => {
    expect(-1.0).toBeCloseTo(Contrast.lighter(-10.0, 2.0), 0.001);
  });

  it('lighterUnsafe_returnsMaxTone', () => {
    expect(100).toBeCloseTo(Contrast.lighterUnsafe(100.0, 2.0), 0.001);
  });

  it('darker_impossibleRatioErrors', () => {
    expect(-1.0).toBeCloseTo(Contrast.darker(10.0, 20.0), 0.001);
  });

  it('darker_outOfBoundsInputAboveErrors', () => {
    expect(-1.0).toBeCloseTo(Contrast.darker(110.0, 2.0), 0.001);
  });

  it('darker_outOfBoundsInputBelowErrors', () => {
    expect(-1.0).toBeCloseTo(Contrast.darker(-10.0, 2.0), 0.001);
  });

  it('darkerUnsafe_returnsMinTone', () => {
    expect(0.0).toBeCloseTo(Contrast.darkerUnsafe(0.0, 2.0), 0.001);
  });
});