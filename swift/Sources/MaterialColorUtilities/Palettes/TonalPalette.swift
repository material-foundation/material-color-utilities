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

/// A convenience class for retrieving colors that are constant in hue and
/// chroma, but vary in tone.
///
/// This class can be instantiated in two ways:
/// 1. [of] From hue and chroma. (preferred)
/// 2. [fromList] From a fixed-size ([TonalPalette.commonSize]) list of ints
/// representing ARBG colors. Correctness (constant hue and chroma) of the input
/// is not enforced. [get] will only return the input colors, corresponding to
/// [commonTones].
public class TonalPalette: Equatable, Hashable {
  /// Commonly-used tone values.
  public static let commonTones = [
    0,
    10,
    20,
    30,
    40,
    50,
    60,
    70,
    80,
    90,
    95,
    99,
    100,
  ]

  static var commonSize: Int {
    return commonTones.count
  }

  private let _hue: Double
  public var hue: Double {
    return _hue
  }
  private let _chroma: Double
  public var chroma: Double {
    return _chroma
  }
  private let _keyColor: Hct
  var keyColor: Hct {
    return _keyColor
  }

  var _cache: [Double: Int]

  private init(hue: Double, chroma: Double, keyColor: Hct, cache: [Double: Int]) {
    self._hue = hue
    self._chroma = chroma
    self._keyColor = keyColor
    self._cache = cache
  }

  convenience init(hct: Hct) {
    self.init(
      hue: hct.hue,
      chroma: hct.chroma,
      keyColor: hct,
      cache: [:]
    )
  }

  convenience init(hue: Double, chroma: Double) {
    self.init(
      hue: hue,
      chroma: chroma,
      keyColor: KeyColor(hue: hue, requestedChroma: chroma).create(),
      cache: [:]
    )
  }

  /// Create a Tonal Palette from hue and chroma of [hct].
  public static func fromHct(_ hct: Hct) -> TonalPalette {
    return TonalPalette(hct: hct)
  }

  /// Create a Tonal Palette from hue and chroma, which generates a key color.
  static func fromHueAndChroma(_ hue: Double, _ chroma: Double) -> TonalPalette {
    return TonalPalette(hue: hue, chroma: chroma)
  }

  /// Create colors using [hue] and [chroma].
  public static func of(_ hue: Double, _ chroma: Double) -> TonalPalette {
    return TonalPalette(hue: hue, chroma: chroma)
  }

  /// Returns the ARGB representation of an Hct color.
  ///
  /// If the class was instantiated from [_hue] and [_chroma], will return the
  /// color with corresponding [tone].
  /// If the class was instantiated from a fixed-size list of color ints, [tone]
  /// must be in [commonTones].
  public func tone(_ tone: Double) -> Int {
    if _cache[tone] == nil {
      _cache[tone] = Hct.from(hue, chroma, tone).toInt()
    }
    return _cache[tone]!
  }

  public func getHct(_ tone: Double) -> Hct {
    return Hct.fromInt(self.tone(tone))
  }

  func isEqual(to other: TonalPalette) -> Bool {
    return _hue == other._hue && _chroma == other._chroma
  }

  public static func == (lhs: TonalPalette, rhs: TonalPalette) -> Bool {
    return type(of: lhs) == type(of: rhs) && lhs.isEqual(to: rhs)
  }

  public func hash(into hasher: inout Hasher) {
    hasher.combine(_hue)
    hasher.combine(_chroma)
  }

  public var description: String {
    return "TonalPalette.of(\(hue), \(chroma))"
  }
}

/// Key color is a color that represents the hue and chroma of a tonal palette.
private class KeyColor {
  let hue: Double
  let requestedChroma: Double

  /// Cache that maps (hue, tone) to max chroma to avoid duplicated Hct calculation.
  private var chromaCache: [Int: Double] = [:]
  private let maxChromaValue = 200.0

  init(hue: Double, requestedChroma: Double) {
    self.hue = hue
    self.requestedChroma = requestedChroma
  }

  /// Creates a key color from a [hue] and a [chroma].
  /// The key color is the first tone, starting from T50, matching the given hue and chroma.
  /// Key color [Hct]
  func create() -> Hct {
    /// Pivot around T50 because T50 has the most chroma available, on average. Thus it is most
    /// likely to have a direct answer.
    let pivotTone = 50
    let toneStepSize = 1
    /// Epsilon to accept values slightly higher than the requested chroma.
    let epsilon = 0.01

    /// Binary search to find the tone that can provide a chroma that is closest
    /// to the requested chroma.
    var lowerTone = 0
    var upperTone = 100

    while lowerTone < upperTone {
      let midTone = (lowerTone + upperTone) / 2
      let isAscending =
        maxChroma(tone: midTone) < maxChroma(tone: midTone + toneStepSize)
      let sufficientChroma = maxChroma(tone: midTone) >= requestedChroma - epsilon

      if sufficientChroma {
        /// Either range [lowerTone, midTone] or [midTone, upperTone] has answer, so search in the
        /// range that is closer the pivot tone.
        if abs(lowerTone - pivotTone) < abs(upperTone - pivotTone) {
          upperTone = midTone
        } else {
          if lowerTone == midTone {
            return Hct.from(hue, requestedChroma, Double(lowerTone))
          }
          lowerTone = midTone
        }
      } else if isAscending {
        /// As there is no sufficient chroma in the midTone, follow the direction to the chroma
        /// peak.
        lowerTone = midTone + toneStepSize
      } else {
        /// Keep midTone for potential chroma peak.
        upperTone = midTone
      }
    }

    return Hct.from(hue, requestedChroma, Double(lowerTone))
  }

  /// Find the maximum chroma for a given tone
  private func maxChroma(tone: Int) -> Double {
    return chromaCache[tone]
      ?? {
        let chroma = Hct.from(self.hue, self.maxChromaValue, Double(tone)).chroma
        chromaCache[tone] = chroma
        return chroma
      }()
  }
}
