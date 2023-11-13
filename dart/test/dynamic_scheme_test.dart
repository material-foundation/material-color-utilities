import 'package:material_color_utilities/dynamiccolor/dynamic_scheme.dart';
import 'package:material_color_utilities/hct/hct.dart';
// Copyright 2022 Google LLC
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

import 'package:test/test.dart';

void main() {
  test('0 length input', () {
    final hue = DynamicScheme.getRotatedHue(Hct.from(43, 16, 16), [], []);
    expect(hue, closeTo(43, 1.0));
  });

  test('1 length input no rotation', () {
    final hue = DynamicScheme.getRotatedHue(Hct.from(43, 16, 16), [0], [0]);
    expect(hue, closeTo(43, 1.0));
  });

  test('input length mismatch asserts', () {
    expect(() {
      DynamicScheme.getRotatedHue(Hct.from(43, 16, 16), [0, 1], [0]);
    }, throwsA(TypeMatcher<AssertionError>()));
  });

  test('on boundary rotation correct', () {
    final hue = DynamicScheme.getRotatedHue(
      Hct.from(43, 16, 16),
      [0, 42, 360],
      [0, 15, 0],
    );
    expect(hue, closeTo(43 + 15, 1.0));
  });

  test('rotation result larger than 360 degrees wraps', () {
    final hue = DynamicScheme.getRotatedHue(
      Hct.from(43, 16, 16),
      [0, 42, 360],
      [0, 480, 0],
    );
    expect(hue, closeTo(163, 1.0));
  });
}
