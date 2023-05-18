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

final class MathUtilsTests: XCTestCase {
  func testSignum() {
    let result1 = MathUtils.signum(-2)
    let result2 = MathUtils.signum(0)
    let result3 = MathUtils.signum(2)

    XCTAssertEqual(result1, -1)
    XCTAssertEqual(result2, 0)
    XCTAssertEqual(result3, 1)
  }

  func testLerp() {
    let result1 = MathUtils.lerp(0, 1, 0.5)
    let result2 = MathUtils.lerp(0, 1, 0.2)
    let result3 = MathUtils.lerp(0, 1, 0.8)
    let result4 = MathUtils.lerp(0, 100, 0.5)

    XCTAssertEqual(result1, 0.5)
    XCTAssertEqual(result2, 0.2)
    XCTAssertEqual(result3, 0.8)
    XCTAssertEqual(result4, 50)
  }

  func testClampInt() {
    let result1 = MathUtils.clampInt(0, 2, -1)
    let result2 = MathUtils.clampInt(0, 2, 1)
    let result3 = MathUtils.clampInt(0, 2, 3)

    XCTAssertEqual(result1, 0)
    XCTAssertEqual(result2, 1)
    XCTAssertEqual(result3, 2)
  }

  func testClampDouble() {
    let result1 = MathUtils.clampDouble(0, 2, -1)
    let result2 = MathUtils.clampDouble(0, 2, 1)
    let result3 = MathUtils.clampDouble(0, 2, 3)

    XCTAssertEqual(result1, 0)
    XCTAssertEqual(result2, 1)
    XCTAssertEqual(result3, 2)
  }

  func testSanitizeDegreesInt() {
    let result1 = MathUtils.sanitizeDegreesInt(20)
    let result2 = MathUtils.sanitizeDegreesInt(360)
    let result3 = MathUtils.sanitizeDegreesInt(420)

    XCTAssertEqual(result1, 20)
    XCTAssertEqual(result2, 0)
    XCTAssertEqual(result3, 60)
  }

  func testSanitizeDegreesDouble() {
    let result1 = MathUtils.sanitizeDegreesDouble(20)
    let result2 = MathUtils.sanitizeDegreesDouble(360)
    let result3 = MathUtils.sanitizeDegreesDouble(420)

    XCTAssertEqual(result1, 20)
    XCTAssertEqual(result2, 0)
    XCTAssertEqual(result3, 60)
  }

  func testRotationDirection() {
    var from = 0.0
    while from < 360 {
      var to = 7.5
      while to < 360 {
        let expectedAnswer = rotationDirection(from, to)
        let actualAnswer = MathUtils.rotationDirection(from, to)

        XCTAssertEqual(actualAnswer, expectedAnswer)
        XCTAssertEqual(abs(actualAnswer), 1)

        to += 15
      }
      from += 15
    }
  }

  func testDifferenceDegrees() {
    let result0 = MathUtils.differenceDegrees(274.6219605304299, 77.72547409861208)
    let result1 = MathUtils.differenceDegrees(34.300891775453685, 345.71661212068005)
    let result2 = MathUtils.differenceDegrees(133.40137028102632, 242.91571888782715)
    let result3 = MathUtils.differenceDegrees(190.0917641906071, 212.50303144714914)
    let result4 = MathUtils.differenceDegrees(74.32650812140363, 8.216795031646305)
    let result5 = MathUtils.differenceDegrees(297.86357401167163, 40.68646508824719)
    let result6 = MathUtils.differenceDegrees(267.81615364209966, 278.2059089562928)
    let result7 = MathUtils.differenceDegrees(174.5904980548994, 23.563620558167703)
    let result8 = MathUtils.differenceDegrees(157.88312470562747, 136.9620280065816)
    let result9 = MathUtils.differenceDegrees(125.57678704737181, 232.55663167025088)
    let result10 = MathUtils.differenceDegrees(29.516420072682976, 282.618422595264)

    XCTAssertEqual(result0, 163.10351356818222)
    XCTAssertEqual(result1, 48.58427965477364)
    XCTAssertEqual(result2, 109.51434860680084)
    XCTAssertEqual(result3, 22.411267256542033)
    XCTAssertEqual(result4, 66.10971308975734)
    XCTAssertEqual(result5, 102.82289107657556)
    XCTAssertEqual(result6, 10.38975531419311)
    XCTAssertEqual(result7, 151.0268774967317)
    XCTAssertEqual(result8, 20.921096699045876)
    XCTAssertEqual(result9, 106.97984462287907)
    XCTAssertEqual(result10, 106.89799747741898)
  }

  func testMatrixMultiply() {
    let result1 = MathUtils.matrixMultiply(
      [0, 1, 2],
      [
        [1, 2, 3],
        [2, 3, 4],
        [4, 5, 6],
      ])
    let result2 = MathUtils.matrixMultiply(
      [3, 4, 5],
      [
        [3, 7, 1],
        [5, 8, 2],
        [6, 9, 3],
      ])

    XCTAssertEqual(result1, [8, 11, 17])
    XCTAssertEqual(result2, [42, 57, 69])
  }
}

// Original implementation for MathUtils.rotationDirection.
// Included here to test equivalence with new implementation.
private func rotationDirection(_ from: Double, _ to: Double) -> Double {
  let a = to - from
  let b = to - from + 360
  let c = to - from - 360
  let aAbs = abs(a)
  let bAbs = abs(b)
  let cAbs = abs(c)
  if aAbs <= bAbs && aAbs <= cAbs {
    return a >= 0 ? 1 : -1
  } else if bAbs <= aAbs && bAbs <= cAbs {
    return b >= 0 ? 1 : -1
  } else {
    return c >= 0 ? 1 : -1
  }
}
