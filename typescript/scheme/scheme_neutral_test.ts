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

import {SchemeNeutral} from './scheme_neutral.js';

beforeEach(() => {
  jasmine.addMatchers(customMatchers);
});

describe('scheme neutral test', () => {
  it('keyColors', () => {
    const scheme = new SchemeNeutral(Hct.fromInt(0xff0000ff), false, 0.0);

    expect(MaterialDynamicColors.primaryPaletteKeyColor.getArgb(scheme)).matchesColor(0xff767685);
    expect(MaterialDynamicColors.secondaryPaletteKeyColor.getArgb(scheme)).matchesColor(0xff777680);
    expect(MaterialDynamicColors.tertiaryPaletteKeyColor.getArgb(scheme)).matchesColor(0xff75758B);
    expect(MaterialDynamicColors.neutralPaletteKeyColor.getArgb(scheme)).matchesColor(0xff787678);
    expect(MaterialDynamicColors.neutralVariantPaletteKeyColor.getArgb(scheme)).matchesColor(0xff787678);
  });
  
  it('lightTheme minContrast primary', () => {
    const scheme = new SchemeNeutral(
        Hct.fromInt(0xff0000ff),
        false,
        -1.0,
    );
    expect(MaterialDynamicColors.primary.getArgb(scheme))
        .matchesColor(0xff737383);
  });

  it('lightTheme standardContrast primary', () => {
    const scheme = new SchemeNeutral(
        Hct.fromInt(0xff0000ff),
        false,
        0.0,
    );
    expect(MaterialDynamicColors.primary.getArgb(scheme))
        .matchesColor(0xff5d5d6c);
  });

  it('lightTheme maxContrast primary', () => {
    const scheme = new SchemeNeutral(
        Hct.fromInt(0xff0000ff),
        false,
        1.0,
    );
    expect(MaterialDynamicColors.primary.getArgb(scheme))
        .matchesColor(0xff21212e);
  });

  it('lightTheme minContrast primaryContainer', () => {
    const scheme = new SchemeNeutral(
        Hct.fromInt(0xff0000ff),
        false,
        -1.0,
    );
    expect(MaterialDynamicColors.primaryContainer.getArgb(scheme))
        .matchesColor(0xffe2e1f3);
  });

  it('lightTheme standardContrast primaryContainer', () => {
    const scheme = new SchemeNeutral(
        Hct.fromInt(0xff0000ff),
        false,
        0.0,
    );
    expect(MaterialDynamicColors.primaryContainer.getArgb(scheme))
        .matchesColor(0xffe2e1f3);
  });

  it('lightTheme maxContrast primaryContainer', () => {
    const scheme = new SchemeNeutral(
        Hct.fromInt(0xff0000ff),
        false,
        1.0,
    );
    expect(MaterialDynamicColors.primaryContainer.getArgb(scheme))
        .matchesColor(0xff414250);
  });

  it('lightTheme minContrast onPrimaryContainer', () => {
    const scheme = new SchemeNeutral(
        Hct.fromInt(0xff0000ff),
        false,
        -1.0,
    );
    expect(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme))
        .matchesColor(0xff636372);
  });

  it('lightTheme standardContrast onPrimaryContainer', () => {
    const scheme = new SchemeNeutral(
        Hct.fromInt(0xff0000ff),
        false,
        0.0,
    );
    expect(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme))
        .matchesColor(0xff1a1b27);
  });

  it('lightTheme maxContrast onPrimaryContainer', () => {
    const scheme = new SchemeNeutral(
        Hct.fromInt(0xff0000ff),
        false,
        1.0,
    );
    expect(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme))
        .matchesColor(0xffd9d8ea);
  });

  it('lightTheme minContrast surface', () => {
    const scheme = new SchemeNeutral(
        Hct.fromInt(0xff0000ff),
        false,
        -1.0,
    );
    expect(MaterialDynamicColors.surface.getArgb(scheme))
        .matchesColor(0xfffcf8fa);
  });

  it('lightTheme standardContrast surface', () => {
    const scheme = new SchemeNeutral(
        Hct.fromInt(0xff0000ff),
        false,
        0.0,
    );
    expect(MaterialDynamicColors.surface.getArgb(scheme))
        .matchesColor(0xfffcf8fa);
  });

  it('lightTheme maxContrast surface', () => {
    const scheme = new SchemeNeutral(
        Hct.fromInt(0xff0000ff),
        false,
        1.0,
    );
    expect(MaterialDynamicColors.surface.getArgb(scheme))
        .matchesColor(0xfffcf8fa);
  });

  it('darkTheme minContrast primary', () => {
    const scheme = new SchemeNeutral(
        Hct.fromInt(0xff0000ff),
        true,
        -1.0,
    );
    expect(MaterialDynamicColors.primary.getArgb(scheme))
        .matchesColor(0xff737383);
  });

  it('darkTheme standardContrast primary', () => {
    const scheme = new SchemeNeutral(
        Hct.fromInt(0xff0000ff),
        true,
        0.0,
    );
    expect(MaterialDynamicColors.primary.getArgb(scheme))
        .matchesColor(0xffc6c5d6);
  });

  it('darkTheme maxContrast primary', () => {
    const scheme = new SchemeNeutral(
        Hct.fromInt(0xff0000ff),
        true,
        1.0,
    );
    expect(MaterialDynamicColors.primary.getArgb(scheme))
        .matchesColor(0xfff6f4ff);
  });

  it('darkTheme minContrast primaryContainer', () => {
    const scheme = new SchemeNeutral(
        Hct.fromInt(0xff0000ff),
        true,
        -1.0,
    );
    expect(MaterialDynamicColors.primaryContainer.getArgb(scheme))
        .matchesColor(0xff454654);
  });

  it('darkTheme standardContrast primaryContainer', () => {
    const scheme = new SchemeNeutral(
        Hct.fromInt(0xff0000ff),
        true,
        0.0,
    );
    expect(MaterialDynamicColors.primaryContainer.getArgb(scheme))
        .matchesColor(0xff454654);
  });

  it('darkTheme maxContrast primaryContainer', () => {
    const scheme = new SchemeNeutral(
        Hct.fromInt(0xff0000ff),
        true,
        1.0,
    );
    expect(MaterialDynamicColors.primaryContainer.getArgb(scheme))
        .matchesColor(0xffcac9da);
  });

  it('darkTheme minContrast onPrimaryContainer', () => {
    const scheme = new SchemeNeutral(
        Hct.fromInt(0xff0000ff),
        true,
        -1.0,
    );
    expect(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme))
        .matchesColor(0xffb5b3c4);
  });

  it('darkTheme standardContrast onPrimaryContainer', () => {
    const scheme = new SchemeNeutral(
        Hct.fromInt(0xff0000ff),
        true,
        0.0,
    );
    expect(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme))
        .matchesColor(0xffe2e1f3);
  });

  it('darkTheme maxContrast onPrimaryContainer', () => {
    const scheme = new SchemeNeutral(
        Hct.fromInt(0xff0000ff),
        true,
        1.0,
    );
    expect(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme))
        .matchesColor(0xff373846);
  });

  it('darkTheme minContrast onTertiaryContainer', () => {
    const scheme = new SchemeNeutral(
        Hct.fromInt(0xff0000ff),
        true,
        -1.0,
    );
    expect(MaterialDynamicColors.onTertiaryContainer.getArgb(scheme))
        .matchesColor(0xffb3b3cb);
  });

  it('darkTheme standardContrast onTertiaryContainer', () => {
    const scheme = new SchemeNeutral(
        Hct.fromInt(0xff0000ff),
        true,
        0.0,
    );
    expect(MaterialDynamicColors.onTertiaryContainer.getArgb(scheme))
        .matchesColor(0xffe1e0f9);
  });

  it('darkTheme maxContrast onTertiaryContainer', () => {
    const scheme = new SchemeNeutral(
        Hct.fromInt(0xff0000ff),
        true,
        1.0,
    );
    expect(MaterialDynamicColors.onTertiaryContainer.getArgb(scheme))
        .matchesColor(0xff37374b);
  });

  it('darkTheme minContrast surface', () => {
    const scheme = new SchemeNeutral(
        Hct.fromInt(0xff0000ff),
        true,
        -1.0,
    );
    expect(MaterialDynamicColors.surface.getArgb(scheme))
        .matchesColor(0xff131315);
  });

  it('darkTheme standardContrast surface', () => {
    const scheme = new SchemeNeutral(
        Hct.fromInt(0xff0000ff),
        true,
        0.0,
    );
    expect(MaterialDynamicColors.surface.getArgb(scheme))
        .matchesColor(0xff131315);
  });

  it('darkTheme maxContrast surface', () => {
    const scheme = new SchemeNeutral(
        Hct.fromInt(0xff0000ff),
        true,
        1.0,
    );
    expect(MaterialDynamicColors.surface.getArgb(scheme))
        .matchesColor(0xff131315);
  });
});
