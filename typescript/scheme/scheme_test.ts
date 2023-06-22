/**
 * @license
 * Copyright 2021 Google LLC
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

import {customMatchers} from '../utils/test_utils.js';

import {Scheme} from './scheme.js';
import {SchemeAndroid} from './scheme_android.js';

beforeEach(() => {
  jasmine.addMatchers(customMatchers);
});

describe('scheme', () => {
  it('blue light scheme', () => {
    const scheme = Scheme.light(0xff0000ff);
    expect(scheme.primary).matchesColor(0xff343dff);
  });

  it('blue dark scheme', () => {
    const scheme = Scheme.dark(0xff0000ff);
    expect(scheme.primary).matchesColor(0xffbec2ff);
  });

  it('3rd party light scheme', () => {
    const scheme = Scheme.light(0xff6750a4);
    expect(scheme.primary).matchesColor(0xff6750a4);
    expect(scheme.secondary).matchesColor(0xff625b71);
    expect(scheme.tertiary).matchesColor(0xff7e5260);
    expect(scheme.surface).matchesColor(0xfffffbff);
    expect(scheme.onSurface).matchesColor(0xff1c1b1e);
  });

  it('3rd party dark scheme', () => {
    const scheme = Scheme.dark(0xff6750a4);
    expect(scheme.primary).matchesColor(0xffcfbcff);
    expect(scheme.secondary).matchesColor(0xffcbc2db);
    expect(scheme.tertiary).matchesColor(0xffefb8c8);
    expect(scheme.surface).matchesColor(0xff1c1b1e);
    expect(scheme.onSurface).matchesColor(0xffe6e1e6);
  });

  it('light scheme from high chroma color', () => {
    const scheme = Scheme.light(0xfffa2bec);
    expect(scheme.primary).matchesColor(0xffab00a2);
    expect(scheme.onPrimary).matchesColor(0xffffffff);
    expect(scheme.primaryContainer).matchesColor(0xffffd7f3);
    expect(scheme.onPrimaryContainer).matchesColor(0xff390035);
    expect(scheme.secondary).matchesColor(0xff6e5868);
    expect(scheme.onSecondary).matchesColor(0xffffffff);
    expect(scheme.secondaryContainer).matchesColor(0xfff8daee);
    expect(scheme.onSecondaryContainer).matchesColor(0xff271624);
    expect(scheme.tertiary).matchesColor(0xff815343);
    expect(scheme.onTertiary).matchesColor(0xffffffff);
    expect(scheme.tertiaryContainer).matchesColor(0xffffdbd0);
    expect(scheme.onTertiaryContainer).matchesColor(0xff321207);
    expect(scheme.error).matchesColor(0xffba1a1a);
    expect(scheme.onError).matchesColor(0xffffffff);
    expect(scheme.errorContainer).matchesColor(0xffffdad6);
    expect(scheme.onErrorContainer).matchesColor(0xff410002);
    expect(scheme.background).matchesColor(0xfffffbff);
    expect(scheme.onBackground).matchesColor(0xff1f1a1d);
    expect(scheme.surface).matchesColor(0xfffffbff);
    expect(scheme.onSurface).matchesColor(0xff1f1a1d);
    expect(scheme.surfaceVariant).matchesColor(0xffeedee7);
    expect(scheme.onSurfaceVariant).matchesColor(0xff4e444b);
    expect(scheme.outline).matchesColor(0xff80747b);
    expect(scheme.outlineVariant).matchesColor(0xffd2c2cb);
    expect(scheme.shadow).matchesColor(0xff000000);
    expect(scheme.scrim).matchesColor(0xff000000);
    expect(scheme.inverseSurface).matchesColor(0xff342f32);
    expect(scheme.inverseOnSurface).matchesColor(0xfff8eef2);
    expect(scheme.inversePrimary).matchesColor(0xffffabee);
  });

  it('dark scheme from high chroma color', () => {
    const scheme = Scheme.dark(0xfffa2bec);
    expect(scheme.primary).matchesColor(0xffffabee);
    expect(scheme.onPrimary).matchesColor(0xff5c0057);
    expect(scheme.primaryContainer).matchesColor(0xff83007b);
    expect(scheme.onPrimaryContainer).matchesColor(0xffffd7f3);
    expect(scheme.secondary).matchesColor(0xffdbbed1);
    expect(scheme.onSecondary).matchesColor(0xff3e2a39);
    expect(scheme.secondaryContainer).matchesColor(0xff554050);
    expect(scheme.onSecondaryContainer).matchesColor(0xfff8daee);
    expect(scheme.tertiary).matchesColor(0xfff5b9a5);
    expect(scheme.onTertiary).matchesColor(0xff4c2619);
    expect(scheme.tertiaryContainer).matchesColor(0xff663c2d);
    expect(scheme.onTertiaryContainer).matchesColor(0xffffdbd0);
    expect(scheme.error).matchesColor(0xffffb4ab);
    expect(scheme.onError).matchesColor(0xff690005);
    expect(scheme.errorContainer).matchesColor(0xff93000a);
    expect(scheme.onErrorContainer).matchesColor(0xffffb4ab);
    expect(scheme.background).matchesColor(0xff1f1a1d);
    expect(scheme.onBackground).matchesColor(0xffeae0e4);
    expect(scheme.surface).matchesColor(0xff1f1a1d);
    expect(scheme.onSurface).matchesColor(0xffeae0e4);
    expect(scheme.surfaceVariant).matchesColor(0xff4e444b);
    expect(scheme.onSurfaceVariant).matchesColor(0xffd2c2cb);
    expect(scheme.outline).matchesColor(0xff9a8d95);
    expect(scheme.outlineVariant).matchesColor(0xff4e444b);
    expect(scheme.shadow).matchesColor(0xff000000);
    expect(scheme.scrim).matchesColor(0xff000000);
    expect(scheme.inverseSurface).matchesColor(0xffeae0e4);
    expect(scheme.inverseOnSurface).matchesColor(0xff342f32);
    expect(scheme.inversePrimary).matchesColor(0xffab00a2);
  });

  it('light content scheme from high chroma color', () => {
    const scheme = Scheme.lightContent(0xfffa2bec);
    expect(scheme.primary).matchesColor(0xffab00a2);
    expect(scheme.onPrimary).matchesColor(0xffffffff);
    expect(scheme.primaryContainer).matchesColor(0xffffd7f3);
    expect(scheme.onPrimaryContainer).matchesColor(0xff390035);
    expect(scheme.secondary).matchesColor(0xff7f4e75);
    expect(scheme.onSecondary).matchesColor(0xffffffff);
    expect(scheme.secondaryContainer).matchesColor(0xffffd7f3);
    expect(scheme.onSecondaryContainer).matchesColor(0xff330b2f);
    expect(scheme.tertiary).matchesColor(0xff9c4323);
    expect(scheme.onTertiary).matchesColor(0xffffffff);
    expect(scheme.tertiaryContainer).matchesColor(0xffffdbd0);
    expect(scheme.onTertiaryContainer).matchesColor(0xff390c00);
    expect(scheme.error).matchesColor(0xffba1a1a);
    expect(scheme.onError).matchesColor(0xffffffff);
    expect(scheme.errorContainer).matchesColor(0xffffdad6);
    expect(scheme.onErrorContainer).matchesColor(0xff410002);
    expect(scheme.background).matchesColor(0xfffffbff);
    expect(scheme.onBackground).matchesColor(0xff1f1a1d);
    expect(scheme.surface).matchesColor(0xfffffbff);
    expect(scheme.onSurface).matchesColor(0xff1f1a1d);
    expect(scheme.surfaceVariant).matchesColor(0xffeedee7);
    expect(scheme.onSurfaceVariant).matchesColor(0xff4e444b);
    expect(scheme.outline).matchesColor(0xff80747b);
    expect(scheme.outlineVariant).matchesColor(0xffd2c2cb);
    expect(scheme.shadow).matchesColor(0xff000000);
    expect(scheme.scrim).matchesColor(0xff000000);
    expect(scheme.inverseSurface).matchesColor(0xff342f32);
    expect(scheme.inverseOnSurface).matchesColor(0xfff8eef2);
    expect(scheme.inversePrimary).matchesColor(0xffffabee);
  });

  it('dark content scheme from high chroma color', () => {
    const scheme = Scheme.darkContent(0xfffa2bec);
    expect(scheme.primary).matchesColor(0xffffabee);
    expect(scheme.onPrimary).matchesColor(0xff5c0057);
    expect(scheme.primaryContainer).matchesColor(0xff83007b);
    expect(scheme.onPrimaryContainer).matchesColor(0xffffd7f3);
    expect(scheme.secondary).matchesColor(0xfff0b4e1);
    expect(scheme.onSecondary).matchesColor(0xff4b2145);
    expect(scheme.secondaryContainer).matchesColor(0xff64375c);
    expect(scheme.onSecondaryContainer).matchesColor(0xffffd7f3);
    expect(scheme.tertiary).matchesColor(0xffffb59c);
    expect(scheme.onTertiary).matchesColor(0xff5c1900);
    expect(scheme.tertiaryContainer).matchesColor(0xff7d2c0d);
    expect(scheme.onTertiaryContainer).matchesColor(0xffffdbd0);
    expect(scheme.error).matchesColor(0xffffb4ab);
    expect(scheme.onError).matchesColor(0xff690005);
    expect(scheme.errorContainer).matchesColor(0xff93000a);
    expect(scheme.onErrorContainer).matchesColor(0xffffb4ab);
    expect(scheme.background).matchesColor(0xff1f1a1d);
    expect(scheme.onBackground).matchesColor(0xffeae0e4);
    expect(scheme.surface).matchesColor(0xff1f1a1d);
    expect(scheme.onSurface).matchesColor(0xffeae0e4);
    expect(scheme.surfaceVariant).matchesColor(0xff4e444b);
    expect(scheme.onSurfaceVariant).matchesColor(0xffd2c2cb);
    expect(scheme.outline).matchesColor(0xff9a8d95);
    expect(scheme.outlineVariant).matchesColor(0xff4e444b);
    expect(scheme.shadow).matchesColor(0xff000000);
    expect(scheme.scrim).matchesColor(0xff000000);
    expect(scheme.inverseSurface).matchesColor(0xffeae0e4);
    expect(scheme.inverseOnSurface).matchesColor(0xff342f32);
    expect(scheme.inversePrimary).matchesColor(0xffab00a2);
  });
});

describe('android scheme', () => {
  it('blue light scheme', () => {
    const scheme = SchemeAndroid.light(0xff0000ff);
    expect(scheme.colorAccentPrimary).matchesColor(0xffe0e0ff);
  });

  it('blue dark scheme', () => {
    const scheme = SchemeAndroid.dark(0xff0000ff);
    expect(scheme.colorAccentPrimary).matchesColor(0xffe0e0ff);
  });

  it('3rd party light scheme', () => {
    const scheme = SchemeAndroid.light(0xff6750a4);
    expect(scheme.colorAccentPrimary).matchesColor(0xffe9ddff);
    expect(scheme.colorAccentSecondary).matchesColor(0xffe8def8);
    expect(scheme.colorAccentTertiary).matchesColor(0xffffd9e3);
    expect(scheme.colorSurface).matchesColor(0xfffdf8fd);
    expect(scheme.textColorPrimary).matchesColor(0xff1c1b1e);
  });

  it('3rd party dark scheme', () => {
    const scheme = SchemeAndroid.dark(0xff6750a4);
    expect(scheme.colorAccentPrimary).matchesColor(0xffe9ddff);
    expect(scheme.colorAccentSecondary).matchesColor(0xffe8def8);
    expect(scheme.colorAccentTertiary).matchesColor(0xffffd9e3);
    expect(scheme.colorSurface).matchesColor(0xff313033);
    expect(scheme.textColorPrimary).matchesColor(0xfff4eff4);
  });
});
