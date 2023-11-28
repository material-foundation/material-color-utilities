/**
 * @license
 * Copyright 2023 Google LLC
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

import {Contrast} from '../contrast/contrast.js';
import {ContrastCurve} from '../dynamiccolor/contrast_curve.js';
import {MaterialDynamicColors} from '../dynamiccolor/material_dynamic_colors.js';
import {Hct} from '../hct/hct.js';
import {DynamicScheme} from '../scheme/dynamic_scheme.js';
import {SchemeContent} from '../scheme/scheme_content.js';
import {SchemeExpressive} from '../scheme/scheme_expressive.js';
import {SchemeFidelity} from '../scheme/scheme_fidelity.js';
import {SchemeMonochrome} from '../scheme/scheme_monochrome.js';
import {SchemeNeutral} from '../scheme/scheme_neutral.js';
import {SchemeTonalSpot} from '../scheme/scheme_tonal_spot.js';
import {SchemeVibrant} from '../scheme/scheme_vibrant.js';
import * as colorUtils from '../utils/color_utils.js';

const seedColors = [
  Hct.fromInt(0xFFFF0000),
  Hct.fromInt(0xFFFFFF00),
  Hct.fromInt(0xFF00FF00),
  Hct.fromInt(0xFF0000FF),
];

class Pair {
  constructor(public fgName: string, public bgName: string) {}
}

const colors = [
  MaterialDynamicColors.background,
  MaterialDynamicColors.onBackground,
  MaterialDynamicColors.surface,
  MaterialDynamicColors.surfaceDim,
  MaterialDynamicColors.surfaceBright,
  MaterialDynamicColors.surfaceContainerLowest,
  MaterialDynamicColors.surfaceContainerLow,
  MaterialDynamicColors.surfaceContainer,
  MaterialDynamicColors.surfaceContainerHigh,
  MaterialDynamicColors.surfaceContainerHighest,
  MaterialDynamicColors.onSurface,
  MaterialDynamicColors.surfaceVariant,
  MaterialDynamicColors.onSurfaceVariant,
  MaterialDynamicColors.inverseSurface,
  MaterialDynamicColors.inverseOnSurface,
  MaterialDynamicColors.outline,
  MaterialDynamicColors.outlineVariant,
  MaterialDynamicColors.shadow,
  MaterialDynamicColors.scrim,
  MaterialDynamicColors.surfaceTint,
  MaterialDynamicColors.primary,
  MaterialDynamicColors.onPrimary,
  MaterialDynamicColors.primaryContainer,
  MaterialDynamicColors.onPrimaryContainer,
  MaterialDynamicColors.inversePrimary,
  MaterialDynamicColors.secondary,
  MaterialDynamicColors.onSecondary,
  MaterialDynamicColors.secondaryContainer,
  MaterialDynamicColors.onSecondaryContainer,
  MaterialDynamicColors.tertiary,
  MaterialDynamicColors.onTertiary,
  MaterialDynamicColors.tertiaryContainer,
  MaterialDynamicColors.onTertiaryContainer,
  MaterialDynamicColors.error,
  MaterialDynamicColors.onError,
  MaterialDynamicColors.errorContainer,
  MaterialDynamicColors.onErrorContainer,
  MaterialDynamicColors.primaryFixed,
  MaterialDynamicColors.primaryFixedDim,
  MaterialDynamicColors.onPrimaryFixed,
  MaterialDynamicColors.onPrimaryFixedVariant,
  MaterialDynamicColors.secondaryFixed,
  MaterialDynamicColors.secondaryFixedDim,
  MaterialDynamicColors.onSecondaryFixed,
  MaterialDynamicColors.onSecondaryFixedVariant,
  MaterialDynamicColors.tertiaryFixed,
  MaterialDynamicColors.tertiaryFixedDim,
  MaterialDynamicColors.onTertiaryFixed,
  MaterialDynamicColors.onTertiaryFixedVariant,
];

const colorByName = new Map(
    colors.map((color) => [color.name, color]),
);

const textSurfacePairs = [
  new Pair('on_primary', 'primary'),
  new Pair('on_primary_container', 'primary_container'),
  new Pair('on_secondary', 'secondary'),
  new Pair('on_secondary_container', 'secondary_container'),
  new Pair('on_tertiary', 'tertiary'),
  new Pair('on_tertiary_container', 'tertiary_container'),
  new Pair('on_error', 'error'),
  new Pair('on_error_container', 'error_container'),
  new Pair('on_background', 'background'),
  new Pair('on_surface_variant', 'surface_bright'),
  new Pair('on_surface_variant', 'surface_dim'),
];

function getMinRequirement(curve: ContrastCurve, level: number): number {
  if (level >= 1) return curve.high;
  if (level >= 0.5) return curve.medium;
  if (level >= 0) return curve.normal;
  return curve.low;
}

function getPairs(resp: boolean, fores: string[], backs: string[]): string[][] {
  const ans = [];
  if (resp) {
    for (let i = 0; i < fores.length; i++) {
      ans.push([fores[i], backs[i]]);
    }
  } else {
    for (const f of fores) {
      for (const b of backs) {
        ans.push([f, b]);
      }
    }
  }
  return ans;
}

const schemes: DynamicScheme[] = [];

for (const color of seedColors) {
  for (const contrastLevel
           of [-1.0, -0.75, -0.5, -0.25, 0.0, 0.25, 0.5, 0.75, 1.0]) {
    for (const isDark of [false, true]) {
      for (const scheme
               of [new SchemeContent(color, isDark, contrastLevel),
                   new SchemeExpressive(color, isDark, contrastLevel),
                   new SchemeFidelity(color, isDark, contrastLevel),
                   new SchemeMonochrome(color, isDark, contrastLevel),
                   new SchemeNeutral(color, isDark, contrastLevel),
                   new SchemeTonalSpot(color, isDark, contrastLevel),
                   new SchemeVibrant(color, isDark, contrastLevel),
      ]) {
        schemes.push(scheme);
      }
    }
  }
}

describe('DynamicColor', () => {
  // Parametric test, ensuring that dynamic schemes respect contrast
  // between text-surface pairs.

  it('generates colors respecting contrast', () => {
    for (const scheme of schemes) {
      for (const pair of textSurfacePairs) {
        // Expect that each text-surface pair has a
        // minimum contrast of 4.5 (unreduced contrast), or 3.0
        // (reduced contrast).
        const fgName = pair.fgName;
        const bgName = pair.bgName;
        const foregroundTone = colorByName.get(fgName)!.getHct(scheme).tone;
        const backgroundTone = colorByName.get(bgName)!.getHct(scheme).tone;
        const contrast = Contrast.ratioOfTones(foregroundTone, backgroundTone);

        const minimumRequirement = scheme.contrastLevel >= 0.0 ? 4.5 : 3.0;

        if (contrast < minimumRequirement) {
          fail(`${fgName} on ${bgName} is ${contrast}, needed ${
              minimumRequirement}`);
        }
      }
    }
  });

  it('constraint conformance test', () => {
    /*
      Tone delta pair:
      [A, B, delta, "lighter"] = A is lighter than B by delta
      [A, B, delta, "darker"] = A is darker than B by delta
      [A, B, delta, "farther"] = A is farther (from + surfaces) than B by delta
                              = [A, B, delta, "darker"] in light
                              = [A, B, delta, "lighter"] in dark
      [A, B, delta, "nearer"] = A is nearer (to + surfaces) than B by delta
                              = [A, B, delta, "lighter"] in light
                              = [A, B, delta, "darker"] in dark
    */
    const limitingSurfaces = [
      'surface_dim',
      'surface_bright',
    ];

    const constraints = [
      // Contrast constraints, as defined in the spec.
      //
      // If "respectively" is set to true, the constraint is tested against
      // every pair of __corresponding__ foreground and background;
      // otherwise, the constraint is tested against every possible pair
      // of foreground and background.
      //
      // In other words, if "respectively" is true, "fore" and "back" must
      // have equal length N, and there will be N comparisons.
      // If "respectively" is false, "fore" has length M, and "back" has length
      // N, then there will be (M * N) comparisons.
      //
      // Surface contrast constraints.
      {
        kind: 'Contrast',
        values: new ContrastCurve(4.5, 7, 11, 21),
        fore: ['on_surface'],
        back: limitingSurfaces,
      },
      {
        kind: 'Contrast',
        values: new ContrastCurve(3, 4.5, 7, 11),
        fore: ['on_surface_variant'],
        back: limitingSurfaces,
      },
      {
        kind: 'Contrast',
        values: new ContrastCurve(3, 4.5, 7, 7),
        fore: ['primary', 'secondary', 'tertiary', 'error'],
        back: limitingSurfaces,
      },
      {
        kind: 'Contrast',
        values: new ContrastCurve(1.5, 3, 4.5, 7),
        fore: ['outline'],
        back: limitingSurfaces,
      },
      {
        kind: 'Contrast',
        values: new ContrastCurve(0, 0, 3, 4.5),
        fore: [
          'primary_container',
          'primary_fixed',
          'primary_fixed_dim',
          'secondary_container',
          'secondary_fixed',
          'secondary_fixed_dim',
          'tertiary_container',
          'tertiary_fixed',
          'tertiary_fixed_dim',
          'error_container',
          'outline_variant',
        ],
        back: limitingSurfaces,
      },
      {
        kind: 'Contrast',
        values: new ContrastCurve(4.5, 7, 11, 21),
        fore: ['inverse_on_surface'],
        back: ['inverse_surface'],
      },
      {
        kind: 'Contrast',
        values: new ContrastCurve(3, 4.5, 7, 7),
        fore: ['inverse_primary'],
        back: ['inverse_surface'],
      },

      // Accent contrast constraints.
      {
        kind: 'Contrast',
        respectively: true,
        values: new ContrastCurve(4.5, 7, 11, 21),
        fore: [
          'on_primary',
          'on_secondary',
          'on_tertiary',
          'on_error',
          'on_primary_container',
          'on_secondary_container',
          'on_tertiary_container',
          'on_error_container',
        ],
        back: [
          'primary',
          'secondary',
          'tertiary',
          'error',
          'primary_container',
          'secondary_container',
          'tertiary_container',
          'error_container',
        ],
      },
      {
        kind: 'Contrast',
        values: new ContrastCurve(4.5, 7, 11, 21),
        fore: ['on_primary_fixed'],
        back: ['primary_fixed', 'primary_fixed_dim'],
      },
      {
        kind: 'Contrast',
        values: new ContrastCurve(4.5, 7, 11, 21),
        fore: ['on_secondary_fixed'],
        back: ['secondary_fixed', 'secondary_fixed_dim'],
      },
      {
        kind: 'Contrast',
        values: new ContrastCurve(4.5, 7, 11, 21),
        fore: ['on_tertiary_fixed'],
        back: ['tertiary_fixed', 'tertiary_fixed_dim'],
      },
      {
        kind: 'Contrast',
        values: new ContrastCurve(3, 4.5, 7, 11),
        fore: ['on_primary_fixed_variant'],
        back: ['primary_fixed', 'primary_fixed_dim'],
      },
      {
        kind: 'Contrast',
        values: new ContrastCurve(3, 4.5, 7, 11),
        fore: ['on_secondary_fixed_variant'],
        back: ['secondary_fixed', 'secondary_fixed_dim'],
      },
      {
        kind: 'Contrast',
        values: new ContrastCurve(3, 4.5, 7, 11),
        fore: ['on_tertiary_fixed_variant'],
        back: ['tertiary_fixed', 'tertiary_fixed_dim'],
      },

      // Delta constraints.
      {
        kind: 'Delta',
        delta: 10,
        respectively: true,
        fore: [
          'primary',
          'secondary',
          'tertiary',
          'error',
        ],
        back: [
          'primary_container',
          'secondary_container',
          'tertiary_container',
          'error_container',
        ],
        polarity: 'farther',
      },
      {
        kind: 'Delta',
        delta: 10,
        respectively: true,
        fore: [
          'primary_fixed_dim',
          'secondary_fixed_dim',
          'tertiary_fixed_dim',
        ],
        back: [
          'primary_fixed',
          'secondary_fixed',
          'tertiary_fixed',
        ],
        polarity: 'darker',
      },

      // Background constraints.
      {
        kind: 'Background',
        objects: [
          'background',
          'error',
          'error_container',
          'primary',
          'primary_container',
          'primary_fixed',
          'primary_fixed_dim',
          'secondary',
          'secondary_container',
          'secondary_fixed',
          'secondary_fixed_dim',
          'surface',
          'surface_bright',
          'surface_container',
          'surface_container_high',
          'surface_container_highest',
          'surface_container_low',
          'surface_container_lowest',
          'surface_dim',
          'surface_tint',
          'surface_variant',
          'tertiary',
          'tertiary_container',
          'tertiary_fixed',
          'tertiary_fixed_dim',
        ],
      }
    ];

    for (const scheme of schemes) {
      const prec = 2;

      const resolvedColors = new Map(
          colors.map((color) => [color.name, color.getArgb(scheme)]),
      );

      for (const cstr of constraints) {
        if (cstr.kind === 'Contrast') {
          const contrastTolerance = 0.05;

          const minRequirement =
              getMinRequirement(cstr.values!, scheme.contrastLevel);
          const respectively = cstr.respectively ?? false;
          const pairs = getPairs(respectively, cstr.fore!, cstr.back!);
          // Check each pair
          for (const pair of pairs) {
            const [fore, back] = pair;
            const ftone = colorUtils.lstarFromArgb(resolvedColors.get(fore)!);
            const btone = colorUtils.lstarFromArgb(resolvedColors.get(back)!);
            const contrast = Contrast.ratioOfTones(ftone, btone);

            // It's failing only if:
            //     A minimum requirement of 4.5 or lower is not reached
            //     A minimum requirement of >4.5 is not reached, while
            //     some colors are not B or White yet.
            const failing = (minRequirement <= 4.5) ?
                (contrast < minRequirement - contrastTolerance) :
                (ftone !== 0 && btone !== 0 && ftone !== 100 && btone !== 100 &&
                 contrast < minRequirement - contrastTolerance);

            if (contrast < minRequirement - contrastTolerance &&
                minRequirement <= 4.5) {
              // Real fail.
              fail(`Contrast ${fore} ${ftone.toFixed(prec)} ${back} ${
                  btone.toFixed(
                      prec)} ${contrast.toFixed(prec)} ${minRequirement} `);
            }
            if (failing && minRequirement > 4.5) {
              fail(`Contrast(stretch-goal) ${fore} ${ftone.toFixed(prec)} ${
                  back} ${btone.toFixed(prec)} ${contrast.toFixed(prec)} ${
                  minRequirement} `);
            }
          }
        } else if (cstr.kind === 'Delta') {
          // Verifies that the two colors satisfy the required
          // tone delta constraint.
          const respectively = cstr.respectively ?? false;
          const pairs = getPairs(respectively, cstr.fore!, cstr.back!);
          const polarity = cstr.polarity;
          expect(
              polarity === 'nearer' || polarity === 'farther' ||
              polarity === 'lighter' || polarity === 'darker')
              .toBeTrue();
          for (const pair of pairs) {
            const [fore, back] = pair;
            const ftone = colorUtils.lstarFromArgb(resolvedColors.get(fore)!);
            const btone = colorUtils.lstarFromArgb(resolvedColors.get(back)!);

            const isLighter =
                (polarity === 'lighter' ||
                 (polarity === 'nearer' && !scheme.isDark) ||
                 (polarity === 'farther' && scheme.isDark));

            const observedDelta = isLighter ? ftone - btone : btone - ftone;

            if (observedDelta < cstr.delta! - 0.5 /* lenient */) {
              // Failing
              fail(`Delta ${fore} ${ftone.toFixed(prec)} ${back} ${
                  btone.toFixed(
                      prec)} ${observedDelta.toFixed(prec)} ${cstr.delta}`);
            }
          }
        } else if (cstr.kind === 'Background') {
          // Verifies that none of the background tones are in the
          // "awkward zone" from 50 to 60.
          for (const bg of cstr.objects!) {
            const bgtone = colorUtils.lstarFromArgb(resolvedColors.get(bg)!);
            if (bgtone >= 50.5 && bgtone < 59.5 /* lenient */) {
              // Failing
              fail(`Background ${bg} ${bgtone.toFixed(prec)}`);
            }
          }
        } else {
          fail(`Bad constraint kind = ${cstr.kind}`);
        }
      }
    }
  });
});
