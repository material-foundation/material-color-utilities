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

  func testKeyColor_exactChromaAvailable() {
    // Requested chroma is exactly achievable at a certain tone.
    let palette = TonalPalette(hue: 50.0, chroma: 60.0)
    let result = palette.keyColor

    XCTAssertEqual(result.hue, 50.0, accuracy: 10.0)
    XCTAssertEqual(result.chroma, 60.0, accuracy: 0.5)
    // Tone might vary, but should be within the range from 0 to 100.
    XCTAssertTrue(result.tone > 0 && result.tone < 100)
  }

  func testKeyColor_unusuallyHighChroma() {
    // Requested chroma is above what is achievable. For Hue 149, chroma peak is 89.6 at Tone 87.9.
    // The result key color's chroma should be close to the chroma peak.
    let palette = TonalPalette(hue: 149.0, chroma: 200.0)
    let result = palette.keyColor

    XCTAssertEqual(result.hue, 149.0, accuracy: 10.0)
    XCTAssertGreaterThan(result.chroma, 89.0)
    // Tone might vary, but should be within the range from 0 to 100.
    XCTAssertTrue(result.tone > 0 && result.tone < 100)
  }

  func testKeyColor_unusuallyLowChroma() {
    // By definition, the key color should be the first tone, starting from Tone 50, matching the
    // given hue and chroma. When requesting a very low chroma, the result should be close to Tone
    // 50, since most tones can produce a low chroma.
    let palette = TonalPalette(hue: 50.0, chroma: 3.0)
    let result = palette.keyColor

    // Higher error tolerance for hue when the requested chroma is unusually low.
    XCTAssertEqual(result.hue, 50.0, accuracy: 10.0)
    XCTAssertEqual(result.chroma, 3.0, accuracy: 0.5)
    XCTAssertEqual(result.tone, 50.0, accuracy: 0.5)
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
