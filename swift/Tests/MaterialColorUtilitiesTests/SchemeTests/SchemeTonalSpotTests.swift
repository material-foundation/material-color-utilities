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
  func testBlueLightScheme() {
    let scheme = SchemeTonalSpot(
      sourceColorHct: Hct(0xff00_00ff), isDark: false, contrastLevel: 0.0)

    XCTAssertEqual(scheme.primary, 0xff55_5992)
  }

  func testBlueDarkScheme() {
    let scheme = SchemeTonalSpot(sourceColorHct: Hct(0xff00_00ff), isDark: true, contrastLevel: 0.0)

    XCTAssertEqual(scheme.primary, 0xffbe_c2ff)
  }

  func test3rdPartyLightScheme() {
    let scheme = SchemeTonalSpot(
      sourceColorHct: Hct(0xff67_50a4), isDark: false, contrastLevel: 0.0)

    XCTAssertEqual(scheme.primary, 0xff65_558f)
    XCTAssertEqual(scheme.secondary, 0xff62_5b71)
    XCTAssertEqual(scheme.tertiary, 0xff7e_5260)
    XCTAssertEqual(scheme.surface, 0xfffd_f7ff)
    XCTAssertEqual(scheme.onSurface, 0xff1d_1b20)
  }

  func test3rdPartyDarkScheme() {
    let scheme = SchemeTonalSpot(sourceColorHct: Hct(0xff67_50a4), isDark: true, contrastLevel: 0.0)

    XCTAssertEqual(scheme.primary, 0xffcf_bdfe)
    XCTAssertEqual(scheme.secondary, 0xffcb_c2db)
    XCTAssertEqual(scheme.tertiary, 0xffef_b8c8)
    XCTAssertEqual(scheme.surface, 0xff14_1218)
    XCTAssertEqual(scheme.onSurface, 0xffe6_e0e9)
  }

  func testLightSchemeFromHighChromaColor() {
    let scheme = SchemeTonalSpot(
      sourceColorHct: Hct(0xfffa_2bec), isDark: false, contrastLevel: 0.0)

    XCTAssertEqual(scheme.primary, 0xff81_4c77)
    XCTAssertEqual(scheme.onPrimary, 0xffff_ffff)
    XCTAssertEqual(scheme.primaryContainer, 0xffff_d7f3)
    XCTAssertEqual(scheme.onPrimaryContainer, 0xff67_355e)
    XCTAssertEqual(scheme.secondary, 0xff6e_5868)
    XCTAssertEqual(scheme.onSecondary, 0xffff_ffff)
    XCTAssertEqual(scheme.secondaryContainer, 0xfff8_daee)
    XCTAssertEqual(scheme.onSecondaryContainer, 0xff55_4050)
    XCTAssertEqual(scheme.tertiary, 0xff81_5343)
    XCTAssertEqual(scheme.onTertiary, 0xffff_ffff)
    XCTAssertEqual(scheme.tertiaryContainer, 0xffff_dbd0)
    XCTAssertEqual(scheme.onTertiaryContainer, 0xff66_3c2d)
    XCTAssertEqual(scheme.error, 0xffba_1a1a)
    XCTAssertEqual(scheme.onError, 0xffff_ffff)
    XCTAssertEqual(scheme.errorContainer, 0xffff_dad6)
    XCTAssertEqual(scheme.onErrorContainer, 0xff93_000a)
    XCTAssertEqual(scheme.background, 0xffff_f7f9)
    XCTAssertEqual(scheme.onBackground, 0xff20_1a1e)
    XCTAssertEqual(scheme.surface, 0xffff_f7f9)
    XCTAssertEqual(scheme.onSurface, 0xff20_1a1e)
    XCTAssertEqual(scheme.surfaceVariant, 0xffee_dee7)
    XCTAssertEqual(scheme.onSurfaceVariant, 0xff4e_444b)
    XCTAssertEqual(scheme.outline, 0xff80_747b)
    XCTAssertEqual(scheme.outlineVariant, 0xffd2_c2cb)
    XCTAssertEqual(scheme.shadow, 0xff00_0000)
    XCTAssertEqual(scheme.scrim, 0xff00_0000)
    XCTAssertEqual(scheme.inverseSurface, 0xff36_2e33)
    XCTAssertEqual(scheme.inverseOnSurface, 0xfffa_edf3)
    XCTAssertEqual(scheme.inversePrimary, 0xfff3_b2e4)
  }

  func testDarkSchemeFromHighChromaColor() {
    let scheme = SchemeTonalSpot(sourceColorHct: Hct(0xfffa_2bec), isDark: true, contrastLevel: 0.0)

    XCTAssertEqual(scheme.primary, 0xfff3_b2e4)
    XCTAssertEqual(scheme.onPrimary, 0xff4d_1f47)
    XCTAssertEqual(scheme.primaryContainer, 0xff67_355e)
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
    XCTAssertEqual(scheme.onErrorContainer, 0xffff_dad6)
    XCTAssertEqual(scheme.background, 0xff18_1216)
    XCTAssertEqual(scheme.onBackground, 0xffec_dfe5)
    XCTAssertEqual(scheme.surface, 0xff18_1216)
    XCTAssertEqual(scheme.onSurface, 0xffec_dfe5)
    XCTAssertEqual(scheme.surfaceVariant, 0xff4e_444b)
    XCTAssertEqual(scheme.onSurfaceVariant, 0xffd2_c2cb)
    XCTAssertEqual(scheme.outline, 0xff9a_8d95)
    XCTAssertEqual(scheme.outlineVariant, 0xff4e_444b)
    XCTAssertEqual(scheme.shadow, 0xff00_0000)
    XCTAssertEqual(scheme.scrim, 0xff00_0000)
    XCTAssertEqual(scheme.inverseSurface, 0xffec_dfe5)
    XCTAssertEqual(scheme.inverseOnSurface, 0xff36_2e33)
    XCTAssertEqual(scheme.inversePrimary, 0xff81_4c77)
  }

  func testLightContentSchemeFromHighChromaColor() {
    let scheme = SchemeContent(sourceColorHct: Hct(0xfffa_2bec), isDark: false, contrastLevel: 0.0)

    XCTAssertEqual(scheme.primary, 0xffa7_009e)
    XCTAssertEqual(scheme.onPrimary, 0xffff_ffff)
    XCTAssertEqual(scheme.primaryContainer, 0xffd1_00c6)
    XCTAssertEqual(scheme.onPrimaryContainer, 0xffff_fbff)
    XCTAssertEqual(scheme.secondary, 0xff9e_2d93)
    XCTAssertEqual(scheme.onSecondary, 0xffff_ffff)
    XCTAssertEqual(scheme.secondaryContainer, 0xffff_83ec)
    XCTAssertEqual(scheme.onSecondaryContainer, 0xff7c_0276)
    XCTAssertEqual(scheme.tertiary, 0xffb5_1830)
    XCTAssertEqual(scheme.onTertiary, 0xffff_ffff)
    XCTAssertEqual(scheme.tertiaryContainer, 0xffd8_3546)
    XCTAssertEqual(scheme.onTertiaryContainer, 0xffff_fbff)
    XCTAssertEqual(scheme.error, 0xffba_1a1a)
    XCTAssertEqual(scheme.onError, 0xffff_ffff)
    XCTAssertEqual(scheme.errorContainer, 0xffff_dad6)
    XCTAssertEqual(scheme.onErrorContainer, 0xff93_000a)
    XCTAssertEqual(scheme.background, 0xffff_f7f9)
    XCTAssertEqual(scheme.onBackground, 0xff25_1722)
    XCTAssertEqual(scheme.surface, 0xffff_f7f9)
    XCTAssertEqual(scheme.onSurface, 0xff25_1722)
    XCTAssertEqual(scheme.surfaceVariant, 0xfff9_daee)
    XCTAssertEqual(scheme.onSurfaceVariant, 0xff56_4050)
    XCTAssertEqual(scheme.outline, 0xff89_7081)
    XCTAssertEqual(scheme.outlineVariant, 0xffdc_bed2)
    XCTAssertEqual(scheme.shadow, 0xff00_0000)
    XCTAssertEqual(scheme.scrim, 0xff00_0000)
    XCTAssertEqual(scheme.inverseSurface, 0xff3b_2c37)
    XCTAssertEqual(scheme.inverseOnSurface, 0xffff_ebf6)
    XCTAssertEqual(scheme.inversePrimary, 0xffff_abee)
  }

  func testDarkContentSchemeFromHighChromaColor() {
    let scheme = SchemeContent(sourceColorHct: Hct(0xfffa_2bec), isDark: true, contrastLevel: 0.0)

    XCTAssertEqual(scheme.primary, 0xffff_abee)
    XCTAssertEqual(scheme.onPrimary, 0xff5c_0057)
    XCTAssertEqual(scheme.primaryContainer, 0xfffa_2bec)
    XCTAssertEqual(scheme.onPrimaryContainer, 0xff51_004c)
    XCTAssertEqual(scheme.secondary, 0xffff_abee)
    XCTAssertEqual(scheme.onSecondary, 0xff5c_0057)
    XCTAssertEqual(scheme.secondaryContainer, 0xff84_0f7c)
    XCTAssertEqual(scheme.onSecondaryContainer, 0xffff_93ec)
    XCTAssertEqual(scheme.tertiary, 0xffff_b3b2)
    XCTAssertEqual(scheme.onTertiary, 0xff68_0014)
    XCTAssertEqual(scheme.tertiaryContainer, 0xffff_525f)
    XCTAssertEqual(scheme.onTertiaryContainer, 0xff5b_0010)
    XCTAssertEqual(scheme.error, 0xffff_b4ab)
    XCTAssertEqual(scheme.onError, 0xff69_0005)
    XCTAssertEqual(scheme.errorContainer, 0xff93_000a)
    XCTAssertEqual(scheme.onErrorContainer, 0xffff_dad6)
    XCTAssertEqual(scheme.background, 0xff1c_0f19)
    XCTAssertEqual(scheme.onBackground, 0xfff4_dceb)
    XCTAssertEqual(scheme.surface, 0xff1c_0f19)
    XCTAssertEqual(scheme.onSurface, 0xfff4_dceb)
    XCTAssertEqual(scheme.surfaceVariant, 0xff56_4050)
    XCTAssertEqual(scheme.onSurfaceVariant, 0xffdc_bed2)
    XCTAssertEqual(scheme.outline, 0xffa4_899b)
    XCTAssertEqual(scheme.outlineVariant, 0xff56_4050)
    XCTAssertEqual(scheme.shadow, 0xff00_0000)
    XCTAssertEqual(scheme.scrim, 0xff00_0000)
    XCTAssertEqual(scheme.inverseSurface, 0xfff4_dceb)
    XCTAssertEqual(scheme.inverseOnSurface, 0xff3b_2c37)
    XCTAssertEqual(scheme.inversePrimary, 0xffab_00a2)
  }
}
