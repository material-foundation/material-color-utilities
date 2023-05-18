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

final class ContrastTests: XCTestCase {
  func testRatioOfTonesOutOfBoundsInput() {
    XCTAssertEqual(21.0, Contrast.ratioOfTones(-10.0, 110.0), accuracy: 0.001)
  }

  func testLighterImpossibleRatioErrors() {
    XCTAssertEqual(-1, Contrast.lighter(tone: 90, ratio: 10), accuracy: 0.001)
  }

  func testLighterOutOfBoundsInputAboveErrors() {
    XCTAssertEqual(-1, Contrast.lighter(tone: 110, ratio: 2), accuracy: 0.001)
  }

  func testLighterOutOfBoundsInputBelowErrors() {
    XCTAssertEqual(-1, Contrast.lighter(tone: -10, ratio: 2), accuracy: 0.001)
  }

  func testLighterUnsafeReturnsMaxTone() {
    XCTAssertEqual(100, Contrast.lighterUnsafe(tone: 100, ratio: 2), accuracy: 0.001)
  }

  func testDarkerImpossibleRatioErrors() {
    XCTAssertEqual(-1, Contrast.darker(tone: 10, ratio: 20), accuracy: 0.001)
  }

  func testDarkerOutOfBoundsInputAboveErrors() {
    XCTAssertEqual(-1, Contrast.darker(tone: 110, ratio: 2), accuracy: 0.001)
  }

  func testDarkerOutOfBoundsInputBelowErrors() {
    XCTAssertEqual(-1, Contrast.darker(tone: -10, ratio: 2), accuracy: 0.001)
  }

  func testDarkerUnsafeReturnsMinTone() {
    XCTAssertEqual(0, Contrast.darkerUnsafe(tone: 0, ratio: 2), accuracy: 0.001)
  }
}
