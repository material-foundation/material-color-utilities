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

final class SchemeContentTests: XCTestCase {

  func testKeyColors() {
    let scheme = SchemeContent(sourceColorHct: Hct(0xff00_00ff), isDark: false, contrastLevel: 0.0)
    XCTAssertEqual(scheme.primaryPaletteKeyColor, 0xff08_0c_ff)
    XCTAssertEqual(scheme.secondaryPaletteKeyColor, 0xff65_6d_d3)
    XCTAssertEqual(scheme.tertiaryPaletteKeyColor, 0xff81_00_9f)
    XCTAssertEqual(scheme.neutralPaletteKeyColor, 0xff76_76_84)
    XCTAssertEqual(scheme.neutralVariantPaletteKeyColor, 0xff75_75_89)
  }

  func testLightTheme_MinContrast_Primary() {
    let scheme = SchemeContent(sourceColorHct: Hct(0xff00_00ff), isDark: false, contrastLevel: -1.0)
    XCTAssertEqual(scheme.primary, 0xff56_60_ff)
  }

  func testLightTheme_StandardContrast_Primary() {
    let scheme = SchemeContent(sourceColorHct: Hct(0xff00_00ff), isDark: false, contrastLevel: 0.0)
    XCTAssertEqual(scheme.primary, 0xff00_01_bb)
  }

  func testLightTheme_MaxContrast_Primary() {
    let scheme = SchemeContent(sourceColorHct: Hct(0xff00_00ff), isDark: false, contrastLevel: 1.0)
    XCTAssertEqual(scheme.primary, 0xff00_01_9f)
  }

  func testLightTheme_MinContrast_PrimaryContainer() {
    let scheme = SchemeContent(sourceColorHct: Hct(0xff00_00ff), isDark: false, contrastLevel: -1.0)
    XCTAssertEqual(scheme.primaryContainer, 0xffd5_d6_ff)
  }

  func testLightTheme_StandardContrast_PrimaryContainer() {
    let scheme = SchemeContent(sourceColorHct: Hct(0xff00_00ff), isDark: false, contrastLevel: 0.0)
    XCTAssertEqual(scheme.primaryContainer, 0xff00_00_ff)
  }

  func testLightTheme_MaxContrast_PrimaryContainer() {
    let scheme = SchemeContent(sourceColorHct: Hct(0xff00_00ff), isDark: false, contrastLevel: 1.0)
    XCTAssertEqual(scheme.primaryContainer, 0xff00_00_f6)
  }

  func testLightTheme_MinContrast_TertiaryContainer() {
    let scheme = SchemeContent(sourceColorHct: Hct(0xff00_00ff), isDark: false, contrastLevel: -1.0)
    XCTAssertEqual(scheme.tertiaryContainer, 0xfffa_c9_ff)
  }

  func testLightTheme_StandardContrast_TertiaryContainer() {
    let scheme = SchemeContent(sourceColorHct: Hct(0xff00_00ff), isDark: false, contrastLevel: 0.0)
    XCTAssertEqual(scheme.tertiaryContainer, 0xff81_00_9f)
  }

  func testLightTheme_MaxContrast_TertiaryContainer() {
    let scheme = SchemeContent(sourceColorHct: Hct(0xff00_00ff), isDark: false, contrastLevel: 1.0)
    XCTAssertEqual(scheme.tertiaryContainer, 0xff7d_00_9a)
  }

  func testLightTheme_MinContrast_OnPrimaryContainer() {
    let scheme = SchemeContent(sourceColorHct: Hct(0xff00_00ff), isDark: false, contrastLevel: -1.0)
    XCTAssertEqual(scheme.onPrimaryContainer, 0xff5e_68_ff)
  }

  func testLightTheme_StandardContrast_OnPrimaryContainer() {
    let scheme = SchemeContent(sourceColorHct: Hct(0xff00_00ff), isDark: false, contrastLevel: 0.0)
    XCTAssertEqual(scheme.onPrimaryContainer, 0xffb3_b7_ff)
  }

  func testLightTheme_MaxContrast_OnPrimaryContainer() {
    let scheme = SchemeContent(sourceColorHct: Hct(0xff00_00ff), isDark: false, contrastLevel: 1.0)
    XCTAssertEqual(scheme.onPrimaryContainer, 0xffff_ffff)
  }

  func testLightTheme_MinContrast_Surface() {
    let scheme = SchemeContent(sourceColorHct: Hct(0xff00_00ff), isDark: false, contrastLevel: -1)
    XCTAssertEqual(scheme.surface, 0xfffb_f8_ff)
  }

  func testLightTheme_StandardContrast_Surface() {
    let scheme = SchemeContent(sourceColorHct: Hct(0xff00_00ff), isDark: false, contrastLevel: 0.0)
    XCTAssertEqual(scheme.surface, 0xfffb_f8_ff)
  }

  func testLightTheme_MaxContrast_Surface() {
    let scheme = SchemeContent(sourceColorHct: Hct(0xff00_00ff), isDark: false, contrastLevel: 1.0)
    XCTAssertEqual(scheme.surface, 0xfffb_f8_ff)
  }

  func testDarkTheme_MinContrast_Primary() {
    let scheme = SchemeContent(sourceColorHct: Hct(0xff00_00ff), isDark: true, contrastLevel: -1.0)
    XCTAssertEqual(scheme.primary, 0xff7c_84_ff)
  }

  func testDarkTheme_StandardContrast_Primary() {
    let scheme = SchemeContent(sourceColorHct: Hct(0xff00_00ff), isDark: true, contrastLevel: 0.0)
    XCTAssertEqual(scheme.primary, 0xffbe_c2_ff)
  }

  func testDarkTheme_MaxContrast_Primary() {
    let scheme = SchemeContent(sourceColorHct: Hct(0xff00_00ff), isDark: true, contrastLevel: 1.0)
    XCTAssertEqual(scheme.primary, 0xfff0_ee_ff)
  }

  func testDarkTheme_MinContrast_PrimaryContainer() {
    let scheme = SchemeContent(sourceColorHct: Hct(0xff00_00ff), isDark: true, contrastLevel: -1.0)
    XCTAssertEqual(scheme.primaryContainer, 0xff00_01_c9)
  }

  func testDarkTheme_StandardContrast_PrimaryContainer() {
    let scheme = SchemeContent(sourceColorHct: Hct(0xff00_00ff), isDark: true, contrastLevel: 0.0)
    XCTAssertEqual(scheme.primaryContainer, 0xff00_00_ff)
  }

  func testDarkTheme_MaxContrast_PrimaryContainer() {
    let scheme = SchemeContent(sourceColorHct: Hct(0xff00_00ff), isDark: true, contrastLevel: 1.0)
    XCTAssertEqual(scheme.primaryContainer, 0xffba_bd_ff)
  }

  func testDarkTheme_MinContrast_OnPrimaryContainer() {
    let scheme = SchemeContent(sourceColorHct: Hct(0xff00_00ff), isDark: true, contrastLevel: -1.0)
    XCTAssertEqual(scheme.onPrimaryContainer, 0xff6b_75_ff)
  }

  func testDarkTheme_StandardContrast_OnPrimaryContainer() {
    let scheme = SchemeContent(sourceColorHct: Hct(0xff00_00ff), isDark: true, contrastLevel: 0.0)
    XCTAssertEqual(scheme.onPrimaryContainer, 0xffb3_b7_ff)
  }

  func testDarkTheme_MaxContrast_OnPrimaryContainer() {
    let scheme = SchemeContent(sourceColorHct: Hct(0xff00_00ff), isDark: true, contrastLevel: 1.0)
    XCTAssertEqual(scheme.onPrimaryContainer, 0xff00_00_3d)
  }

  func testDarkTheme_MinContrast_OnTertiaryContainer() {
    let scheme = SchemeContent(sourceColorHct: Hct(0xff00_00ff), isDark: true, contrastLevel: -1.0)
    XCTAssertEqual(scheme.onTertiaryContainer, 0xffc2_54_de)
  }

  func testDarkTheme_StandardContrast_OnTertiaryContainer() {
    let scheme = SchemeContent(sourceColorHct: Hct(0xff00_00ff), isDark: true, contrastLevel: 0.0)
    XCTAssertEqual(scheme.onTertiaryContainer, 0xfff0_9f_ff)
  }

  func testDarkTheme_MaxContrast_OnTertiaryContainer() {
    let scheme = SchemeContent(sourceColorHct: Hct(0xff00_00ff), isDark: true, contrastLevel: 1.0)
    XCTAssertEqual(scheme.onTertiaryContainer, 0xff1a_00_22)
  }

  func testDarkTheme_MinContrast_Surface() {
    let scheme = SchemeContent(sourceColorHct: Hct(0xff00_00ff), isDark: true, contrastLevel: -1.0)
    XCTAssertEqual(scheme.surface, 0xff12_12_1d)
  }

  func testDarkTheme_StandardContrast_Surface() {
    let scheme = SchemeContent(sourceColorHct: Hct(0xff00_00ff), isDark: true, contrastLevel: 0.0)
    XCTAssertEqual(scheme.surface, 0xff12_12_1d)
  }

  func testDarkTheme_MaxContrast_Surface() {
    let scheme = SchemeContent(sourceColorHct: Hct(0xff00_00ff), isDark: true, contrastLevel: 1.0)
    XCTAssertEqual(scheme.surface, 0xff12_12_1d)
  }

  func testLightTheme_MinContrast_ObjectionabeTertiaryContainerLightens() {
    let scheme = SchemeContent(
      sourceColorHct: Hct.fromInt(0xff85_0096),
      isDark: false,
      contrastLevel: -1
    )

    XCTAssertEqual(scheme.tertiaryContainer, 0xffff_ccd7)
  }

  func testLightTheme_StandardContrast_ObjectionabeTertiaryContainerLightens() {
    let scheme = SchemeContent(
      sourceColorHct: Hct.fromInt(0xff85_0096),
      isDark: false,
      contrastLevel: 0
    )

    XCTAssertEqual(scheme.tertiaryContainer, 0xff98_0249)
  }

  func testLightTheme_MaxContrast_ObjectionabeTertiaryContainerDarkens() {
    let scheme = SchemeContent(
      sourceColorHct: Hct.fromInt(0xff85_0096),
      isDark: false,
      contrastLevel: 1
    )

    XCTAssertEqual(scheme.tertiaryContainer, 0xff93_0046)
  }

  func testSchemeContentProvider_returnsIdeniticalSchemeWithSameSourceColor() {
    let sourceColorHct = Hct(0xfffa_2bec)
    let isDark = false
    let contrastLevel = 0.0

    let scheme = SchemeContent(
      sourceColorHct: sourceColorHct, isDark: isDark, contrastLevel: contrastLevel)
    let provider = SchemeContentProvider(sourceColorHct: sourceColorHct)
    let schemeByProvider = provider.scheme(isDark: isDark, contrastLevel: contrastLevel)

    XCTAssertEqual(scheme, schemeByProvider)
  }

  func testSchemeContentProvider_reusesTonalPalettes() {
    let provider = SchemeContentProvider(sourceColorHct: Hct(0xfffa_2bec))

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
