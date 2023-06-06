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
import 'package:material_color_utilities/scheme/scheme_expressive.dart';
import 'package:test/test.dart';
import './utils/color_matcher.dart';

void main() {
  test('keyColors', () {
    final scheme = SchemeExpressive(
        sourceColorHct: Hct.fromInt(0xff0000ff),
        isDark: false,
        contrastLevel: 0.0);

    expect(MaterialDynamicColors.primaryPaletteKeyColor.getArgb(scheme),
        isColor(0xff35855F));
    expect(MaterialDynamicColors.secondaryPaletteKeyColor.getArgb(scheme),
        isColor(0xff8C6D8C));
    expect(MaterialDynamicColors.tertiaryPaletteKeyColor.getArgb(scheme),
        isColor(0xff806EA1));
    expect(MaterialDynamicColors.neutralPaletteKeyColor.getArgb(scheme),
        isColor(0xff79757F));
    expect(MaterialDynamicColors.neutralVariantPaletteKeyColor.getArgb(scheme),
        isColor(0xff7A7585));
  });

  test('lightTheme_minContrast_primary', () {
    final scheme = SchemeExpressive(
        sourceColorHct: Hct.fromInt(0xff0000ff),
        isDark: false,
        contrastLevel: -1.0);
    expect(MaterialDynamicColors.primary.getArgb(scheme), isColor(0xff32835D));
  });

  test('lightTheme_standardContrast_primary', () {
    final scheme = SchemeExpressive(
        sourceColorHct: Hct.fromInt(0xff0000ff),
        isDark: false,
        contrastLevel: 0.0);
    expect(MaterialDynamicColors.primary.getArgb(scheme), isColor(0xff146C48));
  });

  test('lightTheme_maxContrast_primary', () {
    final scheme = SchemeExpressive(
        sourceColorHct: Hct.fromInt(0xff0000ff),
        isDark: false,
        contrastLevel: 1.0);
    expect(MaterialDynamicColors.primary.getArgb(scheme), isColor(0xff002818));
  });

  test('lightTheme_minContrast_primaryContainer', () {
    final scheme = SchemeExpressive(
        sourceColorHct: Hct.fromInt(0xff0000ff),
        isDark: false,
        contrastLevel: -1.0);
    expect(MaterialDynamicColors.primaryContainer.getArgb(scheme),
        isColor(0xffA2F4C6));
  });

  test('lightTheme_standardContrast_primaryContainer', () {
    final scheme = SchemeExpressive(
        sourceColorHct: Hct.fromInt(0xff0000ff),
        isDark: false,
        contrastLevel: 0.0);
    expect(MaterialDynamicColors.primaryContainer.getArgb(scheme),
        isColor(0xffA2F4C6));
  });

  test('lightTheme_maxContrast_primaryContainer', () {
    final scheme = SchemeExpressive(
        sourceColorHct: Hct.fromInt(0xff0000ff),
        isDark: false,
        contrastLevel: 1.0);
    expect(MaterialDynamicColors.primaryContainer.getArgb(scheme),
        isColor(0xff004D31));
  });

  test('lightTheme_minContrast_onPrimaryContainer', () {
    final scheme = SchemeExpressive(
        sourceColorHct: Hct.fromInt(0xff0000ff),
        isDark: false,
        contrastLevel: -1.0);
    expect(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme),
        isColor(0xff1e724e));
  });

  test('lightTheme_standardContrast_onPrimaryContainer', () {
    final scheme = SchemeExpressive(
        sourceColorHct: Hct.fromInt(0xff0000ff),
        isDark: false,
        contrastLevel: 0.0);
    expect(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme),
        isColor(0xff002112));
  });

  test('lightTheme_maxContrast_onPrimaryContainer', () {
    final scheme = SchemeExpressive(
        sourceColorHct: Hct.fromInt(0xff0000ff),
        isDark: false,
        contrastLevel: 1.0);
    expect(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme),
        isColor(0xff9aebbe));
  });

  test('lightTheme_minContrast_surface', () {
    final scheme = SchemeExpressive(
        sourceColorHct: Hct.fromInt(0xff0000ff),
        isDark: false,
        contrastLevel: -1.0);
    expect(MaterialDynamicColors.surface.getArgb(scheme), isColor(0xfffdf7ff));
  });

  test('lightTheme_standardContrast_surface', () {
    final scheme = SchemeExpressive(
        sourceColorHct: Hct.fromInt(0xff0000ff),
        isDark: false,
        contrastLevel: 0.0);
    expect(MaterialDynamicColors.surface.getArgb(scheme), isColor(0xfffdf7ff));
  });

  test('lightTheme_maxContrast_surface', () {
    final scheme = SchemeExpressive(
        sourceColorHct: Hct.fromInt(0xff0000ff),
        isDark: false,
        contrastLevel: 1.0);
    expect(MaterialDynamicColors.surface.getArgb(scheme), isColor(0xfffdf7ff));
  });

  test('darkTheme_minContrast_primary', () {
    final scheme = SchemeExpressive(
        sourceColorHct: Hct.fromInt(0xff0000ff),
        isDark: true,
        contrastLevel: -1.0);
    expect(MaterialDynamicColors.primary.getArgb(scheme), isColor(0xff32835d));
  });

  test('darkTheme_standardContrast_primary', () {
    final scheme = SchemeExpressive(
        sourceColorHct: Hct.fromInt(0xff0000ff),
        isDark: true,
        contrastLevel: 0.0);
    expect(MaterialDynamicColors.primary.getArgb(scheme), isColor(0xff87d7ab));
  });

  test('darkTheme_maxContrast_primary', () {
    final scheme = SchemeExpressive(
        sourceColorHct: Hct.fromInt(0xff0000ff),
        isDark: true,
        contrastLevel: 1.0);

    expect(MaterialDynamicColors.primary.getArgb(scheme), isColor(0xffd5ffe4));
  });

  test('darkTheme_minContrast_primaryContainer', () {
    final scheme = SchemeExpressive(
        sourceColorHct: Hct.fromInt(0xff0000ff),
        isDark: true,
        contrastLevel: -1.0);
    expect(MaterialDynamicColors.primaryContainer.getArgb(scheme),
        isColor(0xff005234));
  });

  test('darkTheme_standardContrast_primaryContainer', () {
    final scheme = SchemeExpressive(
        sourceColorHct: Hct.fromInt(0xff0000ff),
        isDark: true,
        contrastLevel: 0.0);
    expect(MaterialDynamicColors.primaryContainer.getArgb(scheme),
        isColor(0xff005234));
  });

  test('darkTheme_maxContrast_primaryContainer', () {
    final scheme = SchemeExpressive(
        sourceColorHct: Hct.fromInt(0xff0000ff),
        isDark: true,
        contrastLevel: 1.0);
    expect(MaterialDynamicColors.primaryContainer.getArgb(scheme),
        isColor(0xff8bdbaf));
  });

  test('darkTheme_minContrast_onPrimaryContainer', () {
    final scheme = SchemeExpressive(
        sourceColorHct: Hct.fromInt(0xff0000ff),
        isDark: true,
        contrastLevel: -1.0);
    expect(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme),
        isColor(0xff76c59b));
  });

  test('darkTheme_standardContrast_onPrimaryContainer', () {
    final scheme = SchemeExpressive(
        sourceColorHct: Hct.fromInt(0xff0000ff),
        isDark: true,
        contrastLevel: 0.0);
    expect(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme),
        isColor(0xffa2f4c6));
  });

  test('darkTheme_maxContrast_onPrimaryContainer', () {
    final scheme = SchemeExpressive(
        sourceColorHct: Hct.fromInt(0xff0000ff),
        isDark: true,
        contrastLevel: 1.0);
    expect(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme),
        isColor(0xff004229));
  });

  test('darkTheme_minContrast_surface', () {
    final scheme = SchemeExpressive(
        sourceColorHct: Hct.fromInt(0xff0000ff),
        isDark: true,
        contrastLevel: -1.0);
    expect(MaterialDynamicColors.surface.getArgb(scheme), isColor(0xff14121a));
  });

  test('darkTheme_standardContrast_surface', () {
    final scheme = SchemeExpressive(
        sourceColorHct: Hct.fromInt(0xff0000ff),
        isDark: true,
        contrastLevel: 0.0);
    expect(MaterialDynamicColors.surface.getArgb(scheme), isColor(0xff14121a));
  });

  test('darkTheme_maxContrast_surface', () {
    final scheme = SchemeExpressive(
        sourceColorHct: Hct.fromInt(0xff0000ff),
        isDark: true,
        contrastLevel: 1.0);
    expect(MaterialDynamicColors.surface.getArgb(scheme), isColor(0xff14121a));
  });
}
