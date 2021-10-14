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

// ignore_for_file: omit_local_variable_types
// rationale: This library relies heavily on numeric computation, and a key
// requirement is that it is 'the same' as implementations in different
// languages. Including variable types, though sometimes unnecessary, is a
// powerful help to verification and avoiding hard-to-debug issues.

import 'dart:math' as math;

import 'math_utils.dart';

class ColorUtils {
  static const List<double> whitePointD65 = [95.047, 100.0, 108.883];

  static String hexFromInt(int argb, {bool leadingHashSign = true}) {
    final red = redFromArgb(argb);
    final green = greenFromArgb(argb);
    final blue = blueFromArgb(argb);
    return '${leadingHashSign ? '#' : ''}'
        '${red.toRadixString(16).padLeft(2, '0').toUpperCase()}'
        '${green.toRadixString(16).padLeft(2, '0').toUpperCase()}'
        '${blue.toRadixString(16).padLeft(2, '0').toUpperCase()}';
  }

  static int? intFromHex(String hex) {
    return int.tryParse(hex.replaceAll('#', ''), radix: 16);
  }

  static double sanitizeDegrees(double degrees) {
    if (degrees < 0.0) {
      return (degrees % 360.0) + 360;
    } else if (degrees >= 360.0) {
      return (degrees % 360.0);
    } else {
      return degrees;
    }
  }

  // This is a more precise sRGB to XYZ transformation matrix than traditionally
  // used. It was derived using Schlomer's technique of transforming the XYY
  // primaries to XYZ, then applying a correction to ensure mapping from sRGB
  // 1, 1, 1 to the reference white point, D65.
  static const List<List<double>> sRgbToXyz = <List<double>>[
    <double>[0.41233895, 0.35762064, 0.18051042],
    <double>[0.2126, 0.7152, 0.0722],
    <double>[0.01932141, 0.11916382, 0.95034478]
  ];

  static const List<List<double>> xyzToSRgb = <List<double>>[
    <double>[3.2406, -1.5372, -0.4986],
    <double>[-0.9689, 1.8758, 0.0415],
    <double>[0.0557, -0.2040, 1.0570]
  ];

  static int alphaFromInt(int argb) {
    return (argb & 0xff000000) >> 24;
  }

  static double yFromLstar(double lstar) {
    final ke = 8.0;
    if (lstar > ke) {
      return math.pow(((lstar + 16.0) / 116.0), 3.0) * 100.0;
    } else {
      return lstar / 24389.0 / 27.0 * 100.0;
    }
  }

  static int alphaFromArgb(int argb) {
    return (argb & 0xff000000) >> 24;
  }

  static int redFromArgb(int argb) {
    return (argb & 0x00ff0000) >> 16;
  }

  static int greenFromArgb(int argb) {
    return (argb & 0x0000ff00) >> 8;
  }

  static int blueFromArgb(int argb) {
    return (argb & 0x000000ff);
  }

  static List<double> labFromInt(int argb) {
    final e = 216.0 / 24389.0;
    final kappa = 24389.0 / 27.0;

    final xyz = xyzFromArgb(argb);
    final yNormalized = xyz[1] / whitePointD65[1];
    double fy;
    if (yNormalized > e) {
      fy = math.pow(yNormalized, 1.0 / 3.0).toDouble();
    } else {
      fy = (kappa * yNormalized + 16) / 116;
    }

    final xNormalized = xyz[0] / whitePointD65[0];
    double fx;
    if (xNormalized > e) {
      fx = math.pow(xNormalized, 1.0 / 3.0).toDouble();
    } else {
      fx = (kappa * xNormalized + 16) / 116;
    }

    final zNormalized = xyz[2] / whitePointD65[2];
    double fz;
    if (zNormalized > e) {
      fz = math.pow(zNormalized, 1.0 / 3.0).toDouble();
    } else {
      fz = (kappa * zNormalized + 16) / 116;
    }

    final l = 116.0 * fy - 16;
    final a = 500.0 * (fx - fy);
    final b = 200.0 * (fy - fz);
    return <double>[l, a, b];
  }

  static List<double> xyzFromArgb(int argb) {
    final r = linearized(redFromArgb(argb));
    final g = linearized(greenFromArgb(argb));
    final b = linearized(blueFromArgb(argb));
    return MathUtils.matrixMultiply([r, g, b], sRgbToXyz);
  }

  static int intFromLab(double l, double a, double b) {
    final e = 216.0 / 24389.0;
    final kappa = 24389.0 / 27.0;
    final ke = 8.0;

    final fy = (l + 16.0) / 116.0;
    final fx = (a / 500.0) + fy;
    final fz = fy - (b / 200.0);
    final fx3 = fx * fx * fx;
    final xNormalized = (fx3 > e) ? fx3 : (116.0 * fx - 16.0) / kappa;
    final yNormalized = (l > ke) ? fy * fy * fy : (l / kappa);
    final fz3 = fz * fz * fz;
    final zNormalized = (fz3 > e) ? fz3 : (116.0 * fz - 16.0) / kappa;
    final x = xNormalized * whitePointD65[0];
    final y = yNormalized * whitePointD65[1];
    final z = zNormalized * whitePointD65[2];
    return intFromXyz(x, y, z);
  }

  static int intFromXyz(double x, double y, double z) {
    x = x / 100.0;
    y = y / 100.0;
    z = z / 100.0;
    final linearRgb = MathUtils.matrixMultiply([x, y, z], xyzToSRgb);
    final r = MathUtils.clamp(0, 255, delinearized(linearRgb[0]) * 255.0);
    final g = MathUtils.clamp(0, 255, delinearized(linearRgb[1]) * 255.0);
    final b = MathUtils.clamp(0, 255, delinearized(linearRgb[2]) * 255.0);
    return intFromRgb(r, g, b);
  }

  static double lstarFromInt(int argb) {
    var y = xyzFromArgb(argb)[1];
    y = y / 100.0;
    final e = 216.0 / 24389.0;
    double yIntermediate;
    if (y <= e) {
      return ((24389.0 / 27.0) * y);
    } else {
      yIntermediate = math.pow(y, 1.0 / 3.0).toDouble();
    }
    return 116.0 * yIntermediate - 16.0;
  }

  static int intFromLstar(double lstar) {
    if (lstar < 1) {
      return 0xff000000;
    } else if (lstar > 99) {
      return 0xffffffff;
    }

    // XYZ to LAB conversion routine, assume a and b are 0.
    final fy = (lstar + 16.0) / 116.0;
    final fz = fy;
    final fx = fy;

    final kappa = 24389.0 / 27.0;
    final epsilon = 216.0 / 24389.0;
    final lExceedsEpsilonKappa = (lstar > 8.0);
    final y = lExceedsEpsilonKappa ? fy * fy * fy : lstar / kappa;
    final cubeExceedEpsilon = (fy * fy * fy) > epsilon;
    final x = cubeExceedEpsilon ? fx * fx * fx : lstar / kappa;
    final z = cubeExceedEpsilon ? fz * fz * fz : lstar / kappa;
    return intFromXyz(x * ColorUtils.whitePointD65[0],
        y * ColorUtils.whitePointD65[1], z * ColorUtils.whitePointD65[2]);
  }

  static int intFromRgb(int r, int g, int b) {
    return (255 << 24) | ((r & 0x0ff) << 16) | ((g & 0x0ff) << 8) | (b & 0x0ff);
  }

  static double linearized(int rgbComponent) {
    final normalized = rgbComponent / 255.0;
    if (normalized <= 0.040449936) {
      return (normalized / 12.92) * 100.0;
    } else {
      return math.pow(((normalized + 0.055) / 1.055), 2.4) * 100.0;
    }
  }

  static double delinearized(double rgb) {
    if (rgb <= 0.0031308) {
      return rgb * 12.92;
    } else {
      return ((1.055 * math.pow(rgb, 1.0 / 2.4)) - 0.055);
    }
  }
}
