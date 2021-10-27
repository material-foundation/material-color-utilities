# Material color utilities

Algorithms and utilities used for Material You, such as a new color
space, choosing theme colors from images, and creating tones of colors.

## Code availability

Language    | Availability  | Notes
----------- | ------------- | --------------------------------------------
C/C++       | *Coming soon* |
Dart        | ✅             | `material_color_utilities` package available
Java        | ✅             |
Objective-C | *Coming soon* |
TypeScript  | ✅             |

Need another platform/language?
[Open an issue](https://github.com/material-foundation/material-color-utilities/issues/new?title=%5BLanguage%2FPlatform%20request%5D%20x).

## Usage

### Image to color

A common use case for this library is extracting a single color from an image.
Here's how to do that:

#### Dart

```dart
// TODO(plg): add code
```

#### Java

```java
// TODO(jamesoleary): add code
```

#### TypeScript

```ts
// TODO(plg): add code
```

## Cheat sheet

![library cheat sheet](g3doc/cheat_sheet.png)

## Background

Learn about the [M3 color system]
https://m3.material.io/styles/color/the-color-system/key-colors-tones.

## Components

The library is built out of multiple components

*   each with its own folder and tests
*   each as small as possible

This enables easy merging and updating of subsets into other libraries, such as
Material Design Components, Android System UI, etc.

*   Not all consumers will need every component — ex. MDC doesn’t need
    quantization/scoring/image extraction

### Quantize

*   Turns a wallpaper into N colors
*   Celebi, which runs Wu, then WSMeans

### Score

*   Rank colors for suitability for theming
*   Quantize buckets a wallpaper into 128 colors
*   Enables deduplicating and ranking that output.

### Scheme

*   Mapping from roles, i.e. names like primary, to colors.

### Palettes

*   Tonal Palette — range of colors that varies only in tone
*   Core Palette — set of tonal palettes needed to create Material color schemes

### HCT

*   Hue, chroma, tone
*   A new color space based on CAM16 x L*
*   Accounts for viewing conditions

### Blend

*   Color interpolation in HCT
*   Harmonizing, animations, gradients

### Utils

*   Color — conversions between color spaces needed to implement HCT/CAM16
*   Math — functions for ex. ensuring hue is between 0 and 360, clamping, etc.
