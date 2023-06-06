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
  it('keyColors', () => {
    const scheme = new SchemeExpressive(Hct.fromInt(0xff0000ff), false, 0.0);

    expect(MaterialDynamicColors.primaryPaletteKeyColor.getArgb(scheme))
        .matchesColor(0xff35855F);
    expect(MaterialDynamicColors.secondaryPaletteKeyColor.getArgb(scheme))
        .matchesColor(0xff8C6D8C);
    expect(MaterialDynamicColors.tertiaryPaletteKeyColor.getArgb(scheme))
        .matchesColor(0xff806EA1);
    expect(MaterialDynamicColors.neutralPaletteKeyColor.getArgb(scheme))
        .matchesColor(0xff79757F);
    expect(MaterialDynamicColors.neutralVariantPaletteKeyColor.getArgb(scheme))
        .matchesColor(0xff7A7585);
  });

  it('lightTheme_minContrast_primary', () => {
    const scheme = new SchemeExpressive(Hct.fromInt(0xff0000ff), false, -1.0);
    expect(MaterialDynamicColors.primary.getArgb(scheme))
        .matchesColor(0xff32835D);
  });

  it('lightTheme_standardContrast_primary', () => {
    const scheme = new SchemeExpressive(Hct.fromInt(0xff0000ff), false, 0.0);
    expect(MaterialDynamicColors.primary.getArgb(scheme))
        .matchesColor(0xff146C48);
  });

  it('lightTheme_maxContrast_primary', () => {
    const scheme = new SchemeExpressive(Hct.fromInt(0xff0000ff), false, 1.0);
    expect(MaterialDynamicColors.primary.getArgb(scheme))
        .matchesColor(0xff002818);
  });

  it('lightTheme_minContrast_primaryContainer', () => {
    const scheme = new SchemeExpressive(Hct.fromInt(0xff0000ff), false, -1.0);
    expect(MaterialDynamicColors.primaryContainer.getArgb(scheme))
        .matchesColor(0xffA2F4C6);
  });

  it('lightTheme_standardContrast_primaryContainer', () => {
    const scheme = new SchemeExpressive(Hct.fromInt(0xff0000ff), false, 0.0);
    expect(MaterialDynamicColors.primaryContainer.getArgb(scheme))
        .matchesColor(0xffA2F4C6);
  });

  it('lightTheme_maxContrast_primaryContainer', () => {
    const scheme = new SchemeExpressive(Hct.fromInt(0xff0000ff), false, 1.0);
    expect(MaterialDynamicColors.primaryContainer.getArgb(scheme))
        .matchesColor(0xff004D31);
  });

  it('lightTheme_minContrast_onPrimaryContainer', () => {
    const scheme = new SchemeExpressive(Hct.fromInt(0xff0000ff), false, -1.0);
    expect(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme))
        .matchesColor(0xff1e724e);
  });

  it('lightTheme_standardContrast_onPrimaryContainer', () => {
    const scheme = new SchemeExpressive(Hct.fromInt(0xff0000ff), false, 0.0);
    expect(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme))
        .matchesColor(0xff002112);
  });

  it('lightTheme_maxContrast_onPrimaryContainer', () => {
    const scheme = new SchemeExpressive(Hct.fromInt(0xff0000ff), false, 1.0);
    expect(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme))
        .matchesColor(0xff9aebbe);
  });

  it('lightTheme_minContrast_surface', () => {
    const scheme = new SchemeExpressive(Hct.fromInt(0xff0000ff), false, -1.0);
    expect(MaterialDynamicColors.surface.getArgb(scheme))
        .matchesColor(0xfffdf7ff);
  });

  it('lightTheme_standardContrast_surface', () => {
    const scheme = new SchemeExpressive(Hct.fromInt(0xff0000ff), false, 0.0);
    expect(MaterialDynamicColors.surface.getArgb(scheme))
        .matchesColor(0xfffdf7ff);
  });

  it('lightTheme_maxContrast_surface', () => {
    const scheme = new SchemeExpressive(Hct.fromInt(0xff0000ff), false, 1.0);
    expect(MaterialDynamicColors.surface.getArgb(scheme))
        .matchesColor(0xfffdf7ff);
  });

  it('darkTheme_minContrast_primary', () => {
    const scheme = new SchemeExpressive(Hct.fromInt(0xff0000ff), true, -1.0);
    expect(MaterialDynamicColors.primary.getArgb(scheme))
        .matchesColor(0xff32835d);
  });

  it('darkTheme_standardContrast_primary', () => {
    const scheme = new SchemeExpressive(Hct.fromInt(0xff0000ff), true, 0.0);
    expect(MaterialDynamicColors.primary.getArgb(scheme))
        .matchesColor(0xff87d7ab);
  });

  it('darkTheme_maxContrast_primary', () => {
    const scheme = new SchemeExpressive(Hct.fromInt(0xff0000ff), true, 1.0);
    expect(MaterialDynamicColors.primary.getArgb(scheme))
        .matchesColor(0xffd5ffe4);
  });

  it('darkTheme_minContrast_primaryContainer', () => {
    const scheme = new SchemeExpressive(Hct.fromInt(0xff0000ff), true, -1.0);
    expect(MaterialDynamicColors.primaryContainer.getArgb(scheme))
        .matchesColor(0xff005234);
  });

  it('darkTheme_standardContrast_primaryContainer', () => {
    const scheme = new SchemeExpressive(Hct.fromInt(0xff0000ff), true, 0.0);
    expect(MaterialDynamicColors.primaryContainer.getArgb(scheme))
        .matchesColor(0xff005234);
  });

  it('darkTheme_maxContrast_primaryContainer', () => {
    const scheme = new SchemeExpressive(Hct.fromInt(0xff0000ff), true, 1.0);
    expect(MaterialDynamicColors.primaryContainer.getArgb(scheme))
        .matchesColor(0xff8bdbaf);
  });

  it('darkTheme_minContrast_onPrimaryContainer', () => {
    const scheme = new SchemeExpressive(Hct.fromInt(0xff0000ff), true, -1.0);
    expect(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme))
        .matchesColor(0xff76c59b);
  });

  it('darkTheme_standardContrast_onPrimaryContainer', () => {
    const scheme = new SchemeExpressive(Hct.fromInt(0xff0000ff), true, 0.0);
    expect(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme))
        .matchesColor(0xffa2f4c6);
  });

  it('darkTheme_maxContrast_onPrimaryContainer', () => {
    const scheme = new SchemeExpressive(Hct.fromInt(0xff0000ff), true, 1.0);
    expect(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme))
        .matchesColor(0xff004229);
  });

  it('darkTheme_minContrast_surface', () => {
    const scheme = new SchemeExpressive(Hct.fromInt(0xff0000ff), true, -1.0);
    expect(MaterialDynamicColors.surface.getArgb(scheme))
        .matchesColor(0xff14121a);
  });

  it('darkTheme_standardContrast_surface', () => {
    const scheme = new SchemeExpressive(Hct.fromInt(0xff0000ff), true, 0.0);
    expect(MaterialDynamicColors.surface.getArgb(scheme))
        .matchesColor(0xff14121a);
  });

  it('darkTheme_maxContrast_surface', () => {
    const scheme = new SchemeExpressive(Hct.fromInt(0xff0000ff), true, 1.0);
    expect(MaterialDynamicColors.surface.getArgb(scheme))
        .matchesColor(0xff14121a);
  });
});
