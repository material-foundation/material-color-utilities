# Material Color Utilities

Color is a powerful design tool and part of the Material system along with
styles like typography and shape. In products, colors and the way they are used
can be vast and varied. An app’s color scheme can express brand and style.
Semantic colors can communicate meaning. And color contrast control supports
visual accessibility.

In many design systems of the past, designers manually picked app colors to
support the necessary range of color applications and use cases. Material 3
introduces a dynamic color system, which does not rely on hand-picked colors.
Instead, it uses color algorithms to generate beautiful, accessible color
schemes based on dynamic inputs like a user’s wallpaper. This enables greater
flexibility, personalization, and expression, all while streamlining work for
designers and teams.

Material Color Ultilities (MCU) powers dynamic color with a set of color
libraries containing algorithms and utilities that make it easier for you to
develop color themes and schemes in your app.

<video autoplay muted loop src="https://user-images.githubusercontent.com/6655696/146014425-8e8e04bc-e646-4cc2-a3e7-97497a3e1b09.mp4" data-canonical-src="https://user-images.githubusercontent.com/6655696/146014425-8e8e04bc-e646-4cc2-a3e7-97497a3e1b09.mp4" class="d-block rounded-bottom-2 width-fit" style="max-width:640px;"></video>

## Library availability


Language    | Availability  | Location
----------- | ------------- | --------
C++         | ✅             |
Dart        | ✅             | [![pub package](https://img.shields.io/pub/v/material_color_utilities.svg)](https://pub.dev/packages/material_color_utilities)
Java        | ✅             | [MDC-Android](https://github.com/material-components/material-components-android/blob/master/docs/theming/Color.md)
Swift       | ✅             |
TypeScript  | ✅             | [![npm package](https://badgen.net/npm/v/@material/material-color-utilities)](https://npmjs.com/package/@material/material-color-utilities)

Need another platform/language? Check the
[existing issues](https://github.com/material-foundation/material-color-utilities/labels/library%3A%20new)
or open a new one.

## Capabilities Overview

<a href="https://github.com/material-foundation/material-color-utilities/raw/main/cheat_sheet.png">
    <img alt="library cheat sheet" src="https://github.com/material-foundation/material-color-utilities/raw/main/cheat_sheet.png" style="max-width:640px;" />
</a>

The library consists of various components, each having its own folder and
 tests, designed to be as self-contained as possible. This enables seamless
 integration of subsets into other libraries, like Material Design Components
 and Android System UI. Some consumers do not require all components, for
 example, MDC doesn’t need quantization, scoring, image extraction.


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

## Learn about color science

[The Science of Color & Design - Material Design](https://material.io/blog/science-of-color-design)

## Try it out

### Material Theme Builder

We recommend incorporating the Material Theme Builder
[Figma plugin](https://www.figma.com/community/plugin/1034969338659738588/Material-Theme-Builder)
and [web tool](https://material-foundation.github.io/material-theme-builder/)
into the design workflow. With them, designers can easily experiment with
different dynamic color themes and see how they transform their designs with
just a few clicks.
