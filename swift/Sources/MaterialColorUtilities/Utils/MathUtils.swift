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

public class MathUtils {
  /// The signum function.
  ///
  /// Returns 1 if num > 0, -1 if num < 0, and 0 if num = 0
  @inlinable public static func signum(_ value: Double) -> Int {
    if value < 0 {
      return -1
    } else if value == 0 {
      return 0
    } else {
      return 1
    }
  }

  /// The linear interpolation function.
  ///
  /// Returns start if amount = 0 and stop if amount = 1
  @inlinable public static func lerp(_ start: Double, _ stop: Double, _ amount: Double) -> Double {
    return (1 - amount) * start + amount * stop
  }

  /// Clamps an integer between two integers.
  ///
  /// Returns input when min <= input <= max, and either min or max
  /// otherwise.
  @inlinable public static func clampInt(_ min: Int, _ max: Int, _ input: Int) -> Int {
    if input < min {
      return min
    } else if input > max {
      return max
    }
    return input
  }

  /// Clamps an floating-point between two floating-point numbers.
  ///
  /// Returns input when min <= input <= max, and either min or max
  /// otherwise.
  @inlinable public static func clampDouble(_ min: Double, _ max: Double, _ input: Double) -> Double
  {
    if input < min {
      return min
    } else if input > max {
      return max
    }
    return input

  }

  /// Sanitizes a degree measure as an integer.
  ///
  /// Returns a degree measure between 0 (inclusive) and 360
  /// (exclusive).
  @inlinable public static func sanitizeDegreesInt(_ degrees: Int) -> Int {
    var degrees = degrees % 360
    if degrees < 0 {
      degrees = degrees + 360
    }
    return degrees
  }

  /// Sanitizes a degree measure as a floating-point number.
  ///
  /// Returns a degree measure between 0.0 (inclusive) and 360.0
  /// (exclusive).
  @inlinable public static func sanitizeDegreesDouble(_ degrees: Double) -> Double {
    var degrees = degrees.truncatingRemainder(dividingBy: 360)
    if degrees < 0 {
      degrees = degrees + 360
    }
    return degrees
  }

  /// Sign of direction change needed to travel from one angle to
  /// another.
  ///
  /// For angles that are 180 degrees apart from each other, both
  /// directions have the same travel distance, so either direction is
  /// shortest. The value 1.0 is returned in this case.
  ///
  /// [from] The angle travel starts from, in degrees.
  /// [to] The angle travel ends at, in degrees.
  /// Returns -1 if decreasing from leads to the shortest travel
  /// distance, 1 if increasing from leads to the shortest travel
  /// distance.
  @inlinable public static func rotationDirection(_ from: Double, _ to: Double) -> Double {
    let increasingDifference = sanitizeDegreesDouble(to - from)
    return increasingDifference <= 180 ? 1 : -1
  }

  /// Distance of two points on a circle, represented using degrees.
  @inlinable public static func differenceDegrees(_ a: Double, _ b: Double) -> Double {
    return 180 - abs(abs(a - b) - 180)
  }

  /// Multiplies a 1x3 row vector with a 3x3 matrix.
  @inlinable public static func matrixMultiply(_ row: [Double], _ matrix: [[Double]]) -> [Double] {
    let a = row[0] * matrix[0][0] + row[1] * matrix[0][1] + row[2] * matrix[0][2]
    let b = row[0] * matrix[1][0] + row[1] * matrix[1][1] + row[2] * matrix[1][2]
    let c = row[0] * matrix[2][0] + row[1] * matrix[2][1] + row[2] * matrix[2][2]
    return [a, b, c]
  }
}
