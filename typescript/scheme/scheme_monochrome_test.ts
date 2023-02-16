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

import {MaterialDynamicColors} from '../dynamiccolor/material_dynamic_colors.js';
import {Hct} from '../hct/hct.js';
import {customMatchers} from '../utils/test_utils.js';

import {SchemeMonochrome} from './scheme_monochrome.js';

beforeEach(() => {
  jasmine.addMatchers(customMatchers);
});

describe('scheme monochrome test', () => {
  it('lightTheme minContrast primary', () => {
    const scheme = new SchemeMonochrome(
        Hct.fromInt(0xff0000ff),
        false,
        -1.0,
    );
    expect(MaterialDynamicColors.primary.getArgb(scheme))
        .matchesColor(0xff747474);
  });

  it('lightTheme standardContrast primary', () => {
    const scheme = new SchemeMonochrome(
        Hct.fromInt(0xff0000ff),
        false,
        0,
    );
    expect(MaterialDynamicColors.primary.getArgb(scheme))
        .matchesColor(0xff5e5e5e);
  });

  it('lightTheme maxContrast primary', () => {
    const scheme = new SchemeMonochrome(
        Hct.fromInt(0xff0000ff),
        false,
        1.0,
    );
    expect(MaterialDynamicColors.primary.getArgb(scheme))
        .matchesColor(0xff222222);
  });

  it('lightTheme minContrast primaryContainer', () => {
    const scheme = new SchemeMonochrome(
        Hct.fromInt(0xff0000ff),
        false,
        -1,
    );
    expect(MaterialDynamicColors.primaryContainer.getArgb(scheme))
        .matchesColor(0xffe2e2e2);
  });

  it('lightTheme standardContrast primaryContainer', () => {
    const scheme = new SchemeMonochrome(
        Hct.fromInt(0xff0000ff),
        false,
        0,
    );
    expect(MaterialDynamicColors.primaryContainer.getArgb(scheme))
        .matchesColor(0xffe2e2e2);
  });

  it('lightTheme maxContrast primaryContainer', () => {
    const scheme = new SchemeMonochrome(
        Hct.fromInt(0xff0000ff),
        false,
        1,
    );
    expect(MaterialDynamicColors.primaryContainer.getArgb(scheme))
        .matchesColor(0xff434343);
  });

  it('lightTheme minContrast onPrimaryContainer', () => {
    const scheme = new SchemeMonochrome(
        Hct.fromInt(0xff0000ff),
        false,
        -1,
    );
    expect(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme))
        .matchesColor(0xff646464);
  });

  it('lightTheme standardContrast onPrimaryContainer', () => {
    const scheme = new SchemeMonochrome(
        Hct.fromInt(0xff0000ff),
        false,
        0,
    );
    expect(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme))
        .matchesColor(0xff1b1b1b);
  });

  it('lightTheme maxContrast onPrimaryContainer', () => {
    const scheme = new SchemeMonochrome(
        Hct.fromInt(0xff0000ff),
        false,
        1,
    );
    expect(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme))
        .matchesColor(0xffdadada);
  });

  it('lightTheme minContrast surface', () => {
    const scheme = new SchemeMonochrome(
        Hct.fromInt(0xff0000ff),
        false,
        -1,
    );
    expect(MaterialDynamicColors.surface.getArgb(scheme))
        .matchesColor(0xfff9f9f9);
  });

  it('lightTheme standardContrast surface', () => {
    const scheme = new SchemeMonochrome(
        Hct.fromInt(0xff0000ff),
        false,
        0.0,
    );
    expect(MaterialDynamicColors.surface.getArgb(scheme))
        .matchesColor(0xfff9f9f9);
  });

  it('lightTheme maxContrast surface', () => {
    const scheme = new SchemeMonochrome(
        Hct.fromInt(0xff0000ff),
        false,
        1.0,
    );
    expect(MaterialDynamicColors.surface.getArgb(scheme))
        .matchesColor(0xfff9f9f9);
  });

  it('darkTheme minContrast primary', () => {
    const scheme = new SchemeMonochrome(
        Hct.fromInt(0xff0000ff),
        true,
        -1.0,
    );
    expect(MaterialDynamicColors.primary.getArgb(scheme))
        .matchesColor(0xff747474);
  });

  it('darkTheme standardContrast primary', () => {
    const scheme = new SchemeMonochrome(
        Hct.fromInt(0xff0000ff),
        true,
        0.0,
    );
    expect(MaterialDynamicColors.primary.getArgb(scheme))
        .matchesColor(0xffc6c6c6);
  });

  it('darkTheme maxContrast primary', () => {
    const scheme = new SchemeMonochrome(
        Hct.fromInt(0xff0000ff),
        true,
        1.0,
    );
    expect(MaterialDynamicColors.primary.getArgb(scheme))
        .matchesColor(0xfff5f5f5);
  });

  it('darkTheme minContrast primaryContainer', () => {
    const scheme = new SchemeMonochrome(
        Hct.fromInt(0xff0000ff),
        true,
        -1.0,
    );
    expect(MaterialDynamicColors.primaryContainer.getArgb(scheme))
        .matchesColor(0xff474747);
  });

  it('darkTheme standardContrast primaryContainer', () => {
    const scheme = new SchemeMonochrome(
        Hct.fromInt(0xff0000ff),
        true,
        0.0,
    );
    expect(MaterialDynamicColors.primaryContainer.getArgb(scheme))
        .matchesColor(0xff474747);
  });

  it('darkTheme maxContrast primaryContainer', () => {
    const scheme = new SchemeMonochrome(
        Hct.fromInt(0xff0000ff),
        true,
        1.0,
    );
    expect(MaterialDynamicColors.primaryContainer.getArgb(scheme))
        .matchesColor(0xffcbcbcb);
  });

  it('darkTheme minContrast onPrimaryContainer', () => {
    const scheme = new SchemeMonochrome(
        Hct.fromInt(0xff0000ff),
        true,
        -1.0,
    );
    expect(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme))
        .matchesColor(0xffb5b5b5);
  });

  it('darkTheme standardContrast onPrimaryContainer', () => {
    const scheme = new SchemeMonochrome(
        Hct.fromInt(0xff0000ff),
        true,
        0.0,
    );
    expect(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme))
        .matchesColor(0xffe2e2e2);
  });

  it('darkTheme maxContrast onPrimaryContainer', () => {
    const scheme = new SchemeMonochrome(
        Hct.fromInt(0xff0000ff),
        true,
        1.0,
    );
    expect(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme))
        .matchesColor(0xff393939);
  });

  it('darkTheme minContrast onTertiaryContainer', () => {
    const scheme = new SchemeMonochrome(
        Hct.fromInt(0xff0000ff),
        true,
        -1.0,
    );
    expect(MaterialDynamicColors.onTertiaryContainer.getArgb(scheme))
        .matchesColor(0xffb5b5b5);
  });

  it('darkTheme standardContrast onTertiaryContainer', () => {
    const scheme = new SchemeMonochrome(
        Hct.fromInt(0xff0000ff),
        true,
        0.0,
    );
    expect(MaterialDynamicColors.onTertiaryContainer.getArgb(scheme))
        .matchesColor(0xffe2e2e2);
  });

  it('darkTheme maxContrast onTertiaryContainer', () => {
    const scheme = new SchemeMonochrome(
        Hct.fromInt(0xff0000ff),
        true,
        1.0,
    );
    expect(MaterialDynamicColors.onTertiaryContainer.getArgb(scheme))
        .matchesColor(0xff393939);
  });

  it('darkTheme minContrast surface', () => {
    const scheme = new SchemeMonochrome(
        Hct.fromInt(0xff0000ff),
        true,
        -1.0,
    );
    expect(MaterialDynamicColors.surface.getArgb(scheme))
        .matchesColor(0xff131313);
  });

  it('darkTheme standardContrast surface', () => {
    const scheme = new SchemeMonochrome(
        Hct.fromInt(0xff0000ff),
        true,
        0.0,
    );
    expect(MaterialDynamicColors.surface.getArgb(scheme))
        .matchesColor(0xff131313);
  });

  it('darkTheme maxContrast surface', () => {
    const scheme = new SchemeMonochrome(
        Hct.fromInt(0xff0000ff),
        true,
        1.0,
    );
    expect(MaterialDynamicColors.surface.getArgb(scheme))
        .matchesColor(0xff131313);
  });
});
