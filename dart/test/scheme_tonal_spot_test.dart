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
import 'package:material_color_utilities/scheme/scheme_tonal_spot.dart';
import 'package:test/test.dart';
import './utils/color_matcher.dart';

void main() {
  test('keyColors', () {
    final scheme = SchemeTonalSpot(
        sourceColorHct: Hct.fromInt(0xff0000ff),
        isDark: false,
        contrastLevel: 0.0);

    expect(MaterialDynamicColors.primaryPaletteKeyColor.getArgb(scheme),
        isColor(0xff6E72AC));
    expect(MaterialDynamicColors.secondaryPaletteKeyColor.getArgb(scheme),
        isColor(0xff75758B));
    expect(MaterialDynamicColors.tertiaryPaletteKeyColor.getArgb(scheme),
        isColor(0xff936B84));
    expect(MaterialDynamicColors.neutralPaletteKeyColor.getArgb(scheme),
        isColor(0xff77767d));
    expect(MaterialDynamicColors.neutralVariantPaletteKeyColor.getArgb(scheme),
        isColor(0xff777680));
  });

  test('lightTheme_minContrast_primary', () {
    final scheme = SchemeTonalSpot(
        sourceColorHct: Hct.fromInt(0xff0000ff),
        isDark: false,
        contrastLevel: -1.0);
    expect(MaterialDynamicColors.primary.getArgb(scheme), isColor(0xff6c70aa));
  });

  test('lightTheme_standardContrast_primary', () {
    final scheme = SchemeTonalSpot(
        sourceColorHct: Hct.fromInt(0xff0000ff),
        isDark: false,
        contrastLevel: 0.0);
    expect(MaterialDynamicColors.primary.getArgb(scheme), isColor(0xff555992));
  });

  test('lightTheme_maxContrast_primary', () {
    final scheme = SchemeTonalSpot(
        sourceColorHct: Hct.fromInt(0xff0000ff),
        isDark: false,
        contrastLevel: 1.0);
    expect(MaterialDynamicColors.primary.getArgb(scheme), isColor(0xff181c51));
  });

  test('lightTheme_minContrast_primaryContainer', () {
    final scheme = SchemeTonalSpot(
        sourceColorHct: Hct.fromInt(0xff0000ff),
        isDark: false,
        contrastLevel: -1.0);
    expect(MaterialDynamicColors.primaryContainer.getArgb(scheme),
        isColor(0xffe0e0ff));
  });

  test('lightTheme_standardContrast_primaryContainer', () {
    final scheme = SchemeTonalSpot(
        sourceColorHct: Hct.fromInt(0xff0000ff),
        isDark: false,
        contrastLevel: 0.0);
    expect(MaterialDynamicColors.primaryContainer.getArgb(scheme),
        isColor(0xffe0e0ff));
  });

  test('lightTheme_maxContrast_primaryContainer', () {
    final scheme = SchemeTonalSpot(
        sourceColorHct: Hct.fromInt(0xff0000ff),
        isDark: false,
        contrastLevel: 1.0);
    expect(MaterialDynamicColors.primaryContainer.getArgb(scheme),
        isColor(0xff3a3e74));
  });

  test('lightTheme_minContrast_onPrimaryContainer', () {
    final scheme = SchemeTonalSpot(
        sourceColorHct: Hct.fromInt(0xff0000ff),
        isDark: false,
        contrastLevel: -1.0);
    expect(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme),
        isColor(0xff5C5F98));
  });

  test('lightTheme_standardContrast_onPrimaryContainer', () {
    final scheme = SchemeTonalSpot(
        sourceColorHct: Hct.fromInt(0xff0000ff),
        isDark: false,
        contrastLevel: 0.0);
    expect(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme),
        isColor(0xff11144B));
  });

  test('lightTheme_maxContrast_onPrimaryContainer', () {
    final scheme = SchemeTonalSpot(
        sourceColorHct: Hct.fromInt(0xff0000ff),
        isDark: false,
        contrastLevel: 1.0);
    expect(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme),
        isColor(0xffd6d6ff));
  });

  test('lightTheme_minContrast_surface', () {
    final scheme = SchemeTonalSpot(
        sourceColorHct: Hct.fromInt(0xff0000ff),
        isDark: false,
        contrastLevel: -1.0);
    expect(MaterialDynamicColors.surface.getArgb(scheme), isColor(0xfffbf8ff));
  });

  test('lightTheme_standardContrast_surface', () {
    final scheme = SchemeTonalSpot(
        sourceColorHct: Hct.fromInt(0xff0000ff),
        isDark: false,
        contrastLevel: 0.0);
    expect(MaterialDynamicColors.surface.getArgb(scheme), isColor(0xfffbf8ff));
  });

  test('lightTheme_maxContrast_surface', () {
    final scheme = SchemeTonalSpot(
        sourceColorHct: Hct.fromInt(0xff0000ff),
        isDark: false,
        contrastLevel: 1.0);
    expect(MaterialDynamicColors.surface.getArgb(scheme), isColor(0xfffbf8ff));
  });

  test('lightTheme_minContrast_onSurface', () {
    final scheme = SchemeTonalSpot(
        sourceColorHct: Hct.fromInt(0xff0000ff),
        isDark: false,
        contrastLevel: -1.0);
    expect(
        MaterialDynamicColors.onSurface.getArgb(scheme), isColor(0xff5f5e65));
  });

  test('lightTheme_standardContrast_onSurface', () {
    final scheme = SchemeTonalSpot(
        sourceColorHct: Hct.fromInt(0xff0000ff),
        isDark: false,
        contrastLevel: 0.0);
    expect(
        MaterialDynamicColors.onSurface.getArgb(scheme), isColor(0xff1b1b21));
  });

  test('lightTheme_maxContrast_onSurface', () {
    final scheme = SchemeTonalSpot(
        sourceColorHct: Hct.fromInt(0xff0000ff),
        isDark: false,
        contrastLevel: 1.0);
    expect(
        MaterialDynamicColors.onSurface.getArgb(scheme), isColor(0xff1a1a20));
  });

  test('lightTheme_minContrast_onSecondary', () {
    final scheme = SchemeTonalSpot(
        sourceColorHct: Hct.fromInt(0xff0000ff),
        isDark: false,
        contrastLevel: -1.0);
    expect(
        MaterialDynamicColors.onSecondary.getArgb(scheme), isColor(0xffcfcfe7));
  });

  test('lightTheme_standardContrast_onSecondary', () {
    final scheme = SchemeTonalSpot(
        sourceColorHct: Hct.fromInt(0xff0000ff),
        isDark: false,
        contrastLevel: 0.0);
    expect(
        MaterialDynamicColors.onSecondary.getArgb(scheme), isColor(0xffffffff));
  });

  test('lightTheme_maxContrast_onSecondary', () {
    final scheme = SchemeTonalSpot(
        sourceColorHct: Hct.fromInt(0xff0000ff),
        isDark: false,
        contrastLevel: 1.0);
    expect(
        MaterialDynamicColors.onSecondary.getArgb(scheme), isColor(0xffababc3));
  });

  test('lightTheme_minContrast_onTertiary', () {
    final scheme = SchemeTonalSpot(
        sourceColorHct: Hct.fromInt(0xff0000ff),
        isDark: false,
        contrastLevel: -1.0);
    expect(
        MaterialDynamicColors.onTertiary.getArgb(scheme), isColor(0xfff3c3df));
  });

  test('lightTheme_standardContrast_onTertiary', () {
    final scheme = SchemeTonalSpot(
        sourceColorHct: Hct.fromInt(0xff0000ff),
        isDark: false,
        contrastLevel: 0.0);
    expect(
        MaterialDynamicColors.onTertiary.getArgb(scheme), isColor(0xffffffff));
  });

  test('lightTheme_maxContrast_onTertiary', () {
    final scheme = SchemeTonalSpot(
        sourceColorHct: Hct.fromInt(0xff0000ff),
        isDark: false,
        contrastLevel: 1.0);
    expect(
        MaterialDynamicColors.onTertiary.getArgb(scheme), isColor(0xffcda0bb));
  });

  test('lightTheme_minContrast_onError', () {
    final scheme = SchemeTonalSpot(
        sourceColorHct: Hct.fromInt(0xff0000ff),
        isDark: false,
        contrastLevel: -1.0);
    expect(MaterialDynamicColors.onError.getArgb(scheme), isColor(0xffffc2bb));
  });

  test('lightTheme_standardContrast_onError', () {
    final scheme = SchemeTonalSpot(
        sourceColorHct: Hct.fromInt(0xff0000ff),
        isDark: false,
        contrastLevel: 0.0);
    expect(MaterialDynamicColors.onError.getArgb(scheme), isColor(0xffffffff));
  });

  test('lightTheme_maxContrast_onError', () {
    final scheme = SchemeTonalSpot(
        sourceColorHct: Hct.fromInt(0xff0000ff),
        isDark: false,
        contrastLevel: 1.0);
    expect(MaterialDynamicColors.onError.getArgb(scheme), isColor(0xffff8d80));
  });

  test('darkTheme_minContrast_primary', () {
    final scheme = SchemeTonalSpot(
        sourceColorHct: Hct.fromInt(0xff0000ff),
        isDark: true,
        contrastLevel: -1.0);
    expect(MaterialDynamicColors.primary.getArgb(scheme), isColor(0xff6C70AA));
  });

  test('darkTheme_standardContrast_primary', () {
    final scheme = SchemeTonalSpot(
        sourceColorHct: Hct.fromInt(0xff0000ff),
        isDark: true,
        contrastLevel: 0.0);
    expect(MaterialDynamicColors.primary.getArgb(scheme), isColor(0xffbec2ff));
  });

  test('darkTheme_maxContrast_primary', () {
    final scheme = SchemeTonalSpot(
        sourceColorHct: Hct.fromInt(0xff0000ff),
        isDark: true,
        contrastLevel: 1.0);
    expect(MaterialDynamicColors.primary.getArgb(scheme), isColor(0xfff6f4ff));
  });

  test('darkTheme_minContrast_primaryContainer', () {
    final scheme = SchemeTonalSpot(
        sourceColorHct: Hct.fromInt(0xff0000ff),
        isDark: true,
        contrastLevel: -1.0);
    expect(MaterialDynamicColors.primaryContainer.getArgb(scheme),
        isColor(0xff3E4278));
  });

  test('darkTheme_standardContrast_primaryContainer', () {
    final scheme = SchemeTonalSpot(
        sourceColorHct: Hct.fromInt(0xff0000ff),
        isDark: true,
        contrastLevel: 0.0);
    expect(MaterialDynamicColors.primaryContainer.getArgb(scheme),
        isColor(0xff3E4278));
  });

  test('darkTheme_maxContrast_primaryContainer', () {
    final scheme = SchemeTonalSpot(
        sourceColorHct: Hct.fromInt(0xff0000ff),
        isDark: true,
        contrastLevel: 1.0);
    expect(MaterialDynamicColors.primaryContainer.getArgb(scheme),
        isColor(0xffc4c6ff));
  });

  test('darkTheme_minContrast_onPrimaryContainer', () {
    final scheme = SchemeTonalSpot(
        sourceColorHct: Hct.fromInt(0xff0000ff),
        isDark: true,
        contrastLevel: -1.0);
    expect(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme),
        isColor(0xffadb0ef));
  });

  test('darkTheme_standardContrast_onPrimaryContainer', () {
    final scheme = SchemeTonalSpot(
        sourceColorHct: Hct.fromInt(0xff0000ff),
        isDark: true,
        contrastLevel: 0.0);
    expect(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme),
        isColor(0xffe0e0ff));
  });

  test('darkTheme_maxContrast_onPrimaryContainer', () {
    final scheme = SchemeTonalSpot(
        sourceColorHct: Hct.fromInt(0xff0000ff),
        isDark: true,
        contrastLevel: 1.0);
    expect(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme),
        isColor(0xff30346A));
  });

  test('darkTheme_minContrast_onTertiaryContainer', () {
    final scheme = SchemeTonalSpot(
        sourceColorHct: Hct.fromInt(0xff0000ff),
        isDark: true,
        contrastLevel: -1.0);
    expect(MaterialDynamicColors.onTertiaryContainer.getArgb(scheme),
        isColor(0xffd5a8c3));
  });

  test('darkTheme_standardContrast_onTertiaryContainer', () {
    final scheme = SchemeTonalSpot(
        sourceColorHct: Hct.fromInt(0xff0000ff),
        isDark: true,
        contrastLevel: 0.0);
    expect(MaterialDynamicColors.onTertiaryContainer.getArgb(scheme),
        isColor(0xffffd8ee));
  });

  test('darkTheme_maxContrast_onTertiaryContainer', () {
    final scheme = SchemeTonalSpot(
        sourceColorHct: Hct.fromInt(0xff0000ff),
        isDark: true,
        contrastLevel: 1.0);
    expect(MaterialDynamicColors.onTertiaryContainer.getArgb(scheme),
        isColor(0xff4f2e44));
  });

  test('darkTheme_minContrast_onSecondary', () {
    final scheme = SchemeTonalSpot(
        sourceColorHct: Hct.fromInt(0xff0000ff),
        isDark: true,
        contrastLevel: -1.0);
    expect(
        MaterialDynamicColors.onSecondary.getArgb(scheme), isColor(0xfffffbff));
  });

  test('darkTheme_standardContrast_onSecondary', () {
    final scheme = SchemeTonalSpot(
        sourceColorHct: Hct.fromInt(0xff0000ff),
        isDark: true,
        contrastLevel: 0.0);
    expect(
        MaterialDynamicColors.onSecondary.getArgb(scheme), isColor(0xff2e2f42));
  });

  test('darkTheme_maxContrast_onSecondary', () {
    final scheme = SchemeTonalSpot(
        sourceColorHct: Hct.fromInt(0xff0000ff),
        isDark: true,
        contrastLevel: 1.0);
    expect(
        MaterialDynamicColors.onSecondary.getArgb(scheme), isColor(0xff505165));
  });

  test('darkTheme_minContrast_onTertiary', () {
    final scheme = SchemeTonalSpot(
        sourceColorHct: Hct.fromInt(0xff0000ff),
        isDark: true,
        contrastLevel: -1.0);
    expect(
        MaterialDynamicColors.onTertiary.getArgb(scheme), isColor(0xfffffbff));
  });

  test('darkTheme_standardContrast_onTertiary', () {
    final scheme = SchemeTonalSpot(
        sourceColorHct: Hct.fromInt(0xff0000ff),
        isDark: true,
        contrastLevel: 0.0);
    expect(
        MaterialDynamicColors.onTertiary.getArgb(scheme), isColor(0xff46263b));
  });

  test('darkTheme_maxContrast_onTertiary', () {
    final scheme = SchemeTonalSpot(
        sourceColorHct: Hct.fromInt(0xff0000ff),
        isDark: true,
        contrastLevel: 1.0);
    expect(
        MaterialDynamicColors.onTertiary.getArgb(scheme), isColor(0xff6b485f));
  });

  test('darkTheme_minContrast_onError', () {
    final scheme = SchemeTonalSpot(
        sourceColorHct: Hct.fromInt(0xff0000ff),
        isDark: true,
        contrastLevel: -1.0);
    expect(MaterialDynamicColors.onError.getArgb(scheme), isColor(0xfffffbff));
  });

  test('darkTheme_standardContrast_onError', () {
    final scheme = SchemeTonalSpot(
        sourceColorHct: Hct.fromInt(0xff0000ff),
        isDark: true,
        contrastLevel: 0.0);
    expect(MaterialDynamicColors.onError.getArgb(scheme), isColor(0xff690005));
  });

  test('darkTheme_maxContrast_onError', () {
    final scheme = SchemeTonalSpot(
        sourceColorHct: Hct.fromInt(0xff0000ff),
        isDark: true,
        contrastLevel: 1.0);
    expect(MaterialDynamicColors.onError.getArgb(scheme), isColor(0xffa80710));
  });

  test('darkTheme_minContrast_surface', () {
    final scheme = SchemeTonalSpot(
        sourceColorHct: Hct.fromInt(0xff0000ff),
        isDark: true,
        contrastLevel: -1.0);
    expect(MaterialDynamicColors.surface.getArgb(scheme), isColor(0xff131318));
  });

  test('darkTheme_standardContrast_surface', () {
    final scheme = SchemeTonalSpot(
        sourceColorHct: Hct.fromInt(0xff0000ff),
        isDark: true,
        contrastLevel: 0.0);
    expect(MaterialDynamicColors.surface.getArgb(scheme), isColor(0xff131318));
  });

  test('darkTheme_maxContrast_surface', () {
    final scheme = SchemeTonalSpot(
        sourceColorHct: Hct.fromInt(0xff0000ff),
        isDark: true,
        contrastLevel: 1.0);
    expect(MaterialDynamicColors.surface.getArgb(scheme), isColor(0xff131318));
  });

  test('darkTheme_minContrast_onSurface', () {
    final scheme = SchemeTonalSpot(
        sourceColorHct: Hct.fromInt(0xff0000ff),
        isDark: true,
        contrastLevel: -1.0);
    expect(
        MaterialDynamicColors.onSurface.getArgb(scheme), isColor(0xffa4a2a9));
  });

  test('darkTheme_standardContrast_onSurface', () {
    final scheme = SchemeTonalSpot(
        sourceColorHct: Hct.fromInt(0xff0000ff),
        isDark: true,
        contrastLevel: 0.0);
    expect(
        MaterialDynamicColors.onSurface.getArgb(scheme), isColor(0xffe4e1e9));
  });

  test('darkTheme_maxContrast_onSurface', () {
    final scheme = SchemeTonalSpot(
        sourceColorHct: Hct.fromInt(0xff0000ff),
        isDark: true,
        contrastLevel: 1.0);
    expect(
        MaterialDynamicColors.onSurface.getArgb(scheme), isColor(0xffe5e2ea));
  });
}
