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

import 'dart:math' as math;
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

  final Hct? _keyColor;
  Hct get keyColor => _keyColor ?? Hct.from(0.0, 0.0, 0.0);
  final double? _hue;
  double get hue => _hue ?? 0.0;
  final double? _chroma;
  double get chroma => _chroma ?? 0.0;
  final Map<int, int> _cache;

  TonalPalette._fromHct(Hct hct)
      : _cache = {},
        _hue = hct.hue,
        _chroma = hct.chroma,
        _keyColor = hct;

  TonalPalette._fromHueAndChroma(double hue, double chroma)
      : _cache = {},
        _hue = hue,
        _chroma = chroma,
        _keyColor = createKeyColor(hue, chroma);

  TonalPalette._fromCache(Map<int, int> cache)
      : _cache = cache,
        _hue = null,
        _chroma = null,
        _keyColor = null;

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
    return TonalPalette._fromCache(cache);
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

  /// Returns the ARGB representation of an HCT color.
  ///
  /// If the class was instantiated from [_hue] and [_chroma], will return the
  /// color with corresponding [tone].
  /// If the class was instantiated from a fixed-size list of color ints, [tone]
  /// must be in [commonTones].
  int get(int tone) {
    if (_hue == null || _chroma == null) {
      if (!_cache.containsKey(tone)) {
        throw (ArgumentError.value(
          tone,
          'tone',
          'When a TonalPalette is created with fromList, tone must be one of '
              '$commonTones',
        ));
      } else {
        return _cache[tone]!;
      }
    }
    final chroma = (tone >= 90.0) ? math.min(_chroma!, 40.0) : _chroma!;
    return _cache.putIfAbsent(
        tone, () => Hct.from(_hue!, chroma, tone.toDouble()).toInt());
  }

  Hct getHct(double tone) {
    if (_hue == null || _chroma == null) {
      if (!_cache.containsKey(tone)) {
        throw (ArgumentError.value(
          tone,
          'tone',
          'When a TonalPalette is created with fromList, tone must be one of '
              '$commonTones',
        ));
      }
    }
    return Hct.from(_hue!, _chroma!, tone);
  }

  @override
  bool operator ==(Object other) {
    if (other is TonalPalette) {
      if (_hue != null &&
          _chroma != null &&
          other._hue != null &&
          other._chroma != null) {
        // Both created with .of or .fromHct
        return _hue == other._hue && _chroma == other._chroma;
      } else {
        return ListEquality().equals(asList, other.asList);
      }
    }
    return false;
  }

  @override
  int get hashCode {
    if (_hue != null && _chroma != null) {
      return Object.hash(_hue, _chroma);
    } else {
      return Object.hashAll(asList);
    }
  }

  @override
  String toString() {
    if (_hue != null && _chroma != null) {
      return 'TonalPalette.of($_hue, $_chroma)';
    } else {
      return 'TonalPalette.fromList($_cache)';
    }
  }
}
