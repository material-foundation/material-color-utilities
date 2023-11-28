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

import 'package:material_color_utilities/utils/math_utils.dart';

/// A class containing a value that changes with the contrast level.
///
/// Usually represents the contrast requirements for a dynamic color on its
/// background. The four values correspond to values for contrast levels
/// -1.0, 0.0, 0.5, and 1.0, respectively.
class ContrastCurve {
  final double low;
  final double normal;
  final double medium;
  final double high;

  /// Creates a `ContrastCurve` object.
  ///
  /// [low] Value for contrast level -1.0
  /// [normal] Value for contrast level 0.0
  /// [medium] Value for contrast level 0.5
  /// [high] Value for contrast level 1.0
  ContrastCurve(
    this.low,
    this.normal,
    this.medium,
    this.high,
  );

  /// Returns the value at a given contrast level.
  ///
  /// [contrastLevel] The contrast level. 0.0 is the default (normal);
  /// -1.0 is the lowest; 1.0 is the highest.
  /// Returns the value. For contrast ratios, a number between 1.0 and 21.0.
  double get(double contrastLevel) {
    if (contrastLevel <= -1.0) {
      return low;
    } else if (contrastLevel < 0.0) {
      return MathUtils.lerp(low, normal, (contrastLevel - (-1)) / 1);
    } else if (contrastLevel < 0.5) {
      return MathUtils.lerp(normal, medium, (contrastLevel - 0) / 0.5);
    } else if (contrastLevel < 1.0) {
      return MathUtils.lerp(medium, high, (contrastLevel - 0.5) / 0.5);
    } else {
      return high;
    }
  }
}
