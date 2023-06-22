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

final class SchemeRainbowTests: XCTestCase {
  func testKeyColors() {
    let scheme = SchemeRainbow(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: false,
      contrastLevel: 0.0
    )

    XCTAssertEqual(MaterialDynamicColors.primaryPaletteKeyColor.getArgb(scheme), 0xff69_6fc4)
    XCTAssertEqual(MaterialDynamicColors.secondaryPaletteKeyColor.getArgb(scheme), 0xff75_758b)
    XCTAssertEqual(MaterialDynamicColors.tertiaryPaletteKeyColor.getArgb(scheme), 0xff93_6b84)
    XCTAssertEqual(MaterialDynamicColors.neutralPaletteKeyColor.getArgb(scheme), 0xff07_0707)
    XCTAssertEqual(MaterialDynamicColors.neutralVariantPaletteKeyColor.getArgb(scheme), 0xff07_0707)
  }

  func testLightTheme_minContrast_primary() {
    let scheme = SchemeRainbow(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: false,
      contrastLevel: -1.0
    )
    XCTAssertEqual(MaterialDynamicColors.primary.getArgb(scheme), 0xff67_6dc1)
  }

  func testLightTheme_standardContrast_primary() {
    let scheme = SchemeRainbow(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: false,
      contrastLevel: 0.0
    )
    XCTAssertEqual(MaterialDynamicColors.primary.getArgb(scheme), 0xff50_56a9)
  }

  func testLightTheme_maxContrast_primary() {
    let scheme = SchemeRainbow(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: false,
      contrastLevel: 1.0
    )
    XCTAssertEqual(MaterialDynamicColors.primary.getArgb(scheme), 0xff0f_136a)
  }

  func testLightTheme_minContrast_primaryContainer() {
    let scheme = SchemeRainbow(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: false,
      contrastLevel: -1.0
    )
    XCTAssertEqual(MaterialDynamicColors.primaryContainer.getArgb(scheme), 0xffd5_d6ff)
  }

  func testLightTheme_standardContrast_primaryContainer() {
    let scheme = SchemeRainbow(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: false,
      contrastLevel: 0.0
    )
    XCTAssertEqual(MaterialDynamicColors.primaryContainer.getArgb(scheme), 0xffe0_e0ff)
  }

  func testLightTheme_maxContrast_primaryContainer() {
    let scheme = SchemeRainbow(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: false,
      contrastLevel: 1.0
    )
    XCTAssertEqual(MaterialDynamicColors.primaryContainer.getArgb(scheme), 0xff34_398b)
  }

  func testLightTheme_minContrast_tertiaryContainer() {
    let scheme = SchemeRainbow(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: false,
      contrastLevel: -1.0
    )
    XCTAssertEqual(MaterialDynamicColors.tertiaryContainer.getArgb(scheme), 0xfffb_cbe7)
  }

  func testLightTheme_standardContrast_tertiaryContainer() {
    let scheme = SchemeRainbow(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: false,
      contrastLevel: 0.0
    )
    XCTAssertEqual(MaterialDynamicColors.tertiaryContainer.getArgb(scheme), 0xffff_d8ee)
  }

  func testLightTheme_maxContrast_tertiaryContainer() {
    let scheme = SchemeRainbow(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: false,
      contrastLevel: 1.0
    )
    XCTAssertEqual(MaterialDynamicColors.tertiaryContainer.getArgb(scheme), 0xff5a_384e)
  }

  func testLightTheme_minContrast_onPrimaryContainer() {
    let scheme = SchemeRainbow(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: false,
      contrastLevel: -1.0
    )
    XCTAssertEqual(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme), 0xff50_56a9)
  }

  func testLightTheme_standardContrast_onPrimaryContainer() {
    let scheme = SchemeRainbow(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: false,
      contrastLevel: 0.0
    )
    XCTAssertEqual(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme), 0xff05_0865)
  }

  func testLightTheme_maxContrast_onPrimaryContainer() {
    let scheme = SchemeRainbow(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: false,
      contrastLevel: 1.0
    )
    XCTAssertEqual(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme), 0xffff_ffff)
  }

  func testLightTheme_minContrast_surface() {
    let scheme = SchemeRainbow(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: false,
      contrastLevel: -1.0
    )
    XCTAssertEqual(MaterialDynamicColors.surface.getArgb(scheme), 0xfff9_f9f9)
  }

  func testLightTheme_standardContrast_surface() {
    let scheme = SchemeRainbow(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: false,
      contrastLevel: 0.0
    )
    XCTAssertEqual(MaterialDynamicColors.surface.getArgb(scheme), 0xfff9_f9f9)
  }

  func testLightTheme_maxContrast_surface() {
    let scheme = SchemeRainbow(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: false,
      contrastLevel: 1.0
    )
    XCTAssertEqual(MaterialDynamicColors.surface.getArgb(scheme), 0xfff9_f9f9)
  }

  func testLightTheme_standardContrast_secondary() {
    let scheme = SchemeRainbow(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: false,
      contrastLevel: 0.0
    )
    XCTAssertEqual(MaterialDynamicColors.secondary.getArgb(scheme), 0xff5c_5d72)
  }

  func testLightTheme_standardContrast_secondaryContainer() {
    let scheme = SchemeRainbow(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: false,
      contrastLevel: 0.0
    )
    XCTAssertEqual(MaterialDynamicColors.secondaryContainer.getArgb(scheme), 0xffe1_e0f9)
  }

  func testDarkTheme_minContrast_primary() {
    let scheme = SchemeRainbow(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: true,
      contrastLevel: -1.0
    )
    XCTAssertEqual(MaterialDynamicColors.primary.getArgb(scheme), 0xff83_89e0)
  }

  func testDarkTheme_standardContrast_primary() {
    let scheme = SchemeRainbow(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: true,
      contrastLevel: 0.0
    )
    XCTAssertEqual(MaterialDynamicColors.primary.getArgb(scheme), 0xffbe_c2ff)
  }

  func testDarkTheme_maxContrast_primary() {
    let scheme = SchemeRainbow(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: true,
      contrastLevel: 1.0
    )
    XCTAssertEqual(MaterialDynamicColors.primary.getArgb(scheme), 0xfffd_f9ff)
  }

  func testDarkTheme_minContrast_primaryContainer() {
    let scheme = SchemeRainbow(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: true,
      contrastLevel: -1.0
    )
    XCTAssertEqual(MaterialDynamicColors.primaryContainer.getArgb(scheme), 0xff2a_3082)
  }

  func testDarkTheme_standardContrast_primaryContainer() {
    let scheme = SchemeRainbow(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: true,
      contrastLevel: 0.0
    )
    XCTAssertEqual(MaterialDynamicColors.primaryContainer.getArgb(scheme), 0xff38_3e8f)
  }

  func testDarkTheme_maxContrast_primaryContainer() {
    let scheme = SchemeRainbow(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: true,
      contrastLevel: 1.0
    )
    XCTAssertEqual(MaterialDynamicColors.primaryContainer.getArgb(scheme), 0xffc4_c6ff)
  }

  func testDarkTheme_minContrast_onPrimaryContainer() {
    let scheme = SchemeRainbow(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: true,
      contrastLevel: -1.0
    )
    XCTAssertEqual(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme), 0xff96_9cf5)
  }

  func testDarkTheme_standardContrast_onPrimaryContainer() {
    let scheme = SchemeRainbow(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: true,
      contrastLevel: 0.0
    )
    XCTAssertEqual(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme), 0xffe0_e0ff)
  }

  func testDarkTheme_maxContrast_onPrimaryContainer() {
    let scheme = SchemeRainbow(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: true,
      contrastLevel: 1.0
    )
    XCTAssertEqual(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme), 0xff00_0000)
  }

  func testDarkTheme_minContrast_onTertiaryContainer() {
    let scheme = SchemeRainbow(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: true,
      contrastLevel: -1.0
    )
    XCTAssertEqual(MaterialDynamicColors.onTertiaryContainer.getArgb(scheme), 0xffc3_97b2)
  }

  func testDarkTheme_standardContrast_onTertiaryContainer() {
    let scheme = SchemeRainbow(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: true,
      contrastLevel: 0.0
    )
    XCTAssertEqual(MaterialDynamicColors.onTertiaryContainer.getArgb(scheme), 0xffff_d8ee)
  }

  func testDarkTheme_maxContrast_onTertiaryContainer() {
    let scheme = SchemeRainbow(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: true,
      contrastLevel: 1.0
    )
    XCTAssertEqual(MaterialDynamicColors.onTertiaryContainer.getArgb(scheme), 0xff00_0000)
  }

  func testDarkTheme_minContrast_surface() {
    let scheme = SchemeRainbow(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: true,
      contrastLevel: -1.0
    )
    XCTAssertEqual(MaterialDynamicColors.surface.getArgb(scheme), 0xff13_1313)
  }

  func testDarkTheme_standardContrast_surface() {
    let scheme = SchemeRainbow(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: true,
      contrastLevel: 0.0
    )
    XCTAssertEqual(MaterialDynamicColors.surface.getArgb(scheme), 0xff13_1313)
  }

  func testDarkTheme_maxContrast_surface() {
    let scheme = SchemeRainbow(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: true,
      contrastLevel: 1.0
    )
    XCTAssertEqual(MaterialDynamicColors.surface.getArgb(scheme), 0xff13_1313)
  }

  func testDarkTheme_standardContrast_secondary() {
    let scheme = SchemeRainbow(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: true,
      contrastLevel: 0.0
    )
    XCTAssertEqual(MaterialDynamicColors.secondary.getArgb(scheme), 0xffc5_c4dd)
  }

  func testDarkTheme_standardContrast_secondaryContainer() {
    let scheme = SchemeRainbow(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: true,
      contrastLevel: 0.0
    )
    XCTAssertEqual(MaterialDynamicColors.secondaryContainer.getArgb(scheme), 0xff44_4559)
  }
}
