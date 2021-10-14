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

import 'package:material_color_utilities/hct/cam16.dart';
import 'package:material_color_utilities/palettes/tonal_palette.dart';
import 'dart:math' as math;

/// An intermediate concept between the key color for a UI theme, and a full
/// color scheme. 5 tonal palettes are generated, all except one use the same
/// hue as the key color, and all vary in chroma.
class CorePalette {
  /// The number of generated tonal palettes.
  static const size = 5;

  // TODO: consider renaming to primary, secondary, ..., neutralVariant and providing getters
  final TonalPalette a1;
  final TonalPalette a2;
  final TonalPalette a3;
  final TonalPalette n1;
  final TonalPalette n2;
  final TonalPalette error = TonalPalette.of(25, 84);

  /// Create a [CorePalette] from a source ARGB color.
  static CorePalette of(int argb) {
    final cam = Cam16.fromInt(argb);
    return CorePalette._(cam.hue, cam.chroma);
  }

  CorePalette._(double hue, double chroma)
      : a1 = TonalPalette.of(hue, math.max(48, chroma)),
        a2 = TonalPalette.of(hue, 16),
        a3 = TonalPalette.of(hue + 60, 24),
        n1 = TonalPalette.of(hue, 4),
        n2 = TonalPalette.of(hue, 8);

  /// Create a [CorePalette] from a fixed-size list of ARGB color ints
  /// representing concatenated tonal palettes.
  ///
  /// Inverse of [asList].
  CorePalette.fromList(List<int> colors)
      : assert(colors.length == size * TonalPalette.commonSize),
        a1 = TonalPalette.fromList(
            _getPartition(colors, 0, TonalPalette.commonSize)),
        a2 = TonalPalette.fromList(
            _getPartition(colors, 1, TonalPalette.commonSize)),
        a3 = TonalPalette.fromList(
            _getPartition(colors, 2, TonalPalette.commonSize)),
        n1 = TonalPalette.fromList(
            _getPartition(colors, 3, TonalPalette.commonSize)),
        n2 = TonalPalette.fromList(
            _getPartition(colors, 4, TonalPalette.commonSize));

  /// Returns a list of ARGB color [int]s from concatenated tonal palettes.
  ///
  /// Inverse of [CorePalette.fromList].
  List<int> asList() =>
      [...a1.asList, ...a2.asList, ...a3.asList, ...n1.asList, ...n2.asList];

  @override
  bool operator ==(Object other) =>
      other is CorePalette &&
      a1 == other.a1 &&
      a2 == other.a2 &&
      a3 == other.a3 &&
      n1 == other.n1 &&
      n2 == other.n2 &&
      error == other.error;

  @override
  int get hashCode => Object.hash(a1, a2, a3, n1, n2, error);

  @override
  String toString() {
    return 'A1: $a1\n'
        'A2: $a2\n'
        'A3: $a3\n'
        'N1: $n1\n'
        'N2: $n2\n'
        'error: $error\n';
  }
}

// Returns a partition from a list.
//
// For example, given a list with 2 partitions of size 3.
// range = [1, 2, 3, 4, 5, 6];
//
// range.getPartition(0, 3) // [1, 2, 3]
// range.getPartition(1, 3) // [4, 5, 6]
List<int> _getPartition(
    List<int> list, int partitionNumber, int partitionSize) {
  return list.sublist(
    partitionNumber * partitionSize,
    (partitionNumber + 1) * partitionSize,
  );
}
