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

import 'dart:math' as math;

import 'package:material_color_utilities/dislike/dislike_analyzer.dart';
import 'package:material_color_utilities/dynamiccolor/dynamic_scheme.dart';
import 'package:material_color_utilities/dynamiccolor/variant.dart';
import 'package:material_color_utilities/hct/hct.dart';

import 'dynamic_color.dart';
import 'src/contrast_curve.dart';
import 'src/tone_delta_pair.dart';

bool _isFidelity(DynamicScheme scheme) =>
    scheme.variant == Variant.fidelity || scheme.variant == Variant.content;

bool _isMonochrome(DynamicScheme scheme) =>
    scheme.variant == Variant.monochrome;

/// Tokens, or named colors, in the Material Design system.
class MaterialDynamicColors {
  static const double contentAccentToneDelta = 15.0;
  static DynamicColor highestSurface(DynamicScheme s) {
    return s.isDark ? surfaceBright : surfaceDim;
  }

  static DynamicColor primaryPaletteKeyColor = DynamicColor.fromPalette(
    name: 'primary_palette_key_color',
    palette: (s) => s.primaryPalette,
    tone: (s) => s.primaryPalette.keyColor.tone,
  );

  static DynamicColor secondaryPaletteKeyColor = DynamicColor.fromPalette(
    name: 'secondary_palette_key_color',
    palette: (s) => s.secondaryPalette,
    tone: (s) => s.secondaryPalette.keyColor.tone,
  );

  static DynamicColor tertiaryPaletteKeyColor = DynamicColor.fromPalette(
    name: 'tertiary_palette_key_color',
    palette: (s) => s.tertiaryPalette,
    tone: (s) => s.tertiaryPalette.keyColor.tone,
  );

  static DynamicColor neutralPaletteKeyColor = DynamicColor.fromPalette(
    name: 'neutral_palette_key_color',
    palette: (s) => s.neutralPalette,
    tone: (s) => s.neutralPalette.keyColor.tone,
  );

  static DynamicColor neutralVariantPaletteKeyColor = DynamicColor.fromPalette(
    name: 'neutral_variant_palette_key_color',
    palette: (s) => s.neutralVariantPalette,
    tone: (s) => s.neutralVariantPalette.keyColor.tone,
  );

  static DynamicColor background = DynamicColor.fromPalette(
    name: 'background',
    palette: (s) => s.neutralPalette,
    tone: (s) => s.isDark ? 6 : 98,
    isBackground: true,
  );

  static DynamicColor onBackground = DynamicColor.fromPalette(
    name: 'on_background',
    palette: (s) => s.neutralPalette,
    tone: (s) => s.isDark ? 90 : 10,
    background: (s) => MaterialDynamicColors.background,
    contrastCurve: ContrastCurve(3, 3, 4.5, 7),
  );

  static DynamicColor surface = DynamicColor.fromPalette(
    name: 'surface',
    palette: (s) => s.neutralPalette,
    tone: (s) => s.isDark ? 6 : 98,
    isBackground: true,
  );

  static DynamicColor surfaceDim = DynamicColor.fromPalette(
    name: 'surface_dim',
    palette: (s) => s.neutralPalette,
    tone: (s) =>
        s.isDark ? 6 : ContrastCurve(87, 87, 80, 75).get(s.contrastLevel),
    isBackground: true,
  );

  static DynamicColor surfaceBright = DynamicColor.fromPalette(
    name: 'surface_bright',
    palette: (s) => s.neutralPalette,
    tone: (s) =>
        s.isDark ? ContrastCurve(24, 24, 29, 34).get(s.contrastLevel) : 98,
    isBackground: true,
  );

  static DynamicColor surfaceContainerLowest = DynamicColor.fromPalette(
    name: 'surface_container_lowest',
    palette: (s) => s.neutralPalette,
    tone: (s) =>
        s.isDark ? ContrastCurve(4, 4, 2, 0).get(s.contrastLevel) : 100,
    isBackground: true,
  );

  static DynamicColor surfaceContainerLow = DynamicColor.fromPalette(
    name: 'surface_container_low',
    palette: (s) => s.neutralPalette,
    tone: (s) => s.isDark
        ? ContrastCurve(10, 10, 11, 12).get(s.contrastLevel)
        : ContrastCurve(96, 96, 96, 95).get(s.contrastLevel),
    isBackground: true,
  );

  static DynamicColor surfaceContainer = DynamicColor.fromPalette(
    name: 'surface_container',
    palette: (s) => s.neutralPalette,
    tone: (s) => s.isDark
        ? ContrastCurve(12, 12, 16, 20).get(s.contrastLevel)
        : ContrastCurve(94, 94, 92, 90).get(s.contrastLevel),
    isBackground: true,
  );

  static DynamicColor surfaceContainerHigh = DynamicColor.fromPalette(
    name: 'surface_container_high',
    palette: (s) => s.neutralPalette,
    tone: (s) => s.isDark
        ? ContrastCurve(17, 17, 21, 25).get(s.contrastLevel)
        : ContrastCurve(92, 92, 88, 85).get(s.contrastLevel),
    isBackground: true,
  );

  static DynamicColor surfaceContainerHighest = DynamicColor.fromPalette(
    name: 'surface_container_highest',
    palette: (s) => s.neutralPalette,
    tone: (s) => s.isDark
        ? ContrastCurve(22, 22, 26, 30).get(s.contrastLevel)
        : ContrastCurve(90, 90, 84, 80).get(s.contrastLevel),
    isBackground: true,
  );

  static DynamicColor onSurface = DynamicColor.fromPalette(
    name: 'on_surface',
    palette: (s) => s.neutralPalette,
    tone: (s) => s.isDark ? 90 : 10,
    background: (s) => MaterialDynamicColors.highestSurface(s),
    contrastCurve: ContrastCurve(4.5, 7, 11, 21),
  );

  static DynamicColor surfaceVariant = DynamicColor.fromPalette(
    name: 'surface_variant',
    palette: (s) => s.neutralVariantPalette,
    tone: (s) => s.isDark ? 30 : 90,
    isBackground: true,
  );

  static DynamicColor onSurfaceVariant = DynamicColor.fromPalette(
    name: 'on_surface_variant',
    palette: (s) => s.neutralVariantPalette,
    tone: (s) => s.isDark ? 80 : 30,
    background: (s) => MaterialDynamicColors.highestSurface(s),
    contrastCurve: ContrastCurve(3, 4.5, 7, 11),
  );

  static DynamicColor inverseSurface = DynamicColor.fromPalette(
    name: 'inverse_surface',
    palette: (s) => s.neutralPalette,
    tone: (s) => s.isDark ? 90 : 20,
  );

  static DynamicColor inverseOnSurface = DynamicColor.fromPalette(
    name: 'inverse_on_surface',
    palette: (s) => s.neutralPalette,
    tone: (s) => s.isDark ? 20 : 95,
    background: (s) => MaterialDynamicColors.inverseSurface,
    contrastCurve: ContrastCurve(4.5, 7, 11, 21),
  );

  static DynamicColor outline = DynamicColor.fromPalette(
    name: 'outline',
    palette: (s) => s.neutralVariantPalette,
    tone: (s) => s.isDark ? 60 : 50,
    background: (s) => MaterialDynamicColors.highestSurface(s),
    contrastCurve: ContrastCurve(1.5, 3, 4.5, 7),
  );

  static DynamicColor outlineVariant = DynamicColor.fromPalette(
    name: 'outline_variant',
    palette: (s) => s.neutralVariantPalette,
    tone: (s) => s.isDark ? 30 : 80,
    background: (s) => MaterialDynamicColors.highestSurface(s),
    contrastCurve: ContrastCurve(1, 1, 3, 4.5),
  );

  static DynamicColor shadow = DynamicColor.fromPalette(
    name: 'shadow',
    palette: (s) => s.neutralPalette,
    tone: (s) => 0,
  );

  static DynamicColor scrim = DynamicColor.fromPalette(
    name: 'scrim',
    palette: (s) => s.neutralPalette,
    tone: (s) => 0,
  );

  static DynamicColor surfaceTint = DynamicColor.fromPalette(
    name: 'surface_tint',
    palette: (s) => s.primaryPalette,
    tone: (s) => s.isDark ? 80 : 40,
    isBackground: true,
  );

  static DynamicColor primary = DynamicColor.fromPalette(
    name: 'primary',
    palette: (s) => s.primaryPalette,
    tone: (s) {
      if (_isMonochrome(s)) {
        return s.isDark ? 100 : 0;
      }
      return s.isDark ? 80 : 40;
    },
    isBackground: true,
    background: (s) => MaterialDynamicColors.highestSurface(s),
    contrastCurve: ContrastCurve(3, 4.5, 7, 7),
    toneDeltaPair: (s) => ToneDeltaPair(MaterialDynamicColors.primaryContainer,
        MaterialDynamicColors.primary, 10, TonePolarity.nearer, false),
  );

  static DynamicColor onPrimary = DynamicColor.fromPalette(
    name: 'on_primary',
    palette: (s) => s.primaryPalette,
    tone: (s) {
      if (_isMonochrome(s)) {
        return s.isDark ? 10 : 90;
      }
      return s.isDark ? 20 : 100;
    },
    background: (s) => MaterialDynamicColors.primary,
    contrastCurve: ContrastCurve(4.5, 7, 11, 21),
  );

  static DynamicColor primaryContainer = DynamicColor.fromPalette(
    name: 'primary_container',
    palette: (s) => s.primaryPalette,
    tone: (s) {
      if (_isFidelity(s)) {
        return s.sourceColorHct.tone;
      }
      if (_isMonochrome(s)) {
        return s.isDark ? 85 : 25;
      }
      return s.isDark ? 30 : 90;
    },
    isBackground: true,
    background: (s) => MaterialDynamicColors.highestSurface(s),
    contrastCurve: ContrastCurve(1, 1, 3, 4.5),
    toneDeltaPair: (s) => ToneDeltaPair(MaterialDynamicColors.primaryContainer,
        MaterialDynamicColors.primary, 10, TonePolarity.nearer, false),
  );

  static DynamicColor onPrimaryContainer = DynamicColor.fromPalette(
    name: 'on_primary_container',
    palette: (s) => s.primaryPalette,
    tone: (s) {
      if (_isFidelity(s)) {
        return DynamicColor.foregroundTone(
            MaterialDynamicColors.primaryContainer.tone(s), 4.5);
      }
      if (_isMonochrome(s)) {
        return s.isDark ? 0 : 100;
      }
      return s.isDark ? 90 : 10;
    },
    background: (s) => MaterialDynamicColors.primaryContainer,
    contrastCurve: ContrastCurve(4.5, 7, 11, 21),
  );

  static DynamicColor inversePrimary = DynamicColor.fromPalette(
    name: 'inverse_primary',
    palette: (s) => s.primaryPalette,
    tone: (s) => s.isDark ? 40 : 80,
    background: (s) => MaterialDynamicColors.inverseSurface,
    contrastCurve: ContrastCurve(3, 4.5, 7, 7),
  );

  static DynamicColor secondary = DynamicColor.fromPalette(
    name: 'secondary',
    palette: (s) => s.secondaryPalette,
    tone: (s) => s.isDark ? 80 : 40,
    isBackground: true,
    background: (s) => MaterialDynamicColors.highestSurface(s),
    contrastCurve: ContrastCurve(3, 4.5, 7, 7),
    toneDeltaPair: (s) => ToneDeltaPair(
        MaterialDynamicColors.secondaryContainer,
        MaterialDynamicColors.secondary,
        10,
        TonePolarity.nearer,
        false),
  );

  static DynamicColor onSecondary = DynamicColor.fromPalette(
    name: 'on_secondary',
    palette: (s) => s.secondaryPalette,
    tone: (s) {
      if (_isMonochrome(s)) {
        return s.isDark ? 10 : 100;
      } else {
        return s.isDark ? 20 : 100;
      }
    },
    background: (s) => MaterialDynamicColors.secondary,
    contrastCurve: ContrastCurve(4.5, 7, 11, 21),
  );

  static DynamicColor secondaryContainer = DynamicColor.fromPalette(
    name: 'secondary_container',
    palette: (s) => s.secondaryPalette,
    tone: (s) {
      final initialTone = s.isDark ? 30.0 : 90.0;
      if (_isMonochrome(s)) {
        return s.isDark ? 30 : 85;
      }
      if (!_isFidelity(s)) {
        return initialTone;
      }
      return _findDesiredChromaByTone(s.secondaryPalette.hue,
          s.secondaryPalette.chroma, initialTone, s.isDark ? false : true);
    },
    isBackground: true,
    background: (s) => MaterialDynamicColors.highestSurface(s),
    contrastCurve: ContrastCurve(1, 1, 3, 4.5),
    toneDeltaPair: (s) => ToneDeltaPair(
        MaterialDynamicColors.secondaryContainer,
        MaterialDynamicColors.secondary,
        10,
        TonePolarity.nearer,
        false),
  );

  static DynamicColor onSecondaryContainer = DynamicColor.fromPalette(
    name: 'on_secondary_container',
    palette: (s) => s.secondaryPalette,
    tone: (s) {
      if (!_isFidelity(s)) {
        return s.isDark ? 90 : 10;
      }
      return DynamicColor.foregroundTone(
          MaterialDynamicColors.secondaryContainer.tone(s), 4.5);
    },
    background: (s) => MaterialDynamicColors.secondaryContainer,
    contrastCurve: ContrastCurve(4.5, 7, 11, 21),
  );

  static DynamicColor tertiary = DynamicColor.fromPalette(
    name: 'tertiary',
    palette: (s) => s.tertiaryPalette,
    tone: (s) {
      if (_isMonochrome(s)) {
        return s.isDark ? 90 : 25;
      }
      return s.isDark ? 80 : 40;
    },
    isBackground: true,
    background: (s) => MaterialDynamicColors.highestSurface(s),
    contrastCurve: ContrastCurve(3, 4.5, 7, 7),
    toneDeltaPair: (s) => ToneDeltaPair(MaterialDynamicColors.tertiaryContainer,
        MaterialDynamicColors.tertiary, 10, TonePolarity.nearer, false),
  );

  static DynamicColor onTertiary = DynamicColor.fromPalette(
    name: 'on_tertiary',
    palette: (s) => s.tertiaryPalette,
    tone: (s) {
      if (_isMonochrome(s)) {
        return s.isDark ? 10 : 90;
      }
      return s.isDark ? 20 : 100;
    },
    background: (s) => MaterialDynamicColors.tertiary,
    contrastCurve: ContrastCurve(4.5, 7, 11, 21),
  );

  static DynamicColor tertiaryContainer = DynamicColor.fromPalette(
    name: 'tertiary_container',
    palette: (s) => s.tertiaryPalette,
    tone: (s) {
      if (_isMonochrome(s)) {
        return s.isDark ? 60 : 49;
      }
      if (!_isFidelity(s)) {
        return s.isDark ? 30 : 90;
      }
      final proposedHct = s.tertiaryPalette.getHct(s.sourceColorHct.tone);
      return DislikeAnalyzer.fixIfDisliked(proposedHct).tone;
    },
    isBackground: true,
    background: (s) => MaterialDynamicColors.highestSurface(s),
    contrastCurve: ContrastCurve(1, 1, 3, 4.5),
    toneDeltaPair: (s) => ToneDeltaPair(MaterialDynamicColors.tertiaryContainer,
        MaterialDynamicColors.tertiary, 10, TonePolarity.nearer, false),
  );

  static DynamicColor onTertiaryContainer = DynamicColor.fromPalette(
    name: 'on_tertiary_container',
    palette: (s) => s.tertiaryPalette,
    tone: (s) {
      if (_isMonochrome(s)) {
        return s.isDark ? 0 : 100;
      }
      if (!_isFidelity(s)) {
        return s.isDark ? 90 : 10;
      }
      return DynamicColor.foregroundTone(
          MaterialDynamicColors.tertiaryContainer.tone(s), 4.5);
    },
    background: (s) => MaterialDynamicColors.tertiaryContainer,
    contrastCurve: ContrastCurve(4.5, 7, 11, 21),
  );

  static DynamicColor error = DynamicColor.fromPalette(
    name: 'error',
    palette: (s) => s.errorPalette,
    tone: (s) => s.isDark ? 80 : 40,
    isBackground: true,
    background: (s) => MaterialDynamicColors.highestSurface(s),
    contrastCurve: ContrastCurve(3, 4.5, 7, 7),
    toneDeltaPair: (s) => ToneDeltaPair(MaterialDynamicColors.errorContainer,
        MaterialDynamicColors.error, 10, TonePolarity.nearer, false),
  );

  static DynamicColor onError = DynamicColor.fromPalette(
    name: 'on_error',
    palette: (s) => s.errorPalette,
    tone: (s) => s.isDark ? 20 : 100,
    background: (s) => MaterialDynamicColors.error,
    contrastCurve: ContrastCurve(4.5, 7, 11, 21),
  );

  static DynamicColor errorContainer = DynamicColor.fromPalette(
    name: 'error_container',
    palette: (s) => s.errorPalette,
    tone: (s) => s.isDark ? 30 : 90,
    isBackground: true,
    background: (s) => MaterialDynamicColors.highestSurface(s),
    contrastCurve: ContrastCurve(1, 1, 3, 4.5),
    toneDeltaPair: (s) => ToneDeltaPair(MaterialDynamicColors.errorContainer,
        MaterialDynamicColors.error, 10, TonePolarity.nearer, false),
  );

  static DynamicColor onErrorContainer = DynamicColor.fromPalette(
    name: 'on_error_container',
    palette: (s) => s.errorPalette,
    tone: (s) => s.isDark ? 90 : 10,
    background: (s) => MaterialDynamicColors.errorContainer,
    contrastCurve: ContrastCurve(4.5, 7, 11, 21),
  );

  static DynamicColor primaryFixed = DynamicColor.fromPalette(
    name: 'primary_fixed',
    palette: (s) => s.primaryPalette,
    tone: (s) => _isMonochrome(s) ? 40.0 : 90.0,
    isBackground: true,
    background: (s) => MaterialDynamicColors.highestSurface(s),
    contrastCurve: ContrastCurve(1, 1, 3, 4.5),
    toneDeltaPair: (s) => ToneDeltaPair(MaterialDynamicColors.primaryFixed,
        MaterialDynamicColors.primaryFixedDim, 10, TonePolarity.lighter, true),
  );

  static DynamicColor primaryFixedDim = DynamicColor.fromPalette(
    name: 'primary_fixed_dim',
    palette: (s) => s.primaryPalette,
    tone: (s) => _isMonochrome(s) ? 30.0 : 80.0,
    isBackground: true,
    background: (s) => MaterialDynamicColors.highestSurface(s),
    contrastCurve: ContrastCurve(1, 1, 3, 4.5),
    toneDeltaPair: (s) => ToneDeltaPair(MaterialDynamicColors.primaryFixed,
        MaterialDynamicColors.primaryFixedDim, 10, TonePolarity.lighter, true),
  );

  static DynamicColor onPrimaryFixed = DynamicColor.fromPalette(
    name: 'on_primary_fixed',
    palette: (s) => s.primaryPalette,
    tone: (s) => _isMonochrome(s) ? 100.0 : 10.0,
    background: (s) => MaterialDynamicColors.primaryFixedDim,
    secondBackground: (s) => MaterialDynamicColors.primaryFixed,
    contrastCurve: ContrastCurve(4.5, 7, 11, 21),
  );

  static DynamicColor onPrimaryFixedVariant = DynamicColor.fromPalette(
    name: 'on_primary_fixed_variant',
    palette: (s) => s.primaryPalette,
    tone: (s) => _isMonochrome(s) ? 90.0 : 30.0,
    background: (s) => MaterialDynamicColors.primaryFixedDim,
    secondBackground: (s) => MaterialDynamicColors.primaryFixed,
    contrastCurve: ContrastCurve(3, 4.5, 7, 11),
  );

  static DynamicColor secondaryFixed = DynamicColor.fromPalette(
    name: 'secondary_fixed',
    palette: (s) => s.secondaryPalette,
    tone: (s) => _isMonochrome(s) ? 80.0 : 90.0,
    isBackground: true,
    background: (s) => MaterialDynamicColors.highestSurface(s),
    contrastCurve: ContrastCurve(1, 1, 3, 4.5),
    toneDeltaPair: (s) => ToneDeltaPair(
        MaterialDynamicColors.secondaryFixed,
        MaterialDynamicColors.secondaryFixedDim,
        10,
        TonePolarity.lighter,
        true),
  );

  static DynamicColor secondaryFixedDim = DynamicColor.fromPalette(
    name: 'secondary_fixed_dim',
    palette: (s) => s.secondaryPalette,
    tone: (s) => _isMonochrome(s) ? 70.0 : 80.0,
    isBackground: true,
    background: (s) => MaterialDynamicColors.highestSurface(s),
    contrastCurve: ContrastCurve(1, 1, 3, 4.5),
    toneDeltaPair: (s) => ToneDeltaPair(
        MaterialDynamicColors.secondaryFixed,
        MaterialDynamicColors.secondaryFixedDim,
        10,
        TonePolarity.lighter,
        true),
  );

  static DynamicColor onSecondaryFixed = DynamicColor.fromPalette(
    name: 'on_secondary_fixed',
    palette: (s) => s.secondaryPalette,
    tone: (s) => 10.0,
    background: (s) => MaterialDynamicColors.secondaryFixedDim,
    secondBackground: (s) => MaterialDynamicColors.secondaryFixed,
    contrastCurve: ContrastCurve(4.5, 7, 11, 21),
  );

  static DynamicColor onSecondaryFixedVariant = DynamicColor.fromPalette(
    name: 'on_secondary_fixed_variant',
    palette: (s) => s.secondaryPalette,
    tone: (s) => _isMonochrome(s) ? 25.0 : 30.0,
    background: (s) => MaterialDynamicColors.secondaryFixedDim,
    secondBackground: (s) => MaterialDynamicColors.secondaryFixed,
    contrastCurve: ContrastCurve(3, 4.5, 7, 11),
  );

  static DynamicColor tertiaryFixed = DynamicColor.fromPalette(
    name: 'tertiary_fixed',
    palette: (s) => s.tertiaryPalette,
    tone: (s) => _isMonochrome(s) ? 40.0 : 90.0,
    isBackground: true,
    background: (s) => MaterialDynamicColors.highestSurface(s),
    contrastCurve: ContrastCurve(1, 1, 3, 4.5),
    toneDeltaPair: (s) => ToneDeltaPair(MaterialDynamicColors.tertiaryFixed,
        MaterialDynamicColors.tertiaryFixedDim, 10, TonePolarity.lighter, true),
  );

  static DynamicColor tertiaryFixedDim = DynamicColor.fromPalette(
    name: 'tertiary_fixed_dim',
    palette: (s) => s.tertiaryPalette,
    tone: (s) => _isMonochrome(s) ? 30.0 : 80.0,
    isBackground: true,
    background: (s) => MaterialDynamicColors.highestSurface(s),
    contrastCurve: ContrastCurve(1, 1, 3, 4.5),
    toneDeltaPair: (s) => ToneDeltaPair(MaterialDynamicColors.tertiaryFixed,
        MaterialDynamicColors.tertiaryFixedDim, 10, TonePolarity.lighter, true),
  );

  static DynamicColor onTertiaryFixed = DynamicColor.fromPalette(
    name: 'on_tertiary_fixed',
    palette: (s) => s.tertiaryPalette,
    tone: (s) => _isMonochrome(s) ? 100.0 : 10.0,
    background: (s) => MaterialDynamicColors.tertiaryFixedDim,
    secondBackground: (s) => MaterialDynamicColors.tertiaryFixed,
    contrastCurve: ContrastCurve(4.5, 7, 11, 21),
  );

  static DynamicColor onTertiaryFixedVariant = DynamicColor.fromPalette(
    name: 'on_tertiary_fixed_variant',
    palette: (s) => s.tertiaryPalette,
    tone: (s) => _isMonochrome(s) ? 90.0 : 30.0,
    background: (s) => MaterialDynamicColors.tertiaryFixedDim,
    secondBackground: (s) => MaterialDynamicColors.tertiaryFixed,
    contrastCurve: ContrastCurve(3, 4.5, 7, 11),
  );

  static double _findDesiredChromaByTone(
      double hue, double chroma, double tone, bool byDecreasingTone) {
    var answer = tone;

    Hct closestToChroma = Hct.from(hue, chroma, tone);
    if (closestToChroma.chroma < chroma) {
      double chromaPeak = closestToChroma.chroma;
      while (closestToChroma.chroma < chroma) {
        answer += byDecreasingTone ? -1.0 : 1.0;
        final potentialSolution = Hct.from(hue, chroma, answer);
        if (chromaPeak > potentialSolution.chroma) {
          break;
        }
        if ((potentialSolution.chroma - chroma).abs() < 0.4) {
          break;
        }

        final potentialDelta = (potentialSolution.chroma - chroma).abs();
        final currentDelta = (closestToChroma.chroma - chroma).abs();
        if (potentialDelta < currentDelta) {
          closestToChroma = potentialSolution;
        }
        chromaPeak = math.max(chromaPeak, potentialSolution.chroma);
      }
    }

    return answer;
  }
}
