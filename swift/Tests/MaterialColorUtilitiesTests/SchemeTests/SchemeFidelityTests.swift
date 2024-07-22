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

final class SchemeFidelityTests: XCTestCase {
  func testKeyColors() {
    let scheme = SchemeFidelity(
      sourceColorHct: Hct.fromInt(0xff00_00ff), isDark: false, contrastLevel: 0.0)

    XCTAssertEqual(scheme.primaryPaletteKeyColor, 0xff08_0CFF)
    XCTAssertEqual(scheme.secondaryPaletteKeyColor, 0xff65_6DD3)
    XCTAssertEqual(scheme.tertiaryPaletteKeyColor, 0xff9D_0002)
    XCTAssertEqual(scheme.neutralPaletteKeyColor, 0xff76_7684)
    XCTAssertEqual(scheme.neutralVariantPaletteKeyColor, 0xff75_7589)
  }

  func testLightTheme_minContrast_primary() {
    let scheme = SchemeFidelity(
      sourceColorHct: Hct.fromInt(0xff00_00ff), isDark: false, contrastLevel: -1.0)
    XCTAssertEqual(scheme.primary, 0xff56_60ff)
  }

  func testLightTheme_standardContrast_primary() {
    let scheme = SchemeFidelity(
      sourceColorHct: Hct.fromInt(0xff00_00ff), isDark: false, contrastLevel: 0.0)
    XCTAssertEqual(scheme.primary, 0xff00_01bb)
  }

  func testLightTheme_maxContrast_primary() {
    let scheme = SchemeFidelity(
      sourceColorHct: Hct.fromInt(0xff00_00ff), isDark: false, contrastLevel: 1.0)
    XCTAssertEqual(scheme.primary, 0xff00_019f)
  }

  func testLightTheme_minContrast_primaryContainer() {
    let scheme = SchemeFidelity(
      sourceColorHct: Hct.fromInt(0xff00_00ff), isDark: false, contrastLevel: -1.0)
    XCTAssertEqual(scheme.primaryContainer, 0xffd5_d6ff)
  }

  func testLightTheme_standardContrast_primaryContainer() {
    let scheme = SchemeFidelity(
      sourceColorHct: Hct.fromInt(0xff00_00ff), isDark: false, contrastLevel: 0.0)
    XCTAssertEqual(scheme.primaryContainer, 0xff00_00ff)
  }

  func testLightTheme_maxContrast_primaryContainer() {
    let scheme = SchemeFidelity(
      sourceColorHct: Hct.fromInt(0xff00_00ff), isDark: false, contrastLevel: 1.0)
    XCTAssertEqual(scheme.primaryContainer, 0xff00_00f6)
  }

  func testLightTheme_minContrast_tertiaryContainer() {
    let scheme = SchemeFidelity(
      sourceColorHct: Hct.fromInt(0xff00_00ff), isDark: false, contrastLevel: -1.0)
    XCTAssertEqual(scheme.tertiaryContainer, 0xffff_cdc6)
  }

  func testLightTheme_standardContrast_tertiaryContainer() {
    let scheme = SchemeFidelity(
      sourceColorHct: Hct.fromInt(0xff00_00ff), isDark: false, contrastLevel: 0.0)
    XCTAssertEqual(scheme.tertiaryContainer, 0xff9d_0002)
  }

  func testLightTheme_maxContrast_tertiaryContainer() {
    let scheme = SchemeFidelity(
      sourceColorHct: Hct.fromInt(0xff00_00ff), isDark: false, contrastLevel: 1.0)
    XCTAssertEqual(scheme.tertiaryContainer, 0xff98_0002)
  }

  func testLightTheme_minContrast_objectionableTertiaryContainerLightens() {
    let scheme = SchemeFidelity(
      sourceColorHct: Hct.fromInt(0xff85_0096), isDark: false, contrastLevel: -1.0)
    XCTAssertEqual(scheme.tertiaryContainer, 0xffeb_d982)
  }

  func testLightTheme_standardContrast_objectionableTertiaryContainerLightens() {
    let scheme = SchemeFidelity(
      sourceColorHct: Hct.fromInt(0xff85_0096), isDark: false, contrastLevel: 0.0)
    XCTAssertEqual(scheme.tertiaryContainer, 0xffbc_ac5a)
  }

  func testLightTheme_maxContrast_objectionableTertiaryContainerDarkens() {
    let scheme = SchemeFidelity(
      sourceColorHct: Hct.fromInt(0xff85_0096), isDark: false, contrastLevel: 1.0)
    XCTAssertEqual(scheme.tertiaryContainer, 0xff54_4900)
  }

  func testLightTheme_minContrast_onPrimaryContainer() {
    let scheme = SchemeFidelity(
      sourceColorHct: Hct.fromInt(0xff00_00ff), isDark: false, contrastLevel: -1.0)
    XCTAssertEqual(scheme.onPrimaryContainer, 0xff5e_68ff)
  }

  func testLightTheme_standardContrast_onPrimaryContainer() {
    let scheme = SchemeFidelity(
      sourceColorHct: Hct.fromInt(0xff00_00ff), isDark: false, contrastLevel: 0.0)
    XCTAssertEqual(scheme.onPrimaryContainer, 0xffb3_b7ff)
  }

  func testLightTheme_maxContrast_onPrimaryContainer() {
    let scheme = SchemeFidelity(
      sourceColorHct: Hct.fromInt(0xff00_00ff), isDark: false, contrastLevel: 1.0)
    XCTAssertEqual(scheme.onPrimaryContainer, 0xffff_ffff)
  }

  func testLightTheme_minContrast_surface() {
    let scheme = SchemeFidelity(
      sourceColorHct: Hct.fromInt(0xff00_00ff), isDark: false, contrastLevel: -1.0)
    XCTAssertEqual(scheme.surface, 0xfffb_f8ff)
  }

  func testLightTheme_standardContrast_surface() {
    let scheme = SchemeFidelity(
      sourceColorHct: Hct.fromInt(0xff00_00ff), isDark: false, contrastLevel: 0.0)
    XCTAssertEqual(scheme.surface, 0xfffb_f8ff)
  }

  func testLightTheme_maxContrast_surface() {
    let scheme = SchemeFidelity(
      sourceColorHct: Hct.fromInt(0xff00_00ff), isDark: false, contrastLevel: 1.0)
    XCTAssertEqual(scheme.surface, 0xfffb_f8ff)
  }

  func testDarkTheme_minContrast_primary() {
    let scheme = SchemeFidelity(
      sourceColorHct: Hct.fromInt(0xff00_00ff), isDark: true, contrastLevel: -1.0)
    XCTAssertEqual(scheme.primary, 0xff7c_84ff)
  }

  func testDarkTheme_standardContrast_primary() {
    let scheme = SchemeFidelity(
      sourceColorHct: Hct.fromInt(0xff00_00ff), isDark: true, contrastLevel: 0.0)
    XCTAssertEqual(scheme.primary, 0xffbe_c2ff)
  }

  func testDarkTheme_maxContrast_primary() {
    let scheme = SchemeFidelity(
      sourceColorHct: Hct.fromInt(0xff00_00ff), isDark: true, contrastLevel: 1.0)
    XCTAssertEqual(scheme.primary, 0xfff0_eeff)
  }

  func testDarkTheme_minContrast_primaryContainer() {
    let scheme = SchemeFidelity(
      sourceColorHct: Hct.fromInt(0xff00_00ff), isDark: true, contrastLevel: -1.0)
    XCTAssertEqual(scheme.primaryContainer, 0xff00_01c9)
  }

  func testDarkTheme_standardContrast_primaryContainer() {
    let scheme = SchemeFidelity(
      sourceColorHct: Hct.fromInt(0xff00_00ff), isDark: true, contrastLevel: 0.0)
    XCTAssertEqual(scheme.primaryContainer, 0xff00_00ff)
  }

  func testDarkTheme_maxContrast_primaryContainer() {
    let scheme = SchemeFidelity(
      sourceColorHct: Hct.fromInt(0xff00_00ff), isDark: true, contrastLevel: 1.0)
    XCTAssertEqual(scheme.primaryContainer, 0xffba_bdff)
  }

  func testDarkTheme_minContrast_onPrimaryContainer() {
    let scheme = SchemeFidelity(
      sourceColorHct: Hct.fromInt(0xff00_00ff), isDark: true, contrastLevel: -1.0)
    XCTAssertEqual(scheme.onPrimaryContainer, 0xff6b_75ff)
  }

  func testDarkTheme_standardContrast_onPrimaryContainer() {
    let scheme = SchemeFidelity(
      sourceColorHct: Hct.fromInt(0xff00_00ff), isDark: true, contrastLevel: 0.0)
    XCTAssertEqual(scheme.onPrimaryContainer, 0xffb3_b7ff)
  }

  func testDarkTheme_maxContrast_onPrimaryContainer() {
    let scheme = SchemeFidelity(
      sourceColorHct: Hct.fromInt(0xff00_00ff), isDark: true, contrastLevel: 1.0)
    XCTAssertEqual(scheme.onPrimaryContainer, 0xff00_003d)
  }

  func testDarkTheme_minContrast_onTertiaryContainer() {
    let scheme = SchemeFidelity(
      sourceColorHct: Hct.fromInt(0xff00_00ff), isDark: true, contrastLevel: -1.0)
    XCTAssertEqual(scheme.onTertiaryContainer, 0xffef_4635)
  }

  func testDarkTheme_standardContrast_onTertiaryContainer() {
    let scheme = SchemeFidelity(
      sourceColorHct: Hct.fromInt(0xff00_00ff), isDark: true, contrastLevel: 0.0)
    XCTAssertEqual(scheme.onTertiaryContainer, 0xffff_a598)
  }

  func testDarkTheme_maxContrast_onTertiaryContainer() {
    let scheme = SchemeFidelity(
      sourceColorHct: Hct.fromInt(0xff00_00ff), isDark: true, contrastLevel: 1.0)
    XCTAssertEqual(scheme.onTertiaryContainer, 0xff22_0000)
  }

  func testDarkTheme_minContrast_surface() {
    let scheme = SchemeFidelity(
      sourceColorHct: Hct.fromInt(0xff00_00ff), isDark: true, contrastLevel: -1.0)
    XCTAssertEqual(scheme.surface, 0xff12_121d)
  }

  func testDarkTheme_standardContrast_surface() {
    let scheme = SchemeFidelity(
      sourceColorHct: Hct.fromInt(0xff00_00ff), isDark: true, contrastLevel: 0.0)
    XCTAssertEqual(scheme.surface, 0xff12_121d)
  }

  func testDarkTheme_maxContrast_surface() {
    let scheme = SchemeFidelity(
      sourceColorHct: Hct.fromInt(0xff00_00ff), isDark: true, contrastLevel: 1.0)
    XCTAssertEqual(scheme.surface, 0xff12_121d)
  }

  func testSchemeFidelityProvider_returnsIdeniticalSchemeWithSameSourceColor() {
    let sourceColorHct = Hct(0xfffa_2bec)
    let isDark = false
    let contrastLevel = 0.0

    let scheme = SchemeFidelity(
      sourceColorHct: sourceColorHct, isDark: isDark, contrastLevel: contrastLevel)
    let provider = SchemeFidelityProvider(sourceColorHct: sourceColorHct)
    let schemeByProvider = provider.scheme(isDark: isDark, contrastLevel: contrastLevel)

    XCTAssertEqual(scheme, schemeByProvider)
  }

  func testSchemeFidelityProvider_reusesTonalPalettes() {
    let provider = SchemeFidelityProvider(sourceColorHct: Hct(0xfffa_2bec))

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
