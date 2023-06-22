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

import 'package:material_color_utilities/hct/hct.dart';

import 'package:material_color_utilities/temperature/temperature_cache.dart';
import 'package:test/test.dart';
import './utils/color_matcher.dart';

void main() {
  group(TemperatureCache, () {
    test('raw temperature', () {
      final blueTemp = TemperatureCache.rawTemperature(Hct.fromInt(0xff0000ff));
      expect(blueTemp, closeTo(-1.393, 0.001));

      final redTemp = TemperatureCache.rawTemperature(Hct.fromInt(0xffff0000));
      expect(redTemp, closeTo(2.351, 0.001));

      final greenTemp =
          TemperatureCache.rawTemperature(Hct.fromInt(0xff00ff00));
      expect(greenTemp, closeTo(-0.267, 0.001));

      final whiteTemp =
          TemperatureCache.rawTemperature(Hct.fromInt(0xffffffff));
      expect(whiteTemp, closeTo(-0.5, 0.001));

      final blackTemp =
          TemperatureCache.rawTemperature(Hct.fromInt(0xff000000));
      expect(blackTemp, closeTo(-0.5, 0.001));
    });

    test('relative temperature', () {
      final blueTemp =
          TemperatureCache(Hct.fromInt(0xff0000ff)).inputRelativeTemperature;
      expect(blueTemp, closeTo(0.0, 0.001));

      final redTemp =
          TemperatureCache(Hct.fromInt(0xffff0000)).inputRelativeTemperature;
      expect(redTemp, closeTo(1.0, 0.001));

      final greenTemp =
          TemperatureCache(Hct.fromInt(0xff00ff00)).inputRelativeTemperature;
      expect(greenTemp, closeTo(0.467, 0.001));

      final whiteTemp =
          TemperatureCache(Hct.fromInt(0xffffffff)).inputRelativeTemperature;
      expect(whiteTemp, closeTo(0.5, 0.001));

      final blackTemp =
          TemperatureCache(Hct.fromInt(0xff000000)).inputRelativeTemperature;
      expect(blackTemp, closeTo(0.5, 0.001));
    });

    test('complement', () {
      final blueComplement =
          TemperatureCache(Hct.fromInt(0xff0000ff)).complement.toInt();
      expect(blueComplement, isColor(0xff9d0002));

      final redComplement =
          TemperatureCache(Hct.fromInt(0xffff0000)).complement.toInt();
      expect(redComplement, isColor(0xff007bfc));

      final greenComplement =
          TemperatureCache(Hct.fromInt(0xff00ff00)).complement.toInt();
      expect(greenComplement, isColor(0xffffd2c9));

      final whiteComplement =
          TemperatureCache(Hct.fromInt(0xffffffff)).complement.toInt();
      expect(whiteComplement, isColor(0xffffffff));

      final blackComplement =
          TemperatureCache(Hct.fromInt(0xff000000)).complement.toInt();
      expect(blackComplement, isColor(0xff000000));
    });

    test('analogous', () {
      final blueAnalogous = TemperatureCache(Hct.fromInt(0xff0000ff))
          .analogous()
          .map((e) => e.toInt())
          .toList();
      expect(blueAnalogous[0], isColor(0xff00590c));
      expect(blueAnalogous[1], isColor(0xff00564e));
      expect(blueAnalogous[2], isColor(0xff0000ff));
      expect(blueAnalogous[3], isColor(0xff6700cc));
      expect(blueAnalogous[4], isColor(0xff81009f));

      final redAnalogous = TemperatureCache(Hct.fromInt(0xffff0000))
          .analogous()
          .map((e) => e.toInt())
          .toList();
      expect(redAnalogous[0], isColor(0xfff60082));
      expect(redAnalogous[1], isColor(0xfffc004c));
      expect(redAnalogous[2], isColor(0xffff0000));
      expect(redAnalogous[3], isColor(0xffd95500));
      expect(redAnalogous[4], isColor(0xffaf7200));

      final greenAnalogous = TemperatureCache(Hct.fromInt(0xff00ff00))
          .analogous()
          .map((e) => e.toInt())
          .toList();
      expect(greenAnalogous[0], isColor(0xffcee900));
      expect(greenAnalogous[1], isColor(0xff92f500));
      expect(greenAnalogous[2], isColor(0xff00ff00));
      expect(greenAnalogous[3], isColor(0xff00fd6f));
      expect(greenAnalogous[4], isColor(0xff00fab3));

      final blackAnalogous = TemperatureCache(Hct.fromInt(0xff000000))
          .analogous()
          .map((e) => e.toInt())
          .toList();
      expect(blackAnalogous[0], isColor(0xff000000));
      expect(blackAnalogous[1], isColor(0xff000000));
      expect(blackAnalogous[2], isColor(0xff000000));
      expect(blackAnalogous[3], isColor(0xff000000));
      expect(blackAnalogous[4], isColor(0xff000000));

      final whiteAnalogous = TemperatureCache(Hct.fromInt(0xffffffff))
          .analogous()
          .map((e) => e.toInt())
          .toList();
      expect(whiteAnalogous[0], isColor(0xffffffff));
      expect(whiteAnalogous[1], isColor(0xffffffff));
      expect(whiteAnalogous[2], isColor(0xffffffff));
      expect(whiteAnalogous[3], isColor(0xffffffff));
      expect(whiteAnalogous[4], isColor(0xffffffff));
    });
  });
}
