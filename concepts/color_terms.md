# Color terms

### Dynamic Color

Dynamic Color represents a Material color role, and its value is determined by
constraints in Dynamic Scheme.

### Material Color Roles

[Material color roles](https://m3.material.io/styles/color/roles) are like the
"numbers" on a paint-by-number canvas. They are the connective tissue between
elements of the UI and what color goes where. Roughly speaking, MCU assigns each
color role with a value from a specific tonal palette. For example, the
`onSurface` color uses a color from the Neutral Palette with tone 30 in light
scheme.

### Dynamic Scheme

The Dynamic Scheme is comprised of color attributes that are combined in a
predetermined way to meet the needs of a user context or preference. It is
essentially a mapping of color roles to color at specific tone in a tonal
palette. For example, primary = *207H 80C 90T*, onPrimary = *207H 80C 40T*.

### Scheme Variant

Each variant is a set of design decisions on the assignment of color values from
tonal palettes to color roles.

### Tonal Palette

A set of colors that share hue and chroma in HCT color space and vary in tones.
From a perception perspective, we can say that they are "tones of the same
color".

MCU produces 6 tonal palettes: primary, secondary, tertiary, neutral, neutral
variant, and error. Each comprises tones ranging from 0 to 100 that serves as
the basis for mapping specific tones to specific roles.

### Source Color

The single color that’s extracted to define all five key colors is called a
source color. While it may not be needed in code, it’s a useful distinction for
understanding that a dynamic color scheme has its root in one initiating color,
AKA hue, chroma, and tone.

### Key Color

Key colors are a concept useful to understanding dynamic color. The term
describes any color that undergoes hue and chroma transformation of a source
color. It is not an extracted color, it’s a derivation of the source color.

Key color is a color that represents the hue and chroma of a tonal palette.
Dynamic color uses 5 key colors to generate 5 tonal palettes as a foundation for
dynamic scheme generation.

### HCT

HCT is an abbreviation of hue, chroma, tone. It’s the name of a new color space
that enables dynamic color. HCT is based on
[CAM16](https://onlinelibrary.wiley.com/doi/10.1002/col.22131) hue and chroma;
the L* construct for luminance from L*a*b* (CIELAB, 1976) is represented as
tone. 

### Hue

Examples are red, orange, yellow, green, etc. A hue can range from 0 to 359
degrees.

### Chroma

Informally, chroma describes degrees of colorfulness. It’s similar to saturation
in the HSL color space, but note two distinctions: chroma in HCT is perceptually
accurate; for every combination of hue and tone there’s a different maximum
chroma.

### Tone

Informally, tone means degrees of lightness. T in HCT color space equals L* in
L*a*b* color space.

### Contrast

The difference between colors. For accessibility, contrast refers strictly to
the difference in tone. A difference of 40 in tone guarantees a WCAG contrast
ratio ≥ 3.0; a difference of 50 in tone guarantees a contrast ratio ≥ 4.5.

## For more information

See https://m3.material.io/foundations/glossary for more Material terms.
