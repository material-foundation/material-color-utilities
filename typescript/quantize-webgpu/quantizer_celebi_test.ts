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

import { QuantizerCelebi } from './quantizer_celebi.js';

const RED = 0xffff0000;
const GREEN = 0xff00ff00;
const BLUE = 0xff0000ff;

describe('QuantizerCelebi', () => {
  it('1R', async () => {
    const answer = await QuantizerCelebi.quantize([RED], 128);
    expect(answer.length).toBe(1);
    expect(answer[0]).toBe(RED);
  });

  it('1G', async () => {
    const answer = await QuantizerCelebi.quantize([GREEN], 128);
    expect(answer.length).toBe(1);
    expect(answer[0]).toBe(GREEN);
  });

  it('1B', async () => {
    const answer = await QuantizerCelebi.quantize([BLUE], 128);
    expect(answer.length).toBe(1);
    expect(answer[0]).toBe(BLUE);
  });

  it('5B', async () => {
    const answer = await QuantizerCelebi.quantize([BLUE, BLUE, BLUE, BLUE, BLUE], 128);
    expect(answer.length).toBe(1);
    expect(answer[0]).toBe(BLUE);
  });

  it('2R 3G', async () => {
    const answer = await QuantizerCelebi.quantize([RED, RED, GREEN, GREEN, GREEN], 128);
    expect(answer.length).toBe(2);
    expect(answer).toContain(RED);
    expect(answer).toContain(GREEN);
  });

  it('1R 1G 1B', async () => {
    const answer = await QuantizerCelebi.quantize([RED, GREEN, BLUE], 4);
    expect(answer.length).toBe(3);
    expect(answer).toContain(RED);
    expect(answer).toContain(GREEN);
    expect(answer).toContain(BLUE);
  });
});
