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

import {SchemeExpressive} from './scheme_expressive.js';

beforeEach(() => {
  jasmine.addMatchers(customMatchers);
});

describe('scheme expressive test', () => {
  it('lightTheme minContrast primary', () => {
    const scheme = new SchemeExpressive(
        Hct.fromInt(0xff0000ff),
        false,
        -1.0,
    );
    expect(MaterialDynamicColors.primary.getArgb(scheme))
        .matchesColor(0xffad603c);
  });

  it('lightTheme standardContrast primary', () => {
    const scheme = new SchemeExpressive(
        Hct.fromInt(0xff0000ff),
        false,
        0.0,
    );
    expect(MaterialDynamicColors.primary.getArgb(scheme))
        .matchesColor(0xff924b28);
  });

  it('lightTheme maxContrast primary', () => {
    const scheme = new SchemeExpressive(
        Hct.fromInt(0xff0000ff),
        false,
        1.0,
    );
    expect(MaterialDynamicColors.primary.getArgb(scheme))
        .matchesColor(0xff401400);
  });

  it('lightTheme minContrast primaryContainer', () => {
    const scheme = new SchemeExpressive(
        Hct.fromInt(0xff0000ff),
        false,
        -1.0,
    );
    expect(MaterialDynamicColors.primaryContainer.getArgb(scheme))
        .matchesColor(0xffffdbcc);
  });

  it('lightTheme standardContrast primaryContainer', () => {
    const scheme = new SchemeExpressive(
        Hct.fromInt(0xff0000ff),
        false,
        0.0,
    );
    expect(MaterialDynamicColors.primaryContainer.getArgb(scheme))
        .matchesColor(0xffffdbcc);
  });

  it('lightTheme maxContrast primaryContainer', () => {
    const scheme = new SchemeExpressive(
        Hct.fromInt(0xff0000ff),
        false,
        1.0,
    );
    expect(MaterialDynamicColors.primaryContainer.getArgb(scheme))
        .matchesColor(0xff6f3010);
  });

  it('lightTheme minContrast onPrimaryContainer', () => {
    const scheme = new SchemeExpressive(
        Hct.fromInt(0xff0000ff),
        false,
        -1.0,
    );
    expect(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme))
        .matchesColor(0xff99512e);
  });

  it('lightTheme standardContrast onPrimaryContainer', () => {
    const scheme = new SchemeExpressive(
        Hct.fromInt(0xff0000ff),
        false,
        0.0,
    );
    expect(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme))
        .matchesColor(0xff351000);
  });

  it('lightTheme maxContrast onPrimaryContainer', () => {
    const scheme = new SchemeExpressive(
        Hct.fromInt(0xff0000ff),
        false,
        1.0,
    );
    expect(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme))
        .matchesColor(0xffffd0bc);
  });

  it('lightTheme minContrast surface', () => {
    const scheme = new SchemeExpressive(
        Hct.fromInt(0xff0000ff),
        false,
        -1.0,
    );
    expect(MaterialDynamicColors.surface.getArgb(scheme))
        .matchesColor(0xfffbf8ff);
  });

  it('lightTheme standardContrast surface', () => {
    const scheme = new SchemeExpressive(
        Hct.fromInt(0xff0000ff),
        false,
        0.0,
    );
    expect(MaterialDynamicColors.surface.getArgb(scheme))
        .matchesColor(0xfffbf8ff);
  });

  it('lightTheme maxContrast surface', () => {
    const scheme = new SchemeExpressive(
        Hct.fromInt(0xff0000ff),
        false,
        1.0,
    );
    expect(MaterialDynamicColors.surface.getArgb(scheme))
        .matchesColor(0xfffbf8ff);
  });

  it('darkTheme minContrast primary', () => {
    const scheme = new SchemeExpressive(
        Hct.fromInt(0xff0000ff),
        true,
        -1.0,
    );
    expect(MaterialDynamicColors.primary.getArgb(scheme))
        .matchesColor(0xffad603c);
  });

  it('darkTheme standardContrast primary', () => {
    const scheme = new SchemeExpressive(
        Hct.fromInt(0xff0000ff),
        true,
        0.0,
    );
    expect(MaterialDynamicColors.primary.getArgb(scheme))
        .matchesColor(0xffffb595);
  });

  it('darkTheme maxContrast primary', () => {
    const scheme = new SchemeExpressive(
        Hct.fromInt(0xff0000ff),
        true,
        1.0,
    );
    expect(MaterialDynamicColors.primary.getArgb(scheme))
        .matchesColor(0xfffff3ee);
  });

  it('darkTheme minContrast primaryContainer', () => {
    const scheme = new SchemeExpressive(
        Hct.fromInt(0xff0000ff),
        true,
        -1.0,
    );
    expect(MaterialDynamicColors.primaryContainer.getArgb(scheme))
        .matchesColor(0xff743413);
  });

  it('darkTheme standardContrast primaryContainer', () => {
    const scheme = new SchemeExpressive(
        Hct.fromInt(0xff0000ff),
        true,
        0.0,
    );
    expect(MaterialDynamicColors.primaryContainer.getArgb(scheme))
        .matchesColor(0xff743413);
  });

  it('darkTheme maxContrast primaryContainer', () => {
    const scheme = new SchemeExpressive(
        Hct.fromInt(0xff0000ff),
        true,
        1.0,
    );
    expect(MaterialDynamicColors.primaryContainer.getArgb(scheme))
        .matchesColor(0xffffbb9e);
  });

  it('darkTheme minContrast onPrimaryContainer', () => {
    const scheme = new SchemeExpressive(
        Hct.fromInt(0xff0000ff),
        true,
        -1.0,
    );
    expect(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme))
        .matchesColor(0xfff99f75);
  });

  it('darkTheme standardContrast onPrimaryContainer', () => {
    const scheme = new SchemeExpressive(
        Hct.fromInt(0xff0000ff),
        true,
        0.0,
    );
    expect(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme))
        .matchesColor(0xffffdbcc);
  });

  it('darkTheme maxContrast onPrimaryContainer', () => {
    const scheme = new SchemeExpressive(
        Hct.fromInt(0xff0000ff),
        true,
        1.0,
    );
    expect(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme))
        .matchesColor(0xff622706);
  });

  it('darkTheme minContrast surface', () => {
    const scheme = new SchemeExpressive(
        Hct.fromInt(0xff0000ff),
        true,
        -1.0,
    );
    expect(MaterialDynamicColors.surface.getArgb(scheme))
        .matchesColor(0xff12131a);
  });

  it('darkTheme standardContrast surface', () => {
    const scheme = new SchemeExpressive(
        Hct.fromInt(0xff0000ff),
        true,
        0.0,
    );
    expect(MaterialDynamicColors.surface.getArgb(scheme))
        .matchesColor(0xff12131a);
  });

  it('darkTheme maxContrast surface', () => {
    const scheme = new SchemeExpressive(
        Hct.fromInt(0xff0000ff),
        true,
        1.0,
    );
    expect(MaterialDynamicColors.surface.getArgb(scheme))
        .matchesColor(0xff12131a);
  });
});
