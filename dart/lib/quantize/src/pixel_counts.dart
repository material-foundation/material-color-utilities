// Copyright 2026 Google LLC
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

import 'dart:typed_data';

/// The distinct colors of an image and how often each appears, in order of
/// first appearance, as a `LinkedHashMap<int, int>` would keep them.
///
/// The colors are counted in a flat open-addressing hash table of typed
/// arrays, so no map entry or boxed int is allocated per color.
class PixelCounts {
  /// The distinct colors, in order of first appearance. Only the first [size]
  /// entries are used.
  final Uint32List colors;

  /// How often each color in [colors] appears.
  final Int32List counts;

  /// The number of distinct colors.
  final int size;

  PixelCounts._(this.colors, this.counts, this.size);

  /// Counts the colors in [pixels].
  ///
  /// Returns null if a pixel is not in [0, 2^32), because such ints do not
  /// fit in the table. Callers then fall back to a map, which keeps, for
  /// example, -1 and 0xffffffff apart.
  static PixelCounts? tryCount(List<int> pixels) {
    final pixelCount = pixels.length;
    var capacity = 16;
    while (capacity < 2 * pixelCount) {
      capacity <<= 1;
    }
    final mask = capacity - 1;
    final keys = Uint32List(capacity);
    // The index of the color in each slot, plus 1. 0 marks an empty slot.
    final slots = Int32List(capacity);
    final colors = Uint32List(pixelCount);
    final counts = Int32List(pixelCount);
    var size = 0;
    for (var i = 0; i < pixelCount; i++) {
      final pixel = pixels[i];
      if (pixel != (pixel & 0xffffffff)) {
        return null;
      }
      // Shifts and xors only, so that the hash is exact on the web too.
      var slot = (pixel ^ (pixel >> 11) ^ (pixel >> 19)) & mask;
      while (true) {
        final index = slots[slot];
        if (index == 0) {
          keys[slot] = pixel;
          slots[slot] = size + 1;
          colors[size] = pixel;
          counts[size] = 1;
          size++;
          break;
        }
        if (keys[slot] == pixel) {
          counts[index - 1]++;
          break;
        }
        slot = (slot + 1) & mask;
      }
    }
    return PixelCounts._(colors, counts, size);
  }
}
