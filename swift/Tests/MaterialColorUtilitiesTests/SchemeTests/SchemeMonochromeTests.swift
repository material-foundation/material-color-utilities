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

final class SchemeMonochromeTests: XCTestCase {
  func testKeyColors() {
    let scheme = SchemeMonochrome(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: false,
      contrastLevel: 0.0
    )

    XCTAssertEqual(MaterialDynamicColors.primaryPaletteKeyColor.getArgb(scheme), 0xff07_0707)
    XCTAssertEqual(MaterialDynamicColors.secondaryPaletteKeyColor.getArgb(scheme), 0xff07_0707)
    XCTAssertEqual(MaterialDynamicColors.tertiaryPaletteKeyColor.getArgb(scheme), 0xff07_0707)
    XCTAssertEqual(MaterialDynamicColors.neutralPaletteKeyColor.getArgb(scheme), 0xff07_0707)
    XCTAssertEqual(MaterialDynamicColors.neutralVariantPaletteKeyColor.getArgb(scheme), 0xff07_0707)
  }

  func testLightSchemeMonochromeMinContrast() {
    let scheme = SchemeMonochrome(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: false,
      contrastLevel: -1
    )

    XCTAssertEqual(MaterialDynamicColors.background.getArgb(scheme), 0xfff9_f9f9)
    XCTAssertEqual(MaterialDynamicColors.onBackground.getArgb(scheme), 0xff90_9090)
    XCTAssertEqual(MaterialDynamicColors.surface.getArgb(scheme), 0xfff9_f9f9)
    XCTAssertEqual(MaterialDynamicColors.surfaceDim.getArgb(scheme), 0xffda_dada)
    XCTAssertEqual(MaterialDynamicColors.surfaceBright.getArgb(scheme), 0xfff9_f9f9)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerLowest.getArgb(scheme), 0xffff_ffff)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerLow.getArgb(scheme), 0xfff3_f3f3)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainer.getArgb(scheme), 0xffee_eeee)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerHigh.getArgb(scheme), 0xffe8_e8e8)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerHighest.getArgb(scheme), 0xffe2_e2e2)
    XCTAssertEqual(MaterialDynamicColors.onSurface.getArgb(scheme), 0xff5f_5f5f)
    XCTAssertEqual(MaterialDynamicColors.onSurfaceVariant.getArgb(scheme), 0xff7b_7b7b)
    XCTAssertEqual(MaterialDynamicColors.surfaceVariant.getArgb(scheme), 0xffe2_e2e2)
    XCTAssertEqual(MaterialDynamicColors.inverseSurface.getArgb(scheme), 0xff30_3030)
    XCTAssertEqual(MaterialDynamicColors.inverseOnSurface.getArgb(scheme), 0xff98_9898)
    XCTAssertEqual(MaterialDynamicColors.outline.getArgb(scheme), 0xffb2_b2b2)
    XCTAssertEqual(MaterialDynamicColors.outlineVariant.getArgb(scheme), 0xffd9_d9d9)
    XCTAssertEqual(MaterialDynamicColors.shadow.getArgb(scheme), 0xff00_0000)
    XCTAssertEqual(MaterialDynamicColors.scrim.getArgb(scheme), 0xff00_0000)
    XCTAssertEqual(MaterialDynamicColors.surfaceTint.getArgb(scheme), 0xff5e_5e5e)
    XCTAssertEqual(MaterialDynamicColors.primary.getArgb(scheme), 0xff74_7474)
    XCTAssertEqual(MaterialDynamicColors.onPrimary.getArgb(scheme), 0xfffc_fcfc)
    XCTAssertEqual(MaterialDynamicColors.primaryContainer.getArgb(scheme), 0xffd9_d9d9)
    XCTAssertEqual(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme), 0xff5e_5e5e)
    XCTAssertEqual(MaterialDynamicColors.inversePrimary.getArgb(scheme), 0xff7a_7a7a)
    XCTAssertEqual(MaterialDynamicColors.secondary.getArgb(scheme), 0xff74_7474)
    XCTAssertEqual(MaterialDynamicColors.onSecondary.getArgb(scheme), 0xfffc_fcfc)
    XCTAssertEqual(MaterialDynamicColors.secondaryContainer.getArgb(scheme), 0xffd9_d9d9)
    XCTAssertEqual(MaterialDynamicColors.onSecondaryContainer.getArgb(scheme), 0xff5e_5e5e)
    XCTAssertEqual(MaterialDynamicColors.tertiary.getArgb(scheme), 0xff74_7474)
    XCTAssertEqual(MaterialDynamicColors.onTertiary.getArgb(scheme), 0xfffc_fcfc)
    XCTAssertEqual(MaterialDynamicColors.tertiaryContainer.getArgb(scheme), 0xffd9_d9d9)
    XCTAssertEqual(MaterialDynamicColors.onTertiaryContainer.getArgb(scheme), 0xff5e_5e5e)
    XCTAssertEqual(MaterialDynamicColors.error.getArgb(scheme), 0xffda_342e)
    XCTAssertEqual(MaterialDynamicColors.onError.getArgb(scheme), 0xffff_fbff)
    XCTAssertEqual(MaterialDynamicColors.errorContainer.getArgb(scheme), 0xffff_cdc7)
    XCTAssertEqual(MaterialDynamicColors.onErrorContainer.getArgb(scheme), 0xffba_1a1a)
    XCTAssertEqual(MaterialDynamicColors.primaryFixed.getArgb(scheme), 0xffd9_d9d9)
    XCTAssertEqual(MaterialDynamicColors.primaryFixedDim.getArgb(scheme), 0xffbd_bdbd)
    XCTAssertEqual(MaterialDynamicColors.onPrimaryFixed.getArgb(scheme), 0xff4c_4c4c)
    XCTAssertEqual(MaterialDynamicColors.onPrimaryFixedVariant.getArgb(scheme), 0xff66_6666)
    XCTAssertEqual(MaterialDynamicColors.secondaryFixed.getArgb(scheme), 0xffd9_d9d9)
    XCTAssertEqual(MaterialDynamicColors.secondaryFixedDim.getArgb(scheme), 0xffbd_bdbd)
    XCTAssertEqual(MaterialDynamicColors.onSecondaryFixed.getArgb(scheme), 0xff4c_4c4c)
    XCTAssertEqual(MaterialDynamicColors.onSecondaryFixedVariant.getArgb(scheme), 0xff66_6666)
    XCTAssertEqual(MaterialDynamicColors.tertiaryFixed.getArgb(scheme), 0xffd9_d9d9)
    XCTAssertEqual(MaterialDynamicColors.tertiaryFixedDim.getArgb(scheme), 0xffbd_bdbd)
    XCTAssertEqual(MaterialDynamicColors.onTertiaryFixed.getArgb(scheme), 0xff4c_4c4c)
    XCTAssertEqual(MaterialDynamicColors.onTertiaryFixedVariant.getArgb(scheme), 0xff66_6666)
  }

  func testLightSchemeMonochromeStandardContrast() {
    let scheme = SchemeMonochrome(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: false,
      contrastLevel: 0
    )

    XCTAssertEqual(MaterialDynamicColors.background.getArgb(scheme), 0xfff9_f9f9)
    XCTAssertEqual(MaterialDynamicColors.onBackground.getArgb(scheme), 0xff1b_1b1b)
    XCTAssertEqual(MaterialDynamicColors.surface.getArgb(scheme), 0xfff9_f9f9)
    XCTAssertEqual(MaterialDynamicColors.surfaceDim.getArgb(scheme), 0xffda_dada)
    XCTAssertEqual(MaterialDynamicColors.surfaceBright.getArgb(scheme), 0xfff9_f9f9)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerLowest.getArgb(scheme), 0xffff_ffff)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerLow.getArgb(scheme), 0xfff3_f3f3)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainer.getArgb(scheme), 0xffee_eeee)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerHigh.getArgb(scheme), 0xffe8_e8e8)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerHighest.getArgb(scheme), 0xffe2_e2e2)
    XCTAssertEqual(MaterialDynamicColors.onSurface.getArgb(scheme), 0xff1b_1b1b)
    XCTAssertEqual(MaterialDynamicColors.onSurfaceVariant.getArgb(scheme), 0xff47_4747)
    XCTAssertEqual(MaterialDynamicColors.surfaceVariant.getArgb(scheme), 0xffe2_e2e2)
    XCTAssertEqual(MaterialDynamicColors.inverseSurface.getArgb(scheme), 0xff30_3030)
    XCTAssertEqual(MaterialDynamicColors.inverseOnSurface.getArgb(scheme), 0xfff1_f1f1)
    XCTAssertEqual(MaterialDynamicColors.outline.getArgb(scheme), 0xff77_7777)
    XCTAssertEqual(MaterialDynamicColors.outlineVariant.getArgb(scheme), 0xffc6_c6c6)
    XCTAssertEqual(MaterialDynamicColors.shadow.getArgb(scheme), 0xff00_0000)
    XCTAssertEqual(MaterialDynamicColors.scrim.getArgb(scheme), 0xff00_0000)
    XCTAssertEqual(MaterialDynamicColors.surfaceTint.getArgb(scheme), 0xff5e_5e5e)
    XCTAssertEqual(MaterialDynamicColors.primary.getArgb(scheme), 0xff00_0000)
    XCTAssertEqual(MaterialDynamicColors.onPrimary.getArgb(scheme), 0xffe2_e2e2)
    XCTAssertEqual(MaterialDynamicColors.primaryContainer.getArgb(scheme), 0xff3b_3b3b)
    XCTAssertEqual(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme), 0xffff_ffff)
    XCTAssertEqual(MaterialDynamicColors.inversePrimary.getArgb(scheme), 0xffc6_c6c6)
    XCTAssertEqual(MaterialDynamicColors.secondary.getArgb(scheme), 0xff5e_5e5e)
    XCTAssertEqual(MaterialDynamicColors.onSecondary.getArgb(scheme), 0xffff_ffff)
    XCTAssertEqual(MaterialDynamicColors.secondaryContainer.getArgb(scheme), 0xffd4_d4d4)
    XCTAssertEqual(MaterialDynamicColors.onSecondaryContainer.getArgb(scheme), 0xff1b_1b1b)
    XCTAssertEqual(MaterialDynamicColors.tertiary.getArgb(scheme), 0xff3b_3b3b)
    XCTAssertEqual(MaterialDynamicColors.onTertiary.getArgb(scheme), 0xffe2_e2e2)
    XCTAssertEqual(MaterialDynamicColors.tertiaryContainer.getArgb(scheme), 0xff74_7474)
    XCTAssertEqual(MaterialDynamicColors.onTertiaryContainer.getArgb(scheme), 0xffff_ffff)
    XCTAssertEqual(MaterialDynamicColors.error.getArgb(scheme), 0xffba_1a1a)
    XCTAssertEqual(MaterialDynamicColors.onError.getArgb(scheme), 0xffff_ffff)
    XCTAssertEqual(MaterialDynamicColors.errorContainer.getArgb(scheme), 0xffff_dad6)
    XCTAssertEqual(MaterialDynamicColors.onErrorContainer.getArgb(scheme), 0xff41_0002)
    XCTAssertEqual(MaterialDynamicColors.primaryFixed.getArgb(scheme), 0xff5e_5e5e)
    XCTAssertEqual(MaterialDynamicColors.primaryFixedDim.getArgb(scheme), 0xff47_4747)
    XCTAssertEqual(MaterialDynamicColors.onPrimaryFixed.getArgb(scheme), 0xffff_ffff)
    XCTAssertEqual(MaterialDynamicColors.onPrimaryFixedVariant.getArgb(scheme), 0xffe2_e2e2)
    XCTAssertEqual(MaterialDynamicColors.secondaryFixed.getArgb(scheme), 0xffc6_c6c6)
    XCTAssertEqual(MaterialDynamicColors.secondaryFixedDim.getArgb(scheme), 0xffab_abab)
    XCTAssertEqual(MaterialDynamicColors.onSecondaryFixed.getArgb(scheme), 0xff1b_1b1b)
    XCTAssertEqual(MaterialDynamicColors.onSecondaryFixedVariant.getArgb(scheme), 0xff3b_3b3b)
    XCTAssertEqual(MaterialDynamicColors.tertiaryFixed.getArgb(scheme), 0xff5e_5e5e)
    XCTAssertEqual(MaterialDynamicColors.tertiaryFixedDim.getArgb(scheme), 0xff47_4747)
    XCTAssertEqual(MaterialDynamicColors.onTertiaryFixed.getArgb(scheme), 0xffff_ffff)
    XCTAssertEqual(MaterialDynamicColors.onTertiaryFixedVariant.getArgb(scheme), 0xffe2_e2e2)
  }

  func testLightSchemeMonochromeMaxContrast() {
    let scheme = SchemeMonochrome(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: false,
      contrastLevel: 1
    )

    XCTAssertEqual(MaterialDynamicColors.background.getArgb(scheme), 0xfff9_f9f9)
    XCTAssertEqual(MaterialDynamicColors.onBackground.getArgb(scheme), 0xff1b_1b1b)
    XCTAssertEqual(MaterialDynamicColors.surface.getArgb(scheme), 0xfff9_f9f9)
    XCTAssertEqual(MaterialDynamicColors.surfaceDim.getArgb(scheme), 0xffda_dada)
    XCTAssertEqual(MaterialDynamicColors.surfaceBright.getArgb(scheme), 0xfff9_f9f9)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerLowest.getArgb(scheme), 0xffff_ffff)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerLow.getArgb(scheme), 0xfff3_f3f3)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainer.getArgb(scheme), 0xffee_eeee)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerHigh.getArgb(scheme), 0xffe8_e8e8)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerHighest.getArgb(scheme), 0xffe2_e2e2)
    XCTAssertEqual(MaterialDynamicColors.onSurface.getArgb(scheme), 0xff00_0000)
    XCTAssertEqual(MaterialDynamicColors.onSurfaceVariant.getArgb(scheme), 0xff24_2424)
    XCTAssertEqual(MaterialDynamicColors.surfaceVariant.getArgb(scheme), 0xffe2_e2e2)
    XCTAssertEqual(MaterialDynamicColors.inverseSurface.getArgb(scheme), 0xff30_3030)
    XCTAssertEqual(MaterialDynamicColors.inverseOnSurface.getArgb(scheme), 0xffff_ffff)
    XCTAssertEqual(MaterialDynamicColors.outline.getArgb(scheme), 0xff43_4343)
    XCTAssertEqual(MaterialDynamicColors.outlineVariant.getArgb(scheme), 0xff43_4343)
    XCTAssertEqual(MaterialDynamicColors.shadow.getArgb(scheme), 0xff00_0000)
    XCTAssertEqual(MaterialDynamicColors.scrim.getArgb(scheme), 0xff00_0000)
    XCTAssertEqual(MaterialDynamicColors.surfaceTint.getArgb(scheme), 0xff5e_5e5e)
    XCTAssertEqual(MaterialDynamicColors.primary.getArgb(scheme), 0xff00_0000)
    XCTAssertEqual(MaterialDynamicColors.onPrimary.getArgb(scheme), 0xffff_ffff)
    XCTAssertEqual(MaterialDynamicColors.primaryContainer.getArgb(scheme), 0xff3b_3b3b)
    XCTAssertEqual(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme), 0xffff_ffff)
    XCTAssertEqual(MaterialDynamicColors.inversePrimary.getArgb(scheme), 0xffec_ecec)
    XCTAssertEqual(MaterialDynamicColors.secondary.getArgb(scheme), 0xff22_2222)
    XCTAssertEqual(MaterialDynamicColors.onSecondary.getArgb(scheme), 0xffff_ffff)
    XCTAssertEqual(MaterialDynamicColors.secondaryContainer.getArgb(scheme), 0xff43_4343)
    XCTAssertEqual(MaterialDynamicColors.onSecondaryContainer.getArgb(scheme), 0xffff_ffff)
    XCTAssertEqual(MaterialDynamicColors.tertiary.getArgb(scheme), 0xff22_2222)
    XCTAssertEqual(MaterialDynamicColors.onTertiary.getArgb(scheme), 0xffff_ffff)
    XCTAssertEqual(MaterialDynamicColors.tertiaryContainer.getArgb(scheme), 0xff43_4343)
    XCTAssertEqual(MaterialDynamicColors.onTertiaryContainer.getArgb(scheme), 0xffff_ffff)
    XCTAssertEqual(MaterialDynamicColors.error.getArgb(scheme), 0xff4e_0002)
    XCTAssertEqual(MaterialDynamicColors.onError.getArgb(scheme), 0xffff_ffff)
    XCTAssertEqual(MaterialDynamicColors.errorContainer.getArgb(scheme), 0xff8c_0009)
    XCTAssertEqual(MaterialDynamicColors.onErrorContainer.getArgb(scheme), 0xffff_ffff)
    XCTAssertEqual(MaterialDynamicColors.primaryFixed.getArgb(scheme), 0xff43_4343)
    XCTAssertEqual(MaterialDynamicColors.primaryFixedDim.getArgb(scheme), 0xff2d_2d2d)
    XCTAssertEqual(MaterialDynamicColors.onPrimaryFixed.getArgb(scheme), 0xffff_ffff)
    XCTAssertEqual(MaterialDynamicColors.onPrimaryFixedVariant.getArgb(scheme), 0xffff_ffff)
    XCTAssertEqual(MaterialDynamicColors.secondaryFixed.getArgb(scheme), 0xff43_4343)
    XCTAssertEqual(MaterialDynamicColors.secondaryFixedDim.getArgb(scheme), 0xff2d_2d2d)
    XCTAssertEqual(MaterialDynamicColors.onSecondaryFixed.getArgb(scheme), 0xffff_ffff)
    XCTAssertEqual(MaterialDynamicColors.onSecondaryFixedVariant.getArgb(scheme), 0xffff_ffff)
    XCTAssertEqual(MaterialDynamicColors.tertiaryFixed.getArgb(scheme), 0xff43_4343)
    XCTAssertEqual(MaterialDynamicColors.tertiaryFixedDim.getArgb(scheme), 0xff2d_2d2d)
    XCTAssertEqual(MaterialDynamicColors.onTertiaryFixed.getArgb(scheme), 0xffff_ffff)
    XCTAssertEqual(MaterialDynamicColors.onTertiaryFixedVariant.getArgb(scheme), 0xffff_ffff)
  }

  func testDarkSchemeMonochromeMinContrast() {
    let scheme = SchemeMonochrome(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: true,
      contrastLevel: -1
    )

    XCTAssertEqual(MaterialDynamicColors.background.getArgb(scheme), 0xff13_1313)
    XCTAssertEqual(MaterialDynamicColors.onBackground.getArgb(scheme), 0xff62_6262)
    XCTAssertEqual(MaterialDynamicColors.surface.getArgb(scheme), 0xff13_1313)
    XCTAssertEqual(MaterialDynamicColors.surfaceDim.getArgb(scheme), 0xff13_1313)
    XCTAssertEqual(MaterialDynamicColors.surfaceBright.getArgb(scheme), 0xff39_3939)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerLowest.getArgb(scheme), 0xff0e_0e0e)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerLow.getArgb(scheme), 0xff1b_1b1b)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainer.getArgb(scheme), 0xff1f_1f1f)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerHigh.getArgb(scheme), 0xff2a_2a2a)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerHighest.getArgb(scheme), 0xff35_3535)
    XCTAssertEqual(MaterialDynamicColors.onSurface.getArgb(scheme), 0xffa3_a3a3)
    XCTAssertEqual(MaterialDynamicColors.onSurfaceVariant.getArgb(scheme), 0xff83_8383)
    XCTAssertEqual(MaterialDynamicColors.surfaceVariant.getArgb(scheme), 0xff47_4747)
    XCTAssertEqual(MaterialDynamicColors.inverseSurface.getArgb(scheme), 0xffe2_e2e2)
    XCTAssertEqual(MaterialDynamicColors.inverseOnSurface.getArgb(scheme), 0xff64_6464)
    XCTAssertEqual(MaterialDynamicColors.outline.getArgb(scheme), 0xff54_5454)
    XCTAssertEqual(MaterialDynamicColors.outlineVariant.getArgb(scheme), 0xff3a_3a3a)
    XCTAssertEqual(MaterialDynamicColors.shadow.getArgb(scheme), 0xff00_0000)
    XCTAssertEqual(MaterialDynamicColors.scrim.getArgb(scheme), 0xff00_0000)
    XCTAssertEqual(MaterialDynamicColors.surfaceTint.getArgb(scheme), 0xffc6_c6c6)
    XCTAssertEqual(MaterialDynamicColors.primary.getArgb(scheme), 0xff91_9191)
    XCTAssertEqual(MaterialDynamicColors.onPrimary.getArgb(scheme), 0xff2a_2a2a)
    XCTAssertEqual(MaterialDynamicColors.primaryContainer.getArgb(scheme), 0xff3a_3a3a)
    XCTAssertEqual(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme), 0xffa4_a4a4)
    XCTAssertEqual(MaterialDynamicColors.inversePrimary.getArgb(scheme), 0xff80_8080)
    XCTAssertEqual(MaterialDynamicColors.secondary.getArgb(scheme), 0xff91_9191)
    XCTAssertEqual(MaterialDynamicColors.onSecondary.getArgb(scheme), 0xff2a_2a2a)
    XCTAssertEqual(MaterialDynamicColors.secondaryContainer.getArgb(scheme), 0xff3a_3a3a)
    XCTAssertEqual(MaterialDynamicColors.onSecondaryContainer.getArgb(scheme), 0xffa4_a4a4)
    XCTAssertEqual(MaterialDynamicColors.tertiary.getArgb(scheme), 0xff91_9191)
    XCTAssertEqual(MaterialDynamicColors.onTertiary.getArgb(scheme), 0xff2a_2a2a)
    XCTAssertEqual(MaterialDynamicColors.tertiaryContainer.getArgb(scheme), 0xff3a_3a3a)
    XCTAssertEqual(MaterialDynamicColors.onTertiaryContainer.getArgb(scheme), 0xffa4_a4a4)
    XCTAssertEqual(MaterialDynamicColors.error.getArgb(scheme), 0xffff_5449)
    XCTAssertEqual(MaterialDynamicColors.onError.getArgb(scheme), 0xff5c_0003)
    XCTAssertEqual(MaterialDynamicColors.errorContainer.getArgb(scheme), 0xff7b_0007)
    XCTAssertEqual(MaterialDynamicColors.onErrorContainer.getArgb(scheme), 0xffff_7d70)
    XCTAssertEqual(MaterialDynamicColors.primaryFixed.getArgb(scheme), 0xff51_5151)
    XCTAssertEqual(MaterialDynamicColors.primaryFixedDim.getArgb(scheme), 0xff3a_3a3a)
    XCTAssertEqual(MaterialDynamicColors.onPrimaryFixed.getArgb(scheme), 0xffc4_c4c4)
    XCTAssertEqual(MaterialDynamicColors.onPrimaryFixedVariant.getArgb(scheme), 0xffa0_a0a0)
    XCTAssertEqual(MaterialDynamicColors.secondaryFixed.getArgb(scheme), 0xff51_5151)
    XCTAssertEqual(MaterialDynamicColors.secondaryFixedDim.getArgb(scheme), 0xff3a_3a3a)
    XCTAssertEqual(MaterialDynamicColors.onSecondaryFixed.getArgb(scheme), 0xffc4_c4c4)
    XCTAssertEqual(MaterialDynamicColors.onSecondaryFixedVariant.getArgb(scheme), 0xffa0_a0a0)
    XCTAssertEqual(MaterialDynamicColors.tertiaryFixed.getArgb(scheme), 0xff51_5151)
    XCTAssertEqual(MaterialDynamicColors.tertiaryFixedDim.getArgb(scheme), 0xff3a_3a3a)
    XCTAssertEqual(MaterialDynamicColors.onTertiaryFixed.getArgb(scheme), 0xffc4_c4c4)
    XCTAssertEqual(MaterialDynamicColors.onTertiaryFixedVariant.getArgb(scheme), 0xffa0_a0a0)
  }

  func testDarkSchemeMonochromeStandardContrast() {
    let scheme = SchemeMonochrome(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: true,
      contrastLevel: 0
    )

    XCTAssertEqual(MaterialDynamicColors.background.getArgb(scheme), 0xff13_1313)
    XCTAssertEqual(MaterialDynamicColors.onBackground.getArgb(scheme), 0xffe2_e2e2)
    XCTAssertEqual(MaterialDynamicColors.surface.getArgb(scheme), 0xff13_1313)
    XCTAssertEqual(MaterialDynamicColors.surfaceDim.getArgb(scheme), 0xff13_1313)
    XCTAssertEqual(MaterialDynamicColors.surfaceBright.getArgb(scheme), 0xff39_3939)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerLowest.getArgb(scheme), 0xff0e_0e0e)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerLow.getArgb(scheme), 0xff1b_1b1b)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainer.getArgb(scheme), 0xff1f_1f1f)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerHigh.getArgb(scheme), 0xff2a_2a2a)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerHighest.getArgb(scheme), 0xff35_3535)
    XCTAssertEqual(MaterialDynamicColors.onSurface.getArgb(scheme), 0xffe2_e2e2)
    XCTAssertEqual(MaterialDynamicColors.onSurfaceVariant.getArgb(scheme), 0xffc6_c6c6)
    XCTAssertEqual(MaterialDynamicColors.surfaceVariant.getArgb(scheme), 0xff47_4747)
    XCTAssertEqual(MaterialDynamicColors.inverseSurface.getArgb(scheme), 0xffe2_e2e2)
    XCTAssertEqual(MaterialDynamicColors.inverseOnSurface.getArgb(scheme), 0xff30_3030)
    XCTAssertEqual(MaterialDynamicColors.outline.getArgb(scheme), 0xff91_9191)
    XCTAssertEqual(MaterialDynamicColors.outlineVariant.getArgb(scheme), 0xff47_4747)
    XCTAssertEqual(MaterialDynamicColors.shadow.getArgb(scheme), 0xff00_0000)
    XCTAssertEqual(MaterialDynamicColors.scrim.getArgb(scheme), 0xff00_0000)
    XCTAssertEqual(MaterialDynamicColors.surfaceTint.getArgb(scheme), 0xffc6_c6c6)
    XCTAssertEqual(MaterialDynamicColors.primary.getArgb(scheme), 0xffff_ffff)
    XCTAssertEqual(MaterialDynamicColors.onPrimary.getArgb(scheme), 0xff1b_1b1b)
    XCTAssertEqual(MaterialDynamicColors.primaryContainer.getArgb(scheme), 0xffd4_d4d4)
    XCTAssertEqual(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme), 0xff00_0000)
    XCTAssertEqual(MaterialDynamicColors.inversePrimary.getArgb(scheme), 0xff5e_5e5e)
    XCTAssertEqual(MaterialDynamicColors.secondary.getArgb(scheme), 0xffc6_c6c6)
    XCTAssertEqual(MaterialDynamicColors.onSecondary.getArgb(scheme), 0xff1b_1b1b)
    XCTAssertEqual(MaterialDynamicColors.secondaryContainer.getArgb(scheme), 0xff47_4747)
    XCTAssertEqual(MaterialDynamicColors.onSecondaryContainer.getArgb(scheme), 0xffe2_e2e2)
    XCTAssertEqual(MaterialDynamicColors.tertiary.getArgb(scheme), 0xffe2_e2e2)
    XCTAssertEqual(MaterialDynamicColors.onTertiary.getArgb(scheme), 0xff1b_1b1b)
    XCTAssertEqual(MaterialDynamicColors.tertiaryContainer.getArgb(scheme), 0xff91_9191)
    XCTAssertEqual(MaterialDynamicColors.onTertiaryContainer.getArgb(scheme), 0xff00_0000)
    XCTAssertEqual(MaterialDynamicColors.error.getArgb(scheme), 0xffff_b4ab)
    XCTAssertEqual(MaterialDynamicColors.onError.getArgb(scheme), 0xff69_0005)
    XCTAssertEqual(MaterialDynamicColors.errorContainer.getArgb(scheme), 0xff93_000a)
    XCTAssertEqual(MaterialDynamicColors.onErrorContainer.getArgb(scheme), 0xffff_dad6)
    XCTAssertEqual(MaterialDynamicColors.primaryFixed.getArgb(scheme), 0xff5e_5e5e)
    XCTAssertEqual(MaterialDynamicColors.primaryFixedDim.getArgb(scheme), 0xff47_4747)
    XCTAssertEqual(MaterialDynamicColors.onPrimaryFixed.getArgb(scheme), 0xffff_ffff)
    XCTAssertEqual(MaterialDynamicColors.onPrimaryFixedVariant.getArgb(scheme), 0xffe2_e2e2)
    XCTAssertEqual(MaterialDynamicColors.secondaryFixed.getArgb(scheme), 0xffc6_c6c6)
    XCTAssertEqual(MaterialDynamicColors.secondaryFixedDim.getArgb(scheme), 0xffab_abab)
    XCTAssertEqual(MaterialDynamicColors.onSecondaryFixed.getArgb(scheme), 0xff1b_1b1b)
    XCTAssertEqual(MaterialDynamicColors.onSecondaryFixedVariant.getArgb(scheme), 0xff3b_3b3b)
    XCTAssertEqual(MaterialDynamicColors.tertiaryFixed.getArgb(scheme), 0xff5e_5e5e)
    XCTAssertEqual(MaterialDynamicColors.tertiaryFixedDim.getArgb(scheme), 0xff47_4747)
    XCTAssertEqual(MaterialDynamicColors.onTertiaryFixed.getArgb(scheme), 0xffff_ffff)
    XCTAssertEqual(MaterialDynamicColors.onTertiaryFixedVariant.getArgb(scheme), 0xffe2_e2e2)
  }

  func testDarkSchemeMonochromeMaxContrast() {
    let scheme = SchemeMonochrome(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: true,
      contrastLevel: 1
    )

    XCTAssertEqual(MaterialDynamicColors.background.getArgb(scheme), 0xff13_1313)
    XCTAssertEqual(MaterialDynamicColors.onBackground.getArgb(scheme), 0xffe2_e2e2)
    XCTAssertEqual(MaterialDynamicColors.surface.getArgb(scheme), 0xff13_1313)
    XCTAssertEqual(MaterialDynamicColors.surfaceDim.getArgb(scheme), 0xff13_1313)
    XCTAssertEqual(MaterialDynamicColors.surfaceBright.getArgb(scheme), 0xff39_3939)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerLowest.getArgb(scheme), 0xff0e_0e0e)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerLow.getArgb(scheme), 0xff1b_1b1b)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainer.getArgb(scheme), 0xff1f_1f1f)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerHigh.getArgb(scheme), 0xff2a_2a2a)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerHighest.getArgb(scheme), 0xff35_3535)
    XCTAssertEqual(MaterialDynamicColors.onSurface.getArgb(scheme), 0xffff_ffff)
    XCTAssertEqual(MaterialDynamicColors.onSurfaceVariant.getArgb(scheme), 0xfffb_fbfb)
    XCTAssertEqual(MaterialDynamicColors.surfaceVariant.getArgb(scheme), 0xff47_4747)
    XCTAssertEqual(MaterialDynamicColors.inverseSurface.getArgb(scheme), 0xffe2_e2e2)
    XCTAssertEqual(MaterialDynamicColors.inverseOnSurface.getArgb(scheme), 0xff00_0000)
    XCTAssertEqual(MaterialDynamicColors.outline.getArgb(scheme), 0xffcb_cbcb)
    XCTAssertEqual(MaterialDynamicColors.outlineVariant.getArgb(scheme), 0xffcb_cbcb)
    XCTAssertEqual(MaterialDynamicColors.shadow.getArgb(scheme), 0xff00_0000)
    XCTAssertEqual(MaterialDynamicColors.scrim.getArgb(scheme), 0xff00_0000)
    XCTAssertEqual(MaterialDynamicColors.surfaceTint.getArgb(scheme), 0xffc6_c6c6)
    XCTAssertEqual(MaterialDynamicColors.primary.getArgb(scheme), 0xffff_ffff)
    XCTAssertEqual(MaterialDynamicColors.onPrimary.getArgb(scheme), 0xff00_0000)
    XCTAssertEqual(MaterialDynamicColors.primaryContainer.getArgb(scheme), 0xffd4_d4d4)
    XCTAssertEqual(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme), 0xff00_0000)
    XCTAssertEqual(MaterialDynamicColors.inversePrimary.getArgb(scheme), 0xff2a_2a2a)
    XCTAssertEqual(MaterialDynamicColors.secondary.getArgb(scheme), 0xfffb_fbfb)
    XCTAssertEqual(MaterialDynamicColors.onSecondary.getArgb(scheme), 0xff00_0000)
    XCTAssertEqual(MaterialDynamicColors.secondaryContainer.getArgb(scheme), 0xffcb_cbcb)
    XCTAssertEqual(MaterialDynamicColors.onSecondaryContainer.getArgb(scheme), 0xff00_0000)
    XCTAssertEqual(MaterialDynamicColors.tertiary.getArgb(scheme), 0xfffb_fbfb)
    XCTAssertEqual(MaterialDynamicColors.onTertiary.getArgb(scheme), 0xff00_0000)
    XCTAssertEqual(MaterialDynamicColors.tertiaryContainer.getArgb(scheme), 0xffcb_cbcb)
    XCTAssertEqual(MaterialDynamicColors.onTertiaryContainer.getArgb(scheme), 0xff00_0000)
    XCTAssertEqual(MaterialDynamicColors.error.getArgb(scheme), 0xffff_f9f9)
    XCTAssertEqual(MaterialDynamicColors.onError.getArgb(scheme), 0xff00_0000)
    XCTAssertEqual(MaterialDynamicColors.errorContainer.getArgb(scheme), 0xffff_bab1)
    XCTAssertEqual(MaterialDynamicColors.onErrorContainer.getArgb(scheme), 0xff00_0000)
    XCTAssertEqual(MaterialDynamicColors.primaryFixed.getArgb(scheme), 0xffe7_e7e7)
    XCTAssertEqual(MaterialDynamicColors.primaryFixedDim.getArgb(scheme), 0xffcb_cbcb)
    XCTAssertEqual(MaterialDynamicColors.onPrimaryFixed.getArgb(scheme), 0xff00_0000)
    XCTAssertEqual(MaterialDynamicColors.onPrimaryFixedVariant.getArgb(scheme), 0xff16_1616)
    XCTAssertEqual(MaterialDynamicColors.secondaryFixed.getArgb(scheme), 0xffe7_e7e7)
    XCTAssertEqual(MaterialDynamicColors.secondaryFixedDim.getArgb(scheme), 0xffcb_cbcb)
    XCTAssertEqual(MaterialDynamicColors.onSecondaryFixed.getArgb(scheme), 0xff00_0000)
    XCTAssertEqual(MaterialDynamicColors.onSecondaryFixedVariant.getArgb(scheme), 0xff16_1616)
    XCTAssertEqual(MaterialDynamicColors.tertiaryFixed.getArgb(scheme), 0xffe7_e7e7)
    XCTAssertEqual(MaterialDynamicColors.tertiaryFixedDim.getArgb(scheme), 0xffcb_cbcb)
    XCTAssertEqual(MaterialDynamicColors.onTertiaryFixed.getArgb(scheme), 0xff00_0000)
    XCTAssertEqual(MaterialDynamicColors.onTertiaryFixedVariant.getArgb(scheme), 0xff16_1616)
  }
}
