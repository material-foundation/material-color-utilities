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

import 'package:material_color_utilities/hct/cam16.dart';
import 'package:material_color_utilities/hct/hct.dart';
import 'package:material_color_utilities/hct/viewing_conditions.dart';
import 'package:material_color_utilities/utils/color_utils.dart';
import 'package:material_color_utilities/utils/string_utils.dart';
import 'package:test/test.dart';

import './utils/color_matcher.dart';

const black = 0xff000000;
const white = 0xffffffff;
const red = 0xffff0000;
const green = 0xff00ff00;
const blue = 0xff0000ff;
const midgray = 0xff777777;

bool _colorIsOnBoundary(int argb) {
  return ColorUtils.redFromArgb(argb) == 0 ||
      ColorUtils.redFromArgb(argb) == 255 ||
      ColorUtils.greenFromArgb(argb) == 0 ||
      ColorUtils.greenFromArgb(argb) == 255 ||
      ColorUtils.blueFromArgb(argb) == 0 ||
      ColorUtils.blueFromArgb(argb) == 255;
}

void main() {
  test('conversions_areReflexive', () {
    final cam = Cam16.fromInt(red);
    final color = cam.viewed(ViewingConditions.standard);
    expect(color, equals(red));
  });

  test('y_midgray', () {
    expect(18.418, closeTo(ColorUtils.yFromLstar(50.0), 0.001));
  });

  test('y_black', () {
    expect(0.0, closeTo(ColorUtils.yFromLstar(0.0), 0.001));
  });

  test('y_white', () {
    expect(100.0, closeTo(ColorUtils.yFromLstar(100.0), 0.001));
  });

  test('cam_red', () {
    final cam = Cam16.fromInt(red);
    expect(46.445, closeTo(cam.j, 0.001));
    expect(113.357, closeTo(cam.chroma, 0.001));
    expect(27.408, closeTo(cam.hue, 0.001));
    expect(89.494, closeTo(cam.m, 0.001));
    expect(91.889, closeTo(cam.s, 0.001));
    expect(105.988, closeTo(cam.q, 0.001));
  });

  test('cam_green', () {
    final cam = Cam16.fromInt(green);
    expect(79.331, closeTo(cam.j, 0.001));
    expect(108.410, closeTo(cam.chroma, 0.001));
    expect(142.139, closeTo(cam.hue, 0.001));
    expect(85.587, closeTo(cam.m, 0.001));
    expect(78.604, closeTo(cam.s, 0.001));
    expect(138.520, closeTo(cam.q, 0.001));
  });

  test('cam_blue', () {
    final cam = Cam16.fromInt(blue);
    expect(25.465, closeTo(cam.j, 0.001));
    expect(87.230, closeTo(cam.chroma, 0.001));
    expect(282.788, closeTo(cam.hue, 0.001));
    expect(68.867, closeTo(cam.m, 0.001));
    expect(93.674, closeTo(cam.s, 0.001));
    expect(78.481, closeTo(cam.q, 0.001));
  });

  test('cam_black', () {
    final cam = Cam16.fromInt(black);
    expect(0.0, closeTo(cam.j, 0.001));
    expect(0.0, closeTo(cam.chroma, 0.001));
    expect(0.0, closeTo(cam.hue, 0.001));
    expect(0.0, closeTo(cam.m, 0.001));
    expect(0.0, closeTo(cam.s, 0.001));
    expect(0.0, closeTo(cam.q, 0.001));
  });

  test('cam_white', () {
    final cam = Cam16.fromInt(white);
    expect(100.0, closeTo(cam.j, 0.001));
    expect(2.869, closeTo(cam.chroma, 0.001));
    expect(209.492, closeTo(cam.hue, 0.001));
    expect(2.265, closeTo(cam.m, 0.001));
    expect(12.068, closeTo(cam.s, 0.001));
    expect(155.521, closeTo(cam.q, 0.001));
  });

  test('gamutMap_red', () {
    final colorToTest = red;
    final cam = Cam16.fromInt(colorToTest);
    final color =
        Hct.from(cam.hue, cam.chroma, ColorUtils.lstarFromArgb(colorToTest))
            .toInt();
    expect(colorToTest, equals(color));
  });

  test('gamutMap_green', () {
    final colorToTest = green;
    final cam = Cam16.fromInt(colorToTest);
    final color =
        Hct.from(cam.hue, cam.chroma, ColorUtils.lstarFromArgb(colorToTest))
            .toInt();
    expect(colorToTest, equals(color));
  });

  test('gamutMap_blue', () {
    final colorToTest = blue;
    final cam = Cam16.fromInt(colorToTest);
    final color =
        Hct.from(cam.hue, cam.chroma, ColorUtils.lstarFromArgb(colorToTest))
            .toInt();
    expect(colorToTest, equals(color));
  });

  test('gamutMap_white', () {
    final colorToTest = white;
    final cam = Cam16.fromInt(colorToTest);
    final color =
        Hct.from(cam.hue, cam.chroma, ColorUtils.lstarFromArgb(colorToTest))
            .toInt();
    expect(colorToTest, equals(color));
  });

  test('gamutMap_midgray', () {
    final colorToTest = green;
    final cam = Cam16.fromInt(colorToTest);
    final color =
        Hct.from(cam.hue, cam.chroma, ColorUtils.lstarFromArgb(colorToTest))
            .toInt();
    expect(colorToTest, equals(color));
  });

  test('HCT returns a sufficiently close color', () {
    for (var hue = 15; hue < 360; hue += 30) {
      for (var chroma = 0; chroma <= 100; chroma += 10) {
        for (var tone = 20; tone <= 80; tone += 10) {
          final hctRequestDescription = 'H$hue C$chroma T$tone';
          final hctColor = Hct.from(
            hue.toDouble(),
            chroma.toDouble(),
            tone.toDouble(),
          );

          if (chroma > 0) {
            expect(
              hctColor.hue,
              closeTo(hue, 4.0),
              reason: 'Hue should be close for $hctRequestDescription',
            );
          }

          expect(
            hctColor.chroma,
            inInclusiveRange(0.0, chroma + 2.5),
            reason: 'Chroma should be close or less for $hctRequestDescription',
          );

          if (hctColor.chroma < chroma - 2.5) {
            expect(
              _colorIsOnBoundary(hctColor.toInt()),
              true,
              reason: 'HCT request for non-sRGB color should return '
                  'a color on the boundary of the sRGB cube '
                  'for $hctRequestDescription, but got '
                  '${StringUtils.hexFromArgb(hctColor.toInt())} instead',
            );
          }

          expect(
            hctColor.tone,
            closeTo(tone, 0.5),
            reason: 'Tone should be close for $hctRequestDescription',
          );
        }
      }
    }
  });

  group('CAM16 to XYZ', () {
    test('without array', () {
      final colorToTest = red;
      final cam = Cam16.fromInt(colorToTest);
      final xyz = cam.xyzInViewingConditions(ViewingConditions.sRgb);
      expect(xyz[0], closeTo(41.23, 0.01));
      expect(xyz[1], closeTo(21.26, 0.01));
      expect(xyz[2], closeTo(1.93, 0.01));
    });

    test('with array', () {
      final colorToTest = red;
      final cam = Cam16.fromInt(colorToTest);
      final xyz =
          cam.xyzInViewingConditions(ViewingConditions.sRgb, array: [0, 0, 0]);
      expect(xyz[0], closeTo(41.23, 0.01));
      expect(xyz[1], closeTo(21.26, 0.01));
      expect(xyz[2], closeTo(1.93, 0.01));
    });
  });

  group('Color Relativity', () {
    test('red in black', () {
      final colorToTest = red;
      final hct = Hct.fromInt(colorToTest);
      expect(
          hct
              .inViewingConditions(ViewingConditions.make(backgroundLstar: 0.0))
              .toInt(),
          isColor(0xff9F5C51));
    });

    test('red in white', () {
      final colorToTest = red;
      final hct = Hct.fromInt(colorToTest);
      expect(
          hct
              .inViewingConditions(
                  ViewingConditions.make(backgroundLstar: 100.0))
              .toInt(),
          isColor(0xffFF5D48));
    });

    test('green in black', () {
      final colorToTest = green;
      final hct = Hct.fromInt(colorToTest);
      expect(
          hct
              .inViewingConditions(ViewingConditions.make(backgroundLstar: 0.0))
              .toInt(),
          isColor(0xffACD69D));
    });

    test('green in white', () {
      final colorToTest = green;
      final hct = Hct.fromInt(colorToTest);
      expect(
          hct
              .inViewingConditions(
                  ViewingConditions.make(backgroundLstar: 100.0))
              .toInt(),
          isColor(0xff8EFF77));
    });

    test('blue in black', () {
      final colorToTest = blue;
      final hct = Hct.fromInt(colorToTest);
      expect(
          hct
              .inViewingConditions(ViewingConditions.make(backgroundLstar: 0.0))
              .toInt(),
          isColor(0xff343654));
    });

    test('blue in white', () {
      final colorToTest = blue;
      final hct = Hct.fromInt(colorToTest);
      expect(
          hct
              .inViewingConditions(
                  ViewingConditions.make(backgroundLstar: 100.0))
              .toInt(),
          isColor(0xff3F49FF));
    });

    test('white in black', () {
      final colorToTest = white;
      final hct = Hct.fromInt(colorToTest);
      expect(
          hct
              .inViewingConditions(ViewingConditions.make(backgroundLstar: 0.0))
              .toInt(),
          isColor(0xffFFFFFF));
    });

    test('white in white', () {
      final colorToTest = white;
      final hct = Hct.fromInt(colorToTest);
      expect(
          hct
              .inViewingConditions(
                  ViewingConditions.make(backgroundLstar: 100.0))
              .toInt(),
          isColor(0xffFFFFFF));
    });

    test('midgray in black', () {
      final colorToTest = midgray;
      final hct = Hct.fromInt(colorToTest);
      expect(
          hct
              .inViewingConditions(ViewingConditions.make(backgroundLstar: 0.0))
              .toInt(),
          isColor(0xff605F5F));
    });

    test('midgray in white', () {
      final colorToTest = midgray;
      final hct = Hct.fromInt(colorToTest);
      expect(
          hct
              .inViewingConditions(
                  ViewingConditions.make(backgroundLstar: 100.0))
              .toInt(),
          isColor(0xff8E8E8E));
    });

    test('black in black', () {
      final colorToTest = black;
      final hct = Hct.fromInt(colorToTest);
      expect(
          hct
              .inViewingConditions(ViewingConditions.make(backgroundLstar: 0.0))
              .toInt(),
          isColor(0xff000000));
    });

    test('black in white', () {
      final colorToTest = black;
      final hct = Hct.fromInt(colorToTest);
      expect(
          hct
              .inViewingConditions(
                  ViewingConditions.make(backgroundLstar: 100.0))
              .toInt(),
          isColor(0xff000000));
    });
  });
}
