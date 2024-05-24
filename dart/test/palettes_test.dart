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

import 'package:material_color_utilities/hct/hct.dart';
import 'package:material_color_utilities/palettes/core_palette.dart';
import 'package:material_color_utilities/palettes/tonal_palette.dart';
import 'package:test/test.dart';

import './utils/color_matcher.dart';

void main() {
  group('TonalPalette', () {
    group('[.of and .fromList constructors]', () {
      // Regression test for https://github.com/material-foundation/material-color-utilities/issues/56
      test('operator ==', () {
        final a1 = TonalPalette.of(1, 1);
        final a2 = TonalPalette.of(1, 1);
        final b1 = TonalPalette.fromList(
            TonalPalette.commonTones.map((e) => 0xDEADBEEF).toList());
        final b2 = TonalPalette.fromList(
            TonalPalette.commonTones.map((e) => 0xDEADBEEF).toList());
        expect(a1 == b1, isFalse);
        expect(b1 == a1, isFalse);
        expect(a1 != b1, isTrue);
        expect(b1 != a1, isTrue);
        expect(a1 == a2, isTrue);
        expect(b1 == b2, isTrue);

        final c1 = TonalPalette.fromList(
            TonalPalette.commonTones.map((e) => 123).toList());

        final c2 = TonalPalette.fromList(
            TonalPalette.commonTones.map((e) => e < 15 ? 456 : 123).toList());

        expect(c1.get(50), c2.get(50));
        expect(c1 == c2, isFalse);
      });
    });

    group('[.of constructor]', () {
      test('tones of blue', () async {
        final hct = Hct.fromInt(0xff0000ff);
        final tones = TonalPalette.of(hct.hue, hct.chroma);

        expect(tones.get(0), 0xff000000);
        expect(tones.get(10), 0xff00006e);
        expect(tones.get(20), 0xff0001ac);
        expect(tones.get(30), 0xff0000ef);
        expect(tones.get(40), 0xff343dff);
        expect(tones.get(50), 0xff5a64ff);
        expect(tones.get(60), 0xff7c84ff);
        expect(tones.get(70), 0xff9da3ff);
        expect(tones.get(80), 0xffbec2ff);
        expect(tones.get(90), 0xffe0e0ff);
        expect(tones.get(95), 0xfff1efff);
        expect(tones.get(99), 0xfffffbff);
        expect(tones.get(100), 0xffffffff);

        /// Tone not in [TonalPalette.commonTones]
        expect(tones.get(3), 0xff00003c);
      });

      test('asList', () {
        final hct = Hct.fromInt(0xff0000ff);
        final tones = TonalPalette.of(hct.hue, hct.chroma);

        expect(tones.asList, [
          0xff000000,
          0xff00006e,
          0xff0001ac,
          0xff0000ef,
          0xff343dff,
          0xff5a64ff,
          0xff7c84ff,
          0xff9da3ff,
          0xffbec2ff,
          0xffe0e0ff,
          0xfff1efff,
          0xfffffbff,
          0xffffffff,
        ]);
      });

      test('operator == and hashCode', () {
        final hctAB = Hct.fromInt(0xff0000ff);
        final tonesA = TonalPalette.of(hctAB.hue, hctAB.chroma);
        final tonesB = TonalPalette.of(hctAB.hue, hctAB.chroma);
        final hctC = Hct.fromInt(0xff123456);
        final tonesC = TonalPalette.of(hctC.hue, hctC.chroma);

        expect(tonesA, tonesB);
        expect(tonesB, isNot(tonesC));

        expect(tonesA.hashCode, tonesB.hashCode);
        expect(tonesB.hashCode, isNot(tonesC.hashCode));
      });
    });

    group('[.fromList constructor]', () {
      final hueChromaPalette = TonalPalette.of(270, 36);
      final cachedPalette =
          TonalPalette.commonTones.map(hueChromaPalette.get).toList();
      final brokenPalette = [
        cachedPalette[0],
        cachedPalette[1],
        Hct.from(180, 24, 20).toInt(),
        cachedPalette[3],
        cachedPalette[4],
        cachedPalette[5],
        cachedPalette[6],
        cachedPalette[7],
        cachedPalette[8],
        Hct.from(0, 12, 90).toInt(),
        cachedPalette[10],
        cachedPalette[11],
        cachedPalette[12],
      ];

      final rebuiltPalette = TonalPalette.fromList(brokenPalette);

      test('correctly deduces original hue and chroma', () {
        expect(rebuiltPalette.hue, closeTo(270, 1));
        expect(rebuiltPalette.chroma, closeTo(36, 1));
      });

      test('low-chroma noise does not affect the hue and chroma deduced', () {
        final rebuiltCleanPalette = TonalPalette.fromList(cachedPalette);

        expect(rebuiltPalette.hue, rebuiltCleanPalette.hue);
        expect(rebuiltPalette.chroma, rebuiltCleanPalette.chroma);
      });

      test('returns cached colors when possible', () {
        expect(rebuiltPalette.get(20), isColor(brokenPalette[2]));
        expect(rebuiltPalette.get(50), isColor(brokenPalette[5]));
        expect(rebuiltPalette.get(90), isColor(brokenPalette[9]));
        expect(rebuiltPalette.get(99), isColor(brokenPalette[11]));
      });

      test('correctly deduces colors at other tones', () {
        expect(
          rebuiltPalette.get(15),
          isCloseToColor(hueChromaPalette.get(15)),
        );
        expect(
          rebuiltPalette.get(53),
          isCloseToColor(hueChromaPalette.get(53)),
        );
        expect(
          rebuiltPalette.get(78),
          isCloseToColor(hueChromaPalette.get(78)),
        );
      });

      test('deduced colors have correct tone', () {
        expect(rebuiltPalette.getHct(15).tone, closeTo(15, 1));
        expect(rebuiltPalette.getHct(53).tone, closeTo(53, 1));
        expect(rebuiltPalette.getHct(78).tone, closeTo(78, 1));
      });

      test('asList', () {
        final ints = List.generate(TonalPalette.commonSize, (i) => i);
        final tones = TonalPalette.fromList(ints);
        expect(tones.asList, ints);
      });

      test('operator == and hashCode', () {
        // This test confirms that `==` and `hashCode` behave the way they are
        // expected to behave. By defining five palettes, three from hue and
        // chroma, and two from lists, we expect their `hashCode` to be
        // distinct, and that their equality should satisfy the following grid:
        //
        // ==? 1   2   3   4   5
        // 1   YES -   -   YES -
        // 2   -   YES -   -   -
        // 3   -   -   YES -   -
        // 4   YES -   -   YES -
        // 5   -   -   -   -   YES

        final palette1 = TonalPalette.of(270, 36);
        final palette2 = TonalPalette.of(180, 36);
        final palette3 = TonalPalette.of(270, 12);

        final palette4 = TonalPalette.fromList(palette1.asList);
        final brokenList = [...palette1.asList];
        brokenList[2] = Hct.from(180, 24, 20).toInt();
        brokenList[9] = Hct.from(0, 12, 90).toInt();
        final palette5 = TonalPalette.fromList(brokenList);

        expect(palette1, palette1);
        expect(palette1, isNot(palette2));
        expect(palette1, isNot(palette3));
        expect(palette1, palette4);
        expect(palette1, isNot(palette5));

        expect(palette2, isNot(palette1));
        expect(palette2, palette2);
        expect(palette2, isNot(palette3));
        expect(palette2, isNot(palette4));
        expect(palette2, isNot(palette5));

        expect(palette3, isNot(palette1));
        expect(palette3, isNot(palette2));
        expect(palette3, palette3);
        expect(palette3, isNot(palette4));
        expect(palette3, isNot(palette5));

        expect(palette4, palette1);
        expect(palette4, isNot(palette2));
        expect(palette4, isNot(palette3));
        expect(palette4, palette4);
        expect(palette4, isNot(palette5));

        expect(palette5, isNot(palette1));
        expect(palette5, isNot(palette2));
        expect(palette5, isNot(palette3));
        expect(palette5, isNot(palette4));
        expect(palette5, palette5);

        // They should have five distinct hash codes (ignoring hash collision).
        final hashCodes = [palette1, palette2, palette3, palette4, palette5]
            .map((x) => x.hashCode)
            .toSet()
            .toList();
        expect(hashCodes, hasLength(5));
      });
    });
  });

  group('CorePalette', () {
    test('asList', () {
      final ints =
          List.generate(CorePalette.size * TonalPalette.commonSize, (i) => i);
      final corePalette = CorePalette.fromList(ints);
      expect(corePalette.asList(), ints);
    });

    test('operator == and hashCode', () {
      final corePaletteA = CorePalette.of(0xff0000ff);
      final corePaletteB = CorePalette.of(0xff0000ff);
      final corePaletteC = CorePalette.of(0xff123456);

      expect(corePaletteA, corePaletteB);
      expect(corePaletteB, isNot(corePaletteC));

      expect(corePaletteA.hashCode, corePaletteB.hashCode);
      expect(corePaletteB.hashCode, isNot(corePaletteC.hashCode));
    });

    test('of blue', () {
      final core = CorePalette.of(0xff0000ff);

      expect(core.primary.get(100), 0xffffffff);
      expect(core.primary.get(95), 0xfff1efff);
      expect(core.primary.get(90), 0xffe0e0ff);
      expect(core.primary.get(80), 0xffbec2ff);
      expect(core.primary.get(70), 0xff9da3ff);
      expect(core.primary.get(60), 0xff7c84ff);
      expect(core.primary.get(50), 0xff5a64ff);
      expect(core.primary.get(40), 0xff343dff);
      expect(core.primary.get(30), 0xff0000ef);
      expect(core.primary.get(20), 0xff0001ac);
      expect(core.primary.get(10), 0xff00006e);
      expect(core.primary.get(0), 0xff000000);
      expect(core.secondary.get(100), 0xffffffff);
      expect(core.secondary.get(95), 0xfff1efff);
      expect(core.secondary.get(90), 0xffe1e0f9);
      expect(core.secondary.get(80), 0xffc5c4dd);
      expect(core.secondary.get(70), 0xffa9a9c1);
      expect(core.secondary.get(60), 0xff8f8fa6);
      expect(core.secondary.get(50), 0xff75758b);
      expect(core.secondary.get(40), 0xff5c5d72);
      expect(core.secondary.get(30), 0xff444559);
      expect(core.secondary.get(20), 0xff2e2f42);
      expect(core.secondary.get(10), 0xff191a2c);
      expect(core.secondary.get(0), 0xff000000);
    });

    test('content of blue', () {
      final core = CorePalette.contentOf(0xff0000ff);

      expect(core.primary.get(100), 0xffffffff);
      expect(core.primary.get(95), 0xfff1efff);
      expect(core.primary.get(90), 0xffe0e0ff);
      expect(core.primary.get(80), 0xffbec2ff);
      expect(core.primary.get(70), 0xff9da3ff);
      expect(core.primary.get(60), 0xff7c84ff);
      expect(core.primary.get(50), 0xff5a64ff);
      expect(core.primary.get(40), 0xff343dff);
      expect(core.primary.get(30), 0xff0000ef);
      expect(core.primary.get(20), 0xff0001ac);
      expect(core.primary.get(10), 0xff00006e);
      expect(core.primary.get(0), 0xff000000);
      expect(core.secondary.get(100), 0xffffffff);
      expect(core.secondary.get(95), 0xfff1efff);
      expect(core.secondary.get(90), 0xffe0e0ff);
      expect(core.secondary.get(80), 0xffc1c3f4);
      expect(core.secondary.get(70), 0xffa5a7d7);
      expect(core.secondary.get(60), 0xff8b8dbb);
      expect(core.secondary.get(50), 0xff7173a0);
      expect(core.secondary.get(40), 0xff585b86);
      expect(core.secondary.get(30), 0xff40436d);
      expect(core.secondary.get(20), 0xff2a2d55);
      expect(core.secondary.get(10), 0xff14173f);
      expect(core.secondary.get(0), 0xff000000);
    });
  });

  group('KeyColor', () {
    test('exact chroma is available', () {
      // Requested chroma is exactly achievable at a certain tone.
      final palette = TonalPalette.of(50.0, 60.0);
      final result = palette.keyColor;

      expect(result.hue, closeTo(50.0, 10.0));
      expect(result.chroma, closeTo(60.0, 0.5));
      // Tone might vary, but should be within the range from 0 to 100.
      expect(result.tone, greaterThan(0));
      expect(result.tone, lessThan(100));
    });

    test('requesting unusually high chroma', () {
      // Requested chroma is above what is achievable. For Hue 149, chroma peak is 89.6 at Tone 87.9.
      // The result key color's chroma should be close to the chroma peak.
      final palette = TonalPalette.of(149.0, 200.0);
      final result = palette.keyColor;

      expect(result.hue, closeTo(149.0, 10.0));
      expect(result.chroma, greaterThan(89.0));
      // Tone might vary, but should be within the range from 0 to 100.
      expect(result.tone, greaterThan(0));
      expect(result.tone, lessThan(100));
    });

    test('requesting unusually low chroma', () {
      // By definition, the key color should be the first tone, starting from Tone 50, matching the
      // given hue and chroma. When requesting a very low chroma, the result should be close to Tone
      // 50, since most tones can produce a low chroma.
      final palette = TonalPalette.of(50.0, 3.0);
      final result = palette.keyColor;

      // Higher error tolerance for hue when the requested chroma is unusually low.
      expect(result.hue, closeTo(50.0, 10.0));
      expect(result.chroma, closeTo(3.0, 0.5));
      expect(result.tone, closeTo(50.0, 0.5));
    });
  });
}
