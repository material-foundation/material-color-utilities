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

final class DislikeAnalyzerTests: XCTestCase {
  func testMonkSkinToneScaleColors() {
    // From https://skintone.google#/get-started
    let monkSkinToneScaleColors = [
      0xfff6_ede4,
      0xfff3_e7db,
      0xfff7_ead0,
      0xffea_daba,
      0xffd7_bd96,
      0xffa0_7e56,
      0xff82_5c43,
      0xff60_4134,
      0xff3a_312a,
      0xff29_2420,
    ]
    for color in monkSkinToneScaleColors {
      XCTAssertFalse(DislikeAnalyzer.isDisliked(Hct.fromInt(color)))
    }
  }

  func testBileColorsDisliked() {
    let unlikable = [
      0xff95_884B,
      0xff71_6B40,
      0xffB0_8E00,
      0xff4C_4308,
      0xff46_4521,
    ]
    for color in unlikable {
      XCTAssertTrue(DislikeAnalyzer.isDisliked(Hct.fromInt(color)))
    }
  }

  func testBileColorsBecameLikable() {
    let unlikable = [
      0xff95_884B,
      0xff71_6B40,
      0xffB0_8E00,
      0xff4C_4308,
      0xff46_4521,
    ]
    for color in unlikable {
      let hct = Hct.fromInt(color)

      XCTAssertTrue(DislikeAnalyzer.isDisliked(hct))

      let likable = DislikeAnalyzer.fixIfDisliked(hct)

      XCTAssertFalse(DislikeAnalyzer.isDisliked(likable))
    }
  }

  func testTone67NotDisliked() {
    let color = Hct.from(100, 50, 67)

    XCTAssertFalse(DislikeAnalyzer.isDisliked(color))
    XCTAssertEqual(DislikeAnalyzer.fixIfDisliked(color).toInt(), color.toInt())
  }
}
