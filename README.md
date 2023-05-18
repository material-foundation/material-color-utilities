# Material Color Utilities

Algorithms and utilities that power the Material Design 3 (M3) color system,
including choosing theme colors from images and creating tones of colors; all in
a new color space.

<video autoplay muted loop src="https://user-images.githubusercontent.com/6655696/146014425-8e8e04bc-e646-4cc2-a3e7-97497a3e1b09.mp4" data-canonical-src="https://user-images.githubusercontent.com/6655696/146014425-8e8e04bc-e646-4cc2-a3e7-97497a3e1b09.mp4" class="d-block rounded-bottom-2 width-fit" style="max-width:640px;"></video>

## Library availability


Language    | Availability  | Location
----------- | ------------- | --------
C++         | ✅             |
Dart        | ✅             | [![pub package](https://img.shields.io/pub/v/material_color_utilities.svg)](https://pub.dev/packages/material_color_utilities)
Java        | ✅             | [MDC-Android](https://github.com/material-components/material-components-android/blob/master/docs/theming/Color.md)
Swift       | ✅             |
TypeScript  | ✅             | [![npm package](https://badgen.net/npm/v/@material/material-color-utilities)](https://npmjs.com/package/@material/material-color-utilities)
GLSL        | *Coming soon* |

Need another platform/language? Check the
[existing issues](https://github.com/material-foundation/material-color-utilities/labels/library%3A%20new)
or open a new one.

## Usage

### Cheat sheet

<a href="https://github.com/material-foundation/material-color-utilities/raw/main/cheat_sheet.png">
    <img alt="library cheat sheet" src="https://github.com/material-foundation/material-color-utilities/raw/main/cheat_sheet.png" style="max-width:640px;" />
</a>

### Components

The library is composed of multiple components, each with its own folder and
tests, each as small as possible.

This enables easy merging and updating of subsets into other libraries, such as
Material Design Components, Android System UI, etc. Not all consumers will need
every component — ex. MDC doesn’t need quantization/scoring/image extraction.


| Components       | Purpose                                                   |
| ---------------- | --------------------------------------------------------- |
| **blend**        | Interpolate, harmonize, animate, and gradate colors in HCT |
| **contrast**     | Measure contrast, obtain contrastful colors               |
| **dislike**      | Check and fix universally disliked colors                 |
| **dynamiccolor** | Obtain colors that adjust based on UI state (dark theme, style, preferences, contrast requirements, etc.) |
| **hct**          | A new color space (hue, chrome, tone) based on CAM16 x L*, that accounts for viewing conditions |
| **palettes**     | Tonal palette — range of colors that varies only in tone <br>Core palette — set of tonal palettes needed to create Material color schemes |
| **quantize**     | Turn an image into N colors; composed of Celebi, which runs Wu, then WSMeans |
| **scheme**       | Create static and dynamic color schemes from a single color or a core palette |
| **score**        | Rank colors for suitability for theming                   |
| **temperature**  | Obtain analogous and complementary colors                 |
| **utilities**    | Color — convert between color spaces needed to implement HCT/CAM16 <br>Math — functions for ex. ensuring hue is between 0 and 360, clamping, etc. <br>String - convert between strings and integers |

## Background

[The Science of Color & Design - Material Design](https://material.io/blog/science-of-color-design)

## Design tooling

The
[Material Theme Builder](https://www.figma.com/community/plugin/1034969338659738588/Material-Theme-Builder)
Figma plugin and
[web tool](https://material-foundation.github.io/material-theme-builder/) are
recommended for design workflows. The Material Theme Builder delivers dynamic
color to where design is done. Designers can take an existing design, and see
what it looks like under different themes, with just a couple clicks.
