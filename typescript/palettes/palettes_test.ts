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

import {CorePalette} from './core_palette';
import {TonalPalette} from './tonal_palette';

describe('TonalPalette', () => {
  it('ofBlue', () => {
    const blue = TonalPalette.fromInt(0xff0000ff);

    expect(blue.tone(100)).toBe(0xffffffff);
    expect(blue.tone(95)).toBe(0xfff1efff);
    expect(blue.tone(90)).toBe(0xffe0e0ff);
    expect(blue.tone(80)).toBe(0xffbec2ff);
    expect(blue.tone(70)).toBe(0xff9da3ff);
    expect(blue.tone(60)).toBe(0xff7c84ff);
    expect(blue.tone(50)).toBe(0xff5a64ff);
    expect(blue.tone(40)).toBe(0xff343dff);
    expect(blue.tone(30)).toBe(0xff0000ef);
    expect(blue.tone(20)).toBe(0xff0001ac);
    expect(blue.tone(10)).toBe(0xff00006e);
    expect(blue.tone(0)).toBe(0xff000000);
  });
});

describe('CorePalette', () => {
  it('ofBlue', () => {
    const core = CorePalette.of(0xff0000ff);

    expect(core.a1.tone(100)).toBe(0xffffffff);
    expect(core.a1.tone(95)).toBe(0xfff1efff);
    expect(core.a1.tone(90)).toBe(0xffe0e0ff);
    expect(core.a1.tone(80)).toBe(0xffbec2ff);
    expect(core.a1.tone(70)).toBe(0xff9da3ff);
    expect(core.a1.tone(60)).toBe(0xff7c84ff);
    expect(core.a1.tone(50)).toBe(0xff5a64ff);
    expect(core.a1.tone(40)).toBe(0xff343dff);
    expect(core.a1.tone(30)).toBe(0xff0000ef);
    expect(core.a1.tone(20)).toBe(0xff0001ac);
    expect(core.a1.tone(10)).toBe(0xff00006e);
    expect(core.a1.tone(0)).toBe(0xff000000);
  });
});
