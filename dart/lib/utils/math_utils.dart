// Copyright 2021 Google LLC
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

class MathUtils {
  static double lerp(double start, double stop, double amount) {
    return (1.0 - amount) * start + amount * stop;
  }

  /// Multiply a 3 vector by a 3x3 matrix. */
  static List<double> matrixMultiply(
      List<double> row, List<List<double>> matrix) {
    return <double>[
      (row[0] * matrix[0][0]) +
          (row[1] * matrix[0][1]) +
          (row[2] * matrix[0][2]),
      (row[0] * matrix[1][0]) +
          (row[1] * matrix[1][1]) +
          (row[2] * matrix[1][2]),
      (row[0] * matrix[2][0]) +
          (row[1] * matrix[2][1]) +
          (row[2] * matrix[2][2]),
    ];
  }

  static double signum(double number) {
    if (number < 0.0) {
      return -1.0;
    } else if (number == 0.0) {
      return 0.0;
    } else {
      return 1.0;
    }
  }

  static double differenceDegrees(double a, double b) {
    return 180.0 - ((a - b).abs() - 180.0).abs();
  }

  static int clamp(int min, int max, double input) {
    return input > max
        ? max
        : input < min
            ? min
            : input.round();
  }

  static double clampDouble(double min, double max, double input) {
    return input > max
        ? max
        : input < min
            ? min
            : input;
  }

  static double sanitizeDegreesDouble(double degrees) {
    var answer = 0.0;
    if (degrees < 0) {
      if (degrees < -360) {
        answer = (answer % 360) + 360;
      } else {
        answer = degrees + 360;
      }
    } else if (degrees >= 360) {
      answer = degrees % 360;
    } else {
      answer = degrees;
    }
    assert(answer >= 0, 'turned $degrees into $answer, shouldn\'t be < 0');
    assert(answer < 360, 'turned $degrees into $answer, shouldn\'t be >= 360');
    return answer;
  }

  static int sanitizeDegrees(int degrees) {
    var answer = 0;
    if (degrees < 0) {
      if (degrees < -360) {
        answer = (answer % 360) + 360;
      } else {
        answer = degrees + 360;
      }
    } else if (degrees >= 360) {
      answer = degrees % 360;
    } else {
      answer = degrees;
    }
    assert(answer >= 0, 'turned $degrees into $answer, shouldn\'t be < 0');
    assert(answer < 360, 'turned $degrees into $answer, shouldn\'t be >= 360');
    return answer;
  }
}
