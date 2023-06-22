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

final class SchemeFruitSaladTests: XCTestCase {
  func testKeyColors() {
    let scheme = SchemeFruitSalad(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: false,
      contrastLevel: 0.0
    )

    XCTAssertEqual(MaterialDynamicColors.primaryPaletteKeyColor.getArgb(scheme), 0xff00_91c0)
    XCTAssertEqual(MaterialDynamicColors.secondaryPaletteKeyColor.getArgb(scheme), 0xff3a_7e9e)
    XCTAssertEqual(MaterialDynamicColors.tertiaryPaletteKeyColor.getArgb(scheme), 0xff6e_72ac)
    XCTAssertEqual(MaterialDynamicColors.neutralPaletteKeyColor.getArgb(scheme), 0xff77_7682)
    XCTAssertEqual(MaterialDynamicColors.neutralVariantPaletteKeyColor.getArgb(scheme), 0xff75_758b)
  }

  func testLightTheme_minContrast_primary() {
    let scheme = SchemeFruitSalad(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: false,
      contrastLevel: -1.0
    )
    XCTAssertEqual(MaterialDynamicColors.primary.getArgb(scheme), 0xff00_7ea7)
  }

  func testLightTheme_standardContrast_primary() {
    let scheme = SchemeFruitSalad(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: false,
      contrastLevel: 0.0
    )
    XCTAssertEqual(MaterialDynamicColors.primary.getArgb(scheme), 0xff00_6688)
  }

  func testLightTheme_maxContrast_primary() {
    let scheme = SchemeFruitSalad(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: false,
      contrastLevel: 1.0
    )
    XCTAssertEqual(MaterialDynamicColors.primary.getArgb(scheme), 0xff00_2635)
  }

  func testLightTheme_minContrast_primaryContainer() {
    let scheme = SchemeFruitSalad(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: false,
      contrastLevel: -1.0
    )
    XCTAssertEqual(MaterialDynamicColors.primaryContainer.getArgb(scheme), 0xffaa_e0ff)
  }

  func testLightTheme_standardContrast_primaryContainer() {
    let scheme = SchemeFruitSalad(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: false,
      contrastLevel: 0.0
    )
    XCTAssertEqual(MaterialDynamicColors.primaryContainer.getArgb(scheme), 0xffc2_e8ff)
  }

  func testLightTheme_maxContrast_primaryContainer() {
    let scheme = SchemeFruitSalad(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: false,
      contrastLevel: 1.0
    )
    XCTAssertEqual(MaterialDynamicColors.primaryContainer.getArgb(scheme), 0xff00_4862)
  }

  func testLightTheme_minContrast_tertiaryContainer() {
    let scheme = SchemeFruitSalad(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: false,
      contrastLevel: -1.0
    )
    XCTAssertEqual(MaterialDynamicColors.tertiaryContainer.getArgb(scheme), 0xffd5_d6ff)
  }

  func testLightTheme_standardContrast_tertiaryContainer() {
    let scheme = SchemeFruitSalad(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: false,
      contrastLevel: 0.0
    )
    XCTAssertEqual(MaterialDynamicColors.tertiaryContainer.getArgb(scheme), 0xffe0_e0ff)
  }

  func testLightTheme_maxContrast_tertiaryContainer() {
    let scheme = SchemeFruitSalad(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: false,
      contrastLevel: 1.0
    )
    XCTAssertEqual(MaterialDynamicColors.tertiaryContainer.getArgb(scheme), 0xff3a_3e74)
  }

  func testLightTheme_minContrast_onPrimaryContainer() {
    let scheme = SchemeFruitSalad(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: false,
      contrastLevel: -1.0
    )
    XCTAssertEqual(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme), 0xff00_6688)
  }

  func testLightTheme_standardContrast_onPrimaryContainer() {
    let scheme = SchemeFruitSalad(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: false,
      contrastLevel: 0.0
    )
    XCTAssertEqual(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme), 0xff00_1e2b)
  }

  func testLightTheme_maxContrast_onPrimaryContainer() {
    let scheme = SchemeFruitSalad(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: false,
      contrastLevel: 1.0
    )
    XCTAssertEqual(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme), 0xffff_ffff)
  }

  func testLightTheme_minContrast_surface() {
    let scheme = SchemeFruitSalad(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: false,
      contrastLevel: -1.0
    )
    XCTAssertEqual(MaterialDynamicColors.surface.getArgb(scheme), 0xfffb_f8ff)
  }

  func testLightTheme_standardContrast_surface() {
    let scheme = SchemeFruitSalad(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: false,
      contrastLevel: 0.0
    )
    XCTAssertEqual(MaterialDynamicColors.surface.getArgb(scheme), 0xfffb_f8ff)
  }

  func testLightTheme_maxContrast_surface() {
    let scheme = SchemeFruitSalad(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: false,
      contrastLevel: 1.0
    )
    XCTAssertEqual(MaterialDynamicColors.surface.getArgb(scheme), 0xfffb_f8ff)
  }

  func testLightTheme_standardContrast_secondary() {
    let scheme = SchemeFruitSalad(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: false,
      contrastLevel: 0.0
    )
    XCTAssertEqual(MaterialDynamicColors.secondary.getArgb(scheme), 0xff19_6584)
  }

  func testLightTheme_standardContrast_secondaryContainer() {
    let scheme = SchemeFruitSalad(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: false,
      contrastLevel: 0.0
    )
    XCTAssertEqual(MaterialDynamicColors.secondaryContainer.getArgb(scheme), 0xffc2_e8ff)
  }

  func testDarkTheme_minContrast_primary() {
    let scheme = SchemeFruitSalad(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: true,
      contrastLevel: -1.0
    )
    XCTAssertEqual(MaterialDynamicColors.primary.getArgb(scheme), 0xff1e_9bcb)
  }

  func testDarkTheme_standardContrast_primary() {
    let scheme = SchemeFruitSalad(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: true,
      contrastLevel: 0.0
    )
    XCTAssertEqual(MaterialDynamicColors.primary.getArgb(scheme), 0xff76_d1ff)
  }

  func testDarkTheme_maxContrast_primary() {
    let scheme = SchemeFruitSalad(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: true,
      contrastLevel: 1.0
    )
    XCTAssertEqual(MaterialDynamicColors.primary.getArgb(scheme), 0xfff7_fbff)
  }

  func testDarkTheme_minContrast_primaryContainer() {
    let scheme = SchemeFruitSalad(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: true,
      contrastLevel: -1.0
    )
    XCTAssertEqual(MaterialDynamicColors.primaryContainer.getArgb(scheme), 0xff00_3f56)
  }

  func testDarkTheme_standardContrast_primaryContainer() {
    let scheme = SchemeFruitSalad(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: true,
      contrastLevel: 0.0
    )
    XCTAssertEqual(MaterialDynamicColors.primaryContainer.getArgb(scheme), 0xff00_4d67)
  }

  func testDarkTheme_maxContrast_primaryContainer() {
    let scheme = SchemeFruitSalad(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: true,
      contrastLevel: 1.0
    )
    XCTAssertEqual(MaterialDynamicColors.primaryContainer.getArgb(scheme), 0xff83_d5ff)
  }

  func testDarkTheme_minContrast_onPrimaryContainer() {
    let scheme = SchemeFruitSalad(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: true,
      contrastLevel: -1.0
    )
    XCTAssertEqual(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme), 0xff3f_afe0)
  }

  func testDarkTheme_standardContrast_onPrimaryContainer() {
    let scheme = SchemeFruitSalad(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: true,
      contrastLevel: 0.0
    )
    XCTAssertEqual(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme), 0xffc2_e8ff)
  }

  func testDarkTheme_maxContrast_onPrimaryContainer() {
    let scheme = SchemeFruitSalad(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: true,
      contrastLevel: 1.0
    )
    XCTAssertEqual(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme), 0xff00_0000)
  }

  func testDarkTheme_minContrast_onTertiaryContainer() {
    let scheme = SchemeFruitSalad(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: true,
      contrastLevel: -1.0
    )
    XCTAssertEqual(MaterialDynamicColors.onTertiaryContainer.getArgb(scheme), 0xff9b_9fdd)
  }

  func testDarkTheme_standardContrast_onTertiaryContainer() {
    let scheme = SchemeFruitSalad(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: true,
      contrastLevel: 0.0
    )
    XCTAssertEqual(MaterialDynamicColors.onTertiaryContainer.getArgb(scheme), 0xffe0_e0ff)
  }

  func testDarkTheme_maxContrast_onTertiaryContainer() {
    let scheme = SchemeFruitSalad(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: true,
      contrastLevel: 1.0
    )
    XCTAssertEqual(MaterialDynamicColors.onTertiaryContainer.getArgb(scheme), 0xff00_0000)
  }

  func testDarkTheme_minContrast_surface() {
    let scheme = SchemeFruitSalad(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: true,
      contrastLevel: -1.0
    )
    XCTAssertEqual(MaterialDynamicColors.surface.getArgb(scheme), 0xff12_131c)
  }

  func testDarkTheme_standardContrast_surface() {
    let scheme = SchemeFruitSalad(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: true,
      contrastLevel: 0.0
    )
    XCTAssertEqual(MaterialDynamicColors.surface.getArgb(scheme), 0xff12_131c)
  }

  func testDarkTheme_maxContrast_surface() {
    let scheme = SchemeFruitSalad(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: true,
      contrastLevel: 1.0
    )
    XCTAssertEqual(MaterialDynamicColors.surface.getArgb(scheme), 0xff12_131c)
  }

  func testDarkTheme_standardContrast_secondary() {
    let scheme = SchemeFruitSalad(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: true,
      contrastLevel: 0.0
    )
    XCTAssertEqual(MaterialDynamicColors.secondary.getArgb(scheme), 0xff8e_cff2)
  }

  func testDarkTheme_standardContrast_secondaryContainer() {
    let scheme = SchemeFruitSalad(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: true,
      contrastLevel: 0.0
    )
    XCTAssertEqual(MaterialDynamicColors.secondaryContainer.getArgb(scheme), 0xff00_4d67)
  }
}
