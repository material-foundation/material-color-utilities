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
  it('keyColors', () => {
    const scheme = new SchemeMonochrome(Hct.fromInt(0xff0000ff), false, 0.0);

    expect(MaterialDynamicColors.primaryPaletteKeyColor.getArgb(scheme)).matchesColor(0xff070707);
    expect(MaterialDynamicColors.secondaryPaletteKeyColor.getArgb(scheme)).matchesColor(0xff070707);
    expect(MaterialDynamicColors.tertiaryPaletteKeyColor.getArgb(scheme)).matchesColor(0xff070707);
    expect(MaterialDynamicColors.neutralPaletteKeyColor.getArgb(scheme)).matchesColor(0xff070707);
    expect(MaterialDynamicColors.neutralVariantPaletteKeyColor.getArgb(scheme)).matchesColor(0xff070707);
  });

  it('lightTheme minContrast primary', () => {
    const scheme = new SchemeMonochrome(
        Hct.fromInt(0xff0000ff),
        false,
        -1.0,
    );
    expect(MaterialDynamicColors.primary.getArgb(scheme))
        .matchesColor(0xff3c3c3c);
  });

  it('lightTheme standardContrast primary', () => {
    const scheme = new SchemeMonochrome(
        Hct.fromInt(0xff0000ff),
        false,
        0,
    );
    expect(MaterialDynamicColors.primary.getArgb(scheme))
        .matchesColor(0xff000000);
  });

  it('lightTheme maxContrast primary', () => {
    const scheme = new SchemeMonochrome(
        Hct.fromInt(0xff0000ff),
        false,
        1.0,
    );
    expect(MaterialDynamicColors.primary.getArgb(scheme))
        .matchesColor(0xff000000);
  });

  it('lightTheme minContrast primaryContainer', () => {
    const scheme = new SchemeMonochrome(
        Hct.fromInt(0xff0000ff),
        false,
        -1,
    );
    expect(MaterialDynamicColors.primaryContainer.getArgb(scheme))
        .matchesColor(0xff5f5f5f);
  });

  it('lightTheme standardContrast primaryContainer', () => {
    const scheme = new SchemeMonochrome(
        Hct.fromInt(0xff0000ff),
        false,
        0,
    );
    expect(MaterialDynamicColors.primaryContainer.getArgb(scheme))
        .matchesColor(0xff3b3b3b);
  });

  it('lightTheme maxContrast primaryContainer', () => {
    const scheme = new SchemeMonochrome(
        Hct.fromInt(0xff0000ff),
        false,
        1,
    );
    expect(MaterialDynamicColors.primaryContainer.getArgb(scheme))
        .matchesColor(0xff3a3a3a);
  });

  it('lightTheme minContrast onPrimaryContainer', () => {
    const scheme = new SchemeMonochrome(
        Hct.fromInt(0xff0000ff),
        false,
        -1,
    );
    expect(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme))
        .matchesColor(0xffd9d9d9);
  });

  it('lightTheme standardContrast onPrimaryContainer', () => {
    const scheme = new SchemeMonochrome(
        Hct.fromInt(0xff0000ff),
        false,
        0,
    );
    expect(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme))
        .matchesColor(0xffffffff);
  });

  it('lightTheme maxContrast onPrimaryContainer', () => {
    const scheme = new SchemeMonochrome(
        Hct.fromInt(0xff0000ff),
        false,
        1,
    );
    expect(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme))
        .matchesColor(0xffcdcdcd);
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
        .matchesColor(0xffcccccc);
  });

  it('darkTheme standardContrast primary', () => {
    const scheme = new SchemeMonochrome(
        Hct.fromInt(0xff0000ff),
        true,
        0.0,
    );
    expect(MaterialDynamicColors.primary.getArgb(scheme))
        .matchesColor(0xffffffff);
  });

  it('darkTheme maxContrast primary', () => {
    const scheme = new SchemeMonochrome(
        Hct.fromInt(0xff0000ff),
        true,
        1.0,
    );
    expect(MaterialDynamicColors.primary.getArgb(scheme))
        .matchesColor(0xffffffff);
  });

  it('darkTheme minContrast primaryContainer', () => {
    const scheme = new SchemeMonochrome(
        Hct.fromInt(0xff0000ff),
        true,
        -1.0,
    );
    expect(MaterialDynamicColors.primaryContainer.getArgb(scheme))
        .matchesColor(0xffa3a3a3);
  });

  it('darkTheme standardContrast primaryContainer', () => {
    const scheme = new SchemeMonochrome(
        Hct.fromInt(0xff0000ff),
        true,
        0.0,
    );
    expect(MaterialDynamicColors.primaryContainer.getArgb(scheme))
        .matchesColor(0xffd4d4d4);
  });

  it('darkTheme maxContrast primaryContainer', () => {
    const scheme = new SchemeMonochrome(
        Hct.fromInt(0xff0000ff),
        true,
        1.0,
    );
    expect(MaterialDynamicColors.primaryContainer.getArgb(scheme))
        .matchesColor(0xffd5d5d5);
  });

  it('darkTheme minContrast onPrimaryContainer', () => {
    const scheme = new SchemeMonochrome(
        Hct.fromInt(0xff0000ff),
        true,
        -1.0,
    );
    expect(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme))
        .matchesColor(0xff393939);
  });

  it('darkTheme standardContrast onPrimaryContainer', () => {
    const scheme = new SchemeMonochrome(
        Hct.fromInt(0xff0000ff),
        true,
        0.0,
    );
    expect(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme))
        .matchesColor(0xff000000);
  });

  it('darkTheme maxContrast onPrimaryContainer', () => {
    const scheme = new SchemeMonochrome(
        Hct.fromInt(0xff0000ff),
        true,
        1.0,
    );
    expect(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme))
        .matchesColor(0xff404040);
  });

  it('darkTheme minContrast onTertiaryContainer', () => {
    const scheme = new SchemeMonochrome(
        Hct.fromInt(0xff0000ff),
        true,
        -1.0,
    );
    expect(MaterialDynamicColors.onTertiaryContainer.getArgb(scheme))
        .matchesColor(0xffd1d1d1);
  });

  it('darkTheme standardContrast onTertiaryContainer', () => {
    const scheme = new SchemeMonochrome(
        Hct.fromInt(0xff0000ff),
        true,
        0.0,
    );
    expect(MaterialDynamicColors.onTertiaryContainer.getArgb(scheme))
        .matchesColor(0xff000000);
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
