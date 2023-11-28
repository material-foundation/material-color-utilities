// Copyright 2021 Google LLC
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

import 'package:material_color_utilities/hct/hct.dart';
import 'package:material_color_utilities/scheme/scheme_content.dart';
import 'package:material_color_utilities/scheme/scheme_tonal_spot.dart';
import 'package:test/test.dart';

import './utils/color_matcher.dart';

void main() {
  test('blue light scheme', () {
    final scheme = SchemeTonalSpot(
      sourceColorHct: Hct.fromInt(0xff0000ff),
      isDark: false,
      contrastLevel: 0.0,
    );
    expect(scheme.primary, isColor(0xff555992));
  });

  test('blue dark scheme', () {
    final scheme = SchemeTonalSpot(
      sourceColorHct: Hct.fromInt(0xff0000ff),
      isDark: true,
      contrastLevel: 0.0,
    );
    expect(scheme.primary, isColor(0xffbec2ff));
  });

  test('3rd party light scheme', () async {
    final scheme = SchemeTonalSpot(
      sourceColorHct: Hct.fromInt(0xff6750a4),
      isDark: false,
      contrastLevel: 0.0,
    );

    expect(scheme.primary, isColor(0xff65558f));
    expect(scheme.secondary, isColor(0xff625b71));
    expect(scheme.tertiary, isColor(0xff7e5260));
    expect(scheme.surface, isColor(0xfffdf7ff));
    expect(scheme.onSurface, isColor(0xff1d1b20));
  });

  test('3rd party dark scheme', () async {
    final scheme = SchemeTonalSpot(
      sourceColorHct: Hct.fromInt(0xff6750a4),
      isDark: true,
      contrastLevel: 0.0,
    );
    expect(scheme.primary, isColor(0xffcfbdfe));
    expect(scheme.secondary, isColor(0xffcbc2db));
    expect(scheme.tertiary, isColor(0xffefb8c8));
    expect(scheme.surface, isColor(0xff141218));
    expect(scheme.onSurface, isColor(0xffe6e0e9));
  });

  test('light scheme from high chroma color', () async {
    final scheme = SchemeTonalSpot(
      sourceColorHct: Hct.fromInt(0xfffa2bec),
      isDark: false,
      contrastLevel: 0.0,
    );
    expect(scheme.primary, isColor(0xff814c77));
    expect(scheme.onPrimary, isColor(0xffffffff));
    expect(scheme.primaryContainer, isColor(0xffffd7f3));
    expect(scheme.onPrimaryContainer, isColor(0xff340830));
    expect(scheme.secondary, isColor(0xff6e5868));
    expect(scheme.onSecondary, isColor(0xffffffff));
    expect(scheme.secondaryContainer, isColor(0xfff8daee));
    expect(scheme.onSecondaryContainer, isColor(0xff271624));
    expect(scheme.tertiary, isColor(0xff815343));
    expect(scheme.onTertiary, isColor(0xffffffff));
    expect(scheme.tertiaryContainer, isColor(0xffffdbd0));
    expect(scheme.onTertiaryContainer, isColor(0xff321207));
    expect(scheme.error, isColor(0xffba1a1a));
    expect(scheme.onError, isColor(0xffffffff));
    expect(scheme.errorContainer, isColor(0xffffdad6));
    expect(scheme.onErrorContainer, isColor(0xff410002));
    expect(scheme.background, isColor(0xfffff7f9));
    expect(scheme.onBackground, isColor(0xff201a1e));
    expect(scheme.surface, isColor(0xfffff7f9));
    expect(scheme.onSurface, isColor(0xff201a1e));
    expect(scheme.surfaceVariant, isColor(0xffeedee7));
    expect(scheme.onSurfaceVariant, isColor(0xff4e444b));
    expect(scheme.outline, isColor(0xff80747b));
    expect(scheme.outlineVariant, isColor(0xffd2c2cb));
    expect(scheme.shadow, isColor(0xff000000));
    expect(scheme.scrim, isColor(0xff000000));
    expect(scheme.inverseSurface, isColor(0xff362e33));
    expect(scheme.inverseOnSurface, isColor(0xfffaedf3));
    expect(scheme.inversePrimary, isColor(0xfff3b2e4));
  });

  test('dark scheme from high chroma color', () async {
    final scheme = SchemeTonalSpot(
      sourceColorHct: Hct.fromInt(0xfffa2bec),
      isDark: true,
      contrastLevel: 0.0,
    );
    expect(scheme.primary, isColor(0xfff3b2e4));
    expect(scheme.onPrimary, isColor(0xff4d1f47));
    expect(scheme.primaryContainer, isColor(0xff67355e));
    expect(scheme.onPrimaryContainer, isColor(0xffffd7f3));
    expect(scheme.secondary, isColor(0xffdbbed1));
    expect(scheme.onSecondary, isColor(0xff3e2a39));
    expect(scheme.secondaryContainer, isColor(0xff554050));
    expect(scheme.onSecondaryContainer, isColor(0xfff8daee));
    expect(scheme.tertiary, isColor(0xfff5b9a5));
    expect(scheme.onTertiary, isColor(0xff4c2619));
    expect(scheme.tertiaryContainer, isColor(0xff663c2d));
    expect(scheme.onTertiaryContainer, isColor(0xffffdbd0));
    expect(scheme.error, isColor(0xffffb4ab));
    expect(scheme.onError, isColor(0xff690005));
    expect(scheme.errorContainer, isColor(0xff93000a));
    expect(scheme.onErrorContainer, isColor(0xffffdad6));
    expect(scheme.background, isColor(0xff181216));
    expect(scheme.onBackground, isColor(0xffecdfe5));
    expect(scheme.surface, isColor(0xff181216));
    expect(scheme.onSurface, isColor(0xffecdfe5));
    expect(scheme.surfaceVariant, isColor(0xff4e444b));
    expect(scheme.onSurfaceVariant, isColor(0xffd2c2cb));
    expect(scheme.outline, isColor(0xff9a8d95));
    expect(scheme.outlineVariant, isColor(0xff4e444b));
    expect(scheme.shadow, isColor(0xff000000));
    expect(scheme.scrim, isColor(0xff000000));
    expect(scheme.inverseSurface, isColor(0xffecdfe5));
    expect(scheme.inverseOnSurface, isColor(0xff362e33));
    expect(scheme.inversePrimary, isColor(0xff814c77));
  });

  test('light content scheme from high chroma color', () async {
    final scheme = SchemeContent(
      sourceColorHct: Hct.fromInt(0xfffa2bec),
      isDark: false,
      contrastLevel: 0.0,
    );

    expect(scheme.primary, isColor(0xffa7009e));
    expect(scheme.onPrimary, isColor(0xffffffff));
    expect(scheme.primaryContainer, isColor(0xffd100c6));
    expect(scheme.onPrimaryContainer, isColor(0xffffffff));
    expect(scheme.secondary, isColor(0xff9e2d93));
    expect(scheme.onSecondary, isColor(0xffffffff));
    expect(scheme.secondaryContainer, isColor(0xffff83ec));
    expect(scheme.onSecondaryContainer, isColor(0xff4a0045));
    expect(scheme.tertiary, isColor(0xffb51830));
    expect(scheme.onTertiary, isColor(0xffffffff));
    expect(scheme.tertiaryContainer, isColor(0xffd83546));
    expect(scheme.onTertiaryContainer, isColor(0xffffffff));
    expect(scheme.error, isColor(0xffba1a1a));
    expect(scheme.onError, isColor(0xffffffff));
    expect(scheme.errorContainer, isColor(0xffffdad6));
    expect(scheme.onErrorContainer, isColor(0xff410002));
    expect(scheme.background, isColor(0xfffff7f9));
    expect(scheme.onBackground, isColor(0xff251722));
    expect(scheme.surface, isColor(0xfffff7f9));
    expect(scheme.onSurface, isColor(0xff251722));
    expect(scheme.surfaceVariant, isColor(0xfff9daee));
    expect(scheme.onSurfaceVariant, isColor(0xff564050));
    expect(scheme.outline, isColor(0xff897081));
    expect(scheme.outlineVariant, isColor(0xffdcbed2));
    expect(scheme.shadow, isColor(0xff000000));
    expect(scheme.scrim, isColor(0xff000000));
    expect(scheme.inverseSurface, isColor(0xff3b2c37));
    expect(scheme.inverseOnSurface, isColor(0xffffebf6));
    expect(scheme.inversePrimary, isColor(0xffffabee));
  });

  test('dark content scheme from high chroma color', () async {
    final scheme = SchemeContent(
      sourceColorHct: Hct.fromInt(0xfffa2bec),
      isDark: true,
      contrastLevel: 0.0,
    );

    expect(scheme.primary, isColor(0xffffabee));
    expect(scheme.onPrimary, isColor(0xff5c0057));
    expect(scheme.primaryContainer, isColor(0xfffa2bec));
    expect(scheme.onPrimaryContainer, isColor(0xff000000));
    expect(scheme.secondary, isColor(0xffffabee));
    expect(scheme.onSecondary, isColor(0xff5c0057));
    expect(scheme.secondaryContainer, isColor(0xff840f7c));
    expect(scheme.onSecondaryContainer, isColor(0xffffd9f3));
    expect(scheme.tertiary, isColor(0xffffb3b2));
    expect(scheme.onTertiary, isColor(0xff680014));
    expect(scheme.tertiaryContainer, isColor(0xffff525f));
    expect(scheme.onTertiaryContainer, isColor(0xff000000));
    expect(scheme.error, isColor(0xffffb4ab));
    expect(scheme.onError, isColor(0xff690005));
    expect(scheme.errorContainer, isColor(0xff93000a));
    expect(scheme.onErrorContainer, isColor(0xffffdad6));
    expect(scheme.background, isColor(0xff1c0f19));
    expect(scheme.onBackground, isColor(0xfff4dceb));
    expect(scheme.surface, isColor(0xff1c0f19));
    expect(scheme.onSurface, isColor(0xfff4dceb));
    expect(scheme.surfaceVariant, isColor(0xff564050));
    expect(scheme.onSurfaceVariant, isColor(0xffdcbed2));
    expect(scheme.outline, isColor(0xffa4899b));
    expect(scheme.outlineVariant, isColor(0xff564050));
    expect(scheme.shadow, isColor(0xff000000));
    expect(scheme.scrim, isColor(0xff000000));
    expect(scheme.inverseSurface, isColor(0xfff4dceb));
    expect(scheme.inverseOnSurface, isColor(0xff3b2c37));
    expect(scheme.inversePrimary, isColor(0xffab00a2));
  });
}
