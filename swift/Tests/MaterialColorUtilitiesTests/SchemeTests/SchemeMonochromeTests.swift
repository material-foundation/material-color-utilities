// Copyright 2024 Google LLC
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

final class SchemeMonochromeTests: XCTestCase {
  func testKeyColors() {
    let scheme = SchemeMonochrome(
      sourceColorHct: Hct(0xff00_00ff), isDark: false, contrastLevel: 0.0)

    XCTAssertEqual(scheme.primaryPaletteKeyColor, 0xff77_7777)
    XCTAssertEqual(scheme.secondaryPaletteKeyColor, 0xff77_7777)
    XCTAssertEqual(scheme.tertiaryPaletteKeyColor, 0xff77_7777)
    XCTAssertEqual(scheme.neutralPaletteKeyColor, 0xff77_7777)
    XCTAssertEqual(scheme.neutralVariantPaletteKeyColor, 0xff77_7777)
  }

  func testLightTheme_minContrast_primary() {
    let scheme = SchemeMonochrome(
      sourceColorHct: Hct(0xff00_00ff), isDark: false, contrastLevel: -1)
    XCTAssertEqual(scheme.primary, 0xff74_7474)
  }

  func testLightTheme_standardContrast_primary() {
    let scheme = SchemeMonochrome(
      sourceColorHct: Hct(0xff00_00ff), isDark: false, contrastLevel: 0.0)
    XCTAssertEqual(scheme.primary, 0xff00_0000)
  }

  func testLightTheme_maxContrast_primary() {
    let scheme = SchemeMonochrome(sourceColorHct: Hct(0xff00_00ff), isDark: false, contrastLevel: 1)
    XCTAssertEqual(scheme.primary, 0xff00_0000)
  }

  func testLightTheme_minContrast_primaryContainer() {
    let scheme = SchemeMonochrome(
      sourceColorHct: Hct(0xff00_00ff), isDark: false, contrastLevel: -1)
    XCTAssertEqual(scheme.primaryContainer, 0xffd9_d9d9)
  }

  func testLightTheme_standardContrast_primaryContainer() {
    let scheme = SchemeMonochrome(
      sourceColorHct: Hct(0xff00_00ff), isDark: false, contrastLevel: 0.0)
    XCTAssertEqual(scheme.primaryContainer, 0xff3b_3b3b)
  }

  func testLightTheme_maxContrast_primaryContainer() {
    let scheme = SchemeMonochrome(sourceColorHct: Hct(0xff00_00ff), isDark: false, contrastLevel: 1)
    XCTAssertEqual(scheme.primaryContainer, 0xff3b_3b3b)
  }

  func testLightTheme_minContrast_onPrimaryContainer() {
    let scheme = SchemeMonochrome(
      sourceColorHct: Hct(0xff00_00ff), isDark: false, contrastLevel: -1)
    XCTAssertEqual(scheme.onPrimaryContainer, 0xff7a_7a7a)
  }

  func testLightTheme_standardContrast_onPrimaryContainer() {
    let scheme = SchemeMonochrome(
      sourceColorHct: Hct(0xff00_00ff), isDark: false, contrastLevel: 0.0)
    XCTAssertEqual(scheme.onPrimaryContainer, 0xffff_ffff)
  }

  func testLightTheme_maxContrast_onPrimaryContainer() {
    let scheme = SchemeMonochrome(sourceColorHct: Hct(0xff00_00ff), isDark: false, contrastLevel: 1)
    XCTAssertEqual(scheme.onPrimaryContainer, 0xffff_ffff)
  }

  func testLightTheme_minContrast_surface() {
    let scheme = SchemeMonochrome(
      sourceColorHct: Hct(0xff00_00ff), isDark: false, contrastLevel: -1)
    XCTAssertEqual(scheme.surface, 0xfff9_f9f9)
  }

  func testLightTheme_standardContrast_surface() {
    let scheme = SchemeMonochrome(
      sourceColorHct: Hct(0xff00_00ff), isDark: false, contrastLevel: 0.0)
    XCTAssertEqual(scheme.surface, 0xfff9_f9f9)
  }

  func testLightTheme_maxContrast_surface() {
    let scheme = SchemeMonochrome(sourceColorHct: Hct(0xff00_00ff), isDark: false, contrastLevel: 1)
    XCTAssertEqual(scheme.surface, 0xfff9_f9f9)
  }

  func testDarkTheme_minContrast_primary() {
    let scheme = SchemeMonochrome(sourceColorHct: Hct(0xff00_00ff), isDark: true, contrastLevel: -1)
    XCTAssertEqual(scheme.primary, 0xff91_9191)
  }

  func testDarkTheme_standardContrast_primary() {
    let scheme = SchemeMonochrome(
      sourceColorHct: Hct(0xff00_00ff), isDark: true, contrastLevel: 0.0)
    XCTAssertEqual(scheme.primary, 0xffff_ffff)
  }

  func testDarkTheme_maxContrast_primary() {
    let scheme = SchemeMonochrome(sourceColorHct: Hct(0xff00_00ff), isDark: true, contrastLevel: 1)
    XCTAssertEqual(scheme.primary, 0xffff_ffff)
  }

  func testDarkTheme_minContrast_primaryContainer() {
    let scheme = SchemeMonochrome(sourceColorHct: Hct(0xff00_00ff), isDark: true, contrastLevel: -1)
    XCTAssertEqual(scheme.primaryContainer, 0xff3a_3a3a)
  }

  func testDarkTheme_standardContrast_primaryContainer() {
    let scheme = SchemeMonochrome(
      sourceColorHct: Hct(0xff00_00ff), isDark: true, contrastLevel: 0.0)
    XCTAssertEqual(scheme.primaryContainer, 0xffd4_d4d4)
  }

  func testDarkTheme_maxContrast_primaryContainer() {
    let scheme = SchemeMonochrome(sourceColorHct: Hct(0xff00_00ff), isDark: true, contrastLevel: 1)
    XCTAssertEqual(scheme.primaryContainer, 0xffd4_d4d4)
  }

  func testDarkTheme_minContrast_onPrimaryContainer() {
    let scheme = SchemeMonochrome(sourceColorHct: Hct(0xff00_00ff), isDark: true, contrastLevel: -1)
    XCTAssertEqual(scheme.onPrimaryContainer, 0xff84_8484)
  }

  func testDarkTheme_standardContrast_onPrimaryContainer() {
    let scheme = SchemeMonochrome(
      sourceColorHct: Hct(0xff00_00ff), isDark: true, contrastLevel: 0.0)
    XCTAssertEqual(scheme.onPrimaryContainer, 0xff00_0000)
  }

  func testDarkTheme_maxContrast_onPrimaryContainer() {
    let scheme = SchemeMonochrome(sourceColorHct: Hct(0xff00_00ff), isDark: true, contrastLevel: 1)
    XCTAssertEqual(scheme.onPrimaryContainer, 0xff00_0000)
  }

  func testDarkTheme_minContrast_onTertiaryContainer() {
    let scheme = SchemeMonochrome(sourceColorHct: Hct(0xff00_00ff), isDark: true, contrastLevel: -1)
    XCTAssertEqual(scheme.onTertiaryContainer, 0xff84_8484)
  }

  func testDarkTheme_standardContrast_onTertiaryContainer() {
    let scheme = SchemeMonochrome(
      sourceColorHct: Hct(0xff00_00ff), isDark: true, contrastLevel: 0.0)
    XCTAssertEqual(scheme.onTertiaryContainer, 0xff00_0000)
  }

  func testDarkTheme_maxContrast_onTertiaryContainer() {
    let scheme = SchemeMonochrome(sourceColorHct: Hct(0xff00_00ff), isDark: true, contrastLevel: 1)
    XCTAssertEqual(scheme.onTertiaryContainer, 0xff00_0000)
  }

  func testDarkTheme_minContrast_surface() {
    let scheme = SchemeMonochrome(sourceColorHct: Hct(0xff00_00ff), isDark: true, contrastLevel: -1)
    XCTAssertEqual(scheme.surface, 0xff13_1313)
  }

  func testDarkTheme_standardContrast_surface() {
    let scheme = SchemeMonochrome(
      sourceColorHct: Hct(0xff00_00ff), isDark: true, contrastLevel: 0.0)
    XCTAssertEqual(scheme.surface, 0xff13_1313)
  }

  func testDarkTheme_maxContrast_surface() {
    let scheme = SchemeMonochrome(sourceColorHct: Hct(0xff00_00ff), isDark: true, contrastLevel: 1)
    XCTAssertEqual(scheme.surface, 0xff13_1313)
  }

  func testDarkTheme_monochromeSpec() {
    let scheme = SchemeMonochrome(
      sourceColorHct: Hct(0xff00_00ff), isDark: true, contrastLevel: 0.0)
    XCTAssertEqual(MaterialDynamicColors.primary.getHct(scheme).tone, 100, accuracy: 0.3)
    XCTAssertEqual(MaterialDynamicColors.onPrimary.getHct(scheme).tone, 10, accuracy: 0.3)
    XCTAssertEqual(MaterialDynamicColors.primaryContainer.getHct(scheme).tone, 85, accuracy: 0.3)
    XCTAssertEqual(MaterialDynamicColors.onPrimaryContainer.getHct(scheme).tone, 0, accuracy: 0.3)
    XCTAssertEqual(MaterialDynamicColors.secondary.getHct(scheme).tone, 80, accuracy: 0.3)
    XCTAssertEqual(MaterialDynamicColors.onSecondary.getHct(scheme).tone, 10, accuracy: 0.3)
    XCTAssertEqual(MaterialDynamicColors.secondaryContainer.getHct(scheme).tone, 30, accuracy: 0.3)
    XCTAssertEqual(
      MaterialDynamicColors.onSecondaryContainer.getHct(scheme).tone, 90, accuracy: 0.3)
    XCTAssertEqual(MaterialDynamicColors.tertiary.getHct(scheme).tone, 90, accuracy: 0.3)
    XCTAssertEqual(MaterialDynamicColors.onTertiary.getHct(scheme).tone, 10, accuracy: 0.3)
    XCTAssertEqual(MaterialDynamicColors.tertiaryContainer.getHct(scheme).tone, 60, accuracy: 0.3)
    XCTAssertEqual(
      MaterialDynamicColors.onTertiaryContainer.getHct(scheme).tone, 0, accuracy: 0.3)
  }

  func testLightTheme_monochromeSpec() {
    let scheme = SchemeMonochrome(
      sourceColorHct: Hct(0xff00_00ff), isDark: false, contrastLevel: 0.0)
    XCTAssertEqual(MaterialDynamicColors.primary.getHct(scheme).tone, 0, accuracy: 0.3)
    XCTAssertEqual(MaterialDynamicColors.onPrimary.getHct(scheme).tone, 90, accuracy: 0.3)
    XCTAssertEqual(MaterialDynamicColors.primaryContainer.getHct(scheme).tone, 25, accuracy: 0.3)
    XCTAssertEqual(
      MaterialDynamicColors.onPrimaryContainer.getHct(scheme).tone, 100, accuracy: 0.3)
    XCTAssertEqual(MaterialDynamicColors.secondary.getHct(scheme).tone, 40, accuracy: 0.3)
    XCTAssertEqual(MaterialDynamicColors.onSecondary.getHct(scheme).tone, 100, accuracy: 0.3)
    XCTAssertEqual(
      MaterialDynamicColors.secondaryContainer.getHct(scheme).tone, 85, accuracy: 0.3)
    XCTAssertEqual(
      MaterialDynamicColors.onSecondaryContainer.getHct(scheme).tone, 10, accuracy: 0.3)
    XCTAssertEqual(MaterialDynamicColors.tertiary.getHct(scheme).tone, 25, accuracy: 0.3)
    XCTAssertEqual(MaterialDynamicColors.onTertiary.getHct(scheme).tone, 90, accuracy: 0.3)
    XCTAssertEqual(MaterialDynamicColors.tertiaryContainer.getHct(scheme).tone, 49, accuracy: 0.3)
    XCTAssertEqual(
      MaterialDynamicColors.onTertiaryContainer.getHct(scheme).tone, 100, accuracy: 0.3)
  }

  func testSchemeMonochromeProvider_returnsIdeniticalSchemeWithSameSourceColor() {
    let sourceColorHct = Hct(0xfffa_2bec)
    let isDark = false
    let contrastLevel = 0.0

    let scheme = SchemeMonochrome(
      sourceColorHct: sourceColorHct, isDark: isDark, contrastLevel: contrastLevel)
    let provider = SchemeMonochromeProvider(sourceColorHct: sourceColorHct)
    let schemeByProvider = provider.scheme(isDark: isDark, contrastLevel: contrastLevel)

    XCTAssertEqual(scheme, schemeByProvider)
  }

  func testSchemeMonochromeProvider_reusesTonalPalettes() {
    let provider = SchemeMonochromeProvider(sourceColorHct: Hct(0xfffa_2bec))

    let scheme1 = provider.scheme(isDark: true, contrastLevel: 0.0)
    let scheme2 = provider.scheme(isDark: false, contrastLevel: 1.0)

    // Check if the same tonal palettes are being reused
    XCTAssertIdentical(scheme1.primaryPalette, scheme2.primaryPalette)
    XCTAssertIdentical(scheme1.secondaryPalette, scheme2.secondaryPalette)
    XCTAssertIdentical(scheme1.tertiaryPalette, scheme2.tertiaryPalette)
    XCTAssertIdentical(scheme1.neutralPalette, scheme2.neutralPalette)
    XCTAssertIdentical(scheme1.neutralVariantPalette, scheme2.neutralVariantPalette)
  }
}
