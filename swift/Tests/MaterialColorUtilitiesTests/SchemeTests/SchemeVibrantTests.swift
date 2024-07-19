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

final class SchemeVibrantTests: XCTestCase {
  func testKeyColors() {
    let scheme = SchemeVibrant(sourceColorHct: Hct(0xff0000ff), isDark: false, contrastLevel: 0.0)

    XCTAssertEqual(scheme.primaryPaletteKeyColor, 0xff080CFF)
    XCTAssertEqual(scheme.secondaryPaletteKeyColor, 0xff7B7296)
    XCTAssertEqual(scheme.tertiaryPaletteKeyColor, 0xff886C9D)
    XCTAssertEqual(scheme.neutralPaletteKeyColor, 0xff777682)
    XCTAssertEqual(scheme.neutralVariantPaletteKeyColor, 0xff767685)
  }

  func testLightTheme_minContrast_primary() {
    let scheme = SchemeVibrant(sourceColorHct: Hct(0xff0000ff), isDark: false, contrastLevel: -1.0)
    XCTAssertEqual(scheme.primary, 0xff5660ff)
  }

  func testLightTheme_standardContrast_primary() {
    let scheme = SchemeVibrant(sourceColorHct: Hct(0xff0000ff), isDark: false, contrastLevel: 0.0)
    XCTAssertEqual(scheme.primary, 0xff343dff)
  }

  func testLightTheme_maxContrast_primary() {
    let scheme = SchemeVibrant(sourceColorHct: Hct(0xff0000ff), isDark: false, contrastLevel: 1.0)
    XCTAssertEqual(scheme.primary, 0xff00019f)
  }

  func testLightTheme_minContrast_primaryContainer() {
    let scheme = SchemeVibrant(sourceColorHct: Hct(0xff0000ff), isDark: false, contrastLevel: -1.0)
    XCTAssertEqual(scheme.primaryContainer, 0xffd5d6ff)
  }

  func testLightTheme_standardContrast_primaryContainer() {
    let scheme = SchemeVibrant(sourceColorHct: Hct(0xff0000ff), isDark: false, contrastLevel: 0.0)
    XCTAssertEqual(scheme.primaryContainer, 0xffe0e0ff)
  }

  func testLightTheme_maxContrast_primaryContainer() {
    let scheme = SchemeVibrant(sourceColorHct: Hct(0xff0000ff), isDark: false, contrastLevel: 1.0)
    XCTAssertEqual(scheme.primaryContainer, 0xff0000f6)
  }

  func testLightTheme_minContrast_onPrimaryContainer() {
    let scheme = SchemeVibrant(sourceColorHct: Hct(0xff0000ff), isDark: false, contrastLevel: -1.0)
    XCTAssertEqual(scheme.onPrimaryContainer, 0xff5e68ff)
  }

  func testLightTheme_standardContrast_onPrimaryContainer() {
    let scheme = SchemeVibrant(sourceColorHct: Hct(0xff0000ff), isDark: false, contrastLevel: 0.0)
    XCTAssertEqual(scheme.onPrimaryContainer, 0xff0000ef)
  }

  func testLightTheme_maxContrast_onPrimaryContainer() {
    let scheme = SchemeVibrant(sourceColorHct: Hct(0xff0000ff), isDark: false, contrastLevel: 1.0)
    XCTAssertEqual(scheme.onPrimaryContainer, 0xffffffff)
  }

  func testLightTheme_minContrast_surface() {
    let scheme = SchemeVibrant(sourceColorHct: Hct(0xff0000ff), isDark: false, contrastLevel: -1.0)
    XCTAssertEqual(scheme.surface, 0xfffbf8ff)
  }

  func testLightTheme_standardContrast_surface() {
    let scheme = SchemeVibrant(sourceColorHct: Hct(0xff0000ff), isDark: false, contrastLevel: 0.0)
    XCTAssertEqual(scheme.surface, 0xfffbf8ff)
  }

  func testLightTheme_maxContrast_surface() {
    let scheme = SchemeVibrant(sourceColorHct: Hct(0xff0000ff), isDark: false, contrastLevel: 1.0)
    XCTAssertEqual(scheme.surface, 0xfffbf8ff)
  }

  func testDarkTheme_minContrast_primary() {
    let scheme = SchemeVibrant(sourceColorHct: Hct(0xff0000ff), isDark: true, contrastLevel: -1.0)
    XCTAssertEqual(scheme.primary, 0xff7c84ff)
  }

  func testDarkTheme_standardContrast_primary() {
    let scheme = SchemeVibrant(sourceColorHct: Hct(0xff0000ff), isDark: true, contrastLevel: 0.0)
    XCTAssertEqual(scheme.primary, 0xffbec2ff)
  }

  func testDarkTheme_maxContrast_primary() {
    let scheme = SchemeVibrant(sourceColorHct: Hct(0xff0000ff), isDark: true, contrastLevel: 1.0)
    XCTAssertEqual(scheme.primary, 0xfff0eeff)
  }

  func testDarkTheme_minContrast_primaryContainer() {
    let scheme = SchemeVibrant(sourceColorHct: Hct(0xff0000ff), isDark: true, contrastLevel: -1.0)
    XCTAssertEqual(scheme.primaryContainer, 0xff0001c9)
  }

  func testDarkTheme_standardContrast_primaryContainer() {
    let scheme = SchemeVibrant(sourceColorHct: Hct(0xff0000ff), isDark: true, contrastLevel: 0.0)
    XCTAssertEqual(scheme.primaryContainer, 0xff0000ef)
  }

  func testDarkTheme_maxContrast_primaryContainer() {
    let scheme = SchemeVibrant(sourceColorHct: Hct(0xff0000ff), isDark: true, contrastLevel: 1.0)
    XCTAssertEqual(scheme.primaryContainer, 0xffbabdff)
  }

  func testDarkTheme_minContrast_onPrimaryContainer() {
    let scheme = SchemeVibrant(sourceColorHct: Hct(0xff0000ff), isDark: true, contrastLevel: -1.0)
    XCTAssertEqual(scheme.onPrimaryContainer, 0xff6b75ff)
  }

  func testDarkTheme_standardContrast_onPrimaryContainer() {
    let scheme = SchemeVibrant(sourceColorHct: Hct(0xff0000ff), isDark: true, contrastLevel: 0.0)
    XCTAssertEqual(scheme.onPrimaryContainer, 0xffe0e0ff)
  }

  func testDarkTheme_maxContrast_onPrimaryContainer() {
    let scheme = SchemeVibrant(sourceColorHct: Hct(0xff0000ff), isDark: true, contrastLevel: 1.0)
    XCTAssertEqual(scheme.onPrimaryContainer, 0xff00003d)
  }

  func testDarkTheme_minContrast_onTertiaryContainer() {
    let scheme = SchemeVibrant(sourceColorHct: Hct(0xff0000ff), isDark: true, contrastLevel: -1.0)
    XCTAssertEqual(scheme.onTertiaryContainer, 0xff9679ab)
  }

  func testDarkTheme_standardContrast_onTertiaryContainer() {
    let scheme = SchemeVibrant(sourceColorHct: Hct(0xff0000ff), isDark: true, contrastLevel: 0.0)
    XCTAssertEqual(scheme.onTertiaryContainer, 0xfff2daff)
  }

  func testDarkTheme_maxContrast_onTertiaryContainer() {
    let scheme = SchemeVibrant(sourceColorHct: Hct(0xff0000ff), isDark: true, contrastLevel: 1.0)
    XCTAssertEqual(scheme.onTertiaryContainer, 0xff16002a)
  }

  func testDarkTheme_minContrast_surface() {
    let scheme = SchemeVibrant(sourceColorHct: Hct(0xff0000ff), isDark: true, contrastLevel: -1.0)
    XCTAssertEqual(scheme.surface, 0xff12131c)
  }

  func testDarkTheme_standardContrast_surface() {
    let scheme = SchemeVibrant(sourceColorHct: Hct(0xff0000ff), isDark: true, contrastLevel: 0.0)
    XCTAssertEqual(scheme.surface, 0xff12131c)
  }

  func testDarkTheme_maxContrast_surface() {
    let scheme = SchemeVibrant(sourceColorHct: Hct(0xff0000ff), isDark: true, contrastLevel: 1.0)
    XCTAssertEqual(scheme.surface, 0xff12131c)
  }

  func testSchemeVibrantProvider_returnsIdeniticalSchemeWithSameSourceColor() {
    let sourceColorHct = Hct(0xfffa_2bec)
    let isDark = false
    let contrastLevel = 0.0

    let scheme = SchemeVibrant(
      sourceColorHct: sourceColorHct, isDark: isDark, contrastLevel: contrastLevel)
    let provider = SchemeVibrantProvider(sourceColorHct: sourceColorHct)
    let schemeByProvider = provider.scheme(isDark: isDark, contrastLevel: contrastLevel)

    XCTAssertEqual(scheme, schemeByProvider)
  }

  func testSchemeVibrantProvider_reusesTonalPalettes() {
    let provider = SchemeVibrantProvider(sourceColorHct: Hct(0xfffa_2bec))

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
