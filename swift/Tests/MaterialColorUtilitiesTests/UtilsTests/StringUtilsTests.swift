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

final class StringUtilsTests: XCTestCase {
  func testHexFromArgb() {
    let result0 = StringUtils.hexFromArgb(914_181_854)
    let result1 = StringUtils.hexFromArgb(1_941_786_595)
    let result2 = StringUtils.hexFromArgb(4_002_780_905)
    let result3 = StringUtils.hexFromArgb(2_734_560_664)
    let result4 = StringUtils.hexFromArgb(3_291_681_504)
    let result5 = StringUtils.hexFromArgb(607_316_496)
    let result6 = StringUtils.hexFromArgb(2_460_285_668)
    let result7 = StringUtils.hexFromArgb(3_285_071_752)
    let result8 = StringUtils.hexFromArgb(3_940_857_847)
    let result9 = StringUtils.hexFromArgb(1_802_349_691)

    XCTAssertEqual(result0, "#7D4EDE")
    XCTAssertEqual(result1, "#BD4FE3")
    XCTAssertEqual(result2, "#9596E9")
    XCTAssertEqual(result3, "#FE1598")
    XCTAssertEqual(result4, "#3312E0")
    XCTAssertEqual(result5, "#32EA10")
    XCTAssertEqual(result6, "#A4FAE4")
    XCTAssertEqual(result7, "#CE3788")
    XCTAssertEqual(result8, "#E4B7F7")
    XCTAssertEqual(result9, "#6DAC7B")
  }

  func testArgbFromHex() {
    let result0 = StringUtils.argbFromHex("#7D4EDE")
    let result1 = StringUtils.argbFromHex("#BD4FE3")
    let result2 = StringUtils.argbFromHex("#9596E9")
    let result3 = StringUtils.argbFromHex("#FE1598")
    let result4 = StringUtils.argbFromHex("#3312E0")
    let result5 = StringUtils.argbFromHex("#32EA10")
    let result6 = StringUtils.argbFromHex("#A4FAE4")
    let result7 = StringUtils.argbFromHex("#CE3788")
    let result8 = StringUtils.argbFromHex("#E4B7F7")
    let result9 = StringUtils.argbFromHex("#6DAC7B")

    XCTAssertEqual(result0, 8_212_190)
    XCTAssertEqual(result1, 12_406_755)
    XCTAssertEqual(result2, 9_803_497)
    XCTAssertEqual(result3, 16_651_672)
    XCTAssertEqual(result4, 3_347_168)
    XCTAssertEqual(result5, 3_336_720)
    XCTAssertEqual(result6, 10_812_132)
    XCTAssertEqual(result7, 13_514_632)
    XCTAssertEqual(result8, 14_989_303)
    XCTAssertEqual(result9, 7_187_579)
  }

  func testHexFroundTrip() {
    let result0 = "#7D4EDE"
    let result1 = "#BD4FE3"
    let result2 = "#9596E9"
    let result3 = "#FE1598"
    let result4 = "#3312E0"
    let result5 = "#32EA10"
    let result6 = "#A4FAE4"
    let result7 = "#CE3788"
    let result8 = "#E4B7F7"
    let result9 = "#6DAC7B"

    XCTAssertEqual(result0, StringUtils.hexFromArgb(StringUtils.argbFromHex(result0)!))
    XCTAssertEqual(result1, StringUtils.hexFromArgb(StringUtils.argbFromHex(result1)!))
    XCTAssertEqual(result2, StringUtils.hexFromArgb(StringUtils.argbFromHex(result2)!))
    XCTAssertEqual(result3, StringUtils.hexFromArgb(StringUtils.argbFromHex(result3)!))
    XCTAssertEqual(result4, StringUtils.hexFromArgb(StringUtils.argbFromHex(result4)!))
    XCTAssertEqual(result5, StringUtils.hexFromArgb(StringUtils.argbFromHex(result5)!))
    XCTAssertEqual(result6, StringUtils.hexFromArgb(StringUtils.argbFromHex(result6)!))
    XCTAssertEqual(result7, StringUtils.hexFromArgb(StringUtils.argbFromHex(result7)!))
    XCTAssertEqual(result8, StringUtils.hexFromArgb(StringUtils.argbFromHex(result8)!))
    XCTAssertEqual(result9, StringUtils.hexFromArgb(StringUtils.argbFromHex(result9)!))
  }
}
