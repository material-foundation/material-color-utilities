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

import Foundation
import XCTest

@testable import MaterialColorUtilities

/// Checks that the quantizers return exactly what the frozen copy of the previous implementation in
/// `ReferenceQuantizers.swift` returns: the same colors, with the same counts.
///
/// The results are `Dictionary`s, which have no fixed order, so they are compared as maps.
///
/// Inputs for which both implementations stop with a runtime error (a negative `maxColors`, or a
/// `maxColors` of 0 for a non-empty image) cannot be tested with XCTest. Neither can inputs for
/// which both never return: see `randomClustersCanBePicked`.
final class QuantizerEquivalenceTests: XCTestCase {
  /// Whether `QuantizerWsmeans` can pick the random clusters that it needs. If it cannot, both
  /// implementations loop forever.
  ///
  /// The clusters that are added to the starting clusters are distinct colors at random indices.
  /// The random number generator only returns numbers below 2^63, so `Int.random(in: 0..<n)` only
  /// returns indices below (n + 1) / 2.
  private static func randomClustersCanBePicked(
    startingClusterCount: Int, maxColors: Int, pixels: [Int]
  ) -> Bool {
    let distinctColorCount = Set(pixels).count
    let additionalClusterCount = min(maxColors, distinctColorCount) - startingClusterCount
    return additionalClusterCount <= (distinctColorCount + 1) / 2
  }

  /// A small seeded random number generator (SplitMix64), so that the test is reproducible.
  private struct SeededRandom {
    var state: UInt64

    mutating func next() -> UInt64 {
      state = state &+ 0x9E37_79B9_7F4A_7C15
      var z = state
      z = (z ^ (z >> 30)) &* 0xBF58_476D_1CE4_E5B9
      z = (z ^ (z >> 27)) &* 0x94D0_49BB_1331_11EB
      return z ^ (z >> 31)
    }

    mutating func nextInt(_ bound: Int) -> Int {
      return Int(next() % UInt64(bound))
    }
  }

  private enum ImageKind: CaseIterable {
    /// Opaque random colors, almost all distinct.
    case noise
    /// Random colors with random alpha.
    case noiseWithAlpha
    /// Random colors from a palette of 12.
    case palette
    /// Smooth gradients with some noise, like a photo.
    case photo
    /// Black and white pixels.
    case blackAndWhite
    /// Gray pixels.
    case gray
    /// Colors as negative numbers (sign-extended 32-bit ARGB) and numbers above 32 bits.
    case unusualInts
  }

  private static func image(
    _ kind: ImageKind, width: Int, height: Int, random: inout SeededRandom
  ) -> [Int] {
    var pixels: [Int] = []
    pixels.reserveCapacity(width * height)
    let palette = (0..<12).map { _ in 0xff00_0000 | random.nextInt(0x100_0000) }
    let phases = (0..<6).map { _ in Double(random.nextInt(1000)) / 100 }
    for y in 0..<height {
      for x in 0..<width {
        switch kind {
        case .noise:
          pixels.append(0xff00_0000 | random.nextInt(0x100_0000))
        case .noiseWithAlpha:
          pixels.append(random.nextInt(0x1_0000_0000))
        case .palette:
          pixels.append(palette[random.nextInt(palette.count)])
        case .photo:
          func channel(_ i: Int) -> Int {
            let wave =
              sin(Double(x) / 9 + phases[i]) * 80 + cos(Double(y) / 13 + phases[i + 3]) * 60
            let value = 128 + Int(wave) + random.nextInt(17) - 8
            return min(max(value, 0), 255)
          }
          pixels.append(ColorUtils.argbFromRgb(channel(0), channel(1), channel(2)))
        case .blackAndWhite:
          pixels.append((x + y) % 2 == 0 ? 0xff00_0000 : 0xffff_ffff)
        case .gray:
          let value = random.nextInt(256)
          pixels.append(ColorUtils.argbFromRgb(value, value, value))
        case .unusualInts:
          let argb = UInt32(truncatingIfNeeded: random.nextInt(0x1_0000_0000))
          pixels.append(
            random.nextInt(2) == 0
              ? Int(Int32(bitPattern: argb)) : Int(argb) | (random.nextInt(4) << 32))
        }
      }
    }
    return pixels
  }

  /// Images of every kind and several sizes, including empty and single-pixel images.
  private static let images: [(name: String, pixels: [Int])] = {
    var random = SeededRandom(state: 0x42688)
    var images: [(name: String, pixels: [Int])] = [("empty", [])]
    let sizes = [(1, 1), (2, 3), (24, 20)]
    for kind in ImageKind.allCases {
      for (width, height) in sizes {
        images.append(
          ("\(kind) \(width)x\(height)", image(kind, width: width, height: height, random: &random))
        )
      }
    }
    // An image as large as the 128 px images that QuantizerCelebi is usually given.
    images.append(("photo 128x96", image(.photo, width: 128, height: 96, random: &random)))
    return images
  }()

  private func assertSame(
    _ actual: QuantizerResult, _ expected: QuantizerResult, _ message: String,
    file: StaticString = #filePath, line: UInt = #line
  ) {
    XCTAssertEqual(actual.colorToCount, expected.colorToCount, message, file: file, line: line)
    XCTAssertEqual(
      actual.inputPixelToClusterPixel, expected.inputPixelToClusterPixel, message, file: file,
      line: line)
  }

  func testQuantizerCelebiMatchesReference() {
    for image in Self.images {
      let maxColorsList = image.pixels.count > 5000 ? [128] : [1, 2, 7, 16, 128, 256]
      for maxColors in maxColorsList {
        let wuColorCount = ReferenceQuantizerWu().quantize(image.pixels, maxColors).colorToCount
          .count
        if !Self.randomClustersCanBePicked(
          startingClusterCount: wuColorCount, maxColors: maxColors, pixels: image.pixels)
        {
          continue
        }
        assertSame(
          QuantizerCelebi().quantize(image.pixels, maxColors),
          ReferenceQuantizerCelebi().quantize(image.pixels, maxColors),
          "\(image.name), maxColors \(maxColors)")
      }
    }
  }

  func testQuantizerCelebiMatchesReferenceForEmptyImage() {
    // A `maxColors` of 0 stops with an index out of range in `QuantizerWu`, in both.
    for maxColors in [1, 128] {
      assertSame(
        QuantizerCelebi().quantize([], maxColors, returnInputPixelToClusterPixel: true),
        ReferenceQuantizerCelebi().quantize([], maxColors, returnInputPixelToClusterPixel: true),
        "maxColors \(maxColors)")
    }
  }

  func testQuantizerWuMatchesReference() {
    for image in Self.images {
      for maxColors in [2, 16, 128] {
        assertSame(
          QuantizerWu().quantize(image.pixels, maxColors),
          ReferenceQuantizerWu().quantize(image.pixels, maxColors),
          "\(image.name), maxColors \(maxColors)")
      }
    }
  }

  func testQuantizerMapMatchesReference() {
    for image in Self.images {
      assertSame(
        QuantizerMap().quantize(image.pixels, 128),
        ReferenceQuantizerMap().quantize(image.pixels, 128), image.name)
    }
  }

  func testQuantizerWsmeansMatchesReferenceWithAnyStartingClusters() {
    var random = SeededRandom(state: 7)
    for image in Self.images where image.pixels.count <= 5000 {
      let wuClusters = ReferenceQuantizerWu().quantize(image.pixels, 128).colorToCount.keys
        .sorted(by: >)
      let randomClusters = (0..<20).map { _ in 0xff00_0000 | random.nextInt(0x100_0000) }
      let startingClustersList: [(name: String, clusters: [Int])] = [
        ("Wu clusters", wuClusters),
        ("no starting clusters", []),
        ("random clusters", randomClusters),
        ("duplicate clusters", Array(randomClusters.prefix(5) + randomClusters.prefix(5))),
        ("one cluster", [0xff80_8080]),
        ("more clusters than colors", randomClusters + randomClusters),
      ]
      for (name, startingClusters) in startingClustersList {
        for maxColors in [3, 128] {
          // More and fewer iterations than the default of 5, for one image.
          let maxIterationsList = image.name == "photo 24x20" ? [1, 5, 100] : [5]
          for maxIterations in maxIterationsList {
            let message =
              "\(image.name), \(name), maxColors \(maxColors), \(maxIterations) iterations"
            if !Self.randomClustersCanBePicked(
              startingClusterCount: startingClusters.count, maxColors: maxColors,
              pixels: image.pixels)
            {
              continue
            }
            if image.pixels.isEmpty {
              // Both return an empty result without using the clusters.
              assertSame(
                QuantizerWsmeans.quantize(
                  image.pixels, maxColors, startingClusters: startingClusters),
                ReferenceQuantizerWsmeans.quantize(
                  image.pixels, maxColors, startingClusters: startingClusters), message)
              continue
            }
            assertSame(
              QuantizerWsmeans.quantize(
                image.pixels, maxColors, startingClusters: startingClusters,
                maxIterations: maxIterations, returnInputPixelToClusterPixel: true),
              ReferenceQuantizerWsmeans.quantize(
                image.pixels, maxColors, startingClusters: startingClusters,
                maxIterations: maxIterations, returnInputPixelToClusterPixel: true),
              message)
          }
        }
      }
    }
  }

  func testQuantizerWsmeansMatchesReferenceWithOtherPointProvider() throws {
    // A point provider that is not `PointProviderLab` takes the general code path.
    let pixels = try XCTUnwrap(Self.images.first { $0.name == "photo 24x20" }).pixels
    let startingClusters = ReferenceQuantizerWu().quantize(pixels, 16).colorToCount.keys
      .sorted(by: >)
    assertSame(
      QuantizerWsmeans.quantize(
        pixels, 16, startingClusters: startingClusters, pointProvider: ReferencePointProviderLab()),
      ReferenceQuantizerWsmeans.quantize(pixels, 16, startingClusters: startingClusters),
      "photo 24x20")
  }

  func testLabFromArgbMatchesColorUtilsForAllColors() {
    var lab = [Double](repeating: 0, count: 3)
    var mismatches = 0
    for rgb in 0..<0x100_0000 {
      let argb = 0xff00_0000 | rgb
      PointProviderLab.labFromArgb(argb, into: &lab, at: 0)
      let expected = ColorUtils.labFromArgb(argb)
      if lab[0].bitPattern != expected[0].bitPattern
        || lab[1].bitPattern != expected[1].bitPattern
        || lab[2].bitPattern != expected[2].bitPattern
      {
        mismatches += 1
      }
    }
    XCTAssertEqual(mismatches, 0)
  }
}
