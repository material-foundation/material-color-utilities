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

import 'package:material_color_utilities/utils/math_utils.dart';
import 'package:test/test.dart';

// Original implementation for MathUtils.rotationDirection.
// Included here to test equivalence with new implementation.
double _rotationDirection(double from, double to) {
  final a = to - from;
  final b = to - from + 360.0;
  final c = to - from - 360.0;
  final aAbs = a.abs();
  final bAbs = b.abs();
  final cAbs = c.abs();
  if (aAbs <= bAbs && aAbs <= cAbs) {
    return a >= 0.0 ? 1.0 : -1.0;
  } else if (bAbs <= aAbs && bAbs <= cAbs) {
    return b >= 0.0 ? 1.0 : -1.0;
  } else {
    return c >= 0.0 ? 1.0 : -1.0;
  }
}

void main() {
  test('rotationDirection behaves correctly', () {
    for (double from = 0.0; from < 360.0; from += 15.0) {
      for (double to = 7.5; to < 360.0; to += 15.0) {
        double expectedAnswer = _rotationDirection(from, to);
        double actualAnswer = MathUtils.rotationDirection(from, to);
        expect(
          actualAnswer,
          expectedAnswer,
          reason: 'should be $expectedAnswer from $from to $to',
        );
        expect(
          actualAnswer.abs(),
          1.0,
          reason: 'should be either +1.0 or -1.0'
              'from $from to $to (got $actualAnswer)',
        );
      }
    }
  });
}
