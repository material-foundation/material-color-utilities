## 0.8.0 - 2023-06-22
### Added
- Add fruit salad color scheme
- Add rainbow color scheme

## 0.7.0 - 2023-06-13
### Changed
- Updated `DynamicColor` so that it conforms to the new contrast requirements.
    - API for `DynamicColor` modified.

## 0.6.0 - 2023-05-31
### Added
- Add key color to tonal palette.
- Add key colors to the Material dynamic colors:
    - `primaryPaletteKeyColor`
    - `secondaryPaletteKeyColor`
    - `tertiaryPaletteKeyColor`
    - `neutralPaletteKeyColor`
    - `neutralVariantPaletteKeyColor`

### Changed
- Scheme updates to align with recent Android Sys UI changes:
    - `SchemeExpressive`:
        - Primary hue + 240 from 120
        - Neutral hue + 15
        - Neutral variant hue + 15
    - `SchemeTonalSpot`:
        - Primary chroma = 36 from 40
    - `SchemeVibrant`:
        - Neutral chroma = 10 from 8

### Fixed
- Fixed outline when in dark mode to be tone 60.

## 0.5.0 - 2023-05-02
### Removed
- Removed `inverseOnPrimary`, an unfounded dynamic color

## 0.4.0 - 2023-04-28
### Added
- Add `label` and `description` to each `Variant`
- Add `xFixed` Material dynamic colors

### Changed
- Update monochrome scheme to new spec

## Fixed
- Fix `inverseSurface` tone value

## 0.3.0 - 2023-03-10
### Added

- Add 4 new components:
    - `contrast`: Use `Contrast` for utility methods
    - `dislike`: Use `DislikeAnalyzer` for checking and fixing universally disliked colors
    - `dynamiccolor`: Use `DynamicColor` and `MaterialDynamicColors` for colors from a `DynamicScheme`, that adjust based on UI state
        (dark theme, style, preferences, contrast requirements, etc.)
    - `temperature`: Use `TemperatureCache` for analogous & complementary colors
- `scheme`: Add `DynamicScheme` and its subclasses:
    - `SchemeExpressive`
    - `SchemeMonochrome`
    - `SchemeNeutral`
    - `SchemeTonalSpot`
    - `SchemeVibrant`
    - `SchemeFidelity`
    - `SchemeContent`
- `hct`: Add `inViewingConditions` to `hct`, for color relativity
- `utilities`: Add `lstarFromY` method, utility to which is the inverse of `yFromLstar`


### Changed
- Export all public API in `material_color_utilities.dart`
- Bump minimum Flutter SDK version to `2.17.0`

### Fixed
- Fix missing `hashCode` override for `Hct`
- Fix `TonalPalette` equality operator when different constructors are used ([#56](https://github.com/material-foundation/material-color-utilities/issues/56))

## 0.2.0 - 2022-08-05
### Added
- Add support for content color
- Add `outlineVariant` and `scrim` colors

### Changed
- Rename `CamSolver` to `HctSolver`

### Fixed
- Correct `repository` in pubspec

## 0.1.5 - 2022-04-25
### Added
- Introduce `CamSolver`, a fast solver for the HCT equation. Highly performant, but a small breaking change
- Add explanation and link to `dynamic_color` packages
- Add `operator ==` and `toString` overrides to `Hct`

### Changed
- Improve documentation for `color_utils.dart`
- Rename `HctColor` to `Hct`

### Fixed
- Fix README import

## 0.1.4 - 2022-01-21
### Added
- Allow creation of `Scheme` from a `CorePalette` with `lightFromCorePalette`
    and `darkFromCorePalette`

## 0.1.3 - 2021-12-10
### Added
- Export `Scheme`

## 0.1.2 - 2021-12-02
### Changed
- Update `Scheme` tonal values
- Move `matcher` to pubspec's `dev_dependencies`

## 0.1.1 - 2021-10-28
### Changed
- Update pubspec `description`

### Fixed
- Fix `matcher` version incompatibility with flutter stable

## 0.1.0 - 2021-10-28
### Added
- Create library
