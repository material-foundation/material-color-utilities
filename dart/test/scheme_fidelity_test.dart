// Copyright 2022 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
import 'package:material_color_utilities/dynamiccolor/material_dynamic_colors.dart';
import 'package:material_color_utilities/hct/hct.dart';
import 'package:material_color_utilities/scheme/scheme_fidelity.dart';
import 'package:test/test.dart';
import './utils/color_matcher.dart';

void main() {
  test('keyColors', () {
    final scheme = SchemeFidelity(
        sourceColorHct: Hct.fromInt(0xff0000ff),
        isDark: false,
        contrastLevel: 0.0);

    expect(MaterialDynamicColors.primaryPaletteKeyColor.getArgb(scheme),
        isColor(0xff080CFF));
    expect(MaterialDynamicColors.secondaryPaletteKeyColor.getArgb(scheme),
        isColor(0xff656DD3));
    expect(MaterialDynamicColors.tertiaryPaletteKeyColor.getArgb(scheme),
        isColor(0xff9D0002));
    expect(MaterialDynamicColors.neutralPaletteKeyColor.getArgb(scheme),
        isColor(0xff767684));
    expect(MaterialDynamicColors.neutralVariantPaletteKeyColor.getArgb(scheme),
        isColor(0xff757589));
  });

  test('lightTheme_minContrast_primary', () {
    final scheme = SchemeFidelity(
        sourceColorHct: Hct.fromInt(0xFF0000ff),
        isDark: false,
        contrastLevel: -1.0);
    expect(MaterialDynamicColors.primary.getArgb(scheme), isColor(0xff5660ff));
  });

  test('lightTheme_standardContrast_primary', () {
    final scheme = SchemeFidelity(
        sourceColorHct: Hct.fromInt(0xFF0000ff),
        isDark: false,
        contrastLevel: 0);
    expect(MaterialDynamicColors.primary.getArgb(scheme), isColor(0xFF0001C3));
  });

  test('lightTheme_maxContrast_primary', () {
    final scheme = SchemeFidelity(
        sourceColorHct: Hct.fromInt(0xFF0000ff),
        isDark: false,
        contrastLevel: 1);
    expect(MaterialDynamicColors.primary.getArgb(scheme), isColor(0xFF000181));
  });

  test('lightTheme_minContrast_primaryContainer', () {
    final scheme = SchemeFidelity(
        sourceColorHct: Hct.fromInt(0xFF0000ff),
        isDark: false,
        contrastLevel: -1);
    expect(MaterialDynamicColors.primaryContainer.getArgb(scheme),
        isColor(0xffd5d6ff));
  });

  test('lightTheme_standardContrast_primaryContainer', () {
    final scheme = SchemeFidelity(
        sourceColorHct: Hct.fromInt(0xFF0000ff),
        isDark: false,
        contrastLevel: 0);
    expect(MaterialDynamicColors.primaryContainer.getArgb(scheme),
        isColor(0xFF2D36FF));
  });

  test('lightTheme_maxContrast_primaryContainer', () {
    final scheme = SchemeFidelity(
        sourceColorHct: Hct.fromInt(0xFF0000ff),
        isDark: false,
        contrastLevel: 1);
    expect(MaterialDynamicColors.primaryContainer.getArgb(scheme),
        isColor(0xFF0000E3));
  });

  test('lightTheme_minContrast_tertiaryContainer', () {
    final scheme = SchemeFidelity(
        sourceColorHct: Hct.fromInt(0xFF0000ff),
        isDark: false,
        contrastLevel: -1);
    expect(MaterialDynamicColors.tertiaryContainer.getArgb(scheme),
        isColor(0xffffcdc6));
  });

  test('lightTheme_standardContrast_tertiaryContainer', () {
    final scheme = SchemeFidelity(
        sourceColorHct: Hct.fromInt(0xFF0000ff),
        isDark: false,
        contrastLevel: 0);
    expect(MaterialDynamicColors.tertiaryContainer.getArgb(scheme),
        isColor(0xFFB31910));
  });

  test('lightTheme_maxContrast_tertiaryContainer', () {
    final scheme = SchemeFidelity(
        sourceColorHct: Hct.fromInt(0xFF0000ff),
        isDark: false,
        contrastLevel: 1);
    expect(MaterialDynamicColors.tertiaryContainer.getArgb(scheme),
        isColor(0xFF8C0002));
  });

  test('lightTheme_minContrast_objectionableTertiaryContainerLightens', () {
    final scheme = SchemeFidelity(
        sourceColorHct: Hct.fromInt(0xFF850096),
        isDark: false,
        contrastLevel: -1);
    expect(MaterialDynamicColors.tertiaryContainer.getArgb(scheme),
        isColor(0xffebd982));
  });

  test('lightTheme_standardContrast_objectionableTertiaryContainerLightens',
      () {
    final scheme = SchemeFidelity(
        sourceColorHct: Hct.fromInt(0xFF850096),
        isDark: false,
        contrastLevel: 0);
    expect(MaterialDynamicColors.tertiaryContainer.getArgb(scheme),
        isColor(0xFFBCAC5A));
  });

  test('lightTheme_maxContrast_objectionableTertiaryContainerDarkens', () {
    final scheme = SchemeFidelity(
        sourceColorHct: Hct.fromInt(0xFF850096),
        isDark: false,
        contrastLevel: 1);
    expect(MaterialDynamicColors.tertiaryContainer.getArgb(scheme),
        isColor(0xFF4D4300));
  });

  test('lightTheme_minContrast_onPrimaryContainer', () {
    final scheme = SchemeFidelity(
        sourceColorHct: Hct.fromInt(0xFF0000ff),
        isDark: false,
        contrastLevel: -1);
    expect(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme),
        isColor(0xff333dff));
  });

  test('lightTheme_standardContrast_onPrimaryContainer', () {
    final scheme = SchemeFidelity(
        sourceColorHct: Hct.fromInt(0xFF0000ff),
        isDark: false,
        contrastLevel: 0);
    expect(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme),
        isColor(0xffffffff));
  });

  test('lightTheme_maxContrast_onPrimaryContainer', () {
    final scheme = SchemeFidelity(
        sourceColorHct: Hct.fromInt(0xFF0000ff),
        isDark: false,
        contrastLevel: 1);
    expect(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme),
        isColor(0xffffffff));
  });

  test('lightTheme_minContrast_surface', () {
    final scheme = SchemeFidelity(
        sourceColorHct: Hct.fromInt(0xFF0000ff),
        isDark: false,
        contrastLevel: -1);
    expect(MaterialDynamicColors.surface.getArgb(scheme), isColor(0xFFFBF8FF));
  });

  test('lightTheme_standardContrast_surface', () {
    final scheme = SchemeFidelity(
        sourceColorHct: Hct.fromInt(0xFF0000ff),
        isDark: false,
        contrastLevel: 0.0);
    expect(MaterialDynamicColors.surface.getArgb(scheme), isColor(0xFFFBF8FF));
  });

  test('lightTheme_maxContrast_surface', () {
    final scheme = SchemeFidelity(
        sourceColorHct: Hct.fromInt(0xFF0000ff),
        isDark: false,
        contrastLevel: 1.0);
    expect(MaterialDynamicColors.surface.getArgb(scheme), isColor(0xFFFBF8FF));
  });

  test('darkTheme_minContrast_primary', () {
    final scheme = SchemeFidelity(
        sourceColorHct: Hct.fromInt(0xFF0000ff),
        isDark: true,
        contrastLevel: -1.0);
    expect(MaterialDynamicColors.primary.getArgb(scheme), isColor(0xff7c84ff));
  });

  test('darkTheme_standardContrast_primary', () {
    final scheme = SchemeFidelity(
        sourceColorHct: Hct.fromInt(0xFF0000ff),
        isDark: true,
        contrastLevel: 0.0);
    expect(MaterialDynamicColors.primary.getArgb(scheme), isColor(0xFFBEC2FF));
  });

  test('darkTheme_maxContrast_primary', () {
    final scheme = SchemeFidelity(
        sourceColorHct: Hct.fromInt(0xFF0000ff),
        isDark: true,
        contrastLevel: 1.0);
    expect(MaterialDynamicColors.primary.getArgb(scheme), isColor(0xfffdf9ff));
  });

  test('darkTheme_minContrast_primaryContainer', () {
    final scheme = SchemeFidelity(
        sourceColorHct: Hct.fromInt(0xFF0000ff),
        isDark: true,
        contrastLevel: -1.0);
    expect(MaterialDynamicColors.primaryContainer.getArgb(scheme),
        isColor(0xff0001c9));
  });

  test('darkTheme_standardContrast_primaryContainer', () {
    final scheme = SchemeFidelity(
        sourceColorHct: Hct.fromInt(0xFF0000ff),
        isDark: true,
        contrastLevel: 0.0);
    expect(MaterialDynamicColors.primaryContainer.getArgb(scheme),
        isColor(0xFF0000E6));
  });

  test('darkTheme_maxContrast_primaryContainer', () {
    final scheme = SchemeFidelity(
        sourceColorHct: Hct.fromInt(0xFF0000ff),
        isDark: true,
        contrastLevel: 1.0);
    expect(MaterialDynamicColors.primaryContainer.getArgb(scheme),
        isColor(0xFFC4C6FF));
  });

  test('darkTheme_minContrast_onPrimaryContainer', () {
    final scheme = SchemeFidelity(
        sourceColorHct: Hct.fromInt(0xFF0000ff),
        isDark: true,
        contrastLevel: -1.0);
    expect(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme),
        isColor(0xff949bff));
  });

  test('darkTheme_standardContrast_onPrimaryContainer', () {
    final scheme = SchemeFidelity(
        sourceColorHct: Hct.fromInt(0xFF0000ff),
        isDark: true,
        contrastLevel: 0.0);
    expect(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme),
        isColor(0xffd7d8ff));
  });

  test('darkTheme_maxContrast_onPrimaryContainer', () {
    final scheme = SchemeFidelity(
        sourceColorHct: Hct.fromInt(0xFF0000ff),
        isDark: true,
        contrastLevel: 1.0);
    expect(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme),
        isColor(0xff000000));
  });

  test('darkTheme_minContrast_onTertiaryContainer', () {
    final scheme = SchemeFidelity(
        sourceColorHct: Hct.fromInt(0xFF0000ff),
        isDark: true,
        contrastLevel: -1.0);
    expect(MaterialDynamicColors.onTertiaryContainer.getArgb(scheme),
        isColor(0xffff7d6b));
  });

  test('darkTheme_standardContrast_onTertiaryContainer', () {
    final scheme = SchemeFidelity(
        sourceColorHct: Hct.fromInt(0xFF0000ff),
        isDark: true,
        contrastLevel: 0.0);
    expect(MaterialDynamicColors.onTertiaryContainer.getArgb(scheme),
        isColor(0xffffcfc7));
  });

  test('darkTheme_maxContrast_onTertiaryContainer', () {
    final scheme = SchemeFidelity(
        sourceColorHct: Hct.fromInt(0xFF0000ff),
        isDark: true,
        contrastLevel: 1.0);
    expect(MaterialDynamicColors.onTertiaryContainer.getArgb(scheme),
        isColor(0xff000000));
  });

  test('darkTheme_minContrast_surface', () {
    final scheme = SchemeFidelity(
        sourceColorHct: Hct.fromInt(0xFF0000ff),
        isDark: true,
        contrastLevel: -1.0);
    expect(MaterialDynamicColors.surface.getArgb(scheme), isColor(0xFF12121D));
  });

  test('darkTheme_standardContrast_surface', () {
    final scheme = SchemeFidelity(
        sourceColorHct: Hct.fromInt(0xFF0000ff),
        isDark: true,
        contrastLevel: 0.0);
    expect(MaterialDynamicColors.surface.getArgb(scheme), isColor(0xFF12121D));
  });

  test('darkTheme_maxContrast_surface', () {
    final scheme = SchemeFidelity(
        sourceColorHct: Hct.fromInt(0xFF0000ff),
        isDark: true,
        contrastLevel: 1.0);
    expect(MaterialDynamicColors.surface.getArgb(scheme), isColor(0xFF12121D));
  });
}
