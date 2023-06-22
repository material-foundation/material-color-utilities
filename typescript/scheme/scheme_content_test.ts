/**
 * @license
 * Copyright 2023 Google LLC
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

import {SchemeContent} from './scheme_content.js';

beforeEach(() => {
  jasmine.addMatchers(customMatchers);
});

describe('scheme content test', () => {
  it('keyColors', () => {
    const scheme = new SchemeContent(Hct.fromInt(0xff0000ff), false, 0.0);

    expect(MaterialDynamicColors.primaryPaletteKeyColor.getArgb(scheme))
        .matchesColor(0xff080cff);
    expect(MaterialDynamicColors.secondaryPaletteKeyColor.getArgb(scheme))
        .matchesColor(0xff656dd3);
    expect(MaterialDynamicColors.tertiaryPaletteKeyColor.getArgb(scheme))
        .matchesColor(0xff81009f);
    expect(MaterialDynamicColors.neutralPaletteKeyColor.getArgb(scheme))
        .matchesColor(0xff767684);
    expect(MaterialDynamicColors.neutralVariantPaletteKeyColor.getArgb(scheme))
        .matchesColor(0xff757589);
  });

  it('lightTheme_minContrast_primary', () => {
    const scheme = new SchemeContent(
        Hct.fromInt(0xff0000ff),
        false,
        -1.0,
    );
    expect(MaterialDynamicColors.primary.getArgb(scheme))
        .matchesColor(0xff5660ff);
  });

  it('lightTheme_standardContrast_primary', () => {
    const scheme = new SchemeContent(
        Hct.fromInt(0xff0000ff),
        false,
        0,
    );
    expect(MaterialDynamicColors.primary.getArgb(scheme))
        .matchesColor(0xff0001c3);
  });

  it('lightTheme_maxContrast_primary', () => {
    const scheme = new SchemeContent(
        Hct.fromInt(0xff0000ff),
        false,
        1,
    );
    expect(MaterialDynamicColors.primary.getArgb(scheme))
        .matchesColor(0xff000181);
  });

  it('lightTheme_minContrast_primaryContainer', () => {
    const scheme = new SchemeContent(
        Hct.fromInt(0xff0000ff),
        false,
        -1,
    );
    expect(MaterialDynamicColors.primaryContainer.getArgb(scheme))
        .matchesColor(0xffd5d6ff);
  });

  it('lightTheme_standardContrast_primaryContainer', () => {
    const scheme = new SchemeContent(
        Hct.fromInt(0xff0000ff),
        false,
        0,
    );
    expect(MaterialDynamicColors.primaryContainer.getArgb(scheme))
        .matchesColor(0xff2d36ff);
  });

  it('lightTheme_maxContrast_primaryContainer', () => {
    const scheme = new SchemeContent(
        Hct.fromInt(0xff0000ff),
        false,
        1,
    );
    expect(MaterialDynamicColors.primaryContainer.getArgb(scheme))
        .matchesColor(0xff0000e3);
  });

  it('lightTheme_minContrast_tertiaryContainer', () => {
    const scheme = new SchemeContent(
        Hct.fromInt(0xff0000ff),
        false,
        -1,
    );
    expect(MaterialDynamicColors.tertiaryContainer.getArgb(scheme))
        .matchesColor(0xfffac9ff);
  });

  it('lightTheme_standardContrast_tertiaryContainer', () => {
    const scheme = new SchemeContent(
        Hct.fromInt(0xff0000ff),
        false,
        0,
    );
    expect(MaterialDynamicColors.tertiaryContainer.getArgb(scheme))
        .matchesColor(0xff9221af);
  });

  it('lightTheme_maxContrast_tertiaryContainer', () => {
    const scheme = new SchemeContent(
        Hct.fromInt(0xff0000ff),
        false,
        1,
    );
    expect(MaterialDynamicColors.tertiaryContainer.getArgb(scheme))
        .matchesColor(0xff73008e);
  });

  it('lightTheme_minContrast_objectionableTertiaryContainerLightens', () => {
    const scheme = new SchemeContent(
        Hct.fromInt(0xff850096),
        false,
        -1,
    );
    expect(MaterialDynamicColors.tertiaryContainer.getArgb(scheme))
        .matchesColor(0xffffccd7);
  });

  it('lightTheme_standardContrast_objectionableTertiaryContainerLightens',
     () => {
       const scheme = new SchemeContent(
           Hct.fromInt(0xff850096),
           false,
           0,
       );
       expect(MaterialDynamicColors.tertiaryContainer.getArgb(scheme))
           .matchesColor(0xffac1b57);
     });

  it('lightTheme_maxContrast_objectionableTertiaryContainerDarkens', () => {
    const scheme = new SchemeContent(
        Hct.fromInt(0xff850096),
        false,
        1,
    );
    expect(MaterialDynamicColors.tertiaryContainer.getArgb(scheme))
        .matchesColor(0xff870040);
  });

  it('lightTheme_minContrast_onPrimaryContainer', () => {
    const scheme = new SchemeContent(
        Hct.fromInt(0xff0000ff),
        false,
        -1,
    );
    expect(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme))
        .matchesColor(0xff333dff);
  });

  it('lightTheme_standardContrast_onPrimaryContainer', () => {
    const scheme = new SchemeContent(
        Hct.fromInt(0xff0000ff),
        false,
        0,
    );
    expect(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme))
        .matchesColor(0xffffffff);
  });

  it('lightTheme_maxContrast_onPrimaryContainer', () => {
    const scheme = new SchemeContent(
        Hct.fromInt(0xff0000ff),
        false,
        1,
    );
    expect(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme))
        .matchesColor(0xffffffff);
  });

  it('lightTheme_minContrast_surface', () => {
    const scheme = new SchemeContent(
        Hct.fromInt(0xff0000ff),
        false,
        -1,
    );
    expect(MaterialDynamicColors.surface.getArgb(scheme))
        .matchesColor(0xfffbf8ff);
  });

  it('lightTheme_standardContrast_surface', () => {
    const scheme = new SchemeContent(
        Hct.fromInt(0xff0000ff),
        false,
        0.0,
    );
    expect(MaterialDynamicColors.surface.getArgb(scheme))
        .matchesColor(0xfffbf8ff);
  });

  it('lightTheme_maxContrast_surface', () => {
    const scheme = new SchemeContent(
        Hct.fromInt(0xff0000ff),
        false,
        1.0,
    );
    expect(MaterialDynamicColors.surface.getArgb(scheme))
        .matchesColor(0xfffbf8ff);
  });

  it('darkTheme_minContrast_primary', () => {
    const scheme = new SchemeContent(
        Hct.fromInt(0xff0000ff),
        true,
        -1.0,
    );
    expect(MaterialDynamicColors.primary.getArgb(scheme))
        .matchesColor(0xff7c84ff);
  });

  it('darkTheme_standardContrast_primary', () => {
    const scheme = new SchemeContent(
        Hct.fromInt(0xff0000ff),
        true,
        0.0,
    );
    expect(MaterialDynamicColors.primary.getArgb(scheme))
        .matchesColor(0xffbec2ff);
  });

  it('darkTheme_maxContrast_primary', () => {
    const scheme = new SchemeContent(
        Hct.fromInt(0xff0000ff),
        true,
        1.0,
    );
    expect(MaterialDynamicColors.primary.getArgb(scheme))
        .matchesColor(0xfffdf9ff);
  });

  it('darkTheme_minContrast_primaryContainer', () => {
    const scheme = new SchemeContent(
        Hct.fromInt(0xff0000ff),
        true,
        -1.0,
    );
    expect(MaterialDynamicColors.primaryContainer.getArgb(scheme))
        .matchesColor(0xff0001c9);
  });

  it('darkTheme_standardContrast_primaryContainer', () => {
    const scheme = new SchemeContent(
        Hct.fromInt(0xff0000ff),
        true,
        0.0,
    );
    expect(MaterialDynamicColors.primaryContainer.getArgb(scheme))
        .matchesColor(0xff0000e6);
  });

  it('darkTheme_maxContrast_primaryContainer', () => {
    const scheme = new SchemeContent(
        Hct.fromInt(0xff0000ff),
        true,
        1.0,
    );
    expect(MaterialDynamicColors.primaryContainer.getArgb(scheme))
        .matchesColor(0xffc4c6ff);
  });

  it('darkTheme_minContrast_onPrimaryContainer', () => {
    const scheme = new SchemeContent(
        Hct.fromInt(0xff0000ff),
        true,
        -1.0,
    );
    expect(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme))
        .matchesColor(0xff949bff);
  });

  it('darkTheme_standardContrast_onPrimaryContainer', () => {
    const scheme = new SchemeContent(
        Hct.fromInt(0xff0000ff),
        true,
        0.0,
    );
    expect(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme))
        .matchesColor(0xffd7d8ff);
  });

  it('darkTheme_maxContrast_onPrimaryContainer', () => {
    const scheme = new SchemeContent(
        Hct.fromInt(0xff0000ff),
        true,
        1.0,
    );
    expect(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme))
        .matchesColor(0xff000000);
  });

  it('darkTheme_minContrast_onTertiaryContainer', () => {
    const scheme = new SchemeContent(
        Hct.fromInt(0xff0000ff),
        true,
        -1.0,
    );
    expect(MaterialDynamicColors.onTertiaryContainer.getArgb(scheme))
        .matchesColor(0xffe577ff);
  });

  it('darkTheme_standardContrast_onTertiaryContainer', () => {
    const scheme = new SchemeContent(
        Hct.fromInt(0xff0000ff),
        true,
        0.0,
    );
    expect(MaterialDynamicColors.onTertiaryContainer.getArgb(scheme))
        .matchesColor(0xfffbccff);
  });

  it('darkTheme_maxContrast_onTertiaryContainer', () => {
    const scheme = new SchemeContent(
        Hct.fromInt(0xff0000ff),
        true,
        1.0,
    );
    expect(MaterialDynamicColors.onTertiaryContainer.getArgb(scheme))
        .matchesColor(0xff000000);
  });

  it('darkTheme_minContrast_surface', () => {
    const scheme = new SchemeContent(
        Hct.fromInt(0xff0000ff),
        true,
        -1.0,
    );
    expect(MaterialDynamicColors.surface.getArgb(scheme))
        .matchesColor(0xff12121d);
  });

  it('darkTheme_standardContrast_surface', () => {
    const scheme = new SchemeContent(
        Hct.fromInt(0xff0000ff),
        true,
        0.0,
    );
    expect(MaterialDynamicColors.surface.getArgb(scheme))
        .matchesColor(0xff12121d);
  });

  it('darkTheme_maxContrast_surface', () => {
    const scheme = new SchemeContent(
        Hct.fromInt(0xff0000ff),
        true,
        1.0,
    );
    expect(MaterialDynamicColors.surface.getArgb(scheme))
        .matchesColor(0xff12121d);
  });
});
