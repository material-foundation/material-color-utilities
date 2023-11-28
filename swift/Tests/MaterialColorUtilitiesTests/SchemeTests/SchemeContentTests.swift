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

    XCTAssertEqual(MaterialDynamicColors.tertiaryContainer.getArgb(scheme), 0xff98_0249)
  }

  func testLightThemeMaxContrastObjectionabeTertiaryContainerDarkens() {
    let scheme = SchemeContent(
      sourceColorHct: Hct.fromInt(0xff85_0096),
      isDark: false,
      contrastLevel: 1
    )

    XCTAssertEqual(MaterialDynamicColors.tertiaryContainer.getArgb(scheme), 0xff93_0046)
  }
}
