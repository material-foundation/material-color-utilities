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

final class SchemeRainbowTests: XCTestCase {
  func testKeyColors() {
    let scheme = SchemeRainbow(sourceColorHct: Hct(0xff00_00ff), isDark: false, contrastLevel: 0.0)

    XCTAssertEqual(scheme.primaryPaletteKeyColor, 0xff69_6FC4)
    XCTAssertEqual(scheme.secondaryPaletteKeyColor, 0xff75_758B)
    XCTAssertEqual(scheme.tertiaryPaletteKeyColor, 0xff93_6B84)
    XCTAssertEqual(scheme.neutralPaletteKeyColor, 0xff77_7777)
    XCTAssertEqual(scheme.neutralVariantPaletteKeyColor, 0xff77_7777)
  }

  func testLightTheme_minContrast_primary() {
    let scheme = SchemeRainbow(sourceColorHct: Hct(0xff00_00ff), isDark: false, contrastLevel: -1.0)
    XCTAssertEqual(scheme.primary, 0xff67_6DC1)
  }

  func testLightTheme_standardContrast_primary() {
    let scheme = SchemeRainbow(sourceColorHct: Hct(0xff00_00ff), isDark: false, contrastLevel: 0.0)
    XCTAssertEqual(scheme.primary, 0xff50_56A9)
  }

  func testLightTheme_maxContrast_primary() {
    let scheme = SchemeRainbow(sourceColorHct: Hct(0xff00_00ff), isDark: false, contrastLevel: 1.0)
    XCTAssertEqual(scheme.primary, 0xff1b_2074)
  }

  func testLightTheme_minContrast_primaryContainer() {
    let scheme = SchemeRainbow(sourceColorHct: Hct(0xff00_00ff), isDark: false, contrastLevel: -1.0)
    XCTAssertEqual(scheme.primaryContainer, 0xffd5_d6ff)
  }

  func testLightTheme_standardContrast_primaryContainer() {
    let scheme = SchemeRainbow(sourceColorHct: Hct(0xff00_00ff), isDark: false, contrastLevel: 0.0)
    XCTAssertEqual(scheme.primaryContainer, 0xffE0_E0FF)
  }

  func testLightTheme_maxContrast_primaryContainer() {
    let scheme = SchemeRainbow(sourceColorHct: Hct(0xff00_00ff), isDark: false, contrastLevel: 1.0)
    XCTAssertEqual(scheme.primaryContainer, 0xff3a_4092)
  }

  func testLightTheme_minContrast_tertiaryContainer() {
    let scheme = SchemeRainbow(sourceColorHct: Hct(0xff00_00ff), isDark: false, contrastLevel: -1.0)
    XCTAssertEqual(scheme.tertiaryContainer, 0xfffb_cbe7)
  }

  func testLightTheme_standardContrast_tertiaryContainer() {
    let scheme = SchemeRainbow(sourceColorHct: Hct(0xff00_00ff), isDark: false, contrastLevel: 0.0)
    XCTAssertEqual(scheme.tertiaryContainer, 0xffff_d8ee)
  }

  func testLightTheme_maxContrast_tertiaryContainer() {
    let scheme = SchemeRainbow(sourceColorHct: Hct(0xff00_00ff), isDark: false, contrastLevel: 1.0)
    XCTAssertEqual(scheme.tertiaryContainer, 0xff61_3e55)
  }

  func testLightTheme_minContrast_onPrimaryContainer() {
    let scheme = SchemeRainbow(sourceColorHct: Hct(0xff00_00ff), isDark: false, contrastLevel: -1.0)
    XCTAssertEqual(scheme.onPrimaryContainer, 0xff6c_72c7)
  }

  func testLightTheme_standardContrast_onPrimaryContainer() {
    let scheme = SchemeRainbow(sourceColorHct: Hct(0xff00_00ff), isDark: false, contrastLevel: 0.0)
    XCTAssertEqual(scheme.onPrimaryContainer, 0xff38_3e8f)
  }

  func testLightTheme_maxContrast_onPrimaryContainer() {
    let scheme = SchemeRainbow(sourceColorHct: Hct(0xff00_00ff), isDark: false, contrastLevel: 1.0)
    XCTAssertEqual(scheme.onPrimaryContainer, 0xffff_ffff)
  }

  func testLightTheme_minContrast_surface() {
    let scheme = SchemeRainbow(sourceColorHct: Hct(0xff00_00ff), isDark: false, contrastLevel: -1.0)
    XCTAssertEqual(scheme.surface, 0xfff9_f9f9)
  }

  func testLightTheme_standardContrast_surface() {
    let scheme = SchemeRainbow(sourceColorHct: Hct(0xff00_00ff), isDark: false, contrastLevel: 0.0)
    XCTAssertEqual(scheme.surface, 0xfff9_f9f9)
  }

  func testLightTheme_maxContrast_surface() {
    let scheme = SchemeRainbow(sourceColorHct: Hct(0xff00_00ff), isDark: false, contrastLevel: 1.0)
    XCTAssertEqual(scheme.surface, 0xfff9_f9f9)
  }

  func testLightTheme_standardContrast_secondary() {
    let scheme = SchemeRainbow(sourceColorHct: Hct(0xff00_00ff), isDark: false, contrastLevel: 0.0)
    XCTAssertEqual(scheme.secondary, 0xff5c_5d72)
  }

  func testLightTheme_standardContrast_secondaryContainer() {
    let scheme = SchemeRainbow(sourceColorHct: Hct(0xff00_00ff), isDark: false, contrastLevel: 0.0)
    XCTAssertEqual(scheme.secondaryContainer, 0xffe1_e0f9)
  }

  func testDarkTheme_minContrast_primary() {
    let scheme = SchemeRainbow(sourceColorHct: Hct(0xff00_00ff), isDark: true, contrastLevel: -1.0)
    XCTAssertEqual(scheme.primary, 0xff83_89e0)
  }

  func testDarkTheme_standardContrast_primary() {
    let scheme = SchemeRainbow(sourceColorHct: Hct(0xff00_00ff), isDark: true, contrastLevel: 0.0)
    XCTAssertEqual(scheme.primary, 0xffbe_c2ff)
  }

  func testDarkTheme_maxContrast_primary() {
    let scheme = SchemeRainbow(sourceColorHct: Hct(0xff00_00ff), isDark: true, contrastLevel: 1.0)
    XCTAssertEqual(scheme.primary, 0xfff0_eeff)
  }

  func testDarkTheme_minContrast_primaryContainer() {
    let scheme = SchemeRainbow(sourceColorHct: Hct(0xff00_00ff), isDark: true, contrastLevel: -1.0)
    XCTAssertEqual(scheme.primaryContainer, 0xff2a_3082)
  }

  func testDarkTheme_standardContrast_primaryContainer() {
    let scheme = SchemeRainbow(sourceColorHct: Hct(0xff00_00ff), isDark: true, contrastLevel: 0.0)
    XCTAssertEqual(scheme.primaryContainer, 0xff38_3E8F)
  }

  func testDarkTheme_maxContrast_primaryContainer() {
    let scheme = SchemeRainbow(sourceColorHct: Hct(0xff00_00ff), isDark: true, contrastLevel: 1.0)
    XCTAssertEqual(scheme.primaryContainer, 0xffba_bdff)
  }

  func testDarkTheme_minContrast_onPrimaryContainer() {
    let scheme = SchemeRainbow(sourceColorHct: Hct(0xff00_00ff), isDark: true, contrastLevel: -1.0)
    XCTAssertEqual(scheme.onPrimaryContainer, 0xff76_7cd2)
  }

  func testDarkTheme_standardContrast_onPrimaryContainer() {
    let scheme = SchemeRainbow(sourceColorHct: Hct(0xff00_00ff), isDark: true, contrastLevel: 0.0)
    XCTAssertEqual(scheme.onPrimaryContainer, 0xffe0_e0ff)
  }

  func testDarkTheme_maxContrast_onPrimaryContainer() {
    let scheme = SchemeRainbow(sourceColorHct: Hct(0xff00_00ff), isDark: true, contrastLevel: 1.0)
    XCTAssertEqual(scheme.onPrimaryContainer, 0xff00_003d)
  }

  func testDarkTheme_minContrast_onTertiaryContainer() {
    let scheme = SchemeRainbow(sourceColorHct: Hct(0xff00_00ff), isDark: true, contrastLevel: -1.0)
    XCTAssertEqual(scheme.onTertiaryContainer, 0xffa1_7891)
  }

  func testDarkTheme_standardContrast_onTertiaryContainer() {
    let scheme = SchemeRainbow(sourceColorHct: Hct(0xff00_00ff), isDark: true, contrastLevel: 0.0)
    XCTAssertEqual(scheme.onTertiaryContainer, 0xffff_d8ee)
  }

  func testDarkTheme_maxContrast_onTertiaryContainer() {
    let scheme = SchemeRainbow(sourceColorHct: Hct(0xff00_00ff), isDark: true, contrastLevel: 1.0)
    XCTAssertEqual(scheme.onTertiaryContainer, 0xff1b_0315)
  }

  func testDarkTheme_minContrast_surface() {
    let scheme = SchemeRainbow(sourceColorHct: Hct(0xff00_00ff), isDark: true, contrastLevel: -1.0)
    XCTAssertEqual(scheme.surface, 0xff13_1313)
  }

  func testDarkTheme_standardContrast_surface() {
    let scheme = SchemeRainbow(sourceColorHct: Hct(0xff00_00ff), isDark: true, contrastLevel: 0.0)
    XCTAssertEqual(scheme.surface, 0xff13_1313)
  }

  func testDarkTheme_maxContrast_surface() {
    let scheme = SchemeRainbow(sourceColorHct: Hct(0xff00_00ff), isDark: true, contrastLevel: 1.0)
    XCTAssertEqual(scheme.surface, 0xff13_1313)
  }

  func testDarkTheme_standardContrast_secondary() {
    let scheme = SchemeRainbow(sourceColorHct: Hct(0xff00_00ff), isDark: true, contrastLevel: 0.0)
    XCTAssertEqual(scheme.secondary, 0xffc5_c4dd)
  }

  func testDarkTheme_standardContrast_secondaryContainer() {
    let scheme = SchemeRainbow(sourceColorHct: Hct(0xff00_00ff), isDark: true, contrastLevel: 0.0)
    XCTAssertEqual(scheme.secondaryContainer, 0xff44_4559)
  }

  func testSchemeRainbowProvider_returnsIdeniticalSchemeWithSameSourceColor() {
    let sourceColorHct = Hct(0xfffa_2bec)
    let isDark = false
    let contrastLevel = 0.0

    let scheme = SchemeRainbow(
      sourceColorHct: sourceColorHct, isDark: isDark, contrastLevel: contrastLevel)
    let provider = SchemeRainbowProvider(sourceColorHct: sourceColorHct)
    let schemeByProvider = provider.scheme(isDark: isDark, contrastLevel: contrastLevel)

    XCTAssertEqual(scheme, schemeByProvider)
  }

  func testSchemeRainbowProvider_reusesTonalPalettes() {
    let provider = SchemeRainbowProvider(sourceColorHct: Hct(0xfffa_2bec))

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
