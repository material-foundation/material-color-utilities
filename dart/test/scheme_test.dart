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

import 'package:material_color_utilities/scheme/scheme.dart';
import 'package:test/test.dart';

import './utils/color_matcher.dart';

void main() {
  test('blue light scheme', () {
    final scheme = Scheme.light(0xff0000ff);
    expect(scheme.primary, isColor(0xff343DFF));
  });

  test('blue dark scheme', () {
    final scheme = Scheme.dark(0xff0000ff);
    expect(scheme.primary, isColor(0xffBEC2FF));
  });

  test('3rd party light scheme', () async {
    final scheme = Scheme.light(0xff6750A4);
    expect(scheme.primary, isColor(0xff6750A4));
    expect(scheme.secondary, isColor(0xff625B71));
    expect(scheme.tertiary, isColor(0xff7E5260));
    expect(scheme.surface, isColor(0xffFFFBFF));
    expect(scheme.onSurface, isColor(0xff1C1B1E));
  });

  test('3rd party dark scheme', () async {
    final scheme = Scheme.dark(0xff6750A4);
    expect(scheme.primary, isColor(0xffCFBCFF));
    expect(scheme.secondary, isColor(0xffCBC2DB));
    expect(scheme.tertiary, isColor(0xffEFB8C8));
    expect(scheme.surface, isColor(0xff1c1b1e));
    expect(scheme.onSurface, isColor(0xffE6E1E6));
  });

  test('light scheme from high chroma color', () async {
    final scheme = Scheme.light(0xfffa2bec);
    expect(scheme.primary, isColor(0xffab00a2));
    expect(scheme.onPrimary, isColor(0xffffffff));
    expect(scheme.primaryContainer, isColor(0xffffd7f3));
    expect(scheme.onPrimaryContainer, isColor(0xff390035));
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
    expect(scheme.background, isColor(0xfffffbff));
    expect(scheme.onBackground, isColor(0xff1f1a1d));
    expect(scheme.surface, isColor(0xfffffbff));
    expect(scheme.onSurface, isColor(0xff1f1a1d));
    expect(scheme.surfaceVariant, isColor(0xffeedee7));
    expect(scheme.onSurfaceVariant, isColor(0xff4e444b));
    expect(scheme.outline, isColor(0xff80747b));
    expect(scheme.outlineVariant, isColor(0xffd2c2cb));
    expect(scheme.shadow, isColor(0xff000000));
    expect(scheme.scrim, isColor(0xff000000));
    expect(scheme.inverseSurface, isColor(0xff342f32));
    expect(scheme.inverseOnSurface, isColor(0xfff8eef2));
    expect(scheme.inversePrimary, isColor(0xffffabee));
  });

  test('dark scheme from high chroma color', () async {
    final scheme = Scheme.dark(0xfffa2bec);
    expect(scheme.primary, isColor(0xffffabee));
    expect(scheme.onPrimary, isColor(0xff5c0057));
    expect(scheme.primaryContainer, isColor(0xff83007b));
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
    expect(scheme.onErrorContainer, isColor(0xffffb4ab));
    expect(scheme.background, isColor(0xff1f1a1d));
    expect(scheme.onBackground, isColor(0xffeae0e4));
    expect(scheme.surface, isColor(0xff1f1a1d));
    expect(scheme.onSurface, isColor(0xffeae0e4));
    expect(scheme.surfaceVariant, isColor(0xff4e444b));
    expect(scheme.onSurfaceVariant, isColor(0xffd2c2cb));
    expect(scheme.outline, isColor(0xff9a8d95));
    expect(scheme.outlineVariant, isColor(0xff4e444b));
    expect(scheme.shadow, isColor(0xff000000));
    expect(scheme.scrim, isColor(0xff000000));
    expect(scheme.inverseSurface, isColor(0xffeae0e4));
    expect(scheme.inverseOnSurface, isColor(0xff342f32));
    expect(scheme.inversePrimary, isColor(0xffab00a2));
  });

  test('light content scheme from high chroma color', () async {
    final scheme = Scheme.lightContent(0xfffa2bec);
    expect(scheme.primary, isColor(0xffab00a2));
    expect(scheme.onPrimary, isColor(0xffffffff));
    expect(scheme.primaryContainer, isColor(0xffffd7f3));
    expect(scheme.onPrimaryContainer, isColor(0xff390035));
    expect(scheme.secondary, isColor(0xff7f4e75));
    expect(scheme.onSecondary, isColor(0xffffffff));
    expect(scheme.secondaryContainer, isColor(0xffffd7f3));
    expect(scheme.onSecondaryContainer, isColor(0xff330b2f));
    expect(scheme.tertiary, isColor(0xff9c4323));
    expect(scheme.onTertiary, isColor(0xffffffff));
    expect(scheme.tertiaryContainer, isColor(0xffffdbd0));
    expect(scheme.onTertiaryContainer, isColor(0xff390c00));
    expect(scheme.error, isColor(0xffba1a1a));
    expect(scheme.onError, isColor(0xffffffff));
    expect(scheme.errorContainer, isColor(0xffffdad6));
    expect(scheme.onErrorContainer, isColor(0xff410002));
    expect(scheme.background, isColor(0xfffffbff));
    expect(scheme.onBackground, isColor(0xff1f1a1d));
    expect(scheme.surface, isColor(0xfffffbff));
    expect(scheme.onSurface, isColor(0xff1f1a1d));
    expect(scheme.surfaceVariant, isColor(0xffeedee7));
    expect(scheme.onSurfaceVariant, isColor(0xff4e444b));
    expect(scheme.outline, isColor(0xff80747b));
    expect(scheme.outlineVariant, isColor(0xffd2c2cb));
    expect(scheme.shadow, isColor(0xff000000));
    expect(scheme.scrim, isColor(0xff000000));
    expect(scheme.inverseSurface, isColor(0xff342f32));
    expect(scheme.inverseOnSurface, isColor(0xfff8eef2));
    expect(scheme.inversePrimary, isColor(0xffffabee));
  });

  test('dark content scheme from high chroma color', () async {
    final scheme = Scheme.darkContent(0xfffa2bec);
    expect(scheme.primary, isColor(0xffffabee));
    expect(scheme.onPrimary, isColor(0xff5c0057));
    expect(scheme.primaryContainer, isColor(0xff83007b));
    expect(scheme.onPrimaryContainer, isColor(0xffffd7f3));
    expect(scheme.secondary, isColor(0xfff0b4e1));
    expect(scheme.onSecondary, isColor(0xff4b2145));
    expect(scheme.secondaryContainer, isColor(0xff64375c));
    expect(scheme.onSecondaryContainer, isColor(0xffffd7f3));
    expect(scheme.tertiary, isColor(0xffffb59c));
    expect(scheme.onTertiary, isColor(0xff5c1900));
    expect(scheme.tertiaryContainer, isColor(0xff7d2c0d));
    expect(scheme.onTertiaryContainer, isColor(0xffffdbd0));
    expect(scheme.error, isColor(0xffffb4ab));
    expect(scheme.onError, isColor(0xff690005));
    expect(scheme.errorContainer, isColor(0xff93000a));
    expect(scheme.onErrorContainer, isColor(0xffffb4ab));
    expect(scheme.background, isColor(0xff1f1a1d));
    expect(scheme.onBackground, isColor(0xffeae0e4));
    expect(scheme.surface, isColor(0xff1f1a1d));
    expect(scheme.onSurface, isColor(0xffeae0e4));
    expect(scheme.surfaceVariant, isColor(0xff4e444b));
    expect(scheme.onSurfaceVariant, isColor(0xffd2c2cb));
    expect(scheme.outline, isColor(0xff9a8d95));
    expect(scheme.outlineVariant, isColor(0xff4e444b));
    expect(scheme.shadow, isColor(0xff000000));
    expect(scheme.scrim, isColor(0xff000000));
    expect(scheme.inverseSurface, isColor(0xffeae0e4));
    expect(scheme.inverseOnSurface, isColor(0xff342f32));
    expect(scheme.inversePrimary, isColor(0xffab00a2));
  });
}
