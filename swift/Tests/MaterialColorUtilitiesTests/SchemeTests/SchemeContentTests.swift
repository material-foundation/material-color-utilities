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

final class SchemeContentTests: XCTestCase {
  func testKeyColors() {
    let scheme = SchemeContent(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: false,
      contrastLevel: 0.0
    )

    XCTAssertEqual(MaterialDynamicColors.primaryPaletteKeyColor.getArgb(scheme), 0xff08_0cff)
    XCTAssertEqual(MaterialDynamicColors.secondaryPaletteKeyColor.getArgb(scheme), 0xff65_6dd3)
    XCTAssertEqual(MaterialDynamicColors.tertiaryPaletteKeyColor.getArgb(scheme), 0xff81_009f)
    XCTAssertEqual(MaterialDynamicColors.neutralPaletteKeyColor.getArgb(scheme), 0xff76_7684)
    XCTAssertEqual(MaterialDynamicColors.neutralVariantPaletteKeyColor.getArgb(scheme), 0xff75_7589)
  }
  func testLightSchemeContentMinContrast() {
    let scheme = SchemeContent(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: false,
      contrastLevel: -1
    )

    XCTAssertEqual(MaterialDynamicColors.background.getArgb(scheme), 0xfffb_f8ff)
    XCTAssertEqual(MaterialDynamicColors.onBackground.getArgb(scheme), 0xff90_8f9d)
    XCTAssertEqual(MaterialDynamicColors.surface.getArgb(scheme), 0xfffb_f8ff)
    XCTAssertEqual(MaterialDynamicColors.surfaceDim.getArgb(scheme), 0xffda_d8e8)
    XCTAssertEqual(MaterialDynamicColors.surfaceBright.getArgb(scheme), 0xfffb_f8ff)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerLowest.getArgb(scheme), 0xffff_ffff)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerLow.getArgb(scheme), 0xfff5_f2ff)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainer.getArgb(scheme), 0xffee_ecfc)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerHigh.getArgb(scheme), 0xffe8_e6f6)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerHighest.getArgb(scheme), 0xffe3_e1f1)
    XCTAssertEqual(MaterialDynamicColors.onSurface.getArgb(scheme), 0xff5e_5e6b)
    XCTAssertEqual(MaterialDynamicColors.onSurfaceVariant.getArgb(scheme), 0xff79_798d)
    XCTAssertEqual(MaterialDynamicColors.surfaceVariant.getArgb(scheme), 0xffe2_e0f7)
    XCTAssertEqual(MaterialDynamicColors.inverseSurface.getArgb(scheme), 0xff2f_2f3b)
    XCTAssertEqual(MaterialDynamicColors.inverseOnSurface.getArgb(scheme), 0xff98_97a5)
    XCTAssertEqual(MaterialDynamicColors.outline.getArgb(scheme), 0xffb1_b0c6)
    XCTAssertEqual(MaterialDynamicColors.outlineVariant.getArgb(scheme), 0xffd8_d7ee)
    XCTAssertEqual(MaterialDynamicColors.shadow.getArgb(scheme), 0xff00_0000)
    XCTAssertEqual(MaterialDynamicColors.scrim.getArgb(scheme), 0xff00_0000)
    XCTAssertEqual(MaterialDynamicColors.surfaceTint.getArgb(scheme), 0xff34_3dff)
    XCTAssertEqual(MaterialDynamicColors.primary.getArgb(scheme), 0xff56_60ff)
    XCTAssertEqual(MaterialDynamicColors.onPrimary.getArgb(scheme), 0xffff_fbff)
    XCTAssertEqual(MaterialDynamicColors.primaryContainer.getArgb(scheme), 0xffd5_d6ff)
    XCTAssertEqual(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme), 0xff33_3dff)
    XCTAssertEqual(MaterialDynamicColors.inversePrimary.getArgb(scheme), 0xff5d_67ff)
    XCTAssertEqual(MaterialDynamicColors.secondary.getArgb(scheme), 0xff63_6ad1)
    XCTAssertEqual(MaterialDynamicColors.onSecondary.getArgb(scheme), 0xffff_fbff)
    XCTAssertEqual(MaterialDynamicColors.secondaryContainer.getArgb(scheme), 0xffd5_d6ff)
    XCTAssertEqual(MaterialDynamicColors.onSecondaryContainer.getArgb(scheme), 0xff4c_53b8)
    XCTAssertEqual(MaterialDynamicColors.tertiary.getArgb(scheme), 0xffb0_42cc)
    XCTAssertEqual(MaterialDynamicColors.onTertiary.getArgb(scheme), 0xffff_fbff)
    XCTAssertEqual(MaterialDynamicColors.tertiaryContainer.getArgb(scheme), 0xfffa_c9ff)
    XCTAssertEqual(MaterialDynamicColors.onTertiaryContainer.getArgb(scheme), 0xff97_26b4)
    XCTAssertEqual(MaterialDynamicColors.error.getArgb(scheme), 0xffda_342e)
    XCTAssertEqual(MaterialDynamicColors.onError.getArgb(scheme), 0xffff_fbff)
    XCTAssertEqual(MaterialDynamicColors.errorContainer.getArgb(scheme), 0xffff_cdc7)
    XCTAssertEqual(MaterialDynamicColors.onErrorContainer.getArgb(scheme), 0xffba_1a1a)
    XCTAssertEqual(MaterialDynamicColors.primaryFixed.getArgb(scheme), 0xffd5_d6ff)
    XCTAssertEqual(MaterialDynamicColors.primaryFixedDim.getArgb(scheme), 0xffb3_b7ff)
    XCTAssertEqual(MaterialDynamicColors.onPrimaryFixed.getArgb(scheme), 0xff00_01ff)
    XCTAssertEqual(MaterialDynamicColors.onPrimaryFixedVariant.getArgb(scheme), 0xff41_4bff)
    XCTAssertEqual(MaterialDynamicColors.secondaryFixed.getArgb(scheme), 0xffd5_d6ff)
    XCTAssertEqual(MaterialDynamicColors.secondaryFixedDim.getArgb(scheme), 0xffb3_b7ff)
    XCTAssertEqual(MaterialDynamicColors.onSecondaryFixed.getArgb(scheme), 0xff39_40a5)
    XCTAssertEqual(MaterialDynamicColors.onSecondaryFixedVariant.getArgb(scheme), 0xff54_5cc1)
    XCTAssertEqual(MaterialDynamicColors.tertiaryFixed.getArgb(scheme), 0xfffa_c9ff)
    XCTAssertEqual(MaterialDynamicColors.tertiaryFixedDim.getArgb(scheme), 0xfff0_a0ff)
    XCTAssertEqual(MaterialDynamicColors.onTertiaryFixed.getArgb(scheme), 0xff81_019f)
    XCTAssertEqual(MaterialDynamicColors.onTertiaryFixedVariant.getArgb(scheme), 0xffa0_31bd)
  }

  func testLightSchemeContentStandardContrast() {
    let scheme = SchemeContent(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: false,
      contrastLevel: 0
    )

    XCTAssertEqual(MaterialDynamicColors.background.getArgb(scheme), 0xfffb_f8ff)
    XCTAssertEqual(MaterialDynamicColors.onBackground.getArgb(scheme), 0xff1a_1b26)
    XCTAssertEqual(MaterialDynamicColors.surface.getArgb(scheme), 0xfffb_f8ff)
    XCTAssertEqual(MaterialDynamicColors.surfaceDim.getArgb(scheme), 0xffda_d8e8)
    XCTAssertEqual(MaterialDynamicColors.surfaceBright.getArgb(scheme), 0xfffb_f8ff)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerLowest.getArgb(scheme), 0xffff_ffff)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerLow.getArgb(scheme), 0xfff5_f2ff)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainer.getArgb(scheme), 0xffee_ecfc)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerHigh.getArgb(scheme), 0xffe8_e6f6)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerHighest.getArgb(scheme), 0xffe3_e1f1)
    XCTAssertEqual(MaterialDynamicColors.onSurface.getArgb(scheme), 0xff1a_1b26)
    XCTAssertEqual(MaterialDynamicColors.onSurfaceVariant.getArgb(scheme), 0xff45_4558)
    XCTAssertEqual(MaterialDynamicColors.surfaceVariant.getArgb(scheme), 0xffe2_e0f7)
    XCTAssertEqual(MaterialDynamicColors.inverseSurface.getArgb(scheme), 0xff2f_2f3b)
    XCTAssertEqual(MaterialDynamicColors.inverseOnSurface.getArgb(scheme), 0xfff1_efff)
    XCTAssertEqual(MaterialDynamicColors.outline.getArgb(scheme), 0xff75_7589)
    XCTAssertEqual(MaterialDynamicColors.outlineVariant.getArgb(scheme), 0xffc5_c4db)
    XCTAssertEqual(MaterialDynamicColors.shadow.getArgb(scheme), 0xff00_0000)
    XCTAssertEqual(MaterialDynamicColors.scrim.getArgb(scheme), 0xff00_0000)
    XCTAssertEqual(MaterialDynamicColors.surfaceTint.getArgb(scheme), 0xff34_3dff)
    XCTAssertEqual(MaterialDynamicColors.primary.getArgb(scheme), 0xff00_01c3)
    XCTAssertEqual(MaterialDynamicColors.onPrimary.getArgb(scheme), 0xffff_ffff)
    XCTAssertEqual(MaterialDynamicColors.primaryContainer.getArgb(scheme), 0xff2d_36ff)
    XCTAssertEqual(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme), 0xffff_ffff)
    XCTAssertEqual(MaterialDynamicColors.inversePrimary.getArgb(scheme), 0xffbe_c2ff)
    XCTAssertEqual(MaterialDynamicColors.secondary.getArgb(scheme), 0xff4c_53b8)
    XCTAssertEqual(MaterialDynamicColors.onSecondary.getArgb(scheme), 0xffff_ffff)
    XCTAssertEqual(MaterialDynamicColors.secondaryContainer.getArgb(scheme), 0xff9b_a1ff)
    XCTAssertEqual(MaterialDynamicColors.onSecondaryContainer.getArgb(scheme), 0xff00_0076)
    XCTAssertEqual(MaterialDynamicColors.tertiary.getArgb(scheme), 0xff61_0078)
    XCTAssertEqual(MaterialDynamicColors.onTertiary.getArgb(scheme), 0xffff_ffff)
    XCTAssertEqual(MaterialDynamicColors.tertiaryContainer.getArgb(scheme), 0xff92_21af)
    XCTAssertEqual(MaterialDynamicColors.onTertiaryContainer.getArgb(scheme), 0xffff_ffff)
    XCTAssertEqual(MaterialDynamicColors.error.getArgb(scheme), 0xffba_1a1a)
    XCTAssertEqual(MaterialDynamicColors.onError.getArgb(scheme), 0xffff_ffff)
    XCTAssertEqual(MaterialDynamicColors.errorContainer.getArgb(scheme), 0xffff_dad6)
    XCTAssertEqual(MaterialDynamicColors.onErrorContainer.getArgb(scheme), 0xff41_0002)
    XCTAssertEqual(MaterialDynamicColors.primaryFixed.getArgb(scheme), 0xffe0_e0ff)
    XCTAssertEqual(MaterialDynamicColors.primaryFixedDim.getArgb(scheme), 0xffbe_c2ff)
    XCTAssertEqual(MaterialDynamicColors.onPrimaryFixed.getArgb(scheme), 0xff00_006e)
    XCTAssertEqual(MaterialDynamicColors.onPrimaryFixedVariant.getArgb(scheme), 0xff00_00ef)
    XCTAssertEqual(MaterialDynamicColors.secondaryFixed.getArgb(scheme), 0xffe0_e0ff)
    XCTAssertEqual(MaterialDynamicColors.secondaryFixedDim.getArgb(scheme), 0xffbe_c2ff)
    XCTAssertEqual(MaterialDynamicColors.onSecondaryFixed.getArgb(scheme), 0xff00_006e)
    XCTAssertEqual(MaterialDynamicColors.onSecondaryFixedVariant.getArgb(scheme), 0xff33_3a9f)
    XCTAssertEqual(MaterialDynamicColors.tertiaryFixed.getArgb(scheme), 0xfffd_d6ff)
    XCTAssertEqual(MaterialDynamicColors.tertiaryFixedDim.getArgb(scheme), 0xfff4_aeff)
    XCTAssertEqual(MaterialDynamicColors.onTertiaryFixed.getArgb(scheme), 0xff34_0042)
    XCTAssertEqual(MaterialDynamicColors.onTertiaryFixedVariant.getArgb(scheme), 0xff79_0095)
  }

  func testLightSchemeContentMaxContrast() {
    let scheme = SchemeContent(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: false,
      contrastLevel: 1
    )

    XCTAssertEqual(MaterialDynamicColors.background.getArgb(scheme), 0xfffb_f8ff)
    XCTAssertEqual(MaterialDynamicColors.onBackground.getArgb(scheme), 0xff1a_1b26)
    XCTAssertEqual(MaterialDynamicColors.surface.getArgb(scheme), 0xfffb_f8ff)
    XCTAssertEqual(MaterialDynamicColors.surfaceDim.getArgb(scheme), 0xffda_d8e8)
    XCTAssertEqual(MaterialDynamicColors.surfaceBright.getArgb(scheme), 0xfffb_f8ff)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerLowest.getArgb(scheme), 0xffff_ffff)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerLow.getArgb(scheme), 0xfff5_f2ff)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainer.getArgb(scheme), 0xffee_ecfc)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerHigh.getArgb(scheme), 0xffe8_e6f6)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerHighest.getArgb(scheme), 0xffe3_e1f1)
    XCTAssertEqual(MaterialDynamicColors.onSurface.getArgb(scheme), 0xff00_0000)
    XCTAssertEqual(MaterialDynamicColors.onSurfaceVariant.getArgb(scheme), 0xff22_2333)
    XCTAssertEqual(MaterialDynamicColors.surfaceVariant.getArgb(scheme), 0xffe2_e0f7)
    XCTAssertEqual(MaterialDynamicColors.inverseSurface.getArgb(scheme), 0xff2f_2f3b)
    XCTAssertEqual(MaterialDynamicColors.inverseOnSurface.getArgb(scheme), 0xffff_ffff)
    XCTAssertEqual(MaterialDynamicColors.outline.getArgb(scheme), 0xff41_4153)
    XCTAssertEqual(MaterialDynamicColors.outlineVariant.getArgb(scheme), 0xff41_4153)
    XCTAssertEqual(MaterialDynamicColors.shadow.getArgb(scheme), 0xff00_0000)
    XCTAssertEqual(MaterialDynamicColors.scrim.getArgb(scheme), 0xff00_0000)
    XCTAssertEqual(MaterialDynamicColors.surfaceTint.getArgb(scheme), 0xff34_3dff)
    XCTAssertEqual(MaterialDynamicColors.primary.getArgb(scheme), 0xff00_0181)
    XCTAssertEqual(MaterialDynamicColors.onPrimary.getArgb(scheme), 0xffff_ffff)
    XCTAssertEqual(MaterialDynamicColors.primaryContainer.getArgb(scheme), 0xff00_00e3)
    XCTAssertEqual(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme), 0xffff_ffff)
    XCTAssertEqual(MaterialDynamicColors.inversePrimary.getArgb(scheme), 0xffec_eaff)
    XCTAssertEqual(MaterialDynamicColors.secondary.getArgb(scheme), 0xff04_067c)
    XCTAssertEqual(MaterialDynamicColors.onSecondary.getArgb(scheme), 0xffff_ffff)
    XCTAssertEqual(MaterialDynamicColors.secondaryContainer.getArgb(scheme), 0xff2f_359b)
    XCTAssertEqual(MaterialDynamicColors.onSecondaryContainer.getArgb(scheme), 0xffff_ffff)
    XCTAssertEqual(MaterialDynamicColors.tertiary.getArgb(scheme), 0xff3f_004f)
    XCTAssertEqual(MaterialDynamicColors.onTertiary.getArgb(scheme), 0xffff_ffff)
    XCTAssertEqual(MaterialDynamicColors.tertiaryContainer.getArgb(scheme), 0xff73_008e)
    XCTAssertEqual(MaterialDynamicColors.onTertiaryContainer.getArgb(scheme), 0xffff_ffff)
    XCTAssertEqual(MaterialDynamicColors.error.getArgb(scheme), 0xff4e_0002)
    XCTAssertEqual(MaterialDynamicColors.onError.getArgb(scheme), 0xffff_ffff)
    XCTAssertEqual(MaterialDynamicColors.errorContainer.getArgb(scheme), 0xff8c_0009)
    XCTAssertEqual(MaterialDynamicColors.onErrorContainer.getArgb(scheme), 0xffff_ffff)
    XCTAssertEqual(MaterialDynamicColors.primaryFixed.getArgb(scheme), 0xff00_00e3)
    XCTAssertEqual(MaterialDynamicColors.primaryFixedDim.getArgb(scheme), 0xff00_01a1)
    XCTAssertEqual(MaterialDynamicColors.onPrimaryFixed.getArgb(scheme), 0xffff_ffff)
    XCTAssertEqual(MaterialDynamicColors.onPrimaryFixedVariant.getArgb(scheme), 0xffff_ffff)
    XCTAssertEqual(MaterialDynamicColors.secondaryFixed.getArgb(scheme), 0xff2f_359b)
    XCTAssertEqual(MaterialDynamicColors.secondaryFixedDim.getArgb(scheme), 0xff15_1a85)
    XCTAssertEqual(MaterialDynamicColors.onSecondaryFixed.getArgb(scheme), 0xffff_ffff)
    XCTAssertEqual(MaterialDynamicColors.onSecondaryFixedVariant.getArgb(scheme), 0xffff_ffff)
    XCTAssertEqual(MaterialDynamicColors.tertiaryFixed.getArgb(scheme), 0xff73_008e)
    XCTAssertEqual(MaterialDynamicColors.tertiaryFixedDim.getArgb(scheme), 0xff4f_0063)
    XCTAssertEqual(MaterialDynamicColors.onTertiaryFixed.getArgb(scheme), 0xffff_ffff)
    XCTAssertEqual(MaterialDynamicColors.onTertiaryFixedVariant.getArgb(scheme), 0xffff_ffff)
  }

  func testDarkSchemeContentMinContrast() {
    let scheme = SchemeContent(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: true,
      contrastLevel: -1
    )

    XCTAssertEqual(MaterialDynamicColors.background.getArgb(scheme), 0xff12_121d)
    XCTAssertEqual(MaterialDynamicColors.onBackground.getArgb(scheme), 0xff61_616e)
    XCTAssertEqual(MaterialDynamicColors.surface.getArgb(scheme), 0xff12_121d)
    XCTAssertEqual(MaterialDynamicColors.surfaceDim.getArgb(scheme), 0xff12_121d)
    XCTAssertEqual(MaterialDynamicColors.surfaceBright.getArgb(scheme), 0xff38_3844)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerLowest.getArgb(scheme), 0xff0d_0d18)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerLow.getArgb(scheme), 0xff1a_1b26)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainer.getArgb(scheme), 0xff1e_1f2a)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerHigh.getArgb(scheme), 0xff29_2935)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerHighest.getArgb(scheme), 0xff33_3440)
    XCTAssertEqual(MaterialDynamicColors.onSurface.getArgb(scheme), 0xffa2_a1b0)
    XCTAssertEqual(MaterialDynamicColors.onSurfaceVariant.getArgb(scheme), 0xff81_8196)
    XCTAssertEqual(MaterialDynamicColors.surfaceVariant.getArgb(scheme), 0xff45_4558)
    XCTAssertEqual(MaterialDynamicColors.inverseSurface.getArgb(scheme), 0xffe3_e1f1)
    XCTAssertEqual(MaterialDynamicColors.inverseOnSurface.getArgb(scheme), 0xff63_6371)
    XCTAssertEqual(MaterialDynamicColors.outline.getArgb(scheme), 0xff52_5365)
    XCTAssertEqual(MaterialDynamicColors.outlineVariant.getArgb(scheme), 0xff38_394a)
    XCTAssertEqual(MaterialDynamicColors.shadow.getArgb(scheme), 0xff00_0000)
    XCTAssertEqual(MaterialDynamicColors.scrim.getArgb(scheme), 0xff00_0000)
    XCTAssertEqual(MaterialDynamicColors.surfaceTint.getArgb(scheme), 0xffbe_c2ff)
    XCTAssertEqual(MaterialDynamicColors.primary.getArgb(scheme), 0xff7c_84ff)
    XCTAssertEqual(MaterialDynamicColors.onPrimary.getArgb(scheme), 0xff00_0198)
    XCTAssertEqual(MaterialDynamicColors.primaryContainer.getArgb(scheme), 0xff00_01c9)
    XCTAssertEqual(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme), 0xff94_9bff)
    XCTAssertEqual(MaterialDynamicColors.inversePrimary.getArgb(scheme), 0xff67_70ff)
    XCTAssertEqual(MaterialDynamicColors.secondary.getArgb(scheme), 0xff7f_87ef)
    XCTAssertEqual(MaterialDynamicColors.onSecondary.getArgb(scheme), 0xff10_1582)
    XCTAssertEqual(MaterialDynamicColors.secondaryContainer.getArgb(scheme), 0xff25_2b92)
    XCTAssertEqual(MaterialDynamicColors.onSecondaryContainer.getArgb(scheme), 0xff94_9bff)
    XCTAssertEqual(MaterialDynamicColors.tertiary.getArgb(scheme), 0xffd1_61ec)
    XCTAssertEqual(MaterialDynamicColors.onTertiary.getArgb(scheme), 0xff4b_005d)
    XCTAssertEqual(MaterialDynamicColors.tertiaryContainer.getArgb(scheme), 0xff65_007d)
    XCTAssertEqual(MaterialDynamicColors.onTertiaryContainer.getArgb(scheme), 0xffe5_77ff)
    XCTAssertEqual(MaterialDynamicColors.error.getArgb(scheme), 0xffff_5449)
    XCTAssertEqual(MaterialDynamicColors.onError.getArgb(scheme), 0xff5c_0003)
    XCTAssertEqual(MaterialDynamicColors.errorContainer.getArgb(scheme), 0xff7b_0007)
    XCTAssertEqual(MaterialDynamicColors.onErrorContainer.getArgb(scheme), 0xffff_7d70)
    XCTAssertEqual(MaterialDynamicColors.primaryFixed.getArgb(scheme), 0xff16_1cff)
    XCTAssertEqual(MaterialDynamicColors.primaryFixedDim.getArgb(scheme), 0xff00_01c9)
    XCTAssertEqual(MaterialDynamicColors.onPrimaryFixed.getArgb(scheme), 0xffbb_bfff)
    XCTAssertEqual(MaterialDynamicColors.onPrimaryFixedVariant.getArgb(scheme), 0xff8f_97ff)
    XCTAssertEqual(MaterialDynamicColors.secondaryFixed.getArgb(scheme), 0xff3e_45aa)
    XCTAssertEqual(MaterialDynamicColors.secondaryFixedDim.getArgb(scheme), 0xff25_2b92)
    XCTAssertEqual(MaterialDynamicColors.onSecondaryFixed.getArgb(scheme), 0xffbb_bfff)
    XCTAssertEqual(MaterialDynamicColors.onSecondaryFixedVariant.getArgb(scheme), 0xff8f_97ff)
    XCTAssertEqual(MaterialDynamicColors.tertiaryFixed.getArgb(scheme), 0xff87_0fa5)
    XCTAssertEqual(MaterialDynamicColors.tertiaryFixedDim.getArgb(scheme), 0xff65_007d)
    XCTAssertEqual(MaterialDynamicColors.onTertiaryFixed.getArgb(scheme), 0xfff3_aaff)
    XCTAssertEqual(MaterialDynamicColors.onTertiaryFixedVariant.getArgb(scheme), 0xffe2_71fd)
  }

  func testDarkSchemeContentStandardContrast() {
    let scheme = SchemeContent(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: true,
      contrastLevel: 0
    )

    XCTAssertEqual(MaterialDynamicColors.background.getArgb(scheme), 0xff12_121d)
    XCTAssertEqual(MaterialDynamicColors.onBackground.getArgb(scheme), 0xffe3_e1f1)
    XCTAssertEqual(MaterialDynamicColors.surface.getArgb(scheme), 0xff12_121d)
    XCTAssertEqual(MaterialDynamicColors.surfaceDim.getArgb(scheme), 0xff12_121d)
    XCTAssertEqual(MaterialDynamicColors.surfaceBright.getArgb(scheme), 0xff38_3844)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerLowest.getArgb(scheme), 0xff0d_0d18)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerLow.getArgb(scheme), 0xff1a_1b26)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainer.getArgb(scheme), 0xff1e_1f2a)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerHigh.getArgb(scheme), 0xff29_2935)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerHighest.getArgb(scheme), 0xff33_3440)
    XCTAssertEqual(MaterialDynamicColors.onSurface.getArgb(scheme), 0xffe3_e1f1)
    XCTAssertEqual(MaterialDynamicColors.onSurfaceVariant.getArgb(scheme), 0xffc5_c4db)
    XCTAssertEqual(MaterialDynamicColors.surfaceVariant.getArgb(scheme), 0xff45_4558)
    XCTAssertEqual(MaterialDynamicColors.inverseSurface.getArgb(scheme), 0xffe3_e1f1)
    XCTAssertEqual(MaterialDynamicColors.inverseOnSurface.getArgb(scheme), 0xff2f_2f3b)
    XCTAssertEqual(MaterialDynamicColors.outline.getArgb(scheme), 0xff8f_8fa4)
    XCTAssertEqual(MaterialDynamicColors.outlineVariant.getArgb(scheme), 0xff45_4558)
    XCTAssertEqual(MaterialDynamicColors.shadow.getArgb(scheme), 0xff00_0000)
    XCTAssertEqual(MaterialDynamicColors.scrim.getArgb(scheme), 0xff00_0000)
    XCTAssertEqual(MaterialDynamicColors.surfaceTint.getArgb(scheme), 0xffbe_c2ff)
    XCTAssertEqual(MaterialDynamicColors.primary.getArgb(scheme), 0xffbe_c2ff)
    XCTAssertEqual(MaterialDynamicColors.onPrimary.getArgb(scheme), 0xff00_01ac)
    XCTAssertEqual(MaterialDynamicColors.primaryContainer.getArgb(scheme), 0xff00_00e6)
    XCTAssertEqual(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme), 0xffd7_d8ff)
    XCTAssertEqual(MaterialDynamicColors.inversePrimary.getArgb(scheme), 0xff34_3dff)
    XCTAssertEqual(MaterialDynamicColors.secondary.getArgb(scheme), 0xffbe_c2ff)
    XCTAssertEqual(MaterialDynamicColors.onSecondary.getArgb(scheme), 0xff19_1f89)
    XCTAssertEqual(MaterialDynamicColors.secondaryContainer.getArgb(scheme), 0xff2c_3298)
    XCTAssertEqual(MaterialDynamicColors.onSecondaryContainer.getArgb(scheme), 0xffd0_d1ff)
    XCTAssertEqual(MaterialDynamicColors.tertiary.getArgb(scheme), 0xfff4_aeff)
    XCTAssertEqual(MaterialDynamicColors.onTertiary.getArgb(scheme), 0xff55_006a)
    XCTAssertEqual(MaterialDynamicColors.tertiaryContainer.getArgb(scheme), 0xff74_008f)
    XCTAssertEqual(MaterialDynamicColors.onTertiaryContainer.getArgb(scheme), 0xfffb_ccff)
    XCTAssertEqual(MaterialDynamicColors.error.getArgb(scheme), 0xffff_b4ab)
    XCTAssertEqual(MaterialDynamicColors.onError.getArgb(scheme), 0xff69_0005)
    XCTAssertEqual(MaterialDynamicColors.errorContainer.getArgb(scheme), 0xff93_000a)
    XCTAssertEqual(MaterialDynamicColors.onErrorContainer.getArgb(scheme), 0xffff_dad6)
    XCTAssertEqual(MaterialDynamicColors.primaryFixed.getArgb(scheme), 0xffe0_e0ff)
    XCTAssertEqual(MaterialDynamicColors.primaryFixedDim.getArgb(scheme), 0xffbe_c2ff)
    XCTAssertEqual(MaterialDynamicColors.onPrimaryFixed.getArgb(scheme), 0xff00_006e)
    XCTAssertEqual(MaterialDynamicColors.onPrimaryFixedVariant.getArgb(scheme), 0xff00_00ef)
    XCTAssertEqual(MaterialDynamicColors.secondaryFixed.getArgb(scheme), 0xffe0_e0ff)
    XCTAssertEqual(MaterialDynamicColors.secondaryFixedDim.getArgb(scheme), 0xffbe_c2ff)
    XCTAssertEqual(MaterialDynamicColors.onSecondaryFixed.getArgb(scheme), 0xff00_006e)
    XCTAssertEqual(MaterialDynamicColors.onSecondaryFixedVariant.getArgb(scheme), 0xff33_3a9f)
    XCTAssertEqual(MaterialDynamicColors.tertiaryFixed.getArgb(scheme), 0xfffd_d6ff)
    XCTAssertEqual(MaterialDynamicColors.tertiaryFixedDim.getArgb(scheme), 0xfff4_aeff)
    XCTAssertEqual(MaterialDynamicColors.onTertiaryFixed.getArgb(scheme), 0xff34_0042)
    XCTAssertEqual(MaterialDynamicColors.onTertiaryFixedVariant.getArgb(scheme), 0xff79_0095)
  }

  func testDarkSchemeContentMaxContrast() {
    let scheme = SchemeContent(
      sourceColorHct: Hct.fromInt(0xff00_00ff),
      isDark: true,
      contrastLevel: 1
    )

    XCTAssertEqual(MaterialDynamicColors.background.getArgb(scheme), 0xff12_121d)
    XCTAssertEqual(MaterialDynamicColors.onBackground.getArgb(scheme), 0xffe3_e1f1)
    XCTAssertEqual(MaterialDynamicColors.surface.getArgb(scheme), 0xff12_121d)
    XCTAssertEqual(MaterialDynamicColors.surfaceDim.getArgb(scheme), 0xff12_121d)
    XCTAssertEqual(MaterialDynamicColors.surfaceBright.getArgb(scheme), 0xff38_3844)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerLowest.getArgb(scheme), 0xff0d_0d18)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerLow.getArgb(scheme), 0xff1a_1b26)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainer.getArgb(scheme), 0xff1e_1f2a)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerHigh.getArgb(scheme), 0xff29_2935)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerHighest.getArgb(scheme), 0xff33_3440)
    XCTAssertEqual(MaterialDynamicColors.onSurface.getArgb(scheme), 0xffff_ffff)
    XCTAssertEqual(MaterialDynamicColors.onSurfaceVariant.getArgb(scheme), 0xfffd_f9ff)
    XCTAssertEqual(MaterialDynamicColors.surfaceVariant.getArgb(scheme), 0xff45_4558)
    XCTAssertEqual(MaterialDynamicColors.inverseSurface.getArgb(scheme), 0xffe3_e1f1)
    XCTAssertEqual(MaterialDynamicColors.inverseOnSurface.getArgb(scheme), 0xff00_0000)
    XCTAssertEqual(MaterialDynamicColors.outline.getArgb(scheme), 0xffca_c9df)
    XCTAssertEqual(MaterialDynamicColors.outlineVariant.getArgb(scheme), 0xffca_c9df)
    XCTAssertEqual(MaterialDynamicColors.shadow.getArgb(scheme), 0xff00_0000)
    XCTAssertEqual(MaterialDynamicColors.scrim.getArgb(scheme), 0xff00_0000)
    XCTAssertEqual(MaterialDynamicColors.surfaceTint.getArgb(scheme), 0xffbe_c2ff)
    XCTAssertEqual(MaterialDynamicColors.primary.getArgb(scheme), 0xfffd_f9ff)
    XCTAssertEqual(MaterialDynamicColors.onPrimary.getArgb(scheme), 0xff00_0000)
    XCTAssertEqual(MaterialDynamicColors.primaryContainer.getArgb(scheme), 0xffc4_c6ff)
    XCTAssertEqual(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme), 0xff00_0000)
    XCTAssertEqual(MaterialDynamicColors.inversePrimary.getArgb(scheme), 0xff00_0199)
    XCTAssertEqual(MaterialDynamicColors.secondary.getArgb(scheme), 0xfffd_f9ff)
    XCTAssertEqual(MaterialDynamicColors.onSecondary.getArgb(scheme), 0xff00_0000)
    XCTAssertEqual(MaterialDynamicColors.secondaryContainer.getArgb(scheme), 0xffc4_c6ff)
    XCTAssertEqual(MaterialDynamicColors.onSecondaryContainer.getArgb(scheme), 0xff00_0000)
    XCTAssertEqual(MaterialDynamicColors.tertiary.getArgb(scheme), 0xffff_f9fa)
    XCTAssertEqual(MaterialDynamicColors.onTertiary.getArgb(scheme), 0xff00_0000)
    XCTAssertEqual(MaterialDynamicColors.tertiaryContainer.getArgb(scheme), 0xfff5_b4ff)
    XCTAssertEqual(MaterialDynamicColors.onTertiaryContainer.getArgb(scheme), 0xff00_0000)
    XCTAssertEqual(MaterialDynamicColors.error.getArgb(scheme), 0xffff_f9f9)
    XCTAssertEqual(MaterialDynamicColors.onError.getArgb(scheme), 0xff00_0000)
    XCTAssertEqual(MaterialDynamicColors.errorContainer.getArgb(scheme), 0xffff_bab1)
    XCTAssertEqual(MaterialDynamicColors.onErrorContainer.getArgb(scheme), 0xff00_0000)
    XCTAssertEqual(MaterialDynamicColors.primaryFixed.getArgb(scheme), 0xffe5_e4ff)
    XCTAssertEqual(MaterialDynamicColors.primaryFixedDim.getArgb(scheme), 0xffc4_c6ff)
    XCTAssertEqual(MaterialDynamicColors.onPrimaryFixed.getArgb(scheme), 0xff00_0000)
    XCTAssertEqual(MaterialDynamicColors.onPrimaryFixedVariant.getArgb(scheme), 0xff00_005e)
    XCTAssertEqual(MaterialDynamicColors.secondaryFixed.getArgb(scheme), 0xffe5_e4ff)
    XCTAssertEqual(MaterialDynamicColors.secondaryFixedDim.getArgb(scheme), 0xffc4_c6ff)
    XCTAssertEqual(MaterialDynamicColors.onSecondaryFixed.getArgb(scheme), 0xff00_0000)
    XCTAssertEqual(MaterialDynamicColors.onSecondaryFixedVariant.getArgb(scheme), 0xff00_005e)
    XCTAssertEqual(MaterialDynamicColors.tertiaryFixed.getArgb(scheme), 0xfffe_dcff)
    XCTAssertEqual(MaterialDynamicColors.tertiaryFixedDim.getArgb(scheme), 0xfff5_b4ff)
    XCTAssertEqual(MaterialDynamicColors.onTertiaryFixed.getArgb(scheme), 0xff00_0000)
    XCTAssertEqual(MaterialDynamicColors.onTertiaryFixedVariant.getArgb(scheme), 0xff2c_0038)
  }

  func testLightThemeMinContrastObjectionabeTertiaryContainerLightens() {
    let scheme = SchemeContent(
      sourceColorHct: Hct.fromInt(0xff85_0096),
      isDark: false,
      contrastLevel: -1
    )

    let color = MaterialDynamicColors.tertiaryContainer.getArgb(scheme)

    XCTAssertEqual(color, 0xffff_ccd7)
  }

  func testLightThemeStandardContrastObjectionabeTertiaryContainerLightens() {
    let scheme = SchemeContent(
      sourceColorHct: Hct.fromInt(0xff85_0096),
      isDark: false,
      contrastLevel: 0
    )

    XCTAssertEqual(MaterialDynamicColors.tertiaryContainer.getArgb(scheme), 0xffac_1b57)
  }

  func testLightThemeMaxContrastObjectionabeTertiaryContainerDarkens() {
    let scheme = SchemeContent(
      sourceColorHct: Hct.fromInt(0xff85_0096),
      isDark: false,
      contrastLevel: 1
    )

    XCTAssertEqual(MaterialDynamicColors.tertiaryContainer.getArgb(scheme), 0xff87_0040)
  }
}
