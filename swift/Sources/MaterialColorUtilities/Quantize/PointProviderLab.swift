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

public class PointProviderLab: PointProvider {
  public init() {}

  public func fromInt(_ argb: Int) -> [Double] {
    return ColorUtils.labFromArgb(argb)
  }

  public func toInt(_ lab: [Double]) -> Int {
    return ColorUtils.argbFromLab(lab[0], lab[1], lab[2])
  }

  public func distance(_ one: [Double], _ two: [Double]) -> Double {
    let dL = (one[0] - two[0])
    let dA = (one[1] - two[1])
    let dB = (one[2] - two[2])
    // Standard CIE 1976 delta E formula also takes the square root, unneeded
    // here. This method is used by quantization algorithms to compare distance,
    // and the relative ordering is the same, with or without a square root.

    // This relatively minor optimization is helpful because this method is
    // called at least once for each pixel in an image.
    return (dL * dL + dA * dA + dB * dB)
  }

  /// `ColorUtils.linearized` of each 8-bit channel value.
  private static let linearizedChannels: [Double] = (0..<256).map { ColorUtils.linearized($0) }

  /// Converts a color to L*a*b* as `ColorUtils.labFromArgb`, with bit-identical results, and
  /// writes L*, a* and b* to `lab` at `offset`, `offset + 1` and `offset + 2`.
  ///
  /// Each channel is linearized with a lookup table instead of `pow`, and no array is allocated
  /// for the result.
  static func labFromArgb(_ argb: Int, into lab: inout [Double], at offset: Int) {
    let linearR = linearizedChannels[ColorUtils.redFromArgb(argb)]
    let linearG = linearizedChannels[ColorUtils.greenFromArgb(argb)]
    let linearB = linearizedChannels[ColorUtils.blueFromArgb(argb)]
    // The same operations, in the same order, as in `ColorUtils.labFromArgb`.
    let matrix = ColorUtils.srgbToXyz
    let x = matrix[0][0] * linearR + matrix[0][1] * linearG + matrix[0][2] * linearB
    let y = matrix[1][0] * linearR + matrix[1][1] * linearG + matrix[1][2] * linearB
    let z = matrix[2][0] * linearR + matrix[2][1] * linearG + matrix[2][2] * linearB
    let whitePoint = ColorUtils.whitePointD65
    let xNormalized = x / whitePoint[0]
    let yNormalized = y / whitePoint[1]
    let zNormalized = z / whitePoint[2]
    let fx = ColorUtils.labF(xNormalized)
    let fy = ColorUtils.labF(yNormalized)
    let fz = ColorUtils.labF(zNormalized)
    lab[offset] = 116 * fy - 16
    lab[offset + 1] = 500 * (fx - fy)
    lab[offset + 2] = 200 * (fy - fz)
  }
}
