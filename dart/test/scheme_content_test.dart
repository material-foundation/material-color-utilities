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
import 'package:material_color_utilities/scheme/scheme_content.dart';
import 'package:test/test.dart';
import './utils/color_matcher.dart';

void main() {
  test('keyColors', () {
    final scheme = SchemeContent(
        sourceColorHct: Hct.fromInt(0xFF0000ff),
        isDark: false,
        contrastLevel: 0.0);
    expect(MaterialDynamicColors.primaryPaletteKeyColor.getArgb(scheme),
        isColor(0xff080CFF));
    expect(MaterialDynamicColors.secondaryPaletteKeyColor.getArgb(scheme),
        isColor(0xff656DD3));
    expect(MaterialDynamicColors.tertiaryPaletteKeyColor.getArgb(scheme),
        isColor(0xff81009F));
    expect(MaterialDynamicColors.neutralPaletteKeyColor.getArgb(scheme),
        isColor(0xff767684));
    expect(MaterialDynamicColors.neutralVariantPaletteKeyColor.getArgb(scheme),
        isColor(0xff757589));
  });

  test('lightTheme_minContrast_primary', () {
    final scheme = SchemeContent(
        sourceColorHct: Hct.fromInt(0xFF0000ff),
        isDark: false,
        contrastLevel: -1.0);
    expect(MaterialDynamicColors.primary.getArgb(scheme), isColor(0xFF1218FF));
  });

  test('lightTheme_standardContrast_primary', () {
    final scheme = SchemeContent(
        sourceColorHct: Hct.fromInt(0xFF0000ff),
        isDark: false,
        contrastLevel: 0);
    expect(MaterialDynamicColors.primary.getArgb(scheme), isColor(0xFF0001C3));
  });

  test('lightTheme_maxContrast_primary', () {
    final scheme = SchemeContent(
        sourceColorHct: Hct.fromInt(0xFF0000ff),
        isDark: false,
        contrastLevel: 1);
    expect(MaterialDynamicColors.primary.getArgb(scheme), isColor(0xFF000181));
  });

  test('lightTheme_minContrast_primaryContainer', () {
    final scheme = SchemeContent(
        sourceColorHct: Hct.fromInt(0xFF0000ff),
        isDark: false,
        contrastLevel: -1);
    expect(MaterialDynamicColors.primaryContainer.getArgb(scheme),
        isColor(0xFF5660FF));
  });

  test('lightTheme_standardContrast_primaryContainer', () {
    final scheme = SchemeContent(
        sourceColorHct: Hct.fromInt(0xFF0000ff),
        isDark: false,
        contrastLevel: 0);
    expect(MaterialDynamicColors.primaryContainer.getArgb(scheme),
        isColor(0xFF2D36FF));
  });

  test('lightTheme_maxContrast_primaryContainer', () {
    final scheme = SchemeContent(
        sourceColorHct: Hct.fromInt(0xFF0000ff),
        isDark: false,
        contrastLevel: 1);
    expect(MaterialDynamicColors.primaryContainer.getArgb(scheme),
        isColor(0xFF0000E3));
  });

  test('lightTheme_minContrast_tertiaryContainer', () {
    final scheme = SchemeContent(
        sourceColorHct: Hct.fromInt(0xFF0000ff),
        isDark: false,
        contrastLevel: -1);
    expect(MaterialDynamicColors.tertiaryContainer.getArgb(scheme),
        isColor(0xFFB042CC));
  });

  test('lightTheme_standardContrast_tertiaryContainer', () {
    final scheme = SchemeContent(
        sourceColorHct: Hct.fromInt(0xFF0000ff),
        isDark: false,
        contrastLevel: 0);
    expect(MaterialDynamicColors.tertiaryContainer.getArgb(scheme),
        isColor(0xFF9221AF));
  });

  test('lightTheme_maxContrast_tertiaryContainer', () {
    final scheme = SchemeContent(
        sourceColorHct: Hct.fromInt(0xFF0000ff),
        isDark: false,
        contrastLevel: 1);
    expect(MaterialDynamicColors.tertiaryContainer.getArgb(scheme),
        isColor(0xFF73008E));
  });

  test('lightTheme_minContrast_objectionableTertiaryContainerLightens', () {
    final scheme = SchemeContent(
        sourceColorHct: Hct.fromInt(0xFF850096),
        isDark: false,
        contrastLevel: -1);
    expect(MaterialDynamicColors.tertiaryContainer.getArgb(scheme),
        isColor(0xFFD03A71));
  });

  test('lightTheme_standardContrast_objectionableTertiaryContainerLightens',
      () {
    final scheme = SchemeContent(
        sourceColorHct: Hct.fromInt(0xFF850096),
        isDark: false,
        contrastLevel: 0);
    expect(MaterialDynamicColors.tertiaryContainer.getArgb(scheme),
        isColor(0xFFAC1B57));
  });

  test('lightTheme_maxContrast_objectionableTertiaryContainerDarkens', () {
    final scheme = SchemeContent(
        sourceColorHct: Hct.fromInt(0xFF850096),
        isDark: false,
        contrastLevel: 1);
    expect(MaterialDynamicColors.tertiaryContainer.getArgb(scheme),
        isColor(0xFF870040));
  });

  test('lightTheme_minContrast_onPrimaryContainer', () {
    final scheme = SchemeContent(
        sourceColorHct: Hct.fromInt(0xFF0000ff),
        isDark: false,
        contrastLevel: -1);
    expect(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme),
        isColor(0xFFCBCDFF));
  });

  test('lightTheme_standardContrast_onPrimaryContainer', () {
    final scheme = SchemeContent(
        sourceColorHct: Hct.fromInt(0xFF0000ff),
        isDark: false,
        contrastLevel: 0);
    expect(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme),
        isColor(0xFFCECFFF));
  });

  test('lightTheme_maxContrast_onPrimaryContainer', () {
    final scheme = SchemeContent(
        sourceColorHct: Hct.fromInt(0xFF0000ff),
        isDark: false,
        contrastLevel: 1);
    expect(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme),
        isColor(0xFFD6D6FF));
  });

  test('lightTheme_minContrast_surface', () {
    final scheme = SchemeContent(
        sourceColorHct: Hct.fromInt(0xFF0000ff),
        isDark: false,
        contrastLevel: -1);
    expect(MaterialDynamicColors.surface.getArgb(scheme), isColor(0xFFFBF8FF));
  });

  test('lightTheme_standardContrast_surface', () {
    final scheme = SchemeContent(
        sourceColorHct: Hct.fromInt(0xFF0000ff),
        isDark: false,
        contrastLevel: 0.0);
    expect(MaterialDynamicColors.surface.getArgb(scheme), isColor(0xFFFBF8FF));
  });

  test('lightTheme_maxContrast_surface', () {
    final scheme = SchemeContent(
        sourceColorHct: Hct.fromInt(0xFF0000ff),
        isDark: false,
        contrastLevel: 1.0);
    expect(MaterialDynamicColors.surface.getArgb(scheme), isColor(0xFFFBF8FF));
  });

  test('darkTheme_minContrast_primary', () {
    final scheme = SchemeContent(
        sourceColorHct: Hct.fromInt(0xFF0000ff),
        isDark: true,
        contrastLevel: -1.0);
    expect(MaterialDynamicColors.primary.getArgb(scheme), isColor(0xFF5660FF));
  });

  test('darkTheme_standardContrast_primary', () {
    final scheme = SchemeContent(
        sourceColorHct: Hct.fromInt(0xFF0000ff),
        isDark: true,
        contrastLevel: 0.0);
    expect(MaterialDynamicColors.primary.getArgb(scheme), isColor(0xFFBEC2FF));
  });

  test('darkTheme_maxContrast_primary', () {
    final scheme = SchemeContent(
        sourceColorHct: Hct.fromInt(0xFF0000ff),
        isDark: true,
        contrastLevel: 1.0);
    expect(MaterialDynamicColors.primary.getArgb(scheme), isColor(0xFFF6F4FF));
  });

  test('darkTheme_minContrast_primaryContainer', () {
    final scheme = SchemeContent(
        sourceColorHct: Hct.fromInt(0xFF0000ff),
        isDark: true,
        contrastLevel: -1.0);
    expect(MaterialDynamicColors.primaryContainer.getArgb(scheme),
        isColor(0xFF0000E6));
  });

  test('darkTheme_standardContrast_primaryContainer', () {
    final scheme = SchemeContent(
        sourceColorHct: Hct.fromInt(0xFF0000ff),
        isDark: true,
        contrastLevel: 0.0);
    expect(MaterialDynamicColors.primaryContainer.getArgb(scheme),
        isColor(0xFF0000E6));
  });

  test('darkTheme_maxContrast_primaryContainer', () {
    final scheme = SchemeContent(
        sourceColorHct: Hct.fromInt(0xFF0000ff),
        isDark: true,
        contrastLevel: 1.0);
    expect(MaterialDynamicColors.primaryContainer.getArgb(scheme),
        isColor(0xFFC4C6FF));
  });

  test('darkTheme_minContrast_onPrimaryContainer', () {
    final scheme = SchemeContent(
        sourceColorHct: Hct.fromInt(0xFF0000ff),
        isDark: true,
        contrastLevel: -1.0);
    expect(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme),
        isColor(0xFF7A83FF));
  });

  test('darkTheme_standardContrast_onPrimaryContainer', () {
    final scheme = SchemeContent(
        sourceColorHct: Hct.fromInt(0xFF0000ff),
        isDark: true,
        contrastLevel: 0.0);
    expect(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme),
        isColor(0xFFA4AAFF));
  });

  test('darkTheme_maxContrast_onPrimaryContainer', () {
    final scheme = SchemeContent(
        sourceColorHct: Hct.fromInt(0xFF0000ff),
        isDark: true,
        contrastLevel: 1.0);
    expect(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme),
        isColor(0xFF0001C6));
  });

  test('darkTheme_minContrast_onTertiaryContainer', () {
    final scheme = SchemeContent(
        sourceColorHct: Hct.fromInt(0xFF0000ff),
        isDark: true,
        contrastLevel: -1.0);
    expect(MaterialDynamicColors.onTertiaryContainer.getArgb(scheme),
        isColor(0xFFCF60EA));
  });

  test('darkTheme_standardContrast_onTertiaryContainer', () {
    final scheme = SchemeContent(
        sourceColorHct: Hct.fromInt(0xFF0000ff),
        isDark: true,
        contrastLevel: 0.0);
    expect(MaterialDynamicColors.onTertiaryContainer.getArgb(scheme),
        isColor(0xFFEB8CFF));
  });

  test('darkTheme_maxContrast_onTertiaryContainer', () {
    final scheme = SchemeContent(
        sourceColorHct: Hct.fromInt(0xFF0000ff),
        isDark: true,
        contrastLevel: 1.0);
    expect(MaterialDynamicColors.onTertiaryContainer.getArgb(scheme),
        isColor(0xFF63007B));
  });

  test('darkTheme_minContrast_surface', () {
    final scheme = SchemeContent(
        sourceColorHct: Hct.fromInt(0xFF0000ff),
        isDark: true,
        contrastLevel: -1.0);
    expect(MaterialDynamicColors.surface.getArgb(scheme), isColor(0xFF12121D));
  });

  test('darkTheme_standardContrast_surface', () {
    final scheme = SchemeContent(
        sourceColorHct: Hct.fromInt(0xFF0000ff),
        isDark: true,
        contrastLevel: 0.0);
    expect(MaterialDynamicColors.surface.getArgb(scheme), isColor(0xFF12121D));
  });

  test('darkTheme_maxContrast_surface', () {
    final scheme = SchemeContent(
        sourceColorHct: Hct.fromInt(0xFF0000ff),
        isDark: true,
        contrastLevel: 1.0);
    expect(MaterialDynamicColors.surface.getArgb(scheme), isColor(0xFF12121D));
  });
}
