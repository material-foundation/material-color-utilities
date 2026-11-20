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

/// The distinct colors of an image and how many pixels have each color, in the order of their
/// first occurrence, as a Java `LinkedHashMap`.
///
/// The colors are counted in a flat open-addressing hash table of `Int`s, which is much faster
/// than a `Dictionary` for this.
struct PixelCounts {
  /// The distinct colors, in the order of their first occurrence.
  private(set) var colors: [Int] = []

  /// The number of pixels with each color in `colors`.
  private(set) var counts: [Int] = []

  init(_ pixels: [Int]) {
    var table = Table(bits: 4)
    for pixel in pixels {
      var slot = table.firstSlot(pixel)
      while true {
        let position = table.positions[slot]
        if position == 0 {
          colors.append(pixel)
          counts.append(1)
          table.keys[slot] = pixel
          table.positions[slot] = colors.count
          // Keeps the table at most half full, so that the probe sequences stay short.
          if colors.count * 2 > table.keys.count {
            table = Table(bits: table.bits + 1)
            for (i, color) in colors.enumerated() {
              table.insert(color, position: i + 1)
            }
          }
          break
        }
        if table.keys[slot] == pixel {
          counts[position - 1] += 1
          break
        }
        slot = (slot + 1) & table.mask
      }
    }
  }

  private struct Table {
    let bits: Int
    let mask: Int
    var keys: [Int]
    /// The position of the key in `colors` plus 1, or 0 if the slot is empty.
    var positions: [Int]

    init(bits: Int) {
      self.bits = bits
      self.mask = (1 << bits) - 1
      self.keys = [Int](repeating: 0, count: 1 << bits)
      self.positions = [Int](repeating: 0, count: 1 << bits)
    }

    /// The first slot to probe for `key`, from Fibonacci hashing.
    @inline(__always)
    func firstSlot(_ key: Int) -> Int {
      let hash = UInt64(UInt(bitPattern: key)) &* 0x9E37_79B9_7F4A_7C15
      return Int(truncatingIfNeeded: hash >> UInt64(64 - bits))
    }

    mutating func insert(_ key: Int, position: Int) {
      var slot = firstSlot(key)
      while positions[slot] != 0 {
        slot = (slot + 1) & mask
      }
      keys[slot] = key
      positions[slot] = position
    }
  }
}
