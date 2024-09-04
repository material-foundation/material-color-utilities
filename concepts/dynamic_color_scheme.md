# Dynamic Color Scheme

## Color space in MCU

Material uses a color spaces called HCT, which quantifies all colors using three
dimensions, Hue, Chroma, and Tone. The color space enables the system to create
and manipulate colors in flexible but predictable ways and allows designers to
identify and relate colors.

**Hue** quantifies the perception of a color as red, yellow, blue, and so on.
Hue is quantified by a number ranging from 0 to 360 and is a circular spectrum.
That is, values 0 and 360 are the same hue.

**Chroma** describes how colorful or neutral, gray, a color appears. Chroma is
quantified by a number ranging from 0, completely gray, to theoretically
infinite, most vibrant, though chroma values in HCT top out at roughly 120.

**Tone** describes how light or dark a color appears. Tone is sometimes also
referred to as luminance. Tone is quantified by a number ranging from 0, pure
black, no luminance, to 100, pure white, complete luminance. For visual
accessibility, tone is crucial because it determines control contrast. Colors
with a greater difference in tone create higher contrast while those with a
smaller difference create lower contrast.

## What is Dynamic Scheme?

`DynamicScheme` is the most important interface for dynamic color clients. It is
a scheme that clients can use to choose what color goes to which elements of the
UI. A helpful analogy is to think of UI as a paint-by-number canvas, with color
roles representing the "numbers" and `DynamicScheme` acting as a guideline to
map from those numbers to actual colors. `DynamicScheme` abstracts away the
exact color values, and the app developers only need to choose which color role
to use at each element of the UI.

More specifically, `DynamicScheme` comprises assignments of color values from
tonal palettes generated from user or app developer's preference to color roles.
The assignment focuses on meeting the requirements of contrast control for
visual accessibility and/or color fidelity for visual expression and trueness of
colors. The requirements comprise both hard constraints, such as accessibility
and fidelity, and soft constraints, such as visual preferences.

## How to generate Dynamic Scheme

Material color schemes start from a source color, a single color from which all
other scheme colors are derived. Source colors can be picked by a designer, or
if the scheme is based on an image like a user's wallpaper, they can be
extracted through a process called quantization. Quantization filters an image
down to its most representative colors. One of those colors is selected as the
source color.

First, the color algorithm systematically manipulates the source color's hue and
chroma to create four additional visually complementary key colors.

Next, those five key colors - the source color plus the four additional colors -
are each used to create a tonal palette. The tonal palette contains 13 tones
from black, tone 0, to white, tone 100. Lower tones are darker in luminance, and
higher tones are lighter in luminance. This full set of five tonal palettes is
the basis of a Material color scheme. Individual tones are selected from each
palette and assigned to color roles within a scheme.

The variety of colors in each scheme provide for different needs like
accessibility and expression. For example, color roles that may be used in
pairs, like container and on container colors, are chosen to maintain accessible
visual control contrast. Colors in the primary, secondary, and tertiary groups
maintain those contrasts while providing a range of style for visual expression.
Both light and dark schemes are created from this process.

## Applying colors to apps using design tokens

Colors are applied using design tokens, which store values for small, repeated
design decisions such as the color that make up a design system's visual style.
A Material token consists of a meaningful code like name and its associated
value. This allows styles to be applied consistently across designs, code,
tools, and platforms.

## For more information

See
[How the system works](https://m3.material.io/styles/color/system/how-the-system-works)
for more information on Material color system.
