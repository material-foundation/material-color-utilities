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

import {SchemeRainbow} from './scheme_rainbow.js';

beforeEach(() => {
  jasmine.addMatchers(customMatchers);
});

describe('scheme rainbow test', () => {
  it('keyColors', () => {
    const scheme = new SchemeRainbow(Hct.fromInt(0xff0000ff), false, 0.0);

    expect(MaterialDynamicColors.primaryPaletteKeyColor.getArgb(scheme))
        .matchesColor(0xff696fc4);
    expect(MaterialDynamicColors.secondaryPaletteKeyColor.getArgb(scheme))
        .matchesColor(0xff75758b);
    expect(MaterialDynamicColors.tertiaryPaletteKeyColor.getArgb(scheme))
        .matchesColor(0xff936b84);
    expect(MaterialDynamicColors.neutralPaletteKeyColor.getArgb(scheme))
        .matchesColor(0xff070707);
    expect(MaterialDynamicColors.neutralVariantPaletteKeyColor.getArgb(scheme))
        .matchesColor(0xff070707);
  });

  it('lightTheme_minContrast_primary', () => {
    const scheme = new SchemeRainbow(Hct.fromInt(0xff0000ff), false, -1.0);
    expect(MaterialDynamicColors.primary.getArgb(scheme))
        .matchesColor(0xff676dc1);
  });

  it('lightTheme_standardContrast_primary', () => {
    const scheme = new SchemeRainbow(Hct.fromInt(0xff0000ff), false, 0.0);
    expect(MaterialDynamicColors.primary.getArgb(scheme))
        .matchesColor(0xff5056a9);
  });

  it('lightTheme_maxContrast_primary', () => {
    const scheme = new SchemeRainbow(Hct.fromInt(0xff0000ff), false, 1.0);
    expect(MaterialDynamicColors.primary.getArgb(scheme))
        .matchesColor(0xff0f136a);
  });

  it('lightTheme_minContrast_primaryContainer', () => {
    const scheme = new SchemeRainbow(Hct.fromInt(0xff0000ff), false, -1.0);
    expect(MaterialDynamicColors.primaryContainer.getArgb(scheme))
        .matchesColor(0xffd5d6ff);
  });

  it('lightTheme_standardContrast_primaryContainer', () => {
    const scheme = new SchemeRainbow(Hct.fromInt(0xff0000ff), false, 0.0);
    expect(MaterialDynamicColors.primaryContainer.getArgb(scheme))
        .matchesColor(0xffe0e0ff);
  });

  it('lightTheme_maxContrast_primaryContainer', () => {
    const scheme = new SchemeRainbow(Hct.fromInt(0xff0000ff), false, 1.0);
    expect(MaterialDynamicColors.primaryContainer.getArgb(scheme))
        .matchesColor(0xff34398b);
  });

  it('lightTheme_minContrast_tertiaryContainer', () => {
    const scheme = new SchemeRainbow(Hct.fromInt(0xff0000ff), false, -1.0);
    expect(MaterialDynamicColors.tertiaryContainer.getArgb(scheme))
        .matchesColor(0xfffbcbe7);
  });

  it('lightTheme_standardContrast_tertiaryContainer', () => {
    const scheme = new SchemeRainbow(Hct.fromInt(0xff0000ff), false, 0.0);
    expect(MaterialDynamicColors.tertiaryContainer.getArgb(scheme))
        .matchesColor(0xffffd8ee);
  });

  it('lightTheme_maxContrast_tertiaryContainer', () => {
    const scheme = new SchemeRainbow(Hct.fromInt(0xff0000ff), false, 1.0);
    expect(MaterialDynamicColors.tertiaryContainer.getArgb(scheme))
        .matchesColor(0xff5a384e);
  });

  it('lightTheme_minContrast_onPrimaryContainer', () => {
    const scheme = new SchemeRainbow(Hct.fromInt(0xff0000ff), false, -1.0);
    expect(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme))
        .matchesColor(0xff5056a9);
  });

  it('lightTheme_standardContrast_onPrimaryContainer', () => {
    const scheme = new SchemeRainbow(Hct.fromInt(0xff0000ff), false, 0.0);
    expect(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme))
        .matchesColor(0xff050865);
  });

  it('lightTheme_maxContrast_onPrimaryContainer', () => {
    const scheme = new SchemeRainbow(Hct.fromInt(0xff0000ff), false, 1.0);
    expect(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme))
        .matchesColor(0xffffffff);
  });

  it('lightTheme_minContrast_surface', () => {
    const scheme = new SchemeRainbow(Hct.fromInt(0xff0000ff), false, -1.0);
    expect(MaterialDynamicColors.surface.getArgb(scheme))
        .matchesColor(0xfff9f9f9);
  });

  it('lightTheme_standardContrast_surface', () => {
    const scheme = new SchemeRainbow(Hct.fromInt(0xff0000ff), false, 0.0);
    expect(MaterialDynamicColors.surface.getArgb(scheme))
        .matchesColor(0xfff9f9f9);
  });

  it('lightTheme_maxContrast_surface', () => {
    const scheme = new SchemeRainbow(Hct.fromInt(0xff0000ff), false, 1.0);
    expect(MaterialDynamicColors.surface.getArgb(scheme))
        .matchesColor(0xfff9f9f9);
  });

  it('lightTheme_standardContrast_secondary', () => {
    const scheme = new SchemeRainbow(Hct.fromInt(0xff0000ff), false, 0.0);
    expect(MaterialDynamicColors.secondary.getArgb(scheme))
        .matchesColor(0xff5c5d72);
  });

  it('lightTheme_standardContrast_secondaryContainer', () => {
    const scheme = new SchemeRainbow(Hct.fromInt(0xff0000ff), false, 0.0);
    expect(MaterialDynamicColors.secondaryContainer.getArgb(scheme))
        .matchesColor(0xffe1e0f9);
  });

  it('darkTheme_minContrast_primary', () => {
    const scheme = new SchemeRainbow(Hct.fromInt(0xff0000ff), true, -1.0);
    expect(MaterialDynamicColors.primary.getArgb(scheme))
        .matchesColor(0xff8389e0);
  });

  it('darkTheme_standardContrast_primary', () => {
    const scheme = new SchemeRainbow(Hct.fromInt(0xff0000ff), true, 0.0);
    expect(MaterialDynamicColors.primary.getArgb(scheme))
        .matchesColor(0xffbec2ff);
  });

  it('darkTheme_maxContrast_primary', () => {
    const scheme = new SchemeRainbow(Hct.fromInt(0xff0000ff), true, 1.0);
    expect(MaterialDynamicColors.primary.getArgb(scheme))
        .matchesColor(0xfffdf9ff);
  });

  it('darkTheme_minContrast_primaryContainer', () => {
    const scheme = new SchemeRainbow(Hct.fromInt(0xff0000ff), true, -1.0);
    expect(MaterialDynamicColors.primaryContainer.getArgb(scheme))
        .matchesColor(0xff2a3082);
  });

  it('darkTheme_standardContrast_primaryContainer', () => {
    const scheme = new SchemeRainbow(Hct.fromInt(0xff0000ff), true, 0.0);
    expect(MaterialDynamicColors.primaryContainer.getArgb(scheme))
        .matchesColor(0xff383e8f);
  });

  it('darkTheme_maxContrast_primaryContainer', () => {
    const scheme = new SchemeRainbow(Hct.fromInt(0xff0000ff), true, 1.0);
    expect(MaterialDynamicColors.primaryContainer.getArgb(scheme))
        .matchesColor(0xffc4c6ff);
  });

  it('darkTheme_minContrast_onPrimaryContainer', () => {
    const scheme = new SchemeRainbow(Hct.fromInt(0xff0000ff), true, -1.0);
    expect(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme))
        .matchesColor(0xff969cf5);
  });

  it('darkTheme_standardContrast_onPrimaryContainer', () => {
    const scheme = new SchemeRainbow(Hct.fromInt(0xff0000ff), true, 0.0);
    expect(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme))
        .matchesColor(0xffe0e0ff);
  });

  it('darkTheme_maxContrast_onPrimaryContainer', () => {
    const scheme = new SchemeRainbow(Hct.fromInt(0xff0000ff), true, 1.0);
    expect(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme))
        .matchesColor(0xff000000);
  });

  it('darkTheme_minContrast_onTertiaryContainer', () => {
    const scheme = new SchemeRainbow(Hct.fromInt(0xff0000ff), true, -1.0);
    expect(MaterialDynamicColors.onTertiaryContainer.getArgb(scheme))
        .matchesColor(0xffc397b2);
  });

  it('darkTheme_standardContrast_onTertiaryContainer', () => {
    const scheme = new SchemeRainbow(Hct.fromInt(0xff0000ff), true, 0.0);
    expect(MaterialDynamicColors.onTertiaryContainer.getArgb(scheme))
        .matchesColor(0xffffd8ee);
  });

  it('darkTheme_maxContrast_onTertiaryContainer', () => {
    const scheme = new SchemeRainbow(Hct.fromInt(0xff0000ff), true, 1.0);
    expect(MaterialDynamicColors.onTertiaryContainer.getArgb(scheme))
        .matchesColor(0xff000000);
  });

  it('darkTheme_minContrast_surface', () => {
    const scheme = new SchemeRainbow(Hct.fromInt(0xff0000ff), true, -1.0);
    expect(MaterialDynamicColors.surface.getArgb(scheme))
        .matchesColor(0xff131313);
  });

  it('darkTheme_standardContrast_surface', () => {
    const scheme = new SchemeRainbow(Hct.fromInt(0xff0000ff), true, 0.0);
    expect(MaterialDynamicColors.surface.getArgb(scheme))
        .matchesColor(0xff131313);
  });

  it('darkTheme_maxContrast_surface', () => {
    const scheme = new SchemeRainbow(Hct.fromInt(0xff0000ff), true, 1.0);
    expect(MaterialDynamicColors.surface.getArgb(scheme))
        .matchesColor(0xff131313);
  });

  it('darkTheme_standardContrast_secondary', () => {
    const scheme = new SchemeRainbow(Hct.fromInt(0xff0000ff), true, 0.0);
    expect(MaterialDynamicColors.secondary.getArgb(scheme))
        .matchesColor(0xffc5c4dd);
  });

  it('darkTheme_standardContrast_secondaryContainer', () => {
    const scheme = new SchemeRainbow(Hct.fromInt(0xff0000ff), true, 0.0);
    expect(MaterialDynamicColors.secondaryContainer.getArgb(scheme))
        .matchesColor(0xff444559);
  });
});
