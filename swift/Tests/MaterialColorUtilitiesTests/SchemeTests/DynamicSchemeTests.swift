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

final class DynamicSchemeTests: XCTestCase {
  func test0LengthInput() {
    let hue = DynamicScheme.getRotatedHue(Hct.from(43, 16, 16), [], [])

    XCTAssertEqual(hue, 43, accuracy: 1)
  }

  func test1LengthInputNoRotation() {
    let hue = DynamicScheme.getRotatedHue(Hct.from(43, 16, 16), [0], [0])

    XCTAssertEqual(hue, 43, accuracy: 1)
  }

  // TODO: Find a way to test "asserts()"
  //    func testInputLengthMismatchAsserts() {
  //        XCTAssertThrowsError(DynamicScheme.getRotatedHue(Hct.from(43, 16, 16), [0, 1], [0]))
  //    }

  func testOnBoundaryRotationCorrect() {
    let hue = DynamicScheme.getRotatedHue(Hct.from(43, 16, 16), [0, 42, 360], [0, 15, 0])

    XCTAssertEqual(hue, 43 + 15, accuracy: 1)
  }

  func testRotationResultLargerThan360egreesWraps() {
    let hue = DynamicScheme.getRotatedHue(Hct.from(43, 16, 16), [0, 42, 360], [0, 480, 0])

    XCTAssertEqual(hue, 163, accuracy: 1)
  }
}
