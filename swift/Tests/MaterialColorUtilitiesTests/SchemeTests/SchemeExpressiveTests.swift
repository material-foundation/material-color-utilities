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

final class SchemeExpressiveTests: XCTestCase {
  func testKeyColors() {
    let scheme = SchemeExpressive(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: false,
      contrastLevel: 0.0
    )

    XCTAssertEqual(MaterialDynamicColors.primaryPaletteKeyColor.getArgb(scheme), 0xff35_855f)
    XCTAssertEqual(MaterialDynamicColors.secondaryPaletteKeyColor.getArgb(scheme), 0xff8c_6d8c)
    XCTAssertEqual(MaterialDynamicColors.tertiaryPaletteKeyColor.getArgb(scheme), 0xff80_6ea1)
    XCTAssertEqual(MaterialDynamicColors.neutralPaletteKeyColor.getArgb(scheme), 0xff79_757f)
    XCTAssertEqual(MaterialDynamicColors.neutralVariantPaletteKeyColor.getArgb(scheme), 0xff7a_7585)
  }

  func testLightTheme_minContrast_primary() {
    let scheme = SchemeExpressive(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: false,
      contrastLevel: -1.0
    )
    XCTAssertEqual(MaterialDynamicColors.primary.getArgb(scheme), 0xff32_835d)
  }

  func testLightTheme_standardContrast_primary() {
    let scheme = SchemeExpressive(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: false,
      contrastLevel: 0.0
    )
    XCTAssertEqual(MaterialDynamicColors.primary.getArgb(scheme), 0xff14_6c48)
  }

  func testLightTheme_maxContrast_primary() {
    let scheme = SchemeExpressive(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: false,
      contrastLevel: 1.0
    )
    XCTAssertEqual(MaterialDynamicColors.primary.getArgb(scheme), 0xff00_2818)
  }

  func testLightTheme_minContrast_primaryContainer() {
    let scheme = SchemeExpressive(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: false,
      contrastLevel: -1.0
    )
    XCTAssertEqual(MaterialDynamicColors.primaryContainer.getArgb(scheme), 0xff99_eabd)
  }

  func testLightTheme_standardContrast_primaryContainer() {
    let scheme = SchemeExpressive(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: false,
      contrastLevel: 0.0
    )
    XCTAssertEqual(MaterialDynamicColors.primaryContainer.getArgb(scheme), 0xffa2_f4c6)
  }

  func testLightTheme_maxContrast_primaryContainer() {
    let scheme = SchemeExpressive(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: false,
      contrastLevel: 1.0
    )
    XCTAssertEqual(MaterialDynamicColors.primaryContainer.getArgb(scheme), 0xff00_4d31)
  }

  func testLightTheme_minContrast_onPrimaryContainer() {
    let scheme = SchemeExpressive(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: false,
      contrastLevel: -1.0
    )
    XCTAssertEqual(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme), 0xff14_6c48)
  }

  func testLightTheme_standardContrast_onPrimaryContainer() {
    let scheme = SchemeExpressive(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: false,
      contrastLevel: 0.0
    )
    XCTAssertEqual(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme), 0xff00_2112)
  }

  func testLightTheme_maxContrast_onPrimaryContainer() {
    let scheme = SchemeExpressive(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: false,
      contrastLevel: 1.0
    )
    XCTAssertEqual(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme), 0xffff_ffff)
  }

  func testLightTheme_minContrast_surface() {
    let scheme = SchemeExpressive(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: false,
      contrastLevel: -1.0
    )
    XCTAssertEqual(MaterialDynamicColors.surface.getArgb(scheme), 0xfffd_f7ff)
  }

  func testLightTheme_standardContrast_surface() {
    let scheme = SchemeExpressive(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: false,
      contrastLevel: 0.0
    )
    XCTAssertEqual(MaterialDynamicColors.surface.getArgb(scheme), 0xfffd_f7ff)
  }

  func testLightTheme_maxContrast_surface() {
    let scheme = SchemeExpressive(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: false,
      contrastLevel: 1.0
    )
    XCTAssertEqual(MaterialDynamicColors.surface.getArgb(scheme), 0xfffd_f7ff)
  }

  func testDarkTheme_minContrast_primary() {
    let scheme = SchemeExpressive(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: true,
      contrastLevel: -1.0
    )
    XCTAssertEqual(MaterialDynamicColors.primary.getArgb(scheme), 0xff51_a078)
  }

  func testDarkTheme_standardContrast_primary() {
    let scheme = SchemeExpressive(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: true,
      contrastLevel: 0.0
    )
    XCTAssertEqual(MaterialDynamicColors.primary.getArgb(scheme), 0xff87_d7ab)
  }

  func testDarkTheme_maxContrast_primary() {
    let scheme = SchemeExpressive(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: true,
      contrastLevel: 1.0
    )
    XCTAssertEqual(MaterialDynamicColors.primary.getArgb(scheme), 0xffee_fff2)
  }

  func testDarkTheme_minContrast_primaryContainer() {
    let scheme = SchemeExpressive(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: true,
      contrastLevel: -1.0
    )
    XCTAssertEqual(MaterialDynamicColors.primaryContainer.getArgb(scheme), 0xff00_432a)
  }

  func testDarkTheme_standardContrast_primaryContainer() {
    let scheme = SchemeExpressive(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: true,
      contrastLevel: 0.0
    )
    XCTAssertEqual(MaterialDynamicColors.primaryContainer.getArgb(scheme), 0xff00_5234)
  }

  func testDarkTheme_maxContrast_primaryContainer() {
    let scheme = SchemeExpressive(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: true,
      contrastLevel: 1.0
    )
    XCTAssertEqual(MaterialDynamicColors.primaryContainer.getArgb(scheme), 0xff8b_dbaf)
  }

  func testDarkTheme_minContrast_onPrimaryContainer() {
    let scheme = SchemeExpressive(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: true,
      contrastLevel: -1.0
    )
    XCTAssertEqual(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme), 0xff64_b48a)
  }

  func testDarkTheme_standardContrast_onPrimaryContainer() {
    let scheme = SchemeExpressive(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: true,
      contrastLevel: 0.0
    )
    XCTAssertEqual(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme), 0xffa2_f4c6)
  }

  func testDarkTheme_maxContrast_onPrimaryContainer() {
    let scheme = SchemeExpressive(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: true,
      contrastLevel: 1.0
    )
    XCTAssertEqual(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme), 0xff00_0000)
  }

  func testDarkTheme_minContrast_surface() {
    let scheme = SchemeExpressive(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: true,
      contrastLevel: -1.0
    )
    XCTAssertEqual(MaterialDynamicColors.surface.getArgb(scheme), 0xff14_121a)
  }

  func testDarkTheme_standardContrast_surface() {
    let scheme = SchemeExpressive(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: true,
      contrastLevel: 0.0
    )
    XCTAssertEqual(MaterialDynamicColors.surface.getArgb(scheme), 0xff14_121a)
  }

  func testDarkTheme_maxContrast_surface() {
    let scheme = SchemeExpressive(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: true,
      contrastLevel: 1.0
    )
    XCTAssertEqual(MaterialDynamicColors.surface.getArgb(scheme), 0xff14_121a)
  }
}
