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
import XCTest

@testable import MaterialColorUtilities

final class DynamicColorTests: XCTestCase {
  let seedColors = [
    Hct.fromInt(0xFFFF_0000),
    Hct.fromInt(0xFFFF_FF00),
    Hct.fromInt(0xFF00_FF00),
    Hct.fromInt(0xFF00_00FF),
  ]

  let contrastLevels: [Double] = [-1, -0.5, 0, 0.5, 1]

  let red = Hct.fromInt(0xFFFF_0000)

  private let _colors: [String: DynamicColor] = [
    "background": MaterialDynamicColors.background,
    "onBackground": MaterialDynamicColors.onBackground,
    "surface": MaterialDynamicColors.surface,
    "surfaceDim": MaterialDynamicColors.surfaceDim,
    "surfaceBright": MaterialDynamicColors.surfaceBright,
    "surfaceContainerLowest": MaterialDynamicColors.surfaceContainerLowest,
    "surfaceContainerLow": MaterialDynamicColors.surfaceContainerLow,
    "surfaceContainer": MaterialDynamicColors.surfaceContainer,
    "surfaceContainerHigh": MaterialDynamicColors.surfaceContainerHigh,
    "surfaceContainerHighest": MaterialDynamicColors.surfaceContainerHighest,
    "onSurface": MaterialDynamicColors.onSurface,
    "surfaceVariant": MaterialDynamicColors.surfaceVariant,
    "onSurfaceVariant": MaterialDynamicColors.onSurfaceVariant,
    "inverseSurface": MaterialDynamicColors.inverseSurface,
    "inverseOnSurface": MaterialDynamicColors.inverseOnSurface,
    "outline": MaterialDynamicColors.outline,
    "outlineVariant": MaterialDynamicColors.outlineVariant,
    "shadow": MaterialDynamicColors.shadow,
    "scrim": MaterialDynamicColors.scrim,
    "surfaceTint": MaterialDynamicColors.surfaceTint,
    "primary": MaterialDynamicColors.primary,
    "onPrimary": MaterialDynamicColors.onPrimary,
    "primaryContainer": MaterialDynamicColors.primaryContainer,
    "onPrimaryContainer": MaterialDynamicColors.onPrimaryContainer,
    "inversePrimary": MaterialDynamicColors.inversePrimary,
    "secondary": MaterialDynamicColors.secondary,
    "onSecondary": MaterialDynamicColors.onSecondary,
    "secondaryContainer": MaterialDynamicColors.secondaryContainer,
    "onSecondaryContainer": MaterialDynamicColors.onSecondaryContainer,
    "tertiary": MaterialDynamicColors.tertiary,
    "onTertiary": MaterialDynamicColors.onTertiary,
    "tertiaryContainer": MaterialDynamicColors.tertiaryContainer,
    "onTertiaryContainer": MaterialDynamicColors.onTertiaryContainer,
    "error": MaterialDynamicColors.error,
    "onError": MaterialDynamicColors.onError,
    "errorContainer": MaterialDynamicColors.errorContainer,
    "onErrorContainer": MaterialDynamicColors.onErrorContainer,
  ]

  private let _textSurfacePairs = [
    _Pair("onPrimary", "primary"),
    _Pair("onPrimaryContainer", "primaryContainer"),
    _Pair("onSecondary", "secondary"),
    _Pair("onSecondaryContainer", "secondaryContainer"),
    _Pair("onTertiary", "tertiary"),
    _Pair("onTertiaryContainer", "tertiaryContainer"),
    _Pair("onError", "error"),
    _Pair("onErrorContainer", "errorContainer"),
    _Pair("onBackground", "background"),
    _Pair("onSurfaceVariant", "surfaceBright"),
    _Pair("onSurfaceVariant", "surfaceDim"),
  ]

  // Parametric test, ensuring that dynamic schemes respect contrast
  // between text-surface pairs.

  func testContrastPairs() {
    for color in seedColors {
      for contrastLevel in contrastLevels {
        for isDark in [false, true] {
          for scheme in [
            SchemeContent(
              sourceColorHct: color,
              isDark: isDark,
              contrastLevel: contrastLevel),
            SchemeMonochrome(
              sourceColorHct: color,
              isDark: isDark,
              contrastLevel: contrastLevel),
            SchemeTonalSpot(
              sourceColorHct: color,
              isDark: isDark,
              contrastLevel: contrastLevel),
            SchemeFidelity(
              sourceColorHct: color,
              isDark: isDark,
              contrastLevel: contrastLevel),
          ] {
            print(
              "Scheme: \(scheme); Seed color: \(color); Contrast level: \(contrastLevel); Dark: \(isDark)"
            )
            for pair in _textSurfacePairs {
              // Expect that each text-surface pair has a
              // minimum contrast of 4.5 (unreduced contrast), or 3.0
              // (reduced contrast).
              let fgName = pair.fgName
              let bgName = pair.bgName
              let foregroundTone = _colors[fgName]!.getHct(scheme).tone
              let backgroundTone = _colors[bgName]!.getHct(scheme).tone
              let contrast = Contrast.ratioOfTones(foregroundTone, backgroundTone)

              let minimumRequirement: Double = contrastLevel >= 0 ? 4.5 : 3

              XCTAssertTrue(
                contrast >= minimumRequirement,
                "Contrast \(contrast) is too low between foreground (\(fgName); \(foregroundTone)) and (\(bgName); \(backgroundTone))"
              )
            }
          }
        }
      }
    }
  }

  // Tests for fixed colors.
  func testFixedColorsInNonMonochromeSchemes() {
    let scheme = SchemeTonalSpot(
      sourceColorHct: Hct.fromInt(0xFFFF_0000),
      isDark: true,
      contrastLevel: 0.0
    )

    XCTAssertEqual(MaterialDynamicColors.primaryFixed.getHct(scheme).tone, 90, accuracy: 1)
    XCTAssertEqual(MaterialDynamicColors.primaryFixedDim.getHct(scheme).tone, 80, accuracy: 1)
    XCTAssertEqual(MaterialDynamicColors.onPrimaryFixed.getHct(scheme).tone, 10, accuracy: 1)
    XCTAssertEqual(MaterialDynamicColors.onPrimaryFixedVariant.getHct(scheme).tone, 30, accuracy: 1)
    XCTAssertEqual(MaterialDynamicColors.secondaryFixed.getHct(scheme).tone, 90, accuracy: 1)
    XCTAssertEqual(MaterialDynamicColors.secondaryFixedDim.getHct(scheme).tone, 80, accuracy: 1)
    XCTAssertEqual(MaterialDynamicColors.onSecondaryFixed.getHct(scheme).tone, 10, accuracy: 1)
    XCTAssertEqual(
      MaterialDynamicColors.onSecondaryFixedVariant.getHct(scheme).tone, 30, accuracy: 1)
    XCTAssertEqual(MaterialDynamicColors.tertiaryFixed.getHct(scheme).tone, 90, accuracy: 1)
    XCTAssertEqual(MaterialDynamicColors.tertiaryFixedDim.getHct(scheme).tone, 80, accuracy: 1)
    XCTAssertEqual(MaterialDynamicColors.onTertiaryFixed.getHct(scheme).tone, 10, accuracy: 1)
    XCTAssertEqual(
      MaterialDynamicColors.onTertiaryFixedVariant.getHct(scheme).tone, 30, accuracy: 1)
  }

  func testFixedColorsInLightMonochromeSchemes() {
    let scheme = SchemeMonochrome(
      sourceColorHct: Hct.fromInt(0xFFFF_0000),
      isDark: false,
      contrastLevel: 0.0
    )

    XCTAssertEqual(MaterialDynamicColors.primaryFixed.getHct(scheme).tone, 40, accuracy: 1)
    XCTAssertEqual(MaterialDynamicColors.primaryFixedDim.getHct(scheme).tone, 30, accuracy: 1)
    XCTAssertEqual(MaterialDynamicColors.onPrimaryFixed.getHct(scheme).tone, 100, accuracy: 1)
    XCTAssertEqual(MaterialDynamicColors.onPrimaryFixedVariant.getHct(scheme).tone, 90, accuracy: 1)
    XCTAssertEqual(MaterialDynamicColors.secondaryFixed.getHct(scheme).tone, 80, accuracy: 1)
    XCTAssertEqual(MaterialDynamicColors.secondaryFixedDim.getHct(scheme).tone, 70, accuracy: 1)
    XCTAssertEqual(MaterialDynamicColors.onSecondaryFixed.getHct(scheme).tone, 10, accuracy: 1)
    XCTAssertEqual(
      MaterialDynamicColors.onSecondaryFixedVariant.getHct(scheme).tone, 25, accuracy: 1)
    XCTAssertEqual(MaterialDynamicColors.tertiaryFixed.getHct(scheme).tone, 40, accuracy: 1)
    XCTAssertEqual(MaterialDynamicColors.tertiaryFixedDim.getHct(scheme).tone, 30, accuracy: 1)
    XCTAssertEqual(MaterialDynamicColors.onTertiaryFixed.getHct(scheme).tone, 100, accuracy: 1)
    XCTAssertEqual(
      MaterialDynamicColors.onTertiaryFixedVariant.getHct(scheme).tone, 90, accuracy: 1)
  }

  func testFixedColorsInDarkMonochromeSchemes() {
    let scheme = SchemeMonochrome(
      sourceColorHct: Hct.fromInt(0xFFFF_0000),
      isDark: true,
      contrastLevel: 0.0
    )

    XCTAssertEqual(MaterialDynamicColors.primaryFixed.getHct(scheme).tone, 40, accuracy: 1)
    XCTAssertEqual(MaterialDynamicColors.primaryFixedDim.getHct(scheme).tone, 30, accuracy: 1)
    XCTAssertEqual(MaterialDynamicColors.onPrimaryFixed.getHct(scheme).tone, 100, accuracy: 1)
    XCTAssertEqual(MaterialDynamicColors.onPrimaryFixedVariant.getHct(scheme).tone, 90, accuracy: 1)
    XCTAssertEqual(MaterialDynamicColors.secondaryFixed.getHct(scheme).tone, 80, accuracy: 1)
    XCTAssertEqual(MaterialDynamicColors.secondaryFixedDim.getHct(scheme).tone, 70, accuracy: 1)
    XCTAssertEqual(MaterialDynamicColors.onSecondaryFixed.getHct(scheme).tone, 10, accuracy: 1)
    XCTAssertEqual(
      MaterialDynamicColors.onSecondaryFixedVariant.getHct(scheme).tone, 25, accuracy: 1)
    XCTAssertEqual(MaterialDynamicColors.tertiaryFixed.getHct(scheme).tone, 40, accuracy: 1)
    XCTAssertEqual(MaterialDynamicColors.tertiaryFixedDim.getHct(scheme).tone, 30, accuracy: 1)
    XCTAssertEqual(MaterialDynamicColors.onTertiaryFixed.getHct(scheme).tone, 100, accuracy: 1)
    XCTAssertEqual(
      MaterialDynamicColors.onTertiaryFixedVariant.getHct(scheme).tone, 90, accuracy: 1)
  }
}

private class _Pair {
  let fgName: String
  let bgName: String

  init(_ fgName: String, _ bgName: String) {
    self.fgName = fgName
    self.bgName = bgName
  }
}
