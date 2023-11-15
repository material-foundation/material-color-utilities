// Copyright 2023 Google LLC
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

@available(*, deprecated, message: "Use `DynamicScheme`")
class Scheme {
  let primary: Int
  let onPrimary: Int
  let primaryContainer: Int
  let onPrimaryContainer: Int
  let secondary: Int
  let onSecondary: Int
  let secondaryContainer: Int
  let onSecondaryContainer: Int
  let tertiary: Int
  let onTertiary: Int
  let tertiaryContainer: Int
  let onTertiaryContainer: Int
  let error: Int
  let onError: Int
  let errorContainer: Int
  let onErrorContainer: Int
  let background: Int
  let onBackground: Int
  let surface: Int
  let onSurface: Int
  let surfaceVariant: Int
  let onSurfaceVariant: Int
  let outline: Int
  let outlineVariant: Int
  let shadow: Int
  let scrim: Int
  let inverseSurface: Int
  let inverseOnSurface: Int
  let inversePrimary: Int

  init(
    primary: Int, onPrimary: Int, primaryContainer: Int, onPrimaryContainer: Int, secondary: Int,
    onSecondary: Int, secondaryContainer: Int, onSecondaryContainer: Int, tertiary: Int,
    onTertiary: Int, tertiaryContainer: Int, onTertiaryContainer: Int, error: Int, onError: Int,
    errorContainer: Int, onErrorContainer: Int, background: Int, onBackground: Int, surface: Int,
    onSurface: Int, surfaceVariant: Int, onSurfaceVariant: Int, outline: Int, outlineVariant: Int,
    shadow: Int, scrim: Int, inverseSurface: Int, inverseOnSurface: Int, inversePrimary: Int
  ) {
    self.primary = primary
    self.onPrimary = onPrimary
    self.primaryContainer = primaryContainer
    self.onPrimaryContainer = onPrimaryContainer
    self.secondary = secondary
    self.onSecondary = onSecondary
    self.secondaryContainer = secondaryContainer
    self.onSecondaryContainer = onSecondaryContainer
    self.tertiary = tertiary
    self.onTertiary = onTertiary
    self.tertiaryContainer = tertiaryContainer
    self.onTertiaryContainer = onTertiaryContainer
    self.error = error
    self.onError = onError
    self.errorContainer = errorContainer
    self.onErrorContainer = onErrorContainer
    self.background = background
    self.onBackground = onBackground
    self.surface = surface
    self.onSurface = onSurface
    self.surfaceVariant = surfaceVariant
    self.onSurfaceVariant = onSurfaceVariant
    self.outline = outline
    self.outlineVariant = outlineVariant
    self.shadow = shadow
    self.scrim = scrim
    self.inverseSurface = inverseSurface
    self.inverseOnSurface = inverseOnSurface
    self.inversePrimary = inversePrimary
  }

  static func light(_ color: Int) -> Scheme {
    return lightFromCorePalette(CorePalette.of(color))
  }

  static func lightContent(_ color: Int) -> Scheme {
    return lightFromCorePalette(CorePalette.contentOf(color))
  }

  static func dark(_ color: Int) -> Scheme {
    return darkFromCorePalette(CorePalette.of(color))
  }

  static func darkContent(_ color: Int) -> Scheme {
    return darkFromCorePalette(CorePalette.contentOf(color))
  }

  static func lightFromCorePalette(_ palette: CorePalette) -> Scheme {
    return Scheme(
      primary: palette.primary.tone(40),
      onPrimary: palette.primary.tone(100),
      primaryContainer: palette.primary.tone(90),
      onPrimaryContainer: palette.primary.tone(10),
      secondary: palette.secondary.tone(40),
      onSecondary: palette.secondary.tone(100),
      secondaryContainer: palette.secondary.tone(90),
      onSecondaryContainer: palette.secondary.tone(10),
      tertiary: palette.tertiary.tone(40),
      onTertiary: palette.tertiary.tone(100),
      tertiaryContainer: palette.tertiary.tone(90),
      onTertiaryContainer: palette.tertiary.tone(10),
      error: palette.error.tone(40),
      onError: palette.error.tone(100),
      errorContainer: palette.error.tone(90),
      onErrorContainer: palette.error.tone(10),
      background: palette.neutral.tone(99),
      onBackground: palette.neutral.tone(10),
      surface: palette.neutral.tone(99),
      onSurface: palette.neutral.tone(10),
      surfaceVariant: palette.neutralVariant.tone(90),
      onSurfaceVariant: palette.neutralVariant.tone(30),
      outline: palette.neutralVariant.tone(50),
      outlineVariant: palette.neutralVariant.tone(80),
      shadow: palette.neutral.tone(0),
      scrim: palette.neutral.tone(0),
      inverseSurface: palette.neutral.tone(20),
      inverseOnSurface: palette.neutral.tone(95),
      inversePrimary: palette.primary.tone(80)
    )
  }

  static func darkFromCorePalette(_ palette: CorePalette) -> Scheme {
    return Scheme(
      primary: palette.primary.tone(80),
      onPrimary: palette.primary.tone(20),
      primaryContainer: palette.primary.tone(30),
      onPrimaryContainer: palette.primary.tone(90),
      secondary: palette.secondary.tone(80),
      onSecondary: palette.secondary.tone(20),
      secondaryContainer: palette.secondary.tone(30),
      onSecondaryContainer: palette.secondary.tone(90),
      tertiary: palette.tertiary.tone(80),
      onTertiary: palette.tertiary.tone(20),
      tertiaryContainer: palette.tertiary.tone(30),
      onTertiaryContainer: palette.tertiary.tone(90),
      error: palette.error.tone(80),
      onError: palette.error.tone(20),
      errorContainer: palette.error.tone(30),
      onErrorContainer: palette.error.tone(80),
      background: palette.neutral.tone(10),
      onBackground: palette.neutral.tone(90),
      surface: palette.neutral.tone(10),
      onSurface: palette.neutral.tone(90),
      surfaceVariant: palette.neutralVariant.tone(30),
      onSurfaceVariant: palette.neutralVariant.tone(80),
      outline: palette.neutralVariant.tone(60),
      outlineVariant: palette.neutralVariant.tone(30),
      shadow: palette.neutral.tone(0),
      scrim: palette.neutral.tone(0),
      inverseSurface: palette.neutral.tone(90),
      inverseOnSurface: palette.neutral.tone(20),
      inversePrimary: palette.primary.tone(40)
    )
  }
}
