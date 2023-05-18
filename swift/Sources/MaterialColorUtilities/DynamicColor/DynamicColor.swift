// Copyright 2023 Google LLC
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

import Foundation

typealias DynamicSchemeValue<T> = (DynamicScheme) -> T

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
  let hue: DynamicSchemeValue<Double>
  let chroma: DynamicSchemeValue<Double>
  let tone: DynamicSchemeValue<Double>

  let background: DynamicSchemeValue<DynamicColor?>
  let toneMinContrast: DynamicSchemeValue<Double>
  let toneMaxContrast: DynamicSchemeValue<Double>
  let toneDeltaConstraint: DynamicSchemeValue<ToneDeltaConstraint>?

  private var _hctCache: [DynamicScheme: Hct] = [:]

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
  init(
    hue: @escaping DynamicSchemeValue<Double>, chroma: @escaping DynamicSchemeValue<Double>,
    tone: @escaping DynamicSchemeValue<Double>,
    background: @escaping DynamicSchemeValue<DynamicColor?>,
    toneMinContrast: @escaping DynamicSchemeValue<Double>,
    toneMaxContrast: @escaping DynamicSchemeValue<Double>,
    toneDeltaConstraint: DynamicSchemeValue<ToneDeltaConstraint>? = nil
  ) {
    self.hue = hue
    self.chroma = chroma
    self.tone = tone
    self.background = background
    self.toneMinContrast = toneMinContrast
    self.toneMaxContrast = toneMaxContrast
    self.toneDeltaConstraint = toneDeltaConstraint
  }

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
  static func fromPalette(
    palette: @escaping DynamicSchemeValue<TonalPalette>,
    tone: @escaping DynamicSchemeValue<Double>,
    background: DynamicSchemeValue<DynamicColor?>? = nil,
    toneDeltaConstraint: DynamicSchemeValue<ToneDeltaConstraint>? = nil
  ) -> DynamicColor {
    return DynamicColor(
      hue: { scheme in
        return palette(scheme).hue
      },
      chroma: { scheme in
        return palette(scheme).chroma
      },
      tone: tone,
      background: { scheme in
        return background?(scheme)
      },
      toneMinContrast: { scheme in
        return toneMinContrastDefault(tone, background, scheme, toneDeltaConstraint)
      },
      toneMaxContrast: { scheme in
        return toneMaxContrastDefault(tone, background, scheme, toneDeltaConstraint)
      },
      toneDeltaConstraint: toneDeltaConstraint
    )
  }

  /// Return a ARGB integer (i.e. a hex code).
  ///
  /// [scheme] Defines the conditions of the user interface, for example,
  /// whether or not it is dark mode or light mode, and what the desired
  /// contrast level is.
  func getArgb(_ scheme: DynamicScheme) -> Int {
    return getHct(scheme).toInt()
  }

  /// Return a color, expressed in the HCT color space, that this
  /// [DynamicColor] is under the conditions in [scheme].
  ///
  /// [scheme] Defines the conditions of the user interface, for example,
  /// whether or not it is dark mode or light mode, and what the desired
  /// contrast level is.
  func getHct(_ scheme: DynamicScheme) -> Hct {
    let cachedAnswer = _hctCache[scheme]
    if cachedAnswer != nil {
      return cachedAnswer!
    }
    let answer = Hct.from(hue(scheme), chroma(scheme), getTone(scheme))
    if _hctCache.count > 4 {
      _hctCache.removeAll()
    }
    _hctCache[scheme] = answer
    return answer
  }

  /// Return a tone, T in the HCT color space, that this [DynamicColor] is under
  /// the conditions in [scheme].
  ///
  /// [scheme] Defines the conditions of the user interface, for example,
  /// whether or not it is dark mode or light mode, and what the desired
  /// contrast level is.
  func getTone(_ scheme: DynamicScheme) -> Double {
    var answer = tone(scheme)
    let decreasingContrast = scheme.contrastLevel < 0
    if scheme.contrastLevel != 0 {
      let startTone = tone(scheme)
      let endTone = decreasingContrast ? toneMinContrast(scheme) : toneMaxContrast(scheme)
      let delta = (endTone - startTone) * abs(scheme.contrastLevel)
      answer = delta + startTone
    }

    let bg = background(scheme)
    var standardRatio: Double?
    var minRatio: Double?
    var maxRatio: Double?
    if bg != nil {
      let bgHasBg = bg!.background(scheme) != nil
      standardRatio = Contrast.ratioOfTones(tone(scheme), bg!.tone(scheme))
      if decreasingContrast {
        let minContrastRatio = Contrast.ratioOfTones(
          toneMinContrast(scheme), bg!.toneMinContrast(scheme))
        minRatio = bgHasBg ? minContrastRatio : nil
        maxRatio = standardRatio
      } else {
        let maxContrastRatio = Contrast.ratioOfTones(
          toneMaxContrast(scheme), bg!.toneMaxContrast(scheme))
        minRatio = bgHasBg ? min(maxContrastRatio, standardRatio!) : nil
        maxRatio = bgHasBg ? max(maxContrastRatio, standardRatio!) : nil
      }
    }

    answer = DynamicColor.calculateDynamicTone(
      scheme: scheme,
      toneStandard: tone,
      toneToJudge: { c in
        return c.getTone(scheme)
      },
      desiredTone: { _, __ in
        return answer
      },
      background: { _ in
        return bg
      },
      constraint: toneDeltaConstraint,
      minRatio: { _ in
        return minRatio ?? 1
      },
      maxRatio: { _ in
        return maxRatio ?? 21
      }
    )

    return answer
  }

  /// The default algorithm for calculating the tone of a color at minimum
  /// contrast.
  ///
  /// If the original contrast ratio was >= 7.0, reach contrast 4.5.
  /// If the original contrast ratio was >= 3.0, reach contrast 3.0.
  /// If the original contrast ratio was < 3.0, reach that ratio.
  static func toneMinContrastDefault(
    _ tone: DynamicSchemeValue<Double>,
    _ background: DynamicSchemeValue<DynamicColor?>?,
    _ scheme: DynamicScheme,
    _ toneDeltaConstraint: DynamicSchemeValue<ToneDeltaConstraint>?
  ) -> Double {
    return DynamicColor.calculateDynamicTone(
      scheme: scheme,
      toneStandard: tone,
      toneToJudge: { c in
        return c.toneMinContrast(scheme)
      },
      desiredTone: { stdRatio, bgTone in
        var answer = tone(scheme)
        if stdRatio >= 7 {
          answer = foregroundTone(bgTone, 4.5)
        } else if stdRatio >= 3 {
          answer = foregroundTone(bgTone, 3)
        } else {
          let backgroundHasBackground = background?(scheme)?.background(scheme) != nil
          if backgroundHasBackground {
            answer = foregroundTone(bgTone, stdRatio)
          }
        }
        return answer
      },
      background: background,
      constraint: toneDeltaConstraint,
      minRatio: nil,
      maxRatio: { standardRatio in
        return standardRatio
      }
    )
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
  static func toneMaxContrastDefault(
    _ tone: DynamicSchemeValue<Double>,
    _ background: DynamicSchemeValue<DynamicColor?>?,
    _ scheme: DynamicScheme,
    _ toneDeltaConstraint: DynamicSchemeValue<ToneDeltaConstraint>?
  ) -> Double {
    return DynamicColor.calculateDynamicTone(
      scheme: scheme,
      toneStandard: tone,
      toneToJudge: { c in
        return c.toneMaxContrast(scheme)
      },
      desiredTone: { stdRatio, bgTone in
        let backgroundHasBackground = background?(scheme)?.background(scheme) != nil
        if backgroundHasBackground {
          return foregroundTone(bgTone, 7)
        } else {
          return foregroundTone(bgTone, max(7, stdRatio))
        }
      },
      background: background,
      constraint: toneDeltaConstraint,
      minRatio: nil,
      maxRatio: nil
    )
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
  static func calculateDynamicTone(
    scheme: DynamicScheme,
    toneStandard: DynamicSchemeValue<Double>,
    toneToJudge: (DynamicColor) -> Double,
    desiredTone: (_ standardRatio: Double, _ bgTone: Double) -> Double,
    background: DynamicSchemeValue<DynamicColor?>? = nil,
    constraint: DynamicSchemeValue<ToneDeltaConstraint>? = nil,
    minRatio: ((_ standardRatio: Double) -> Double)? = nil,
    maxRatio: ((_ standardRatio: Double) -> Double)? = nil
  ) -> Double {
    // Start with the tone with no adjustment for contrast.
    // If there is no background, don't perform any adjustment, return immediately.
    let toneStd = toneStandard(scheme)
    var answer = toneStd
    let bgDynamic = background?(scheme)
    if bgDynamic == nil {
      return answer
    }
    let bgToneStd = bgDynamic!.tone(scheme)
    let stdRatio = Contrast.ratioOfTones(toneStd, bgToneStd)

    // If there is a background, determine its tone after contrast adjustment.
    // Then, calculate the foreground tone that ensures the caller's desired contrast ratio is met.
    let bgTone = toneToJudge(bgDynamic!)
    let myDesiredTone = desiredTone(stdRatio, bgTone)
    let currentRatio = Contrast.ratioOfTones(bgTone, myDesiredTone)
    let desiredRatio = MathUtils.clampDouble(
      minRatio?(stdRatio) ?? 1, maxRatio?(stdRatio) ?? 21, currentRatio)
    if desiredRatio == currentRatio {
      answer = myDesiredTone
    } else {
      answer = DynamicColor.foregroundTone(bgTone, desiredRatio)
    }

    // If the background has no background,  adjust the foreground tone to
    // ensure that it is dark enough to have a light foreground.
    if bgDynamic!.background(scheme) == nil {
      answer = DynamicColor.enableLightForeground(answer)
    }

    // If the caller has specified a constraint where it must have a certain
    // tone distance from another color, enforce that constraint.
    answer = ensureToneDelta(
      tone: answer,
      toneStandard: toneStd,
      scheme: scheme,
      constraintProvider: constraint,
      toneToDistanceFrom: { c in
        return toneToJudge(c)
      }
    )

    return answer
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
  static func ensureToneDelta(
    tone: Double,
    toneStandard: Double,
    scheme: DynamicScheme,
    constraintProvider: DynamicSchemeValue<ToneDeltaConstraint?>? = nil,
    toneToDistanceFrom: (DynamicColor) -> Double
  ) -> Double {
    let constraint = constraintProvider?(scheme)
    if constraint == nil {
      return tone
    }

    let requiredDelta = constraint!.delta
    let keepAwayTone = toneToDistanceFrom(constraint!.keepAway)
    let delta = abs(tone - keepAwayTone)
    if delta > requiredDelta {
      return tone
    }
    switch constraint!.keepAwayPolarity {
    case TonePolarity.darker:
      return MathUtils.clampDouble(0, 100, keepAwayTone + requiredDelta)
    case TonePolarity.lighter:
      return MathUtils.clampDouble(0, 100, keepAwayTone - requiredDelta)
    case TonePolarity.noPreference:
      let keepAwayToneStandard = constraint!.keepAway.tone(scheme)
      let preferLighten = toneStandard > keepAwayToneStandard
      let alterAmount = abs(delta - requiredDelta)
      let lighten = preferLighten ? (tone + alterAmount <= 100) : tone < alterAmount
      return lighten ? tone + alterAmount : tone - alterAmount
    }
  }

  /// Given a background tone, find a foreground tone, while ensuring they reach
  /// a contrast ratio that is as close to [ratio] as possible.
  ///
  /// [bgTone] Tone in HCT. Range is 0 to 100, undefined behavior when it falls
  /// outside that range.
  /// [ratio] The contrast ratio desired between [bgTone] and the return value.
  static func foregroundTone(_ bgTone: Double, _ ratio: Double) -> Double {
    let lighterTone = Contrast.lighterUnsafe(tone: bgTone, ratio: ratio)
    let darkerTone = Contrast.darkerUnsafe(tone: bgTone, ratio: ratio)
    let lighterRatio = Contrast.ratioOfTones(lighterTone, bgTone)
    let darkerRatio = Contrast.ratioOfTones(darkerTone, bgTone)
    let preferLigher = tonePrefersLightForeground(bgTone)

    if preferLigher {
      // This handles an edge case where the initial contrast ratio is high
      // (ex. 13.0), and the ratio passed to the function is that high ratio,
      // and both the lighter and darker ratio fails to pass that ratio.
      //
      // This was observed with Tonal Spot's On Primary Container turning black
      // momentarily between high and max contrast in light mode.
      // PC's standard tone was T90, OPC's was T10, it was light mode, and the
      // contrast value was 0.6568521221032331.
      let negligibleDifference =
        (abs(lighterRatio - darkerRatio) < 0.1 && lighterRatio < ratio && darkerRatio < ratio)
      return lighterRatio >= ratio || lighterRatio >= darkerRatio || negligibleDifference
        ? lighterTone
        : darkerTone
    } else {
      return darkerRatio >= ratio || darkerRatio >= lighterRatio
        ? darkerTone
        : lighterTone
    }
  }

  /// Adjust a tone such that white has 4.5 contrast, if the tone is
  /// reasonably close to supporting it.
  static func enableLightForeground(_ tone: Double) -> Double {
    if tonePrefersLightForeground(tone) && !toneAllowsLightForeground(tone) {
      return 49
    }
    return tone
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
  static func tonePrefersLightForeground(_ tone: Double) -> Bool {
    return round(tone) <= 60
  }

  /// Returns whether [tone] can reach a contrast ratio of 4.5 with a lighter
  /// color.
  static func toneAllowsLightForeground(_ tone: Double) -> Bool {
    return round(tone) <= 49
  }
}
