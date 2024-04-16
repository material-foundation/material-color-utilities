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

/// A class containing a value that changes with the contrast level.
///
/// Usually represents the contrast requirements for a dynamic color on its
/// background. The four values correspond to values for contrast levels
/// -1.0, 0.0, 0.5, and 1.0, respectively.
public struct ContrastCurve {
  let low: Double
  let normal: Double
  let medium: Double
  let high: Double

  /// - Parameters:
  ///   - low: Value for contrast level -1.0
  ///   - normal: Value for contrast level 0.0
  ///   - medium: Value for contrast level 0.5
  ///   - high: Value for contrast level 1.0
  public init(_ low: Double, _ normal: Double, _ medium: Double, _ high: Double) {
    self.low = low
    self.normal = normal
    self.medium = medium
    self.high = high
  }

  /// Returns the value at a given contrast level.
  ///
  /// - Parameter contrastLevel: The contrast level. 0.0 is the default (normal);
  ///   -1.0 is the lowest; 1.0 is the highest.
  ///
  /// - Returns: The value. For contrast ratios, a number between 1.0 and 21.0.
  public func get(_ contrastLevel: Double) -> Double {
    if contrastLevel <= -1.0 {
      return self.low
    } else if contrastLevel < 0.0 {
      return MathUtils.lerp(self.low, self.normal, (contrastLevel - (-1)) / 1)
    } else if contrastLevel < 0.5 {
      return MathUtils.lerp(self.normal, self.medium, (contrastLevel - 0) / 0.5)
    } else if contrastLevel < 1.0 {
      return MathUtils.lerp(self.medium, self.high, (contrastLevel - 0.5) / 0.5)
    } else {
      return self.high
    }
  }
}
