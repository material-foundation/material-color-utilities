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

import './utils/color_matcher.dart';

void main() {
  test('prioritizes chroma', () async {
    final colorsToPopulation = <int, int>{
      0xff000000: 1,
      0xffffffff: 1,
      0xff0000ff: 1
    };
    final ranked = Score.score(colorsToPopulation, desired: 4);

    expect(ranked.length, equals(1));
    expect(ranked[0], isColor(0xff0000ff));
  });

  test('prioritizes chroma when proportions equal', () async {
    final colorsToPopulation = <int, int>{
      0xffff0000: 1,
      0xff00ff00: 1,
      0xff0000ff: 1
    };
    final ranked = Score.score(colorsToPopulation, desired: 4);

    expect(ranked.length, equals(3));
    expect(ranked[0], isColor(0xffff0000));
    expect(ranked[1], isColor(0xff00ff00));
    expect(ranked[2], isColor(0xff0000ff));
  });

  test('generates gBlue when no colors available', () async {
    final colorsToPopulation = <int, int>{0xff000000: 1};
    final ranked = Score.score(colorsToPopulation, desired: 4);

    expect(ranked.length, equals(1));
    expect(ranked[0], isColor(0xff4285f4));
  });

  test('dedupes nearby hues', () async {
    final colorsToPopulation = <int, int>{
      0xff008772: 1, // H 180 C 42 T 50
      0xff318477: 1 // H 184 C 35 T 50
    };
    final ranked = Score.score(colorsToPopulation, desired: 4);

    expect(ranked.length, equals(1));
    expect(ranked[0], isColor(0xff008772));
  });

  test('maximizes hue distance', () async {
    final colorsToPopulation = <int, int>{
      0xff008772: 1, // H 180 C 42 T 50
      0xff008587: 1, // H 198 C 50 T 50
      0xff007ebc: 1 // H 245 C 50 T 50
    };
    final ranked = Score.score(colorsToPopulation, desired: 2);
    expect(ranked.length, equals(2));
    expect(ranked[0], isColor(0xff007ebc));
    expect(ranked[1], isColor(0xff008772));
  });

  test('passes generated scenario one', () async {
    final colorsToPopulation = <int, int>{
      0xff7ea16d: 67,
      0xffd8ccae: 67,
      0xff835c0d: 49
    };

    final ranked = Score.score(colorsToPopulation,
        desired: 3, fallbackColorARGB: 0xff8d3819, filter: false);

    expect(ranked.length, equals(3));
    expect(ranked[0], isColor(0xff7ea16d));
    expect(ranked[1], isColor(0xffd8ccae));
    expect(ranked[2], isColor(0xff835c0d));
  });

  test('passes generated scenario two', () async {
    final colorsToPopulation = <int, int>{
      0xffd33881: 14,
      0xff3205cc: 77,
      0xff0b48cf: 36,
      0xffa08f5d: 81
    };

    final ranked = Score.score(colorsToPopulation,
        desired: 4, fallbackColorARGB: 0xff7d772b, filter: true);

    expect(ranked.length, equals(3));
    expect(ranked[0], isColor(0xff3205cc));
    expect(ranked[1], isColor(0xffa08f5d));
    expect(ranked[2], isColor(0xffd33881));
  });

  test('passes generated scenario three', () async {
    final colorsToPopulation = <int, int>{
      0xffbe94a6: 23,
      0xffc33fd7: 42,
      0xff899f36: 90,
      0xff94c574: 82
    };

    final ranked = Score.score(colorsToPopulation,
        desired: 3, fallbackColorARGB: 0xffaa79a4, filter: true);

    expect(ranked.length, equals(3));
    expect(ranked[0], isColor(0xff94c574));
    expect(ranked[1], isColor(0xffc33fd7));
    expect(ranked[2], isColor(0xffbe94a6));
  });

  test('passes generated scenario four', () async {
    final colorsToPopulation = <int, int>{
      0xffdf241c: 85,
      0xff685859: 44,
      0xffd06d5f: 34,
      0xff561c54: 27,
      0xff713090: 88
    };

    final ranked = Score.score(colorsToPopulation,
        desired: 5, fallbackColorARGB: 0xff58c19c, filter: false);

    expect(ranked.length, equals(2));
    expect(ranked[0], isColor(0xffdf241c));
    expect(ranked[1], isColor(0xff561c54));
  });

  test('passes generated scenario five', () async {
    final colorsToPopulation = <int, int>{
      0xffbe66f8: 41,
      0xff4bbda9: 88,
      0xff80f6f9: 44,
      0xffab8017: 43,
      0xffe89307: 65
    };

    final ranked = Score.score(colorsToPopulation,
        desired: 3, fallbackColorARGB: 0xff916691, filter: false);

    expect(ranked.length, equals(3));
    expect(ranked[0], isColor(0xffab8017));
    expect(ranked[1], isColor(0xff4bbda9));
    expect(ranked[2], isColor(0xffbe66f8));
  });

  test('passes generated scenario six', () async {
    final colorsToPopulation = <int, int>{
      0xff18ea8f: 93,
      0xff327593: 18,
      0xff066a18: 53,
      0xfffa8a23: 74,
      0xff04ca1f: 62
    };

    final ranked = Score.score(colorsToPopulation,
        desired: 2, fallbackColorARGB: 0xff4c377a, filter: false);

    expect(ranked.length, equals(2));
    expect(ranked[0], isColor(0xff18ea8f));
    expect(ranked[1], isColor(0xfffa8a23));
  });

  test('passes generated scenario seven', () async {
    final colorsToPopulation = <int, int>{
      0xff2e05ed: 23,
      0xff153e55: 90,
      0xff9ab220: 23,
      0xff153379: 66,
      0xff68bcc3: 81
    };

    final ranked = Score.score(colorsToPopulation,
        desired: 2, fallbackColorARGB: 0xfff588dc, filter: true);

    expect(ranked.length, equals(2));
    expect(ranked[0], isColor(0xff2e05ed));
    expect(ranked[1], isColor(0xff9ab220));
  });

  test('passes generated scenario eight', () async {
    final colorsToPopulation = <int, int>{
      0xff816ec5: 24,
      0xff6dcb94: 19,
      0xff3cae91: 98,
      0xff5b542f: 25
    };

    final ranked = Score.score(colorsToPopulation,
        desired: 1, fallbackColorARGB: 0xff84b0fd, filter: false);

    expect(ranked.length, equals(1));
    expect(ranked[0], isColor(0xff3cae91));
  });

  test('passes generated scenario nine', () async {
    final colorsToPopulation = <int, int>{
      0xff206f86: 52,
      0xff4a620d: 96,
      0xfff51401: 85,
      0xff2b8ebf: 3,
      0xff277766: 59
    };

    final ranked = Score.score(colorsToPopulation,
        desired: 3, fallbackColorARGB: 0xff02b415, filter: true);

    expect(ranked.length, equals(3));
    expect(ranked[0], isColor(0xfff51401));
    expect(ranked[1], isColor(0xff4a620d));
    expect(ranked[2], isColor(0xff2b8ebf));
  });

  test('passes generated scenario ten', () async {
    final colorsToPopulation = <int, int>{
      0xff8b1d99: 54,
      0xff27effe: 43,
      0xff6f558d: 2,
      0xff77fdf2: 78
    };

    final ranked = Score.score(colorsToPopulation,
        desired: 4, fallbackColorARGB: 0xff5e7a10, filter: true);

    expect(ranked.length, equals(3));
    expect(ranked[0], isColor(0xff27effe));
    expect(ranked[1], isColor(0xff8b1d99));
    expect(ranked[2], isColor(0xff6f558d));
  });
}
