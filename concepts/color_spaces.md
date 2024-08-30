# Color spaces in MCU



## Overview

Color spaces are used to describe color. A color does not change when moved
between color spaces. Using different “distance spaces” like kilometers, or
miles, does not change where you are - it just changes the measure of where you
are.

Color spaces used in design today, RGB, HSL, CMYK, etc., specify colors, but are
flawed in several fundamental ways. They describe colors, but do not do a good
job of describing the relationships between colors. As such, MCU uses multiple
**color spaces** to create a dynamic design system. Each color space is useful
in a different area and provides a way to understand colors.

For example, sRGB is easy for machine to display but not for humans. You get the
colors but not the characteristics. HCT provides a way to define different
characteristics of the color such as hue, chroma, and tone. MCU does most of
calculation in HCT then converts the colors to sRGB for consumption.

## Basics

In each color space, colors are represented as points in a coordinate system.
Any point can be located by rectangular (Cartesian) or circular (polar)
coordinates. For instance, this particular color, which occurs naturally, can be
described in each each space using three numerical values.

![Color with hex code #ff6600](images/orange.png){style="float: left; padding: 50px"}

Color space | Coordinates
----------- | -------------------------------
sRGB        | 255, 102, 0 (hex code: #ff6600)
linear RGB  | 100.00, 13.29, 0.00
XYZ         | 45.99, 30.76, 3.52
L\*a\*b\*   | 62.31, 54.99, 71.33
Cam16-JCH   | 55.16, 79.39, 42.39
Cam16-UCS   | 67.65, 28.75, 26.24
HCT         | 42.39, 79.39, 62.31

Most color spaces are three-dimensional is not a coincidence. Human eyes
typically possess three types of cone cells: one that is most sensitive to
shorter wavelengths (commonly referred to as blue), another that is most
sensitive to medium wavelengths (commonly referred to as green), and a third
that is most sensitive to longer wavelengths (commonly referred to as red).
Cells respond with varying strength to signals produced by lights of different
wavelengths. Hence, the human perception of any color can be described using
three numerical values.

The range of colors that can be represented differs for each color space. Color
spaces like **XYZ** can represent any color that human eyes can see. They serve
as a helpful basis for describing colors objectively. Conversely, the **sRGB**
color space is useful for displaying colors; however, due to the shape of the
Gamut, certain colors cannot be represented using three displayable primaries,
resulting in their absence in the sRGB color space.

## Color spaces used in MCU

### sRGB

RGB represents colors as a combination of red, green, and blue. This is
primarily used for display. The bit depth for each channel is usually 8, meaning
there are 256<sup>3</sup> = 16&nbsp;777&nbsp;216 colors available.

In MCU, an sRGB color usually appears as a hexadecimal number in ARGB format:
for example, `#abcdef` is `0xffabcdef`. The leading `ff` means that this is an
opaque color (alpha = `0xff`).

### HCT

The combination of Cam16-JCH and L*a*b* was used to introduce HCT in MCU. This
color space is crucial for creating color schemes, blending colors, and handling
disliked colors.

Note that while HCT is infinite, it can describe colors like H26 C231 T100.
However, that color isn’t “real.” There is no such color as a red (H26) that is
*extremely* colorful (C231) and the same brightness as white (T100). When it is
converted to RGB to be displayed, HCT keeps the tone, and reduces chroma until
the color is feasible.

### Cam16

CAM16 is a **color appearance model**, which accounts for **viewing
conditions**. The same red color patch will look different at noon, and at
night, and even in situations as simple as the background color being different.

Its aim is to represent the human perception of colors accurately. The Cam16
model uses the class `ViewingCondition` to define the environment, and employing
various `ViewingCondition` objects with the same hex code can result in distinct
"Cam16" objects. The library offers a standard default `ViewingCondition`.

A `Cam16` object contains 9 components, and can be determined uniquely if any of
the following are given:

-   A triple consisting of one of {`j`, `q`}, one of {`chroma`, `m`, `s`}, and
    `hue`
-   A triple of `jstar`, `astar`, and `bstar`

Technically speaking, Cam16 is not a single color space but encompasses multiple
color spaces. MCU uses the color spaces **Cam16-JCH** (using the components `j`,
`chroma`, `hue`) and **Cam16-UCS** (using the components `jstar`, `astar`,
`bstar`) for different purposes.

### XYZ (CIEXYZ)

XYZ is sometimes called a **connector space**, every color space can convert to
and from it. It is used often in conversion, but it is inappropriate for design.
It does not attempt to provide perceptually accurate attributes of colors, and
the three channels are visually interdependent.

This linear color space closely relates to how the cone cells response to light.

### L\*a\*b\* (CIELAB)

A color space intended to be perceptually uniform. Used internally for image
quantization.

L*a*b*, like RGB, is in a cube.

-   L* is the Z axis, representing lightness.
-   a* is the X axis, left to right, green to red.
-   b* is the Y axis, bottom to top, blue to yellow.

### Linear RGB (`linrgb`)

A linearization of the sRGB color space, with no restriction on bit depth.

Used internally for the HCT Solver.

## Conversions between color spaces

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
