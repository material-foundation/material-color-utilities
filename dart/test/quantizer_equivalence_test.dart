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

/// Checks that the quantizers give exactly the same results as the frozen
/// copies of the code before it was sped up, in `utils/reference_quantizers`.
library;

import 'dart:math';
import 'dart:typed_data';

import 'package:material_color_utilities/quantize/quantizer.dart';
import 'package:material_color_utilities/quantize/quantizer_celebi.dart';
import 'package:material_color_utilities/quantize/quantizer_wsmeans.dart';
import 'package:material_color_utilities/quantize/quantizer_wu.dart';
import 'package:material_color_utilities/quantize/src/lab_lut.dart';
import 'package:material_color_utilities/quantize/src/pixel_counts.dart';
import 'package:material_color_utilities/utils/color_utils.dart';
import 'package:test/test.dart';

import 'utils/reference_quantizers.dart';

/// The kinds of random images.
enum _Kind {
  /// Any opaque color.
  opaque,

  /// A few gray levels, so most colors repeat.
  fewColors,

  /// Any 32-bit value, so alpha varies.
  anyAlpha,

  /// Opaque colors as signed or unsigned ints, so equal colors appear as
  /// different ints.
  mixedSign,

  /// Smooth gradients with noise, like a photo.
  photo,
}

List<int> _image(Random random, _Kind kind, int size) {
  final width = max(1, sqrt(size).floor());
  return List<int>.generate(size, (i) {
    switch (kind) {
      case _Kind.opaque:
        return 0xff000000 | random.nextInt(1 << 24);
      case _Kind.fewColors:
        return 0xff000000 | (random.nextInt(8) * 0x111111);
      case _Kind.anyAlpha:
        return random.nextInt(1 << 32);
      case _Kind.mixedSign:
        final color = 0xff000000 | random.nextInt(1 << 24);
        return random.nextBool() ? color : color - 0x100000000;
      case _Kind.photo:
        final x = i % width;
        final y = i ~/ width;
        int channel(int base) =>
            (base + x * 3 + y * 2 + random.nextInt(24)).clamp(0, 255);
        return ColorUtils.argbFromRgb(channel(40), channel(90), channel(10));
    }
  });
}

/// The entries of [map] in order.
String _entries(Map<int, int> map) =>
    map.entries.map((e) => '${e.key}:${e.value}').join(',');

/// The result of [run] as text, or the type of the error that it threw.
Future<String> _describe(Future<QuantizerResult> Function() run) async {
  try {
    final result = await run();
    return '${_entries(result.colorToCount)} | '
        '${_entries(result.inputPixelToClusterPixel)}';
  } catch (e) {
    return 'threw ${e.runtimeType}';
  }
}

void main() {
  const sizes = [0, 1, 5, 100, 2000, 16384];
  const maxColorsValues = [-1, 0, 1, 2, 16, 128, 256, 300];

  test('QuantizerCelebi matches the reference on random images', () async {
    final random = Random(0x42688);
    var cases = 0;
    for (final kind in _Kind.values) {
      for (final size in sizes) {
        final pixels = _image(random, kind, size);
        for (final maxColors in maxColorsValues) {
          // Also checks a pixel source that is not a List.
          final Iterable<int> input = maxColors == 16 ? pixels.toSet() : pixels;
          final mapPixels = maxColors == 128;
          final expected = await _describe(
            () => ReferenceQuantizerCelebi().quantize(
              input,
              maxColors,
              returnInputPixelToClusterPixel: mapPixels,
            ),
          );
          final actual = await _describe(
            () => QuantizerCelebi().quantize(
              input,
              maxColors,
              returnInputPixelToClusterPixel: mapPixels,
            ),
          );
          expect(actual, expected, reason: '$kind, $size px, $maxColors');
          cases++;
        }
      }
    }
    expect(cases, _Kind.values.length * sizes.length * maxColorsValues.length);
  });

  test('QuantizerWsmeans matches the reference for edge cases', () async {
    final random = Random(7);
    for (final kind in _Kind.values) {
      for (final size in [0, 1, 100, 2000]) {
        final pixels = _image(random, kind, size);
        final startingClustersValues = [
          <int>[],
          [0xff112233, 0xff112233, 0xff445566],
          List<int>.generate(10, (_) => 0xff000000 | random.nextInt(1 << 24)),
          List<int>.generate(300, (_) => 0xff000000 | random.nextInt(1 << 24)),
          pixels.take(5).toList(),
        ];
        for (final startingClusters in startingClustersValues) {
          for (final maxColors in [-3, 0, 1, 7, 128]) {
            for (final maxIterations in [1, 10]) {
              final expected = await _describe(
                () async => ReferenceQuantizerWsmeans.quantize(
                  pixels,
                  maxColors,
                  startingClusters: startingClusters,
                  maxIterations: maxIterations,
                  returnInputPixelToClusterPixel: maxIterations == 1,
                ),
              );
              final actual = await _describe(
                () async => QuantizerWsmeans.quantize(
                  pixels,
                  maxColors,
                  startingClusters: startingClusters,
                  maxIterations: maxIterations,
                  returnInputPixelToClusterPixel: maxIterations == 1,
                ),
              );
              expect(
                actual,
                expected,
                reason:
                    '$kind, $size px, ${startingClusters.length} starting '
                    'clusters, $maxColors, $maxIterations iterations',
              );
            }
          }
        }
      }
    }
  });

  test('QuantizerWu matches the reference, histogram included', () async {
    final random = Random(11);
    for (final kind in _Kind.values) {
      final pixels = _image(random, kind, 5000);
      final reference = ReferenceQuantizerWu();
      final wu = QuantizerWu();
      final expected = await reference.quantize(pixels, 128);
      final actual = await wu.quantize(pixels, 128);
      expect(
        _entries(actual.colorToCount),
        _entries(expected.colorToCount),
        reason: '$kind',
      );
      expect(wu.weights, reference.weights);
      expect(wu.momentsR, reference.momentsR);
      expect(wu.momentsG, reference.momentsG);
      expect(wu.momentsB, reference.momentsB);
      expect(wu.moments, reference.moments);
    }
  });

  test('PixelCounts keeps the order and counts of a LinkedHashMap', () {
    final random = Random(3);
    final pixels =
        _image(random, _Kind.fewColors, 1000) +
        _image(random, _Kind.anyAlpha, 1000);
    final expected = <int, int>{};
    for (final pixel in pixels) {
      expected[pixel] = (expected[pixel] ?? 0) + 1;
    }
    final counts = PixelCounts.tryCount(pixels)!;
    final actual = {
      for (var i = 0; i < counts.size; i++) counts.colors[i]: counts.counts[i],
    };
    expect(_entries(actual), _entries(expected));
    expect(PixelCounts.tryCount([0xffffffff, -1]), isNull);
    expect(PixelCounts.tryCount([0x100000000]), isNull);
  });

  test('labFromArgbInto matches ColorUtils.labFromArgb for all colors', () {
    final lab = Float64List(3);
    var mismatches = 0;
    for (var rgb = 0; rgb < 1 << 24; rgb++) {
      final argb = 0xff000000 | rgb;
      labFromArgbInto(argb, lab, 0);
      final expected = ColorUtils.labFromArgb(argb);
      for (var i = 0; i < 3; i++) {
        if (lab[i] != expected[i] ||
            lab[i].isNegative != expected[i].isNegative) {
          mismatches++;
        }
      }
    }
    expect(mismatches, 0);
  });
}
