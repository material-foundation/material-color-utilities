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

final class SchemeExpressiveTests: XCTestCase {
  func testKeyColors() {
    let scheme = SchemeExpressive(
      sourceColorHct: Hct.fromInt(0xff00_00ff), isDark: false, contrastLevel: 0.0)

    XCTAssertEqual(scheme.primaryPaletteKeyColor, 0xff35_855F)
    XCTAssertEqual(scheme.secondaryPaletteKeyColor, 0xff8C_6D8C)
    XCTAssertEqual(scheme.tertiaryPaletteKeyColor, 0xff80_6EA1)
    XCTAssertEqual(scheme.neutralPaletteKeyColor, 0xff79_757F)
    XCTAssertEqual(scheme.neutralVariantPaletteKeyColor, 0xff7A_7585)
  }

  func testLightTheme_minContrast_primary() {
    let scheme = SchemeExpressive(
      sourceColorHct: Hct.fromInt(0xff00_00ff), isDark: false, contrastLevel: -1.0)
    XCTAssertEqual(scheme.primary, 0xff32_835d)
  }

  func testLightTheme_standardContrast_primary() {
    let scheme = SchemeExpressive(
      sourceColorHct: Hct.fromInt(0xff00_00ff), isDark: false, contrastLevel: 0.0)
    XCTAssertEqual(scheme.primary, 0xff14_6c48)
  }

  func testLightTheme_maxContrast_primary() {
    let scheme = SchemeExpressive(
      sourceColorHct: Hct.fromInt(0xff00_00ff), isDark: false, contrastLevel: 1.0)
    XCTAssertEqual(scheme.primary, 0xff00_341f)
  }

  func testLightTheme_minContrast_primaryContainer() {
    let scheme = SchemeExpressive(
      sourceColorHct: Hct.fromInt(0xff00_00ff), isDark: false, contrastLevel: -1.0)
    XCTAssertEqual(scheme.primaryContainer, 0xff99_eabd)
  }

  func testLightTheme_standardContrast_primaryContainer() {
    let scheme = SchemeExpressive(
      sourceColorHct: Hct.fromInt(0xff00_00ff), isDark: false, contrastLevel: 0.0)
    XCTAssertEqual(scheme.primaryContainer, 0xffa2_f4c6)
  }

  func testLightTheme_maxContrast_primaryContainer() {
    let scheme = SchemeExpressive(
      sourceColorHct: Hct.fromInt(0xff00_00ff), isDark: false, contrastLevel: 1.0)
    XCTAssertEqual(scheme.primaryContainer, 0xff00_5436)
  }

  func testLightTheme_minContrast_onPrimaryContainer() {
    let scheme = SchemeExpressive(
      sourceColorHct: Hct.fromInt(0xff00_00ff), isDark: false, contrastLevel: -1.0)
    XCTAssertEqual(scheme.onPrimaryContainer, 0xff38_8862)
  }

  func testLightTheme_standardContrast_onPrimaryContainer() {
    let scheme = SchemeExpressive(
      sourceColorHct: Hct.fromInt(0xff00_00ff), isDark: false, contrastLevel: 0.0)
    XCTAssertEqual(scheme.onPrimaryContainer, 0xff00_5234)
  }

  func testLightTheme_maxContrast_onPrimaryContainer() {
    let scheme = SchemeExpressive(
      sourceColorHct: Hct.fromInt(0xff00_00ff), isDark: false, contrastLevel: 1.0)
    XCTAssertEqual(scheme.onPrimaryContainer, 0xffff_ffff)
  }

  func testLightTheme_minContrast_surface() {
    let scheme = SchemeExpressive(
      sourceColorHct: Hct.fromInt(0xff00_00ff), isDark: false, contrastLevel: -1.0)
    XCTAssertEqual(scheme.surface, 0xfffd_f7ff)
  }

  func testLightTheme_standardContrast_surface() {
    let scheme = SchemeExpressive(
      sourceColorHct: Hct.fromInt(0xff00_00ff), isDark: false, contrastLevel: 0.0)
    XCTAssertEqual(scheme.surface, 0xfffd_f7ff)
  }

  func testLightTheme_maxContrast_surface() {
    let scheme = SchemeExpressive(
      sourceColorHct: Hct.fromInt(0xff00_00ff), isDark: false, contrastLevel: 1.0)
    XCTAssertEqual(scheme.surface, 0xfffd_f7ff)
  }

  func testDarkTheme_minContrast_primary() {
    let scheme = SchemeExpressive(
      sourceColorHct: Hct.fromInt(0xff00_00ff), isDark: true, contrastLevel: -1.0)
    XCTAssertEqual(scheme.primary, 0xff51_a078)
  }

  func testDarkTheme_standardContrast_primary() {
    let scheme = SchemeExpressive(
      sourceColorHct: Hct.fromInt(0xff00_00ff), isDark: true, contrastLevel: 0.0)
    XCTAssertEqual(scheme.primary, 0xff87_d7ab)
  }

  func testDarkTheme_maxContrast_primary() {
    let scheme = SchemeExpressive(
      sourceColorHct: Hct.fromInt(0xff00_00ff), isDark: true, contrastLevel: 1.0)
    XCTAssertEqual(scheme.primary, 0xffbb_ffd7)
  }

  func testDarkTheme_minContrast_primaryContainer() {
    let scheme = SchemeExpressive(
      sourceColorHct: Hct.fromInt(0xff00_00ff), isDark: true, contrastLevel: -1.0)
    XCTAssertEqual(scheme.primaryContainer, 0xff00_432a)
  }

  func testDarkTheme_standardContrast_primaryContainer() {
    let scheme = SchemeExpressive(
      sourceColorHct: Hct.fromInt(0xff00_00ff), isDark: true, contrastLevel: 0.0)
    XCTAssertEqual(scheme.primaryContainer, 0xff00_5234)
  }

  func testDarkTheme_maxContrast_primaryContainer() {
    let scheme = SchemeExpressive(
      sourceColorHct: Hct.fromInt(0xff00_00ff), isDark: true, contrastLevel: 1.0)
    XCTAssertEqual(scheme.primaryContainer, 0xff83_d3a8)
  }

  func testDarkTheme_minContrast_onPrimaryContainer() {
    let scheme = SchemeExpressive(
      sourceColorHct: Hct.fromInt(0xff00_00ff), isDark: true, contrastLevel: -1.0)
    XCTAssertEqual(scheme.onPrimaryContainer, 0xff43_936c)
  }

  func testDarkTheme_standardContrast_onPrimaryContainer() {
    let scheme = SchemeExpressive(
      sourceColorHct: Hct.fromInt(0xff00_00ff), isDark: true, contrastLevel: 0.0)
    XCTAssertEqual(scheme.onPrimaryContainer, 0xffa2_f4c6)
  }

  func testDarkTheme_maxContrast_onPrimaryContainer() {
    let scheme = SchemeExpressive(
      sourceColorHct: Hct.fromInt(0xff00_00ff), isDark: true, contrastLevel: 1.0)
    XCTAssertEqual(scheme.onPrimaryContainer, 0xff00_0e06)
  }

  func testDarkTheme_minContrast_surface() {
    let scheme = SchemeExpressive(
      sourceColorHct: Hct.fromInt(0xff00_00ff), isDark: true, contrastLevel: -1.0)
    XCTAssertEqual(scheme.surface, 0xff14_121a)
  }

  func testDarkTheme_standardContrast_surface() {
    let scheme = SchemeExpressive(
      sourceColorHct: Hct.fromInt(0xff00_00ff), isDark: true, contrastLevel: 0.0)
    XCTAssertEqual(scheme.surface, 0xff14_121a)
  }

  func testDarkTheme_maxContrast_surface() {
    let scheme = SchemeExpressive(
      sourceColorHct: Hct.fromInt(0xff00_00ff), isDark: true, contrastLevel: 1.0)
    XCTAssertEqual(scheme.surface, 0xff14_121a)
  }

  func testSchemeExpressiveProvider_returnsIdeniticalSchemeWithSameSourceColor() {
    let sourceColorHct = Hct(0xfffa_2bec)
    let isDark = false
    let contrastLevel = 0.0

    let scheme = SchemeExpressive(
      sourceColorHct: sourceColorHct, isDark: isDark, contrastLevel: contrastLevel)
    let provider = SchemeExpressiveProvider(sourceColorHct: sourceColorHct)
    let schemeByProvider = provider.scheme(isDark: isDark, contrastLevel: contrastLevel)

    XCTAssertEqual(scheme, schemeByProvider)
  }

  func testSchemeExpressiveProvider_reusesTonalPalettes() {
    let provider = SchemeExpressiveProvider(sourceColorHct: Hct(0xfffa_2bec))

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
