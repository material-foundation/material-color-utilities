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

/// An intermediate concept between the key color for a UI theme, and a full
/// color scheme. 5 tonal palettes are generated, all except one use the same
/// hue as the key color, and all vary in chroma.
public class CorePalette: Equatable, Hashable {
  /// The number of generated tonal palettes.
  static let size = 5

  public let primary: TonalPalette
  public let secondary: TonalPalette
  public let tertiary: TonalPalette
  public let neutral: TonalPalette
  public let neutralVariant: TonalPalette
  public let error: TonalPalette

  init(
    primary: TonalPalette, secondary: TonalPalette, tertiary: TonalPalette, neutral: TonalPalette,
    neutralVariant: TonalPalette, error: TonalPalette? = nil
  ) {
    self.primary = primary
    self.secondary = secondary
    self.tertiary = tertiary
    self.neutral = neutral
    self.neutralVariant = neutralVariant
    self.error = error ?? TonalPalette.of(25, 84)
  }

  /// Create a [CorePalette] from a source ARGB color.
  public static func of(_ argb: Int) -> CorePalette {
    let cam = Cam16.fromInt(argb)
    return CorePalette._of(cam.hue, cam.chroma)
  }

  static private func _of(_ hue: Double, _ chroma: Double) -> CorePalette {
    return CorePalette(
      primary: TonalPalette.of(hue, max(48, chroma)),
      secondary: TonalPalette.of(hue, 16),
      tertiary: TonalPalette.of(hue + 60, 24),
      neutral: TonalPalette.of(hue, 4),
      neutralVariant: TonalPalette.of(hue, 8)
    )
  }

  /// Create a content [CorePalette] from a source ARGB color.
  public static func contentOf(_ argb: Int) -> CorePalette {
    let cam = Cam16.fromInt(argb)
    return CorePalette._contentOf(cam.hue, cam.chroma)
  }

  static private func _contentOf(_ hue: Double, _ chroma: Double) -> CorePalette {
    return CorePalette(
      primary: TonalPalette.of(hue, chroma),
      secondary: TonalPalette.of(hue, chroma / 3),
      tertiary: TonalPalette.of(hue + 60, chroma / 2),
      neutral: TonalPalette.of(hue, min(chroma / 12, 4)),
      neutralVariant: TonalPalette.of(hue, min(chroma / 6, 8))
    )
  }

  func isEqual(to other: CorePalette) -> Bool {
    return primary == other.primary && secondary == other.secondary && tertiary == other.tertiary
      && neutral == other.neutral && neutralVariant == other.neutralVariant
  }

  static public func == (lhs: CorePalette, rhs: CorePalette) -> Bool {
    return type(of: lhs) == type(of: rhs) && lhs.isEqual(to: rhs)
  }

  public func hash(into hasher: inout Hasher) {
    hasher.combine(primary)
    hasher.combine(secondary)
    hasher.combine(tertiary)
    hasher.combine(neutral)
    hasher.combine(neutralVariant)
  }

  public var description: String {
    return
      "primary\(primary) secondary\(secondary) tertiary\(tertiary) neutral\(neutral) neutralVariant\(neutralVariant)"
  }
}

// Returns a partition from a list.
//
// For example, given a list with 2 partitions of size 3.
// range = [1, 2, 3, 4, 5, 6];
//
// range.getPartition(0, 3) // [1, 2, 3]
// range.getPartition(1, 3) // [4, 5, 6]
private func _getPartition(_ list: [Int], _ partitionNumber: Int, _ partitionSize: Int) -> [Int] {
  let slide = list[(partitionNumber * partitionSize)..<((partitionNumber + 1) * partitionSize)]
  return [Int](slide)
}
