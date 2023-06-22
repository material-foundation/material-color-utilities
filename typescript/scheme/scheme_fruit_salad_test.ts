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

import {SchemeFruitSalad} from './scheme_fruit_salad.js';

beforeEach(() => {
  jasmine.addMatchers(customMatchers);
});

describe('scheme fruit salad test', () => {
  it('keyColors', () => {
    const scheme = new SchemeFruitSalad(Hct.fromInt(0xff0000ff), false, 0.0);

    expect(MaterialDynamicColors.primaryPaletteKeyColor.getArgb(scheme))
        .matchesColor(0xff0091c0);
    expect(MaterialDynamicColors.secondaryPaletteKeyColor.getArgb(scheme))
        .matchesColor(0xff3a7e9e);
    expect(MaterialDynamicColors.tertiaryPaletteKeyColor.getArgb(scheme))
        .matchesColor(0xff6e72ac);
    expect(MaterialDynamicColors.neutralPaletteKeyColor.getArgb(scheme))
        .matchesColor(0xff777682);
    expect(MaterialDynamicColors.neutralVariantPaletteKeyColor.getArgb(scheme))
        .matchesColor(0xff75758b);
  });

  it('lightTheme_minContrast_primary', () => {
    const scheme = new SchemeFruitSalad(Hct.fromInt(0xff0000ff), false, -1.0);
    expect(MaterialDynamicColors.primary.getArgb(scheme))
        .matchesColor(0xff007ea7);
  });

  it('lightTheme_standardContrast_primary', () => {
    const scheme = new SchemeFruitSalad(Hct.fromInt(0xff0000ff), false, 0.0);
    expect(MaterialDynamicColors.primary.getArgb(scheme))
        .matchesColor(0xff006688);
  });

  it('lightTheme_maxContrast_primary', () => {
    const scheme = new SchemeFruitSalad(Hct.fromInt(0xff0000ff), false, 1.0);
    expect(MaterialDynamicColors.primary.getArgb(scheme))
        .matchesColor(0xff002635);
  });

  it('lightTheme_minContrast_primaryContainer', () => {
    const scheme = new SchemeFruitSalad(Hct.fromInt(0xff0000ff), false, -1.0);
    expect(MaterialDynamicColors.primaryContainer.getArgb(scheme))
        .matchesColor(0xffaae0ff);
  });

  it('lightTheme_standardContrast_primaryContainer', () => {
    const scheme = new SchemeFruitSalad(Hct.fromInt(0xff0000ff), false, 0.0);
    expect(MaterialDynamicColors.primaryContainer.getArgb(scheme))
        .matchesColor(0xffc2e8ff);
  });

  it('lightTheme_maxContrast_primaryContainer', () => {
    const scheme = new SchemeFruitSalad(Hct.fromInt(0xff0000ff), false, 1.0);
    expect(MaterialDynamicColors.primaryContainer.getArgb(scheme))
        .matchesColor(0xff004862);
  });

  it('lightTheme_minContrast_tertiaryContainer', () => {
    const scheme = new SchemeFruitSalad(Hct.fromInt(0xff0000ff), false, -1.0);
    expect(MaterialDynamicColors.tertiaryContainer.getArgb(scheme))
        .matchesColor(0xffd5d6ff);
  });

  it('lightTheme_standardContrast_tertiaryContainer', () => {
    const scheme = new SchemeFruitSalad(Hct.fromInt(0xff0000ff), false, 0.0);
    expect(MaterialDynamicColors.tertiaryContainer.getArgb(scheme))
        .matchesColor(0xffe0e0ff);
  });

  it('lightTheme_maxContrast_tertiaryContainer', () => {
    const scheme = new SchemeFruitSalad(Hct.fromInt(0xff0000ff), false, 1.0);
    expect(MaterialDynamicColors.tertiaryContainer.getArgb(scheme))
        .matchesColor(0xff3a3e74);
  });

  it('lightTheme_minContrast_onPrimaryContainer', () => {
    const scheme = new SchemeFruitSalad(Hct.fromInt(0xff0000ff), false, -1.0);
    expect(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme))
        .matchesColor(0xff006688);
  });

  it('lightTheme_standardContrast_onPrimaryContainer', () => {
    const scheme = new SchemeFruitSalad(Hct.fromInt(0xff0000ff), false, 0.0);
    expect(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme))
        .matchesColor(0xff001e2b);
  });

  it('lightTheme_maxContrast_onPrimaryContainer', () => {
    const scheme = new SchemeFruitSalad(Hct.fromInt(0xff0000ff), false, 1.0);
    expect(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme))
        .matchesColor(0xffffffff);
  });

  it('lightTheme_minContrast_surface', () => {
    const scheme = new SchemeFruitSalad(Hct.fromInt(0xff0000ff), false, -1.0);
    expect(MaterialDynamicColors.surface.getArgb(scheme))
        .matchesColor(0xfffbf8ff);
  });

  it('lightTheme_standardContrast_surface', () => {
    const scheme = new SchemeFruitSalad(Hct.fromInt(0xff0000ff), false, 0.0);
    expect(MaterialDynamicColors.surface.getArgb(scheme))
        .matchesColor(0xfffbf8ff);
  });

  it('lightTheme_maxContrast_surface', () => {
    const scheme = new SchemeFruitSalad(Hct.fromInt(0xff0000ff), false, 1.0);
    expect(MaterialDynamicColors.surface.getArgb(scheme))
        .matchesColor(0xfffbf8ff);
  });

  it('lightTheme_standardContrast_secondary', () => {
    const scheme = new SchemeFruitSalad(Hct.fromInt(0xff0000ff), false, 0.0);
    expect(MaterialDynamicColors.secondary.getArgb(scheme))
        .matchesColor(0xff196584);
  });

  it('lightTheme_standardContrast_secondaryContainer', () => {
    const scheme = new SchemeFruitSalad(Hct.fromInt(0xff0000ff), false, 0.0);
    expect(MaterialDynamicColors.secondaryContainer.getArgb(scheme))
        .matchesColor(0xffc2e8ff);
  });

  it('darkTheme_minContrast_primary', () => {
    const scheme = new SchemeFruitSalad(Hct.fromInt(0xff0000ff), true, -1.0);
    expect(MaterialDynamicColors.primary.getArgb(scheme))
        .matchesColor(0xff1e9bcb);
  });

  it('darkTheme_standardContrast_primary', () => {
    const scheme = new SchemeFruitSalad(Hct.fromInt(0xff0000ff), true, 0.0);
    expect(MaterialDynamicColors.primary.getArgb(scheme))
        .matchesColor(0xff76d1ff);
  });

  it('darkTheme_maxContrast_primary', () => {
    const scheme = new SchemeFruitSalad(Hct.fromInt(0xff0000ff), true, 1.0);
    expect(MaterialDynamicColors.primary.getArgb(scheme))
        .matchesColor(0xfff7fbff);
  });

  it('darkTheme_minContrast_primaryContainer', () => {
    const scheme = new SchemeFruitSalad(Hct.fromInt(0xff0000ff), true, -1.0);
    expect(MaterialDynamicColors.primaryContainer.getArgb(scheme))
        .matchesColor(0xff003f56);
  });

  it('darkTheme_standardContrast_primaryContainer', () => {
    const scheme = new SchemeFruitSalad(Hct.fromInt(0xff0000ff), true, 0.0);
    expect(MaterialDynamicColors.primaryContainer.getArgb(scheme))
        .matchesColor(0xff004d67);
  });

  it('darkTheme_maxContrast_primaryContainer', () => {
    const scheme = new SchemeFruitSalad(Hct.fromInt(0xff0000ff), true, 1.0);
    expect(MaterialDynamicColors.primaryContainer.getArgb(scheme))
        .matchesColor(0xff83d5ff);
  });

  it('darkTheme_minContrast_onPrimaryContainer', () => {
    const scheme = new SchemeFruitSalad(Hct.fromInt(0xff0000ff), true, -1.0);
    expect(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme))
        .matchesColor(0xff3fafe0);
  });

  it('darkTheme_standardContrast_onPrimaryContainer', () => {
    const scheme = new SchemeFruitSalad(Hct.fromInt(0xff0000ff), true, 0.0);
    expect(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme))
        .matchesColor(0xffc2e8ff);
  });

  it('darkTheme_maxContrast_onPrimaryContainer', () => {
    const scheme = new SchemeFruitSalad(Hct.fromInt(0xff0000ff), true, 1.0);
    expect(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme))
        .matchesColor(0xff000000);
  });

  it('darkTheme_minContrast_onTertiaryContainer', () => {
    const scheme = new SchemeFruitSalad(Hct.fromInt(0xff0000ff), true, -1.0);
    expect(MaterialDynamicColors.onTertiaryContainer.getArgb(scheme))
        .matchesColor(0xff9b9fdd);
  });

  it('darkTheme_standardContrast_onTertiaryContainer', () => {
    const scheme = new SchemeFruitSalad(Hct.fromInt(0xff0000ff), true, 0.0);
    expect(MaterialDynamicColors.onTertiaryContainer.getArgb(scheme))
        .matchesColor(0xffe0e0ff);
  });

  it('darkTheme_maxContrast_onTertiaryContainer', () => {
    const scheme = new SchemeFruitSalad(Hct.fromInt(0xff0000ff), true, 1.0);
    expect(MaterialDynamicColors.onTertiaryContainer.getArgb(scheme))
        .matchesColor(0xff000000);
  });

  it('darkTheme_minContrast_surface', () => {
    const scheme = new SchemeFruitSalad(Hct.fromInt(0xff0000ff), true, -1.0);
    expect(MaterialDynamicColors.surface.getArgb(scheme))
        .matchesColor(0xff12131c);
  });

  it('darkTheme_standardContrast_surface', () => {
    const scheme = new SchemeFruitSalad(Hct.fromInt(0xff0000ff), true, 0.0);
    expect(MaterialDynamicColors.surface.getArgb(scheme))
        .matchesColor(0xff12131c);
  });

  it('darkTheme_maxContrast_surface', () => {
    const scheme = new SchemeFruitSalad(Hct.fromInt(0xff0000ff), true, 1.0);
    expect(MaterialDynamicColors.surface.getArgb(scheme))
        .matchesColor(0xff12131c);
  });

  it('darkTheme_standardContrast_secondary', () => {
    const scheme = new SchemeFruitSalad(Hct.fromInt(0xff0000ff), true, 0.0);
    expect(MaterialDynamicColors.secondary.getArgb(scheme))
        .matchesColor(0xff8ecff2);
  });

  it('darkTheme_standardContrast_secondaryContainer', () => {
    const scheme = new SchemeFruitSalad(Hct.fromInt(0xff0000ff), true, 0.0);
    expect(MaterialDynamicColors.secondaryContainer.getArgb(scheme))
        .matchesColor(0xff004d67);
  });
});
