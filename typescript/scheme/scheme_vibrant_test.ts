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

import {SchemeVibrant} from './scheme_vibrant.js';

beforeEach(() => {
  jasmine.addMatchers(customMatchers);
});

describe('scheme vibrant test', () => {
  it('keyColors', () => {
    const scheme = new SchemeVibrant(Hct.fromInt(0xff0000ff), false, 0.0);

    expect(MaterialDynamicColors.primaryPaletteKeyColor.getArgb(scheme)).matchesColor(0xff080CFF);
    expect(MaterialDynamicColors.secondaryPaletteKeyColor.getArgb(scheme)).matchesColor(0xff7B7296);
    expect(MaterialDynamicColors.tertiaryPaletteKeyColor.getArgb(scheme)).matchesColor(0xff886C9D);
    expect(MaterialDynamicColors.neutralPaletteKeyColor.getArgb(scheme)).matchesColor(0xff777682);
    expect(MaterialDynamicColors.neutralVariantPaletteKeyColor.getArgb(scheme)).matchesColor(0xff767685);
  });
  
  it('lightTheme_minContrast_primary', () => {
    const scheme = new SchemeVibrant(Hct.fromInt(0xff0000ff), false, -1.0);
    expect(MaterialDynamicColors.primary.getArgb(scheme)).matchesColor(0xff5660ff);
  });

  it('lightTheme_standardContrast_primary', () => {
    const scheme = new SchemeVibrant(Hct.fromInt(0xff0000ff), false, 0.0);
    expect(MaterialDynamicColors.primary.getArgb(scheme)).matchesColor(0xff343dff);
  });

  it('lightTheme_maxContrast_primary', () => {
    const scheme = new SchemeVibrant(Hct.fromInt(0xff0000ff), false, 1.0);
    expect(MaterialDynamicColors.primary.getArgb(scheme)).matchesColor(0xff000181);
  });

  it('lightTheme_minContrast_primaryContainer', () => {
    const scheme = new SchemeVibrant(Hct.fromInt(0xff0000ff), false, -1.0);
    expect(MaterialDynamicColors.primaryContainer.getArgb(scheme)).matchesColor(0xffe0e0ff);
  });

  it('lightTheme_standardContrast_primaryContainer', () => {
    const scheme = new SchemeVibrant(Hct.fromInt(0xff0000ff), false, 0.0);
    expect(MaterialDynamicColors.primaryContainer.getArgb(scheme)).matchesColor(0xffe0e0ff);
  });

  it('lightTheme_maxContrast_primaryContainer', () => {
    const scheme = new SchemeVibrant(Hct.fromInt(0xff0000ff), false, 1.0);
    expect(MaterialDynamicColors.primaryContainer.getArgb(scheme)).matchesColor(0xff0000e3);
  });

  it('lightTheme_minContrast_onPrimaryContainer', () => {
    const scheme = new SchemeVibrant(Hct.fromInt(0xff0000ff), false, -1.0);
    expect(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme)).matchesColor(0xff3e47ff);
  });

  it('lightTheme_standardContrast_onPrimaryContainer', () => {
    const scheme = new SchemeVibrant(Hct.fromInt(0xff0000ff), false, 0.0);
    expect(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme)).matchesColor(0xff00006e);
  });

  it('lightTheme_maxContrast_onPrimaryContainer', () => {
    const scheme = new SchemeVibrant(Hct.fromInt(0xff0000ff), false, 1.0);
    expect(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme)).matchesColor(0xffd6d6ff);
  });

  it('lightTheme_minContrast_surface', () => {
    const scheme = new SchemeVibrant(Hct.fromInt(0xff0000ff), false, -1.0);
    expect(MaterialDynamicColors.surface.getArgb(scheme)).matchesColor(0xfffbf8ff);
  });

  it('lightTheme_standardContrast_surface', () => {
    const scheme = new SchemeVibrant(Hct.fromInt(0xff0000ff), false, 0.0);
    expect(MaterialDynamicColors.surface.getArgb(scheme)).matchesColor(0xfffbf8ff);
  });

  it('lightTheme_maxContrast_surface', () => {
    const scheme = new SchemeVibrant(Hct.fromInt(0xff0000ff), false, 1.0);
    expect(MaterialDynamicColors.surface.getArgb(scheme)).matchesColor(0xfffbf8ff);
  });

  it('darkTheme_minContrast_primary', () => {
    const scheme = new SchemeVibrant(Hct.fromInt(0xff0000ff), true, -1.0);
    expect(MaterialDynamicColors.primary.getArgb(scheme)).matchesColor(0xff5660ff);
  });

  it('darkTheme_standardContrast_primary', () => {
    const scheme = new SchemeVibrant(Hct.fromInt(0xff0000ff), true, 0.0);
    expect(MaterialDynamicColors.primary.getArgb(scheme)).matchesColor(0xffbec2ff);
  });

  it('darkTheme_maxContrast_primary', () => {
    const scheme = new SchemeVibrant(Hct.fromInt(0xff0000ff), true, 1.0);
    expect(MaterialDynamicColors.primary.getArgb(scheme)).matchesColor(0xfff6f4ff);
  });

  it('darkTheme_minContrast_primaryContainer', () => {
    const scheme = new SchemeVibrant(Hct.fromInt(0xff0000ff), true, -1.0);
    expect(MaterialDynamicColors.primaryContainer.getArgb(scheme)).matchesColor(0xff0000ef);
  });

  it('darkTheme_standardContrast_primaryContainer', () => {
    const scheme = new SchemeVibrant(Hct.fromInt(0xff0000ff), true, 0.0);
    expect(MaterialDynamicColors.primaryContainer.getArgb(scheme)).matchesColor(0xff0000ef);
  });

  it('darkTheme_maxContrast_primaryContainer', () => {
    const scheme = new SchemeVibrant(Hct.fromInt(0xff0000ff), true, 1.0);
    expect(MaterialDynamicColors.primaryContainer.getArgb(scheme)).matchesColor(0xffc4c6ff);
  });

  it('darkTheme_minContrast_onPrimaryContainer', () => {
    const scheme = new SchemeVibrant(Hct.fromInt(0xff0000ff), true, -1.0);
    expect(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme)).matchesColor(0xffa9afff);
  });

  it('darkTheme_standardContrast_onPrimaryContainer', () => {
    const scheme = new SchemeVibrant(Hct.fromInt(0xff0000ff), true, 0.0);
    expect(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme)).matchesColor(0xffe0e0ff);
  });

  it('darkTheme_maxContrast_onPrimaryContainer', () => {
    const scheme = new SchemeVibrant(Hct.fromInt(0xff0000ff), true, 1.0);
    expect(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme)).matchesColor(0xff0001c6);
  });

  it('darkTheme_minContrast_onTertiaryContainer', () => {
    const scheme = new SchemeVibrant(Hct.fromInt(0xff0000ff), true, -1.0);
    expect(MaterialDynamicColors.onTertiaryContainer.getArgb(scheme)).matchesColor(0xffc9a9df);
  });

  it('darkTheme_standardContrast_onTertiaryContainer', () => {
    const scheme = new SchemeVibrant(Hct.fromInt(0xff0000ff), true, 0.0);
    expect(MaterialDynamicColors.onTertiaryContainer.getArgb(scheme)).matchesColor(0xfff2daff);
  });

  it('darkTheme_maxContrast_onTertiaryContainer', () => {
    const scheme = new SchemeVibrant(Hct.fromInt(0xff0000ff), true, 1.0);
    expect(MaterialDynamicColors.onTertiaryContainer.getArgb(scheme)).matchesColor(0xff472e5b);
  });

  it('darkTheme_minContrast_surface', () => {
    const scheme = new SchemeVibrant(Hct.fromInt(0xff0000ff), true, -1.0);
    expect(MaterialDynamicColors.surface.getArgb(scheme)).matchesColor(0xff12131c);
  });

  it('darkTheme_standardContrast_surface', () => {
    const scheme = new SchemeVibrant(Hct.fromInt(0xff0000ff), true, 0.0);
    expect(MaterialDynamicColors.surface.getArgb(scheme)).matchesColor(0xff12131c);
  });

  it('darkTheme_maxContrast_surface', () => {
    const scheme = new SchemeVibrant(Hct.fromInt(0xff0000ff), true, 1.0);
    expect(MaterialDynamicColors.surface.getArgb(scheme)).matchesColor(0xff12131c);
  });
});
