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
      primary: core.a1.get(40),
      onPrimary: core.a1.get(100),
      primaryContainer: core.a1.get(90),
      onPrimaryContainer: core.a1.get(10),
      secondary: core.a2.get(40),
      onSecondary: core.a2.get(100),
      secondaryContainer: core.a2.get(90),
      onSecondaryContainer: core.a2.get(10),
      tertiary: core.a3.get(40),
      onTertiary: core.a3.get(100),
      tertiaryContainer: core.a3.get(90),
      onTertiaryContainer: core.a3.get(10),
      error: core.error.get(40),
      onError: core.error.get(100),
      errorContainer: core.error.get(90),
      onErrorContainer: core.error.get(10),
      outline: core.n2.get(50),
      background: core.n1.get(90),
      onBackground: core.n1.get(10),
      surface: core.n1.get(99),
      onSurface: core.n1.get(0),
      surfaceVariant: core.n2.get(90),
      onSurfaceVariant: core.n2.get(30),
      inverseSurface: core.n1.get(20),
      inverseOnSurface: core.n1.get(95),
      inversePrimary: core.a1.get(80),
      shadow: core.n1.get(0),
    );
  }

  static Scheme dark(int color) {
    final core = CorePalette.of(color);
    return Scheme(
      primary: core.a1.get(80),
      onPrimary: core.a1.get(20),
      primaryContainer: core.a1.get(70),
      onPrimaryContainer: core.a1.get(10),
      secondary: core.a2.get(80),
      onSecondary: core.a2.get(20),
      secondaryContainer: core.a2.get(70),
      onSecondaryContainer: core.a2.get(10),
      tertiary: core.a3.get(80),
      onTertiary: core.a3.get(20),
      tertiaryContainer: core.a3.get(70),
      onTertiaryContainer: core.a3.get(10),
      error: core.error.get(80),
      onError: core.error.get(20),
      errorContainer: core.error.get(70),
      onErrorContainer: core.error.get(10),
      outline: core.n2.get(60),
      background: core.n1.get(10),
      onBackground: core.n1.get(90),
      surface: core.n1.get(10),
      onSurface: core.n1.get(100),
      surfaceVariant: core.n2.get(30),
      onSurfaceVariant: core.n2.get(80),
      inverseSurface: core.n1.get(90),
      inverseOnSurface: core.n1.get(20),
      inversePrimary: core.a1.get(40),
      shadow: core.n1.get(0),
    );
  }
}
