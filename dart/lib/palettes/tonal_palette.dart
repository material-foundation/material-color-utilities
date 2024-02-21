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

import 'package:collection/collection.dart' show ListEquality;
import 'package:material_color_utilities/hct/hct.dart';

/// A convenience class for retrieving colors that are constant in hue and
/// chroma, but vary in tone.
///
/// This class can be instantiated in two ways:
/// 1. [of] From hue and chroma. (preferred)
/// 2. [fromList] From a fixed-size ([TonalPalette.commonSize]) list of ints
/// representing ARBG colors. Correctness (constant hue and chroma) of the input
/// is not enforced. [get] will only return the input colors, corresponding to
/// [commonTones]. This also initializes the key color to black.
class TonalPalette {
  /// Commonly-used tone values.
  static const List<int> commonTones = [
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
  ];

  static final commonSize = commonTones.length;

  final double hue;
  final double chroma;
  final Hct keyColor;

  /// A cache containing keys-value pairs where:
  /// - keys are integers that represent tones, and
  /// - values are colors in ARGB format.
  final Map<int, int> _cache;
  final bool _isFromCache;

  TonalPalette._fromHct(Hct hct)
      : _cache = {},
        hue = hct.hue,
        chroma = hct.chroma,
        keyColor = hct,
        _isFromCache = false;

  TonalPalette._fromHueAndChroma(this.hue, this.chroma)
      : _cache = {},
        keyColor = createKeyColor(hue, chroma),
        _isFromCache = false;

  TonalPalette._fromCache(Map<int, int> cache, this.hue, this.chroma)
      : _cache = cache,
        keyColor = createKeyColor(hue, chroma),
        _isFromCache = true;

  /// Create colors using [hue] and [chroma].
  static TonalPalette of(double hue, double chroma) {
    return TonalPalette._fromHueAndChroma(hue, chroma);
  }

  /// Create a Tonal Palette from hue and chroma of [hct].
  static TonalPalette fromHct(Hct hct) {
    return TonalPalette._fromHct(hct);
  }

  /// Create colors from a fixed-size list of ARGB color ints.
  ///
  /// Inverse of [TonalPalette.asList].
  static TonalPalette fromList(List<int> colors) {
    assert(colors.length == commonSize);
    var cache = <int, int>{};
    commonTones.asMap().forEach(
        (int index, int toneValue) => cache[toneValue] = colors[index]);

    // Approximately deduces the original hue and chroma that generated this
    // list of colors.
    // Uses the hue and chroma of the provided color with the highest chroma.

    var bestHue = 0.0, bestChroma = 0.0;
    for (final argb in colors) {
      final hct = Hct.fromInt(argb);

      // If the color is too close to white, its chroma may have been
      // affected by a known issue, so we ignore it.
      // https://github.com/material-foundation/material-color-utilities/issues/140

      if (hct.tone > 98.0) continue;

      if (hct.chroma > bestChroma) {
        bestHue = hct.hue;
        bestChroma = hct.chroma;
      }
    }

    return TonalPalette._fromCache(cache, bestHue, bestChroma);
  }

  /// Creates a key color from a [hue] and a [chroma].
  /// The key color is the first tone, starting from T50, matching the given hue and chroma.
  /// Key color [Hct]
  static Hct createKeyColor(double hue, double chroma) {
    double startTone = 50.0;
    Hct smallestDeltaHct = Hct.from(hue, chroma, startTone);
    double smallestDelta = (smallestDeltaHct.chroma - chroma).abs();
    // Starting from T50, check T+/-delta to see if they match the requested
    // chroma.
    //
    // Starts from T50 because T50 has the most chroma available, on
    // average. Thus it is most likely to have a direct answer and minimize
    // iteration.
    for (double delta = 1.0; delta < 50.0; delta += 1.0) {
      // Termination condition rounding instead of minimizing delta to avoid
      // case where requested chroma is 16.51, and the closest chroma is 16.49.
      // Error is minimized, but when rounded and displayed, requested chroma
      // is 17, key color's chroma is 16.
      if (chroma.round() == smallestDeltaHct.chroma.round()) {
        return smallestDeltaHct;
      }

      final Hct hctAdd = Hct.from(hue, chroma, startTone + delta);
      final double hctAddDelta = (hctAdd.chroma - chroma).abs();
      if (hctAddDelta < smallestDelta) {
        smallestDelta = hctAddDelta;
        smallestDeltaHct = hctAdd;
      }

      final Hct hctSubtract = Hct.from(hue, chroma, startTone - delta);
      final double hctSubtractDelta = (hctSubtract.chroma - chroma).abs();
      if (hctSubtractDelta < smallestDelta) {
        smallestDelta = hctSubtractDelta;
        smallestDeltaHct = hctSubtract;
      }
    }

    return smallestDeltaHct;
  }

  /// Returns a fixed-size list of ARGB color ints for common tone values.
  ///
  /// Inverse of [fromList].
  List<int> get asList => commonTones.map((int tone) => get(tone)).toList();

  /// Returns the ARGB representation of an HCT color at the given [tone].
  ///
  /// If the palette is constructed from a list of colors
  /// (i.e. using [fromList]), the color provided at construction is returned
  /// if possible; otherwise the result is generated from the deduced
  /// [hue] and [chroma].
  ///
  /// If the palette is constructed from a hue and chroma (i.e. using [of] or
  /// [fromHct]), the result is generated from the given [hue] and [chroma].
  int get(int tone) {
    return _cache.putIfAbsent(
      tone,
      () => Hct.from(hue, chroma, tone.toDouble()).toInt(),
    );
  }

  /// Returns the HCT color at the given [tone].
  ///
  /// If the palette is constructed from a list of colors
  /// (i.e. using [fromList]), the color provided at construction is returned
  /// if possible; otherwise the result is generated from the deduced
  /// [hue] and [chroma].
  ///
  /// If the palette is constructed from a hue and chroma (i.e. using [of] or
  /// [fromHct]), the result is generated from the given [hue] and [chroma].
  Hct getHct(double tone) {
    if (_cache.containsKey(tone)) {
      return Hct.fromInt(_cache[tone]!);
    } else {
      return Hct.from(hue, chroma, tone);
    }
  }

  @override
  bool operator ==(Object other) {
    if (other is TonalPalette) {
      if (!_isFromCache && !other._isFromCache) {
        // Both created with .of or .fromHct
        return hue == other.hue && chroma == other.chroma;
      } else {
        return ListEquality().equals(asList, other.asList);
      }
    }
    return false;
  }

  @override
  int get hashCode {
    if (!_isFromCache) {
      return Object.hash(hue, chroma);
    } else {
      return Object.hashAll(asList);
    }
  }

  @override
  String toString() {
    if (!_isFromCache) {
      return 'TonalPalette.of($hue, $chroma)';
    } else {
      return 'TonalPalette.fromList($asList)';
    }
  }
}
