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

final class HctTests: XCTestCase {
  //    func testHctRoundTrip() {
  //        let colors = allColors()
  //        var idx = 0
  //
  //        for argb in colors {
  //            let hct = Hct.fromInt(argb)
  //            let reconstructedArgb = Hct.from(hct.hue, hct.chroma, hct.tone)
  //
  //            XCTAssertEqual(hct.toInt(), reconstructedArgb.toInt())
  //
  //            print("\(argb) \(idx + 1)/\(colors.count)")
  //            idx += 1
  //        }
  //    }

  func testHashCode() {
    XCTAssertEqual(Hct.fromInt(123), Hct.fromInt(123))
    XCTAssertEqual(Hct.fromInt(123).hashValue, Hct.fromInt(123).hashValue)
  }

  func testConversionsAreReflexive() {
    let cam = Cam16.fromInt(red)
    let color = cam.viewed(ViewingConditions.standard())

    XCTAssertEqual(color, red)
  }

  func testYMidgray() {
    XCTAssertEqual(18.418, ColorUtils.yFromLstar(50), accuracy: 0.001)
  }

  func testYBlack() {
    XCTAssertEqual(0, ColorUtils.yFromLstar(0), accuracy: 0.001)
  }

  func testYWhite() {
    XCTAssertEqual(100, ColorUtils.yFromLstar(100), accuracy: 0.001)
  }

  func testCamRed() {
    let cam = Cam16.fromInt(red)

    XCTAssertEqual(46.445, cam.j, accuracy: 0.001)
    XCTAssertEqual(113.357, cam.chroma, accuracy: 0.001)
    XCTAssertEqual(27.408, cam.hue, accuracy: 0.001)
    XCTAssertEqual(89.494, cam.m, accuracy: 0.001)
    XCTAssertEqual(91.889, cam.s, accuracy: 0.001)
    XCTAssertEqual(105.988, cam.q, accuracy: 0.001)
  }

  func testCamGreen() {
    let cam = Cam16.fromInt(green)

    XCTAssertEqual(79.331, cam.j, accuracy: 0.001)
    XCTAssertEqual(108.410, cam.chroma, accuracy: 0.001)
    XCTAssertEqual(142.139, cam.hue, accuracy: 0.001)
    XCTAssertEqual(85.587, cam.m, accuracy: 0.001)
    XCTAssertEqual(78.604, cam.s, accuracy: 0.001)
    XCTAssertEqual(138.520, cam.q, accuracy: 0.001)
  }

  func testCamBlue() {
    let cam = Cam16.fromInt(blue)

    XCTAssertEqual(25.465, cam.j, accuracy: 0.001)
    XCTAssertEqual(87.230, cam.chroma, accuracy: 0.001)
    XCTAssertEqual(282.788, cam.hue, accuracy: 0.001)
    XCTAssertEqual(68.867, cam.m, accuracy: 0.001)
    XCTAssertEqual(93.674, cam.s, accuracy: 0.001)
    XCTAssertEqual(78.481, cam.q, accuracy: 0.001)
  }

  func testCamBlack() {
    let cam = Cam16.fromInt(black)

    XCTAssertEqual(0.0, cam.j, accuracy: 0.001)
    XCTAssertEqual(0.0, cam.chroma, accuracy: 0.001)
    XCTAssertEqual(0.0, cam.hue, accuracy: 0.001)
    XCTAssertEqual(0.0, cam.m, accuracy: 0.001)
    XCTAssertEqual(0.0, cam.s, accuracy: 0.001)
    XCTAssertEqual(0.0, cam.q, accuracy: 0.001)
  }

  func testCamWhite() {
    let cam = Cam16.fromInt(white)

    XCTAssertEqual(100.0, cam.j, accuracy: 0.001)
    XCTAssertEqual(2.869, cam.chroma, accuracy: 0.001)
    XCTAssertEqual(209.492, cam.hue, accuracy: 0.001)
    XCTAssertEqual(2.265, cam.m, accuracy: 0.001)
    XCTAssertEqual(12.068, cam.s, accuracy: 0.001)
    XCTAssertEqual(155.521, cam.q, accuracy: 0.001)
  }

  func testCamutMapRed() {
    let colorToTest = red
    let cam = Cam16.fromInt(colorToTest)
    let color = Hct.from(cam.hue, cam.chroma, ColorUtils.lstarFromArgb(colorToTest)).toInt()

    XCTAssertEqual(colorToTest, color)
  }

  func testCamutMapGreen() {
    let colorToTest = green
    let cam = Cam16.fromInt(colorToTest)
    let color = Hct.from(cam.hue, cam.chroma, ColorUtils.lstarFromArgb(colorToTest)).toInt()

    XCTAssertEqual(colorToTest, color)
  }

  func testCamutMapBlue() {
    let colorToTest = blue
    let cam = Cam16.fromInt(colorToTest)
    let color = Hct.from(cam.hue, cam.chroma, ColorUtils.lstarFromArgb(colorToTest)).toInt()

    XCTAssertEqual(colorToTest, color)
  }

  func testCamutMapWhite() {
    let colorToTest = white
    let cam = Cam16.fromInt(colorToTest)
    let color = Hct.from(cam.hue, cam.chroma, ColorUtils.lstarFromArgb(colorToTest)).toInt()

    XCTAssertEqual(colorToTest, color)
  }

  func testCamutMapMidgray() {
    let colorToTest = midgray
    let cam = Cam16.fromInt(colorToTest)
    let color = Hct.from(cam.hue, cam.chroma, ColorUtils.lstarFromArgb(colorToTest)).toInt()

    XCTAssertEqual(colorToTest, color)
  }

  func testCamutMapBlack() {
    let colorToTest = black
    let cam = Cam16.fromInt(colorToTest)
    let color = Hct.from(cam.hue, cam.chroma, ColorUtils.lstarFromArgb(colorToTest)).toInt()

    XCTAssertEqual(colorToTest, color)
  }

  func testHctReturnsSufficientlyCloseColor() {
    for hue in stride(from: 15, to: 361, by: 30) {
      for chroma in stride(from: 0, to: 100, by: 10) {
        for tone in stride(from: 20, to: 80, by: 10) {
          let hctRequestDescription = "H\(hue) C\(chroma) T\(tone)"
          let hctColor = Hct.from(Double(hue), Double(chroma), Double(tone))

          if chroma > 0 {
            XCTAssertEqual(
              Int(hctColor.hue), hue, accuracy: 4,
              "Hue should be close for \(hctRequestDescription)")
          }

          XCTAssertTrue(
            0...(Double(chroma) + 2.5) ~= hctColor.chroma,
            "Chroma should be close or less for \(hctRequestDescription)")

          if hctColor.chroma < Double(chroma) - 2.5 {
            XCTAssertTrue(
              colorIsOnBoundary(hctColor.toInt()),
              "HCT request for non-sRGB color should return a color on the boundary of the sRGB cube for \(hctRequestDescription), but got \(StringUtils.hexFromArgb(hctColor.toInt())) instead"
            )
          }

          XCTAssertEqual(
            hctColor.tone, Double(tone), accuracy: 0.5,
            "Tone should be close for \(hctRequestDescription)")
        }
      }
    }
  }

  func testCam16ToXyzWithoutArray() {
    let colorToTest = red
    let cam = Cam16.fromInt(colorToTest)
    let xyz = cam.xyzInViewingConditions(ViewingConditions.sRgb())

    XCTAssertEqual(xyz[0], 41.23, accuracy: 0.01)
    XCTAssertEqual(xyz[1], 21.26, accuracy: 0.01)
    XCTAssertEqual(xyz[2], 1.93, accuracy: 0.01)
  }

  func testCam16ToXyzWithArray() {
    let colorToTest = red
    let cam = Cam16.fromInt(colorToTest)
    let xyz = cam.xyzInViewingConditions(ViewingConditions.sRgb(), array: [0, 0, 0])

    XCTAssertEqual(xyz[0], 41.23, accuracy: 0.01)
    XCTAssertEqual(xyz[1], 21.26, accuracy: 0.01)
    XCTAssertEqual(xyz[2], 1.93, accuracy: 0.01)
  }

  func testColorRelativityRedInBlack() {
    let colorToTest = red
    let hct = Hct.fromInt(colorToTest)

    let result = hct.inViewingConditions(ViewingConditions.make(backgroundLstar: 0))

    XCTAssertEqual(result.toInt(), 0xff9F_5C51)
  }

  func testColorRelativityRedInWhite() {
    let colorToTest = red
    let hct = Hct.fromInt(colorToTest)

    let result = hct.inViewingConditions(ViewingConditions.make(backgroundLstar: 100))

    XCTAssertEqual(result.toInt(), 0xffFF_5D48)
  }

  func testColorRelativityGreenInBlack() {
    let colorToTest = green
    let hct = Hct.fromInt(colorToTest)

    let result = hct.inViewingConditions(ViewingConditions.make(backgroundLstar: 0))

    XCTAssertEqual(result.toInt(), 0xffAC_D69D)
  }

  func testColorRelativityGreenInWhite() {
    let colorToTest = green
    let hct = Hct.fromInt(colorToTest)

    let result = hct.inViewingConditions(ViewingConditions.make(backgroundLstar: 100))

    XCTAssertEqual(result.toInt(), 0xff8E_FF77)
  }

  func testColorRelativityBlueInBlack() {
    let colorToTest = blue
    let hct = Hct.fromInt(colorToTest)

    let result = hct.inViewingConditions(ViewingConditions.make(backgroundLstar: 0))

    XCTAssertEqual(result.toInt(), 0xff34_3654)
  }

  func testColorRelativityBlueInWhite() {
    let colorToTest = blue
    let hct = Hct.fromInt(colorToTest)

    let result = hct.inViewingConditions(ViewingConditions.make(backgroundLstar: 100))

    XCTAssertEqual(result.toInt(), 0xff3F_49FF)
  }

  func testColorRelativityWhiteInBlack() {
    let colorToTest = white
    let hct = Hct.fromInt(colorToTest)

    let result = hct.inViewingConditions(ViewingConditions.make(backgroundLstar: 0))

    XCTAssertEqual(result.toInt(), 0xffFF_FFFF)
  }

  func testColorRelativityWhiteInWhite() {
    let colorToTest = white
    let hct = Hct.fromInt(colorToTest)

    let result = hct.inViewingConditions(ViewingConditions.make(backgroundLstar: 100))

    XCTAssertEqual(result.toInt(), 0xffFF_FFFF)
  }

  func testColorRelativityMidgrayInBlack() {
    let colorToTest = midgray
    let hct = Hct.fromInt(colorToTest)

    let result = hct.inViewingConditions(ViewingConditions.make(backgroundLstar: 0))

    XCTAssertEqual(result.toInt(), 0xff60_5F5F)
  }

  func testColorRelativityMidgrayInWhite() {
    let colorToTest = midgray
    let hct = Hct.fromInt(colorToTest)

    let result = hct.inViewingConditions(ViewingConditions.make(backgroundLstar: 100))

    XCTAssertEqual(result.toInt(), 0xff8E_8E8E)
  }

  func testColorRelativityBlackInBlack() {
    let colorToTest = black
    let hct = Hct.fromInt(colorToTest)

    let result = hct.inViewingConditions(ViewingConditions.make(backgroundLstar: 0))

    XCTAssertEqual(result.toInt(), 0xff00_0000)
  }

  func testColorRelativityBlackInWhite() {
    let colorToTest = black
    let hct = Hct.fromInt(colorToTest)

    let result = hct.inViewingConditions(ViewingConditions.make(backgroundLstar: 100))

    XCTAssertEqual(result.toInt(), 0xff00_0000)
  }
}

private let black = 0xff00_0000
private let white = 0xffff_ffff
private let red = 0xffff_0000
private let green = 0xff00_ff00
private let blue = 0xff00_00ff
private let midgray = 0xff77_7777

private func colorIsOnBoundary(_ argb: Int) -> Bool {
  return ColorUtils.redFromArgb(argb) == 0 || ColorUtils.redFromArgb(argb) == 255
    || ColorUtils.greenFromArgb(argb) == 0 || ColorUtils.greenFromArgb(argb) == 255
    || ColorUtils.blueFromArgb(argb) == 0 || ColorUtils.blueFromArgb(argb) == 255
}

private func allColors() -> [Int] {
  var colors: [Int] = []
  for color in 0xFF00_0000...0xFFFF_FFFF {
    colors.append(color)
  }
  return colors
}
