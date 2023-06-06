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
      sourceColorHct: Hct.fromInt(0xFF_ff00_00ff),
      isDark: false,
      contrastLevel: -1.0
    )

    XCTAssertEqual(MaterialDynamicColors.background.getArgb(scheme), 4_294_572_537)
    XCTAssertEqual(MaterialDynamicColors.onBackground.getArgb(scheme), 4_285_690_482)
    XCTAssertEqual(MaterialDynamicColors.surface.getArgb(scheme), 4_294_572_537)
    XCTAssertEqual(MaterialDynamicColors.surfaceDim.getArgb(scheme), 4_292_532_954)
    XCTAssertEqual(MaterialDynamicColors.surfaceBright.getArgb(scheme), 4_294_572_537)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerLowest.getArgb(scheme), 4_294_967_295)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerLow.getArgb(scheme), 4_294_177_779)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainer.getArgb(scheme), 4_293_848_814)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerHigh.getArgb(scheme), 4_293_454_056)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerHighest.getArgb(scheme), 4_293_059_298)
    XCTAssertEqual(MaterialDynamicColors.onSurface.getArgb(scheme), 4_284_440_415)
    XCTAssertEqual(MaterialDynamicColors.onSurfaceVariant.getArgb(scheme), 4_284_769_380)
    XCTAssertEqual(MaterialDynamicColors.surfaceVariant.getArgb(scheme), 4_293_059_298)
    XCTAssertEqual(MaterialDynamicColors.inverseSurface.getArgb(scheme), 4_281_348_144)
    XCTAssertEqual(MaterialDynamicColors.inverseOnSurface.getArgb(scheme), 4_288_190_616)
    XCTAssertEqual(MaterialDynamicColors.outline.getArgb(scheme), 4_285_822_068)
    XCTAssertEqual(MaterialDynamicColors.outlineVariant.getArgb(scheme), 4_291_217_094)
    XCTAssertEqual(MaterialDynamicColors.shadow.getArgb(scheme), 4_278_190_080)
    XCTAssertEqual(MaterialDynamicColors.scrim.getArgb(scheme), 4_278_190_080)
    XCTAssertEqual(MaterialDynamicColors.surfaceTint.getArgb(scheme), 4_284_374_622)
    XCTAssertEqual(MaterialDynamicColors.primary.getArgb(scheme), 4_282_137_660)
    XCTAssertEqual(MaterialDynamicColors.onPrimary.getArgb(scheme), 4_289_111_718)
    XCTAssertEqual(MaterialDynamicColors.primaryContainer.getArgb(scheme), 4_284_440_415)
    XCTAssertEqual(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme), 4_292_467_161)
    XCTAssertEqual(MaterialDynamicColors.inversePrimary.getArgb(scheme), 4_288_190_616)
    XCTAssertEqual(MaterialDynamicColors.secondary.getArgb(scheme), 4_285_822_068)
    XCTAssertEqual(MaterialDynamicColors.onSecondary.getArgb(scheme), 4_291_940_817)
    XCTAssertEqual(MaterialDynamicColors.secondaryContainer.getArgb(scheme), 4_292_138_196)
    XCTAssertEqual(MaterialDynamicColors.onSecondaryContainer.getArgb(scheme), 4_284_177_243)
    XCTAssertEqual(MaterialDynamicColors.tertiary.getArgb(scheme), 4_283_453_520)
    XCTAssertEqual(MaterialDynamicColors.onTertiary.getArgb(scheme), 4_290_953_922)
    XCTAssertEqual(MaterialDynamicColors.tertiaryContainer.getArgb(scheme), 4_285_822_068)
    XCTAssertEqual(MaterialDynamicColors.onTertiaryContainer.getArgb(scheme), 4_291_940_817)
    XCTAssertEqual(MaterialDynamicColors.error.getArgb(scheme), 4_292_490_286)
    XCTAssertEqual(MaterialDynamicColors.onError.getArgb(scheme), 4_294_951_611)
    XCTAssertEqual(MaterialDynamicColors.errorContainer.getArgb(scheme), 4_294_957_782)
    XCTAssertEqual(MaterialDynamicColors.onErrorContainer.getArgb(scheme), 4_290_978_336)
    XCTAssertEqual(MaterialDynamicColors.primaryFixed.getArgb(scheme), 4_284_440_415)
    XCTAssertEqual(MaterialDynamicColors.primaryFixedDim.getArgb(scheme), 4_284_440_415)
    XCTAssertEqual(MaterialDynamicColors.onPrimaryFixed.getArgb(scheme), 4_292_467_161)
    XCTAssertEqual(MaterialDynamicColors.onPrimaryFixedVariant.getArgb(scheme), 4_289_967_027)
    XCTAssertEqual(MaterialDynamicColors.secondaryFixed.getArgb(scheme), 4_291_217_094)
    XCTAssertEqual(MaterialDynamicColors.secondaryFixedDim.getArgb(scheme), 4_289_440_683)
    XCTAssertEqual(MaterialDynamicColors.onSecondaryFixed.getArgb(scheme), 4_282_335_039)
    XCTAssertEqual(MaterialDynamicColors.onSecondaryFixedVariant.getArgb(scheme), 4_284_045_657)
    XCTAssertEqual(MaterialDynamicColors.tertiaryFixed.getArgb(scheme), 4_285_822_068)
    XCTAssertEqual(MaterialDynamicColors.tertiaryFixedDim.getArgb(scheme), 4_285_822_068)
    XCTAssertEqual(MaterialDynamicColors.onTertiaryFixed.getArgb(scheme), 4_294_769_916)
    XCTAssertEqual(MaterialDynamicColors.onTertiaryFixedVariant.getArgb(scheme), 4_291_940_817)
  }

  func testLightSchemeMonochromeStandardContrast() {
    let scheme = SchemeMonochrome(
      sourceColorHct: Hct.fromInt(0xFF_ff00_00ff),
      isDark: false,
      contrastLevel: 0.0
    )

    XCTAssertEqual(MaterialDynamicColors.background.getArgb(scheme), 4_294_572_537)
    XCTAssertEqual(MaterialDynamicColors.onBackground.getArgb(scheme), 4_279_966_491)
    XCTAssertEqual(MaterialDynamicColors.surface.getArgb(scheme), 4_294_572_537)
    XCTAssertEqual(MaterialDynamicColors.surfaceDim.getArgb(scheme), 4_292_532_954)
    XCTAssertEqual(MaterialDynamicColors.surfaceBright.getArgb(scheme), 4_294_572_537)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerLowest.getArgb(scheme), 4_294_967_295)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerLow.getArgb(scheme), 4_294_177_779)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainer.getArgb(scheme), 4_293_848_814)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerHigh.getArgb(scheme), 4_293_454_056)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerHighest.getArgb(scheme), 4_293_059_298)
    XCTAssertEqual(MaterialDynamicColors.onSurface.getArgb(scheme), 4_279_966_491)
    XCTAssertEqual(MaterialDynamicColors.onSurfaceVariant.getArgb(scheme), 4_282_861_383)
    XCTAssertEqual(MaterialDynamicColors.surfaceVariant.getArgb(scheme), 4_293_059_298)
    XCTAssertEqual(MaterialDynamicColors.inverseSurface.getArgb(scheme), 4_281_348_144)
    XCTAssertEqual(MaterialDynamicColors.inverseOnSurface.getArgb(scheme), 4_294_046_193)
    XCTAssertEqual(MaterialDynamicColors.outline.getArgb(scheme), 4_285_822_068)
    XCTAssertEqual(MaterialDynamicColors.outlineVariant.getArgb(scheme), 4_291_217_094)
    XCTAssertEqual(MaterialDynamicColors.shadow.getArgb(scheme), 4_278_190_080)
    XCTAssertEqual(MaterialDynamicColors.scrim.getArgb(scheme), 4_278_190_080)
    XCTAssertEqual(MaterialDynamicColors.surfaceTint.getArgb(scheme), 4_284_374_622)
    XCTAssertEqual(MaterialDynamicColors.primary.getArgb(scheme), 4_278_190_080)
    XCTAssertEqual(MaterialDynamicColors.onPrimary.getArgb(scheme), 4_293_059_298)
    XCTAssertEqual(MaterialDynamicColors.primaryContainer.getArgb(scheme), 4_282_071_867)
    XCTAssertEqual(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme), 4_294_967_295)
    XCTAssertEqual(MaterialDynamicColors.inversePrimary.getArgb(scheme), 4_291_217_094)
    XCTAssertEqual(MaterialDynamicColors.secondary.getArgb(scheme), 4_284_374_622)
    XCTAssertEqual(MaterialDynamicColors.onSecondary.getArgb(scheme), 4_294_967_295)
    XCTAssertEqual(MaterialDynamicColors.secondaryContainer.getArgb(scheme), 4_292_138_196)
    XCTAssertEqual(MaterialDynamicColors.onSecondaryContainer.getArgb(scheme), 4_279_966_491)
    XCTAssertEqual(MaterialDynamicColors.tertiary.getArgb(scheme), 4_282_071_867)
    XCTAssertEqual(MaterialDynamicColors.onTertiary.getArgb(scheme), 4_293_059_298)
    XCTAssertEqual(MaterialDynamicColors.tertiaryContainer.getArgb(scheme), 4_285_822_068)
    XCTAssertEqual(MaterialDynamicColors.onTertiaryContainer.getArgb(scheme), 4_294_967_295)
    XCTAssertEqual(MaterialDynamicColors.error.getArgb(scheme), 4_290_386_458)
    XCTAssertEqual(MaterialDynamicColors.onError.getArgb(scheme), 4_294_967_295)
    XCTAssertEqual(MaterialDynamicColors.errorContainer.getArgb(scheme), 4_294_957_782)
    XCTAssertEqual(MaterialDynamicColors.onErrorContainer.getArgb(scheme), 4_282_449_922)
    XCTAssertEqual(MaterialDynamicColors.primaryFixed.getArgb(scheme), 4_279_966_491)
    XCTAssertEqual(MaterialDynamicColors.primaryFixedDim.getArgb(scheme), 4_281_348_144)
    XCTAssertEqual(MaterialDynamicColors.onPrimaryFixed.getArgb(scheme), 4_293_059_298)
    XCTAssertEqual(MaterialDynamicColors.onPrimaryFixedVariant.getArgb(scheme), 4_289_440_683)
    XCTAssertEqual(MaterialDynamicColors.secondaryFixed.getArgb(scheme), 4_291_217_094)
    XCTAssertEqual(MaterialDynamicColors.secondaryFixedDim.getArgb(scheme), 4_289_440_683)
    XCTAssertEqual(MaterialDynamicColors.onSecondaryFixed.getArgb(scheme), 4_279_966_491)
    XCTAssertEqual(MaterialDynamicColors.onSecondaryFixedVariant.getArgb(scheme), 4_282_071_867)
    XCTAssertEqual(MaterialDynamicColors.tertiaryFixed.getArgb(scheme), 4_284_374_622)
    XCTAssertEqual(MaterialDynamicColors.tertiaryFixedDim.getArgb(scheme), 4_282_861_383)
    XCTAssertEqual(MaterialDynamicColors.onTertiaryFixed.getArgb(scheme), 4_293_059_298)
    XCTAssertEqual(MaterialDynamicColors.onTertiaryFixedVariant.getArgb(scheme), 4_289_440_683)
  }

  func testLightSchemeMonochromeMaxContrast() {
    let scheme = SchemeMonochrome(
      sourceColorHct: Hct.fromInt(0xFF_ff00_00ff),
      isDark: false,
      contrastLevel: 1.0
    )

    XCTAssertEqual(MaterialDynamicColors.background.getArgb(scheme), 4_294_572_537)
    XCTAssertEqual(MaterialDynamicColors.onBackground.getArgb(scheme), 4_279_966_491)
    XCTAssertEqual(MaterialDynamicColors.surface.getArgb(scheme), 4_294_572_537)
    XCTAssertEqual(MaterialDynamicColors.surfaceDim.getArgb(scheme), 4_292_532_954)
    XCTAssertEqual(MaterialDynamicColors.surfaceBright.getArgb(scheme), 4_294_572_537)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerLowest.getArgb(scheme), 4_294_967_295)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerLow.getArgb(scheme), 4_294_177_779)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainer.getArgb(scheme), 4_293_848_814)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerHigh.getArgb(scheme), 4_293_454_056)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerHighest.getArgb(scheme), 4_293_059_298)
    XCTAssertEqual(MaterialDynamicColors.onSurface.getArgb(scheme), 4_279_966_491)
    XCTAssertEqual(MaterialDynamicColors.onSurfaceVariant.getArgb(scheme), 4_282_795_590)
    XCTAssertEqual(MaterialDynamicColors.surfaceVariant.getArgb(scheme), 4_293_059_298)
    XCTAssertEqual(MaterialDynamicColors.inverseSurface.getArgb(scheme), 4_281_348_144)
    XCTAssertEqual(MaterialDynamicColors.inverseOnSurface.getArgb(scheme), 4_294_111_986)
    XCTAssertEqual(MaterialDynamicColors.outline.getArgb(scheme), 4_282_598_211)
    XCTAssertEqual(MaterialDynamicColors.outlineVariant.getArgb(scheme), 4_282_598_211)
    XCTAssertEqual(MaterialDynamicColors.shadow.getArgb(scheme), 4_278_190_080)
    XCTAssertEqual(MaterialDynamicColors.scrim.getArgb(scheme), 4_278_190_080)
    XCTAssertEqual(MaterialDynamicColors.surfaceTint.getArgb(scheme), 4_284_374_622)
    XCTAssertEqual(MaterialDynamicColors.primary.getArgb(scheme), 4_278_190_080)
    XCTAssertEqual(MaterialDynamicColors.onPrimary.getArgb(scheme), 4_288_059_030)
    XCTAssertEqual(MaterialDynamicColors.primaryContainer.getArgb(scheme), 4_282_006_074)
    XCTAssertEqual(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme), 4_291_677_645)
    XCTAssertEqual(MaterialDynamicColors.inversePrimary.getArgb(scheme), 4_291_282_887)
    XCTAssertEqual(MaterialDynamicColors.secondary.getArgb(scheme), 4_280_427_042)
    XCTAssertEqual(MaterialDynamicColors.onSecondary.getArgb(scheme), 4_289_572_269)
    XCTAssertEqual(MaterialDynamicColors.secondaryContainer.getArgb(scheme), 4_282_598_211)
    XCTAssertEqual(MaterialDynamicColors.onSecondaryContainer.getArgb(scheme), 4_292_532_954)
    XCTAssertEqual(MaterialDynamicColors.tertiary.getArgb(scheme), 4_280_427_042)
    XCTAssertEqual(MaterialDynamicColors.onTertiary.getArgb(scheme), 4_289_572_269)
    XCTAssertEqual(MaterialDynamicColors.tertiaryContainer.getArgb(scheme), 4_282_598_211)
    XCTAssertEqual(MaterialDynamicColors.onTertiaryContainer.getArgb(scheme), 4_292_532_954)
    XCTAssertEqual(MaterialDynamicColors.error.getArgb(scheme), 4_283_301_890)
    XCTAssertEqual(MaterialDynamicColors.onError.getArgb(scheme), 4_294_937_984)
    XCTAssertEqual(MaterialDynamicColors.errorContainer.getArgb(scheme), 4_287_365_129)
    XCTAssertEqual(MaterialDynamicColors.onErrorContainer.getArgb(scheme), 4_294_954_696)
    XCTAssertEqual(MaterialDynamicColors.primaryFixed.getArgb(scheme), 4_279_966_491)
    XCTAssertEqual(MaterialDynamicColors.primaryFixedDim.getArgb(scheme), 4_281_282_351)
    XCTAssertEqual(MaterialDynamicColors.onPrimaryFixed.getArgb(scheme), 4_290_624_957)
    XCTAssertEqual(MaterialDynamicColors.onPrimaryFixedVariant.getArgb(scheme), 4_290_624_957)
    XCTAssertEqual(MaterialDynamicColors.secondaryFixed.getArgb(scheme), 4_282_598_211)
    XCTAssertEqual(MaterialDynamicColors.secondaryFixedDim.getArgb(scheme), 4_282_598_211)
    XCTAssertEqual(MaterialDynamicColors.onSecondaryFixed.getArgb(scheme), 4_292_532_954)
    XCTAssertEqual(MaterialDynamicColors.onSecondaryFixedVariant.getArgb(scheme), 4_292_532_954)
    XCTAssertEqual(MaterialDynamicColors.tertiaryFixed.getArgb(scheme), 4_282_598_211)
    XCTAssertEqual(MaterialDynamicColors.tertiaryFixedDim.getArgb(scheme), 4_282_598_211)
    XCTAssertEqual(MaterialDynamicColors.onTertiaryFixed.getArgb(scheme), 4_292_532_954)
    XCTAssertEqual(MaterialDynamicColors.onTertiaryFixedVariant.getArgb(scheme), 4_292_532_954)
  }

  func testDarkSchemeMonochromeMinContrast() {
    let scheme = SchemeMonochrome(
      sourceColorHct: Hct.fromInt(0xFF_ff00_00ff),
      isDark: true,
      contrastLevel: -1.0
    )

    XCTAssertEqual(MaterialDynamicColors.background.getArgb(scheme), 4_279_440_147)
    XCTAssertEqual(MaterialDynamicColors.onBackground.getArgb(scheme), 4_285_822_068)
    XCTAssertEqual(MaterialDynamicColors.surface.getArgb(scheme), 4_279_440_147)
    XCTAssertEqual(MaterialDynamicColors.surfaceDim.getArgb(scheme), 4_279_440_147)
    XCTAssertEqual(MaterialDynamicColors.surfaceBright.getArgb(scheme), 4_281_940_281)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerLowest.getArgb(scheme), 4_279_111_182)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerLow.getArgb(scheme), 4_279_966_491)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainer.getArgb(scheme), 4_280_229_663)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerHigh.getArgb(scheme), 4_280_953_386)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerHighest.getArgb(scheme), 4_281_677_109)
    XCTAssertEqual(MaterialDynamicColors.onSurface.getArgb(scheme), 4_288_914_339)
    XCTAssertEqual(MaterialDynamicColors.onSurfaceVariant.getArgb(scheme), 4_287_861_651)
    XCTAssertEqual(MaterialDynamicColors.surfaceVariant.getArgb(scheme), 4_282_861_383)
    XCTAssertEqual(MaterialDynamicColors.inverseSurface.getArgb(scheme), 4_293_059_298)
    XCTAssertEqual(MaterialDynamicColors.inverseOnSurface.getArgb(scheme), 4_284_769_380)
    XCTAssertEqual(MaterialDynamicColors.outline.getArgb(scheme), 4_285_822_068)
    XCTAssertEqual(MaterialDynamicColors.outlineVariant.getArgb(scheme), 4_282_861_383)
    XCTAssertEqual(MaterialDynamicColors.shadow.getArgb(scheme), 4_278_190_080)
    XCTAssertEqual(MaterialDynamicColors.scrim.getArgb(scheme), 4_278_190_080)
    XCTAssertEqual(MaterialDynamicColors.surfaceTint.getArgb(scheme), 4_291_217_094)
    XCTAssertEqual(MaterialDynamicColors.primary.getArgb(scheme), 4_291_611_852)
    XCTAssertEqual(MaterialDynamicColors.onPrimary.getArgb(scheme), 4_283_848_278)
    XCTAssertEqual(MaterialDynamicColors.primaryContainer.getArgb(scheme), 4_288_914_339)
    XCTAssertEqual(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme), 4_281_940_281)
    XCTAssertEqual(MaterialDynamicColors.inversePrimary.getArgb(scheme), 4_285_822_068)
    XCTAssertEqual(MaterialDynamicColors.secondary.getArgb(scheme), 4_285_822_068)
    XCTAssertEqual(MaterialDynamicColors.onSecondary.getArgb(scheme), 4_294_769_916)
    XCTAssertEqual(MaterialDynamicColors.secondaryContainer.getArgb(scheme), 4_282_861_383)
    XCTAssertEqual(MaterialDynamicColors.onSecondaryContainer.getArgb(scheme), 4_290_098_613)
    XCTAssertEqual(MaterialDynamicColors.tertiary.getArgb(scheme), 4_288_914_339)
    XCTAssertEqual(MaterialDynamicColors.onTertiary.getArgb(scheme), 4_281_940_281)
    XCTAssertEqual(MaterialDynamicColors.tertiaryContainer.getArgb(scheme), 4_285_822_068)
    XCTAssertEqual(MaterialDynamicColors.onTertiaryContainer.getArgb(scheme), 4_291_940_817)
    XCTAssertEqual(MaterialDynamicColors.error.getArgb(scheme), 4_292_490_286)
    XCTAssertEqual(MaterialDynamicColors.onError.getArgb(scheme), 4_294_966_271)
    XCTAssertEqual(MaterialDynamicColors.errorContainer.getArgb(scheme), 4_287_823_882)
    XCTAssertEqual(MaterialDynamicColors.onErrorContainer.getArgb(scheme), 4_294_941_326)
    XCTAssertEqual(MaterialDynamicColors.primaryFixed.getArgb(scheme), 4_288_914_339)
    XCTAssertEqual(MaterialDynamicColors.primaryFixedDim.getArgb(scheme), 4_288_914_339)
    XCTAssertEqual(MaterialDynamicColors.onPrimaryFixed.getArgb(scheme), 4_281_940_281)
    XCTAssertEqual(MaterialDynamicColors.onPrimaryFixedVariant.getArgb(scheme), 4_281_940_281)
    XCTAssertEqual(MaterialDynamicColors.secondaryFixed.getArgb(scheme), 4_285_822_068)
    XCTAssertEqual(MaterialDynamicColors.secondaryFixedDim.getArgb(scheme), 4_285_822_068)
    XCTAssertEqual(MaterialDynamicColors.onSecondaryFixed.getArgb(scheme), 4_294_769_916)
    XCTAssertEqual(MaterialDynamicColors.onSecondaryFixedVariant.getArgb(scheme), 4_291_940_817)
    XCTAssertEqual(MaterialDynamicColors.tertiaryFixed.getArgb(scheme), 4_284_374_622)
    XCTAssertEqual(MaterialDynamicColors.tertiaryFixedDim.getArgb(scheme), 4_282_861_383)
    XCTAssertEqual(MaterialDynamicColors.onTertiaryFixed.getArgb(scheme), 4_290_098_613)
    XCTAssertEqual(MaterialDynamicColors.onTertiaryFixedVariant.getArgb(scheme), 4_287_861_651)
  }

  func testDarkSchemeMonochromeStandardContrast() {
    let scheme = SchemeMonochrome(
      sourceColorHct: Hct.fromInt(0xFF_ff00_00ff),
      isDark: true,
      contrastLevel: 0.0
    )

    XCTAssertEqual(MaterialDynamicColors.background.getArgb(scheme), 4_279_440_147)
    XCTAssertEqual(MaterialDynamicColors.onBackground.getArgb(scheme), 4_293_059_298)
    XCTAssertEqual(MaterialDynamicColors.surface.getArgb(scheme), 4_279_440_147)
    XCTAssertEqual(MaterialDynamicColors.surfaceDim.getArgb(scheme), 4_279_440_147)
    XCTAssertEqual(MaterialDynamicColors.surfaceBright.getArgb(scheme), 4_281_940_281)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerLowest.getArgb(scheme), 4_279_111_182)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerLow.getArgb(scheme), 4_279_966_491)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainer.getArgb(scheme), 4_280_229_663)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerHigh.getArgb(scheme), 4_280_953_386)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerHighest.getArgb(scheme), 4_281_677_109)
    XCTAssertEqual(MaterialDynamicColors.onSurface.getArgb(scheme), 4_293_059_298)
    XCTAssertEqual(MaterialDynamicColors.onSurfaceVariant.getArgb(scheme), 4_291_217_094)
    XCTAssertEqual(MaterialDynamicColors.surfaceVariant.getArgb(scheme), 4_282_861_383)
    XCTAssertEqual(MaterialDynamicColors.inverseSurface.getArgb(scheme), 4_293_059_298)
    XCTAssertEqual(MaterialDynamicColors.inverseOnSurface.getArgb(scheme), 4_281_348_144)
    XCTAssertEqual(MaterialDynamicColors.outline.getArgb(scheme), 4_285_822_068)
    XCTAssertEqual(MaterialDynamicColors.outlineVariant.getArgb(scheme), 4_282_861_383)
    XCTAssertEqual(MaterialDynamicColors.shadow.getArgb(scheme), 4_278_190_080)
    XCTAssertEqual(MaterialDynamicColors.scrim.getArgb(scheme), 4_278_190_080)
    XCTAssertEqual(MaterialDynamicColors.surfaceTint.getArgb(scheme), 4_291_217_094)
    XCTAssertEqual(MaterialDynamicColors.primary.getArgb(scheme), 4_294_967_295)
    XCTAssertEqual(MaterialDynamicColors.onPrimary.getArgb(scheme), 4_279_966_491)
    XCTAssertEqual(MaterialDynamicColors.primaryContainer.getArgb(scheme), 4_292_138_196)
    XCTAssertEqual(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme), 4_278_190_080)
    XCTAssertEqual(MaterialDynamicColors.inversePrimary.getArgb(scheme), 4_284_374_622)
    XCTAssertEqual(MaterialDynamicColors.secondary.getArgb(scheme), 4_291_217_094)
    XCTAssertEqual(MaterialDynamicColors.onSecondary.getArgb(scheme), 4_279_966_491)
    XCTAssertEqual(MaterialDynamicColors.secondaryContainer.getArgb(scheme), 4_282_861_383)
    XCTAssertEqual(MaterialDynamicColors.onSecondaryContainer.getArgb(scheme), 4_293_059_298)
    XCTAssertEqual(MaterialDynamicColors.tertiary.getArgb(scheme), 4_293_059_298)
    XCTAssertEqual(MaterialDynamicColors.onTertiary.getArgb(scheme), 4_279_966_491)
    XCTAssertEqual(MaterialDynamicColors.tertiaryContainer.getArgb(scheme), 4_285_822_068)
    XCTAssertEqual(MaterialDynamicColors.onTertiaryContainer.getArgb(scheme), 4_294_967_295)
    XCTAssertEqual(MaterialDynamicColors.error.getArgb(scheme), 4_294_948_011)
    XCTAssertEqual(MaterialDynamicColors.onError.getArgb(scheme), 4_285_071_365)
    XCTAssertEqual(MaterialDynamicColors.errorContainer.getArgb(scheme), 4_287_823_882)
    XCTAssertEqual(MaterialDynamicColors.onErrorContainer.getArgb(scheme), 4_294_957_782)
    XCTAssertEqual(MaterialDynamicColors.primaryFixed.getArgb(scheme), 4_294_967_295)
    XCTAssertEqual(MaterialDynamicColors.primaryFixedDim.getArgb(scheme), 4_293_059_298)
    XCTAssertEqual(MaterialDynamicColors.onPrimaryFixed.getArgb(scheme), 4_279_966_491)
    XCTAssertEqual(MaterialDynamicColors.onPrimaryFixedVariant.getArgb(scheme), 4_282_861_383)
    XCTAssertEqual(MaterialDynamicColors.secondaryFixed.getArgb(scheme), 4_291_217_094)
    XCTAssertEqual(MaterialDynamicColors.secondaryFixedDim.getArgb(scheme), 4_289_440_683)
    XCTAssertEqual(MaterialDynamicColors.onSecondaryFixed.getArgb(scheme), 4_279_966_491)
    XCTAssertEqual(MaterialDynamicColors.onSecondaryFixedVariant.getArgb(scheme), 4_282_071_867)
    XCTAssertEqual(MaterialDynamicColors.tertiaryFixed.getArgb(scheme), 4_284_374_622)
    XCTAssertEqual(MaterialDynamicColors.tertiaryFixedDim.getArgb(scheme), 4_282_861_383)
    XCTAssertEqual(MaterialDynamicColors.onTertiaryFixed.getArgb(scheme), 4_293_059_298)
    XCTAssertEqual(MaterialDynamicColors.onTertiaryFixedVariant.getArgb(scheme), 4_289_440_683)
  }

  func testDarkSchemeMonochromeMaxContrast() {
    let scheme = SchemeMonochrome(
      sourceColorHct: Hct.fromInt(0xFF_ff00_00ff),
      isDark: true,
      contrastLevel: 1.0
    )

    XCTAssertEqual(MaterialDynamicColors.background.getArgb(scheme), 4_279_440_147)
    XCTAssertEqual(MaterialDynamicColors.onBackground.getArgb(scheme), 4_293_125_091)
    XCTAssertEqual(MaterialDynamicColors.surface.getArgb(scheme), 4_279_440_147)
    XCTAssertEqual(MaterialDynamicColors.surfaceDim.getArgb(scheme), 4_279_440_147)
    XCTAssertEqual(MaterialDynamicColors.surfaceBright.getArgb(scheme), 4_281_940_281)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerLowest.getArgb(scheme), 4_279_111_182)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerLow.getArgb(scheme), 4_279_966_491)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainer.getArgb(scheme), 4_280_229_663)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerHigh.getArgb(scheme), 4_280_953_386)
    XCTAssertEqual(MaterialDynamicColors.surfaceContainerHighest.getArgb(scheme), 4_281_677_109)
    XCTAssertEqual(MaterialDynamicColors.onSurface.getArgb(scheme), 4_293_125_091)
    XCTAssertEqual(MaterialDynamicColors.onSurfaceVariant.getArgb(scheme), 4_292_927_712)
    XCTAssertEqual(MaterialDynamicColors.surfaceVariant.getArgb(scheme), 4_282_861_383)
    XCTAssertEqual(MaterialDynamicColors.inverseSurface.getArgb(scheme), 4_293_059_298)
    XCTAssertEqual(MaterialDynamicColors.inverseOnSurface.getArgb(scheme), 4_281_282_351)
    XCTAssertEqual(MaterialDynamicColors.outline.getArgb(scheme), 4_291_546_059)
    XCTAssertEqual(MaterialDynamicColors.outlineVariant.getArgb(scheme), 4_291_546_059)
    XCTAssertEqual(MaterialDynamicColors.shadow.getArgb(scheme), 4_278_190_080)
    XCTAssertEqual(MaterialDynamicColors.scrim.getArgb(scheme), 4_278_190_080)
    XCTAssertEqual(MaterialDynamicColors.surfaceTint.getArgb(scheme), 4_291_217_094)
    XCTAssertEqual(MaterialDynamicColors.primary.getArgb(scheme), 4_294_967_295)
    XCTAssertEqual(MaterialDynamicColors.onPrimary.getArgb(scheme), 4_283_979_864)
    XCTAssertEqual(MaterialDynamicColors.primaryContainer.getArgb(scheme), 4_292_203_989)
    XCTAssertEqual(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme), 4_282_400_832)
    XCTAssertEqual(MaterialDynamicColors.inversePrimary.getArgb(scheme), 4_282_927_176)
    XCTAssertEqual(MaterialDynamicColors.secondary.getArgb(scheme), 4_294_309_365)
    XCTAssertEqual(MaterialDynamicColors.onSecondary.getArgb(scheme), 4_283_650_899)
    XCTAssertEqual(MaterialDynamicColors.secondaryContainer.getArgb(scheme), 4_291_546_059)
    XCTAssertEqual(MaterialDynamicColors.onSecondaryContainer.getArgb(scheme), 4_281_940_281)
    XCTAssertEqual(MaterialDynamicColors.tertiary.getArgb(scheme), 4_294_309_365)
    XCTAssertEqual(MaterialDynamicColors.onTertiary.getArgb(scheme), 4_283_650_899)
    XCTAssertEqual(MaterialDynamicColors.tertiaryContainer.getArgb(scheme), 4_291_546_059)
    XCTAssertEqual(MaterialDynamicColors.onTertiaryContainer.getArgb(scheme), 4_281_940_281)
    XCTAssertEqual(MaterialDynamicColors.error.getArgb(scheme), 4_294_963_953)
    XCTAssertEqual(MaterialDynamicColors.onError.getArgb(scheme), 4_289_201_936)
    XCTAssertEqual(MaterialDynamicColors.errorContainer.getArgb(scheme), 4_294_949_553)
    XCTAssertEqual(MaterialDynamicColors.onErrorContainer.getArgb(scheme), 4_286_119_942)
    XCTAssertEqual(MaterialDynamicColors.primaryFixed.getArgb(scheme), 4_294_967_295)
    XCTAssertEqual(MaterialDynamicColors.primaryFixedDim.getArgb(scheme), 4_293_125_091)
    XCTAssertEqual(MaterialDynamicColors.onPrimaryFixed.getArgb(scheme), 4_282_927_176)
    XCTAssertEqual(MaterialDynamicColors.onPrimaryFixedVariant.getArgb(scheme), 4_282_927_176)
    XCTAssertEqual(MaterialDynamicColors.secondaryFixed.getArgb(scheme), 4_291_546_059)
    XCTAssertEqual(MaterialDynamicColors.secondaryFixedDim.getArgb(scheme), 4_291_546_059)
    XCTAssertEqual(MaterialDynamicColors.onSecondaryFixed.getArgb(scheme), 4_281_940_281)
    XCTAssertEqual(MaterialDynamicColors.onSecondaryFixedVariant.getArgb(scheme), 4_281_940_281)
    XCTAssertEqual(MaterialDynamicColors.tertiaryFixed.getArgb(scheme), 4_291_546_059)
    XCTAssertEqual(MaterialDynamicColors.tertiaryFixedDim.getArgb(scheme), 4_291_546_059)
    XCTAssertEqual(MaterialDynamicColors.onTertiaryFixed.getArgb(scheme), 4_281_940_281)
    XCTAssertEqual(MaterialDynamicColors.onTertiaryFixedVariant.getArgb(scheme), 4_281_940_281)
  }
}
