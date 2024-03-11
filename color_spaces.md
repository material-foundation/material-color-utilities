# Color spaces



## Overview

MCU uses multiple **color spaces**. Each color space is useful in a different
area and provides a way to understand colors. This page describes the different
color spaces used and how colors are converted between them in MCU.

## Color space basics

A color space is a coordinate system to describe colors. For example, the
following color, which is a natural phenomenon, can be represented in each color
space using three numbers. The coordinates are different, but they all represent
the same color.

![#ff6600](orange.png)

Color space | Coordinates
----------- | -------------------------------
sRGB        | 255, 102, 0 (hex code: #ff6600)
linear RGB  | 100.00, 13.29, 0.00
XYZ         | 45.99, 30.76, 3.52
L\*a\*b\*   | 62.31, 54.99, 71.33
Cam16-JCH   | 55.16, 79.39, 42.39
Cam16-UCS   | 67.65, 28.75, 26.24
HCT         | 42.39, 79.39, 62.31

The typical human eye has three kind of cone cells: one that reacts most to
short wavelengths (roughly blue), one to medium wavelengths (roughly green), and
one to long wavelengths (roughly red). Lights of different wavelengths create
signals of different strength on the three kinds of cells. Therefore, human
perception of any color can be described by three numbers, which is why each
color space is three-dimensional.

Some color spaces, such as **XYZ**, can represent any color perceived by human
eyes. They are useful as a common ground for objective color description.

The **sRGB** color space is useful for color display. Due to the shape of the
Gamut, there are some colors not representable by three displayable primaries,
and are therefore usually not in the sRGB color space.

## Color spaces used in MCU

*   **sRGB**
    -   A color space used primarily for display. The bit depth for each channel
        is usually 8, meaning there are 256<sup>3</sup> = 16&nbsp;777&nbsp;216
        colors available.
    -   Usually represented by a hexadecimal, such as `#007fff`.
    -   In MCU, an sRGB color usually appears as a hexadecimal number in ARGB
        format: for example, `#abcdef` is `0xffabcdef`. The leading `ff` means
        that this is an opaque color (alpha = `0xff`).
*   **HCT**
    -   The color space created by MCU, a combination between Cam16-JCH and
        L\*a\*b\*.
    -   The main color space of this library. Used to generate schemes, blend
        colors, and treat "disliked" colors.
*   **Cam16**
    -   Cam16 is a **color appearance model** that aims to accurately represent
        human perception of colors. Technically speaking, it is not a color
        space; it contains multiple color spaces.
    -   A `Cam16` object contains 9 components, and can be determined uniquely
        if any of the following are given:
        +   A triple consisting of one of {`j`, `q`}, one of {`chroma`, `m`,
            `s`}, and `hue`
        +   A triple of `jstar`, `astar`, and `bstar`
    -   MCU uses the color spaces **Cam16-JCH** (using the components `j`,
        `chroma`, `hue`) and **Cam16-UCS** (using the components `jstar`,
        `astar`, `bstar`) for different purposes.
    -   How a color appears to a human observer is affected by the surrounding
        environment. The Cam16 model uses the class `ViewingCondition` to
        describe the environment; using different `ViewingCondition` objects on
        the same hex code may create different `Cam16` objects. A standard,
        default `ViewingCondition` is provided in the library.
*   **XYZ** (CIEXYZ)
    -   One of the earliest color spaces. This is a linear color space closely
        related to the cone cells' response to light. It is often used
        internally as a common ground to convert between different color spaces.
*   **L\*a\*b\*** (CIELAB)
    -   A color space intended to be perceptually uniform. Used internally for
        image quantization.
    -   L\* represents lightness.
    -   a\* represents how red or green a color is.
    -   b\* represents how yellow or blue a color is.
*   **Linear RGB** (`linrgb`)
    -   A linearization of the sRGB color space, with no restriction on bit
        depth. Used internally for the HCT Solver.

## Conversion between color spaces

<section>

###### Dart

*   sRGB ⇌ HCT
    -   `Hct.fromInt(argb)`
    -   `Hct.from(h, c, t).toInt()`
*   sRGB ⇌ XYZ
    -   `ColorUtils.xyzFromArgb(argb)`
    -   `ColorUtils.argbFromXyz(x, y, z)`
*   sRGB ⇌ Cam16
    -   `Cam16.fromInt(argb)`
    -   `cam16.toInt()`
    -   Constructing a Cam16 from JCH or UCS:
        -   `Cam16.fromJch(j, c, h)`
        -   `Cam16.fromUcs(jstar, astar, bstar)`
*   XYZ ⇌ Cam16
    -   `Cam16.fromXyzInViewingConditions(x, y, z, vc)`
    -   `cam16.xyzInViewingConditions(vc)`
*   sRGB ⇌ L\*a\*b\*
    -   `ColorUtils.labFromArgb(argb)`
    -   `ColorUtils.argbFromLab(l, a, b)`
*   linRGB → sRGB
    -   `ColorUtils.argbFromLinrgb(linrgb)`

###### Java

*   sRGB ⇌ HCT
    -   `Hct.fromInt(argb)`
    -   `Hct.from(h, c, t).toInt()`
*   sRGB ⇌ XYZ
    -   `ColorUtils.xyzFromArgb(argb)`
    -   `ColorUtils.argbFromXyz(x, y, z)`
*   sRGB ⇌ Cam16
    -   `Cam16.fromInt(argb)`
    -   `cam16.toInt()`
    -   Constructing a Cam16 from JCH or UCS:
        -   `Cam16.fromJch(j, c, h)`
        -   `Cam16.fromUcs(jstar, astar, bstar)`
*   XYZ ⇌ Cam16
    -   `Cam16.fromXyzInViewingConditions(x, y, z, vc)`
    -   `cam16.xyzInViewingConditions(vc, returnArray)`
*   sRGB ⇌ L\*a\*b\*
    -   `ColorUtils.labFromArgb(argb)`
    -   `ColorUtils.argbFromLab(l, a, b)`
*   linRGB → sRGB
    -   `ColorUtils.argbFromLinrgb(linrgb)`

###### TypeScript

*   sRGB ⇌ HCT
    -   `Hct.fromInt(argb)`
    -   `Hct.from(h, c, t).toInt()`
*   sRGB ⇌ XYZ
    -   `colorUtils.xyzFromArgb(argb)`
    -   `colorUtils.argbFromXyz(x, y, z)`
*   sRGB ⇌ Cam16
    -   `Cam16.fromInt(argb)`
    -   `cam16.toInt()`
    -   Constructing a Cam16 from JCH or UCS:
        -   `Cam16.fromJch(j, c, h)`
        -   `Cam16.fromUcs(jstar, astar, bstar)`
*   XYZ ⇌ Cam16
    -   `Cam16.fromXyzInViewingConditions(x, y, z, vc)`
    -   `cam16.xyzInViewingConditions(vc)`
*   sRGB ⇌ L\*a\*b\*
    -   `colorUtils.labFromArgb(argb)`
    -   `colorUtils.argbFromLab(l, a, b)`
*   linRGB → sRGB
    -   `colorUtils.argbFromLinrgb(linrgb)`

###### C++

*   sRGB ⇌ HCT
    -   `Hct::Hct(argb)`
    -   `Hct::ToInt()`
*   sRGB ⇌ XYZ — *not provided yet*
*   sRGB ⇌ Cam16
    -   `CamFromInt(argb)`
    -   `IntFromCam(cam)`
    -   (*Cam16 from JCH is not available yet*)
    -   Constructing a Cam16 from UCS:
        -   `CamFromUcsAndViewingConditions(jstar, astar, bstar, vc)`
*   XYZ ⇌ Cam16
    -   `CamFromXyzAndViewingConditions(x, y, z, vc)`
    -   (*Cam16 to XYZ is not available yet*)
*   sRGB ⇌ L\*a\*b\*
    -   `LabFromInt(argb)`
    -   `IntFromLab(lab)`
*   linRGB → sRGB
    -   `ArgbFromLinrgb(linrgb)`

###### Swift

*   sRGB ⇌ HCT
    -   `Hct.fromInt(argb)`
    -   `Hct.from(h, c, t).toInt()`
*   sRGB ⇌ XYZ
    -   `ColorUtils.xyzFromArgb(argb)`
    -   `ColorUtils.argbFromXyz(x, y, z)`
*   sRGB ⇌ Cam16
    -   `Cam16.fromInt(argb)`
    -   `cam16.toInt()`
    -   Constructing a Cam16 from JCH or UCS:
        -   `Cam16.fromJch(j, c, h)`
        -   `Cam16.fromUcs(jstar, astar, bstar)`
*   XYZ ⇌ Cam16
    -   `Cam16.fromXyzInViewingConditions(x, y, z, vc)`
    -   `cam16.xyzInViewingConditions(vc)`
*   sRGB ⇌ L\*a\*b\*
    -   `ColorUtils.labFromArgb(argb)`
    -   `ColorUtils.argbFromLab(l, a, b)`
*   linRGB → sRGB
    -   `ColorUtils.argbFromLinrgb(linrgb)`

</section>

## References

### Wikipedia

-   [Color space](https://en.wikipedia.org/wiki/Color_space)
-   [Color model](https://en.wikipedia.org/wiki/Color_model)
-   [sRGB](https://en.wikipedia.org/wiki/SRGB)
    -   [sRGB: Gamma](https://en.wikipedia.org/wiki/SRGB#Transfer_function_\(%22gamma%22\))
-   [Gamma correction](https://en.wikipedia.org/wiki/Gamma_correction)
-   [CIE 1931 color space (CIEXYZ and others)](https://en.wikipedia.org/wiki/CIE_1931_color_space)
-   [CIELAB color space (L\*a\*b\*)](https://en.wikipedia.org/wiki/CIELAB_color_space)
-   [Color appearance model (CAM)](https://en.wikipedia.org/wiki/Color_appearance_model)
    -   [Cam16](https://en.wikipedia.org/wiki/Color_appearance_model#CAM16)
