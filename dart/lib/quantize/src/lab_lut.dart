// Copyright 2026 Google LLC
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

import 'dart:math' as math;
import 'dart:typed_data';

import '../../utils/color_utils.dart';

/// [ColorUtils.linearized] for each 8-bit channel value.
final Float64List _linearized = () {
  final table = Float64List(256);
  for (var i = 0; i < 256; i++) {
    table[i] = ColorUtils.linearized(i);
  }
  return table;
}();

double _labF(double t) {
  const e = 216.0 / 24389.0;
  const kappa = 24389.0 / 27.0;
  if (t > e) {
    return math.pow(t, 1.0 / 3.0).toDouble();
  } else {
    return (kappa * t + 16) / 116;
  }
}

/// Writes the L*a*b* coordinates of [argb] to [out] at [offset],
/// [offset] + 1 and [offset] + 2.
///
/// Gives exactly the same values as [ColorUtils.labFromArgb]: it does the
/// same math in the same order, but looks up each linearized channel in a
/// table and does not allocate a list.
void labFromArgbInto(int argb, Float64List out, int offset) {
  final linearR = _linearized[(argb >> 16) & 255];
  final linearG = _linearized[(argb >> 8) & 255];
  final linearB = _linearized[argb & 255];
  final x = 0.41233895 * linearR + 0.35762064 * linearG + 0.18051042 * linearB;
  final y = 0.2126 * linearR + 0.7152 * linearG + 0.0722 * linearB;
  final z = 0.01932141 * linearR + 0.11916382 * linearG + 0.95034478 * linearB;
  final fx = _labF(x / 95.047);
  final fy = _labF(y / 100.0);
  final fz = _labF(z / 108.883);
  out[offset] = 116.0 * fy - 16;
  out[offset + 1] = 500.0 * (fx - fy);
  out[offset + 2] = 200.0 * (fy - fz);
}
