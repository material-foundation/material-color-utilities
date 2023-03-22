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

import 'package:material_color_utilities/dislike/dislike_analyzer.dart';
import 'package:material_color_utilities/hct/hct.dart';
import 'package:test/test.dart';

void main() {
  group(DislikeAnalyzer, () {
    test('Monk Skin Tone Scale colors liked', () {
      // From https://skintone.google#/get-started
      final monkSkinToneScaleColors = <int>[
        0xfff6ede4,
        0xfff3e7db,
        0xfff7ead0,
        0xffeadaba,
        0xffd7bd96,
        0xffa07e56,
        0xff825c43,
        0xff604134,
        0xff3a312a,
        0xff292420,
      ];
      for (var color in monkSkinToneScaleColors) {
        expect(DislikeAnalyzer.isDisliked(Hct.fromInt(color)), false);
      }
    });

    test('bile colors disliked', () {
      final unlikable = <int>[
        0xff95884B,
        0xff716B40,
        0xffB08E00,
        0xff4C4308,
        0xff464521,
      ];
      for (var color in unlikable) {
        expect(DislikeAnalyzer.isDisliked(Hct.fromInt(color)), true,
            reason: '$color was likable');
      }
    });

    test('bile colors became likable', () {
      final unlikable = <int>[
        0xff95884B,
        0xff716B40,
        0xffB08E00,
        0xff4C4308,
        0xff464521,
      ];
      for (var color in unlikable) {
        final hct = Hct.fromInt(color);
        expect(DislikeAnalyzer.isDisliked(hct), true);
        final likable = DislikeAnalyzer.fixIfDisliked(hct);
        expect(DislikeAnalyzer.isDisliked(likable), false);
      }
    });

    test('tone 67 not disliked', () {
      final color = Hct.from(100.0, 50.0, 67.0);
      expect(DislikeAnalyzer.isDisliked(color), false);
      expect(DislikeAnalyzer.fixIfDisliked(color).toInt(), color.toInt());
    });
  });
}
