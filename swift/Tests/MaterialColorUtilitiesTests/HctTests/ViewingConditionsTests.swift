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

final class ViewingConditionsTests: XCTestCase {
  func testViewingConditions() {
    let result1 = ViewingConditions.make()

    XCTAssertEqual(result1.adaptingLuminance, 11.725677948856951)
    XCTAssertEqual(result1.backgroundLstar, 50.0)
    XCTAssertEqual(result1.surround, 2.0)
    XCTAssertEqual(result1.discountingIlluminant, false)
  }
}
