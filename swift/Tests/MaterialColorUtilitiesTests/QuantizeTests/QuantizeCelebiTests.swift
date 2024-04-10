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

final class QuantizeCelibiTests: XCTestCase {
  let red = 0xffff_0000
  let green = 0xff00_ff00
  let blue = 0xff00_00ff
  let white = 0xffff_ffff
  let random = 0xff42_6088
  let maxColors = 256

  func test1Rando() {
    let wu = QuantizerCelebi()
    let result = wu.quantize([0xff14_1216], maxColors)
    let colors = [Int](result.colorToCount.keys)

    XCTAssertEqual(colors.count, 1)
    XCTAssertEqual(colors[0], 0xff14_1216)
  }

  func test1R() {
    let wu = QuantizerCelebi()
    let result = wu.quantize([red], maxColors)
    let colors = [Int](result.colorToCount.keys)

    XCTAssertEqual(colors.count, 1)
    XCTAssertEqual(colors[0], red)
  }

  func test1G() {
    let wu = QuantizerCelebi()
    let result = wu.quantize([green], maxColors)
    let colors = [Int](result.colorToCount.keys)

    XCTAssertEqual(colors.count, 1)
    XCTAssertEqual(colors[0], green)
  }

  func test1B() {
    let wu = QuantizerCelebi()
    let result = wu.quantize([blue], maxColors)
    let colors = [Int](result.colorToCount.keys)

    XCTAssertEqual(colors.count, 1)
    XCTAssertEqual(colors[0], blue)
  }

  func test5B() {
    let wu = QuantizerCelebi()
    let result = wu.quantize([blue, blue, blue, blue, blue], maxColors)
    let colors = [Int](result.colorToCount.keys)

    XCTAssertEqual(colors.count, 1)
    XCTAssertEqual(colors[0], blue)
  }

  func test2R3G() {
    let wu = QuantizerCelebi()
    let result = wu.quantize([red, red, green, green, green], maxColors)

    XCTAssertEqual(result.colorToCount.keys.count, 2)
    XCTAssertEqual(result.colorToCount[green], 3)
    XCTAssertEqual(result.colorToCount[red], 2)
  }

  func test1R1G1B() {
    let wu = QuantizerCelebi()
    let result = wu.quantize([red, green, blue], maxColors)

    XCTAssertEqual(result.colorToCount.keys.count, 3)
    XCTAssertEqual(result.colorToCount[green], 1)
    XCTAssertEqual(result.colorToCount[red], 1)
    XCTAssertEqual(result.colorToCount[blue], 1)
  }

  /// Verifies QuantizerCelebi().quantize returns identical result given same input.
  func testStability() {
    let imagePixels = [
      0xff05_0505, 0xff00_0000, 0xff00_0000, 0xff00_0000, 0xff00_0000, 0xff09_0909, 0xff06_0404,
      0xff03_0102, 0xff08_0607, 0xff07_0506, 0xff01_0001, 0xff07_0506, 0xff36_4341, 0xff22_3529,
      0xff14_251c, 0xff11_221a, 0xff1f_3020, 0xff34_443a, 0xff64_817e, 0xff63_8777, 0xff48_6d58,
      0xff2f_5536, 0xff46_7258, 0xff7f_b7b9, 0xff6d_8473, 0xff85_9488, 0xff7a_947e, 0xff5f_815d,
      0xff3a_5d46, 0xff49_7469, 0xff73_7a73, 0xff65_6453, 0xff44_5938, 0xff65_7c4b, 0xff65_715b,
      0xff6a_816e, 0xff66_7366, 0xff5b_5547, 0xff3b_391e, 0xff70_5e3d, 0xff7f_6c5e, 0xff6d_7c6c,
      0xffa9_9c9c, 0xff8b_7671, 0xff6a_3229, 0xff80_514b, 0xff85_7970, 0xff4f_5a4c, 0xff89_7273,
      0xff74_5451, 0xff51_2823, 0xff78_585a, 0xff53_5552, 0xff40_493f, 0xff15_1616, 0xff0a_0c0c,
      0xff05_0808, 0xff01_0303, 0xff00_0100, 0xff01_0200, 0xff19_1816, 0xff18_1818, 0xff0c_0c0c,
      0xff04_0404, 0xff0c_0c0c, 0xff15_1514, 0xffb1_c3b9, 0xffbf_bfbf, 0xffba_baba, 0xffb7_b7b7,
      0xffb3_b3b3, 0xffad_adad, 0xff53_5756, 0xff57_5656, 0xff55_5555, 0xff55_5555, 0xff54_5454,
      0xff47_4646, 0xff00_0000, 0xff00_0000, 0xff0b_0b0b, 0xff0b_0b0b, 0xff00_0000, 0xff00_0000,
    ]

    let count = 16

    let result1 = QuantizerCelebi().quantize(imagePixels, count).colorToCount
    let result2 = QuantizerCelebi().quantize(imagePixels, count).colorToCount

    XCTAssertEqual(result1, result2)
  }
}
