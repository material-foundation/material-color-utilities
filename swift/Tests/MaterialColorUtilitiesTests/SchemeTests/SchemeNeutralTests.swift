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
    XCTAssertEqual(MaterialDynamicColors.tertiaryPaletteKeyColor.getArgb(scheme), 0xff75_758B)
    XCTAssertEqual(MaterialDynamicColors.neutralPaletteKeyColor.getArgb(scheme), 0xff78_7678)
    XCTAssertEqual(MaterialDynamicColors.neutralVariantPaletteKeyColor.getArgb(scheme), 0xff78_7678)
  }

  func testLightSchemeNeutralMinContrast() {
    let scheme = SchemeNeutral(
      sourceColorHct: Hct.fromInt(0xFF_ff00_00ff),
      isDark: false,
      contrastLevel: -1.0
    )

    XCTAssertEqual(MaterialDynamicColors.background.getArgb(scheme), 4_294_768_890)
    XCTAssertEqual(MaterialDynamicColors.onBackground.getArgb(scheme), 4_285_821_555)
    XCTAssertEqual(MaterialDynamicColors.surface.getArgb(scheme), 4_294_768_890)
    XCTAssertEqual(MaterialDynamicColors.surfaceDim.getArgb(scheme), 4_292_663_771)
    XCTAssertEqual(MaterialDynamicColors.surfaceBright.getArgb(scheme), 4_294_768_890)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerLowest.getArgb(scheme), 4_294_967_295)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerLow.getArgb(scheme), 4_294_374_132)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainer.getArgb(scheme), 4_294_045_167)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerHigh.getArgb(scheme), 4_293_650_409)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerHighest.getArgb(scheme), 4_293_255_651)
    XCTAssertEqual(MaterialDynamicColors.onSurface.getArgb(scheme), 4_284_505_696)
    XCTAssertEqual(MaterialDynamicColors.onSurfaceVariant.getArgb(scheme), 4_284_834_917)
    XCTAssertEqual(MaterialDynamicColors.surfaceVariant.getArgb(scheme), 4_293_255_651)
    XCTAssertEqual(MaterialDynamicColors.inverseSurface.getArgb(scheme), 4_281_413_682)
    XCTAssertEqual(MaterialDynamicColors.inverseOnSurface.getArgb(scheme), 4_288_321_433)
    XCTAssertEqual(MaterialDynamicColors.outline.getArgb(scheme), 4_285_953_142)
    XCTAssertEqual(MaterialDynamicColors.outlineVariant.getArgb(scheme), 4_291_413_703)
    XCTAssertEqual(MaterialDynamicColors.shadow.getArgb(scheme), 4_278_190_080)
    XCTAssertEqual(MaterialDynamicColors.scrim.getArgb(scheme), 4_278_190_080)
    XCTAssertEqual(MaterialDynamicColors.surfaceTint.getArgb(scheme), 4_284_308_844)
    XCTAssertEqual(MaterialDynamicColors.primary.getArgb(scheme), 4_285_756_291)
    XCTAssertEqual(MaterialDynamicColors.onPrimary.getArgb(scheme), 4_291_940_321)
    XCTAssertEqual(MaterialDynamicColors.primaryContainer.getArgb(scheme), 4_293_059_059)
    XCTAssertEqual(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme), 4_284_703_602)
    XCTAssertEqual(MaterialDynamicColors.inversePrimary.getArgb(scheme), 4_288_124_839)
    XCTAssertEqual(MaterialDynamicColors.secondary.getArgb(scheme), 4_285_821_821)
    XCTAssertEqual(MaterialDynamicColors.onSecondary.getArgb(scheme), 4_292_005_850)
    XCTAssertEqual(MaterialDynamicColors.secondaryContainer.getArgb(scheme), 4_293_190_124)
    XCTAssertEqual(MaterialDynamicColors.onSecondaryContainer.getArgb(scheme), 4_284_769_133)
    XCTAssertEqual(MaterialDynamicColors.tertiary.getArgb(scheme), 4_285_690_761)
    XCTAssertEqual(MaterialDynamicColors.onTertiary.getArgb(scheme), 4_291_809_255)
    XCTAssertEqual(MaterialDynamicColors.tertiaryContainer.getArgb(scheme), 4_292_993_273)
    XCTAssertEqual(MaterialDynamicColors.onTertiaryContainer.getArgb(scheme), 4_284_638_072)
    XCTAssertEqual(MaterialDynamicColors.error.getArgb(scheme), 4_292_490_286)
    XCTAssertEqual(MaterialDynamicColors.onError.getArgb(scheme), 4_294_951_611)
    XCTAssertEqual(MaterialDynamicColors.errorContainer.getArgb(scheme), 4_294_957_782)
    XCTAssertEqual(MaterialDynamicColors.onErrorContainer.getArgb(scheme), 4_290_978_336)
    XCTAssertEqual(MaterialDynamicColors.primaryFixed.getArgb(scheme), 4_293_059_059)
    XCTAssertEqual(MaterialDynamicColors.primaryFixedDim.getArgb(scheme), 4_291_216_854)
    XCTAssertEqual(MaterialDynamicColors.onPrimaryFixed.getArgb(scheme), 4_283_519_328)
    XCTAssertEqual(MaterialDynamicColors.onPrimaryFixedVariant.getArgb(scheme), 4_285_295_739)
    XCTAssertEqual(MaterialDynamicColors.secondaryFixed.getArgb(scheme), 4_293_190_124)
    XCTAssertEqual(MaterialDynamicColors.secondaryFixedDim.getArgb(scheme), 4_291_282_384)
    XCTAssertEqual(MaterialDynamicColors.onSecondaryFixed.getArgb(scheme), 4_283_585_115)
    XCTAssertEqual(MaterialDynamicColors.onSecondaryFixedVariant.getArgb(scheme), 4_285_361_270)
    XCTAssertEqual(MaterialDynamicColors.tertiaryFixed.getArgb(scheme), 4_292_993_273)
    XCTAssertEqual(MaterialDynamicColors.tertiaryFixedDim.getArgb(scheme), 4_291_151_069)
    XCTAssertEqual(MaterialDynamicColors.onTertiaryFixed.getArgb(scheme), 4_283_453_797)
    XCTAssertEqual(MaterialDynamicColors.onTertiaryFixedVariant.getArgb(scheme), 4_285_229_953)
  }

  func testLightSchemeNeutralStandardContrast() {
    let scheme = SchemeNeutral(
      sourceColorHct: Hct.fromInt(0xFF_ff00_00ff),
      isDark: false,
      contrastLevel: 0.0
    )

    XCTAssertEqual(MaterialDynamicColors.background.getArgb(scheme), 4_294_768_890)
    XCTAssertEqual(MaterialDynamicColors.onBackground.getArgb(scheme), 4_280_032_029)
    XCTAssertEqual(MaterialDynamicColors.surface.getArgb(scheme), 4_294_768_890)
    XCTAssertEqual(MaterialDynamicColors.surfaceDim.getArgb(scheme), 4_292_663_771)
    XCTAssertEqual(MaterialDynamicColors.surfaceBright.getArgb(scheme), 4_294_768_890)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerLowest.getArgb(scheme), 4_294_967_295)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerLow.getArgb(scheme), 4_294_374_132)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainer.getArgb(scheme), 4_294_045_167)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerHigh.getArgb(scheme), 4_293_650_409)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerHighest.getArgb(scheme), 4_293_255_651)
    XCTAssertEqual(MaterialDynamicColors.onSurface.getArgb(scheme), 4_280_032_029)
    XCTAssertEqual(MaterialDynamicColors.onSurfaceVariant.getArgb(scheme), 4_282_861_128)
    XCTAssertEqual(MaterialDynamicColors.surfaceVariant.getArgb(scheme), 4_293_255_651)
    XCTAssertEqual(MaterialDynamicColors.inverseSurface.getArgb(scheme), 4_281_413_682)
    XCTAssertEqual(MaterialDynamicColors.inverseOnSurface.getArgb(scheme), 4_294_177_009)
    XCTAssertEqual(MaterialDynamicColors.outline.getArgb(scheme), 4_285_953_142)
    XCTAssertEqual(MaterialDynamicColors.outlineVariant.getArgb(scheme), 4_291_413_703)
    XCTAssertEqual(MaterialDynamicColors.shadow.getArgb(scheme), 4_278_190_080)
    XCTAssertEqual(MaterialDynamicColors.scrim.getArgb(scheme), 4_278_190_080)
    XCTAssertEqual(MaterialDynamicColors.surfaceTint.getArgb(scheme), 4_284_308_844)
    XCTAssertEqual(MaterialDynamicColors.primary.getArgb(scheme), 4_284_308_844)
    XCTAssertEqual(MaterialDynamicColors.onPrimary.getArgb(scheme), 4_294_967_295)
    XCTAssertEqual(MaterialDynamicColors.primaryContainer.getArgb(scheme), 4_293_059_059)
    XCTAssertEqual(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme), 4_279_900_967)
    XCTAssertEqual(MaterialDynamicColors.inversePrimary.getArgb(scheme), 4_291_216_854)
    XCTAssertEqual(MaterialDynamicColors.secondary.getArgb(scheme), 4_284_374_375)
    XCTAssertEqual(MaterialDynamicColors.onSecondary.getArgb(scheme), 4_294_967_295)
    XCTAssertEqual(MaterialDynamicColors.secondaryContainer.getArgb(scheme), 4_293_190_124)
    XCTAssertEqual(MaterialDynamicColors.onSecondaryContainer.getArgb(scheme), 4_279_966_499)
    XCTAssertEqual(MaterialDynamicColors.tertiary.getArgb(scheme), 4_284_243_314)
    XCTAssertEqual(MaterialDynamicColors.onTertiary.getArgb(scheme), 4_294_967_295)
    XCTAssertEqual(MaterialDynamicColors.tertiaryContainer.getArgb(scheme), 4_292_993_273)
    XCTAssertEqual(MaterialDynamicColors.onTertiaryContainer.getArgb(scheme), 4_279_835_180)
    XCTAssertEqual(MaterialDynamicColors.error.getArgb(scheme), 4_290_386_458)
    XCTAssertEqual(MaterialDynamicColors.onError.getArgb(scheme), 4_294_967_295)
    XCTAssertEqual(MaterialDynamicColors.errorContainer.getArgb(scheme), 4_294_957_782)
    XCTAssertEqual(MaterialDynamicColors.onErrorContainer.getArgb(scheme), 4_282_449_922)
    XCTAssertEqual(MaterialDynamicColors.primaryFixed.getArgb(scheme), 4_293_059_059)
    XCTAssertEqual(MaterialDynamicColors.primaryFixedDim.getArgb(scheme), 4_291_216_854)
    XCTAssertEqual(MaterialDynamicColors.onPrimaryFixed.getArgb(scheme), 4_279_900_967)
    XCTAssertEqual(MaterialDynamicColors.onPrimaryFixedVariant.getArgb(scheme), 4_282_730_068)
    XCTAssertEqual(MaterialDynamicColors.secondaryFixed.getArgb(scheme), 4_293_190_124)
    XCTAssertEqual(MaterialDynamicColors.secondaryFixedDim.getArgb(scheme), 4_291_282_384)
    XCTAssertEqual(MaterialDynamicColors.onSecondaryFixed.getArgb(scheme), 4_279_966_499)
    XCTAssertEqual(MaterialDynamicColors.onSecondaryFixedVariant.getArgb(scheme), 4_282_795_599)
    XCTAssertEqual(MaterialDynamicColors.tertiaryFixed.getArgb(scheme), 4_292_993_273)
    XCTAssertEqual(MaterialDynamicColors.tertiaryFixedDim.getArgb(scheme), 4_291_151_069)
    XCTAssertEqual(MaterialDynamicColors.onTertiaryFixed.getArgb(scheme), 4_279_835_180)
    XCTAssertEqual(MaterialDynamicColors.onTertiaryFixedVariant.getArgb(scheme), 4_282_664_281)
  }

  func testLightSchemeNeutralMaxContrast() {
    let scheme = SchemeNeutral(
      sourceColorHct: Hct.fromInt(0xFF_ff00_00ff),
      isDark: false,
      contrastLevel: 1.0
    )

    XCTAssertEqual(MaterialDynamicColors.background.getArgb(scheme), 4_294_768_890)
    XCTAssertEqual(MaterialDynamicColors.onBackground.getArgb(scheme), 4_279_966_236)
    XCTAssertEqual(MaterialDynamicColors.surface.getArgb(scheme), 4_294_768_890)
    XCTAssertEqual(MaterialDynamicColors.surfaceDim.getArgb(scheme), 4_292_663_771)
    XCTAssertEqual(MaterialDynamicColors.surfaceBright.getArgb(scheme), 4_294_768_890)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerLowest.getArgb(scheme), 4_294_967_295)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerLow.getArgb(scheme), 4_294_374_132)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainer.getArgb(scheme), 4_294_045_167)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerHigh.getArgb(scheme), 4_293_650_409)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerHighest.getArgb(scheme), 4_293_255_651)
    XCTAssertEqual(MaterialDynamicColors.onSurface.getArgb(scheme), 4_279_966_236)
    XCTAssertEqual(MaterialDynamicColors.onSurfaceVariant.getArgb(scheme), 4_282_795_335)
    XCTAssertEqual(MaterialDynamicColors.surfaceVariant.getArgb(scheme), 4_293_255_651)
    XCTAssertEqual(MaterialDynamicColors.inverseSurface.getArgb(scheme), 4_281_413_682)
    XCTAssertEqual(MaterialDynamicColors.inverseOnSurface.getArgb(scheme), 4_294_308_339)
    XCTAssertEqual(MaterialDynamicColors.outline.getArgb(scheme), 4_282_597_956)
    XCTAssertEqual(MaterialDynamicColors.outlineVariant.getArgb(scheme), 4_282_597_956)
    XCTAssertEqual(MaterialDynamicColors.shadow.getArgb(scheme), 4_278_190_080)
    XCTAssertEqual(MaterialDynamicColors.scrim.getArgb(scheme), 4_278_190_080)
    XCTAssertEqual(MaterialDynamicColors.surfaceTint.getArgb(scheme), 4_284_308_844)
    XCTAssertEqual(MaterialDynamicColors.primary.getArgb(scheme), 4_280_361_262)
    XCTAssertEqual(MaterialDynamicColors.onPrimary.getArgb(scheme), 4_289_572_028)
    XCTAssertEqual(MaterialDynamicColors.primaryContainer.getArgb(scheme), 4_282_466_896)
    XCTAssertEqual(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme), 4_292_466_922)
    XCTAssertEqual(MaterialDynamicColors.inversePrimary.getArgb(scheme), 4_291_282_647)
    XCTAssertEqual(MaterialDynamicColors.secondary.getArgb(scheme), 4_280_361_513)
    XCTAssertEqual(MaterialDynamicColors.onSecondary.getArgb(scheme), 4_289_637_558)
    XCTAssertEqual(MaterialDynamicColors.secondaryContainer.getArgb(scheme), 4_282_532_427)
    XCTAssertEqual(MaterialDynamicColors.onSecondaryContainer.getArgb(scheme), 4_292_597_987)
    XCTAssertEqual(MaterialDynamicColors.tertiary.getArgb(scheme), 4_280_295_731)
    XCTAssertEqual(MaterialDynamicColors.onTertiary.getArgb(scheme), 4_289_440_707)
    XCTAssertEqual(MaterialDynamicColors.tertiaryContainer.getArgb(scheme), 4_282_401_109)
    XCTAssertEqual(MaterialDynamicColors.onTertiaryContainer.getArgb(scheme), 4_292_401_136)
    XCTAssertEqual(MaterialDynamicColors.error.getArgb(scheme), 4_283_301_890)
    XCTAssertEqual(MaterialDynamicColors.onError.getArgb(scheme), 4_294_937_984)
    XCTAssertEqual(MaterialDynamicColors.errorContainer.getArgb(scheme), 4_287_365_129)
    XCTAssertEqual(MaterialDynamicColors.onErrorContainer.getArgb(scheme), 4_294_954_696)
    XCTAssertEqual(MaterialDynamicColors.primaryFixed.getArgb(scheme), 4_282_466_896)
    XCTAssertEqual(MaterialDynamicColors.primaryFixedDim.getArgb(scheme), 4_282_466_896)
    XCTAssertEqual(MaterialDynamicColors.onPrimaryFixed.getArgb(scheme), 4_292_466_922)
    XCTAssertEqual(MaterialDynamicColors.onPrimaryFixedVariant.getArgb(scheme), 4_292_466_922)
    XCTAssertEqual(MaterialDynamicColors.secondaryFixed.getArgb(scheme), 4_282_532_427)
    XCTAssertEqual(MaterialDynamicColors.secondaryFixedDim.getArgb(scheme), 4_282_532_427)
    XCTAssertEqual(MaterialDynamicColors.onSecondaryFixed.getArgb(scheme), 4_292_597_987)
    XCTAssertEqual(MaterialDynamicColors.onSecondaryFixedVariant.getArgb(scheme), 4_292_597_987)
    XCTAssertEqual(MaterialDynamicColors.tertiaryFixed.getArgb(scheme), 4_282_401_109)
    XCTAssertEqual(MaterialDynamicColors.tertiaryFixedDim.getArgb(scheme), 4_282_401_109)
    XCTAssertEqual(MaterialDynamicColors.onTertiaryFixed.getArgb(scheme), 4_292_401_136)
    XCTAssertEqual(MaterialDynamicColors.onTertiaryFixedVariant.getArgb(scheme), 4_292_401_136)
  }

  func testDarkSchemeNeutralMinContrast() {
    let scheme = SchemeNeutral(
      sourceColorHct: Hct.fromInt(0xFF_ff00_00ff),
      isDark: true,
      contrastLevel: -1.0
    )

    XCTAssertEqual(MaterialDynamicColors.background.getArgb(scheme), 4_279_440_149)
    XCTAssertEqual(MaterialDynamicColors.onBackground.getArgb(scheme), 4_285_953_142)
    XCTAssertEqual(MaterialDynamicColors.surface.getArgb(scheme), 4_279_440_149)
    XCTAssertEqual(MaterialDynamicColors.surfaceDim.getArgb(scheme), 4_279_440_149)
    XCTAssertEqual(MaterialDynamicColors.surfaceBright.getArgb(scheme), 4_282_005_818)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerLowest.getArgb(scheme), 4_279_111_183)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerLow.getArgb(scheme), 4_280_032_029)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainer.getArgb(scheme), 4_280_295_201)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerHigh.getArgb(scheme), 4_280_953_387)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerHighest.getArgb(scheme), 4_281_676_854)
    XCTAssertEqual(MaterialDynamicColors.onSurface.getArgb(scheme), 4_289_045_156)
    XCTAssertEqual(MaterialDynamicColors.onSurfaceVariant.getArgb(scheme), 4_287_992_468)
    XCTAssertEqual(MaterialDynamicColors.surfaceVariant.getArgb(scheme), 4_282_861_128)
    XCTAssertEqual(MaterialDynamicColors.inverseSurface.getArgb(scheme), 4_293_255_651)
    XCTAssertEqual(MaterialDynamicColors.inverseOnSurface.getArgb(scheme), 4_284_834_917)
    XCTAssertEqual(MaterialDynamicColors.outline.getArgb(scheme), 4_285_953_142)
    XCTAssertEqual(MaterialDynamicColors.outlineVariant.getArgb(scheme), 4_282_861_128)
    XCTAssertEqual(MaterialDynamicColors.shadow.getArgb(scheme), 4_278_190_080)
    XCTAssertEqual(MaterialDynamicColors.scrim.getArgb(scheme), 4_278_190_080)
    XCTAssertEqual(MaterialDynamicColors.surfaceTint.getArgb(scheme), 4_291_216_854)
    XCTAssertEqual(MaterialDynamicColors.primary.getArgb(scheme), 4_285_756_291)
    XCTAssertEqual(MaterialDynamicColors.onPrimary.getArgb(scheme), 4_294_966_271)
    XCTAssertEqual(MaterialDynamicColors.primaryContainer.getArgb(scheme), 4_282_730_068)
    XCTAssertEqual(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme), 4_290_098_116)
    XCTAssertEqual(MaterialDynamicColors.inversePrimary.getArgb(scheme), 4_285_756_291)
    XCTAssertEqual(MaterialDynamicColors.secondary.getArgb(scheme), 4_285_821_821)
    XCTAssertEqual(MaterialDynamicColors.onSecondary.getArgb(scheme), 4_294_966_271)
    XCTAssertEqual(MaterialDynamicColors.secondaryContainer.getArgb(scheme), 4_282_795_599)
    XCTAssertEqual(MaterialDynamicColors.onSecondaryContainer.getArgb(scheme), 4_290_163_902)
    XCTAssertEqual(MaterialDynamicColors.tertiary.getArgb(scheme), 4_285_690_761)
    XCTAssertEqual(MaterialDynamicColors.onTertiary.getArgb(scheme), 4_294_966_271)
    XCTAssertEqual(MaterialDynamicColors.tertiaryContainer.getArgb(scheme), 4_282_664_281)
    XCTAssertEqual(MaterialDynamicColors.onTertiaryContainer.getArgb(scheme), 4_289_967_051)
    XCTAssertEqual(MaterialDynamicColors.error.getArgb(scheme), 4_292_490_286)
    XCTAssertEqual(MaterialDynamicColors.onError.getArgb(scheme), 4_294_966_271)
    XCTAssertEqual(MaterialDynamicColors.errorContainer.getArgb(scheme), 4_287_823_882)
    XCTAssertEqual(MaterialDynamicColors.onErrorContainer.getArgb(scheme), 4_294_941_326)
    XCTAssertEqual(MaterialDynamicColors.primaryFixed.getArgb(scheme), 4_288_848_306)
    XCTAssertEqual(MaterialDynamicColors.primaryFixedDim.getArgb(scheme), 4_285_756_291)
    XCTAssertEqual(MaterialDynamicColors.onPrimaryFixed.getArgb(scheme), 4_294_966_271)
    XCTAssertEqual(MaterialDynamicColors.onPrimaryFixedVariant.getArgb(scheme), 4_291_940_321)
    XCTAssertEqual(MaterialDynamicColors.secondaryFixed.getArgb(scheme), 4_288_914_092)
    XCTAssertEqual(MaterialDynamicColors.secondaryFixedDim.getArgb(scheme), 4_285_821_821)
    XCTAssertEqual(MaterialDynamicColors.onSecondaryFixed.getArgb(scheme), 4_294_966_271)
    XCTAssertEqual(MaterialDynamicColors.onSecondaryFixedVariant.getArgb(scheme), 4_292_005_850)
    XCTAssertEqual(MaterialDynamicColors.tertiaryFixed.getArgb(scheme), 4_288_782_776)
    XCTAssertEqual(MaterialDynamicColors.tertiaryFixedDim.getArgb(scheme), 4_285_690_761)
    XCTAssertEqual(MaterialDynamicColors.onTertiaryFixed.getArgb(scheme), 4_294_966_271)
    XCTAssertEqual(MaterialDynamicColors.onTertiaryFixedVariant.getArgb(scheme), 4_291_809_255)
  }

  func testDarkSchemeNeutralStandardContrast() {
    let scheme = SchemeNeutral(
      sourceColorHct: Hct.fromInt(0xFF_ff00_00ff),
      isDark: true,
      contrastLevel: 0.0
    )

    XCTAssertEqual(MaterialDynamicColors.background.getArgb(scheme), 4_279_440_149)
    XCTAssertEqual(MaterialDynamicColors.onBackground.getArgb(scheme), 4_293_255_651)
    XCTAssertEqual(MaterialDynamicColors.surface.getArgb(scheme), 4_279_440_149)
    XCTAssertEqual(MaterialDynamicColors.surfaceDim.getArgb(scheme), 4_279_440_149)
    XCTAssertEqual(MaterialDynamicColors.surfaceBright.getArgb(scheme), 4_282_005_818)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerLowest.getArgb(scheme), 4_279_111_183)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerLow.getArgb(scheme), 4_280_032_029)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainer.getArgb(scheme), 4_280_295_201)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerHigh.getArgb(scheme), 4_280_953_387)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerHighest.getArgb(scheme), 4_281_676_854)
    XCTAssertEqual(MaterialDynamicColors.onSurface.getArgb(scheme), 4_293_255_651)
    XCTAssertEqual(MaterialDynamicColors.onSurfaceVariant.getArgb(scheme), 4_291_413_703)
    XCTAssertEqual(MaterialDynamicColors.surfaceVariant.getArgb(scheme), 4_282_861_128)
    XCTAssertEqual(MaterialDynamicColors.inverseSurface.getArgb(scheme), 4_293_255_651)
    XCTAssertEqual(MaterialDynamicColors.inverseOnSurface.getArgb(scheme), 4_281_413_682)
    XCTAssertEqual(MaterialDynamicColors.outline.getArgb(scheme), 4_285_953_142)
    XCTAssertEqual(MaterialDynamicColors.outlineVariant.getArgb(scheme), 4_282_861_128)
    XCTAssertEqual(MaterialDynamicColors.shadow.getArgb(scheme), 4_278_190_080)
    XCTAssertEqual(MaterialDynamicColors.scrim.getArgb(scheme), 4_278_190_080)
    XCTAssertEqual(MaterialDynamicColors.surfaceTint.getArgb(scheme), 4_291_216_854)
    XCTAssertEqual(MaterialDynamicColors.primary.getArgb(scheme), 4_291_216_854)
    XCTAssertEqual(MaterialDynamicColors.onPrimary.getArgb(scheme), 4_281_282_365)
    XCTAssertEqual(MaterialDynamicColors.primaryContainer.getArgb(scheme), 4_282_730_068)
    XCTAssertEqual(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme), 4_293_059_059)
    XCTAssertEqual(MaterialDynamicColors.inversePrimary.getArgb(scheme), 4_284_308_844)
    XCTAssertEqual(MaterialDynamicColors.secondary.getArgb(scheme), 4_291_282_384)
    XCTAssertEqual(MaterialDynamicColors.onSecondary.getArgb(scheme), 4_281_348_152)
    XCTAssertEqual(MaterialDynamicColors.secondaryContainer.getArgb(scheme), 4_282_795_599)
    XCTAssertEqual(MaterialDynamicColors.onSecondaryContainer.getArgb(scheme), 4_293_190_124)
    XCTAssertEqual(MaterialDynamicColors.tertiary.getArgb(scheme), 4_291_151_069)
    XCTAssertEqual(MaterialDynamicColors.onTertiary.getArgb(scheme), 4_281_216_834)
    XCTAssertEqual(MaterialDynamicColors.tertiaryContainer.getArgb(scheme), 4_282_664_281)
    XCTAssertEqual(MaterialDynamicColors.onTertiaryContainer.getArgb(scheme), 4_292_993_273)
    XCTAssertEqual(MaterialDynamicColors.error.getArgb(scheme), 4_294_948_011)
    XCTAssertEqual(MaterialDynamicColors.onError.getArgb(scheme), 4_285_071_365)
    XCTAssertEqual(MaterialDynamicColors.errorContainer.getArgb(scheme), 4_287_823_882)
    XCTAssertEqual(MaterialDynamicColors.onErrorContainer.getArgb(scheme), 4_294_957_782)
    XCTAssertEqual(MaterialDynamicColors.primaryFixed.getArgb(scheme), 4_293_059_059)
    XCTAssertEqual(MaterialDynamicColors.primaryFixedDim.getArgb(scheme), 4_291_216_854)
    XCTAssertEqual(MaterialDynamicColors.onPrimaryFixed.getArgb(scheme), 4_279_900_967)
    XCTAssertEqual(MaterialDynamicColors.onPrimaryFixedVariant.getArgb(scheme), 4_282_730_068)
    XCTAssertEqual(MaterialDynamicColors.secondaryFixed.getArgb(scheme), 4_293_190_124)
    XCTAssertEqual(MaterialDynamicColors.secondaryFixedDim.getArgb(scheme), 4_291_282_384)
    XCTAssertEqual(MaterialDynamicColors.onSecondaryFixed.getArgb(scheme), 4_279_966_499)
    XCTAssertEqual(MaterialDynamicColors.onSecondaryFixedVariant.getArgb(scheme), 4_282_795_599)
    XCTAssertEqual(MaterialDynamicColors.tertiaryFixed.getArgb(scheme), 4_292_993_273)
    XCTAssertEqual(MaterialDynamicColors.tertiaryFixedDim.getArgb(scheme), 4_291_151_069)
    XCTAssertEqual(MaterialDynamicColors.onTertiaryFixed.getArgb(scheme), 4_279_835_180)
    XCTAssertEqual(MaterialDynamicColors.onTertiaryFixedVariant.getArgb(scheme), 4_282_664_281)
  }

  func testDarkSchemeNeutralMaxContrast() {
    let scheme = SchemeNeutral(
      sourceColorHct: Hct.fromInt(0xFF_ff00_00ff),
      isDark: true,
      contrastLevel: 1.0
    )

    XCTAssertEqual(MaterialDynamicColors.background.getArgb(scheme), 4_279_440_149)
    XCTAssertEqual(MaterialDynamicColors.onBackground.getArgb(scheme), 4_293_321_700)
    XCTAssertEqual(MaterialDynamicColors.surface.getArgb(scheme), 4_279_440_149)
    XCTAssertEqual(MaterialDynamicColors.surfaceDim.getArgb(scheme), 4_279_440_149)
    XCTAssertEqual(MaterialDynamicColors.surfaceBright.getArgb(scheme), 4_282_005_818)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerLowest.getArgb(scheme), 4_279_111_183)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerLow.getArgb(scheme), 4_280_032_029)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainer.getArgb(scheme), 4_280_295_201)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerHigh.getArgb(scheme), 4_280_953_387)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerHighest.getArgb(scheme), 4_281_676_854)
    XCTAssertEqual(MaterialDynamicColors.onSurface.getArgb(scheme), 4_293_321_700)
    XCTAssertEqual(MaterialDynamicColors.onSurfaceVariant.getArgb(scheme), 4_293_124_065)
    XCTAssertEqual(MaterialDynamicColors.surfaceVariant.getArgb(scheme), 4_282_861_128)
    XCTAssertEqual(MaterialDynamicColors.inverseSurface.getArgb(scheme), 4_293_255_651)
    XCTAssertEqual(MaterialDynamicColors.inverseOnSurface.getArgb(scheme), 4_281_347_889)
    XCTAssertEqual(MaterialDynamicColors.outline.getArgb(scheme), 4_291_676_876)
    XCTAssertEqual(MaterialDynamicColors.outlineVariant.getArgb(scheme), 4_291_676_876)
    XCTAssertEqual(MaterialDynamicColors.shadow.getArgb(scheme), 4_278_190_080)
    XCTAssertEqual(MaterialDynamicColors.scrim.getArgb(scheme), 4_278_190_080)
    XCTAssertEqual(MaterialDynamicColors.surfaceTint.getArgb(scheme), 4_291_216_854)
    XCTAssertEqual(MaterialDynamicColors.primary.getArgb(scheme), 4_294_374_655)
    XCTAssertEqual(MaterialDynamicColors.onPrimary.getArgb(scheme), 4_283_519_328)
    XCTAssertEqual(MaterialDynamicColors.primaryContainer.getArgb(scheme), 4_291_480_026)
    XCTAssertEqual(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme), 4_281_808_966)
    XCTAssertEqual(MaterialDynamicColors.inversePrimary.getArgb(scheme), 4_282_861_397)
    XCTAssertEqual(MaterialDynamicColors.secondary.getArgb(scheme), 4_294_374_655)
    XCTAssertEqual(MaterialDynamicColors.onSecondary.getArgb(scheme), 4_283_585_115)
    XCTAssertEqual(MaterialDynamicColors.secondaryContainer.getArgb(scheme), 4_291_545_556)
    XCTAssertEqual(MaterialDynamicColors.onSecondaryContainer.getArgb(scheme), 4_281_874_497)
    XCTAssertEqual(MaterialDynamicColors.tertiary.getArgb(scheme), 4_294_374_655)
    XCTAssertEqual(MaterialDynamicColors.onTertiary.getArgb(scheme), 4_283_453_797)
    XCTAssertEqual(MaterialDynamicColors.tertiaryContainer.getArgb(scheme), 4_291_414_497)
    XCTAssertEqual(MaterialDynamicColors.onTertiaryContainer.getArgb(scheme), 4_281_808_715)
    XCTAssertEqual(MaterialDynamicColors.error.getArgb(scheme), 4_294_963_953)
    XCTAssertEqual(MaterialDynamicColors.onError.getArgb(scheme), 4_289_201_936)
    XCTAssertEqual(MaterialDynamicColors.errorContainer.getArgb(scheme), 4_294_949_553)
    XCTAssertEqual(MaterialDynamicColors.onErrorContainer.getArgb(scheme), 4_286_119_942)
    XCTAssertEqual(MaterialDynamicColors.primaryFixed.getArgb(scheme), 4_293_190_388)
    XCTAssertEqual(MaterialDynamicColors.primaryFixedDim.getArgb(scheme), 4_291_480_026)
    XCTAssertEqual(MaterialDynamicColors.onPrimaryFixed.getArgb(scheme), 4_281_808_966)
    XCTAssertEqual(MaterialDynamicColors.onPrimaryFixedVariant.getArgb(scheme), 4_281_808_966)
    XCTAssertEqual(MaterialDynamicColors.secondaryFixed.getArgb(scheme), 4_293_255_917)
    XCTAssertEqual(MaterialDynamicColors.secondaryFixedDim.getArgb(scheme), 4_291_545_556)
    XCTAssertEqual(MaterialDynamicColors.onSecondaryFixed.getArgb(scheme), 4_281_874_497)
    XCTAssertEqual(MaterialDynamicColors.onSecondaryFixedVariant.getArgb(scheme), 4_281_874_497)
    XCTAssertEqual(MaterialDynamicColors.tertiaryFixed.getArgb(scheme), 4_293_059_066)
    XCTAssertEqual(MaterialDynamicColors.tertiaryFixedDim.getArgb(scheme), 4_291_414_497)
    XCTAssertEqual(MaterialDynamicColors.onTertiaryFixed.getArgb(scheme), 4_281_808_715)
    XCTAssertEqual(MaterialDynamicColors.onTertiaryFixedVariant.getArgb(scheme), 4_281_808_715)
  }
}
