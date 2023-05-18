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

final class BlendTests: XCTestCase {
  let red = 0xffff_0000
  let blue = 0xff00_00ff
  let green = 0xff00_ff00
  let yellow = 0xffff_ff00

  func testRedToBlue() {
    let answer = Blend.harmonize(red, blue)

    XCTAssertEqual(answer, 0xffFB_0057)
  }

  func testRedToGreen() {
    let answer = Blend.harmonize(red, green)

    XCTAssertEqual(answer, 0xffD8_5600)
  }

  func testRedToYellow() {
    let answer = Blend.harmonize(red, yellow)

    XCTAssertEqual(answer, 0xffD8_5600)
  }

  func testBlueToRed() {
    let answer = Blend.harmonize(blue, red)

    XCTAssertEqual(answer, 0xff57_00DC)
  }

  func testBlueToYellow() {
    let answer = Blend.harmonize(blue, yellow)

    XCTAssertEqual(answer, 0xff00_47A3)
  }

  func testGreenToBlue() {
    let answer = Blend.harmonize(green, blue)

    XCTAssertEqual(answer, 0xff00_FC94)
  }

  func testGreenToRed() {
    let answer = Blend.harmonize(green, red)

    XCTAssertEqual(answer, 0xffB1_F000)
  }

  func testGreenToYellow() {
    let answer = Blend.harmonize(green, yellow)

    XCTAssertEqual(answer, 0xffB1_F000)
  }

  func testYellowToBlue() {
    let answer = Blend.harmonize(yellow, blue)

    XCTAssertEqual(answer, 0xffEB_FFBA)
  }

  func testYellowToGreen() {
    let answer = Blend.harmonize(yellow, green)

    XCTAssertEqual(answer, 0xffEB_FFBA)
  }

  func testYellowToRed() {
    let answer = Blend.harmonize(yellow, red)

    XCTAssertEqual(answer, 0xffFF_F6E3)
  }
}
