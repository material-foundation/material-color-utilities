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

import 'dart:math' as math;

import 'package:material_color_utilities/contrast/contrast.dart';
import 'package:material_color_utilities/hct/hct.dart';
import 'package:material_color_utilities/palettes/tonal_palette.dart';
import 'package:material_color_utilities/scheme/dynamic_scheme.dart';
import 'package:material_color_utilities/utils/math_utils.dart';

import 'src/tone_delta_constraint.dart';

/// A color that adjusts itself based on UI state provided by [DynamicScheme].
///
/// This color automatically adjusts to accommodate a desired contrast level, or
/// other adjustments such as differing in light mode versus dark mode, or what
/// the theme is, or what the color that produced the theme is, etc.
///
/// Colors without backgrounds do not change tone when contrast changes. Colors
/// with backgrounds become closer to their background as contrast lowers, and
/// further when contrast increases.
///
/// Prefer the static constructors. They provide a much more simple interface,
/// such as requiring just a hexcode, or just a hexcode and a background.
///
/// Ultimately, each component necessary for calculating a color, adjusting it
/// for a desired contrast level, and ensuring it has a certain lightness/tone
/// difference from another color, is provided by a function that takes a
/// [DynamicScheme] and returns a value. This ensures ultimate flexibility, any
/// desired behavior of a color for any design system, but it usually
/// unnecessary. See the default constructor for more information.
class DynamicColor {
  final double Function(DynamicScheme) hue;
  final double Function(DynamicScheme) chroma;
  final double Function(DynamicScheme) tone;

  final DynamicColor? Function(DynamicScheme) background;
  final double Function(DynamicScheme) toneMinContrast;
  final double Function(DynamicScheme) toneMaxContrast;
  final ToneDeltaConstraint Function(DynamicScheme)? toneDeltaConstraint;

  final Map<DynamicScheme, Hct> _hctCache = {};

  /// The base constructor for DynamicColor.
  ///
  /// _Strongly_ prefer using one of the convenience constructors. This class is
  /// arguably too flexible to ensure it can support any scenario. Functional
  /// arguments allow  overriding without risks that come with subclasses.
  ///
  /// For example, the default behavior of adjust tone at max contrast
  /// to be at a 7.0 ratio with its background is principled and
  /// matches accessibility guidance. That does not mean it's the desired
  /// approach for _every_ design system, and every color pairing,
  /// always, in every case.
  ///
  /// [hue] given [DynamicScheme], return the hue in HCT of the output
  /// color.
  /// [chroma] given [DynamicScheme], return chroma in HCT of the output
  /// color.
  /// [tone] given [DynamicScheme], return tone in HCT of the output color.
  /// [background] given [DynamicScheme], return the [DynamicColor] that is
  /// the background of this [DynamicColor]. When this is provided,
  /// automated adjustments to lower and raise contrast are made.
  /// [toneMinContrast] given [DynamicScheme], return tone in HCT this color
  /// should be at minimum contrast. See toneMinContrastDefault for the default
  /// behavior, and strongly consider using it unless you have strong opinions
  /// on color and accessibility. The convenience constructors use it.
  /// [toneMaxContrast] given [DynamicScheme], return tone in HCT this color
  /// should be at maximum contrast. See toneMaxContrastDefault for the default
  /// behavior, and strongly consider using it unless you have strong opinions
  /// on color and accessibility. The convenience constructors use it.
  /// [toneDeltaConstraint] given [DynamicScheme], return a
  /// [ToneDeltaConstraint] that describes a requirement that this
  /// [DynamicColor] must always have some difference in tone from another
  /// [DynamicColor].
  ///
  /// Unlikely to be useful unless a design system has some distortions
  /// where colors that don't have a background/foreground relationship
  /// don't want to have a formal relationship or a principled value for their
  /// tone distance based on common contrast / tone delta values, yet, want
  /// tone distance.
  DynamicColor({
    required this.hue,
    required this.chroma,
    required this.tone,
    required this.background,
    required this.toneMinContrast,
    required this.toneMaxContrast,
    required this.toneDeltaConstraint,
  });

  /// Create a [DynamicColor].
  ///
  /// [palette] Function that provides a TonalPalette given [DynamicScheme]. A
  /// TonalPalette is defined by a hue and chroma, so this replaces the
  /// need to specify hue/chroma. By providing a tonal palette, when
  /// contrast adjustments are made, intended chroma can be preserved.
  /// [tone] Function that provides a tone given [DynamicScheme]. (useful
  /// for dark vs. light mode)
  /// [background] Function that provides background [DynamicColor] given
  /// [DynamicScheme]. Useful for contrast, given a background, colors
  /// can adjust to increase/decrease contrast.
  /// [toneDeltaConstraint] Function that provides a ToneDeltaConstraint
  /// given [DynamicScheme]. Useful for ensuring lightness difference
  /// between colors that don't _require_ contrast or have a formal
  /// background/foreground relationship.
  factory DynamicColor.fromPalette({
    required TonalPalette Function(DynamicScheme) palette,
    required double Function(DynamicScheme) tone,
    DynamicColor? Function(DynamicScheme)? background,
    ToneDeltaConstraint Function(DynamicScheme)? toneDeltaConstraint,
  }) {
    return DynamicColor(
      background: (scheme) => background?.call(scheme),
      hue: (scheme) => palette(scheme).hue,
      chroma: (scheme) => palette(scheme).chroma,
      toneDeltaConstraint: toneDeltaConstraint,
      tone: tone,
      toneMinContrast: (scheme) =>
          toneMinContrastDefault(tone, background, scheme, toneDeltaConstraint),
      toneMaxContrast: (scheme) =>
          toneMaxContrastDefault(tone, background, scheme, toneDeltaConstraint),
    );
  }

  /// Return a ARGB integer (i.e. a hex code).

  /// [scheme] Defines the conditions of the user interface, for example,
  /// whether or not it is dark mode or light mode, and what the desired
  /// contrast level is.
  int getArgb(DynamicScheme scheme) {
    return getHct(scheme).toInt();
  }

  /// Return a color, expressed in the HCT color space, that this
  /// [DynamicColor] is under the conditions in [scheme].
  ///
  /// [scheme] Defines the conditions of the user interface, for example,
  /// whether or not it is dark mode or light mode, and what the desired
  /// contrast level is.
  Hct getHct(DynamicScheme scheme) {
    final cachedAnswer = _hctCache[scheme];
    if (cachedAnswer != null) {
      return cachedAnswer;
    }
    final answer = Hct.from(hue(scheme), chroma(scheme), getTone(scheme));
    if (_hctCache.length > 4) {
      _hctCache.clear();
    }
    _hctCache[scheme] = answer;
    return answer;
  }

  /// Return a tone, T in the HCT color space, that this [DynamicColor] is under
  /// the conditions in [scheme].
  ///
  /// [scheme] Defines the conditions of the user interface, for example,
  /// whether or not it is dark mode or light mode, and what the desired
  /// contrast level is.
  double getTone(DynamicScheme scheme) {
    var answer = tone(scheme);
    final decreasingContrast = scheme.contrastLevel < 0.0;
    if (scheme.contrastLevel != 0.0) {
      final double startTone = tone(scheme);
      final double endTone = decreasingContrast
          ? toneMinContrast(scheme)
          : toneMaxContrast(scheme);
      final delta = (endTone - startTone) * scheme.contrastLevel.abs();
      answer = delta + startTone;
    }

    final bg = background(scheme);
    double? standardRatio;
    double? minRatio;
    double? maxRatio;
    if (bg != null) {
      final bgHasBg = bg.background(scheme) != null;
      standardRatio = Contrast.ratioOfTones(tone(scheme), bg.tone(scheme));
      if (decreasingContrast) {
        final minContrastRatio = Contrast.ratioOfTones(
            toneMinContrast(scheme), bg.toneMinContrast(scheme));
        minRatio = bgHasBg ? minContrastRatio : null;
        maxRatio = standardRatio;
      } else {
        final maxContrastRatio = Contrast.ratioOfTones(
            toneMaxContrast(scheme), bg.toneMaxContrast(scheme));
        minRatio = bgHasBg ? math.min(maxContrastRatio, standardRatio) : null;
        maxRatio = bgHasBg ? math.max(maxContrastRatio, standardRatio) : null;
      }
    }

    answer = calculateDynamicTone(
      scheme: scheme,
      toneStandard: tone,
      toneToJudge: (c) => c.getTone(scheme),
      desiredTone: (_, __) => answer,
      minRatio: (_) => minRatio ?? 1.0,
      maxRatio: (_) => maxRatio ?? 21.0,
      background: (_) => bg,
      constraint: toneDeltaConstraint,
    );

    return answer;
  }

  /// The default algorithm for calculating the tone of a color at minimum
  /// contrast.
  ///
  /// If the original contrast ratio was >= 7.0, reach contrast 4.5.
  /// If the original contrast ratio was >= 3.0, reach contrast 3.0.
  /// If the original contrast ratio was < 3.0, reach that ratio.
  static double toneMinContrastDefault(
      double Function(DynamicScheme) tone,
      DynamicColor? Function(DynamicScheme)? background,
      DynamicScheme scheme,
      ToneDeltaConstraint Function(DynamicScheme)? toneDeltaConstraint) {
    return DynamicColor.calculateDynamicTone(
      scheme: scheme,
      toneStandard: tone,
      toneToJudge: (c) => c.toneMinContrast(scheme),
      desiredTone: (stdRatio, bgTone) {
        var answer = tone(scheme);
        if (stdRatio >= 7.0) {
          answer = foregroundTone(bgTone, 4.5);
        } else if (stdRatio >= 3.0) {
          answer = foregroundTone(bgTone, 3.0);
        } else {
          final backgroundHasBackground =
              background?.call(scheme)?.background(scheme) != null;
          if (backgroundHasBackground) {
            answer = foregroundTone(bgTone, stdRatio);
          }
        }
        return answer;
      },
      background: background,
      constraint: toneDeltaConstraint,
      minRatio: null,
      maxRatio: (standardRatio) => standardRatio,
    );
  }

  /// The default algorithm for calculating the tone of a color at
  /// maximum contrast.
  ///
  /// If the color's background has a background, reach contrast
  /// 7.0.
  /// If it doesn't, maintain the original contrast ratio.
  ///
  /// This ensures text on surfaces maintains its original, often
  /// detrimentally excessive, contrast ratio. But, text on buttons
  /// can soften to not have excessive contrast.
  ///
  /// Historically, digital design uses pure whites and black for
  /// text and surfaces. It's too much of a jump at this point in
  /// history to introduce a dynamic contrast system _and_ insist
  /// that text always had excessive contrast and should reach 7.0,
  /// it would deterimentally affect desire to understand and use
  /// dynamic contrast.
  static double toneMaxContrastDefault(
      double Function(DynamicScheme) tone,
      DynamicColor? Function(DynamicScheme)? background,
      DynamicScheme scheme,
      ToneDeltaConstraint Function(DynamicScheme)? toneDeltaConstraint) {
    return DynamicColor.calculateDynamicTone(
      scheme: scheme,
      toneStandard: tone,
      toneToJudge: (c) => c.toneMaxContrast(scheme),
      desiredTone: (stdRatio, bgTone) {
        final backgroundHasBackground =
            background?.call(scheme)?.background(scheme) != null;
        if (backgroundHasBackground) {
          return foregroundTone(bgTone, 7.0);
        } else {
          return foregroundTone(bgTone, math.max(7.0, stdRatio));
        }
      },
      background: background,
      constraint: toneDeltaConstraint,
      minRatio: null,
      maxRatio: null,
    );
  }

  /// Core method for calculating a tone for under dynamic contrast.
  ///
  /// It enforces important properties:
  /// #1. Desired contrast ratio is reached.
  /// As contrast increases from standard to max, the tones involved should
  /// always be at least the standard ratio. For example, if a button is T90,
  /// and button text is T0, and the button is T0 at max contrast, the button
  /// text cannot simply linearly interpolate from T0 to T100, or at some point
  /// they'll both be at the same tone.
  /// #2. Enable light foregrounds on midtones.
  /// The eye prefers light foregrounds on T50 to T60, possibly up to T70, but,
  /// contrast ratio 4.5 can't be reached with T100 unless the foreground is
  /// T50. Contrast ratio 4.5 is crucial, it represents 'readable text', i.e.
  /// text smaller than ~40 dp / 1/4". So, if a tone is between T50 and T60, it
  /// is proactively changed to T49 to enable light foregrounds.
  /// #3. Ensure tone delta with another color.
  /// In design systems, there may be colors without a background/foreground
  /// relationship that require different tones for visual differentiation.
  /// [ToneDeltaConstraint] models this requirement, and [DynamicColor]
  /// enforces it.
  static double calculateDynamicTone({
    required DynamicScheme scheme,
    required double Function(DynamicScheme) toneStandard,
    required double Function(DynamicColor) toneToJudge,
    required double Function(double standardRatio, double bgTone) desiredTone,
    required DynamicColor? Function(DynamicScheme)? background,
    required ToneDeltaConstraint Function(DynamicScheme)? constraint,
    required double Function(double standardRatio)? minRatio,
    required double Function(double standardRatio)? maxRatio,
  }) {
    // Start with the tone with no adjustment for contrast.
    // If there is no background, don't perform any adjustment, return immediately.
    final toneStd = toneStandard(scheme);
    var answer = toneStd;
    final bgDynamic = background?.call(scheme);
    if (bgDynamic == null) {
      return answer;
    }
    final bgToneStd = bgDynamic.tone(scheme);
    final stdRatio = Contrast.ratioOfTones(toneStd, bgToneStd);

    // If there is a background, determine its tone after contrast adjustment.
    // Then, calculate the foreground tone that ensures the caller's desired contrast ratio is met.
    final bgTone = toneToJudge(bgDynamic);
    final myDesiredTone = desiredTone(stdRatio, bgTone);
    final currentRatio = Contrast.ratioOfTones(bgTone, myDesiredTone);
    final desiredRatio = MathUtils.clampDouble(minRatio?.call(stdRatio) ?? 1.0,
        maxRatio?.call(stdRatio) ?? 21.0, currentRatio);
    if (desiredRatio == currentRatio) {
      answer = myDesiredTone;
    } else {
      answer = DynamicColor.foregroundTone(bgTone, desiredRatio);
    }

    // If the background has no background,  adjust the foreground tone to
    // ensure that it is dark enough to have a light foreground.
    if (bgDynamic.background(scheme) == null) {
      answer = DynamicColor.enableLightForeground(answer);
    }

    // If the caller has specified a constraint where it must have a certain
    // tone distance from another color, enforce that constraint.
    answer = ensureToneDelta(
      tone: answer,
      toneStandard: toneStd,
      scheme: scheme,
      constraintProvider: constraint,
      toneToDistanceFrom: (c) => toneToJudge(c),
    );

    return answer;
  }

  /// Enforce a [ToneDeltaConstraint] between two [DynamicColor]s.
  ///
  /// [tone] the desired tone of the color.
  /// [toneStandard] the tone of the color at standard contrast.
  /// [scheme] Defines the conditions of the user interface, for example,
  /// whether or not it is dark mode or light mode, and what the desired
  /// contrast level is.
  /// [constraintProvider] Given a [DynamicScheme], return a
  /// [ToneDeltaConstraint] or null.
  /// [toneToDistanceFrom] Given a [DynamicColor], return a tone that the
  /// [ToneDeltaConstraint] should enforce a delta from.
  static double ensureToneDelta({
    required double tone,
    required double toneStandard,
    required DynamicScheme scheme,
    required ToneDeltaConstraint? Function(DynamicScheme)? constraintProvider,
    required Function(DynamicColor) toneToDistanceFrom,
  }) {
    final constraint = constraintProvider?.call(scheme);
    if (constraint == null) {
      return tone;
    }

    final requiredDelta = constraint.delta;
    final keepAwayTone = toneToDistanceFrom(constraint.keepAway);
    final delta = (tone - keepAwayTone).abs();
    if (delta > requiredDelta) {
      return tone;
    }
    switch (constraint.keepAwayPolarity) {
      case TonePolarity.darker:
        return MathUtils.clampDouble(0, 100, keepAwayTone + requiredDelta);
      case TonePolarity.lighter:
        return MathUtils.clampDouble(0, 100, keepAwayTone - requiredDelta);

      case TonePolarity.noPreference:
        final keepAwayToneStandard = constraint.keepAway.tone(scheme);
        final preferLighten = toneStandard > keepAwayToneStandard;
        final alterAmount = (delta - requiredDelta).abs();
        final lighten =
            preferLighten ? (tone + alterAmount <= 100.0) : tone < alterAmount;
        return lighten ? tone + alterAmount : tone - alterAmount;
    }
  }

  /// Given a background tone, find a foreground tone, while ensuring they reach
  /// a contrast ratio that is as close to [ratio] as possible.
  ///
  /// [bgTone] Tone in HCT. Range is 0 to 100, undefined behavior when it falls
  /// outside that range.
  /// [ratio] The contrast ratio desired between [bgTone] and the return value.
  static double foregroundTone(double bgTone, double ratio) {
    final lighterTone = Contrast.lighterUnsafe(tone: bgTone, ratio: ratio);
    final darkerTone = Contrast.darkerUnsafe(tone: bgTone, ratio: ratio);
    final lighterRatio = Contrast.ratioOfTones(lighterTone, bgTone);
    final darkerRatio = Contrast.ratioOfTones(darkerTone, bgTone);
    final preferLighter = tonePrefersLightForeground(bgTone);

    if (preferLighter) {
      // This handles an edge case where the initial contrast ratio is high
      // (ex. 13.0), and the ratio passed to the function is that high ratio,
      // and both the lighter and darker ratio fails to pass that ratio.
      //
      // This was observed with Tonal Spot's On Primary Container turning black
      // momentarily between high and max contrast in light mode.
      // PC's standard tone was T90, OPC's was T10, it was light mode, and the
      // contrast value was 0.6568521221032331.
      final negligibleDifference = ((lighterRatio - darkerRatio).abs() < 0.1 &&
          lighterRatio < ratio &&
          darkerRatio < ratio);
      return lighterRatio >= ratio ||
              lighterRatio >= darkerRatio ||
              negligibleDifference
          ? lighterTone
          : darkerTone;
    } else {
      return darkerRatio >= ratio || darkerRatio >= lighterRatio
          ? darkerTone
          : lighterTone;
    }
  }

  /// Adjust a tone such that white has 4.5 contrast, if the tone is
  /// reasonably close to supporting it.
  static double enableLightForeground(double tone) {
    if (tonePrefersLightForeground(tone) && !toneAllowsLightForeground(tone)) {
      return 49.0;
    }
    return tone;
  }

  /// Returns whether [tone] prefers a light foreground.
  ///
  /// People prefer white foregrounds on ~T60-70. Observed over time, and also
  /// by Andrew Somers during research for APCA.
  ///
  /// T60 used as to create the smallest discontinuity possible when skipping
  /// down to T49 in order to ensure light foregrounds.
  ///
  /// Since `tertiaryContainer` in dark monochrome scheme requires a tone of
  /// 60, it should not be adjusted. Therefore, 60 is excluded here.
  static bool tonePrefersLightForeground(double tone) {
    return tone.round() < 60;
  }

  /// Returns whether [tone] can reach a contrast ratio of 4.5 with a lighter
  /// color.
  static bool toneAllowsLightForeground(double tone) {
    return tone.round() <= 49;
  }
}
