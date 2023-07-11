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

void main() {
  test('darkTheme_monochromeSpec', () {
    final scheme = SchemeMonochrome(
      sourceColorHct: Hct.fromInt(0xff0000ff),
      isDark: true,
      contrastLevel: 0.0,
    );
    expect(
      MaterialDynamicColors.primary.getHct(scheme).tone,
      closeTo(100, 1),
    );
    expect(
      MaterialDynamicColors.onPrimary.getHct(scheme).tone,
      closeTo(10, 1),
    );
    expect(
      MaterialDynamicColors.primaryContainer.getHct(scheme).tone,
      closeTo(85, 1),
    );
    expect(
      MaterialDynamicColors.onPrimaryContainer.getHct(scheme).tone,
      closeTo(0, 1),
    );
    expect(
      MaterialDynamicColors.secondary.getHct(scheme).tone,
      closeTo(80, 1),
    );
    expect(
      MaterialDynamicColors.onSecondary.getHct(scheme).tone,
      closeTo(10, 1),
    );
    expect(
      MaterialDynamicColors.secondaryContainer.getHct(scheme).tone,
      closeTo(30, 1),
    );
    expect(
      MaterialDynamicColors.onSecondaryContainer.getHct(scheme).tone,
      closeTo(90, 1),
    );
    expect(
      MaterialDynamicColors.tertiary.getHct(scheme).tone,
      closeTo(90, 1),
    );
    expect(
      MaterialDynamicColors.onTertiary.getHct(scheme).tone,
      closeTo(10, 1),
    );
    expect(
      MaterialDynamicColors.tertiaryContainer.getHct(scheme).tone,
      closeTo(60, 1),
    );
    expect(
      MaterialDynamicColors.onTertiaryContainer.getHct(scheme).tone,
      closeTo(0, 1),
    );
  });

  test('lightTheme_monochromeSpec', () {
    final scheme = SchemeMonochrome(
      sourceColorHct: Hct.fromInt(0xff0000ff),
      isDark: false,
      contrastLevel: 0.0,
    );
    expect(
      MaterialDynamicColors.primary.getHct(scheme).tone,
      closeTo(0, 1),
    );
    expect(
      MaterialDynamicColors.onPrimary.getHct(scheme).tone,
      closeTo(90, 1),
    );
    expect(
      MaterialDynamicColors.primaryContainer.getHct(scheme).tone,
      closeTo(25, 1),
    );
    expect(
      MaterialDynamicColors.onPrimaryContainer.getHct(scheme).tone,
      closeTo(100, 1),
    );
    expect(
      MaterialDynamicColors.secondary.getHct(scheme).tone,
      closeTo(40, 1),
    );
    expect(
      MaterialDynamicColors.onSecondary.getHct(scheme).tone,
      closeTo(100, 1),
    );
    expect(
      MaterialDynamicColors.secondaryContainer.getHct(scheme).tone,
      closeTo(85, 1),
    );
    expect(
      MaterialDynamicColors.onSecondaryContainer.getHct(scheme).tone,
      closeTo(10, 1),
    );
    expect(
      MaterialDynamicColors.tertiary.getHct(scheme).tone,
      closeTo(25, 1),
    );
    expect(
      MaterialDynamicColors.onTertiary.getHct(scheme).tone,
      closeTo(90, 1),
    );
    expect(
      MaterialDynamicColors.tertiaryContainer.getHct(scheme).tone,
      closeTo(49, 1),
    );
    expect(
      MaterialDynamicColors.onTertiaryContainer.getHct(scheme).tone,
      closeTo(100, 1),
    );
  });
}
