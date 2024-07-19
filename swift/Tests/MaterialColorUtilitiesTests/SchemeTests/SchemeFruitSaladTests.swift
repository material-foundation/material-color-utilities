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

final class SchemeFruitSaladTests: XCTestCase {
  func testKeyColors() {
    let scheme = SchemeFruitSalad(
      sourceColorHct: Hct.fromInt(0xff00_00ff), isDark: false, contrastLevel: 0.0)

    XCTAssertEqual(scheme.primaryPaletteKeyColor, 0xff03_93c3)
    XCTAssertEqual(scheme.secondaryPaletteKeyColor, 0xff3A_7E9E)
    XCTAssertEqual(scheme.tertiaryPaletteKeyColor, 0xff6E_72AC)
    XCTAssertEqual(scheme.neutralPaletteKeyColor, 0xff77_7682)
    XCTAssertEqual(scheme.neutralVariantPaletteKeyColor, 0xff75_758B)
  }

  func testLightTheme_minContrast_primary() {
    let scheme = SchemeFruitSalad(
      sourceColorHct: Hct.fromInt(0xff00_00ff), isDark: false, contrastLevel: -1.0)
    XCTAssertEqual(scheme.primary, 0xff00_7ea7)
  }

  func testLightTheme_standardContrast_primary() {
    let scheme = SchemeFruitSalad(
      sourceColorHct: Hct.fromInt(0xff00_00ff), isDark: false, contrastLevel: 0.0)
    XCTAssertEqual(scheme.primary, 0xff00_6688)
  }

  func testLightTheme_maxContrast_primary() {
    let scheme = SchemeFruitSalad(
      sourceColorHct: Hct.fromInt(0xff00_00ff), isDark: false, contrastLevel: 1.0)
    XCTAssertEqual(scheme.primary, 0xff00_3042)
  }

  func testLightTheme_minContrast_primaryContainer() {
    let scheme = SchemeFruitSalad(
      sourceColorHct: Hct.fromInt(0xff00_00ff), isDark: false, contrastLevel: -1.0)
    XCTAssertEqual(scheme.primaryContainer, 0xffaa_e0ff)
  }

  func testLightTheme_standardContrast_primaryContainer() {
    let scheme = SchemeFruitSalad(
      sourceColorHct: Hct.fromInt(0xff00_00ff), isDark: false, contrastLevel: 0.0)
    XCTAssertEqual(scheme.primaryContainer, 0xffC2_E8FF)
  }

  func testLightTheme_maxContrast_primaryContainer() {
    let scheme = SchemeFruitSalad(
      sourceColorHct: Hct.fromInt(0xff00_00ff), isDark: false, contrastLevel: 1.0)
    XCTAssertEqual(scheme.primaryContainer, 0xff00_4f6b)
  }

  func testLightTheme_minContrast_tertiaryContainer() {
    let scheme = SchemeFruitSalad(
      sourceColorHct: Hct.fromInt(0xff00_00ff), isDark: false, contrastLevel: -1.0)
    XCTAssertEqual(scheme.tertiaryContainer, 0xffd5_d6ff)
  }

  func testLightTheme_standardContrast_tertiaryContainer() {
    let scheme = SchemeFruitSalad(
      sourceColorHct: Hct.fromInt(0xff00_00ff), isDark: false, contrastLevel: 0.0)
    XCTAssertEqual(scheme.tertiaryContainer, 0xffE0_E0FF)
  }

  func testLightTheme_maxContrast_tertiaryContainer() {
    let scheme = SchemeFruitSalad(
      sourceColorHct: Hct.fromInt(0xff00_00ff), isDark: false, contrastLevel: 1.0)
    XCTAssertEqual(scheme.tertiaryContainer, 0xff40_447b)
  }

  func testLightTheme_minContrast_onPrimaryContainer() {
    let scheme = SchemeFruitSalad(
      sourceColorHct: Hct.fromInt(0xff00_00ff), isDark: false, contrastLevel: -1.0)
    XCTAssertEqual(scheme.onPrimaryContainer, 0xff00_83ae)
  }

  func testLightTheme_standardContrast_onPrimaryContainer() {
    let scheme = SchemeFruitSalad(
      sourceColorHct: Hct.fromInt(0xff00_00ff), isDark: false, contrastLevel: 0.0)
    XCTAssertEqual(scheme.onPrimaryContainer, 0xff00_4d67)
  }

  func testLightTheme_maxContrast_onPrimaryContainer() {
    let scheme = SchemeFruitSalad(
      sourceColorHct: Hct.fromInt(0xff00_00ff), isDark: false, contrastLevel: 1.0)
    XCTAssertEqual(scheme.onPrimaryContainer, 0xffff_ffff)
  }

  func testLightTheme_minContrast_surface() {
    let scheme = SchemeFruitSalad(
      sourceColorHct: Hct.fromInt(0xff00_00ff), isDark: false, contrastLevel: -1.0)
    XCTAssertEqual(scheme.surface, 0xfffb_f8ff)
  }

  func testLightTheme_standardContrast_surface() {
    let scheme = SchemeFruitSalad(
      sourceColorHct: Hct.fromInt(0xff00_00ff), isDark: false, contrastLevel: 0.0)
    XCTAssertEqual(scheme.surface, 0xfffb_f8ff)
  }

  func testLightTheme_maxContrast_surface() {
    let scheme = SchemeFruitSalad(
      sourceColorHct: Hct.fromInt(0xff00_00ff), isDark: false, contrastLevel: 1.0)
    XCTAssertEqual(scheme.surface, 0xfffb_f8ff)
  }

  func testLightTheme_standardContrast_secondary() {
    let scheme = SchemeFruitSalad(
      sourceColorHct: Hct.fromInt(0xff00_00ff), isDark: false, contrastLevel: 0.0)
    XCTAssertEqual(scheme.secondary, 0xff19_6584)
  }

  func testLightTheme_standardContrast_secondaryContainer() {
    let scheme = SchemeFruitSalad(
      sourceColorHct: Hct.fromInt(0xff00_00ff), isDark: false, contrastLevel: 0.0)
    XCTAssertEqual(scheme.secondaryContainer, 0xffc2_e8ff)
  }

  func testDarkTheme_minContrast_primary() {
    let scheme = SchemeFruitSalad(
      sourceColorHct: Hct.fromInt(0xff00_00ff), isDark: true, contrastLevel: -1.0)
    XCTAssertEqual(scheme.primary, 0xff1e_9bcb)
  }

  func testDarkTheme_standardContrast_primary() {
    let scheme = SchemeFruitSalad(
      sourceColorHct: Hct.fromInt(0xff00_00ff), isDark: true, contrastLevel: 0.0)
    XCTAssertEqual(scheme.primary, 0xFF76_D1FF)
  }

  func testDarkTheme_maxContrast_primary() {
    let scheme = SchemeFruitSalad(
      sourceColorHct: Hct.fromInt(0xff00_00ff), isDark: true, contrastLevel: 1.0)
    XCTAssertEqual(scheme.primary, 0xFFe0_f3ff)
  }

  func testDarkTheme_minContrast_primaryContainer() {
    let scheme = SchemeFruitSalad(
      sourceColorHct: Hct.fromInt(0xff00_00ff), isDark: true, contrastLevel: -1.0)
    XCTAssertEqual(scheme.primaryContainer, 0xff00_3f56)
  }

  func testDarkTheme_standardContrast_primaryContainer() {
    let scheme = SchemeFruitSalad(
      sourceColorHct: Hct.fromInt(0xff00_00ff), isDark: true, contrastLevel: 0.0)
    XCTAssertEqual(scheme.primaryContainer, 0xFF00_4D67)
  }

  func testDarkTheme_maxContrast_primaryContainer() {
    let scheme = SchemeFruitSalad(
      sourceColorHct: Hct.fromInt(0xff00_00ff), isDark: true, contrastLevel: 1.0)
    XCTAssertEqual(scheme.primaryContainer, 0xFF68_ceff)
  }

  func testDarkTheme_minContrast_onPrimaryContainer() {
    let scheme = SchemeFruitSalad(
      sourceColorHct: Hct.fromInt(0xff00_00ff), isDark: true, contrastLevel: -1.0)
    XCTAssertEqual(scheme.onPrimaryContainer, 0xff00_8ebc)
  }

  func testDarkTheme_standardContrast_onPrimaryContainer() {
    let scheme = SchemeFruitSalad(
      sourceColorHct: Hct.fromInt(0xff00_00ff), isDark: true, contrastLevel: 0.0)
    XCTAssertEqual(scheme.onPrimaryContainer, 0xffC2_E8FF)
  }

  func testDarkTheme_maxContrast_onPrimaryContainer() {
    let scheme = SchemeFruitSalad(
      sourceColorHct: Hct.fromInt(0xff00_00ff), isDark: true, contrastLevel: 1.0)
    XCTAssertEqual(scheme.onPrimaryContainer, 0xFF00_0d15)
  }

  func testDarkTheme_minContrast_onTertiaryContainer() {
    let scheme = SchemeFruitSalad(
      sourceColorHct: Hct.fromInt(0xff00_00ff), isDark: true, contrastLevel: -1.0)
    XCTAssertEqual(scheme.onTertiaryContainer, 0xff7b_7fbb)
  }

  func testDarkTheme_standardContrast_onTertiaryContainer() {
    let scheme = SchemeFruitSalad(
      sourceColorHct: Hct.fromInt(0xff00_00ff), isDark: true, contrastLevel: 0.0)
    XCTAssertEqual(scheme.onTertiaryContainer, 0xffe0_e0ff)
  }

  func testDarkTheme_maxContrast_onTertiaryContainer() {
    let scheme = SchemeFruitSalad(
      sourceColorHct: Hct.fromInt(0xff00_00ff), isDark: true, contrastLevel: 1.0)
    XCTAssertEqual(scheme.onTertiaryContainer, 0xFF00_003c)
  }

  func testDarkTheme_minContrast_surface() {
    let scheme = SchemeFruitSalad(
      sourceColorHct: Hct.fromInt(0xff00_00ff), isDark: true, contrastLevel: -1.0)
    XCTAssertEqual(scheme.surface, 0xff12_131c)
  }

  func testDarkTheme_standardContrast_surface() {
    let scheme = SchemeFruitSalad(
      sourceColorHct: Hct.fromInt(0xff00_00ff), isDark: true, contrastLevel: 0.0)
    XCTAssertEqual(scheme.surface, 0xff12_131c)
  }

  func testDarkTheme_maxContrast_surface() {
    let scheme = SchemeFruitSalad(
      sourceColorHct: Hct.fromInt(0xff00_00ff), isDark: true, contrastLevel: 1.0)
    XCTAssertEqual(scheme.surface, 0xff12_131c)
  }

  func testDarkTheme_standardContrast_secondary() {
    let scheme = SchemeFruitSalad(
      sourceColorHct: Hct.fromInt(0xff00_00ff), isDark: true, contrastLevel: 0.0)
    XCTAssertEqual(scheme.secondary, 0xff8e_cff2)
  }

  func testDarkTheme_standardContrast_secondaryContainer() {
    let scheme = SchemeFruitSalad(
      sourceColorHct: Hct.fromInt(0xff00_00ff), isDark: true, contrastLevel: 0.0)
    XCTAssertEqual(scheme.secondaryContainer, 0xff00_4d67)
  }

  func testSchemeFruitSaladProvider_returnsIdeniticalSchemeWithSameSourceColor() {
    let sourceColorHct = Hct(0xfffa_2bec)
    let isDark = false
    let contrastLevel = 0.0

    let scheme = SchemeFruitSalad(
      sourceColorHct: sourceColorHct, isDark: isDark, contrastLevel: contrastLevel)
    let provider = SchemeFruitSaladProvider(sourceColorHct: sourceColorHct)
    let schemeByProvider = provider.scheme(isDark: isDark, contrastLevel: contrastLevel)

    XCTAssertEqual(scheme, schemeByProvider)
  }

  func testSchemeFruitSaladProvider_reusesTonalPalettes() {
    let provider = SchemeFruitSaladProvider(sourceColorHct: Hct(0xfffa_2bec))

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
