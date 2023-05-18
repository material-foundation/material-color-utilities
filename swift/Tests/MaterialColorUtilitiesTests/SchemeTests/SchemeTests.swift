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

final class SchemeTests: XCTestCase {
  func testBlueLightScheme() {
    let scheme = Scheme.light(0xff00_00ff)

    XCTAssertEqual(scheme.primary, 0xff34_3DFF)
  }

  func testBlueDarkScheme() {
    let scheme = Scheme.dark(0xff00_00ff)

    XCTAssertEqual(scheme.primary, 0xffBE_C2FF)
  }

  func test3rdPartyLightScheme() {
    let scheme = Scheme.light(0xff67_50A4)

    XCTAssertEqual(scheme.primary, 0xff67_50A4)
    XCTAssertEqual(scheme.secondary, 0xff62_5B71)
    XCTAssertEqual(scheme.tertiary, 0xff7E_5260)
    XCTAssertEqual(scheme.surface, 0xffFF_FBFF)
    XCTAssertEqual(scheme.onSurface, 0xff1C_1B1E)
  }

  func test3rdPartyDarkScheme() {
    let scheme = Scheme.dark(0xff67_50A4)

    XCTAssertEqual(scheme.primary, 0xffCF_BCFF)
    XCTAssertEqual(scheme.secondary, 0xffCB_C2DB)
    XCTAssertEqual(scheme.tertiary, 0xffEF_B8C8)
    XCTAssertEqual(scheme.surface, 0xff1c_1b1e)
    XCTAssertEqual(scheme.onSurface, 0xffE6_E1E6)
  }

  func testLightSchemeFromHighChromaColor() {
    let scheme = Scheme.light(0xfffa_2bec)

    XCTAssertEqual(scheme.primary, 0xffab_00a2)
    XCTAssertEqual(scheme.onPrimary, 0xffff_ffff)
    XCTAssertEqual(scheme.primaryContainer, 0xffff_d7f3)
    XCTAssertEqual(scheme.onPrimaryContainer, 0xff39_0035)
    XCTAssertEqual(scheme.secondary, 0xff6e_5868)
    XCTAssertEqual(scheme.onSecondary, 0xffff_ffff)
    XCTAssertEqual(scheme.secondaryContainer, 0xfff8_daee)
    XCTAssertEqual(scheme.onSecondaryContainer, 0xff27_1624)
    XCTAssertEqual(scheme.tertiary, 0xff81_5343)
    XCTAssertEqual(scheme.onTertiary, 0xffff_ffff)
    XCTAssertEqual(scheme.tertiaryContainer, 0xffff_dbd0)
    XCTAssertEqual(scheme.onTertiaryContainer, 0xff32_1207)
    XCTAssertEqual(scheme.error, 0xffba_1a1a)
    XCTAssertEqual(scheme.onError, 0xffff_ffff)
    XCTAssertEqual(scheme.errorContainer, 0xffff_dad6)
    XCTAssertEqual(scheme.onErrorContainer, 0xff41_0002)
    XCTAssertEqual(scheme.background, 0xffff_fbff)
    XCTAssertEqual(scheme.onBackground, 0xff1f_1a1d)
    XCTAssertEqual(scheme.surface, 0xffff_fbff)
    XCTAssertEqual(scheme.onSurface, 0xff1f_1a1d)
    XCTAssertEqual(scheme.surfaceVariant, 0xffee_dee7)
    XCTAssertEqual(scheme.onSurfaceVariant, 0xff4e_444b)
    XCTAssertEqual(scheme.outline, 0xff80_747b)
    XCTAssertEqual(scheme.outlineVariant, 0xffd2_c2cb)
    XCTAssertEqual(scheme.shadow, 0xff00_0000)
    XCTAssertEqual(scheme.scrim, 0xff00_0000)
    XCTAssertEqual(scheme.inverseSurface, 0xff34_2f32)
    XCTAssertEqual(scheme.inverseOnSurface, 0xfff8_eef2)
    XCTAssertEqual(scheme.inversePrimary, 0xffff_abee)
  }

  func testDarkSchemeFromHighChromaColor() {
    let scheme = Scheme.dark(0xfffa_2bec)

    XCTAssertEqual(scheme.primary, 0xffff_abee)
    XCTAssertEqual(scheme.onPrimary, 0xff5c_0057)
    XCTAssertEqual(scheme.primaryContainer, 0xff83_007b)
    XCTAssertEqual(scheme.onPrimaryContainer, 0xffff_d7f3)
    XCTAssertEqual(scheme.secondary, 0xffdb_bed1)
    XCTAssertEqual(scheme.onSecondary, 0xff3e_2a39)
    XCTAssertEqual(scheme.secondaryContainer, 0xff55_4050)
    XCTAssertEqual(scheme.onSecondaryContainer, 0xfff8_daee)
    XCTAssertEqual(scheme.tertiary, 0xfff5_b9a5)
    XCTAssertEqual(scheme.onTertiary, 0xff4c_2619)
    XCTAssertEqual(scheme.tertiaryContainer, 0xff66_3c2d)
    XCTAssertEqual(scheme.onTertiaryContainer, 0xffff_dbd0)
    XCTAssertEqual(scheme.error, 0xffff_b4ab)
    XCTAssertEqual(scheme.onError, 0xff69_0005)
    XCTAssertEqual(scheme.errorContainer, 0xff93_000a)
    XCTAssertEqual(scheme.onErrorContainer, 0xffff_b4ab)
    XCTAssertEqual(scheme.background, 0xff1f_1a1d)
    XCTAssertEqual(scheme.onBackground, 0xffea_e0e4)
    XCTAssertEqual(scheme.surface, 0xff1f_1a1d)
    XCTAssertEqual(scheme.onSurface, 0xffea_e0e4)
    XCTAssertEqual(scheme.surfaceVariant, 0xff4e_444b)
    XCTAssertEqual(scheme.onSurfaceVariant, 0xffd2_c2cb)
    XCTAssertEqual(scheme.outline, 0xff9a_8d95)
    XCTAssertEqual(scheme.outlineVariant, 0xff4e_444b)
    XCTAssertEqual(scheme.shadow, 0xff00_0000)
    XCTAssertEqual(scheme.scrim, 0xff00_0000)
    XCTAssertEqual(scheme.inverseSurface, 0xffea_e0e4)
    XCTAssertEqual(scheme.inverseOnSurface, 0xff34_2f32)
    XCTAssertEqual(scheme.inversePrimary, 0xffab_00a2)
  }

  func testLightContentSchemeFromHighChromaColor() {
    let scheme = Scheme.lightContent(0xfffa_2bec)

    XCTAssertEqual(scheme.primary, 0xffab_00a2)
    XCTAssertEqual(scheme.onPrimary, 0xffff_ffff)
    XCTAssertEqual(scheme.primaryContainer, 0xffff_d7f3)
    XCTAssertEqual(scheme.onPrimaryContainer, 0xff39_0035)
    XCTAssertEqual(scheme.secondary, 0xff7f_4e75)
    XCTAssertEqual(scheme.onSecondary, 0xffff_ffff)
    XCTAssertEqual(scheme.secondaryContainer, 0xffff_d7f3)
    XCTAssertEqual(scheme.onSecondaryContainer, 0xff33_0b2f)
    XCTAssertEqual(scheme.tertiary, 0xff9c_4323)
    XCTAssertEqual(scheme.onTertiary, 0xffff_ffff)
    XCTAssertEqual(scheme.tertiaryContainer, 0xffff_dbd0)
    XCTAssertEqual(scheme.onTertiaryContainer, 0xff39_0c00)
    XCTAssertEqual(scheme.error, 0xffba_1a1a)
    XCTAssertEqual(scheme.onError, 0xffff_ffff)
    XCTAssertEqual(scheme.errorContainer, 0xffff_dad6)
    XCTAssertEqual(scheme.onErrorContainer, 0xff41_0002)
    XCTAssertEqual(scheme.background, 0xffff_fbff)
    XCTAssertEqual(scheme.onBackground, 0xff1f_1a1d)
    XCTAssertEqual(scheme.surface, 0xffff_fbff)
    XCTAssertEqual(scheme.onSurface, 0xff1f_1a1d)
    XCTAssertEqual(scheme.surfaceVariant, 0xffee_dee7)
    XCTAssertEqual(scheme.onSurfaceVariant, 0xff4e_444b)
    XCTAssertEqual(scheme.outline, 0xff80_747b)
    XCTAssertEqual(scheme.outlineVariant, 0xffd2_c2cb)
    XCTAssertEqual(scheme.shadow, 0xff00_0000)
    XCTAssertEqual(scheme.scrim, 0xff00_0000)
    XCTAssertEqual(scheme.inverseSurface, 0xff34_2f32)
    XCTAssertEqual(scheme.inverseOnSurface, 0xfff8_eef2)
    XCTAssertEqual(scheme.inversePrimary, 0xffff_abee)
  }

  func testDarkContentSchemeFromHighChromaColor() {
    let scheme = Scheme.darkContent(0xfffa_2bec)

    XCTAssertEqual(scheme.primary, 0xffff_abee)
    XCTAssertEqual(scheme.onPrimary, 0xff5c_0057)
    XCTAssertEqual(scheme.primaryContainer, 0xff83_007b)
    XCTAssertEqual(scheme.onPrimaryContainer, 0xffff_d7f3)
    XCTAssertEqual(scheme.secondary, 0xfff0_b4e1)
    XCTAssertEqual(scheme.onSecondary, 0xff4b_2145)
    XCTAssertEqual(scheme.secondaryContainer, 0xff64_375c)
    XCTAssertEqual(scheme.onSecondaryContainer, 0xffff_d7f3)
    XCTAssertEqual(scheme.tertiary, 0xffff_b59c)
    XCTAssertEqual(scheme.onTertiary, 0xff5c_1900)
    XCTAssertEqual(scheme.tertiaryContainer, 0xff7d_2c0d)
    XCTAssertEqual(scheme.onTertiaryContainer, 0xffff_dbd0)
    XCTAssertEqual(scheme.error, 0xffff_b4ab)
    XCTAssertEqual(scheme.onError, 0xff69_0005)
    XCTAssertEqual(scheme.errorContainer, 0xff93_000a)
    XCTAssertEqual(scheme.onErrorContainer, 0xffff_b4ab)
    XCTAssertEqual(scheme.background, 0xff1f_1a1d)
    XCTAssertEqual(scheme.onBackground, 0xffea_e0e4)
    XCTAssertEqual(scheme.surface, 0xff1f_1a1d)
    XCTAssertEqual(scheme.onSurface, 0xffea_e0e4)
    XCTAssertEqual(scheme.surfaceVariant, 0xff4e_444b)
    XCTAssertEqual(scheme.onSurfaceVariant, 0xffd2_c2cb)
    XCTAssertEqual(scheme.outline, 0xff9a_8d95)
    XCTAssertEqual(scheme.outlineVariant, 0xff4e_444b)
    XCTAssertEqual(scheme.shadow, 0xff00_0000)
    XCTAssertEqual(scheme.scrim, 0xff00_0000)
    XCTAssertEqual(scheme.inverseSurface, 0xffea_e0e4)
    XCTAssertEqual(scheme.inverseOnSurface, 0xff34_2f32)
    XCTAssertEqual(scheme.inversePrimary, 0xffab_00a2)
  }
}
