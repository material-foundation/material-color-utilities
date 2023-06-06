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

final class SchemeTonalSpotTests: XCTestCase {
  func testKeyColors() {
    let scheme = SchemeTonalSpot(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: false,
      contrastLevel: 0.0
    )

    XCTAssertEqual(MaterialDynamicColors.primaryPaletteKeyColor.getArgb(scheme), 0xff6E_72AC)
    XCTAssertEqual(MaterialDynamicColors.secondaryPaletteKeyColor.getArgb(scheme), 0xff75_758B)
    XCTAssertEqual(MaterialDynamicColors.tertiaryPaletteKeyColor.getArgb(scheme), 0xff93_6B84)
    XCTAssertEqual(MaterialDynamicColors.neutralPaletteKeyColor.getArgb(scheme), 0xff77_767d)
    XCTAssertEqual(MaterialDynamicColors.neutralVariantPaletteKeyColor.getArgb(scheme), 0xff77_7680)
  }

  func testLightTheme_minContrast_primary() {
    let scheme = SchemeTonalSpot(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: false,
      contrastLevel: -1.0
    )
    XCTAssertEqual(MaterialDynamicColors.primary.getArgb(scheme), 0xff6c_70aa)
  }

  func testLightTheme_standardContrast_primary() {
    let scheme = SchemeTonalSpot(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: false,
      contrastLevel: 0.0
    )
    XCTAssertEqual(MaterialDynamicColors.primary.getArgb(scheme), 0xff55_5992)
  }

  func testLightTheme_maxContrast_primary() {
    let scheme = SchemeTonalSpot(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: false,
      contrastLevel: 1.0
    )
    XCTAssertEqual(MaterialDynamicColors.primary.getArgb(scheme), 0xff18_1c51)
  }

  func testLightTheme_minContrast_primaryContainer() {
    let scheme = SchemeTonalSpot(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: false,
      contrastLevel: -1.0
    )
    XCTAssertEqual(MaterialDynamicColors.primaryContainer.getArgb(scheme), 0xffe0_e0ff)
  }

  func testLightTheme_standardContrast_primaryContainer() {
    let scheme = SchemeTonalSpot(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: false,
      contrastLevel: 0.0
    )
    XCTAssertEqual(MaterialDynamicColors.primaryContainer.getArgb(scheme), 0xffe0_e0ff)
  }

  func testLightTheme_maxContrast_primaryContainer() {
    let scheme = SchemeTonalSpot(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: false,
      contrastLevel: 1.0
    )
    XCTAssertEqual(MaterialDynamicColors.primaryContainer.getArgb(scheme), 0xff3a_3e74)
  }

  func testLightTheme_minContrast_onPrimaryContainer() {
    let scheme = SchemeTonalSpot(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: false,
      contrastLevel: -1.0
    )
    XCTAssertEqual(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme), 0xff5C_5F98)
  }

  func testLightTheme_standardContrast_onPrimaryContainer() {
    let scheme = SchemeTonalSpot(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: false,
      contrastLevel: 0.0
    )
    XCTAssertEqual(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme), 0xff11_144B)
  }

  func testLightTheme_maxContrast_onPrimaryContainer() {
    let scheme = SchemeTonalSpot(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: false,
      contrastLevel: 1.0
    )
    XCTAssertEqual(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme), 0xffd6_d6ff)
  }

  func testLightTheme_minContrast_surface() {
    let scheme = SchemeTonalSpot(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: false,
      contrastLevel: -1.0
    )
    XCTAssertEqual(MaterialDynamicColors.surface.getArgb(scheme), 0xfffb_f8ff)
  }

  func testLightTheme_standardContrast_surface() {
    let scheme = SchemeTonalSpot(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: false,
      contrastLevel: 0.0
    )
    XCTAssertEqual(MaterialDynamicColors.surface.getArgb(scheme), 0xfffb_f8ff)
  }

  func testLightTheme_maxContrast_surface() {
    let scheme = SchemeTonalSpot(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: false,
      contrastLevel: 1.0
    )
    XCTAssertEqual(MaterialDynamicColors.surface.getArgb(scheme), 0xfffb_f8ff)
  }

  func testLightTheme_minContrast_onSurface() {
    let scheme = SchemeTonalSpot(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: false,
      contrastLevel: -1.0
    )
    XCTAssertEqual(MaterialDynamicColors.onSurface.getArgb(scheme), 0xff5f_5e65)
  }

  func testLightTheme_standardContrast_onSurface() {
    let scheme = SchemeTonalSpot(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: false,
      contrastLevel: 0.0
    )
    XCTAssertEqual(MaterialDynamicColors.onSurface.getArgb(scheme), 0xff1b_1b21)
  }

  func testLightTheme_maxContrast_onSurface() {
    let scheme = SchemeTonalSpot(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: false,
      contrastLevel: 1.0
    )
    XCTAssertEqual(MaterialDynamicColors.onSurface.getArgb(scheme), 0xff1a_1a20)
  }

  func testLightTheme_minContrast_onSecondary() {
    let scheme = SchemeTonalSpot(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: false,
      contrastLevel: -1.0
    )
    XCTAssertEqual(MaterialDynamicColors.onSecondary.getArgb(scheme), 0xffcf_cfe7)
  }

  func testLightTheme_standardContrast_onSecondary() {
    let scheme = SchemeTonalSpot(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: false,
      contrastLevel: 0.0
    )
    XCTAssertEqual(MaterialDynamicColors.onSecondary.getArgb(scheme), 0xffff_ffff)
  }

  func testLightTheme_maxContrast_onSecondary() {
    let scheme = SchemeTonalSpot(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: false,
      contrastLevel: 1.0
    )
    XCTAssertEqual(MaterialDynamicColors.onSecondary.getArgb(scheme), 0xffab_abc3)
  }

  func testLightTheme_minContrast_onTertiary() {
    let scheme = SchemeTonalSpot(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: false,
      contrastLevel: -1.0
    )
    XCTAssertEqual(MaterialDynamicColors.onTertiary.getArgb(scheme), 0xfff3_c3df)
  }

  func testLightTheme_standardContrast_onTertiary() {
    let scheme = SchemeTonalSpot(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: false,
      contrastLevel: 0.0
    )
    XCTAssertEqual(MaterialDynamicColors.onTertiary.getArgb(scheme), 0xffff_ffff)
  }

  func testLightTheme_maxContrast_onTertiary() {
    let scheme = SchemeTonalSpot(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: false,
      contrastLevel: 1.0
    )
    XCTAssertEqual(MaterialDynamicColors.onTertiary.getArgb(scheme), 0xffcd_a0bb)
  }

  func testLightTheme_minContrast_onError() {
    let scheme = SchemeTonalSpot(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: false,
      contrastLevel: -1.0
    )
    XCTAssertEqual(MaterialDynamicColors.onError.getArgb(scheme), 0xffff_c2bb)
  }

  func testLightTheme_standardContrast_onError() {
    let scheme = SchemeTonalSpot(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: false,
      contrastLevel: 0.0
    )
    XCTAssertEqual(MaterialDynamicColors.onError.getArgb(scheme), 0xffff_ffff)
  }

  func testLightTheme_maxContrast_onError() {
    let scheme = SchemeTonalSpot(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: false,
      contrastLevel: 1.0
    )
    XCTAssertEqual(MaterialDynamicColors.onError.getArgb(scheme), 0xffff_8d80)
  }

  func testDarkTheme_minContrast_primary() {
    let scheme = SchemeTonalSpot(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: true,
      contrastLevel: -1.0
    )
    XCTAssertEqual(MaterialDynamicColors.primary.getArgb(scheme), 0xff6C_70AA)
  }

  func testDarkTheme_standardContrast_primary() {
    let scheme = SchemeTonalSpot(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: true,
      contrastLevel: 0.0
    )
    XCTAssertEqual(MaterialDynamicColors.primary.getArgb(scheme), 0xffbe_c2ff)
  }

  func testDarkTheme_maxContrast_primary() {
    let scheme = SchemeTonalSpot(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: true,
      contrastLevel: 1.0
    )
    XCTAssertEqual(MaterialDynamicColors.primary.getArgb(scheme), 0xfff6_f4ff)
  }

  func testDarkTheme_minContrast_primaryContainer() {
    let scheme = SchemeTonalSpot(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: true,
      contrastLevel: -1.0
    )
    XCTAssertEqual(MaterialDynamicColors.primaryContainer.getArgb(scheme), 0xff3E_4278)
  }

  func testDarkTheme_standardContrast_primaryContainer() {
    let scheme = SchemeTonalSpot(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: true,
      contrastLevel: 0.0
    )
    XCTAssertEqual(MaterialDynamicColors.primaryContainer.getArgb(scheme), 0xff3E_4278)
  }

  func testDarkTheme_maxContrast_primaryContainer() {
    let scheme = SchemeTonalSpot(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: true,
      contrastLevel: 1.0
    )
    XCTAssertEqual(MaterialDynamicColors.primaryContainer.getArgb(scheme), 0xffc4_c6ff)
  }

  func testDarkTheme_minContrast_onPrimaryContainer() {
    let scheme = SchemeTonalSpot(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: true,
      contrastLevel: -1.0
    )
    XCTAssertEqual(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme), 0xffad_b0ef)
  }

  func testDarkTheme_standardContrast_onPrimaryContainer() {
    let scheme = SchemeTonalSpot(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: true,
      contrastLevel: 0.0
    )
    XCTAssertEqual(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme), 0xffe0_e0ff)
  }

  func testDarkTheme_maxContrast_onPrimaryContainer() {
    let scheme = SchemeTonalSpot(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: true,
      contrastLevel: 1.0
    )
    XCTAssertEqual(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme), 0xff30_346A)
  }

  func testDarkTheme_minContrast_onTertiaryContainer() {
    let scheme = SchemeTonalSpot(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: true,
      contrastLevel: -1.0
    )
    XCTAssertEqual(MaterialDynamicColors.onTertiaryContainer.getArgb(scheme), 0xffd5_a8c3)
  }

  func testDarkTheme_standardContrast_onTertiaryContainer() {
    let scheme = SchemeTonalSpot(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: true,
      contrastLevel: 0.0
    )
    XCTAssertEqual(MaterialDynamicColors.onTertiaryContainer.getArgb(scheme), 0xffff_d8ee)
  }

  func testDarkTheme_maxContrast_onTertiaryContainer() {
    let scheme = SchemeTonalSpot(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: true,
      contrastLevel: 1.0
    )
    XCTAssertEqual(MaterialDynamicColors.onTertiaryContainer.getArgb(scheme), 0xff4f_2e44)
  }

  func testDarkTheme_minContrast_onSecondary() {
    let scheme = SchemeTonalSpot(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: true,
      contrastLevel: -1.0
    )
    XCTAssertEqual(MaterialDynamicColors.onSecondary.getArgb(scheme), 0xffff_fbff)
  }

  func testDarkTheme_standardContrast_onSecondary() {
    let scheme = SchemeTonalSpot(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: true,
      contrastLevel: 0.0
    )
    XCTAssertEqual(MaterialDynamicColors.onSecondary.getArgb(scheme), 0xff2e_2f42)
  }

  func testDarkTheme_maxContrast_onSecondary() {
    let scheme = SchemeTonalSpot(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: true,
      contrastLevel: 1.0
    )
    XCTAssertEqual(MaterialDynamicColors.onSecondary.getArgb(scheme), 0xff50_5165)
  }

  func testDarkTheme_minContrast_onTertiary() {
    let scheme = SchemeTonalSpot(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: true,
      contrastLevel: -1.0
    )
    XCTAssertEqual(MaterialDynamicColors.onTertiary.getArgb(scheme), 0xffff_fbff)
  }

  func testDarkTheme_standardContrast_onTertiary() {
    let scheme = SchemeTonalSpot(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: true,
      contrastLevel: 0.0
    )
    XCTAssertEqual(MaterialDynamicColors.onTertiary.getArgb(scheme), 0xff46_263b)
  }

  func testDarkTheme_maxContrast_onTertiary() {
    let scheme = SchemeTonalSpot(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: true,
      contrastLevel: 1.0
    )
    XCTAssertEqual(MaterialDynamicColors.onTertiary.getArgb(scheme), 0xff6b_485f)
  }

  func testDarkTheme_minContrast_onError() {
    let scheme = SchemeTonalSpot(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: true,
      contrastLevel: -1.0
    )
    XCTAssertEqual(MaterialDynamicColors.onError.getArgb(scheme), 0xffff_fbff)
  }

  func testDarkTheme_standardContrast_onError() {
    let scheme = SchemeTonalSpot(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: true,
      contrastLevel: 0.0
    )
    XCTAssertEqual(MaterialDynamicColors.onError.getArgb(scheme), 0xff69_0005)
  }

  func testDarkTheme_maxContrast_onError() {
    let scheme = SchemeTonalSpot(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: true,
      contrastLevel: 1.0
    )
    XCTAssertEqual(MaterialDynamicColors.onError.getArgb(scheme), 0xffa8_0710)
  }

  func testDarkTheme_minContrast_surface() {
    let scheme = SchemeTonalSpot(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: true,
      contrastLevel: -1.0
    )
    XCTAssertEqual(MaterialDynamicColors.surface.getArgb(scheme), 0xff13_1318)
  }

  func testDarkTheme_standardContrast_surface() {
    let scheme = SchemeTonalSpot(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: true,
      contrastLevel: 0.0
    )
    XCTAssertEqual(MaterialDynamicColors.surface.getArgb(scheme), 0xff13_1318)
  }

  func testDarkTheme_maxContrast_surface() {
    let scheme = SchemeTonalSpot(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: true,
      contrastLevel: 1.0
    )
    XCTAssertEqual(MaterialDynamicColors.surface.getArgb(scheme), 0xff13_1318)
  }

  func testDarkTheme_minContrast_onSurface() {
    let scheme = SchemeTonalSpot(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: true,
      contrastLevel: -1.0
    )
    XCTAssertEqual(MaterialDynamicColors.onSurface.getArgb(scheme), 0xffa4_a2a9)
  }

  func testDarkTheme_standardContrast_onSurface() {
    let scheme = SchemeTonalSpot(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: true,
      contrastLevel: 0.0
    )
    XCTAssertEqual(MaterialDynamicColors.onSurface.getArgb(scheme), 0xffe4_e1e9)
  }

  func testDarkTheme_maxContrast_onSurface() {
    let scheme = SchemeTonalSpot(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: true,
      contrastLevel: 1.0
    )
    XCTAssertEqual(MaterialDynamicColors.onSurface.getArgb(scheme), 0xffe5_e2ea)
  }
}
