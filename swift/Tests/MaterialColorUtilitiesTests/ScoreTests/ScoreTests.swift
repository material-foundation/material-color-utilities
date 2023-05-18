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

final class ScoreTests: XCTestCase {
  func testPrioritizesChroma() {
    let colorsToPopulation: [Int: Int] = [
      0xff00_0000: 1,
      0xffff_ffff: 1,
      0xff00_00ff: 1,
    ]
    let ranked = Score.score(colorsToPopulation, desired: 4)

    XCTAssertEqual(ranked.count, 1)
    XCTAssertEqual(ranked[0], 0xff00_00ff)
  }

  func testPrioritizesChromaWhenProportionsEqual() {
    let colorsToPopulation: [Int: Int] = [
      0xffff_0000: 1,
      0xff00_ff00: 1,
      0xff00_00ff: 1,
    ]
    let ranked = Score.score(colorsToPopulation, desired: 4)

    XCTAssertEqual(ranked.count, 3)
    XCTAssertEqual(ranked[0], 0xffff_0000)
    XCTAssertEqual(ranked[1], 0xff00_ff00)
    XCTAssertEqual(ranked[2], 0xff00_00ff)
  }

  func testGeneratesGoogleBlueWhenNoColorsAvaliable() {
    let colorsToPopulation: [Int: Int] = [
      0xff00_0000: 1
    ]
    let ranked = Score.score(colorsToPopulation, desired: 4)

    XCTAssertEqual(ranked.count, 1)
    XCTAssertEqual(ranked[0], 0xff42_85F4)
  }

  func testDedupesNearbyHues() {
    let colorsToPopulation: [Int: Int] = [
      0xff00_8772: 1,  // H 180 C 42 T 50
      0xff31_8477: 1,  // H 184 C 35 T 50
    ]
    let ranked = Score.score(colorsToPopulation, desired: 4)

    XCTAssertEqual(ranked.count, 1)
    XCTAssertEqual(ranked[0], 0xff00_8772)
  }

  func testMaximizedHueDistance() {
    let colorsToPopulation: [Int: Int] = [
      0xff00_8772: 1,  // H 180 C 42 T 50
      0xff00_8587: 1,  // H 198 C 50 T 50
      0xff00_7ebc: 1,  // H 245 C 50 T 50
    ]
    let ranked = Score.score(colorsToPopulation, desired: 2)

    XCTAssertEqual(ranked.count, 2)
    XCTAssertEqual(ranked[0], 0xff00_7ebc)
    XCTAssertEqual(ranked[1], 0xff00_8772)
  }

  func testGeneratedScenarioOne() {
    let colorsToPopulation: [Int: Int] = [
      0xff7e_a16d: 67,
      0xffd8_ccae: 67,
      0xff83_5c0d: 49,
    ]

    let ranked = Score.score(
      colorsToPopulation, desired: 3, fallbackColorARGB: 0xff8d_3819, filter: false)

    XCTAssertEqual(ranked.count, 3)
    XCTAssertEqual(ranked[0], 0xff7e_a16d)
    XCTAssertEqual(ranked[1], 0xffd8_ccae)
    XCTAssertEqual(ranked[2], 0xff83_5c0d)
  }

  func testGeneratedScenarioTwo() {
    let colorsToPopulation: [Int: Int] = [
      0xffd3_3881: 14,
      0xff32_05cc: 77,
      0xff0b_48cf: 36,
      0xffa0_8f5d: 81,
    ]

    let ranked = Score.score(
      colorsToPopulation, desired: 4, fallbackColorARGB: 0xff7d_772b, filter: true)

    XCTAssertEqual(ranked.count, 3)
    XCTAssertEqual(ranked[0], 0xff32_05cc)
    XCTAssertEqual(ranked[1], 0xffa0_8f5d)
    XCTAssertEqual(ranked[2], 0xffd3_3881)
  }

  func testGeneratedScenarioThree() {
    let colorsToPopulation: [Int: Int] = [
      0xffbe_94a6: 23,
      0xffc3_3fd7: 42,
      0xff89_9f36: 90,
      0xff94_c574: 82,
    ]

    let ranked = Score.score(
      colorsToPopulation, desired: 3, fallbackColorARGB: 0xffaa_79a4, filter: true)

    XCTAssertEqual(ranked.count, 3)
    XCTAssertEqual(ranked[0], 0xff94_c574)
    XCTAssertEqual(ranked[1], 0xffc3_3fd7)
    XCTAssertEqual(ranked[2], 0xffbe_94a6)
  }

  func testGeneratedScenarioFour() {
    let colorsToPopulation: [Int: Int] = [
      0xffdf_241c: 85,
      0xff68_5859: 44,
      0xffd0_6d5f: 34,
      0xff56_1c54: 27,
      0xff71_3090: 88,
    ]

    let ranked = Score.score(
      colorsToPopulation, desired: 5, fallbackColorARGB: 0xff58_c19c, filter: false)

    XCTAssertEqual(ranked.count, 2)
    XCTAssertEqual(ranked[0], 0xffdf_241c)
    XCTAssertEqual(ranked[1], 0xff56_1c54)
  }

  func testGeneratedScenarioFive() {
    let colorsToPopulation: [Int: Int] = [
      0xffbe_66f8: 41,
      0xff4b_bda9: 88,
      0xff80_f6f9: 44,
      0xffab_8017: 43,
      0xffe8_9307: 65,
    ]

    let ranked = Score.score(
      colorsToPopulation, desired: 3, fallbackColorARGB: 0xff91_6691, filter: false)

    XCTAssertEqual(ranked.count, 3)
    XCTAssertEqual(ranked[0], 0xffab_8017)
    XCTAssertEqual(ranked[1], 0xff4b_bda9)
    XCTAssertEqual(ranked[2], 0xffbe_66f8)
  }

  func testGeneratedScenarioSix() {
    let colorsToPopulation: [Int: Int] = [
      0xff18_ea8f: 93,
      0xff32_7593: 18,
      0xff06_6a18: 53,
      0xfffa_8a23: 74,
      0xff04_ca1f: 62,
    ]

    let ranked = Score.score(
      colorsToPopulation, desired: 2, fallbackColorARGB: 0xff4c_377a, filter: false)

    XCTAssertEqual(ranked.count, 2)
    XCTAssertEqual(ranked[0], 0xff18_ea8f)
    XCTAssertEqual(ranked[1], 0xfffa_8a23)
  }

  func testGeneratedScenarioSeven() {
    let colorsToPopulation: [Int: Int] = [
      0xff2e_05ed: 23,
      0xff15_3e55: 90,
      0xff9a_b220: 23,
      0xff15_3379: 66,
      0xff68_bcc3: 81,
    ]

    let ranked = Score.score(
      colorsToPopulation, desired: 2, fallbackColorARGB: 0xfff5_88dc, filter: true)

    XCTAssertEqual(ranked.count, 2)
    XCTAssertEqual(ranked[0], 0xff2e_05ed)
    XCTAssertEqual(ranked[1], 0xff9a_b220)
  }

  func testGeneratedScenarioEight() {
    let colorsToPopulation: [Int: Int] = [
      0xff81_6ec5: 24,
      0xff6d_cb94: 19,
      0xff3c_ae91: 98,
      0xff5b_542f: 25,
    ]

    let ranked = Score.score(
      colorsToPopulation, desired: 1, fallbackColorARGB: 0xff84_b0fd, filter: false)

    XCTAssertEqual(ranked.count, 1)
    XCTAssertEqual(ranked[0], 0xff3c_ae91)
  }

  func testGeneratedScenarioNine() {
    let colorsToPopulation: [Int: Int] = [
      0xff20_6f86: 52,
      0xff4a_620d: 96,
      0xfff5_1401: 85,
      0xff2b_8ebf: 3,
      0xff27_7766: 59,
    ]

    let ranked = Score.score(
      colorsToPopulation, desired: 3, fallbackColorARGB: 0xff02_b415, filter: true)

    XCTAssertEqual(ranked.count, 3)
    XCTAssertEqual(ranked[0], 0xfff5_1401)
    XCTAssertEqual(ranked[1], 0xff4a_620d)
    XCTAssertEqual(ranked[2], 0xff2b_8ebf)
  }

  func testGeneratedScenarioTen() {
    let colorsToPopulation: [Int: Int] = [
      0xff8b_1d99: 54,
      0xff27_effe: 43,
      0xff6f_558d: 2,
      0xff77_fdf2: 78,
    ]

    let ranked = Score.score(
      colorsToPopulation, desired: 4, fallbackColorARGB: 0xff5e_7a10, filter: true)

    XCTAssertEqual(ranked.count, 3)
    XCTAssertEqual(ranked[0], 0xff27_effe)
    XCTAssertEqual(ranked[1], 0xff8b_1d99)
    XCTAssertEqual(ranked[2], 0xff6f_558d)
  }
}
