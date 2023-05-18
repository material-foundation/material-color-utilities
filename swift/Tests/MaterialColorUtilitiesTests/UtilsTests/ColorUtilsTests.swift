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

final class ColorUtilsTests: XCTestCase {
  func testRangeIntegrity() {
    let range = createRange(3, 9999, 1234)
    for i in 0..<1234 {
      XCTAssertEqual(range[i], 3 + 8.1070559611 * Double(i), accuracy: 1e-5)
    }
  }

  func testYToLstarToY() {
    for y in createRange(0, 100, 1001) {
      let result = ColorUtils.yFromLstar(ColorUtils.lstarFromY(y))

      XCTAssertEqual(result, y, accuracy: 1e-5)
    }
  }

  func testLstarToYToLstar() {
    for lstar in createRange(0, 100, 1001) {
      let result = ColorUtils.lstarFromY(ColorUtils.yFromLstar(lstar))

      XCTAssertEqual(result, lstar, accuracy: 1e-5)
    }
  }

  func testYFromLstar() {
    XCTAssertEqual(ColorUtils.yFromLstar(0.0), 0.0, accuracy: 1e-5)
    XCTAssertEqual(ColorUtils.yFromLstar(0.1), 0.0110705, accuracy: 1e-5)
    XCTAssertEqual(ColorUtils.yFromLstar(0.2), 0.0221411, accuracy: 1e-5)
    XCTAssertEqual(ColorUtils.yFromLstar(0.3), 0.0332116, accuracy: 1e-5)
    XCTAssertEqual(ColorUtils.yFromLstar(0.4), 0.0442822, accuracy: 1e-5)
    XCTAssertEqual(ColorUtils.yFromLstar(0.5), 0.0553528, accuracy: 1e-5)
    XCTAssertEqual(ColorUtils.yFromLstar(1.0), 0.1107056, accuracy: 1e-5)
    XCTAssertEqual(ColorUtils.yFromLstar(2.0), 0.2214112, accuracy: 1e-5)
    XCTAssertEqual(ColorUtils.yFromLstar(3.0), 0.3321169, accuracy: 1e-5)
    XCTAssertEqual(ColorUtils.yFromLstar(4.0), 0.4428225, accuracy: 1e-5)
    XCTAssertEqual(ColorUtils.yFromLstar(5.0), 0.5535282, accuracy: 1e-5)
    XCTAssertEqual(ColorUtils.yFromLstar(8.0), 0.8856451, accuracy: 1e-5)
    XCTAssertEqual(ColorUtils.yFromLstar(10.0), 1.1260199, accuracy: 1e-5)
    XCTAssertEqual(ColorUtils.yFromLstar(15.0), 1.9085832, accuracy: 1e-5)
    XCTAssertEqual(ColorUtils.yFromLstar(20.0), 2.9890524, accuracy: 1e-5)
    XCTAssertEqual(ColorUtils.yFromLstar(25.0), 4.4154767, accuracy: 1e-5)
    XCTAssertEqual(ColorUtils.yFromLstar(30.0), 6.2359055, accuracy: 1e-5)
    XCTAssertEqual(ColorUtils.yFromLstar(40.0), 11.2509737, accuracy: 1e-5)
    XCTAssertEqual(ColorUtils.yFromLstar(50.0), 18.4186518, accuracy: 1e-5)
    XCTAssertEqual(ColorUtils.yFromLstar(60.0), 28.1233342, accuracy: 1e-5)
    XCTAssertEqual(ColorUtils.yFromLstar(70.0), 40.7494157, accuracy: 1e-5)
    XCTAssertEqual(ColorUtils.yFromLstar(80.0), 56.6812907, accuracy: 1e-5)
    XCTAssertEqual(ColorUtils.yFromLstar(90.0), 76.3033539, accuracy: 1e-5)
    XCTAssertEqual(ColorUtils.yFromLstar(95.0), 87.6183294, accuracy: 1e-5)
    XCTAssertEqual(ColorUtils.yFromLstar(99.0), 97.4360239, accuracy: 1e-5)
    XCTAssertEqual(ColorUtils.yFromLstar(100.0), 100.0, accuracy: 1e-5)
  }

  func testLstarFromY() {
    XCTAssertEqual(ColorUtils.lstarFromY(0.0), 0.0, accuracy: 1e-5)
    XCTAssertEqual(ColorUtils.lstarFromY(0.1), 0.9032962, accuracy: 1e-5)
    XCTAssertEqual(ColorUtils.lstarFromY(0.2), 1.8065925, accuracy: 1e-5)
    XCTAssertEqual(ColorUtils.lstarFromY(0.3), 2.7098888, accuracy: 1e-5)
    XCTAssertEqual(ColorUtils.lstarFromY(0.4), 3.6131851, accuracy: 1e-5)
    XCTAssertEqual(ColorUtils.lstarFromY(0.5), 4.5164814, accuracy: 1e-5)
    XCTAssertEqual(ColorUtils.lstarFromY(0.8856451), 8.0, accuracy: 1e-5)
    XCTAssertEqual(ColorUtils.lstarFromY(1.0), 8.9914424, accuracy: 1e-5)
    XCTAssertEqual(ColorUtils.lstarFromY(2.0), 15.4872443, accuracy: 1e-5)
    XCTAssertEqual(ColorUtils.lstarFromY(3.0), 20.0438970, accuracy: 1e-5)
    XCTAssertEqual(ColorUtils.lstarFromY(4.0), 23.6714419, accuracy: 1e-5)
    XCTAssertEqual(ColorUtils.lstarFromY(5.0), 26.7347653, accuracy: 1e-5)
    XCTAssertEqual(ColorUtils.lstarFromY(10.0), 37.8424304, accuracy: 1e-5)
    XCTAssertEqual(ColorUtils.lstarFromY(15.0), 45.6341970, accuracy: 1e-5)
    XCTAssertEqual(ColorUtils.lstarFromY(20.0), 51.8372115, accuracy: 1e-5)
    XCTAssertEqual(ColorUtils.lstarFromY(25.0), 57.0754208, accuracy: 1e-5)
    XCTAssertEqual(ColorUtils.lstarFromY(30.0), 61.6542222, accuracy: 1e-5)
    XCTAssertEqual(ColorUtils.lstarFromY(40.0), 69.4695307, accuracy: 1e-5)
    XCTAssertEqual(ColorUtils.lstarFromY(50.0), 76.0692610, accuracy: 1e-5)
    XCTAssertEqual(ColorUtils.lstarFromY(60.0), 81.8381891, accuracy: 1e-5)
    XCTAssertEqual(ColorUtils.lstarFromY(70.0), 86.9968642, accuracy: 1e-5)
    XCTAssertEqual(ColorUtils.lstarFromY(80.0), 91.6848609, accuracy: 1e-5)
    XCTAssertEqual(ColorUtils.lstarFromY(90.0), 95.9967686, accuracy: 1e-5)
    XCTAssertEqual(ColorUtils.lstarFromY(95.0), 98.0335184, accuracy: 1e-5)
    XCTAssertEqual(ColorUtils.lstarFromY(99.0), 99.6120372, accuracy: 1e-5)
    XCTAssertEqual(ColorUtils.lstarFromY(100.0), 100.0, accuracy: 1e-5)
  }

  func testYContinuity() {
    let epsilon = 1e-6
    let delta = 1e-8
    let left = 8.0 - delta
    let mid = 8.0
    let right = 8.0 + delta

    XCTAssertEqual(ColorUtils.yFromLstar(left), ColorUtils.yFromLstar(mid), accuracy: epsilon)
    XCTAssertEqual(ColorUtils.yFromLstar(right), ColorUtils.yFromLstar(mid), accuracy: epsilon)
  }

  func testRgbToXyzToRgb() {
    let rgbRange = createRgbRange()

    for r in rgbRange {
      for g in rgbRange {
        for b in rgbRange {
          let argb = ColorUtils.argbFromRgb(r, g, b)
          let xyz = ColorUtils.xyzFromArgb(argb)
          let converted = ColorUtils.argbFromXyz(xyz[0], xyz[1], xyz[2])

          XCTAssertEqual(Double(ColorUtils.redFromArgb(converted)), Double(r), accuracy: 1.5)
          XCTAssertEqual(Double(ColorUtils.greenFromArgb(converted)), Double(g), accuracy: 1.5)
          XCTAssertEqual(Double(ColorUtils.blueFromArgb(converted)), Double(b), accuracy: 1.5)
        }
      }
    }
  }

  func testRgbToLabToRgb() {
    let rgbRange = createRgbRange()

    for r in rgbRange {
      for g in rgbRange {
        for b in rgbRange {
          let argb = ColorUtils.argbFromRgb(r, g, b)
          let lab = ColorUtils.labFromArgb(argb)
          let converted = ColorUtils.argbFromLab(lab[0], lab[1], lab[2])

          XCTAssertEqual(Double(ColorUtils.redFromArgb(converted)), Double(r), accuracy: 1.5)
          XCTAssertEqual(Double(ColorUtils.greenFromArgb(converted)), Double(g), accuracy: 1.5)
          XCTAssertEqual(Double(ColorUtils.blueFromArgb(converted)), Double(b), accuracy: 1.5)
        }
      }
    }
  }

  func testRgbToLstarToRgb() {
    let fullRgbRange = createFullRgbRange()

    for component in fullRgbRange {
      let argb = ColorUtils.argbFromRgb(component, component, component)
      let lstar = ColorUtils.lstarFromArgb(argb)
      let converted = ColorUtils.argbFromLstar(lstar)

      XCTAssertEqual(converted, argb)
    }
  }

  func testRgbToLstarToYCommutes() {
    let rgbRange = createRgbRange()

    for r in rgbRange {
      for g in rgbRange {
        for b in rgbRange {
          let argb = ColorUtils.argbFromRgb(r, g, b)
          let lstar = ColorUtils.lstarFromArgb(argb)
          let y = ColorUtils.yFromLstar(lstar)
          let y2 = ColorUtils.xyzFromArgb(argb)[1]

          XCTAssertEqual(y, y2, accuracy: 1e-5)
        }
      }
    }
  }

  func testLstarToRgbToYCommutes() {
    for lstar in createRange(0, 100, 1001) {
      let argb = ColorUtils.argbFromLstar(lstar)
      let y = ColorUtils.xyzFromArgb(argb)[1]
      let y2 = ColorUtils.yFromLstar(lstar)

      XCTAssertEqual(y, y2, accuracy: 1)
    }
  }

  func testLinearizeDelinearize() {
    let fullRgbRange = createFullRgbRange()

    for rgbComponent in fullRgbRange {
      let converted = ColorUtils.delinearized(ColorUtils.linearized(rgbComponent))

      XCTAssertEqual(converted, rgbComponent)
    }
  }
}

private func createRange(_ start: Double, _ stop: Double, _ caseCount: Int) -> [Double] {
  let stepSize = (stop - start) / Double(caseCount - 1)
  var result: [Double] = []
  for index in 0..<caseCount {
    result.append(start + stepSize * Double(index))
  }
  return result
}

private func createRgbRange() -> [Int] {
  let values = createRange(0, 255, 8)
  return values.map { Int(round($0)) }
}

private func createFullRgbRange() -> [Int] {
  var result: [Int] = []
  for index in 0...255 {
    result.append(index)
  }
  return result
}
