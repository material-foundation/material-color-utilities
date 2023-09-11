# Contrast



## Overview

MCU uses **contrast ratio** to measure the contrast between colors and ensure
legibility. The `contrast` part of the library contains a few helper functions
related to contrast ratios.

Contrast ratio is based on `Y`, a component in the CIEXYZ color space that
measures brightness. `Y` is in a one-to-one relationship with `L*` from CIELab.

Given two colors where the lighter color's `Y` is `yL` the darker color's `Y` is
`yD`, the contrast ratio is defined as:

```
contrast_ratio = (yL + 5.0) / (yD + 5.0)
```

The contrast ratio between a color and itself is 1.0.

The contrast ratio between black and white is 21.0.

Generally, text is considered legible against a background when the two colors
have a contrast ratio of at least 4.5.

## Usage

The contrast library allows manual control of contrast. However, we recommend
using the `DynamicColor` and `DynamicScheme` features in production, which are
able to generate color schemes that contrast well.

## Measuring contrast

To measure the contrast of two colors, use the `ratioOfTones` method on the
tones (`L*`) of the two colors.

The tone of an HCT color is the `tone` component. The tone of an ARGB color can
be obtained by `ColorUtils.lstarFromArgb` method.

<section>

###### Dart

```dart
final contrastRatio = Contrast.ratioOfTones(hct1.tone, hct2.tone);
```

```dart
final tone1 = ColorUtils.lstarFromArgb(argb1);
final tone2 = ColorUtils.lstarFromArgb(argb2);
final contrastRatio = Contrast.ratioOfTones(tone1, tone2);
```

###### Java

```java
double contrastRatio = Contrast.ratioOfTones(hct1.getTone(), hct2.getTone());
```

```java
double tone1 = ColorUtils.lstarFromArgb(argb1);
double tone2 = ColorUtils.lstarFromArgb(argb2);
double contrastRatio = Contrast.ratioOfTones(tone1, tone2);
```

###### TypeScript

```typescript
const contrastRatio = Contrast.ratioOfTones(hct1.tone, hct2.tone);
```

```typescript
const tone1 = ColorUtils.lstarFromArgb(argb1);
const tone2 = ColorUtils.lstarFromArgb(argb2);
const contrastRatio = Contrast.ratioOfTones(tone1, tone2);
```

###### C++

```cpp
double contrast_ratio = RatioOfTones(hct1.get_tone(), hct2.get_tone());
```

```cpp
double tone1 = LstarFromArgb(argb1);
double tone2 = LstarFromArgb(argb2);
double contrast_ratio = RatioOfTones(tone1, tone2);
```

###### Swift

```swift
let contrastRatio = Contrast.ratioOfTones(hct1.tone, hct2.tone)
```

```swift
let tone1 = ColorUtils.lstarFromArgb(argb1)
let tone2 = ColorUtils.lstarFromArgb(argb2)
let contrastRatio = Contrast.ratioOfTones(tone1, tone2)
```

</section>

## Obtaining well-contrasting colors

The functions `darker` and `lighter` (and their variants `darkerUnsafe` and
`lighterUnsafe`) allow one to obtain **tones** that contrast well against the
**tone** of a given color.

The functions `darker` and `lighter` will return `-1` if the required contrast
cannot be reached, whereas `darkerUnsafe` and `lighterUnsafe` will return `0`
(tone of black) and `100` (tone of white), respectively, making the contrast
ratio as high as possible.

The word "unsafe" in the names mean they may return a color without guaranteeing
contrast ratio. These functions do not cause actual damage.

<section>

###### Dart

```dart
final original = ColorUtils.lstarFromArgb(0xFF00AA00);  // 60.56

final darker = Contrast.darker(original, 3.0);  // 29.63
final lighter = Contrast.lighter(original, 3.0);  // 98.93
final darkerUnsafe = Contrast.darkerUnsafe(original, 3.0);  // 29.63
final lighterUnsafe = Contrast.lighterUnsafe(original, 3.0);  // 98.93

final darker = Contrast.darker(original, 7.0);  // -1.0
final lighter = Contrast.lighter(original, 7.0);  // -1.0
final darkerUnsafe = Contrast.darkerUnsafe(original, 7.0);  // 0.0
final lighterUnsafe = Contrast.lighterUnsafe(original, 7.0);  // 100.0
```

###### Java

```java
double original = ColorUtils.lstarFromArgb(0xFF00AA00);  // 60.56

double darker = Contrast.darker(original, 3.0);  // 29.63
double lighter = Contrast.lighter(original, 3.0);  // 98.93
double darkerUnsafe = Contrast.darkerUnsafe(original, 3.0);  // 29.63
double lighterUnsafe = Contrast.lighterUnsafe(original, 3.0);  // 98.93

double darker = Contrast.darker(original, 7.0);  // -1.0
double lighter = Contrast.lighter(original, 7.0);  // -1.0
double darkerUnsafe = Contrast.darkerUnsafe(original, 7.0);  // 0.0
double lighterUnsafe = Contrast.lighterUnsafe(original, 7.0);  // 100.0
```

###### TypeScript

```typescript
const original = ColorUtils.lstarFromArgb(0xFF00AA00);  // 60.56

const darker = Contrast.darker(original, 3.0);  // 29.63
const lighter = Contrast.lighter(original, 3.0);  // 98.93
const darkerUnsafe = Contrast.darkerUnsafe(original, 3.0);  // 29.63
const lighterUnsafe = Contrast.lighterUnsafe(original, 3.0);  // 98.93

const darker = Contrast.darker(original, 7.0);  // -1.0
const lighter = Contrast.lighter(original, 7.0);  // -1.0
const darkerUnsafe = Contrast.darkerUnsafe(original, 7.0);  // 0.0
const lighterUnsafe = Contrast.lighterUnsafe(original, 7.0);  // 100.0
```

###### C++

```cpp
double original = LstarFromArgb(0xFF00AA00);  // 60.56

double darker = Darker(original, 3.0);  // 29.63
double lighter = Lighter(original, 3.0);  // 98.93
double darker_unsafe = DarkerUnsafe(original, 3.0);  // 29.63
double lighter_unsafe = LighterUnsafe(original, 3.0);  // 98.93

double darker = Darker(original, 7.0);  // -1.0
double lighter = Lighter(original, 7.0);  // -1.0
double darker_unsafe = DarkerUnsafe(original, 7.0);  // 0.0
double lighter_unsafe = LighterUnsafe(original, 7.0);  // 100.0
```

###### Swift

```swift
let original = ColorUtils.lstarFromArgb(0xFF00AA00)  // 60.56

let darker = Contrast.darker(tone: original, ratio: 3.0)  // 29.63
let lighter = Contrast.lighter(tone: original, ratio: 3.0)  // 98.93
let darkerUnsafe = Contrast.darkerUnsafe(tone: original, ratio: 3.0)  // 29.63
let lighterUnsafe = Contrast.lighterUnsafe(tone: original, ratio: 3.0)  // 98.93

let darker = Contrast.darker(tone: original, ratio: 7.0)  // -1.0
let lighter = Contrast.lighter(tone: original, ratio: 7.0)  // -1.0
let darkerUnsafe = Contrast.darkerUnsafe(tone: original, ratio: 7.0)  // 0.0
let lighterUnsafe = Contrast.lighterUnsafe(tone: original, ratio: 7.0)  // 100.0
```

</section>
