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
  test('lightTheme_minContrast_primary', () {
    final scheme = SchemeExpressive(
        sourceColorHct: Hct.fromInt(0xff0000ff),
        isDark: false,
        contrastLevel: -1.0);
    expect(MaterialDynamicColors.primary.getArgb(scheme), isColor(0xffad603c));
  });

  test('lightTheme_standardContrast_primary', () {
    final scheme = SchemeExpressive(
        sourceColorHct: Hct.fromInt(0xff0000ff),
        isDark: false,
        contrastLevel: 0.0);
    expect(MaterialDynamicColors.primary.getArgb(scheme), isColor(0xff924b28));
  });

  test('lightTheme_maxContrast_primary', () {
    final scheme = SchemeExpressive(
        sourceColorHct: Hct.fromInt(0xff0000ff),
        isDark: false,
        contrastLevel: 1.0);
    expect(MaterialDynamicColors.primary.getArgb(scheme), isColor(0xff401400));
  });

  test('lightTheme_minContrast_primaryContainer', () {
    final scheme = SchemeExpressive(
        sourceColorHct: Hct.fromInt(0xff0000ff),
        isDark: false,
        contrastLevel: -1.0);
    expect(MaterialDynamicColors.primaryContainer.getArgb(scheme),
        isColor(0xffffdbcc));
  });

  test('lightTheme_standardContrast_primaryContainer', () {
    final scheme = SchemeExpressive(
        sourceColorHct: Hct.fromInt(0xff0000ff),
        isDark: false,
        contrastLevel: 0.0);
    expect(MaterialDynamicColors.primaryContainer.getArgb(scheme),
        isColor(0xffffdbcc));
  });

  test('lightTheme_maxContrast_primaryContainer', () {
    final scheme = SchemeExpressive(
        sourceColorHct: Hct.fromInt(0xff0000ff),
        isDark: false,
        contrastLevel: 1.0);
    expect(MaterialDynamicColors.primaryContainer.getArgb(scheme),
        isColor(0xff6f3010));
  });

  test('lightTheme_minContrast_onPrimaryContainer', () {
    final scheme = SchemeExpressive(
        sourceColorHct: Hct.fromInt(0xff0000ff),
        isDark: false,
        contrastLevel: -1.0);
    expect(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme),
        isColor(0xff99512e));
  });

  test('lightTheme_standardContrast_onPrimaryContainer', () {
    final scheme = SchemeExpressive(
        sourceColorHct: Hct.fromInt(0xff0000ff),
        isDark: false,
        contrastLevel: 0.0);
    expect(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme),
        isColor(0xff351000));
  });

  test('lightTheme_maxContrast_onPrimaryContainer', () {
    final scheme = SchemeExpressive(
        sourceColorHct: Hct.fromInt(0xff0000ff),
        isDark: false,
        contrastLevel: 1.0);
    expect(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme),
        isColor(0xffffd0bc));
  });

  test('lightTheme_minContrast_surface', () {
    final scheme = SchemeExpressive(
        sourceColorHct: Hct.fromInt(0xff0000ff),
        isDark: false,
        contrastLevel: -1.0);
    expect(MaterialDynamicColors.surface.getArgb(scheme), isColor(0xfffbf8ff));
  });

  test('lightTheme_standardContrast_surface', () {
    final scheme = SchemeExpressive(
        sourceColorHct: Hct.fromInt(0xff0000ff),
        isDark: false,
        contrastLevel: 0.0);
    expect(MaterialDynamicColors.surface.getArgb(scheme), isColor(0xfffbf8ff));
  });

  test('lightTheme_maxContrast_surface', () {
    final scheme = SchemeExpressive(
        sourceColorHct: Hct.fromInt(0xff0000ff),
        isDark: false,
        contrastLevel: 1.0);
    expect(MaterialDynamicColors.surface.getArgb(scheme), isColor(0xfffbf8ff));
  });

  test('darkTheme_minContrast_primary', () {
    final scheme = SchemeExpressive(
        sourceColorHct: Hct.fromInt(0xff0000ff),
        isDark: true,
        contrastLevel: -1.0);
    expect(MaterialDynamicColors.primary.getArgb(scheme), isColor(0xffad603c));
  });

  test('darkTheme_standardContrast_primary', () {
    final scheme = SchemeExpressive(
        sourceColorHct: Hct.fromInt(0xff0000ff),
        isDark: true,
        contrastLevel: 0.0);
    expect(MaterialDynamicColors.primary.getArgb(scheme), isColor(0xffffb595));
  });

  test('darkTheme_maxContrast_primary', () {
    final scheme = SchemeExpressive(
        sourceColorHct: Hct.fromInt(0xff0000ff),
        isDark: true,
        contrastLevel: 1.0);
    expect(MaterialDynamicColors.primary.getArgb(scheme), isColor(0xfffff3ee));
  });

  test('darkTheme_minContrast_primaryContainer', () {
    final scheme = SchemeExpressive(
        sourceColorHct: Hct.fromInt(0xff0000ff),
        isDark: true,
        contrastLevel: -1.0);
    expect(MaterialDynamicColors.primaryContainer.getArgb(scheme),
        isColor(0xff743413));
  });

  test('darkTheme_standardContrast_primaryContainer', () {
    final scheme = SchemeExpressive(
        sourceColorHct: Hct.fromInt(0xff0000ff),
        isDark: true,
        contrastLevel: 0.0);
    expect(MaterialDynamicColors.primaryContainer.getArgb(scheme),
        isColor(0xff743413));
  });

  test('darkTheme_maxContrast_primaryContainer', () {
    final scheme = SchemeExpressive(
        sourceColorHct: Hct.fromInt(0xff0000ff),
        isDark: true,
        contrastLevel: 1.0);
    expect(MaterialDynamicColors.primaryContainer.getArgb(scheme),
        isColor(0xffffbb9e));
  });

  test('darkTheme_minContrast_onPrimaryContainer', () {
    final scheme = SchemeExpressive(
        sourceColorHct: Hct.fromInt(0xff0000ff),
        isDark: true,
        contrastLevel: -1.0);
    expect(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme),
        isColor(0xfff99f75));
  });

  test('darkTheme_standardContrast_onPrimaryContainer', () {
    final scheme = SchemeExpressive(
        sourceColorHct: Hct.fromInt(0xff0000ff),
        isDark: true,
        contrastLevel: 0.0);
    expect(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme),
        isColor(0xffffdbcc));
  });

  test('darkTheme_maxContrast_onPrimaryContainer', () {
    final scheme = SchemeExpressive(
        sourceColorHct: Hct.fromInt(0xff0000ff),
        isDark: true,
        contrastLevel: 1.0);
    expect(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme),
        isColor(0xff622706));
  });

  test('darkTheme_minContrast_surface', () {
    final scheme = SchemeExpressive(
        sourceColorHct: Hct.fromInt(0xff0000ff),
        isDark: true,
        contrastLevel: -1.0);
    expect(MaterialDynamicColors.surface.getArgb(scheme), isColor(0xff12131a));
  });

  test('darkTheme_standardContrast_surface', () {
    final scheme = SchemeExpressive(
        sourceColorHct: Hct.fromInt(0xff0000ff),
        isDark: true,
        contrastLevel: 0.0);
    expect(MaterialDynamicColors.surface.getArgb(scheme), isColor(0xff12131a));
  });

  test('darkTheme_maxContrast_surface', () {
    final scheme = SchemeExpressive(
        sourceColorHct: Hct.fromInt(0xff0000ff),
        isDark: true,
        contrastLevel: 1.0);
    expect(MaterialDynamicColors.surface.getArgb(scheme), isColor(0xff12131a));
  });
}
