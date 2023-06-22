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

final class SchemeNeutralTests: XCTestCase {
  func testKeyColors() {
    let scheme = SchemeNeutral(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: false,
      contrastLevel: 0.0
    )

    XCTAssertEqual(MaterialDynamicColors.primaryPaletteKeyColor.getArgb(scheme), 0xff76_7685)
    XCTAssertEqual(MaterialDynamicColors.secondaryPaletteKeyColor.getArgb(scheme), 0xff77_7680)
    XCTAssertEqual(MaterialDynamicColors.tertiaryPaletteKeyColor.getArgb(scheme), 0xff75_758b)
    XCTAssertEqual(MaterialDynamicColors.neutralPaletteKeyColor.getArgb(scheme), 0xff78_7678)
    XCTAssertEqual(MaterialDynamicColors.neutralVariantPaletteKeyColor.getArgb(scheme), 0xff78_7678)
  }

  func testLightSchemeNeutralMinContrast() {
    let scheme = SchemeNeutral(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: false,
      contrastLevel: -1
    )

    XCTAssertEqual(MaterialDynamicColors.background.getArgb(scheme), 0xfffc_f8fa)
    XCTAssertEqual(MaterialDynamicColors.onBackground.getArgb(scheme), 0xff92_8f91)
    XCTAssertEqual(MaterialDynamicColors.surface.getArgb(scheme), 0xfffc_f8fa)
    XCTAssertEqual(MaterialDynamicColors.surfaceDim.getArgb(scheme), 0xffdc_d9db)
    XCTAssertEqual(MaterialDynamicColors.surfaceBright.getArgb(scheme), 0xfffc_f8fa)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerLowest.getArgb(scheme), 0xffff_ffff)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerLow.getArgb(scheme), 0xfff6_f2f4)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainer.getArgb(scheme), 0xfff1_edef)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerHigh.getArgb(scheme), 0xffeb_e7e9)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerHighest.getArgb(scheme), 0xffe5_e1e3)
    XCTAssertEqual(MaterialDynamicColors.onSurface.getArgb(scheme), 0xff60_5e60)
    XCTAssertEqual(MaterialDynamicColors.onSurfaceVariant.getArgb(scheme), 0xff7c_7a7c)
    XCTAssertEqual(MaterialDynamicColors.surfaceVariant.getArgb(scheme), 0xffe5_e1e3)
    XCTAssertEqual(MaterialDynamicColors.inverseSurface.getArgb(scheme), 0xff31_3032)
    XCTAssertEqual(MaterialDynamicColors.inverseOnSurface.getArgb(scheme), 0xff9a_9799)
    XCTAssertEqual(MaterialDynamicColors.outline.getArgb(scheme), 0xffb4_b1b3)
    XCTAssertEqual(MaterialDynamicColors.outlineVariant.getArgb(scheme), 0xffdb_d8da)
    XCTAssertEqual(MaterialDynamicColors.shadow.getArgb(scheme), 0xff00_0000)
    XCTAssertEqual(MaterialDynamicColors.scrim.getArgb(scheme), 0xff00_0000)
    XCTAssertEqual(MaterialDynamicColors.surfaceTint.getArgb(scheme), 0xff5d_5d6c)
    XCTAssertEqual(MaterialDynamicColors.primary.getArgb(scheme), 0xff73_7383)
    XCTAssertEqual(MaterialDynamicColors.onPrimary.getArgb(scheme), 0xffff_fbff)
    XCTAssertEqual(MaterialDynamicColors.primaryContainer.getArgb(scheme), 0xffd9_d7e9)
    XCTAssertEqual(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme), 0xff5d_5d6c)
    XCTAssertEqual(MaterialDynamicColors.inversePrimary.getArgb(scheme), 0xff79_7888)
    XCTAssertEqual(MaterialDynamicColors.secondary.getArgb(scheme), 0xff74_737d)
    XCTAssertEqual(MaterialDynamicColors.onSecondary.getArgb(scheme), 0xffff_fbff)
    XCTAssertEqual(MaterialDynamicColors.secondaryContainer.getArgb(scheme), 0xffda_d7e2)
    XCTAssertEqual(MaterialDynamicColors.onSecondaryContainer.getArgb(scheme), 0xff5e_5d67)
    XCTAssertEqual(MaterialDynamicColors.tertiary.getArgb(scheme), 0xff72_7389)
    XCTAssertEqual(MaterialDynamicColors.onTertiary.getArgb(scheme), 0xffff_fbff)
    XCTAssertEqual(MaterialDynamicColors.tertiaryContainer.getArgb(scheme), 0xffd7_d7f0)
    XCTAssertEqual(MaterialDynamicColors.onTertiaryContainer.getArgb(scheme), 0xff5c_5d72)
    XCTAssertEqual(MaterialDynamicColors.error.getArgb(scheme), 0xffda_342e)
    XCTAssertEqual(MaterialDynamicColors.onError.getArgb(scheme), 0xffff_fbff)
    XCTAssertEqual(MaterialDynamicColors.errorContainer.getArgb(scheme), 0xffff_cdc7)
    XCTAssertEqual(MaterialDynamicColors.onErrorContainer.getArgb(scheme), 0xffba_1a1a)
    XCTAssertEqual(MaterialDynamicColors.primaryFixed.getArgb(scheme), 0xffd9_d7e9)
    XCTAssertEqual(MaterialDynamicColors.primaryFixedDim.getArgb(scheme), 0xffbd_bbcd)
    XCTAssertEqual(MaterialDynamicColors.onPrimaryFixed.getArgb(scheme), 0xff4b_4b59)
    XCTAssertEqual(MaterialDynamicColors.onPrimaryFixedVariant.getArgb(scheme), 0xff65_6574)
    XCTAssertEqual(MaterialDynamicColors.secondaryFixed.getArgb(scheme), 0xffda_d7e2)
    XCTAssertEqual(MaterialDynamicColors.secondaryFixedDim.getArgb(scheme), 0xffbe_bcc6)
    XCTAssertEqual(MaterialDynamicColors.onSecondaryFixed.getArgb(scheme), 0xff4c_4b54)
    XCTAssertEqual(MaterialDynamicColors.onSecondaryFixedVariant.getArgb(scheme), 0xff66_656f)
    XCTAssertEqual(MaterialDynamicColors.tertiaryFixed.getArgb(scheme), 0xffd7_d7f0)
    XCTAssertEqual(MaterialDynamicColors.tertiaryFixedDim.getArgb(scheme), 0xffbc_bbd3)
    XCTAssertEqual(MaterialDynamicColors.onTertiaryFixed.getArgb(scheme), 0xff4a_4b5f)
    XCTAssertEqual(MaterialDynamicColors.onTertiaryFixedVariant.getArgb(scheme), 0xff64_657a)
  }

  func testLightSchemeNeutralStandardContrast() {
    let scheme = SchemeNeutral(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: false,
      contrastLevel: 0
    )

    XCTAssertEqual(MaterialDynamicColors.background.getArgb(scheme), 0xfffc_f8fa)
    XCTAssertEqual(MaterialDynamicColors.onBackground.getArgb(scheme), 0xff1c_1b1d)
    XCTAssertEqual(MaterialDynamicColors.surface.getArgb(scheme), 0xfffc_f8fa)
    XCTAssertEqual(MaterialDynamicColors.surfaceDim.getArgb(scheme), 0xffdc_d9db)
    XCTAssertEqual(MaterialDynamicColors.surfaceBright.getArgb(scheme), 0xfffc_f8fa)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerLowest.getArgb(scheme), 0xffff_ffff)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerLow.getArgb(scheme), 0xfff6_f2f4)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainer.getArgb(scheme), 0xfff1_edef)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerHigh.getArgb(scheme), 0xffeb_e7e9)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerHighest.getArgb(scheme), 0xffe5_e1e3)
    XCTAssertEqual(MaterialDynamicColors.onSurface.getArgb(scheme), 0xff1c_1b1d)
    XCTAssertEqual(MaterialDynamicColors.onSurfaceVariant.getArgb(scheme), 0xff47_4648)
    XCTAssertEqual(MaterialDynamicColors.surfaceVariant.getArgb(scheme), 0xffe5_e1e3)
    XCTAssertEqual(MaterialDynamicColors.inverseSurface.getArgb(scheme), 0xff31_3032)
    XCTAssertEqual(MaterialDynamicColors.inverseOnSurface.getArgb(scheme), 0xfff3_f0f1)
    XCTAssertEqual(MaterialDynamicColors.outline.getArgb(scheme), 0xff78_7678)
    XCTAssertEqual(MaterialDynamicColors.outlineVariant.getArgb(scheme), 0xffc9_c6c7)
    XCTAssertEqual(MaterialDynamicColors.shadow.getArgb(scheme), 0xff00_0000)
    XCTAssertEqual(MaterialDynamicColors.scrim.getArgb(scheme), 0xff00_0000)
    XCTAssertEqual(MaterialDynamicColors.surfaceTint.getArgb(scheme), 0xff5d_5d6c)
    XCTAssertEqual(MaterialDynamicColors.primary.getArgb(scheme), 0xff5d_5d6c)
    XCTAssertEqual(MaterialDynamicColors.onPrimary.getArgb(scheme), 0xffff_ffff)
    XCTAssertEqual(MaterialDynamicColors.primaryContainer.getArgb(scheme), 0xffe2_e1f3)
    XCTAssertEqual(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme), 0xff1a_1b27)
    XCTAssertEqual(MaterialDynamicColors.inversePrimary.getArgb(scheme), 0xffc6_c5d6)
    XCTAssertEqual(MaterialDynamicColors.secondary.getArgb(scheme), 0xff5e_5d67)
    XCTAssertEqual(MaterialDynamicColors.onSecondary.getArgb(scheme), 0xffff_ffff)
    XCTAssertEqual(MaterialDynamicColors.secondaryContainer.getArgb(scheme), 0xffe4_e1ec)
    XCTAssertEqual(MaterialDynamicColors.onSecondaryContainer.getArgb(scheme), 0xff1b_1b23)
    XCTAssertEqual(MaterialDynamicColors.tertiary.getArgb(scheme), 0xff5c_5d72)
    XCTAssertEqual(MaterialDynamicColors.onTertiary.getArgb(scheme), 0xffff_ffff)
    XCTAssertEqual(MaterialDynamicColors.tertiaryContainer.getArgb(scheme), 0xffe1_e0f9)
    XCTAssertEqual(MaterialDynamicColors.onTertiaryContainer.getArgb(scheme), 0xff19_1a2c)
    XCTAssertEqual(MaterialDynamicColors.error.getArgb(scheme), 0xffba_1a1a)
    XCTAssertEqual(MaterialDynamicColors.onError.getArgb(scheme), 0xffff_ffff)
    XCTAssertEqual(MaterialDynamicColors.errorContainer.getArgb(scheme), 0xffff_dad6)
    XCTAssertEqual(MaterialDynamicColors.onErrorContainer.getArgb(scheme), 0xff41_0002)
    XCTAssertEqual(MaterialDynamicColors.primaryFixed.getArgb(scheme), 0xffe2_e1f3)
    XCTAssertEqual(MaterialDynamicColors.primaryFixedDim.getArgb(scheme), 0xffc6_c5d6)
    XCTAssertEqual(MaterialDynamicColors.onPrimaryFixed.getArgb(scheme), 0xff1a_1b27)
    XCTAssertEqual(MaterialDynamicColors.onPrimaryFixedVariant.getArgb(scheme), 0xff45_4654)
    XCTAssertEqual(MaterialDynamicColors.secondaryFixed.getArgb(scheme), 0xffe4_e1ec)
    XCTAssertEqual(MaterialDynamicColors.secondaryFixedDim.getArgb(scheme), 0xffc7_c5d0)
    XCTAssertEqual(MaterialDynamicColors.onSecondaryFixed.getArgb(scheme), 0xff1b_1b23)
    XCTAssertEqual(MaterialDynamicColors.onSecondaryFixedVariant.getArgb(scheme), 0xff46_464f)
    XCTAssertEqual(MaterialDynamicColors.tertiaryFixed.getArgb(scheme), 0xffe1_e0f9)
    XCTAssertEqual(MaterialDynamicColors.tertiaryFixedDim.getArgb(scheme), 0xffc5_c4dd)
    XCTAssertEqual(MaterialDynamicColors.onTertiaryFixed.getArgb(scheme), 0xff19_1a2c)
    XCTAssertEqual(MaterialDynamicColors.onTertiaryFixedVariant.getArgb(scheme), 0xff44_4559)
  }

  func testLightSchemeNeutralMaxContrast() {
    let scheme = SchemeNeutral(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: false,
      contrastLevel: 1
    )

    XCTAssertEqual(MaterialDynamicColors.background.getArgb(scheme), 0xfffc_f8fa)
    XCTAssertEqual(MaterialDynamicColors.onBackground.getArgb(scheme), 0xff1c_1b1d)
    XCTAssertEqual(MaterialDynamicColors.surface.getArgb(scheme), 0xfffc_f8fa)
    XCTAssertEqual(MaterialDynamicColors.surfaceDim.getArgb(scheme), 0xffdc_d9db)
    XCTAssertEqual(MaterialDynamicColors.surfaceBright.getArgb(scheme), 0xfffc_f8fa)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerLowest.getArgb(scheme), 0xffff_ffff)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerLow.getArgb(scheme), 0xfff6_f2f4)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainer.getArgb(scheme), 0xfff1_edef)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerHigh.getArgb(scheme), 0xffeb_e7e9)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerHighest.getArgb(scheme), 0xffe5_e1e3)
    XCTAssertEqual(MaterialDynamicColors.onSurface.getArgb(scheme), 0xff00_0000)
    XCTAssertEqual(MaterialDynamicColors.onSurfaceVariant.getArgb(scheme), 0xff24_2425)
    XCTAssertEqual(MaterialDynamicColors.surfaceVariant.getArgb(scheme), 0xffe5_e1e3)
    XCTAssertEqual(MaterialDynamicColors.inverseSurface.getArgb(scheme), 0xff31_3032)
    XCTAssertEqual(MaterialDynamicColors.inverseOnSurface.getArgb(scheme), 0xffff_ffff)
    XCTAssertEqual(MaterialDynamicColors.outline.getArgb(scheme), 0xff43_4244)
    XCTAssertEqual(MaterialDynamicColors.outlineVariant.getArgb(scheme), 0xff43_4244)
    XCTAssertEqual(MaterialDynamicColors.shadow.getArgb(scheme), 0xff00_0000)
    XCTAssertEqual(MaterialDynamicColors.scrim.getArgb(scheme), 0xff00_0000)
    XCTAssertEqual(MaterialDynamicColors.surfaceTint.getArgb(scheme), 0xff5d_5d6c)
    XCTAssertEqual(MaterialDynamicColors.primary.getArgb(scheme), 0xff21_212e)
    XCTAssertEqual(MaterialDynamicColors.onPrimary.getArgb(scheme), 0xffff_ffff)
    XCTAssertEqual(MaterialDynamicColors.primaryContainer.getArgb(scheme), 0xff41_4250)
    XCTAssertEqual(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme), 0xffff_ffff)
    XCTAssertEqual(MaterialDynamicColors.inversePrimary.getArgb(scheme), 0xffec_eafc)
    XCTAssertEqual(MaterialDynamicColors.secondary.getArgb(scheme), 0xff21_2229)
    XCTAssertEqual(MaterialDynamicColors.onSecondary.getArgb(scheme), 0xffff_ffff)
    XCTAssertEqual(MaterialDynamicColors.secondaryContainer.getArgb(scheme), 0xff42_424b)
    XCTAssertEqual(MaterialDynamicColors.onSecondaryContainer.getArgb(scheme), 0xffff_ffff)
    XCTAssertEqual(MaterialDynamicColors.tertiary.getArgb(scheme), 0xff20_2133)
    XCTAssertEqual(MaterialDynamicColors.onTertiary.getArgb(scheme), 0xffff_ffff)
    XCTAssertEqual(MaterialDynamicColors.tertiaryContainer.getArgb(scheme), 0xff40_4155)
    XCTAssertEqual(MaterialDynamicColors.onTertiaryContainer.getArgb(scheme), 0xffff_ffff)
    XCTAssertEqual(MaterialDynamicColors.error.getArgb(scheme), 0xff4e_0002)
    XCTAssertEqual(MaterialDynamicColors.onError.getArgb(scheme), 0xffff_ffff)
    XCTAssertEqual(MaterialDynamicColors.errorContainer.getArgb(scheme), 0xff8c_0009)
    XCTAssertEqual(MaterialDynamicColors.onErrorContainer.getArgb(scheme), 0xffff_ffff)
    XCTAssertEqual(MaterialDynamicColors.primaryFixed.getArgb(scheme), 0xff41_4250)
    XCTAssertEqual(MaterialDynamicColors.primaryFixedDim.getArgb(scheme), 0xff2b_2c39)
    XCTAssertEqual(MaterialDynamicColors.onPrimaryFixed.getArgb(scheme), 0xffff_ffff)
    XCTAssertEqual(MaterialDynamicColors.onPrimaryFixedVariant.getArgb(scheme), 0xffff_ffff)
    XCTAssertEqual(MaterialDynamicColors.secondaryFixed.getArgb(scheme), 0xff42_424b)
    XCTAssertEqual(MaterialDynamicColors.secondaryFixedDim.getArgb(scheme), 0xff2c_2c34)
    XCTAssertEqual(MaterialDynamicColors.onSecondaryFixed.getArgb(scheme), 0xffff_ffff)
    XCTAssertEqual(MaterialDynamicColors.onSecondaryFixedVariant.getArgb(scheme), 0xffff_ffff)
    XCTAssertEqual(MaterialDynamicColors.tertiaryFixed.getArgb(scheme), 0xff40_4155)
    XCTAssertEqual(MaterialDynamicColors.tertiaryFixedDim.getArgb(scheme), 0xff2a_2b3e)
    XCTAssertEqual(MaterialDynamicColors.onTertiaryFixed.getArgb(scheme), 0xffff_ffff)
    XCTAssertEqual(MaterialDynamicColors.onTertiaryFixedVariant.getArgb(scheme), 0xffff_ffff)
  }

  func testDarkSchemeNeutralMinContrast() {
    let scheme = SchemeNeutral(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: true,
      contrastLevel: -1
    )

    XCTAssertEqual(MaterialDynamicColors.background.getArgb(scheme), 0xff13_1315)
    XCTAssertEqual(MaterialDynamicColors.onBackground.getArgb(scheme), 0xff63_6263)
    XCTAssertEqual(MaterialDynamicColors.surface.getArgb(scheme), 0xff13_1315)
    XCTAssertEqual(MaterialDynamicColors.surfaceDim.getArgb(scheme), 0xff13_1315)
    XCTAssertEqual(MaterialDynamicColors.surfaceBright.getArgb(scheme), 0xff3a_393a)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerLowest.getArgb(scheme), 0xff0e_0e0f)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerLow.getArgb(scheme), 0xff1c_1b1d)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainer.getArgb(scheme), 0xff20_1f21)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerHigh.getArgb(scheme), 0xff2a_2a2b)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerHighest.getArgb(scheme), 0xff35_3436)
    XCTAssertEqual(MaterialDynamicColors.onSurface.getArgb(scheme), 0xffa5_a2a4)
    XCTAssertEqual(MaterialDynamicColors.onSurfaceVariant.getArgb(scheme), 0xff84_8284)
    XCTAssertEqual(MaterialDynamicColors.surfaceVariant.getArgb(scheme), 0xff47_4648)
    XCTAssertEqual(MaterialDynamicColors.inverseSurface.getArgb(scheme), 0xffe5_e1e3)
    XCTAssertEqual(MaterialDynamicColors.inverseOnSurface.getArgb(scheme), 0xff65_6465)
    XCTAssertEqual(MaterialDynamicColors.outline.getArgb(scheme), 0xff55_5455)
    XCTAssertEqual(MaterialDynamicColors.outlineVariant.getArgb(scheme), 0xff3b_3a3b)
    XCTAssertEqual(MaterialDynamicColors.shadow.getArgb(scheme), 0xff00_0000)
    XCTAssertEqual(MaterialDynamicColors.scrim.getArgb(scheme), 0xff00_0000)
    XCTAssertEqual(MaterialDynamicColors.surfaceTint.getArgb(scheme), 0xffc6_c5d6)
    XCTAssertEqual(MaterialDynamicColors.primary.getArgb(scheme), 0xff90_8f9f)
    XCTAssertEqual(MaterialDynamicColors.onPrimary.getArgb(scheme), 0xff28_2936)
    XCTAssertEqual(MaterialDynamicColors.primaryContainer.getArgb(scheme), 0xff39_3947)
    XCTAssertEqual(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme), 0xffa3_a2b3)
    XCTAssertEqual(MaterialDynamicColors.inversePrimary.getArgb(scheme), 0xff80_7f8f)
    XCTAssertEqual(MaterialDynamicColors.secondary.getArgb(scheme), 0xff91_909a)
    XCTAssertEqual(MaterialDynamicColors.onSecondary.getArgb(scheme), 0xff29_2931)
    XCTAssertEqual(MaterialDynamicColors.secondaryContainer.getArgb(scheme), 0xff39_3942)
    XCTAssertEqual(MaterialDynamicColors.onSecondaryContainer.getArgb(scheme), 0xffa4_a3ad)
    XCTAssertEqual(MaterialDynamicColors.tertiary.getArgb(scheme), 0xff8f_8fa6)
    XCTAssertEqual(MaterialDynamicColors.onTertiary.getArgb(scheme), 0xff27_283b)
    XCTAssertEqual(MaterialDynamicColors.tertiaryContainer.getArgb(scheme), 0xff38_394c)
    XCTAssertEqual(MaterialDynamicColors.onTertiaryContainer.getArgb(scheme), 0xffa2_a2b9)
    XCTAssertEqual(MaterialDynamicColors.error.getArgb(scheme), 0xffff_5449)
    XCTAssertEqual(MaterialDynamicColors.onError.getArgb(scheme), 0xff5c_0003)
    XCTAssertEqual(MaterialDynamicColors.errorContainer.getArgb(scheme), 0xff7b_0007)
    XCTAssertEqual(MaterialDynamicColors.onErrorContainer.getArgb(scheme), 0xffff_7d70)
    XCTAssertEqual(MaterialDynamicColors.primaryFixed.getArgb(scheme), 0xff50_505e)
    XCTAssertEqual(MaterialDynamicColors.primaryFixedDim.getArgb(scheme), 0xff39_3947)
    XCTAssertEqual(MaterialDynamicColors.onPrimaryFixed.getArgb(scheme), 0xffc4_c2d4)
    XCTAssertEqual(MaterialDynamicColors.onPrimaryFixedVariant.getArgb(scheme), 0xff9f_9eaf)
    XCTAssertEqual(MaterialDynamicColors.secondaryFixed.getArgb(scheme), 0xff51_5059)
    XCTAssertEqual(MaterialDynamicColors.secondaryFixedDim.getArgb(scheme), 0xff39_3942)
    XCTAssertEqual(MaterialDynamicColors.onSecondaryFixed.getArgb(scheme), 0xffc5_c3cd)
    XCTAssertEqual(MaterialDynamicColors.onSecondaryFixedVariant.getArgb(scheme), 0xffa0_9fa9)
    XCTAssertEqual(MaterialDynamicColors.tertiaryFixed.getArgb(scheme), 0xff4f_4f64)
    XCTAssertEqual(MaterialDynamicColors.tertiaryFixedDim.getArgb(scheme), 0xff38_394c)
    XCTAssertEqual(MaterialDynamicColors.onTertiaryFixed.getArgb(scheme), 0xffc2_c2da)
    XCTAssertEqual(MaterialDynamicColors.onTertiaryFixedVariant.getArgb(scheme), 0xff9e_9eb5)
  }

  func testDarkSchemeNeutralStandardContrast() {
    let scheme = SchemeNeutral(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: true,
      contrastLevel: 0
    )

    XCTAssertEqual(MaterialDynamicColors.background.getArgb(scheme), 0xff13_1315)
    XCTAssertEqual(MaterialDynamicColors.onBackground.getArgb(scheme), 0xffe5_e1e3)
    XCTAssertEqual(MaterialDynamicColors.surface.getArgb(scheme), 0xff13_1315)
    XCTAssertEqual(MaterialDynamicColors.surfaceDim.getArgb(scheme), 0xff13_1315)
    XCTAssertEqual(MaterialDynamicColors.surfaceBright.getArgb(scheme), 0xff3a_393a)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerLowest.getArgb(scheme), 0xff0e_0e0f)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerLow.getArgb(scheme), 0xff1c_1b1d)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainer.getArgb(scheme), 0xff20_1f21)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerHigh.getArgb(scheme), 0xff2a_2a2b)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerHighest.getArgb(scheme), 0xff35_3436)
    XCTAssertEqual(MaterialDynamicColors.onSurface.getArgb(scheme), 0xffe5_e1e3)
    XCTAssertEqual(MaterialDynamicColors.onSurfaceVariant.getArgb(scheme), 0xffc9_c6c7)
    XCTAssertEqual(MaterialDynamicColors.surfaceVariant.getArgb(scheme), 0xff47_4648)
    XCTAssertEqual(MaterialDynamicColors.inverseSurface.getArgb(scheme), 0xffe5_e1e3)
    XCTAssertEqual(MaterialDynamicColors.inverseOnSurface.getArgb(scheme), 0xff31_3032)
    XCTAssertEqual(MaterialDynamicColors.outline.getArgb(scheme), 0xff92_9092)
    XCTAssertEqual(MaterialDynamicColors.outlineVariant.getArgb(scheme), 0xff47_4648)
    XCTAssertEqual(MaterialDynamicColors.shadow.getArgb(scheme), 0xff00_0000)
    XCTAssertEqual(MaterialDynamicColors.scrim.getArgb(scheme), 0xff00_0000)
    XCTAssertEqual(MaterialDynamicColors.surfaceTint.getArgb(scheme), 0xffc6_c5d6)
    XCTAssertEqual(MaterialDynamicColors.primary.getArgb(scheme), 0xffc6_c5d6)
    XCTAssertEqual(MaterialDynamicColors.onPrimary.getArgb(scheme), 0xff2f_2f3d)
    XCTAssertEqual(MaterialDynamicColors.primaryContainer.getArgb(scheme), 0xff45_4654)
    XCTAssertEqual(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme), 0xffe2_e1f3)
    XCTAssertEqual(MaterialDynamicColors.inversePrimary.getArgb(scheme), 0xff5d_5d6c)
    XCTAssertEqual(MaterialDynamicColors.secondary.getArgb(scheme), 0xffc7_c5d0)
    XCTAssertEqual(MaterialDynamicColors.onSecondary.getArgb(scheme), 0xff30_3038)
    XCTAssertEqual(MaterialDynamicColors.secondaryContainer.getArgb(scheme), 0xff46_464f)
    XCTAssertEqual(MaterialDynamicColors.onSecondaryContainer.getArgb(scheme), 0xffe4_e1ec)
    XCTAssertEqual(MaterialDynamicColors.tertiary.getArgb(scheme), 0xffc5_c4dd)
    XCTAssertEqual(MaterialDynamicColors.onTertiary.getArgb(scheme), 0xff2e_2f42)
    XCTAssertEqual(MaterialDynamicColors.tertiaryContainer.getArgb(scheme), 0xff44_4559)
    XCTAssertEqual(MaterialDynamicColors.onTertiaryContainer.getArgb(scheme), 0xffe1_e0f9)
    XCTAssertEqual(MaterialDynamicColors.error.getArgb(scheme), 0xffff_b4ab)
    XCTAssertEqual(MaterialDynamicColors.onError.getArgb(scheme), 0xff69_0005)
    XCTAssertEqual(MaterialDynamicColors.errorContainer.getArgb(scheme), 0xff93_000a)
    XCTAssertEqual(MaterialDynamicColors.onErrorContainer.getArgb(scheme), 0xffff_dad6)
    XCTAssertEqual(MaterialDynamicColors.primaryFixed.getArgb(scheme), 0xffe2_e1f3)
    XCTAssertEqual(MaterialDynamicColors.primaryFixedDim.getArgb(scheme), 0xffc6_c5d6)
    XCTAssertEqual(MaterialDynamicColors.onPrimaryFixed.getArgb(scheme), 0xff1a_1b27)
    XCTAssertEqual(MaterialDynamicColors.onPrimaryFixedVariant.getArgb(scheme), 0xff45_4654)
    XCTAssertEqual(MaterialDynamicColors.secondaryFixed.getArgb(scheme), 0xffe4_e1ec)
    XCTAssertEqual(MaterialDynamicColors.secondaryFixedDim.getArgb(scheme), 0xffc7_c5d0)
    XCTAssertEqual(MaterialDynamicColors.onSecondaryFixed.getArgb(scheme), 0xff1b_1b23)
    XCTAssertEqual(MaterialDynamicColors.onSecondaryFixedVariant.getArgb(scheme), 0xff46_464f)
    XCTAssertEqual(MaterialDynamicColors.tertiaryFixed.getArgb(scheme), 0xffe1_e0f9)
    XCTAssertEqual(MaterialDynamicColors.tertiaryFixedDim.getArgb(scheme), 0xffc5_c4dd)
    XCTAssertEqual(MaterialDynamicColors.onTertiaryFixed.getArgb(scheme), 0xff19_1a2c)
    XCTAssertEqual(MaterialDynamicColors.onTertiaryFixedVariant.getArgb(scheme), 0xff44_4559)
  }

  func testDarkSchemeNeutralMaxContrast() {
    let scheme = SchemeNeutral(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: true,
      contrastLevel: 1
    )

    XCTAssertEqual(MaterialDynamicColors.background.getArgb(scheme), 0xff13_1315)
    XCTAssertEqual(MaterialDynamicColors.onBackground.getArgb(scheme), 0xffe5_e1e3)
    XCTAssertEqual(MaterialDynamicColors.surface.getArgb(scheme), 0xff13_1315)
    XCTAssertEqual(MaterialDynamicColors.surfaceDim.getArgb(scheme), 0xff13_1315)
    XCTAssertEqual(MaterialDynamicColors.surfaceBright.getArgb(scheme), 0xff3a_393a)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerLowest.getArgb(scheme), 0xff0e_0e0f)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerLow.getArgb(scheme), 0xff1c_1b1d)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainer.getArgb(scheme), 0xff20_1f21)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerHigh.getArgb(scheme), 0xff2a_2a2b)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerHighest.getArgb(scheme), 0xff35_3436)
    XCTAssertEqual(MaterialDynamicColors.onSurface.getArgb(scheme), 0xffff_ffff)
    XCTAssertEqual(MaterialDynamicColors.onSurfaceVariant.getArgb(scheme), 0xfffe_fafb)
    XCTAssertEqual(MaterialDynamicColors.surfaceVariant.getArgb(scheme), 0xff47_4648)
    XCTAssertEqual(MaterialDynamicColors.inverseSurface.getArgb(scheme), 0xffe5_e1e3)
    XCTAssertEqual(MaterialDynamicColors.inverseOnSurface.getArgb(scheme), 0xff00_0000)
    XCTAssertEqual(MaterialDynamicColors.outline.getArgb(scheme), 0xffcd_cacc)
    XCTAssertEqual(MaterialDynamicColors.outlineVariant.getArgb(scheme), 0xffcd_cacc)
    XCTAssertEqual(MaterialDynamicColors.shadow.getArgb(scheme), 0xff00_0000)
    XCTAssertEqual(MaterialDynamicColors.scrim.getArgb(scheme), 0xff00_0000)
    XCTAssertEqual(MaterialDynamicColors.surfaceTint.getArgb(scheme), 0xffc6_c5d6)
    XCTAssertEqual(MaterialDynamicColors.primary.getArgb(scheme), 0xfffd_f9ff)
    XCTAssertEqual(MaterialDynamicColors.onPrimary.getArgb(scheme), 0xff00_0000)
    XCTAssertEqual(MaterialDynamicColors.primaryContainer.getArgb(scheme), 0xffca_c9da)
    XCTAssertEqual(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme), 0xff00_0000)
    XCTAssertEqual(MaterialDynamicColors.inversePrimary.getArgb(scheme), 0xff28_2936)
    XCTAssertEqual(MaterialDynamicColors.secondary.getArgb(scheme), 0xfffd_f9ff)
    XCTAssertEqual(MaterialDynamicColors.onSecondary.getArgb(scheme), 0xff00_0000)
    XCTAssertEqual(MaterialDynamicColors.secondaryContainer.getArgb(scheme), 0xffcb_c9d4)
    XCTAssertEqual(MaterialDynamicColors.onSecondaryContainer.getArgb(scheme), 0xff00_0000)
    XCTAssertEqual(MaterialDynamicColors.tertiary.getArgb(scheme), 0xfffd_f9ff)
    XCTAssertEqual(MaterialDynamicColors.onTertiary.getArgb(scheme), 0xff00_0000)
    XCTAssertEqual(MaterialDynamicColors.tertiaryContainer.getArgb(scheme), 0xffc9_c9e1)
    XCTAssertEqual(MaterialDynamicColors.onTertiaryContainer.getArgb(scheme), 0xff00_0000)
    XCTAssertEqual(MaterialDynamicColors.error.getArgb(scheme), 0xffff_f9f9)
    XCTAssertEqual(MaterialDynamicColors.onError.getArgb(scheme), 0xff00_0000)
    XCTAssertEqual(MaterialDynamicColors.errorContainer.getArgb(scheme), 0xffff_bab1)
    XCTAssertEqual(MaterialDynamicColors.onErrorContainer.getArgb(scheme), 0xff00_0000)
    XCTAssertEqual(MaterialDynamicColors.primaryFixed.getArgb(scheme), 0xffe7_e5f7)
    XCTAssertEqual(MaterialDynamicColors.primaryFixedDim.getArgb(scheme), 0xffca_c9da)
    XCTAssertEqual(MaterialDynamicColors.onPrimaryFixed.getArgb(scheme), 0xff00_0000)
    XCTAssertEqual(MaterialDynamicColors.onPrimaryFixedVariant.getArgb(scheme), 0xff15_1522)
    XCTAssertEqual(MaterialDynamicColors.secondaryFixed.getArgb(scheme), 0xffe8_e5f0)
    XCTAssertEqual(MaterialDynamicColors.secondaryFixedDim.getArgb(scheme), 0xffcb_c9d4)
    XCTAssertEqual(MaterialDynamicColors.onSecondaryFixed.getArgb(scheme), 0xff00_0000)
    XCTAssertEqual(MaterialDynamicColors.onSecondaryFixedVariant.getArgb(scheme), 0xff15_161d)
    XCTAssertEqual(MaterialDynamicColors.tertiaryFixed.getArgb(scheme), 0xffe6_e4fe)
    XCTAssertEqual(MaterialDynamicColors.tertiaryFixedDim.getArgb(scheme), 0xffc9_c9e1)
    XCTAssertEqual(MaterialDynamicColors.onTertiaryFixed.getArgb(scheme), 0xff00_0000)
    XCTAssertEqual(MaterialDynamicColors.onTertiaryFixedVariant.getArgb(scheme), 0xff14_1526)
  }

}
