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

public typealias DynamicSchemeValue<T> = (DynamicScheme) -> T

/// A color that adjusts itself based on UI state provided by `DynamicScheme`.
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
/// `DynamicScheme` and returns a value. This ensures ultimate flexibility, any
/// desired behavior of a color for any design system, but it usually
/// unnecessary. See the default constructor for more information.
public class DynamicColor {
  public let name: String
  let palette: DynamicSchemeValue<TonalPalette>
  let tone: DynamicSchemeValue<Double>
  let isBackground: Bool
  let background: DynamicSchemeValue<DynamicColor>?
  let secondBackground: DynamicSchemeValue<DynamicColor>?
  let contrastCurve: ContrastCurve?
  let toneDeltaPair: DynamicSchemeValue<ToneDeltaPair>?

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
  /// - Parameters:
  ///   - name: The name of the dynamic color.
  ///   - palette: Function that provides a TonalPalette given DynamicScheme.
  ///       A TonalPalette is defined by a hue and chroma, so this
  ///       replaces the need to specify hue/chroma. By providing a tonal palette,
  ///       when contrast adjustments are made, intended chroma can be preserved.
  ///   - tone: Function that provides a tone, given a DynamicScheme.
  ///   - isBackground: Whether this dynamic color is a background, with
  ///       some other color as the foreground.
  ///   - background: The background of the dynamic color (as a function of a
  ///       `DynamicScheme`), if it exists.
  ///   - secondBackground: A second background of the dynamic color (as a function
  ///       of a `DynamicScheme`), if it exists.
  ///   - contrastCurve: A `ContrastCurve` object specifying how its contrast
  ///       against its background should behave in various contrast levels options.
  ///   - toneDeltaPair: A `ToneDeltaPair` object specifying a tone delta
  ///       constraint between two colors. One of them must be the color being constructed.
  ///
  /// Unlikely to be useful unless a design system has some distortions
  /// where colors that don't have a background/foreground relationship
  /// don't want to have a formal relationship or a principled value for their
  /// tone distance based on common contrast / tone delta values, yet, want
  /// tone distance.
  public init(
    name: String,
    palette: @escaping DynamicSchemeValue<TonalPalette>,
    tone: @escaping DynamicSchemeValue<Double>,
    isBackground: Bool = false,
    background: DynamicSchemeValue<DynamicColor>? = nil,
    secondBackground: DynamicSchemeValue<DynamicColor>? = nil,
    contrastCurve: ContrastCurve? = nil,
    toneDeltaPair: DynamicSchemeValue<ToneDeltaPair>? = nil
  ) {
    self.name = name
    self.palette = palette
    self.tone = tone
    self.isBackground = isBackground
    self.background = background
    self.secondBackground = secondBackground
    self.contrastCurve = contrastCurve
    self.toneDeltaPair = toneDeltaPair
  }

  /// Return a ARGB integer (i.e. a hex code).
  ///
  /// - Parameter scheme: Defines the conditions of the user interface, for example,
  ///   whether or not it is dark mode or light mode, and what the desired contrast level is.
  /// - Returns: The color as an integer (ARGB).
  public func getArgb(_ scheme: DynamicScheme) -> Int {
    return getHct(scheme).toInt()
  }

  /// - Parameter scheme: Defines the conditions of the user interface, for example,
  ///   whether or not it is dark mode or light mode, and what the desired
  ///   contrast level is.
  /// - Returns: a color, expressed in the HCT color space, that this
  ///   `DynamicColor` is under the conditions in `scheme`.
  public func getHct(_ scheme: DynamicScheme) -> Hct {
    if let cachedAnswer = _hctCache[scheme] {
      return cachedAnswer
    }
    let answer = palette(scheme).getHct(getTone(scheme))
    if _hctCache.count > 4 {
      _hctCache.removeAll()
    }
    _hctCache[scheme] = answer
    return answer
  }

  /// - Parameter scheme: Defines the conditions of the user interface, for example,
  ///   whether or not it is dark mode or light mode, and what the desired
  ///   contrast level is.
  /// - Returns: a tone, T in the HCT color space, that this `DynamicColor` is under
  ///   the conditions in `scheme`.
  public func getTone(_ scheme: DynamicScheme) -> Double {
    let decreasingContrast = scheme.contrastLevel < 0

    // Case 1: dual foreground, pair of colors with delta constraint.
    if let toneDeltaPair {
      let pair = toneDeltaPair(scheme)
      let roleA = pair.subject
      let roleB = pair.basis
      let delta = pair.delta
      let polarity = pair.polarity
      let stayTogether = pair.stayTogether

      let bg = background!(scheme)
      let bgTone = bg.getTone(scheme)

      let aIsNearer =
        (polarity == TonePolarity.nearer || (polarity == TonePolarity.lighter && !scheme.isDark)
          || (polarity == TonePolarity.darker && scheme.isDark))
      let nearer = aIsNearer ? roleA : roleB
      let farther = aIsNearer ? roleB : roleA
      let amNearer = self.name == nearer.name
      let expansionDir: Double = scheme.isDark ? 1 : -1

      // 1st round: solve to min, each
      let nContrast = nearer.contrastCurve!.get(scheme.contrastLevel)
      let fContrast =
        farther.contrastCurve!.get(scheme.contrastLevel)

      // If a color is good enough, it is not adjusted.
      // Initial and adjusted tones for `nearer`
      let nInitialTone = nearer.tone(scheme)
      var nTone =
        Contrast.ratioOfTones(bgTone, nInitialTone) >= nContrast
        ? nInitialTone
        : DynamicColor.foregroundTone(bgTone, nContrast)
      // Initial and adjusted tones for `farther`
      let fInitialTone = farther.tone(scheme)
      var fTone =
        Contrast.ratioOfTones(bgTone, fInitialTone) >= fContrast
        ? fInitialTone
        : DynamicColor.foregroundTone(bgTone, fContrast)

      if decreasingContrast {
        // If decreasing contrast, adjust color to the "bare minimum"
        // that satisfies contrast.
        nTone = DynamicColor.foregroundTone(bgTone, nContrast)
        fTone = DynamicColor.foregroundTone(bgTone, fContrast)
      }

      if (fTone - nTone) * expansionDir >= delta {
        // Good! Tones satisfy the constraint; no change needed.
      } else {
        // 2nd round: expand farther to match delta.
        fTone = MathUtils.clampDouble(0, 100, nTone + delta * expansionDir)
        if (fTone - nTone) * expansionDir >= delta {
          // Good! Tones now satisfy the constraint; no change needed.
        } else {
          // 3rd round: contract nearer to match delta.
          nTone = MathUtils.clampDouble(0, 100, fTone - delta * expansionDir)
        }
      }

      // Avoids the 50-59 awkward zone.
      if 50 <= nTone && nTone < 60 {
        // If `nearer` is in the awkward zone, move it away, together with
        // `farther`.
        if expansionDir > 0 {
          nTone = 60
          fTone = max(fTone, nTone + delta * expansionDir)
        } else {
          nTone = 49
          fTone = min(fTone, nTone + delta * expansionDir)
        }
      } else if 50 <= fTone && fTone < 60 {
        if stayTogether {
          // Fixes both, to avoid two colors on opposite sides of the "awkward
          // zone".
          if expansionDir > 0 {
            nTone = 60
            fTone = max(fTone, nTone + delta * expansionDir)
          } else {
            nTone = 49
            fTone = min(fTone, nTone + delta * expansionDir)
          }
        } else {
          // Not required to stay together; fixes just one.
          if expansionDir > 0 {
            fTone = 60
          } else {
            fTone = 49
          }
        }
      }

      // Returns `nTone` if this color is `nearer`, otherwise `fTone`.
      return amNearer ? nTone : fTone
    } else {
      // Case 2: No contrast pair; just solve for itself.
      var answer = self.tone(scheme)

      if let background {
        let bgTone = background(scheme).getTone(scheme)

        let desiredRatio =
          self.contrastCurve!.get(scheme.contrastLevel)

        if Contrast.ratioOfTones(bgTone, answer) >= desiredRatio {
          // Don't "improve" what's good enough.
        } else {
          // Rough improvement.
          answer = DynamicColor.foregroundTone(bgTone, desiredRatio)
        }

        if decreasingContrast {
          answer = DynamicColor.foregroundTone(bgTone, desiredRatio)
        }

        if self.isBackground && 50 <= answer && answer < 60 {
          // Must adjust
          if Contrast.ratioOfTones(49, bgTone) >= desiredRatio {
            answer = 49
          } else {
            answer = 60
          }
        }

        if let secondBackground {
          // Case 3: Adjust for dual backgrounds.

          let bgTone1 = self.background!(scheme).getTone(scheme)
          let bgTone2 = secondBackground(scheme).getTone(scheme)

          let upper = max(bgTone1, bgTone2)
          let lower = min(bgTone1, bgTone2)

          if Contrast.ratioOfTones(upper, answer) >= desiredRatio
            && Contrast.ratioOfTones(lower, answer) >= desiredRatio
          {
            return answer
          }

          // The darkest light tone that satisfies the desired ratio,
          // or -1 if such ratio cannot be reached.
          let lightOption = Contrast.lighter(tone: upper, ratio: desiredRatio)

          // The lightest dark tone that satisfies the desired ratio,
          // or -1 if such ratio cannot be reached.
          let darkOption = Contrast.darker(tone: lower, ratio: desiredRatio)

          // Tones suitable for the foreground.
          var availables: [Double] = []
          if lightOption != -1 { availables.append(lightOption) }
          if darkOption != -1 { availables.append(darkOption) }

          let prefersLight =
            DynamicColor.tonePrefersLightForeground(bgTone1)
            || DynamicColor.tonePrefersLightForeground(bgTone2)
          if prefersLight {
            return (lightOption < 0) ? 100 : lightOption
          }
          if availables.count == 1 {
            return availables[0]
          }
          return (darkOption < 0) ? 0 : darkOption
        }
      }

      return answer
    }
  }

  /// Given a background tone, find a foreground tone, while ensuring they reach
  /// a contrast ratio that is as close to `ratio` as possible.
  ///
  /// - Parameters:
  ///   - bgTone: Tone in HCT. Range is 0 to 100, undefined behavior when it falls
  ///     outside that range.
  ///   - ratio: The contrast ratio desired between `bgTone` and the return value.
  ///
  /// - Returns: The desired foreground tone.
  public static func foregroundTone(_ bgTone: Double, _ ratio: Double) -> Double {
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

  /// Adjusts a tone such that white has 4.5 contrast, if the tone is
  /// reasonably close to supporting it.
  /// - Parameter tone: The tone to be adjusted.
  /// - Returns: The (possibly updated) tone.
  public static func enableLightForeground(_ tone: Double) -> Double {
    if tonePrefersLightForeground(tone) && !toneAllowsLightForeground(tone) {
      return 49
    }
    return tone
  }

  /// Returns whether `tone` prefers a light foreground.
  ///
  /// People prefer white foregrounds on ~T60-70. Observed over time, and also
  /// by Andrew Somers during research for APCA.
  ///
  /// T60 used as to create the smallest discontinuity possible when skipping
  /// down to T49 in order to ensure light foregrounds.
  ///
  /// Since `tertiaryContainer` in dark monochrome scheme requires a tone of
  /// 60, it should not be adjusted. Therefore, 60 is excluded here.
  ///
  /// - Parameter tone: The tone to be judged.
  /// - Returns: whether `tone` prefers a light foreground.
  public static func tonePrefersLightForeground(_ tone: Double) -> Bool {
    return round(tone) < 60
  }

  /// Returns whether `tone` can reach a contrast ratio of 4.5 with a lighter
  /// color.
  ///
  /// - Parameter tone: The tone to be judged.
  /// - Returns: whether `tone` allows a light foreground.
  public static func toneAllowsLightForeground(_ tone: Double) -> Bool {
    return round(tone) <= 49
  }
}
