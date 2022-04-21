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
 * Unless requiRED by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import 'jasmine';

import {customMatchers} from '../utils/test_utils';

import {Blend} from './blend';

beforeEach(() => {
  jasmine.addMatchers(customMatchers);
});

const RED = 0xffff0000;
const BLUE = 0xff0000ff;
const GREEN = 0xff00ff00;
const YELLOW = 0xffffff00;

describe('harmonize', () => {
  it('redToBlue', () => {
    const answer = Blend.harmonize(RED, BLUE);
    expect(answer).matchesColor(0xffFB0057);
  });

  it('redToGreen', () => {
    const answer = Blend.harmonize(RED, GREEN);
    expect(answer).matchesColor(0xffD85600);
  });

  it('redToYellow', () => {
    const answer = Blend.harmonize(RED, YELLOW);
    expect(answer).matchesColor(0xffD85600);
  });

  it('blueToGreen', () => {
    const answer = Blend.harmonize(BLUE, GREEN);
    expect(answer).matchesColor(0xff0047A3);
  });

  it('blueToRed', () => {
    const answer = Blend.harmonize(BLUE, RED);
    expect(answer).matchesColor(0xff5700DC);
  });

  it('blueToYellow', () => {
    const answer = Blend.harmonize(BLUE, YELLOW);
    expect(answer).matchesColor(0xff0047A3);
  });

  it('greenToBlue', () => {
    const answer = Blend.harmonize(GREEN, BLUE);
    expect(answer).matchesColor(0xff00FC94);
  });

  it('greenToRed', () => {
    const answer = Blend.harmonize(GREEN, RED);
    expect(answer).matchesColor(0xffB1F000);
  });

  it('greenToYellow', () => {
    const answer = Blend.harmonize(GREEN, YELLOW);
    expect(answer).matchesColor(0xffB1F000);
  });

  it('yellowToBlue', () => {
    const answer = Blend.harmonize(YELLOW, BLUE);
    expect(answer).matchesColor(0xffEBFFBA);
  });

  it('yellowToGreen', () => {
    const answer = Blend.harmonize(YELLOW, GREEN);
    expect(answer).matchesColor(0xffEBFFBA);
  });

  it('yellowToRed', () => {
    const answer = Blend.harmonize(YELLOW, RED);
    expect(answer).matchesColor(0xffFFF6E3);
  });
});
