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

import 'package:material_color_utilities/score/score.dart';
import 'package:test/test.dart';

void main() {
  test('prioritizes chroma when proportions equal', () async {
    final colorsToPopulation = <int, int>{
      0xffff0000: 1,
      0xff00ff00: 1,
      0xff0000ff: 1
    };
    final ranked = Score.score(colorsToPopulation);

    expect(ranked[0], equals(0xffff0000));
    expect(ranked[1], equals(0xff00ff00));
    expect(ranked[2], equals(0xff0000ff));
  });

  test('generates gBlue when no colors available', () async {
    final colorsToPopulation = <int, int>{0xff000000: 1};
    final ranked = Score.score(colorsToPopulation);

    expect(ranked[0], equals(0xff4285F4));
  });

  test('dedupes nearby hues', () async {
    final colorsToPopulation = <int, int>{
      0xff008772: 1, // H 180 C 42 T 50
      0xff318477: 1 // H 184 C 35 T 50
    };
    final ranked = Score.score(colorsToPopulation);

    expect(ranked.length, equals(1));
    expect(ranked[0], equals(0xff008772));
  });
}
