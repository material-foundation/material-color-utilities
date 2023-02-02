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
import 'package:material_color_utilities/contrast/contrast.dart';
import 'package:test/test.dart';

void main() {
  test('ratioOfTones_outOfBoundsInput', () {
    expect(21.0, closeTo(Contrast.ratioOfTones(-10.0, 110.0), 0.001));
  });

  test('lighter_impossibleRatioErrors', () {
    expect(-1.0, closeTo(Contrast.lighter(tone: 90.0, ratio: 10.0), 0.001));
  });

  test('lighter_outOfBoundsInputAboveErrors', () {
    expect(-1.0, closeTo(Contrast.lighter(tone: 110.0, ratio: 2.0), 0.001));
  });

  test('lighter_outOfBoundsInputBelowErrors', () {
    expect(-1.0, closeTo(Contrast.lighter(tone: -10.0, ratio: 2.0), 0.001));
  });

  test('lighterUnsafe_returnsMaxTone', () {
    expect(
        100, closeTo(Contrast.lighterUnsafe(tone: 100.0, ratio: 2.0), 0.001));
  });

  test('darker_impossibleRatioErrors', () {
    expect(-1.0, closeTo(Contrast.darker(tone: 10.0, ratio: 20.0), 0.001));
  });

  test('darker_outOfBoundsInputAboveErrors', () {
    expect(-1.0, closeTo(Contrast.darker(tone: 110.0, ratio: 2.0), 0.001));
  });

  test('darker_outOfBoundsInputBelowErrors', () {
    expect(-1.0, closeTo(Contrast.darker(tone: -10.0, ratio: 2.0), 0.001));
  });

  test('darkerUnsafe_returnsMinTone', () {
    expect(0.0, closeTo(Contrast.darkerUnsafe(tone: 0.0, ratio: 2.0), 0.001));
  });
}
