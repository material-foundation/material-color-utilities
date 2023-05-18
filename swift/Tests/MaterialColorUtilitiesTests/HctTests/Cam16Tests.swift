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

final class Cam16Tests: XCTestCase {
  func testCam16() {
    let result0 = Cam16.fromInt(1_151_024_110)
    let result1 = Cam16.fromInt(2_599_766_946)
    let result2 = Cam16.fromInt(207_007_830)
    let result3 = Cam16.fromInt(2_178_068_049)
    let result4 = Cam16.fromInt(2_293_293_753)
    let result5 = Cam16.fromInt(2_127_352_735)
    let result6 = Cam16.fromInt(2_692_552_334)
    let result7 = Cam16.fromInt(481_692_528)
    let result8 = Cam16.fromInt(1_073_904_100)
    let result9 = Cam16.fromInt(3_734_873_206)

    XCTAssertEqual(result0.hue, 311.42806917590127, accuracy: 1e-7)
    XCTAssertEqual(result0.j, 39.80957637025326, accuracy: 1e-7)
    XCTAssertEqual(result0.q, 98.12583617460575, accuracy: 1e-7)
    XCTAssertEqual(result0.m, 64.10143150621671, accuracy: 1e-7)
    XCTAssertEqual(result0.s, 80.82434221770161, accuracy: 1e-7)
    XCTAssertEqual(result0.jstar, 52.927210914635715, accuracy: 1e-7)
    XCTAssertEqual(result0.astar, 26.14144025259719, accuracy: 1e-7)
    XCTAssertEqual(result0.bstar, -29.622376253821233, accuracy: 1e-7)
    XCTAssertEqual(result1.hue, 355.0503461678604, accuracy: 1e-7)
    XCTAssertEqual(result1.j, 52.56866623390567, accuracy: 1e-7)
    XCTAssertEqual(result1.q, 112.75948188554017, accuracy: 1e-7)
    XCTAssertEqual(result1.m, 64.2339418261725, accuracy: 1e-7)
    XCTAssertEqual(result1.s, 75.4754569748874, accuracy: 1e-7)
    XCTAssertEqual(result1.jstar, 65.32748230521139, accuracy: 1e-7)
    XCTAssertEqual(result1.astar, 39.413992608446186, accuracy: 1e-7)
    XCTAssertEqual(result1.bstar, -3.413381791164169, accuracy: 1e-7)
    XCTAssertEqual(result2.hue, 145.62456894249067, accuracy: 1e-7)
    XCTAssertEqual(result2.j, 53.54270205682524, accuracy: 1e-7)
    XCTAssertEqual(result2.q, 113.79933774011006, accuracy: 1e-7)
    XCTAssertEqual(result2.m, 45.67944977111023, accuracy: 1e-7)
    XCTAssertEqual(result2.s, 63.35641059229854, accuracy: 1e-7)
    XCTAssertEqual(result2.jstar, 66.20793233348957, accuracy: 1e-7)
    XCTAssertEqual(result2.astar, -25.83510432830831, accuracy: 1e-7)
    XCTAssertEqual(result2.bstar, 17.67339768662175, accuracy: 1e-7)
    XCTAssertEqual(result3.hue, 89.18218954198817, accuracy: 1e-7)
    XCTAssertEqual(result3.j, 64.64864806089051, accuracy: 1e-7)
    XCTAssertEqual(result3.q, 125.04585955071941, accuracy: 1e-7)
    XCTAssertEqual(result3.m, 31.023158944993195, accuracy: 1e-7)
    XCTAssertEqual(result3.s, 49.809060584658496, accuracy: 1e-7)
    XCTAssertEqual(result3.jstar, 75.66239905009027, accuracy: 1e-7)
    XCTAssertEqual(result3.astar, 0.3348706268561027, accuracy: 1e-7)
    XCTAssertEqual(result3.bstar, 23.45943416825876, accuracy: 1e-7)
    XCTAssertEqual(result4.hue, 154.90292039856698, accuracy: 1e-7)
    XCTAssertEqual(result4.j, 79.40954826675019, accuracy: 1e-7)
    XCTAssertEqual(result4.q, 138.58810463022758, accuracy: 1e-7)
    XCTAssertEqual(result4.m, 24.01419462632291, accuracy: 1e-7)
    XCTAssertEqual(result4.s, 41.62660916534058, accuracy: 1e-7)
    XCTAssertEqual(result4.jstar, 86.76592929927428, accuracy: 1e-7)
    XCTAssertEqual(result4.astar, -17.343486416766375, accuracy: 1e-7)
    XCTAssertEqual(result4.bstar, 8.123204738848699, accuracy: 1e-7)
    XCTAssertEqual(result5.hue, 119.29861501791848, accuracy: 1e-7)
    XCTAssertEqual(result5.j, 76.65379834326399, accuracy: 1e-7)
    XCTAssertEqual(result5.q, 136.16216008227642, accuracy: 1e-7)
    XCTAssertEqual(result5.m, 18.68775872501647, accuracy: 1e-7)
    XCTAssertEqual(result5.s, 37.04677374071979, accuracy: 1e-7)
    XCTAssertEqual(result5.jstar, 84.80635340083987, accuracy: 1e-7)
    XCTAssertEqual(result5.astar, -7.617941092812117, accuracy: 1e-7)
    XCTAssertEqual(result5.bstar, 13.575780288737059, accuracy: 1e-7)
    XCTAssertEqual(result6.hue, 327.9022451708669, accuracy: 1e-7)
    XCTAssertEqual(result6.j, 25.207401197509327, accuracy: 1e-7)
    XCTAssertEqual(result6.q, 78.0824855218106, accuracy: 1e-7)
    XCTAssertEqual(result6.m, 53.16273184281286, accuracy: 1e-7)
    XCTAssertEqual(result6.s, 82.51384599304502, accuracy: 1e-7)
    XCTAssertEqual(result6.jstar, 36.425276182524954, accuracy: 1e-7)
    XCTAssertEqual(result6.astar, 29.499403055932383, accuracy: 1e-7)
    XCTAssertEqual(result6.bstar, -18.50332986780255, accuracy: 1e-7)
    XCTAssertEqual(result7.hue, 355.279570048603, accuracy: 1e-7)
    XCTAssertEqual(result7.j, 33.2614419664756, accuracy: 1e-7)
    XCTAssertEqual(result7.q, 89.69332605634818, accuracy: 1e-7)
    XCTAssertEqual(result7.m, 64.28874467824023, accuracy: 1e-7)
    XCTAssertEqual(result7.s, 84.6617825549819, accuracy: 1e-7)
    XCTAssertEqual(result7.jstar, 45.865567063105644, accuracy: 1e-7)
    XCTAssertEqual(result7.astar, 39.449488663086846, accuracy: 1e-7)
    XCTAssertEqual(result7.bstar, -3.257500355999049, accuracy: 1e-7)
    XCTAssertEqual(result8.hue, 261.1968416808902, accuracy: 1e-7)
    XCTAssertEqual(result8.j, 40.7183615122085, accuracy: 1e-7)
    XCTAssertEqual(result8.q, 99.23953929867855, accuracy: 1e-7)
    XCTAssertEqual(result8.m, 49.66881860103603, accuracy: 1e-7)
    XCTAssertEqual(result8.s, 70.74561810312906, accuracy: 1e-7)
    XCTAssertEqual(result8.jstar, 53.86745346363419, accuracy: 1e-7)
    XCTAssertEqual(result8.astar, -5.083026592209834, accuracy: 1e-7)
    XCTAssertEqual(result8.bstar, -32.82238686945024, accuracy: 1e-7)
    XCTAssertEqual(result9.hue, 119.84832142132542, accuracy: 1e-7)
    XCTAssertEqual(result9.j, 56.17844931089786, accuracy: 1e-7)
    XCTAssertEqual(result9.q, 116.56669043770763, accuracy: 1e-7)
    XCTAssertEqual(result9.m, 17.906925043592874, accuracy: 1e-7)
    XCTAssertEqual(result9.s, 39.19433269789186, accuracy: 1e-7)
    XCTAssertEqual(result9.jstar, 68.547225856322, accuracy: 1e-7)
    XCTAssertEqual(result9.astar, -7.47360894560527, accuracy: 1e-7)
    XCTAssertEqual(result9.bstar, 13.024174399350978, accuracy: 1e-7)
  }
}
