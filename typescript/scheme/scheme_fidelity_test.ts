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

import {SchemeFidelity} from './scheme_fidelity.js';

beforeEach(() => {
  jasmine.addMatchers(customMatchers);
});

describe('scheme fidelity test', () => {
  it('keyColors', () => {
    const scheme = new SchemeFidelity(Hct.fromInt(0xff0000ff), false, 0.0);

    expect(MaterialDynamicColors.primaryPaletteKeyColor.getArgb(scheme)).matchesColor(0xff080CFF);
    expect(MaterialDynamicColors.secondaryPaletteKeyColor.getArgb(scheme)).matchesColor(0xff656DD3);
    expect(MaterialDynamicColors.tertiaryPaletteKeyColor.getArgb(scheme)).matchesColor(0xff9D0002);
    expect(MaterialDynamicColors.neutralPaletteKeyColor.getArgb(scheme)).matchesColor(0xff767684);
    expect(MaterialDynamicColors.neutralVariantPaletteKeyColor.getArgb(scheme)).matchesColor(0xff757589);
  });

  it('lightTheme_minContrast_primary', () => {
    const scheme = new SchemeFidelity(
        Hct.fromInt(0xFF0000ff),
        false,
        -1.0,
    );
    expect(MaterialDynamicColors.primary.getArgb(scheme))
        .matchesColor(0xFF1218FF);
  });

  it('lightTheme_standardContrast_primary', () => {
    const scheme = new SchemeFidelity(
        Hct.fromInt(0xFF0000ff),
        false,
        0,
    );
    expect(MaterialDynamicColors.primary.getArgb(scheme))
        .matchesColor(0xFF0001C3);
  });

  it('lightTheme_maxContrast_primary', () => {
    const scheme = new SchemeFidelity(
        Hct.fromInt(0xFF0000ff),
        false,
        1,
    );
    expect(MaterialDynamicColors.primary.getArgb(scheme))
        .matchesColor(0xFF000181);
  });

  it('lightTheme_minContrast_primaryContainer', () => {
    const scheme = new SchemeFidelity(
        Hct.fromInt(0xFF0000ff),
        false,
        -1,
    );
    expect(MaterialDynamicColors.primaryContainer.getArgb(scheme))
        .matchesColor(0xFF5660FF);
  });

  it('lightTheme_standardContrast_primaryContainer', () => {
    const scheme = new SchemeFidelity(
        Hct.fromInt(0xFF0000ff),
        false,
        0,
    );
    expect(MaterialDynamicColors.primaryContainer.getArgb(scheme))
        .matchesColor(0xFF2D36FF);
  });

  it('lightTheme_maxContrast_primaryContainer', () => {
    const scheme = new SchemeFidelity(
        Hct.fromInt(0xFF0000ff),
        false,
        1,
    );
    expect(MaterialDynamicColors.primaryContainer.getArgb(scheme))
        .matchesColor(0xFF0000E3);
  });

  it('lightTheme_minContrast_tertiaryContainer', () => {
    const scheme = new SchemeFidelity(
        Hct.fromInt(0xFF0000ff),
        false,
        -1,
    );
    expect(MaterialDynamicColors.tertiaryContainer.getArgb(scheme))
        .matchesColor(0xFFD93628);
  });

  it('lightTheme_standardContrast_tertiaryContainer', () => {
    const scheme = new SchemeFidelity(
        Hct.fromInt(0xFF0000ff),
        false,
        0,
    );
    expect(MaterialDynamicColors.tertiaryContainer.getArgb(scheme))
        .matchesColor(0xFFB31910);
  });

  it('lightTheme_maxContrast_tertiaryContainer', () => {
    const scheme = new SchemeFidelity(
        Hct.fromInt(0xFF0000ff),
        false,
        1,
    );
    expect(MaterialDynamicColors.tertiaryContainer.getArgb(scheme))
        .matchesColor(0xFF8C0002);
  });

  it('lightTheme_minContrast_objectionableTertiaryContainerLightens', () => {
    const scheme = new SchemeFidelity(
        Hct.fromInt(0xFF850096),
        false,
        -1,
    );
    expect(MaterialDynamicColors.tertiaryContainer.getArgb(scheme))
        .matchesColor(0xFFBCAC5A);
  });

  it('lightTheme_standardContrast_objectionableTertiaryContainerLightens',
     () => {
       const scheme = new SchemeFidelity(
           Hct.fromInt(0xFF850096),
           false,
           0,
       );
       expect(MaterialDynamicColors.tertiaryContainer.getArgb(scheme))
           .matchesColor(0xFFBCAC5A);
     });

  it('lightTheme_maxContrast_objectionableTertiaryContainerDarkens', () => {
    const scheme = new SchemeFidelity(
        Hct.fromInt(0xFF850096),
        false,
        1,
    );
    expect(MaterialDynamicColors.tertiaryContainer.getArgb(scheme))
        .matchesColor(0xFF4D4300);
  });

  it('lightTheme_minContrast_onPrimaryContainer', () => {
    const scheme = new SchemeFidelity(
        Hct.fromInt(0xFF0000ff),
        false,
        -1,
    );
    expect(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme))
        .matchesColor(0xFFCBCDFF);
  });

  it('lightTheme_standardContrast_onPrimaryContainer', () => {
    const scheme = new SchemeFidelity(
        Hct.fromInt(0xFF0000ff),
        false,
        0,
    );
    expect(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme))
        .matchesColor(0xFFCECFFF);
  });

  it('lightTheme_maxContrast_onPrimaryContainer', () => {
    const scheme = new SchemeFidelity(
        Hct.fromInt(0xFF0000ff),
        false,
        1,
    );
    expect(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme))
        .matchesColor(0xFFD6D6FF);
  });

  it('lightTheme_minContrast_surface', () => {
    const scheme = new SchemeFidelity(
        Hct.fromInt(0xFF0000ff),
        false,
        -1,
    );
    expect(MaterialDynamicColors.surface.getArgb(scheme))
        .matchesColor(0xFFFBF8FF);
  });

  it('lightTheme_standardContrast_surface', () => {
    const scheme = new SchemeFidelity(
        Hct.fromInt(0xFF0000ff),
        false,
        0.0,
    );
    expect(MaterialDynamicColors.surface.getArgb(scheme))
        .matchesColor(0xFFFBF8FF);
  });

  it('lightTheme_maxContrast_surface', () => {
    const scheme = new SchemeFidelity(
        Hct.fromInt(0xFF0000ff),
        false,
        1.0,
    );
    expect(MaterialDynamicColors.surface.getArgb(scheme))
        .matchesColor(0xFFFBF8FF);
  });

  it('darkTheme_minContrast_primary', () => {
    const scheme = new SchemeFidelity(
        Hct.fromInt(0xFF0000ff),
        true,
        -1.0,
    );
    expect(MaterialDynamicColors.primary.getArgb(scheme))
        .matchesColor(0xFF5660FF);
  });

  it('darkTheme_standardContrast_primary', () => {
    const scheme = new SchemeFidelity(
        Hct.fromInt(0xFF0000ff),
        true,
        0.0,
    );
    expect(MaterialDynamicColors.primary.getArgb(scheme))
        .matchesColor(0xFFBEC2FF);
  });

  it('darkTheme_maxContrast_primary', () => {
    const scheme = new SchemeFidelity(
        Hct.fromInt(0xFF0000ff),
        true,
        1.0,
    );
    expect(MaterialDynamicColors.primary.getArgb(scheme))
        .matchesColor(0xFFF6F4FF);
  });

  it('darkTheme_minContrast_primaryContainer', () => {
    const scheme = new SchemeFidelity(
        Hct.fromInt(0xFF0000ff),
        true,
        -1.0,
    );
    expect(MaterialDynamicColors.primaryContainer.getArgb(scheme))
        .matchesColor(0xFF0000E6);
  });

  it('darkTheme_standardContrast_primaryContainer', () => {
    const scheme = new SchemeFidelity(
        Hct.fromInt(0xFF0000ff),
        true,
        0.0,
    );
    expect(MaterialDynamicColors.primaryContainer.getArgb(scheme))
        .matchesColor(0xFF0000E6);
  });

  it('darkTheme_maxContrast_primaryContainer', () => {
    const scheme = new SchemeFidelity(
        Hct.fromInt(0xFF0000ff),
        true,
        1.0,
    );
    expect(MaterialDynamicColors.primaryContainer.getArgb(scheme))
        .matchesColor(0xFFC4C6FF);
  });

  it('darkTheme_minContrast_onPrimaryContainer', () => {
    const scheme = new SchemeFidelity(
        Hct.fromInt(0xFF0000ff),
        true,
        -1.0,
    );
    expect(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme))
        .matchesColor(0xFF7A83FF);
  });

  it('darkTheme_standardContrast_onPrimaryContainer', () => {
    const scheme = new SchemeFidelity(
        Hct.fromInt(0xFF0000ff),
        true,
        0.0,
    );
    expect(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme))
        .matchesColor(0xFFA4AAFF);
  });

  it('darkTheme_maxContrast_onPrimaryContainer', () => {
    const scheme = new SchemeFidelity(
        Hct.fromInt(0xFF0000ff),
        true,
        1.0,
    );
    expect(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme))
        .matchesColor(0xFF0001C6);
  });

  it('darkTheme_minContrast_onTertiaryContainer', () => {
    const scheme = new SchemeFidelity(
        Hct.fromInt(0xFF0000ff),
        true,
        -1.0,
    );
    expect(MaterialDynamicColors.onTertiaryContainer.getArgb(scheme))
        .matchesColor(0xFFFE513E);
  });

  it('darkTheme_standardContrast_onTertiaryContainer', () => {
    const scheme = new SchemeFidelity(
        Hct.fromInt(0xFF0000ff),
        true,
        0.0,
    );
    expect(MaterialDynamicColors.onTertiaryContainer.getArgb(scheme))
        .matchesColor(0xFFFF9181);
  });

  it('darkTheme_maxContrast_onTertiaryContainer', () => {
    const scheme = new SchemeFidelity(
        Hct.fromInt(0xFF0000ff),
        true,
        1.0,
    );
    expect(MaterialDynamicColors.onTertiaryContainer.getArgb(scheme))
        .matchesColor(0xFF790001);
  });

  it('darkTheme_minContrast_surface', () => {
    const scheme = new SchemeFidelity(
        Hct.fromInt(0xFF0000ff),
        true,
        -1.0,
    );
    expect(MaterialDynamicColors.surface.getArgb(scheme))
        .matchesColor(0xFF12121D);
  });

  it('darkTheme_standardContrast_surface', () => {
    const scheme = new SchemeFidelity(
        Hct.fromInt(0xFF0000ff),
        true,
        0.0,
    );
    expect(MaterialDynamicColors.surface.getArgb(scheme))
        .matchesColor(0xFF12121D);
  });

  it('darkTheme_maxContrast_surface', () => {
    const scheme = new SchemeFidelity(
        Hct.fromInt(0xFF0000ff),
        true,
        1.0,
    );
    expect(MaterialDynamicColors.surface.getArgb(scheme))
        .matchesColor(0xFF12121D);
  });
});
