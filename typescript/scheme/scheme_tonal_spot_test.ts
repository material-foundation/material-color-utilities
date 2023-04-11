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

import {SchemeTonalSpot} from './scheme_tonal_spot.js';

beforeEach(() => {
  jasmine.addMatchers(customMatchers);
});

describe('scheme tonal spot test', () => {
  it('lightTheme minContrast primary', () => {
    const scheme = new SchemeTonalSpot(
        Hct.fromInt(0xff0000ff),
        false,
        -1.0,
    );
    expect(MaterialDynamicColors.primary.getArgb(scheme))
        .matchesColor(0xff6a6fb1);
  });

  it('lightTheme standardContrast primary', () => {
    const scheme = new SchemeTonalSpot(
        Hct.fromInt(0xff0000ff),
        false,
        0.0,
    );
    expect(MaterialDynamicColors.primary.getArgb(scheme))
        .matchesColor(0xff545999);
  });

  it('lightTheme maxContrast primary', () => {
    const scheme = new SchemeTonalSpot(
        Hct.fromInt(0xff0000ff),
        false,
        1.0,
    );
    expect(MaterialDynamicColors.primary.getArgb(scheme))
        .matchesColor(0xff161a59);
  });

  it('lightTheme minContrast primaryContainer', () => {
    const scheme = new SchemeTonalSpot(
        Hct.fromInt(0xff0000ff),
        false,
        -1.0,
    );
    expect(MaterialDynamicColors.primaryContainer.getArgb(scheme))
        .matchesColor(0xffe0e0ff);
  });

  it('lightTheme standardContrast primaryContainer', () => {
    const scheme = new SchemeTonalSpot(
        Hct.fromInt(0xff0000ff),
        false,
        0.0,
    );
    expect(MaterialDynamicColors.primaryContainer.getArgb(scheme))
        .matchesColor(0xffe0e0ff);
  });

  it('lightTheme maxContrast primaryContainer', () => {
    const scheme = new SchemeTonalSpot(
        Hct.fromInt(0xff0000ff),
        false,
        1.0,
    );
    expect(MaterialDynamicColors.primaryContainer.getArgb(scheme))
        .matchesColor(0xff383c7c);
  });

  it('lightTheme minContrast onPrimaryContainer', () => {
    const scheme = new SchemeTonalSpot(
        Hct.fromInt(0xff0000ff),
        false,
        -1.0,
    );
    expect(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme))
        .matchesColor(0xff5a5fa0);
  });

  it('lightTheme standardContrast onPrimaryContainer', () => {
    const scheme = new SchemeTonalSpot(
        Hct.fromInt(0xff0000ff),
        false,
        0.0,
    );
    expect(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme))
        .matchesColor(0xff0e1253);
  });

  it('lightTheme maxContrast onPrimaryContainer', () => {
    const scheme = new SchemeTonalSpot(
        Hct.fromInt(0xff0000ff),
        false,
        1.0,
    );
    expect(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme))
        .matchesColor(0xffd6d6ff);
  });

  it('lightTheme minContrast surface', () => {
    const scheme = new SchemeTonalSpot(
        Hct.fromInt(0xff0000ff),
        false,
        -1.0,
    );
    expect(MaterialDynamicColors.surface.getArgb(scheme))
        .matchesColor(0xfffbf8ff);
  });

  it('lightTheme standardContrast surface', () => {
    const scheme = new SchemeTonalSpot(
        Hct.fromInt(0xff0000ff),
        false,
        0.0,
    );
    expect(MaterialDynamicColors.surface.getArgb(scheme))
        .matchesColor(0xfffbf8ff);
  });

  it('lightTheme maxContrast surface', () => {
    const scheme = new SchemeTonalSpot(
        Hct.fromInt(0xff0000ff),
        false,
        1.0,
    );
    expect(MaterialDynamicColors.surface.getArgb(scheme))
        .matchesColor(0xfffbf8ff);
  });

  it('lightTheme minContrast onSurface', () => {
    const scheme = new SchemeTonalSpot(
        Hct.fromInt(0xff0000ff),
        false,
        -1.0,
    );
    expect(MaterialDynamicColors.onSurface.getArgb(scheme))
        .matchesColor(0xff5f5e65);
  });

  it('lightTheme standardContrast onSurface', () => {
    const scheme = new SchemeTonalSpot(
        Hct.fromInt(0xff0000ff),
        false,
        0.0,
    );
    expect(MaterialDynamicColors.onSurface.getArgb(scheme))
        .matchesColor(0xff1b1b21);
  });

  it('lightTheme maxContrast onSurface', () => {
    const scheme = new SchemeTonalSpot(
        Hct.fromInt(0xff0000ff),
        false,
        1.0,
    );
    expect(MaterialDynamicColors.onSurface.getArgb(scheme))
        .matchesColor(0xff1a1a20);
  });

  it('lightTheme minContrast onSecondary', () => {
    const scheme = new SchemeTonalSpot(
        Hct.fromInt(0xff0000ff),
        false,
        -1.0,
    );
    expect(MaterialDynamicColors.onSecondary.getArgb(scheme))
        .matchesColor(0xffcfcfe7);
  });

  it('lightTheme standardContrast onSecondary', () => {
    const scheme = new SchemeTonalSpot(
        Hct.fromInt(0xff0000ff),
        false,
        0.0,
    );
    expect(MaterialDynamicColors.onSecondary.getArgb(scheme))
        .matchesColor(0xffffffff);
  });

  it('lightTheme maxContrast onSecondary', () => {
    const scheme = new SchemeTonalSpot(
        Hct.fromInt(0xff0000ff),
        false,
        1.0,
    );
    expect(MaterialDynamicColors.onSecondary.getArgb(scheme))
        .matchesColor(0xffababc3);
  });

  it('lightTheme minContrast onTertiary', () => {
    const scheme = new SchemeTonalSpot(
        Hct.fromInt(0xff0000ff),
        false,
        -1.0,
    );
    expect(MaterialDynamicColors.onTertiary.getArgb(scheme))
        .matchesColor(0xfff3c3df);
  });

  it('lightTheme standardContrast onTertiary', () => {
    const scheme = new SchemeTonalSpot(
        Hct.fromInt(0xff0000ff),
        false,
        0.0,
    );
    expect(MaterialDynamicColors.onTertiary.getArgb(scheme))
        .matchesColor(0xffffffff);
  });

  it('lightTheme maxContrast onTertiary', () => {
    const scheme = new SchemeTonalSpot(
        Hct.fromInt(0xff0000ff),
        false,
        1.0,
    );
    expect(MaterialDynamicColors.onTertiary.getArgb(scheme))
        .matchesColor(0xffcda0bb);
  });

  it('lightTheme minContrast onError', () => {
    const scheme = new SchemeTonalSpot(
        Hct.fromInt(0xff0000ff),
        false,
        -1.0,
    );
    expect(MaterialDynamicColors.onError.getArgb(scheme))
        .matchesColor(0xffffc2bb);
  });

  it('lightTheme standardContrast onError', () => {
    const scheme = new SchemeTonalSpot(
        Hct.fromInt(0xff0000ff),
        false,
        0.0,
    );
    expect(MaterialDynamicColors.onError.getArgb(scheme))
        .matchesColor(0xffffffff);
  });

  it('lightTheme maxContrast onError', () => {
    const scheme = new SchemeTonalSpot(
        Hct.fromInt(0xff0000ff),
        false,
        1.0,
    );
    expect(MaterialDynamicColors.onError.getArgb(scheme))
        .matchesColor(0xffff8d80);
  });

  it('darkTheme minContrast primary', () => {
    const scheme = new SchemeTonalSpot(
        Hct.fromInt(0xff0000ff),
        true,
        -1.0,
    );
    expect(MaterialDynamicColors.primary.getArgb(scheme))
        .matchesColor(0xff6a6fb1);
  });

  it('darkTheme standardContrast primary', () => {
    const scheme = new SchemeTonalSpot(
        Hct.fromInt(0xff0000ff),
        true,
        0.0,
    );
    expect(MaterialDynamicColors.primary.getArgb(scheme))
        .matchesColor(0xffbec2ff);
  });

  it('darkTheme maxContrast primary', () => {
    const scheme = new SchemeTonalSpot(
        Hct.fromInt(0xff0000ff),
        true,
        1.0,
    );
    expect(MaterialDynamicColors.primary.getArgb(scheme))
        .matchesColor(0xfff6f4ff);
  });

  it('darkTheme minContrast primaryContainer', () => {
    const scheme = new SchemeTonalSpot(
        Hct.fromInt(0xff0000ff),
        true,
        -1.0,
    );
    expect(MaterialDynamicColors.primaryContainer.getArgb(scheme))
        .matchesColor(0xff3c4180);
  });

  it('darkTheme standardContrast primaryContainer', () => {
    const scheme = new SchemeTonalSpot(
        Hct.fromInt(0xff0000ff),
        true,
        0.0,
    );
    expect(MaterialDynamicColors.primaryContainer.getArgb(scheme))
        .matchesColor(0xff3c4180);
  });

  it('darkTheme maxContrast primaryContainer', () => {
    const scheme = new SchemeTonalSpot(
        Hct.fromInt(0xff0000ff),
        true,
        1.0,
    );
    expect(MaterialDynamicColors.primaryContainer.getArgb(scheme))
        .matchesColor(0xffc4c6ff);
  });

  it('darkTheme minContrast onPrimaryContainer', () => {
    const scheme = new SchemeTonalSpot(
        Hct.fromInt(0xff0000ff),
        true,
        -1.0,
    );
    expect(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme))
        .matchesColor(0xffabaff7);
  });

  it('darkTheme standardContrast onPrimaryContainer', () => {
    const scheme = new SchemeTonalSpot(
        Hct.fromInt(0xff0000ff),
        true,
        0.0,
    );
    expect(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme))
        .matchesColor(0xffe0e0ff);
  });

  it('darkTheme maxContrast onPrimaryContainer', () => {
    const scheme = new SchemeTonalSpot(
        Hct.fromInt(0xff0000ff),
        true,
        1.0,
    );
    expect(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme))
        .matchesColor(0xff2e3271);
  });

  it('darkTheme minContrast onSecondary', () => {
    const scheme = new SchemeTonalSpot(
        Hct.fromInt(0xff0000ff),
        true,
        -1.0,
    );
    expect(MaterialDynamicColors.onSecondary.getArgb(scheme))
        .matchesColor(0xfffffbff);
  });

  it('darkTheme standardContrast onSecondary', () => {
    const scheme = new SchemeTonalSpot(
        Hct.fromInt(0xff0000ff),
        true,
        0.0,
    );
    expect(MaterialDynamicColors.onSecondary.getArgb(scheme))
        .matchesColor(0xff2e2f42);
  });

  it('darkTheme maxContrast onSecondary', () => {
    const scheme = new SchemeTonalSpot(
        Hct.fromInt(0xff0000ff),
        true,
        1.0,
    );
    expect(MaterialDynamicColors.onSecondary.getArgb(scheme))
        .matchesColor(0xff505165);
  });

  it('darkTheme minContrast onTertiaryContainer', () => {
    const scheme = new SchemeTonalSpot(
        Hct.fromInt(0xff0000ff),
        true,
        -1.0,
    );
    expect(MaterialDynamicColors.onTertiaryContainer.getArgb(scheme))
        .matchesColor(0xffd5a8c3);
  });

  it('darkTheme standardContrast onTertiaryContainer', () => {
    const scheme = new SchemeTonalSpot(
        Hct.fromInt(0xff0000ff),
        true,
        0.0,
    );
    expect(MaterialDynamicColors.onTertiaryContainer.getArgb(scheme))
        .matchesColor(0xffffd8ee);
  });

  it('darkTheme maxContrast onTertiaryContainer', () => {
    const scheme = new SchemeTonalSpot(
        Hct.fromInt(0xff0000ff),
        true,
        1.0,
    );
    expect(MaterialDynamicColors.onTertiaryContainer.getArgb(scheme))
        .matchesColor(0xff4f2e44);
  });

  it('darkTheme minContrast onTertiary', () => {
    const scheme = new SchemeTonalSpot(
        Hct.fromInt(0xff0000ff),
        true,
        -1.0,
    );
    expect(MaterialDynamicColors.onTertiary.getArgb(scheme))
        .matchesColor(0xfffffbff);
  });

  it('darkTheme standardContrast onTertiary', () => {
    const scheme = new SchemeTonalSpot(
        Hct.fromInt(0xff0000ff),
        true,
        0.0,
    );
    expect(MaterialDynamicColors.onTertiary.getArgb(scheme))
        .matchesColor(0xff46263b);
  });

  it('darkTheme maxContrast onTertiary', () => {
    const scheme = new SchemeTonalSpot(
        Hct.fromInt(0xff0000ff),
        true,
        1.0,
    );
    expect(MaterialDynamicColors.onTertiary.getArgb(scheme))
        .matchesColor(0xff6b485f);
  });

  it('darkTheme minContrast onError', () => {
    const scheme = new SchemeTonalSpot(
        Hct.fromInt(0xff0000ff),
        true,
        -1.0,
    );
    expect(MaterialDynamicColors.onError.getArgb(scheme))
        .matchesColor(0xfffffbff);
  });

  it('darkTheme standardContrast onError', () => {
    const scheme = new SchemeTonalSpot(
        Hct.fromInt(0xff0000ff),
        true,
        0.0,
    );
    expect(MaterialDynamicColors.onError.getArgb(scheme))
        .matchesColor(0xff690005);
  });

  it('darkTheme maxContrast onError', () => {
    const scheme = new SchemeTonalSpot(
        Hct.fromInt(0xff0000ff),
        true,
        1.0,
    );
    expect(MaterialDynamicColors.onError.getArgb(scheme))
        .matchesColor(0xffa80710);
  });

  it('darkTheme minContrast surface', () => {
    const scheme = new SchemeTonalSpot(
        Hct.fromInt(0xff0000ff),
        true,
        -1.0,
    );
    expect(MaterialDynamicColors.surface.getArgb(scheme))
        .matchesColor(0xff131318);
  });

  it('darkTheme standardContrast surface', () => {
    const scheme = new SchemeTonalSpot(
        Hct.fromInt(0xff0000ff),
        true,
        0.0,
    );
    expect(MaterialDynamicColors.surface.getArgb(scheme))
        .matchesColor(0xff131318);
  });

  it('darkTheme maxContrast surface', () => {
    const scheme = new SchemeTonalSpot(
        Hct.fromInt(0xff0000ff),
        true,
        1.0,
    );
    expect(MaterialDynamicColors.surface.getArgb(scheme))
        .matchesColor(0xff131318);
  });

  it('darkTheme minContrast onSurface', () => {
    const scheme = new SchemeTonalSpot(
        Hct.fromInt(0xff0000ff),
        true,
        -1.0,
    );
    expect(MaterialDynamicColors.onSurface.getArgb(scheme))
        .matchesColor(0xffa4a2a9);
  });

  it('darkTheme standardContrast onSurface', () => {
    const scheme = new SchemeTonalSpot(
        Hct.fromInt(0xff0000ff),
        true,
        0.0,
    );
    expect(MaterialDynamicColors.onSurface.getArgb(scheme))
        .matchesColor(0xffe4e1e9);
  });

  it('darkTheme maxContrast onSurface', () => {
    const scheme = new SchemeTonalSpot(
        Hct.fromInt(0xff0000ff),
        true,
        1.0,
    );
    expect(MaterialDynamicColors.onSurface.getArgb(scheme))
        .matchesColor(0xffe5e2ea);
  });

  it('lightTheme colors are correct', () => {
    const scheme = new SchemeTonalSpot(
        Hct.fromInt(0xff0000ff),
        false,
        0.0,
    );
    expect(MaterialDynamicColors.surfaceInverse.getArgb(scheme))
        .matchesColor(0xff47464c);
    expect(MaterialDynamicColors.onSurfaceInverse.getArgb(scheme))
        .matchesColor(0xfff2eff7);
    expect(MaterialDynamicColors.outlineVariant.getArgb(scheme))
        .matchesColor(0xffc7c5d0);
    expect(MaterialDynamicColors.shadow.getArgb(scheme))
        .matchesColor(0xff000000);
    expect(MaterialDynamicColors.scrim.getArgb(scheme))
        .matchesColor(0xff000000);
    expect(MaterialDynamicColors.surfaceTint.getArgb(scheme))
        .matchesColor(0xff545999);
    expect(MaterialDynamicColors.primaryInverse.getArgb(scheme))
        .matchesColor(0xffbec2ff);
    expect(MaterialDynamicColors.onPrimaryInverse.getArgb(scheme))
        .matchesColor(0xff252968);
  });

  it('darkTheme colors are correct', () => {
    const scheme = new SchemeTonalSpot(
        Hct.fromInt(0xff0000ff),
        true,
        0.0,
    );
    expect(MaterialDynamicColors.surfaceInverse.getArgb(scheme))
        .matchesColor(0xffe4e1e9);
    expect(MaterialDynamicColors.onSurfaceInverse.getArgb(scheme))
        .matchesColor(0xff303036);
    expect(MaterialDynamicColors.outlineVariant.getArgb(scheme))
        .matchesColor(0xff46464f);
    expect(MaterialDynamicColors.shadow.getArgb(scheme))
        .matchesColor(0xff000000);
    expect(MaterialDynamicColors.scrim.getArgb(scheme))
        .matchesColor(0xff000000);
    expect(MaterialDynamicColors.surfaceTint.getArgb(scheme))
        .matchesColor(0xffbec2ff);
    expect(MaterialDynamicColors.primaryInverse.getArgb(scheme))
        .matchesColor(0xff545999);
    expect(MaterialDynamicColors.onPrimaryInverse.getArgb(scheme))
        .matchesColor(0xffffffff);
  });
});
