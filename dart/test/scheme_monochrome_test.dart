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
import 'package:material_color_utilities/scheme/scheme_monochrome.dart';
import 'package:test/test.dart';
import './utils/color_matcher.dart';

void main() {
  test('lightTheme_minContrast_primary', () {
    final scheme = SchemeMonochrome(
        sourceColorHct: Hct.fromInt(0xff0000ff),
        isDark: false,
        contrastLevel: -1.0);
    expect(MaterialDynamicColors.primary.getArgb(scheme), isColor(0xff747474));
  });

  test('lightTheme_standardContrast_primary', () {
    final scheme = SchemeMonochrome(
        sourceColorHct: Hct.fromInt(0xff0000ff),
        isDark: false,
        contrastLevel: 0);
    expect(MaterialDynamicColors.primary.getArgb(scheme), isColor(0xff5e5e5e));
  });

  test('lightTheme_maxContrast_primary', () {
    final scheme = SchemeMonochrome(
        sourceColorHct: Hct.fromInt(0xff0000ff),
        isDark: false,
        contrastLevel: 1);
    expect(MaterialDynamicColors.primary.getArgb(scheme), isColor(0xff222222));
  });

  test('lightTheme_minContrast_primaryContainer', () {
    final scheme = SchemeMonochrome(
        sourceColorHct: Hct.fromInt(0xff0000ff),
        isDark: false,
        contrastLevel: -1);
    expect(MaterialDynamicColors.primaryContainer.getArgb(scheme),
        isColor(0xffe2e2e2));
  });

  test('lightTheme_standardContrast_primaryContainer', () {
    final scheme = SchemeMonochrome(
        sourceColorHct: Hct.fromInt(0xff0000ff),
        isDark: false,
        contrastLevel: 0);
    expect(MaterialDynamicColors.primaryContainer.getArgb(scheme),
        isColor(0xffe2e2e2));
  });

  test('lightTheme_maxContrast_primaryContainer', () {
    final scheme = SchemeMonochrome(
        sourceColorHct: Hct.fromInt(0xff0000ff),
        isDark: false,
        contrastLevel: 1);
    expect(MaterialDynamicColors.primaryContainer.getArgb(scheme),
        isColor(0xff434343));
  });

  test('lightTheme_minContrast_onPrimaryContainer', () {
    final scheme = SchemeMonochrome(
        sourceColorHct: Hct.fromInt(0xff0000ff),
        isDark: false,
        contrastLevel: -1);
    expect(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme),
        isColor(0xff646464));
  });

  test('lightTheme_standardContrast_onPrimaryContainer', () {
    final scheme = SchemeMonochrome(
        sourceColorHct: Hct.fromInt(0xff0000ff),
        isDark: false,
        contrastLevel: 0);
    expect(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme),
        isColor(0xff1b1b1b));
  });

  test('lightTheme_maxContrast_onPrimaryContainer', () {
    final scheme = SchemeMonochrome(
        sourceColorHct: Hct.fromInt(0xff0000ff),
        isDark: false,
        contrastLevel: 1);
    expect(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme),
        isColor(0xffdadada));
  });

  test('lightTheme_minContrast_surface', () {
    final scheme = SchemeMonochrome(
        sourceColorHct: Hct.fromInt(0xff0000ff),
        isDark: false,
        contrastLevel: -1);
    expect(MaterialDynamicColors.surface.getArgb(scheme), isColor(0xfff9f9f9));
  });

  test('lightTheme_standardContrast_surface', () {
    final scheme = SchemeMonochrome(
        sourceColorHct: Hct.fromInt(0xff0000ff),
        isDark: false,
        contrastLevel: 0.0);
    expect(MaterialDynamicColors.surface.getArgb(scheme), isColor(0xfff9f9f9));
  });

  test('lightTheme_maxContrast_surface', () {
    final scheme = SchemeMonochrome(
        sourceColorHct: Hct.fromInt(0xff0000ff),
        isDark: false,
        contrastLevel: 1.0);
    expect(MaterialDynamicColors.surface.getArgb(scheme), isColor(0xfff9f9f9));
  });

  test('darkTheme_minContrast_primary', () {
    final scheme = SchemeMonochrome(
        sourceColorHct: Hct.fromInt(0xff0000ff),
        isDark: true,
        contrastLevel: -1.0);
    expect(MaterialDynamicColors.primary.getArgb(scheme), isColor(0xff747474));
  });

  test('darkTheme_standardContrast_primary', () {
    final scheme = SchemeMonochrome(
        sourceColorHct: Hct.fromInt(0xff0000ff),
        isDark: true,
        contrastLevel: 0.0);
    expect(MaterialDynamicColors.primary.getArgb(scheme), isColor(0xffc6c6c6));
  });

  test('darkTheme_maxContrast_primary', () {
    final scheme = SchemeMonochrome(
        sourceColorHct: Hct.fromInt(0xff0000ff),
        isDark: true,
        contrastLevel: 1.0);
    expect(MaterialDynamicColors.primary.getArgb(scheme), isColor(0xfff5f5f5));
  });

  test('darkTheme_minContrast_primaryContainer', () {
    final scheme = SchemeMonochrome(
        sourceColorHct: Hct.fromInt(0xff0000ff),
        isDark: true,
        contrastLevel: -1.0);
    expect(MaterialDynamicColors.primaryContainer.getArgb(scheme),
        isColor(0xff474747));
  });

  test('darkTheme_standardContrast_primaryContainer', () {
    final scheme = SchemeMonochrome(
        sourceColorHct: Hct.fromInt(0xff0000ff),
        isDark: true,
        contrastLevel: 0.0);
    expect(MaterialDynamicColors.primaryContainer.getArgb(scheme),
        isColor(0xff474747));
  });

  test('darkTheme_maxContrast_primaryContainer', () {
    final scheme = SchemeMonochrome(
        sourceColorHct: Hct.fromInt(0xff0000ff),
        isDark: true,
        contrastLevel: 1.0);
    expect(MaterialDynamicColors.primaryContainer.getArgb(scheme),
        isColor(0xffcbcbcb));
  });

  test('darkTheme_minContrast_onPrimaryContainer', () {
    final scheme = SchemeMonochrome(
        sourceColorHct: Hct.fromInt(0xff0000ff),
        isDark: true,
        contrastLevel: -1.0);
    expect(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme),
        isColor(0xffb5b5b5));
  });

  test('darkTheme_standardContrast_onPrimaryContainer', () {
    final scheme = SchemeMonochrome(
        sourceColorHct: Hct.fromInt(0xff0000ff),
        isDark: true,
        contrastLevel: 0.0);
    expect(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme),
        isColor(0xffe2e2e2));
  });

  test('darkTheme_maxContrast_onPrimaryContainer', () {
    final scheme = SchemeMonochrome(
        sourceColorHct: Hct.fromInt(0xff0000ff),
        isDark: true,
        contrastLevel: 1.0);
    expect(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme),
        isColor(0xff393939));
  });

  test('darkTheme_minContrast_onTertiaryContainer', () {
    final scheme = SchemeMonochrome(
        sourceColorHct: Hct.fromInt(0xff0000ff),
        isDark: true,
        contrastLevel: -1.0);
    expect(MaterialDynamicColors.onTertiaryContainer.getArgb(scheme),
        isColor(0xffb5b5b5));
  });

  test('darkTheme_standardContrast_onTertiaryContainer', () {
    final scheme = SchemeMonochrome(
        sourceColorHct: Hct.fromInt(0xff0000ff),
        isDark: true,
        contrastLevel: 0.0);
    expect(MaterialDynamicColors.onTertiaryContainer.getArgb(scheme),
        isColor(0xffe2e2e2));
  });

  test('darkTheme_maxContrast_onTertiaryContainer', () {
    final scheme = SchemeMonochrome(
        sourceColorHct: Hct.fromInt(0xff0000ff),
        isDark: true,
        contrastLevel: 1.0);
    expect(MaterialDynamicColors.onTertiaryContainer.getArgb(scheme),
        isColor(0xff393939));
  });

  test('darkTheme_minContrast_surface', () {
    final scheme = SchemeMonochrome(
        sourceColorHct: Hct.fromInt(0xff0000ff),
        isDark: true,
        contrastLevel: -1.0);
    expect(MaterialDynamicColors.surface.getArgb(scheme), isColor(0xff131313));
  });

  test('darkTheme_standardContrast_surface', () {
    final scheme = SchemeMonochrome(
        sourceColorHct: Hct.fromInt(0xff0000ff),
        isDark: true,
        contrastLevel: 0.0);
    expect(MaterialDynamicColors.surface.getArgb(scheme), isColor(0xff131313));
  });

  test('darkTheme_maxContrast_surface', () {
    final scheme = SchemeMonochrome(
        sourceColorHct: Hct.fromInt(0xff0000ff),
        isDark: true,
        contrastLevel: 1.0);
    expect(MaterialDynamicColors.surface.getArgb(scheme), isColor(0xff131313));
  });
}
