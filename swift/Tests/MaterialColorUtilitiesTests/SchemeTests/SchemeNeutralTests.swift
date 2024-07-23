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

final class SchemeNeutralTests: XCTestCase {
  func testKeyColors() {
    let scheme = SchemeNeutral(sourceColorHct: Hct(0xff00_00ff), isDark: false, contrastLevel: 0.0)

    XCTAssertEqual(scheme.primaryPaletteKeyColor, 0xff76_7685)
    XCTAssertEqual(scheme.secondaryPaletteKeyColor, 0xff77_7680)
    XCTAssertEqual(scheme.tertiaryPaletteKeyColor, 0xff75_758B)
    XCTAssertEqual(scheme.neutralPaletteKeyColor, 0xff78_7678)
    XCTAssertEqual(scheme.neutralVariantPaletteKeyColor, 0xff78_7678)
  }

  func testLightTheme_minContrast_primary() {
    let scheme = SchemeNeutral(sourceColorHct: Hct(0xff00_00ff), isDark: false, contrastLevel: -1.0)
    XCTAssertEqual(scheme.primary, 0xff73_7383)
  }

  func testLightTheme_standardContrast_primary() {
    let scheme = SchemeNeutral(sourceColorHct: Hct(0xff00_00ff), isDark: false, contrastLevel: 0.0)
    XCTAssertEqual(scheme.primary, 0xff5d_5d6c)
  }

  func testLightTheme_maxContrast_primary() {
    let scheme = SchemeNeutral(sourceColorHct: Hct(0xff00_00ff), isDark: false, contrastLevel: 1.0)
    XCTAssertEqual(scheme.primary, 0xff2b_2b38)
  }

  func testLightTheme_minContrast_primaryContainer() {
    let scheme = SchemeNeutral(sourceColorHct: Hct(0xff00_00ff), isDark: false, contrastLevel: -1.0)
    XCTAssertEqual(scheme.primaryContainer, 0xffd9_d7e9)
  }

  func testLightTheme_standardContrast_primaryContainer() {
    let scheme = SchemeNeutral(sourceColorHct: Hct(0xff00_00ff), isDark: false, contrastLevel: 0.0)
    XCTAssertEqual(scheme.primaryContainer, 0xffe2_e1f3)
  }

  func testLightTheme_maxContrast_primaryContainer() {
    let scheme = SchemeNeutral(sourceColorHct: Hct(0xff00_00ff), isDark: false, contrastLevel: 1.0)
    XCTAssertEqual(scheme.primaryContainer, 0xff48_4856)
  }

  func testLightTheme_minContrast_onPrimaryContainer() {
    let scheme = SchemeNeutral(sourceColorHct: Hct(0xff00_00ff), isDark: false, contrastLevel: -1.0)
    XCTAssertEqual(scheme.onPrimaryContainer, 0xff79_7888)
  }

  func testLightTheme_standardContrast_onPrimaryContainer() {
    let scheme = SchemeNeutral(sourceColorHct: Hct(0xff00_00ff), isDark: false, contrastLevel: 0.0)
    XCTAssertEqual(scheme.onPrimaryContainer, 0xff45_4654)
  }

  func testLightTheme_maxContrast_onPrimaryContainer() {
    let scheme = SchemeNeutral(sourceColorHct: Hct(0xff00_00ff), isDark: false, contrastLevel: 1.0)
    XCTAssertEqual(scheme.onPrimaryContainer, 0xffff_ffff)
  }

  func testLightTheme_minContrast_surface() {
    let scheme = SchemeNeutral(sourceColorHct: Hct(0xff00_00ff), isDark: false, contrastLevel: -1.0)
    XCTAssertEqual(scheme.surface, 0xfffc_f8fa)
  }

  func testLightTheme_standardContrast_surface() {
    let scheme = SchemeNeutral(sourceColorHct: Hct(0xff00_00ff), isDark: false, contrastLevel: 0.0)
    XCTAssertEqual(scheme.surface, 0xfffc_f8fa)
  }

  func testLightTheme_maxContrast_surface() {
    let scheme = SchemeNeutral(sourceColorHct: Hct(0xff00_00ff), isDark: false, contrastLevel: 1.0)
    XCTAssertEqual(scheme.surface, 0xfffc_f8fa)
  }

  func testDarkTheme_minContrast_primary() {
    let scheme = SchemeNeutral(sourceColorHct: Hct(0xff00_00ff), isDark: true, contrastLevel: -1.0)
    XCTAssertEqual(scheme.primary, 0xff90_8f9f)
  }

  func testDarkTheme_standardContrast_primary() {
    let scheme = SchemeNeutral(sourceColorHct: Hct(0xff00_00ff), isDark: true, contrastLevel: 0.0)
    XCTAssertEqual(scheme.primary, 0xffc6_c5d6)
  }

  func testDarkTheme_maxContrast_primary() {
    let scheme = SchemeNeutral(sourceColorHct: Hct(0xff00_00ff), isDark: true, contrastLevel: 1.0)
    XCTAssertEqual(scheme.primary, 0xfff0_eeff)
  }

  func testDarkTheme_minContrast_primaryContainer() {
    let scheme = SchemeNeutral(sourceColorHct: Hct(0xff00_00ff), isDark: true, contrastLevel: -1.0)
    XCTAssertEqual(scheme.primaryContainer, 0xff39_3947)
  }

  func testDarkTheme_standardContrast_primaryContainer() {
    let scheme = SchemeNeutral(sourceColorHct: Hct(0xff00_00ff), isDark: true, contrastLevel: 0.0)
    XCTAssertEqual(scheme.primaryContainer, 0xff45_4654)
  }

  func testDarkTheme_maxContrast_primaryContainer() {
    let scheme = SchemeNeutral(sourceColorHct: Hct(0xff00_00ff), isDark: true, contrastLevel: 1.0)
    XCTAssertEqual(scheme.primaryContainer, 0xffc2_c1d2)
  }

  func testDarkTheme_minContrast_onPrimaryContainer() {
    let scheme = SchemeNeutral(sourceColorHct: Hct(0xff00_00ff), isDark: true, contrastLevel: -1.0)
    XCTAssertEqual(scheme.onPrimaryContainer, 0xff83_8393)
  }

  func testDarkTheme_standardContrast_onPrimaryContainer() {
    let scheme = SchemeNeutral(sourceColorHct: Hct(0xff00_00ff), isDark: true, contrastLevel: 0.0)
    XCTAssertEqual(scheme.onPrimaryContainer, 0xffe2_e1f3)
  }

  func testDarkTheme_maxContrast_onPrimaryContainer() {
    let scheme = SchemeNeutral(sourceColorHct: Hct(0xff00_00ff), isDark: true, contrastLevel: 1.0)
    XCTAssertEqual(scheme.onPrimaryContainer, 0xff09_0a16)
  }

  func testDarkTheme_minContrast_onTertiaryContainer() {
    let scheme = SchemeNeutral(sourceColorHct: Hct(0xff00_00ff), isDark: true, contrastLevel: -1.0)
    XCTAssertEqual(scheme.onTertiaryContainer, 0xff82_8299)
  }

  func testDarkTheme_standardContrast_onTertiaryContainer() {
    let scheme = SchemeNeutral(sourceColorHct: Hct(0xff00_00ff), isDark: true, contrastLevel: 0.0)
    XCTAssertEqual(scheme.onTertiaryContainer, 0xffe1_e0f9)
  }

  func testDarkTheme_maxContrast_onTertiaryContainer() {
    let scheme = SchemeNeutral(sourceColorHct: Hct(0xff00_00ff), isDark: true, contrastLevel: 1.0)
    XCTAssertEqual(scheme.onTertiaryContainer, 0xff08_0a1b)
  }

  func testDarkTheme_minContrast_surface() {
    let scheme = SchemeNeutral(sourceColorHct: Hct(0xff00_00ff), isDark: true, contrastLevel: -1.0)
    XCTAssertEqual(scheme.surface, 0xff13_1315)
  }

  func testDarkTheme_standardContrast_surface() {
    let scheme = SchemeNeutral(sourceColorHct: Hct(0xff00_00ff), isDark: true, contrastLevel: 0.0)
    XCTAssertEqual(scheme.surface, 0xff13_1315)
  }

  func testDarkTheme_maxContrast_surface() {
    let scheme = SchemeNeutral(sourceColorHct: Hct(0xff00_00ff), isDark: true, contrastLevel: 1.0)
    XCTAssertEqual(scheme.surface, 0xff13_1315)
  }

  func testSchemeNeutralProvider_returnsIdeniticalSchemeWithSameSourceColor() {
    let sourceColorHct = Hct(0xfffa_2bec)
    let isDark = false
    let contrastLevel = 0.0

    let scheme = SchemeNeutral(
      sourceColorHct: sourceColorHct, isDark: isDark, contrastLevel: contrastLevel)
    let provider = SchemeNeutralProvider(sourceColorHct: sourceColorHct)
    let schemeByProvider = provider.scheme(isDark: isDark, contrastLevel: contrastLevel)

    XCTAssertEqual(scheme, schemeByProvider)
  }

  func testSchemeNeutralProvider_reusesTonalPalettes() {
    let provider = SchemeNeutralProvider(sourceColorHct: Hct(0xfffa_2bec))

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
