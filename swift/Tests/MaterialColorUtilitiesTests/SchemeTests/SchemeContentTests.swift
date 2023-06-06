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

    XCTAssertEqual(MaterialDynamicColors.primaryPaletteKeyColor.getArgb(scheme), 0xff08_0CFF)
    XCTAssertEqual(MaterialDynamicColors.secondaryPaletteKeyColor.getArgb(scheme), 0xff65_6DD3)
    XCTAssertEqual(MaterialDynamicColors.tertiaryPaletteKeyColor.getArgb(scheme), 0xff81_009F)
    XCTAssertEqual(MaterialDynamicColors.neutralPaletteKeyColor.getArgb(scheme), 0xff76_7684)
    XCTAssertEqual(MaterialDynamicColors.neutralVariantPaletteKeyColor.getArgb(scheme), 0xff75_7589)
  }

  func testLightSchemeContentMinContrast() {
    let scheme = SchemeContent(
      sourceColorHct: Hct.fromInt(0xFF_ff00_00ff),
      isDark: false,
      contrastLevel: -1.0
    )

    XCTAssertEqual(MaterialDynamicColors.background.getArgb(scheme), 4_294_703_359)
    XCTAssertEqual(MaterialDynamicColors.onBackground.getArgb(scheme), 4_285_624_703)
    XCTAssertEqual(MaterialDynamicColors.surface.getArgb(scheme), 4_294_703_359)
    XCTAssertEqual(MaterialDynamicColors.surfaceDim.getArgb(scheme), 4_292_532_456)
    XCTAssertEqual(MaterialDynamicColors.surfaceBright.getArgb(scheme), 4_294_703_359)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerLowest.getArgb(scheme), 4_294_967_295)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerLow.getArgb(scheme), 4_294_308_607)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainer.getArgb(scheme), 4_293_848_316)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerHigh.getArgb(scheme), 4_293_453_558)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerHighest.getArgb(scheme), 4_293_124_593)
    XCTAssertEqual(MaterialDynamicColors.onSurface.getArgb(scheme), 4_284_374_635)
    XCTAssertEqual(MaterialDynamicColors.onSurfaceVariant.getArgb(scheme), 4_284_638_070)
    XCTAssertEqual(MaterialDynamicColors.surfaceVariant.getArgb(scheme), 4_293_058_807)
    XCTAssertEqual(MaterialDynamicColors.inverseSurface.getArgb(scheme), 4_281_282_363)
    XCTAssertEqual(MaterialDynamicColors.inverseOnSurface.getArgb(scheme), 4_288_190_373)
    XCTAssertEqual(MaterialDynamicColors.outline.getArgb(scheme), 4_285_756_295)
    XCTAssertEqual(MaterialDynamicColors.outlineVariant.getArgb(scheme), 4_291_151_067)
    XCTAssertEqual(MaterialDynamicColors.shadow.getArgb(scheme), 4_278_190_080)
    XCTAssertEqual(MaterialDynamicColors.scrim.getArgb(scheme), 4_278_190_080)
    XCTAssertEqual(MaterialDynamicColors.surfaceTint.getArgb(scheme), 4_281_613_823)
    XCTAssertEqual(MaterialDynamicColors.primary.getArgb(scheme), 4_279_376_127)
    XCTAssertEqual(MaterialDynamicColors.onPrimary.getArgb(scheme), 4_287_534_591)
    XCTAssertEqual(MaterialDynamicColors.primaryContainer.getArgb(scheme), 4_283_851_007)
    XCTAssertEqual(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme), 4_291_546_623)
    XCTAssertEqual(MaterialDynamicColors.inversePrimary.getArgb(scheme), 4_286_942_719)
    XCTAssertEqual(MaterialDynamicColors.secondary.getArgb(scheme), 4_284_705_489)
    XCTAssertEqual(MaterialDynamicColors.onSecondary.getArgb(scheme), 4_291_546_623)
    XCTAssertEqual(MaterialDynamicColors.secondaryContainer.getArgb(scheme), 4_288_389_631)
    XCTAssertEqual(MaterialDynamicColors.onSecondaryContainer.getArgb(scheme), 4_282_731_697)
    XCTAssertEqual(MaterialDynamicColors.tertiary.getArgb(scheme), 4_286_975_140)
    XCTAssertEqual(MaterialDynamicColors.onTertiary.getArgb(scheme), 4_292_964_603)
    XCTAssertEqual(MaterialDynamicColors.tertiaryContainer.getArgb(scheme), 4_289_741_516)
    XCTAssertEqual(MaterialDynamicColors.onTertiaryContainer.getArgb(scheme), 4_294_426_111)
    XCTAssertEqual(MaterialDynamicColors.error.getArgb(scheme), 4_292_490_286)
    XCTAssertEqual(MaterialDynamicColors.onError.getArgb(scheme), 4_294_951_611)
    XCTAssertEqual(MaterialDynamicColors.errorContainer.getArgb(scheme), 4_294_957_782)
    XCTAssertEqual(MaterialDynamicColors.onErrorContainer.getArgb(scheme), 4_290_978_336)
    XCTAssertEqual(MaterialDynamicColors.primaryFixed.getArgb(scheme), 4_292_927_743)
    XCTAssertEqual(MaterialDynamicColors.primaryFixedDim.getArgb(scheme), 4_290_691_839)
    XCTAssertEqual(MaterialDynamicColors.onPrimaryFixed.getArgb(scheme), 4_279_902_719)
    XCTAssertEqual(MaterialDynamicColors.onPrimaryFixedVariant.getArgb(scheme), 4_283_127_295)
    XCTAssertEqual(MaterialDynamicColors.secondaryFixed.getArgb(scheme), 4_292_927_743)
    XCTAssertEqual(MaterialDynamicColors.secondaryFixedDim.getArgb(scheme), 4_290_691_839)
    XCTAssertEqual(MaterialDynamicColors.onSecondaryFixed.getArgb(scheme), 4_282_402_732)
    XCTAssertEqual(MaterialDynamicColors.onSecondaryFixedVariant.getArgb(scheme), 4_284_179_400)
    XCTAssertEqual(MaterialDynamicColors.tertiaryFixed.getArgb(scheme), 4_294_825_727)
    XCTAssertEqual(MaterialDynamicColors.tertiaryFixedDim.getArgb(scheme), 4_294_225_663)
    XCTAssertEqual(MaterialDynamicColors.onTertiaryFixed.getArgb(scheme), 4_287_173_286)
    XCTAssertEqual(MaterialDynamicColors.onTertiaryFixedVariant.getArgb(scheme), 4_289_215_172)
  }

  func testLightSchemeContentStandardContrast() {
    let scheme = SchemeContent(
      sourceColorHct: Hct.fromInt(0xFF_ff00_00ff),
      isDark: false,
      contrastLevel: 0.0
    )

    XCTAssertEqual(MaterialDynamicColors.background.getArgb(scheme), 4_294_703_359)
    XCTAssertEqual(MaterialDynamicColors.onBackground.getArgb(scheme), 4_279_900_966)
    XCTAssertEqual(MaterialDynamicColors.surface.getArgb(scheme), 4_294_703_359)
    XCTAssertEqual(MaterialDynamicColors.surfaceDim.getArgb(scheme), 4_292_532_456)
    XCTAssertEqual(MaterialDynamicColors.surfaceBright.getArgb(scheme), 4_294_703_359)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerLowest.getArgb(scheme), 4_294_967_295)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerLow.getArgb(scheme), 4_294_308_607)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainer.getArgb(scheme), 4_293_848_316)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerHigh.getArgb(scheme), 4_293_453_558)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerHighest.getArgb(scheme), 4_293_124_593)
    XCTAssertEqual(MaterialDynamicColors.onSurface.getArgb(scheme), 4_279_900_966)
    XCTAssertEqual(MaterialDynamicColors.onSurfaceVariant.getArgb(scheme), 4_282_729_816)
    XCTAssertEqual(MaterialDynamicColors.surfaceVariant.getArgb(scheme), 4_293_058_807)
    XCTAssertEqual(MaterialDynamicColors.inverseSurface.getArgb(scheme), 4_281_282_363)
    XCTAssertEqual(MaterialDynamicColors.inverseOnSurface.getArgb(scheme), 4_294_045_695)
    XCTAssertEqual(MaterialDynamicColors.outline.getArgb(scheme), 4_285_756_295)
    XCTAssertEqual(MaterialDynamicColors.outlineVariant.getArgb(scheme), 4_291_151_067)
    XCTAssertEqual(MaterialDynamicColors.shadow.getArgb(scheme), 4_278_190_080)
    XCTAssertEqual(MaterialDynamicColors.scrim.getArgb(scheme), 4_278_190_080)
    XCTAssertEqual(MaterialDynamicColors.surfaceTint.getArgb(scheme), 4_281_613_823)
    XCTAssertEqual(MaterialDynamicColors.primary.getArgb(scheme), 4_278_190_531)
    XCTAssertEqual(MaterialDynamicColors.onPrimary.getArgb(scheme), 4_291_020_543)
    XCTAssertEqual(MaterialDynamicColors.primaryContainer.getArgb(scheme), 4_281_153_279)
    XCTAssertEqual(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme), 4_291_743_743)
    XCTAssertEqual(MaterialDynamicColors.inversePrimary.getArgb(scheme), 4_290_691_839)
    XCTAssertEqual(MaterialDynamicColors.secondary.getArgb(scheme), 4_283_192_248)
    XCTAssertEqual(MaterialDynamicColors.onSecondary.getArgb(scheme), 4_294_967_295)
    XCTAssertEqual(MaterialDynamicColors.secondaryContainer.getArgb(scheme), 4_288_389_631)
    XCTAssertEqual(MaterialDynamicColors.onSecondaryContainer.getArgb(scheme), 4_280_955_030)
    XCTAssertEqual(MaterialDynamicColors.tertiary.getArgb(scheme), 4_284_547_192)
    XCTAssertEqual(MaterialDynamicColors.onTertiary.getArgb(scheme), 4_294_292_479)
    XCTAssertEqual(MaterialDynamicColors.tertiaryContainer.getArgb(scheme), 4_287_766_959)
    XCTAssertEqual(MaterialDynamicColors.onTertiaryContainer.getArgb(scheme), 4_294_492_159)
    XCTAssertEqual(MaterialDynamicColors.error.getArgb(scheme), 4_290_386_458)
    XCTAssertEqual(MaterialDynamicColors.onError.getArgb(scheme), 4_294_967_295)
    XCTAssertEqual(MaterialDynamicColors.errorContainer.getArgb(scheme), 4_294_957_782)
    XCTAssertEqual(MaterialDynamicColors.onErrorContainer.getArgb(scheme), 4_282_449_922)
    XCTAssertEqual(MaterialDynamicColors.primaryFixed.getArgb(scheme), 4_292_927_743)
    XCTAssertEqual(MaterialDynamicColors.primaryFixedDim.getArgb(scheme), 4_290_691_839)
    XCTAssertEqual(MaterialDynamicColors.onPrimaryFixed.getArgb(scheme), 4_278_190_190)
    XCTAssertEqual(MaterialDynamicColors.onPrimaryFixedVariant.getArgb(scheme), 4_278_190_319)
    XCTAssertEqual(MaterialDynamicColors.secondaryFixed.getArgb(scheme), 4_292_927_743)
    XCTAssertEqual(MaterialDynamicColors.secondaryFixedDim.getArgb(scheme), 4_290_691_839)
    XCTAssertEqual(MaterialDynamicColors.onSecondaryFixed.getArgb(scheme), 4_278_190_190)
    XCTAssertEqual(MaterialDynamicColors.onSecondaryFixedVariant.getArgb(scheme), 4_281_547_423)
    XCTAssertEqual(MaterialDynamicColors.tertiaryFixed.getArgb(scheme), 4_294_825_727)
    XCTAssertEqual(MaterialDynamicColors.tertiaryFixedDim.getArgb(scheme), 4_294_225_663)
    XCTAssertEqual(MaterialDynamicColors.onTertiaryFixed.getArgb(scheme), 4_281_598_018)
    XCTAssertEqual(MaterialDynamicColors.onTertiaryFixedVariant.getArgb(scheme), 4_286_120_085)
  }

  func testLightSchemeContentMaxContrast() {
    let scheme = SchemeContent(
      sourceColorHct: Hct.fromInt(0xFF_ff00_00ff),
      isDark: false,
      contrastLevel: 1.0
    )

    XCTAssertEqual(MaterialDynamicColors.background.getArgb(scheme), 4_294_703_359)
    XCTAssertEqual(MaterialDynamicColors.onBackground.getArgb(scheme), 4_279_835_173)
    XCTAssertEqual(MaterialDynamicColors.surface.getArgb(scheme), 4_294_703_359)
    XCTAssertEqual(MaterialDynamicColors.surfaceDim.getArgb(scheme), 4_292_532_456)
    XCTAssertEqual(MaterialDynamicColors.surfaceBright.getArgb(scheme), 4_294_703_359)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerLowest.getArgb(scheme), 4_294_967_295)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerLow.getArgb(scheme), 4_294_308_607)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainer.getArgb(scheme), 4_293_848_316)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerHigh.getArgb(scheme), 4_293_453_558)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerHighest.getArgb(scheme), 4_293_124_593)
    XCTAssertEqual(MaterialDynamicColors.onSurface.getArgb(scheme), 4_279_835_173)
    XCTAssertEqual(MaterialDynamicColors.onSurfaceVariant.getArgb(scheme), 4_282_664_023)
    XCTAssertEqual(MaterialDynamicColors.surfaceVariant.getArgb(scheme), 4_293_058_807)
    XCTAssertEqual(MaterialDynamicColors.inverseSurface.getArgb(scheme), 4_281_282_363)
    XCTAssertEqual(MaterialDynamicColors.inverseOnSurface.getArgb(scheme), 4_294_111_487)
    XCTAssertEqual(MaterialDynamicColors.outline.getArgb(scheme), 4_282_466_643)
    XCTAssertEqual(MaterialDynamicColors.outlineVariant.getArgb(scheme), 4_282_466_643)
    XCTAssertEqual(MaterialDynamicColors.shadow.getArgb(scheme), 4_278_190_080)
    XCTAssertEqual(MaterialDynamicColors.scrim.getArgb(scheme), 4_278_190_080)
    XCTAssertEqual(MaterialDynamicColors.surfaceTint.getArgb(scheme), 4_281_613_823)
    XCTAssertEqual(MaterialDynamicColors.primary.getArgb(scheme), 4_278_190_465)
    XCTAssertEqual(MaterialDynamicColors.onPrimary.getArgb(scheme), 4_288_718_591)
    XCTAssertEqual(MaterialDynamicColors.primaryContainer.getArgb(scheme), 4_278_190_307)
    XCTAssertEqual(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme), 4_292_269_823)
    XCTAssertEqual(MaterialDynamicColors.inversePrimary.getArgb(scheme), 4_290_823_167)
    XCTAssertEqual(MaterialDynamicColors.secondary.getArgb(scheme), 4_278_453_884)
    XCTAssertEqual(MaterialDynamicColors.onSecondary.getArgb(scheme), 4_288_718_591)
    XCTAssertEqual(MaterialDynamicColors.secondaryContainer.getArgb(scheme), 4_281_283_995)
    XCTAssertEqual(MaterialDynamicColors.onSecondaryContainer.getArgb(scheme), 4_292_269_823)
    XCTAssertEqual(MaterialDynamicColors.tertiary.getArgb(scheme), 4_282_318_927)
    XCTAssertEqual(MaterialDynamicColors.onTertiary.getArgb(scheme), 4_293_494_783)
    XCTAssertEqual(MaterialDynamicColors.tertiaryContainer.getArgb(scheme), 4_285_726_862)
    XCTAssertEqual(MaterialDynamicColors.onTertiaryContainer.getArgb(scheme), 4_294_626_047)
    XCTAssertEqual(MaterialDynamicColors.error.getArgb(scheme), 4_283_301_890)
    XCTAssertEqual(MaterialDynamicColors.onError.getArgb(scheme), 4_294_937_984)
    XCTAssertEqual(MaterialDynamicColors.errorContainer.getArgb(scheme), 4_287_365_129)
    XCTAssertEqual(MaterialDynamicColors.onErrorContainer.getArgb(scheme), 4_294_954_696)
    XCTAssertEqual(MaterialDynamicColors.primaryFixed.getArgb(scheme), 4_278_190_307)
    XCTAssertEqual(MaterialDynamicColors.primaryFixedDim.getArgb(scheme), 4_278_190_307)
    XCTAssertEqual(MaterialDynamicColors.onPrimaryFixed.getArgb(scheme), 4_292_269_823)
    XCTAssertEqual(MaterialDynamicColors.onPrimaryFixedVariant.getArgb(scheme), 4_292_269_823)
    XCTAssertEqual(MaterialDynamicColors.secondaryFixed.getArgb(scheme), 4_281_283_995)
    XCTAssertEqual(MaterialDynamicColors.secondaryFixedDim.getArgb(scheme), 4_281_283_995)
    XCTAssertEqual(MaterialDynamicColors.onSecondaryFixed.getArgb(scheme), 4_292_269_823)
    XCTAssertEqual(MaterialDynamicColors.onSecondaryFixedVariant.getArgb(scheme), 4_292_269_823)
    XCTAssertEqual(MaterialDynamicColors.tertiaryFixed.getArgb(scheme), 4_285_726_862)
    XCTAssertEqual(MaterialDynamicColors.tertiaryFixedDim.getArgb(scheme), 4_285_726_862)
    XCTAssertEqual(MaterialDynamicColors.onTertiaryFixed.getArgb(scheme), 4_294_626_047)
    XCTAssertEqual(MaterialDynamicColors.onTertiaryFixedVariant.getArgb(scheme), 4_294_626_047)
  }

  func testDarkSchemeContentMinContrast() {
    let scheme = SchemeContent(
      sourceColorHct: Hct.fromInt(0xFF_ff00_00ff),
      isDark: true,
      contrastLevel: -1.0
    )

    XCTAssertEqual(MaterialDynamicColors.background.getArgb(scheme), 4_279_374_365)
    XCTAssertEqual(MaterialDynamicColors.onBackground.getArgb(scheme), 4_285_821_825)
    XCTAssertEqual(MaterialDynamicColors.surface.getArgb(scheme), 4_279_374_365)
    XCTAssertEqual(MaterialDynamicColors.surfaceDim.getArgb(scheme), 4_279_374_365)
    XCTAssertEqual(MaterialDynamicColors.surfaceBright.getArgb(scheme), 4_281_874_500)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerLowest.getArgb(scheme), 4_279_045_400)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerLow.getArgb(scheme), 4_279_900_966)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainer.getArgb(scheme), 4_280_164_138)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerHigh.getArgb(scheme), 4_280_887_605)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerHighest.getArgb(scheme), 4_281_545_792)
    XCTAssertEqual(MaterialDynamicColors.onSurface.getArgb(scheme), 4_288_848_304)
    XCTAssertEqual(MaterialDynamicColors.onSurfaceVariant.getArgb(scheme), 4_287_730_086)
    XCTAssertEqual(MaterialDynamicColors.surfaceVariant.getArgb(scheme), 4_282_729_816)
    XCTAssertEqual(MaterialDynamicColors.inverseSurface.getArgb(scheme), 4_293_124_593)
    XCTAssertEqual(MaterialDynamicColors.inverseOnSurface.getArgb(scheme), 4_284_703_601)
    XCTAssertEqual(MaterialDynamicColors.outline.getArgb(scheme), 4_285_756_295)
    XCTAssertEqual(MaterialDynamicColors.outlineVariant.getArgb(scheme), 4_282_729_816)
    XCTAssertEqual(MaterialDynamicColors.shadow.getArgb(scheme), 4_278_190_080)
    XCTAssertEqual(MaterialDynamicColors.scrim.getArgb(scheme), 4_278_190_080)
    XCTAssertEqual(MaterialDynamicColors.surfaceTint.getArgb(scheme), 4_290_691_839)
    XCTAssertEqual(MaterialDynamicColors.primary.getArgb(scheme), 4_283_851_007)
    XCTAssertEqual(MaterialDynamicColors.onPrimary.getArgb(scheme), 4_294_966_271)
    XCTAssertEqual(MaterialDynamicColors.primaryContainer.getArgb(scheme), 4_278_190_310)
    XCTAssertEqual(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme), 4_286_219_263)
    XCTAssertEqual(MaterialDynamicColors.inversePrimary.getArgb(scheme), 4_283_851_007)
    XCTAssertEqual(MaterialDynamicColors.secondary.getArgb(scheme), 4_284_705_489)
    XCTAssertEqual(MaterialDynamicColors.onSecondary.getArgb(scheme), 4_294_966_271)
    XCTAssertEqual(MaterialDynamicColors.secondaryContainer.getArgb(scheme), 4_281_086_616)
    XCTAssertEqual(MaterialDynamicColors.onSecondaryContainer.getArgb(scheme), 4_286_153_193)
    XCTAssertEqual(MaterialDynamicColors.tertiary.getArgb(scheme), 4_289_741_516)
    XCTAssertEqual(MaterialDynamicColors.onTertiary.getArgb(scheme), 4_294_966_271)
    XCTAssertEqual(MaterialDynamicColors.tertiaryContainer.getArgb(scheme), 4_285_792_399)
    XCTAssertEqual(MaterialDynamicColors.onTertiaryContainer.getArgb(scheme), 4_291_780_842)
    XCTAssertEqual(MaterialDynamicColors.error.getArgb(scheme), 4_292_490_286)
    XCTAssertEqual(MaterialDynamicColors.onError.getArgb(scheme), 4_294_966_271)
    XCTAssertEqual(MaterialDynamicColors.errorContainer.getArgb(scheme), 4_287_823_882)
    XCTAssertEqual(MaterialDynamicColors.onErrorContainer.getArgb(scheme), 4_294_941_326)
    XCTAssertEqual(MaterialDynamicColors.primaryFixed.getArgb(scheme), 4_287_863_551)
    XCTAssertEqual(MaterialDynamicColors.primaryFixedDim.getArgb(scheme), 4_283_851_007)
    XCTAssertEqual(MaterialDynamicColors.onPrimaryFixed.getArgb(scheme), 4_294_966_271)
    XCTAssertEqual(MaterialDynamicColors.onPrimaryFixedVariant.getArgb(scheme), 4_291_546_623)
    XCTAssertEqual(MaterialDynamicColors.secondaryFixed.getArgb(scheme), 4_287_863_551)
    XCTAssertEqual(MaterialDynamicColors.secondaryFixedDim.getArgb(scheme), 4_284_705_489)
    XCTAssertEqual(MaterialDynamicColors.onSecondaryFixed.getArgb(scheme), 4_294_966_271)
    XCTAssertEqual(MaterialDynamicColors.onSecondaryFixedVariant.getArgb(scheme), 4_291_546_623)
    XCTAssertEqual(MaterialDynamicColors.tertiaryFixed.getArgb(scheme), 4_293_228_031)
    XCTAssertEqual(MaterialDynamicColors.tertiaryFixedDim.getArgb(scheme), 4_289_741_516)
    XCTAssertEqual(MaterialDynamicColors.onTertiaryFixed.getArgb(scheme), 4_294_966_271)
    XCTAssertEqual(MaterialDynamicColors.onTertiaryFixedVariant.getArgb(scheme), 4_294_426_111)
  }

  func testDarkSchemeContentStandardContrast() {
    let scheme = SchemeContent(
      sourceColorHct: Hct.fromInt(0xFF_ff00_00ff),
      isDark: true,
      contrastLevel: 0.0
    )

    XCTAssertEqual(MaterialDynamicColors.background.getArgb(scheme), 4_279_374_365)
    XCTAssertEqual(MaterialDynamicColors.onBackground.getArgb(scheme), 4_293_124_593)
    XCTAssertEqual(MaterialDynamicColors.surface.getArgb(scheme), 4_279_374_365)
    XCTAssertEqual(MaterialDynamicColors.surfaceDim.getArgb(scheme), 4_279_374_365)
    XCTAssertEqual(MaterialDynamicColors.surfaceBright.getArgb(scheme), 4_281_874_500)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerLowest.getArgb(scheme), 4_279_045_400)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerLow.getArgb(scheme), 4_279_900_966)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainer.getArgb(scheme), 4_280_164_138)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerHigh.getArgb(scheme), 4_280_887_605)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerHighest.getArgb(scheme), 4_281_545_792)
    XCTAssertEqual(MaterialDynamicColors.onSurface.getArgb(scheme), 4_293_124_593)
    XCTAssertEqual(MaterialDynamicColors.onSurfaceVariant.getArgb(scheme), 4_291_151_067)
    XCTAssertEqual(MaterialDynamicColors.surfaceVariant.getArgb(scheme), 4_282_729_816)
    XCTAssertEqual(MaterialDynamicColors.inverseSurface.getArgb(scheme), 4_293_124_593)
    XCTAssertEqual(MaterialDynamicColors.inverseOnSurface.getArgb(scheme), 4_281_282_363)
    XCTAssertEqual(MaterialDynamicColors.outline.getArgb(scheme), 4_285_756_295)
    XCTAssertEqual(MaterialDynamicColors.outlineVariant.getArgb(scheme), 4_282_729_816)
    XCTAssertEqual(MaterialDynamicColors.shadow.getArgb(scheme), 4_278_190_080)
    XCTAssertEqual(MaterialDynamicColors.scrim.getArgb(scheme), 4_278_190_080)
    XCTAssertEqual(MaterialDynamicColors.surfaceTint.getArgb(scheme), 4_290_691_839)
    XCTAssertEqual(MaterialDynamicColors.primary.getArgb(scheme), 4_290_691_839)
    XCTAssertEqual(MaterialDynamicColors.onPrimary.getArgb(scheme), 4_278_190_508)
    XCTAssertEqual(MaterialDynamicColors.primaryContainer.getArgb(scheme), 4_278_190_310)
    XCTAssertEqual(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme), 4_288_981_759)
    XCTAssertEqual(MaterialDynamicColors.inversePrimary.getArgb(scheme), 4_281_613_823)
    XCTAssertEqual(MaterialDynamicColors.secondary.getArgb(scheme), 4_290_691_839)
    XCTAssertEqual(MaterialDynamicColors.onSecondary.getArgb(scheme), 4_279_836_553)
    XCTAssertEqual(MaterialDynamicColors.secondaryContainer.getArgb(scheme), 4_281_086_616)
    XCTAssertEqual(MaterialDynamicColors.onSecondaryContainer.getArgb(scheme), 4_288_521_471)
    XCTAssertEqual(MaterialDynamicColors.tertiary.getArgb(scheme), 4_294_225_663)
    XCTAssertEqual(MaterialDynamicColors.onTertiary.getArgb(scheme), 4_283_760_746)
    XCTAssertEqual(MaterialDynamicColors.tertiaryContainer.getArgb(scheme), 4_285_792_399)
    XCTAssertEqual(MaterialDynamicColors.onTertiaryContainer.getArgb(scheme), 4_293_627_135)
    XCTAssertEqual(MaterialDynamicColors.error.getArgb(scheme), 4_294_948_011)
    XCTAssertEqual(MaterialDynamicColors.onError.getArgb(scheme), 4_285_071_365)
    XCTAssertEqual(MaterialDynamicColors.errorContainer.getArgb(scheme), 4_287_823_882)
    XCTAssertEqual(MaterialDynamicColors.onErrorContainer.getArgb(scheme), 4_294_957_782)
    XCTAssertEqual(MaterialDynamicColors.primaryFixed.getArgb(scheme), 4_292_927_743)
    XCTAssertEqual(MaterialDynamicColors.primaryFixedDim.getArgb(scheme), 4_290_691_839)
    XCTAssertEqual(MaterialDynamicColors.onPrimaryFixed.getArgb(scheme), 4_278_190_190)
    XCTAssertEqual(MaterialDynamicColors.onPrimaryFixedVariant.getArgb(scheme), 4_278_190_319)
    XCTAssertEqual(MaterialDynamicColors.secondaryFixed.getArgb(scheme), 4_292_927_743)
    XCTAssertEqual(MaterialDynamicColors.secondaryFixedDim.getArgb(scheme), 4_290_691_839)
    XCTAssertEqual(MaterialDynamicColors.onSecondaryFixed.getArgb(scheme), 4_278_190_190)
    XCTAssertEqual(MaterialDynamicColors.onSecondaryFixedVariant.getArgb(scheme), 4_281_547_423)
    XCTAssertEqual(MaterialDynamicColors.tertiaryFixed.getArgb(scheme), 4_294_825_727)
    XCTAssertEqual(MaterialDynamicColors.tertiaryFixedDim.getArgb(scheme), 4_294_225_663)
    XCTAssertEqual(MaterialDynamicColors.onTertiaryFixed.getArgb(scheme), 4_281_598_018)
    XCTAssertEqual(MaterialDynamicColors.onTertiaryFixedVariant.getArgb(scheme), 4_286_120_085)
  }

  func testDarkSchemeContentMaxContrast() {
    let scheme = SchemeContent(
      sourceColorHct: Hct.fromInt(0xFF_ff00_00ff),
      isDark: true,
      contrastLevel: 1.0
    )

    XCTAssertEqual(MaterialDynamicColors.background.getArgb(scheme), 4_279_374_365)
    XCTAssertEqual(MaterialDynamicColors.onBackground.getArgb(scheme), 4_293_190_386)
    XCTAssertEqual(MaterialDynamicColors.surface.getArgb(scheme), 4_279_374_365)
    XCTAssertEqual(MaterialDynamicColors.surfaceDim.getArgb(scheme), 4_279_374_365)
    XCTAssertEqual(MaterialDynamicColors.surfaceBright.getArgb(scheme), 4_281_874_500)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerLowest.getArgb(scheme), 4_279_045_400)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerLow.getArgb(scheme), 4_279_900_966)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainer.getArgb(scheme), 4_280_164_138)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerHigh.getArgb(scheme), 4_280_887_605)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerHighest.getArgb(scheme), 4_281_545_792)
    XCTAssertEqual(MaterialDynamicColors.onSurface.getArgb(scheme), 4_293_190_386)
    XCTAssertEqual(MaterialDynamicColors.onSurfaceVariant.getArgb(scheme), 4_292_861_685)
    XCTAssertEqual(MaterialDynamicColors.surfaceVariant.getArgb(scheme), 4_282_729_816)
    XCTAssertEqual(MaterialDynamicColors.inverseSurface.getArgb(scheme), 4_293_124_593)
    XCTAssertEqual(MaterialDynamicColors.inverseOnSurface.getArgb(scheme), 4_281_216_826)
    XCTAssertEqual(MaterialDynamicColors.outline.getArgb(scheme), 4_291_480_031)
    XCTAssertEqual(MaterialDynamicColors.outlineVariant.getArgb(scheme), 4_291_480_031)
    XCTAssertEqual(MaterialDynamicColors.shadow.getArgb(scheme), 4_278_190_080)
    XCTAssertEqual(MaterialDynamicColors.scrim.getArgb(scheme), 4_278_190_080)
    XCTAssertEqual(MaterialDynamicColors.surfaceTint.getArgb(scheme), 4_290_691_839)
    XCTAssertEqual(MaterialDynamicColors.primary.getArgb(scheme), 4_294_374_655)
    XCTAssertEqual(MaterialDynamicColors.onPrimary.getArgb(scheme), 4_279_968_255)
    XCTAssertEqual(MaterialDynamicColors.primaryContainer.getArgb(scheme), 4_291_086_079)
    XCTAssertEqual(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme), 4_278_190_534)
    XCTAssertEqual(MaterialDynamicColors.inversePrimary.getArgb(scheme), 4_278_190_323)
    XCTAssertEqual(MaterialDynamicColors.secondary.getArgb(scheme), 4_294_374_655)
    XCTAssertEqual(MaterialDynamicColors.onSecondary.getArgb(scheme), 4_282_402_732)
    XCTAssertEqual(MaterialDynamicColors.secondaryContainer.getArgb(scheme), 4_291_086_079)
    XCTAssertEqual(MaterialDynamicColors.onSecondaryContainer.getArgb(scheme), 4_280_560_273)
    XCTAssertEqual(MaterialDynamicColors.tertiary.getArgb(scheme), 4_294_963_708)
    XCTAssertEqual(MaterialDynamicColors.onTertiary.getArgb(scheme), 4_287_173_543)
    XCTAssertEqual(MaterialDynamicColors.tertiaryContainer.getArgb(scheme), 4_294_292_735)
    XCTAssertEqual(MaterialDynamicColors.onTertiaryContainer.getArgb(scheme), 4_284_678_267)
    XCTAssertEqual(MaterialDynamicColors.error.getArgb(scheme), 4_294_963_953)
    XCTAssertEqual(MaterialDynamicColors.onError.getArgb(scheme), 4_289_201_936)
    XCTAssertEqual(MaterialDynamicColors.errorContainer.getArgb(scheme), 4_294_949_553)
    XCTAssertEqual(MaterialDynamicColors.onErrorContainer.getArgb(scheme), 4_286_119_942)
    XCTAssertEqual(MaterialDynamicColors.primaryFixed.getArgb(scheme), 4_293_059_071)
    XCTAssertEqual(MaterialDynamicColors.primaryFixedDim.getArgb(scheme), 4_291_086_079)
    XCTAssertEqual(MaterialDynamicColors.onPrimaryFixed.getArgb(scheme), 4_278_190_534)
    XCTAssertEqual(MaterialDynamicColors.onPrimaryFixedVariant.getArgb(scheme), 4_278_190_534)
    XCTAssertEqual(MaterialDynamicColors.secondaryFixed.getArgb(scheme), 4_293_059_071)
    XCTAssertEqual(MaterialDynamicColors.secondaryFixedDim.getArgb(scheme), 4_291_086_079)
    XCTAssertEqual(MaterialDynamicColors.onSecondaryFixed.getArgb(scheme), 4_280_560_273)
    XCTAssertEqual(MaterialDynamicColors.onSecondaryFixedVariant.getArgb(scheme), 4_280_560_273)
    XCTAssertEqual(MaterialDynamicColors.tertiaryFixed.getArgb(scheme), 4_294_826_239)
    XCTAssertEqual(MaterialDynamicColors.tertiaryFixedDim.getArgb(scheme), 4_294_292_735)
    XCTAssertEqual(MaterialDynamicColors.onTertiaryFixed.getArgb(scheme), 4_284_678_267)
    XCTAssertEqual(MaterialDynamicColors.onTertiaryFixedVariant.getArgb(scheme), 4_284_678_267)
  }

  func testLightThemeMinContrastObjectionabeTertiaryContainerLightens() {
    let scheme = SchemeContent(
      sourceColorHct: Hct.fromInt(0xFF85_0096),
      isDark: false,
      contrastLevel: -1
    )

    let color = MaterialDynamicColors.tertiaryContainer.getArgb(scheme)

    XCTAssertEqual(color, 0xFFD0_3A71)
  }

  func testLightThemeStandardContrastObjectionabeTertiaryContainerLightens() {
    let scheme = SchemeContent(
      sourceColorHct: Hct.fromInt(0xFF85_0096),
      isDark: false,
      contrastLevel: 0
    )

    XCTAssertEqual(MaterialDynamicColors.tertiaryContainer.getArgb(scheme), 0xFFAC_1B57)
  }

  func testLightThemeMaxContrastObjectionabeTertiaryContainerDarkens() {
    let scheme = SchemeContent(
      sourceColorHct: Hct.fromInt(0xFF85_0096),
      isDark: false,
      contrastLevel: 1
    )

    XCTAssertEqual(MaterialDynamicColors.tertiaryContainer.getArgb(scheme), 0xFF87_0040)
  }
}
