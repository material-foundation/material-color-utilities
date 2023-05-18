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

import XCTest

@testable import MaterialColorUtilities

final class CorePalettesTests: XCTestCase {
  func testEqualsAndHash() {
    let corePaletteA = CorePalette.of(0xff00_00ff)
    let corePaletteB = CorePalette.of(0xff00_00ff)
    let corePaletteC = CorePalette.of(0xff12_3456)

    XCTAssertEqual(corePaletteA, corePaletteB)
    XCTAssertTrue(corePaletteB != corePaletteC)

    XCTAssertEqual(corePaletteA.hashValue, corePaletteB.hashValue)
    XCTAssertTrue(corePaletteB.hashValue != corePaletteC.hashValue)
  }

  func testOfBlue() {
    let core = CorePalette.of(0xff00_00ff)

    XCTAssertEqual(core.primary.tone(100), 0xffff_ffff)
    XCTAssertEqual(core.primary.tone(95), 0xfff1_efff)
    XCTAssertEqual(core.primary.tone(90), 0xffe0_e0ff)
    XCTAssertEqual(core.primary.tone(80), 0xffbe_c2ff)
    XCTAssertEqual(core.primary.tone(70), 0xff9d_a3ff)
    XCTAssertEqual(core.primary.tone(60), 0xff7c_84ff)
    XCTAssertEqual(core.primary.tone(50), 0xff5a_64ff)
    XCTAssertEqual(core.primary.tone(40), 0xff34_3dff)
    XCTAssertEqual(core.primary.tone(30), 0xff00_00ef)
    XCTAssertEqual(core.primary.tone(20), 0xff00_01ac)
    XCTAssertEqual(core.primary.tone(10), 0xff00_006e)
    XCTAssertEqual(core.primary.tone(0), 0xff00_0000)
    XCTAssertEqual(core.secondary.tone(100), 0xffff_ffff)
    XCTAssertEqual(core.secondary.tone(95), 0xfff1_efff)
    XCTAssertEqual(core.secondary.tone(90), 0xffe1_e0f9)
    XCTAssertEqual(core.secondary.tone(80), 0xffc5_c4dd)
    XCTAssertEqual(core.secondary.tone(70), 0xffa9_a9c1)
    XCTAssertEqual(core.secondary.tone(60), 0xff8f_8fa6)
    XCTAssertEqual(core.secondary.tone(50), 0xff75_758b)
    XCTAssertEqual(core.secondary.tone(40), 0xff5c_5d72)
    XCTAssertEqual(core.secondary.tone(30), 0xff44_4559)
    XCTAssertEqual(core.secondary.tone(20), 0xff2e_2f42)
    XCTAssertEqual(core.secondary.tone(10), 0xff19_1a2c)
    XCTAssertEqual(core.secondary.tone(0), 0xff00_0000)
  }

  func testContentOfBlue() {
    let core = CorePalette.contentOf(0xff00_00ff)

    XCTAssertEqual(core.primary.tone(100), 0xffff_ffff)
    XCTAssertEqual(core.primary.tone(95), 0xfff1_efff)
    XCTAssertEqual(core.primary.tone(90), 0xffe0_e0ff)
    XCTAssertEqual(core.primary.tone(80), 0xffbe_c2ff)
    XCTAssertEqual(core.primary.tone(70), 0xff9d_a3ff)
    XCTAssertEqual(core.primary.tone(60), 0xff7c_84ff)
    XCTAssertEqual(core.primary.tone(50), 0xff5a_64ff)
    XCTAssertEqual(core.primary.tone(40), 0xff34_3dff)
    XCTAssertEqual(core.primary.tone(30), 0xff00_00ef)
    XCTAssertEqual(core.primary.tone(20), 0xff00_01ac)
    XCTAssertEqual(core.primary.tone(10), 0xff00_006e)
    XCTAssertEqual(core.primary.tone(0), 0xff00_0000)
    XCTAssertEqual(core.secondary.tone(100), 0xffff_ffff)
    XCTAssertEqual(core.secondary.tone(95), 0xfff1_efff)
    XCTAssertEqual(core.secondary.tone(90), 0xffe0_e0ff)
    XCTAssertEqual(core.secondary.tone(80), 0xffc1_c3f4)
    XCTAssertEqual(core.secondary.tone(70), 0xffa5_a7d7)
    XCTAssertEqual(core.secondary.tone(60), 0xff8b_8dbb)
    XCTAssertEqual(core.secondary.tone(50), 0xff71_73a0)
    XCTAssertEqual(core.secondary.tone(40), 0xff58_5b86)
    XCTAssertEqual(core.secondary.tone(30), 0xff40_436d)
    XCTAssertEqual(core.secondary.tone(20), 0xff2a_2d55)
    XCTAssertEqual(core.secondary.tone(10), 0xff14_173f)
    XCTAssertEqual(core.secondary.tone(0), 0xff00_0000)
  }
}

private func createList(_ size: Int, value: Int? = nil) -> [Int] {
  var results: [Int] = []
  for i in 0..<size {
    results.append(value ?? i)
  }
  return results
}
