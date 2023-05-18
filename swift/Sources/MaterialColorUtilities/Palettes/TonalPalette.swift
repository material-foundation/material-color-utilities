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
class TonalPalette: Equatable, Hashable {
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

  var _cache: [Double: Int]

  private init(hue: Double, chroma: Double, cache: [Double: Int]) {
    self._hue = hue
    self._chroma = chroma
    self._cache = cache
  }

  static private func fromHueAndChroma(_ hue: Double, _ chroma: Double) -> TonalPalette {
    return TonalPalette(
      hue: hue,
      chroma: chroma,
      cache: [:]
    )
  }

  /// Create colors using [hue] and [chroma].
  static func of(_ hue: Double, _ chroma: Double) -> TonalPalette {
    return TonalPalette.fromHueAndChroma(hue, chroma)
  }

  /// Create a Tonal Palette from hue and chroma of [hct].
  static func fromHct(_ hct: Hct) -> TonalPalette {
    return TonalPalette.fromHueAndChroma(hct.hue, hct.chroma)
  }

  /// Returns the ARGB representation of an HCT color.
  ///
  /// If the class was instantiated from [_hue] and [_chroma], will return the
  /// color with corresponding [tone].
  /// If the class was instantiated from a fixed-size list of color ints, [tone]
  /// must be in [commonTones].
  func tone(_ tone: Double) -> Int {
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

  static func == (lhs: TonalPalette, rhs: TonalPalette) -> Bool {
    return type(of: lhs) == type(of: rhs) && lhs.isEqual(to: rhs)
  }

  func hash(into hasher: inout Hasher) {
    hasher.combine(_hue)
    hasher.combine(_chroma)
  }

  public var description: String {
    return "TonalPalette.of(\(hue), \(chroma))"
  }
}
