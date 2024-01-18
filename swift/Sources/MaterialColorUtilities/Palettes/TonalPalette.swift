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
  static let commonTones = [
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
  var hue: Double {
    return _hue
  }
  private let _chroma: Double
  var chroma: Double {
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
      keyColor: TonalPalette.createKeyColor(hue, chroma),
      cache: [:]
    )
  }

  /// Create a Tonal Palette from hue and chroma of [hct].
  static func fromHct(_ hct: Hct) -> TonalPalette {
    return TonalPalette(hct: hct)
  }

  /// Create a Tonal Palette from hue and chroma, which generates a key color.
  static func fromHueAndChroma(_ hue: Double, _ chroma: Double) -> TonalPalette {
    return TonalPalette(hue: hue, chroma: chroma)
  }

  /// Create colors using [hue] and [chroma].
  static func of(_ hue: Double, _ chroma: Double) -> TonalPalette {
    return TonalPalette(hue: hue, chroma: chroma)
  }

  /// Creates a key color from a [hue] and a [chroma].
  /// The key color is the first tone, starting from T50, matching the given hue and chroma.
  /// Key color [Hct]
  static func createKeyColor(_ hue: Double, _ chroma: Double) -> Hct {
    let startTone: Double = 50.0
    var smallestDeltaHct = Hct.from(hue, chroma, startTone)
    var smallestDelta: Double = abs(smallestDeltaHct.chroma - chroma)
    // Starting from T50, check T+/-delta to see if they match the requested
    // chroma.
    //
    // Starts from T50 because T50 has the most chroma available, on
    // average. Thus it is most likely to have a direct answer and minimize
    // iteration.
    for delta in (1...49) {
      // Termination condition rounding instead of minimizing delta to avoid
      // case where requested chroma is 16.51, and the closest chroma is 16.49.
      // Error is minimized, but when rounded and displayed, requested chroma
      // is 17, key color's chroma is 16.
      if round(chroma) == round(smallestDeltaHct.chroma) {
        return smallestDeltaHct
      }

      let hctAdd = Hct.from(hue, chroma, startTone + Double(delta))
      let hctAddDelta: Double = abs(hctAdd.chroma - chroma)
      if hctAddDelta < smallestDelta {
        smallestDelta = hctAddDelta
        smallestDeltaHct = hctAdd
      }

      let hctSubtract = Hct.from(hue, chroma, startTone - Double(delta))
      let hctSubtractDelta: Double = abs(hctSubtract.chroma - chroma)
      if hctSubtractDelta < smallestDelta {
        smallestDelta = hctSubtractDelta
        smallestDeltaHct = hctSubtract
      }
    }

    return smallestDeltaHct
  }

  /// Returns the ARGB representation of an HCT color.
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

  func getHct(_ tone: Double) -> Hct {
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
