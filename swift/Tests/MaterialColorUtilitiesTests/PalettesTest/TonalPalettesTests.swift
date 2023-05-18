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

final class TonalPalettesTests: XCTestCase {
  func testOfTonesOfBlue() {
    let hct = Hct.fromInt(0xff00_00ff)
    let tones = TonalPalette.of(hct.hue, hct.chroma)

    XCTAssertEqual(tones.tone(0), 0xff00_0000)
    XCTAssertEqual(tones.tone(10), 0xff00_006e)
    XCTAssertEqual(tones.tone(20), 0xff00_01ac)
    XCTAssertEqual(tones.tone(30), 0xff00_00ef)
    XCTAssertEqual(tones.tone(40), 0xff34_3dff)
    XCTAssertEqual(tones.tone(50), 0xff5a_64ff)
    XCTAssertEqual(tones.tone(60), 0xff7c_84ff)
    XCTAssertEqual(tones.tone(70), 0xff9d_a3ff)
    XCTAssertEqual(tones.tone(80), 0xffbe_c2ff)
    XCTAssertEqual(tones.tone(90), 0xffe0_e0ff)
    XCTAssertEqual(tones.tone(95), 0xfff1_efff)
    XCTAssertEqual(tones.tone(99), 0xffff_fbff)
    XCTAssertEqual(tones.tone(100), 0xffff_ffff)

    /// Tone not in [TonalPalette.commonTones]
    XCTAssertEqual(tones.tone(3), 0xff00_003c)
  }

  func testOfOperatorAndHash() {
    let hctAB = Hct.fromInt(0xff00_00ff)
    let tonesA = TonalPalette.of(hctAB.hue, hctAB.chroma)
    let tonesB = TonalPalette.of(hctAB.hue, hctAB.chroma)
    let hctC = Hct.fromInt(0xff12_3456)
    let tonesC = TonalPalette.of(hctC.hue, hctC.chroma)

    XCTAssertEqual(tonesA, tonesB)
    XCTAssertTrue(tonesB != tonesC)

    XCTAssertEqual(tonesA.hashValue, tonesB.hashValue)
    XCTAssertTrue(tonesB.hashValue != tonesC.hashValue)
  }

  func testFromHct() {
    let hct = Hct.fromInt(0xff00_00ff)

    let paletteFromHct = TonalPalette.fromHct(hct)
    let paletteFromHueAndChroma = TonalPalette.of(hct.hue, hct.chroma)

    XCTAssertEqual(paletteFromHct.hashValue, paletteFromHueAndChroma.hashValue)
  }
}

private func createList(_ size: Int, value: Int? = nil) -> [Int] {
  var results: [Int] = []
  for i in 0..<size {
    results.append(value ?? i)
  }
  return results
}
