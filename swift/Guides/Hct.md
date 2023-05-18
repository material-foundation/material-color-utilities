# Hct

HCT, hue, chroma, and tone. A color system that provides a perceptually accurate color measurement system that can also accurately render what colors will appear as in different lighting environments.

```swift
let hct = Hct.from(hue, chroma, tone)
let hct = Hct.fromInt(0x00000000)
```

### Hue

> 0 <= [value] < 360

A number, in degrees, representing ex. red, orange, yellow, etc. Ranges from 0 <= [hue] < 360

```swift
Hct(...).hue
```

Invalid values are corrected. After setting hue, the color is mapped from HCT to the more limited sRGB gamut for display. This will change its ARGB/integer representation. If the HCT color is outside of the sRGB gamut, chroma will decrease until it is inside the gamut.

### Chroma

> 0 <= [value] <= ?

```swift
Hct(...).chroma
```

After setting chroma, the color is mapped from HCT to the more limited sRGB gamut for display. This will change its ARGB/integer representation. If the HCT color is outside of the sRGB gamut, chroma will decrease until it is inside the gamut.

### Tone

> 0 <= [value] <= 100

Lightness. Ranges from 0 to 100.

```swift
Hct(...).tone
```

Invalid values are corrected. After setting tone, the color is mapped from HCT to the more limited sRGB gamut for display. This will change its ARGB/integer representation. If the HCT color is outside of the sRGB gamut, chroma will decrease until it is inside the gamut.

### ARGB

Argb representation of Hct

```swift
Hct(...).toInt()
```

### In Viewing Conditions

Translate a color into different [ViewingConditions](#viewing-conditions).

Colors change appearance. They look different with lights on versus off, the same color, as in hex code, on white looks different when on black. This is called color relativity, most famously explicated by Josef Albers in Interaction of Color.

In color science, color appearance models can account for this and calculate the appearance of a color in different settings. HCT is based on CAM16, a color appearance model, and uses it to make these calculations.

See [ViewingConditions.make](#make) for parameters affecting color appearance.

```swift
let vc = ViewingConditions.sRgb()
let newHct = Hct(...).inViewingConditions(vc)
```

## Viewing Conditions

In traditional color spaces, a color can be identified solely by the observer's measurement of the color. Color appearance models such as CAM16 also use information about the environment where the color was observed, known as the viewing conditions.

For example, white under the traditional assumption of a midday sun white point is accurately measured as a slightly chromatic blue by CAM16. (roughly, hue 203, chroma 3, lightness 100)

This class caches intermediate values of the CAM16 conversion process that depend only on viewing conditions, enabling speed ups.

### Static

There are two static viewing conditions that can be referenced (standard and sRgb):

```swift
let standard = ViewingConditions.standard()
let sRgb = ViewingConditions.sRgb()
```

### Make

There is also a convenience constructor for `ViewingConditions`.

Parameters affecting color appearance include:

| Parameter | Description | Default |
| ---- | ---- | --- |
| whitePoint | Coordinates of white in XYZ color space | nil |
| adaptingLuminance | Light strength, in lux | -1 |
| backgroundLstar | Average luminance of 10 degrees around color | 50 |
| surround | Brightness of the entire environment | 2 |
| discountingIlluminant | Whether eyes have adjusted to lighting | false |

```swift
let vc = ViewingConditions.make(...)
```

## Cam 16

CAM16, a color appearance model. Colors are not just defined by their hex code, but rather, a hex code and viewing conditions.

CAM16 instances also have coordinates in the CAM16-UCS space, called J*, a*, b*, or jstar, astar, bstar in code. CAM16-UCS is included in the CAM16 specification, and should be used when measuring distances between colors.

In traditional color spaces, a color can be identified solely by the observer's measurement of the color. Color appearance models such as CAM16 also use information about the environment where the color was observed, known as the viewing conditions.

For example, white under the traditional assumption of a midday sun white point is accurately measured as a slightly chromatic blue by (roughly, hue 203, chroma 3, lightness 100) CAM16, a color appearance model. Colors are not just defined by their hex code, but rather, a hex code and viewing conditions.

CAM16 instances also have coordinates in the CAM16-UCS space, called J*, a*, b*, or jstar, astar, bstar in code. CAM16-UCS is included in the CAM16 specification, and should be used when measuring distances between colors.

In traditional color spaces, a color can be identified solely by the observer's measurement of the color. Color appearance models such as CAM16 also use information about the environment where the color was observed, known as the viewing conditions.

For example, white under the traditional assumption of a midday sun white point is accurately measured as a slightly chromatic blue by (roughly, hue 203, chroma 3, lightness 100)

```swift
let cam16 = Cam16.fromInt(0x00000000)
```
