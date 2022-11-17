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

import 'package:material_color_utilities/utils/color_utils.dart';
import 'package:test/test.dart';

List<double> _range(double start, double stop, int caseCount) {
  double stepSize = (stop - start) / (caseCount - 1);
  return List.generate(caseCount, (index) => start + stepSize * index);
}

List<int> get rgbRange =>
    _range(0.0, 255.0, 8).map((element) => element.round()).toList();

List<int> get fullRgbRange => List<int>.generate(256, (index) => index);

void main() {
  test('range_integrity', () {
    final range = _range(3.0, 9999.0, 1234);
    for (var i = 0; i < 1234; i++) {
      expect(range[i], closeTo(3 + 8.1070559611 * i, 1e-5));
    }
  });

  test('y_to_lstar_to_y', () {
    for (final y in _range(0, 100, 1001)) {
      expect(
        ColorUtils.yFromLstar(ColorUtils.lstarFromY(y)),
        closeTo(y, 1e-5),
      );
    }
  });

  test('lstar_to_y_to_lstar', () {
    for (final lstar in _range(0, 100, 1001)) {
      expect(
        ColorUtils.lstarFromY(ColorUtils.yFromLstar(lstar)),
        closeTo(lstar, 1e-5),
      );
    }
  });

  test('yFromLstar', () {
    expect(ColorUtils.yFromLstar(0.0), closeTo(0.0, 1e-5));
    expect(ColorUtils.yFromLstar(0.1), closeTo(0.0110705, 1e-5));
    expect(ColorUtils.yFromLstar(0.2), closeTo(0.0221411, 1e-5));
    expect(ColorUtils.yFromLstar(0.3), closeTo(0.0332116, 1e-5));
    expect(ColorUtils.yFromLstar(0.4), closeTo(0.0442822, 1e-5));
    expect(ColorUtils.yFromLstar(0.5), closeTo(0.0553528, 1e-5));
    expect(ColorUtils.yFromLstar(1.0), closeTo(0.1107056, 1e-5));
    expect(ColorUtils.yFromLstar(2.0), closeTo(0.2214112, 1e-5));
    expect(ColorUtils.yFromLstar(3.0), closeTo(0.3321169, 1e-5));
    expect(ColorUtils.yFromLstar(4.0), closeTo(0.4428225, 1e-5));
    expect(ColorUtils.yFromLstar(5.0), closeTo(0.5535282, 1e-5));
    expect(ColorUtils.yFromLstar(8.0), closeTo(0.8856451, 1e-5));
    expect(ColorUtils.yFromLstar(10.0), closeTo(1.1260199, 1e-5));
    expect(ColorUtils.yFromLstar(15.0), closeTo(1.9085832, 1e-5));
    expect(ColorUtils.yFromLstar(20.0), closeTo(2.9890524, 1e-5));
    expect(ColorUtils.yFromLstar(25.0), closeTo(4.4154767, 1e-5));
    expect(ColorUtils.yFromLstar(30.0), closeTo(6.2359055, 1e-5));
    expect(ColorUtils.yFromLstar(40.0), closeTo(11.2509737, 1e-5));
    expect(ColorUtils.yFromLstar(50.0), closeTo(18.4186518, 1e-5));
    expect(ColorUtils.yFromLstar(60.0), closeTo(28.1233342, 1e-5));
    expect(ColorUtils.yFromLstar(70.0), closeTo(40.7494157, 1e-5));
    expect(ColorUtils.yFromLstar(80.0), closeTo(56.6812907, 1e-5));
    expect(ColorUtils.yFromLstar(90.0), closeTo(76.3033539, 1e-5));
    expect(ColorUtils.yFromLstar(95.0), closeTo(87.6183294, 1e-5));
    expect(ColorUtils.yFromLstar(99.0), closeTo(97.4360239, 1e-5));
    expect(ColorUtils.yFromLstar(100.0), closeTo(100.0, 1e-5));
  });

  test('lstarFromY', () {
    expect(ColorUtils.lstarFromY(0.0), closeTo(0.0, 1e-5));
    expect(ColorUtils.lstarFromY(0.1), closeTo(0.9032962, 1e-5));
    expect(ColorUtils.lstarFromY(0.2), closeTo(1.8065925, 1e-5));
    expect(ColorUtils.lstarFromY(0.3), closeTo(2.7098888, 1e-5));
    expect(ColorUtils.lstarFromY(0.4), closeTo(3.6131851, 1e-5));
    expect(ColorUtils.lstarFromY(0.5), closeTo(4.5164814, 1e-5));
    expect(ColorUtils.lstarFromY(0.8856451), closeTo(8.0, 1e-5));
    expect(ColorUtils.lstarFromY(1.0), closeTo(8.9914424, 1e-5));
    expect(ColorUtils.lstarFromY(2.0), closeTo(15.4872443, 1e-5));
    expect(ColorUtils.lstarFromY(3.0), closeTo(20.0438970, 1e-5));
    expect(ColorUtils.lstarFromY(4.0), closeTo(23.6714419, 1e-5));
    expect(ColorUtils.lstarFromY(5.0), closeTo(26.7347653, 1e-5));
    expect(ColorUtils.lstarFromY(10.0), closeTo(37.8424304, 1e-5));
    expect(ColorUtils.lstarFromY(15.0), closeTo(45.6341970, 1e-5));
    expect(ColorUtils.lstarFromY(20.0), closeTo(51.8372115, 1e-5));
    expect(ColorUtils.lstarFromY(25.0), closeTo(57.0754208, 1e-5));
    expect(ColorUtils.lstarFromY(30.0), closeTo(61.6542222, 1e-5));
    expect(ColorUtils.lstarFromY(40.0), closeTo(69.4695307, 1e-5));
    expect(ColorUtils.lstarFromY(50.0), closeTo(76.0692610, 1e-5));
    expect(ColorUtils.lstarFromY(60.0), closeTo(81.8381891, 1e-5));
    expect(ColorUtils.lstarFromY(70.0), closeTo(86.9968642, 1e-5));
    expect(ColorUtils.lstarFromY(80.0), closeTo(91.6848609, 1e-5));
    expect(ColorUtils.lstarFromY(90.0), closeTo(95.9967686, 1e-5));
    expect(ColorUtils.lstarFromY(95.0), closeTo(98.0335184, 1e-5));
    expect(ColorUtils.lstarFromY(99.0), closeTo(99.6120372, 1e-5));
    expect(ColorUtils.lstarFromY(100.0), closeTo(100.0, 1e-5));
  });

  test('y_continuity', () {
    final epsilon = 1e-6;
    final delta = 1e-8;
    final left = 8.0 - delta;
    final mid = 8.0;
    final right = 8.0 + delta;
    expect(
      ColorUtils.yFromLstar(left),
      closeTo(ColorUtils.yFromLstar(mid), epsilon),
    );
    expect(
      ColorUtils.yFromLstar(right),
      closeTo(ColorUtils.yFromLstar(mid), epsilon),
    );
  });

  test('rgb_to_xyz_to_rgb', () {
    for (final r in rgbRange) {
      for (final g in rgbRange) {
        for (final b in rgbRange) {
          final argb = ColorUtils.argbFromRgb(r, g, b);
          final xyz = ColorUtils.xyzFromArgb(argb);
          final converted = ColorUtils.argbFromXyz(xyz[0], xyz[1], xyz[2]);
          expect(ColorUtils.redFromArgb(converted), closeTo(r, 1.5));
          expect(ColorUtils.greenFromArgb(converted), closeTo(g, 1.5));
          expect(ColorUtils.blueFromArgb(converted), closeTo(b, 1.5));
        }
      }
    }
  });

  test('rgb_to_lab_to_rgb', () {
    for (final r in rgbRange) {
      for (final g in rgbRange) {
        for (final b in rgbRange) {
          final argb = ColorUtils.argbFromRgb(r, g, b);
          final lab = ColorUtils.labFromArgb(argb);
          final converted = ColorUtils.argbFromLab(lab[0], lab[1], lab[2]);
          expect(ColorUtils.redFromArgb(converted), closeTo(r, 1.5));
          expect(ColorUtils.greenFromArgb(converted), closeTo(g, 1.5));
          expect(ColorUtils.blueFromArgb(converted), closeTo(b, 1.5));
        }
      }
    }
  });

  test('rgb_to_lstar_to_rgb', () {
    for (final component in fullRgbRange) {
      final argb = ColorUtils.argbFromRgb(component, component, component);
      final lstar = ColorUtils.lstarFromArgb(argb);
      final converted = ColorUtils.argbFromLstar(lstar);
      expect(converted, argb);
    }
  });

  test('rgb_to_lstar_to_y_commutes', () {
    for (final r in rgbRange) {
      for (final g in rgbRange) {
        for (final b in rgbRange) {
          final argb = ColorUtils.argbFromRgb(r, g, b);
          final lstar = ColorUtils.lstarFromArgb(argb);
          final y = ColorUtils.yFromLstar(lstar);
          final y2 = ColorUtils.xyzFromArgb(argb)[1];
          expect(y, closeTo(y2, 1e-5));
        }
      }
    }
  });

  test('lstar_to_rgb_to_y_commutes', () {
    for (final lstar in _range(0, 100, 1001)) {
      final argb = ColorUtils.argbFromLstar(lstar);
      final y = ColorUtils.xyzFromArgb(argb)[1];
      final y2 = ColorUtils.yFromLstar(lstar);
      expect(y, closeTo(y2, 1));
    }
  });

  test('linearize_delinearize', () {
    for (final rgbComponent in fullRgbRange) {
      final converted =
          ColorUtils.delinearized(ColorUtils.linearized(rgbComponent));
      expect(converted, rgbComponent);
    }
  });
}
