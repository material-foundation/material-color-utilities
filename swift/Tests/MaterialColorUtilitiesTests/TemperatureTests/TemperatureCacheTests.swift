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

final class TemperatureCacheTests: XCTestCase {
  func testRawTemperature() {
    let blueTemp = TemperatureCache.rawTemperature(Hct.fromInt(0xff00_00ff))

    XCTAssertEqual(blueTemp, -1.393, accuracy: 0.001)

    let redTemp = TemperatureCache.rawTemperature(Hct.fromInt(0xffff_0000))

    XCTAssertEqual(redTemp, 2.351, accuracy: 0.001)

    let greenTemp = TemperatureCache.rawTemperature(Hct.fromInt(0xff00_ff00))

    XCTAssertEqual(greenTemp, -0.267, accuracy: 0.001)

    let whiteTemp = TemperatureCache.rawTemperature(Hct.fromInt(0xffff_ffff))

    XCTAssertEqual(whiteTemp, -0.5, accuracy: 0.001)

    let blackTemp = TemperatureCache.rawTemperature(Hct.fromInt(0xff00_0000))

    XCTAssertEqual(blackTemp, -0.5, accuracy: 0.001)
  }

  func testRelativeTemprature() {
    let blueTemp = TemperatureCache(Hct.fromInt(0xff00_00ff)).inputRelativeTemperature

    XCTAssertEqual(blueTemp, 0.0, accuracy: 0.001)

    let redTemp = TemperatureCache(Hct.fromInt(0xffff_0000)).inputRelativeTemperature

    XCTAssertEqual(redTemp, 1.0, accuracy: 0.001)

    let greenTemp = TemperatureCache(Hct.fromInt(0xff00_ff00)).inputRelativeTemperature

    XCTAssertEqual(greenTemp, 0.467, accuracy: 0.001)

    let whiteTemp = TemperatureCache(Hct.fromInt(0xffff_ffff)).inputRelativeTemperature

    XCTAssertEqual(whiteTemp, 0.5, accuracy: 0.001)

    let blackTemp = TemperatureCache(Hct.fromInt(0xff00_0000)).inputRelativeTemperature

    XCTAssertEqual(blackTemp, 0.5, accuracy: 0.001)
  }

  func testComplement() {
    let blueComplement = TemperatureCache(Hct.fromInt(0xff00_00ff)).complement.toInt()

    XCTAssertEqual(blueComplement, 0xff9D_0002)

    let redComplement = TemperatureCache(Hct.fromInt(0xffff_0000)).complement.toInt()

    XCTAssertEqual(redComplement, 0xff00_7BFC)

    let greenComplement = TemperatureCache(Hct.fromInt(0xff00_ff00)).complement.toInt()

    XCTAssertEqual(greenComplement, 0xffFF_D2C9)

    let whiteComplement = TemperatureCache(Hct.fromInt(0xffff_ffff)).complement.toInt()

    XCTAssertEqual(whiteComplement, 0xffff_ffff)

    let blackComplement = TemperatureCache(Hct.fromInt(0xff00_0000)).complement.toInt()

    XCTAssertEqual(blackComplement, 0xff00_0000)
  }

  func testAnalogous() {
    let blueAnalogous = TemperatureCache(Hct.fromInt(0xff00_00ff)).analogous().map { $0.toInt() }

    XCTAssertEqual(blueAnalogous[0], 0xff00_590C)
    XCTAssertEqual(blueAnalogous[1], 0xff00_564E)
    XCTAssertEqual(blueAnalogous[2], 0xff00_00ff)
    XCTAssertEqual(blueAnalogous[3], 0xff67_00CC)
    XCTAssertEqual(blueAnalogous[4], 0xff81_009F)

    let redAnalogous = TemperatureCache(Hct.fromInt(0xffff_0000)).analogous().map { $0.toInt() }

    XCTAssertEqual(redAnalogous[0], 0xffF6_0082)
    XCTAssertEqual(redAnalogous[1], 0xffFC_004C)
    XCTAssertEqual(redAnalogous[2], 0xffff_0000)
    XCTAssertEqual(redAnalogous[3], 0xffD9_5500)
    XCTAssertEqual(redAnalogous[4], 0xffAF_7200)

    let greenAnalogous = TemperatureCache(Hct.fromInt(0xff00_ff00)).analogous().map { $0.toInt() }

    XCTAssertEqual(greenAnalogous[0], 0xffCE_E900)
    XCTAssertEqual(greenAnalogous[1], 0xff92_F500)
    XCTAssertEqual(greenAnalogous[2], 0xff00_ff00)
    XCTAssertEqual(greenAnalogous[3], 0xff00_FD6F)
    XCTAssertEqual(greenAnalogous[4], 0xff00_FAB3)

    let blackAnalogous = TemperatureCache(Hct.fromInt(0xff00_0000)).analogous().map { $0.toInt() }

    XCTAssertEqual(blackAnalogous[0], 0xff00_0000)
    XCTAssertEqual(blackAnalogous[1], 0xff00_0000)
    XCTAssertEqual(blackAnalogous[2], 0xff00_0000)
    XCTAssertEqual(blackAnalogous[3], 0xff00_0000)
    XCTAssertEqual(blackAnalogous[4], 0xff00_0000)

    let whiteAnalogous = TemperatureCache(Hct.fromInt(0xffff_ffff)).analogous().map { $0.toInt() }

    XCTAssertEqual(whiteAnalogous[0], 0xffff_ffff)
    XCTAssertEqual(whiteAnalogous[1], 0xffff_ffff)
    XCTAssertEqual(whiteAnalogous[2], 0xffff_ffff)
    XCTAssertEqual(whiteAnalogous[3], 0xffff_ffff)
    XCTAssertEqual(whiteAnalogous[4], 0xffff_ffff)
  }
}
