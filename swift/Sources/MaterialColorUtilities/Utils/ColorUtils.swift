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

/// Color science utilities.
///
/// Utility methods for color science constants and color space
/// conversions that aren't HCT or CAM16.
public class ColorUtils {
  public static let srgbToXyz: [[Double]] = [
    [0.41233895, 0.35762064, 0.18051042],
    [0.2126, 0.7152, 0.0722],
    [0.01932141, 0.11916382, 0.95034478],
  ]

  public static let xyzToSrgb: [[Double]] = [
    [
      3.2413774792388685,
      -1.5376652402851851,
      -0.49885366846268053,
    ],
    [
      -0.9691452513005321,
      1.8758853451067872,
      0.04156585616912061,
    ],
    [
      0.05562093689691305,
      -0.20395524564742123,
      1.0571799111220335,
    ],
  ]

  /// Returns the standard white point; white on a sunny day.
  ///
  /// Returns The white point
  public static let whitePointD65: [Double] = [95.047, 100.0, 108.883]

  /// Converts a color from RGB components to ARGB format.
  @inlinable public static func argbFromRgb(_ red: Int, _ green: Int, _ blue: Int) -> Int {
    return 255 << 24 | (red & 255) << 16 | (green & 255) << 8 | blue & 255
  }

  /// Converts a color from linear RGB components to ARGB format.
  @inlinable public static func argbFromLinrgb(_ linrgb: [Double]) -> Int {
    let r = delinearized(linrgb[0])
    let g = delinearized(linrgb[1])
    let b = delinearized(linrgb[2])
    return argbFromRgb(r, g, b)
  }

  /// Returns the alpha component of a color in ARGB format.
  @inlinable public static func alphaFromArgb(_ argb: Int) -> Int {
    return argb >> 24 & 255
  }

  /// Returns the red component of a color in ARGB format.
  @inlinable public static func redFromArgb(_ argb: Int) -> Int {
    return argb >> 16 & 255
  }

  /// Returns the green component of a color in ARGB format.
  @inlinable public static func greenFromArgb(_ argb: Int) -> Int {
    return argb >> 8 & 255
  }

  /// Returns the blue component of a color in ARGB format.
  @inlinable public static func blueFromArgb(_ argb: Int) -> Int {
    return argb & 255
  }

  /// Returns whether a color in ARGB format is opaque.
  @inlinable public static func isOpaque(_ argb: Int) -> Bool {
    return alphaFromArgb(argb) >= 255
  }

  /// Converts a color from ARGB to XYZ.
  @inlinable public static func argbFromXyz(_ x: Double, _ y: Double, _ z: Double) -> Int {
    let matrix = xyzToSrgb
    let linearR = matrix[0][0] * x + matrix[0][1] * y + matrix[0][2] * z
    let linearG = matrix[1][0] * x + matrix[1][1] * y + matrix[1][2] * z
    let linearB = matrix[2][0] * x + matrix[2][1] * y + matrix[2][2] * z
    let r = delinearized(linearR)
    let g = delinearized(linearG)
    let b = delinearized(linearB)
    return argbFromRgb(r, g, b)
  }

  /// Converts a color from XYZ to ARGB.
  @inlinable public static func xyzFromArgb(_ argb: Int) -> [Double] {
    let r = linearized(redFromArgb(argb))
    let g = linearized(greenFromArgb(argb))
    let b = linearized(blueFromArgb(argb))
    return MathUtils.matrixMultiply([r, g, b], srgbToXyz)
  }

  /// Converts a color represented in Lab color space into an ARGB
  /// integer.
  @inlinable public static func argbFromLab(_ l: Double, _ a: Double, _ b: Double) -> Int {
    let whitePoint = whitePointD65
    let fy = (l + 16) / 116
    let fx = a / 500 + fy
    let fz = fy - b / 200
    let xNormalized = labInvf(fx)
    let yNormalized = labInvf(fy)
    let zNormalized = labInvf(fz)
    let x = xNormalized * whitePoint[0]
    let y = yNormalized * whitePoint[1]
    let z = zNormalized * whitePoint[2]
    return argbFromXyz(x, y, z)
  }

  /// Converts a color from ARGB representation to L*a*b*
  /// representation.
  ///
  /// [argb] the ARGB representation of a color
  /// Returns a Lab object representing the color
  @inlinable public static func labFromArgb(_ argb: Int) -> [Double] {
    let linearR = linearized(redFromArgb(argb))
    let linearG = linearized(greenFromArgb(argb))
    let linearB = linearized(blueFromArgb(argb))
    let matrix = srgbToXyz
    let x = matrix[0][0] * linearR + matrix[0][1] * linearG + matrix[0][2] * linearB
    let y = matrix[1][0] * linearR + matrix[1][1] * linearG + matrix[1][2] * linearB
    let z = matrix[2][0] * linearR + matrix[2][1] * linearG + matrix[2][2] * linearB
    let whitePoint = whitePointD65
    let xNormalized = x / whitePoint[0]
    let yNormalized = y / whitePoint[1]
    let zNormalized = z / whitePoint[2]
    let fx = labF(xNormalized)
    let fy = labF(yNormalized)
    let fz = labF(zNormalized)
    let l = 116 * fy - 16
    let a = 500 * (fx - fy)
    let b = 200 * (fy - fz)
    return [l, a, b]
  }

  /// Converts an L* value to an ARGB representation.
  ///
  /// [lstar] L* in L*a*b*
  /// Returns ARGB representation of grayscale color with lightness
  /// matching L*
  @inlinable public static func argbFromLstar(_ lstar: Double) -> Int {
    let y = yFromLstar(lstar)
    let component = delinearized(y)
    return argbFromRgb(component, component, component)
  }

  /// Computes the L* value of a color in ARGB representation.
  ///
  /// [argb] ARGB representation of a color
  /// Returns L*, from L*a*b*, coordinate of the color
  @inlinable public static func lstarFromArgb(_ argb: Int) -> Double {
    let y = xyzFromArgb(argb)[1]
    return 116 * labF(y / 100) - 16
  }

  /// Converts an L* value to a Y value.
  ///
  /// L* in L*a*b* and Y in XYZ measure the same quantity, luminance.
  ///
  /// L* measures perceptual luminance, a linear scale. Y in XYZ
  /// measures relative luminance, a logarithmic scale.
  ///
  /// [lstar] L* in L*a*b*
  /// Returns Y in XYZ
  @inlinable public static func yFromLstar(_ lstar: Double) -> Double {
    return 100 * labInvf((lstar + 16) / 116)
  }

  /// Converts a Y value to an L* value.
  ///
  /// L* in L*a*b* and Y in XYZ measure the same quantity, luminance.
  ///
  /// L* measures perceptual luminance, a linear scale. Y in XYZ
  /// measures relative luminance, a logarithmic scale.
  ///
  /// [y] Y in XYZ
  /// Returns L* in L*a*b*
  @inlinable public static func lstarFromY(_ y: Double) -> Double {
    return labF(y / 100) * 116 - 16
  }

  /// Linearizes an RGB component.
  ///
  /// [rgbComponent] 0 <= rgb_component <= 255, represents R/G/B
  /// channel
  /// Returns 0.0 <= output <= 100.0, color channel converted to
  /// linear RGB space
  @inlinable public static func linearized(_ rgbComponent: Int) -> Double {
    let normalized = Double(rgbComponent) / 255
    if normalized <= 0.040449936 {
      return normalized / 12.92 * 100
    } else {
      return pow((normalized + 0.055) / 1.055, 2.4) * 100
    }
  }

  /// Delinearizes an RGB component.
  ///
  /// [rgbComponent] 0.0 <= rgb_component <= 100.0, represents linear
  /// R/G/B channel
  /// Returns 0 <= output <= 255, color channel converted to regular
  /// RGB space
  @inlinable public static func delinearized(_ rgbComponent: Double) -> Int {
    let normalized = rgbComponent / 100
    var delinearlized: Double = 0
    if normalized <= 0.0031308 {
      delinearlized = normalized * 12.92
    } else {
      delinearlized = 1.055 * Double(pow(normalized, 1 / 2.4)) - 0.055
    }
    return MathUtils.clampInt(0, 255, Int(round(delinearlized * 255)))
  }

  public static func labF(_ t: Double) -> Double {
    let e = 216.0 / 24389.0
    let kappa = 24389.0 / 27.0
    if t > e {
      return pow(t, 1 / 3)
    } else {
      return (kappa * t + 16) / 116
    }
  }

  public static func labInvf(_ ft: Double) -> Double {
    let e = 216.0 / 24389.0
    let kappa = 24389.0 / 27.0
    let ft3 = ft * ft * ft  // pow(ft, 3)
    if ft3 > e {
      return ft3
    } else {
      return (116 * ft - 16) / kappa
    }
  }
}
