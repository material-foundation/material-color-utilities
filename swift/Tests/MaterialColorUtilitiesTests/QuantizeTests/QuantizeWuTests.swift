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

final class QuantizeWuTests: XCTestCase {
  let red = 0xffff_0000
  let green = 0xff00_ff00
  let blue = 0xff00_00ff
  let white = 0xffff_ffff
  let random = 0xff42_6088
  let maxColors = 256

  func test1Rando() {
    let wu = QuantizerWu()
    let result = wu.quantize([0xff14_1216], maxColors)
    let colors = [Int](result.colorToCount.keys)

    XCTAssertEqual(colors.count, 1)
    XCTAssertEqual(colors[0], 0xff14_1216)
  }

  func test1R() {
    let wu = QuantizerWu()
    let result = wu.quantize([red], maxColors)
    let colors = [Int](result.colorToCount.keys)

    XCTAssertEqual(colors.count, 1)
    XCTAssertEqual(colors[0], red)
  }

  func test1G() {
    let wu = QuantizerWu()
    let result = wu.quantize([green], maxColors)
    let colors = [Int](result.colorToCount.keys)

    XCTAssertEqual(colors.count, 1)
    XCTAssertEqual(colors[0], green)
  }

  func test1B() {
    let wu = QuantizerWu()
    let result = wu.quantize([blue], maxColors)
    let colors = [Int](result.colorToCount.keys)

    XCTAssertEqual(colors.count, 1)
    XCTAssertEqual(colors[0], blue)
  }

  func test5B() {
    let wu = QuantizerWu()
    let result = wu.quantize([blue, blue, blue, blue, blue], maxColors)
    let colors = [Int](result.colorToCount.keys)

    XCTAssertEqual(colors.count, 1)
    XCTAssertEqual(colors[0], blue)
  }

  func test2R3G() {
    let wu = QuantizerWu()
    let result = wu.quantize([red, red, green, green, green], maxColors)

    XCTAssertEqual(result.colorToCount.keys.count, 2)
    XCTAssertNotNil(result.colorToCount[green])
    XCTAssertNotNil(result.colorToCount[red])
  }

  func test1R1G1B() {
    let wu = QuantizerWu()
    let result = wu.quantize([red, green, blue], maxColors)

    XCTAssertEqual(result.colorToCount.keys.count, 3)
    XCTAssertNotNil(result.colorToCount[green])
    XCTAssertNotNil(result.colorToCount[red])
    XCTAssertNotNil(result.colorToCount[blue])
  }
}
