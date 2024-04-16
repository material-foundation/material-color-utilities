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

/// HCT, hue, chroma, and tone. A color system that provides a perceptually
/// accurate color measurement system that can also accurately render what
/// colors will appear as in different lighting environments.
public class Hct: Equatable, Hashable {
  private var _hue: Double
  private var _chroma: Double
  private var _tone: Double
  private var _argb: Int

  /// A number, in degrees, representing ex. red, orange, yellow, etc.
  /// Ranges from 0 <= [hue] < 360
  ///
  /// 0 <= [newHue] < 360; invalid values are corrected.
  /// After setting hue, the color is mapped from HCT to the more
  /// limited sRGB gamut for display. This will change its ARGB/integer
  /// representation. If the HCT color is outside of the sRGB gamut, chroma
  /// will decrease until it is inside the gamut.
  public var hue: Double {
    get { return _hue }
    set {
      _argb = HctSolver.solveToInt(newValue, chroma, tone)
      let cam16 = Cam16.fromInt(_argb)
      _hue = cam16.hue
      _chroma = cam16.chroma
      _tone = ColorUtils.lstarFromArgb(_argb)
    }
  }

  /// 0 <= [newChroma] <= ?
  /// After setting chroma, the color is mapped from HCT to the more
  /// limited sRGB gamut for display. This will change its ARGB/integer
  /// representation. If the HCT color is outside of the sRGB gamut, chroma
  /// will decrease until it is inside the gamut.
  public var chroma: Double {
    get { return _chroma }
    set {
      _argb = HctSolver.solveToInt(hue, newValue, tone)
      let cam16 = Cam16.fromInt(_argb)
      _hue = cam16.hue
      _chroma = cam16.chroma
      _tone = ColorUtils.lstarFromArgb(_argb)
    }
  }

  /// Lightness. Ranges from 0 to 100.
  ///
  /// 0 <= [newTone] <= 100; invalid values are corrected.
  /// After setting tone, the color is mapped from HCT to the more
  /// limited sRGB gamut for display. This will change its ARGB/integer
  /// representation. If the HCT color is outside of the sRGB gamut, chroma
  /// will decrease until it is inside the gamut.
  public var tone: Double {
    get { return _tone }
    set {
      _argb = HctSolver.solveToInt(hue, chroma, newValue)
      let cam16 = Cam16.fromInt(_argb)
      _hue = cam16.hue
      _chroma = cam16.chroma
      _tone = ColorUtils.lstarFromArgb(_argb)
    }
  }

  public init(_ argb: Int) {
    self._argb = argb
    let cam16 = Cam16.fromInt(argb)
    self._hue = cam16.hue
    self._chroma = cam16.chroma
    self._tone = ColorUtils.lstarFromArgb(argb)
  }

  /// 0 <= [hue] < 360; invalid values are corrected.
  /// 0 <= [chroma] <= ?; Informally, colorfulness. The color returned may be
  ///    lower than the requested chroma. Chroma has a different maximum for any
  ///    given hue and tone.
  /// 0 <= [tone] <= 100; informally, lightness. Invalid values are corrected.
  public static func from(_ hue: Double, _ chroma: Double, _ tone: Double) -> Hct {
    let argb = HctSolver.solveToInt(hue, chroma, tone)
    return Hct(argb)
  }

  func isEqual(to other: Hct) -> Bool {
    return _argb == other._argb
  }

  public static func == (lhs: Hct, rhs: Hct) -> Bool {
    return type(of: lhs) == type(of: rhs) && lhs.isEqual(to: rhs)
  }

  public func hash(into hasher: inout Hasher) {
    hasher.combine(_argb)
  }

  public var description: String {
    return "H\(round(hue)) C\(round(chroma)) T\(round(tone))"
  }

  /// HCT representation of [argb].
  public static func fromInt(_ argb: Int) -> Hct {
    return Hct(argb)
  }

  func toInt() -> Int {
    return _argb
  }

  /// Translate a color into different [ViewingConditions].
  ///
  /// Colors change appearance. They look different with lights on versus off,
  /// the same color, as in hex code, on white looks different when on black.
  /// This is called color relativity, most famously explicated by Josef Albers
  /// in Interaction of Color.
  ///
  /// In color science, color appearance models can account for this and
  /// calculate the appearance of a color in different settings. HCT is based on
  /// CAM16, a color appearance model, and uses it to make these calculations.
  ///
  /// See [ViewingConditions.make] for parameters affecting color appearance.
  public func inViewingConditions(_ vc: ViewingConditions) -> Hct {
    // 1. Use CAM16 to find XYZ coordinates of color in specified VC.
    let cam16 = Cam16.fromInt(toInt())
    let viewedInVc = cam16.xyzInViewingConditions(vc)

    // 2. Create CAM16 of those XYZ coordinates in default VC.
    let recastInVc = Cam16.fromXyzInViewingConditions(
      viewedInVc[0],
      viewedInVc[1],
      viewedInVc[2],
      ViewingConditions.make()
    )

    // 3. Create HCT from:
    // - CAM16 using default VC with XYZ coordinates in specified VC.
    // - L* converted from Y in XYZ coordinates in specified VC.
    let recastHct = Hct.from(
      recastInVc.hue,
      recastInVc.chroma,
      ColorUtils.lstarFromY(viewedInVc[1])
    )
    return recastHct
  }
}
