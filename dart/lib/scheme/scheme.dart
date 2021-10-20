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

import 'package:material_color_utilities/palettes/core_palette.dart';

/// Prefer [ColorScheme]. This class is the same concept as Flutter's
/// ColorScheme class, inlined into libmonet to ensure parity across languages.
class Scheme {
  final int primary;
  final int onPrimary;
  final int primaryContainer;
  final int onPrimaryContainer;
  final int secondary;
  final int onSecondary;
  final int secondaryContainer;
  final int onSecondaryContainer;
  final int tertiary;
  final int onTertiary;
  final int tertiaryContainer;
  final int onTertiaryContainer;
  final int error;
  final int onError;
  final int errorContainer;
  final int onErrorContainer;
  final int outline;
  final int background;
  final int onBackground;
  final int surface;
  final int onSurface;
  final int surfaceVariant;
  final int onSurfaceVariant;
  final int inverseSurface;
  final int inverseOnSurface;
  final int inversePrimary;
  final int shadow;

  const Scheme(
      {required this.primary,
      required this.onPrimary,
      required this.primaryContainer,
      required this.onPrimaryContainer,
      required this.secondary,
      required this.onSecondary,
      required this.secondaryContainer,
      required this.onSecondaryContainer,
      required this.tertiary,
      required this.onTertiary,
      required this.tertiaryContainer,
      required this.onTertiaryContainer,
      required this.error,
      required this.onError,
      required this.errorContainer,
      required this.onErrorContainer,
      required this.outline,
      required this.background,
      required this.onBackground,
      required this.surface,
      required this.onSurface,
      required this.surfaceVariant,
      required this.onSurfaceVariant,
      required this.inverseSurface,
      required this.inverseOnSurface,
      required this.inversePrimary,
      required this.shadow});

  static Scheme light(int color) {
    final core = CorePalette.of(color);
    return Scheme(
      primary: core.primary.get(40),
      onPrimary: core.primary.get(100),
      primaryContainer: core.primary.get(90),
      onPrimaryContainer: core.primary.get(10),
      secondary: core.secondary.get(40),
      onSecondary: core.secondary.get(100),
      secondaryContainer: core.secondary.get(90),
      onSecondaryContainer: core.secondary.get(10),
      tertiary: core.tertiary.get(40),
      onTertiary: core.tertiary.get(100),
      tertiaryContainer: core.tertiary.get(90),
      onTertiaryContainer: core.tertiary.get(10),
      error: core.error.get(40),
      onError: core.error.get(100),
      errorContainer: core.error.get(90),
      onErrorContainer: core.error.get(10),
      outline: core.neutralVariant.get(50),
      background: core.neutral.get(90),
      onBackground: core.neutral.get(10),
      surface: core.neutral.get(99),
      onSurface: core.neutral.get(0),
      surfaceVariant: core.neutralVariant.get(90),
      onSurfaceVariant: core.neutralVariant.get(30),
      inverseSurface: core.neutral.get(20),
      inverseOnSurface: core.neutral.get(95),
      inversePrimary: core.primary.get(80),
      shadow: core.neutral.get(0),
    );
  }

  static Scheme dark(int color) {
    final core = CorePalette.of(color);
    return Scheme(
      primary: core.primary.get(80),
      onPrimary: core.primary.get(20),
      primaryContainer: core.primary.get(70),
      onPrimaryContainer: core.primary.get(10),
      secondary: core.secondary.get(80),
      onSecondary: core.secondary.get(20),
      secondaryContainer: core.secondary.get(70),
      onSecondaryContainer: core.secondary.get(10),
      tertiary: core.tertiary.get(80),
      onTertiary: core.tertiary.get(20),
      tertiaryContainer: core.tertiary.get(70),
      onTertiaryContainer: core.tertiary.get(10),
      error: core.error.get(80),
      onError: core.error.get(20),
      errorContainer: core.error.get(70),
      onErrorContainer: core.error.get(10),
      outline: core.neutralVariant.get(60),
      background: core.neutral.get(10),
      onBackground: core.neutral.get(90),
      surface: core.neutral.get(10),
      onSurface: core.neutral.get(100),
      surfaceVariant: core.neutralVariant.get(30),
      onSurfaceVariant: core.neutralVariant.get(80),
      inverseSurface: core.neutral.get(90),
      inverseOnSurface: core.neutral.get(20),
      inversePrimary: core.primary.get(40),
      shadow: core.neutral.get(0),
    );
  }
}
