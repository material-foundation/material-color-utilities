# Creating a Color Scheme

See [Dynamic Color Scheme](../concepts/dynamic_color_scheme.md) for a conceptual
overview.

## Getting colors for theming

To get color values for styling your UIs, the first step is to initialize
`DynamicScheme` with the below parameters:

1.  A source color (formerly called seed color).
    -   It can be in ARGB format, `sourceColorArgb`, or HCT format,
        `sourceColorHct`.
1.  Scheme variant, `variant`.
1.  Whether the scheme is in light mode or dark mode, `isDark`.
1.  Contrast level, `contrastLevel` typed `Double`. The recommended levels are:
    -   `0.0` for default contrast.
    -   `0.5` for higher contrast.
    -   `1.0` for highest contrast.
    -   `-1.0` for reduced contrast.
1.  Tonal palettes:
    *   `primaryPalette`
    *   `secondaryPalette`
    *   `tertiaryPalette`
    *   `neutralPalette`
    *   `neutralVariantPalette`
    *   `errorPalette`

We provide various scheme variants, such as `SchemeTonalSpot`, `SchemeContent`,
etc, which inherit `DynamicScheme` and come with pre-defined tonal palettes.
This means you only need to specify the source color, theme mode, and contrast
level to create a scheme.

The `DynamicScheme` object does not store the ARGB or HCT values of specific
color roles. Instead, these values are generated upon demand, and you can get
them with the `DynamicColor` class. We provide color role APIs like
`DynamicScheme.primary` to make it easier to get a specific color.

## Step-by-Steps Instructions

### 1. Generating a scheme

#### Method 1 — Using a variant

The recommended way to generate a scheme from a source color is to use a scheme
variant constructor, such as `SchemeTonalSpot`. The following example generates
a `SchemeTonalSpot` scheme in light mode and default contrast from `hct` as
source color in HCT format.

<section>

###### Dart

```dart
final scheme = SchemeTonalSpot(sourceColorHct: hct, isDark: false, contrastLevel: 0.0);
```

###### Java

```java
DynamicScheme scheme = new SchemeTonalSpot(hct, false, 0.0);
```

###### TypeScript

```typescript
const scheme = new SchemeTonalSpot(hct, false, 0.0);
```

###### C++

```cpp
DynamicScheme scheme = SchemeTonalSpot(hct, false, 0.0);
```

###### Swift

```swift
let scheme = SchemeTonalSpot(
    sourceColorHct: hct,
    isDark: false,
    contrastLevel: 0.0)
```

</section>

We provide the below variants:

*   Content
*   Expressive
*   Fidelity
*   Fruit salad
*   Monochrome
*   Neutral
*   Rainbow
*   Tonal spot
*   Vibrant

#### Method 2 — Specifying palettes

<section>

###### Dart

```dart
final scheme = DynamicScheme(
    sourceColorArgb: 0xFFEB0057,
    variant: Variant.vibrant,
    isDark: false,
    contrastLevel: 0.0,
    primaryPalette: TonalPalette.fromHct(Hct.fromInt(0xFFEB0057)),
    secondaryPalette: TonalPalette.fromHct(Hct.fromInt(0xFFF46B00)),
    tertiaryPalette: TonalPalette.fromHct(Hct.fromInt(0xFF00AB46)),
    neutralPalette: TonalPalette.fromHct(Hct.fromInt(0xFF949494)),
    neutralVariantPalette: TonalPalette.fromHct(Hct.fromInt(0xFFBC8877)),
);
```

###### Java

```java
DynamicScheme scheme = new DynamicScheme(
    /*sourceColorHct=*/ Hct.fromInt(0xFFEB0057),
    /*variant=*/ Variant.VIBRANT,
    /*isDark=*/ false,
    /*contrastLevel=*/ 0.0,
    /*primaryPalette=*/ TonalPalette.fromInt(0xFFEB0057),
    /*secondaryPalette=*/ TonalPalette.fromInt(0xFFF46B00),
    /*tertiaryPalette=*/ TonalPalette.fromInt(0xFF00AB46),
    /*neutralPalette=*/ TonalPalette.fromInt(0xFF949494),
    /*neutralVariantPalette=*/ TonalPalette.fromInt(0xFFBC8877));
```

###### TypeScript

```typescript
const scheme = new DynamicScheme({
    sourceColorArgb: 0xFFEB0057,
    variant: Variant.VIBRANT,
    isDark: false,
    contrastLevel: 0.0,
    primaryPalette: TonalPalette.fromInt(0xFFEB0057),
    secondaryPalette: TonalPalette.fromInt(0xFFF46B00),
    tertiaryPalette: TonalPalette.fromInt(0xFF00AB46),
    neutralPalette: TonalPalette.fromInt(0xFF949494),
    neutralVariantPalette: TonalPalette.fromInt(0xFFBC8877)
});
```

###### C++

```cpp
DynamicScheme scheme = DynamicScheme(
    /*source_color_argb=*/ 0xFFEB0057,
    /*variant=*/ Variant::kVibrant,
    /*contrast_level=*/ 0.0,
    /*is_dark=*/ false,
    /*primary_palette=*/ TonalPalette(0xFFEB0057),
    /*secondary_palette=*/ TonalPalette(0xFFF46B00),
    /*tertiary_palette=*/ TonalPalette(0xFF00AB46),
    /*neutral_palette=*/ TonalPalette(0xFF949494),
    /*neutral_variant_palette=*/ TonalPalette(0xFFBC8877));
```

###### Swift

```swift
let scheme = DynamicScheme(
    sourceColorArgb: 0xFFEB0057,
    variant: Variant.vibrant,
    isDark: false,
    contrastLevel: 0.0,
    primaryPalette: TonalPalette.fromHct(Hct(0xFFEB0057)),
    secondaryPalette: TonalPalette.fromHct(Hct(0xFFF46B00)),
    tertiaryPalette: TonalPalette.fromHct(Hct(0xFF00AB46)),
    neutralPalette: TonalPalette.fromHct(Hct(0xFF949494)),
    neutralVariantPalette: TonalPalette.fromHct(Hct(0xFFBC8877)))
```

</section>

### 2. Obtaining colors

Colors can be in either ARGB or HCT. Below shows how you may obtain the
`primary` color.

<section>

###### Dart

```dart
final argb = scheme.primary;
```

Alternatively,

```dart
final argb = MaterialDynamicColors.primary.getArgb(scheme);
final hct = MaterialDynamicColors.primary.getHct(scheme);
```

###### Java

```java
int argb = scheme.getPrimary();
```

Alternatively,

```java
MaterialDynamicColors materialDynamicColors = new MaterialDynamicColors();
int argb = materialDynamicColors.primary().getArgb(scheme);
Hct hct = materialDynamicColors.primary().getHct(scheme);
```

###### TypeScript

```typescript
const argb = scheme.primary;
```

Alternatively,

```typescript
const argb = MaterialDynamicColors.primary.getArgb(scheme);
const hct = MaterialDynamicColors.primary.getHct(scheme);
```

###### C++

```cpp
Argb argb = MaterialDynamicColors::Primary().GetArgb(s);
Hct hct = MaterialDynamicColors::Primary().GetHct(s);
```

###### Swift

```swift
let argb = scheme.primary
```

Alternatively,

```swift
let argb = MaterialDynamicColors.primary.getArgb(scheme)
let hct = MaterialDynamicColors.primary.getHct(scheme)
```

</section>

## For existing library users using `Scheme`,

The `Scheme` class will be deprecated soon, as it does not support different
contrast levels. The functionality of `Scheme` is fully replicated by
`SchemeTonalSpot` and `SchemeContent`.

<section>



###### Dart

| Instead of …                 | Use …                               |
| ---------------------------- | ----------------------------------- |
| `Scheme.light(color)`        | `SchemeTonalSpot(sourceColorHct: Hct.fromInt(color), isDark: false, contrastLevel: 0.0)` |
| `Scheme.dark(color)`         | `SchemeTonalSpot(sourceColorHct: Hct.fromInt(color), isDark: true, contrastLevel: 0.0)`  |
| `Scheme.lightContent(color)` | `SchemeContent(sourceColorHct: Hct.fromInt(color), isDark: false, contrastLevel: 0.0)`   |
| `Scheme.darkContent(color)`  | `SchemeContent(sourceColorHct: Hct.fromInt(color), isDark: true, contrastLevel: 0.0)`    |

###### Java

| Instead of …                 | Use …                                         |
| ---------------------------- | --------------------------------------------- |
| `Scheme.light(color)`        | `new SchemeTonalSpot(Hct.fromInt(color), false, 0.0)` |
| `Scheme.dark(color)`         | `new SchemeTonalSpot(Hct.fromInt(color), true, 0.0)`  |
| `Scheme.lightContent(color)` | `new SchemeContent(Hct.fromInt(color), false, 0.0)`   |
| `Scheme.darkContent(color)`  | `new SchemeContent(Hct.fromInt(color), true, 0.0)`    |

###### TypeScript

| Instead of …                 | Use …                                         |
| ---------------------------- | --------------------------------------------- |
| `Scheme.light(color)`        | `new SchemeTonalSpot(Hct.fromInt(color), false, 0.0)` |
| `Scheme.dark(color)`         | `new SchemeTonalSpot(Hct.fromInt(color), true, 0.0)`  |
| `Scheme.lightContent(color)` | `new SchemeContent(Hct.fromInt(color), false, 0.0)`   |
| `Scheme.darkContent(color)`  | `new SchemeContent(Hct.fromInt(color), true, 0.0)`    |

###### C++

| Instead of …                             | Use …                             |
| ---------------------------------------- | --------------------------------- |
| `MaterialLightColorScheme(color)`        | `SchemeTonalSpot(Hct(color), false, 0.0)` |
| `MaterialDarkColorScheme(color)`         | `SchemeTonalSpot(Hct(color), true, 0.0)`  |
| `MaterialLightContentColorScheme(color)` | `SchemeContent(Hct(color), false, 0.0)`   |
| `MaterialDarkContentColorScheme(color)`  | `SchemeContent(Hct(color), true, 0.0)`    |

###### Swift

| Instead of …                 | Use …                               |
| ---------------------------- | ----------------------------------- |
| `Scheme.light(color)`        | `SchemeTonalSpot(sourceColorHct: Hct.fromInt(color), isDark: false, contrastLevel: 0.0)` |
| `Scheme.dark(color)`         | `SchemeTonalSpot(sourceColorHct: Hct.fromInt(color), isDark: true, contrastLevel: 0.0)`  |
| `Scheme.lightContent(color)` | `SchemeContent(sourceColorHct: Hct.fromInt(color), isDark: false, contrastLevel: 0.0)`   |
| `Scheme.darkContent(color)`  | `SchemeContent(sourceColorHct: Hct.fromInt(color), isDark: true, contrastLevel: 0.0)`    |



</section>

For `Scheme.lightFromCorePalette` and `Scheme.darkFromCorePalette`
(`MaterialLightColorSchemeFromPalette` and `MaterialDarkColorSchemeFromPalette`
in C++), please use the `DynamicScheme` constructor instead.

Please see **Step 2 — Obtaining colors** to obtain colors from a
`DynamicScheme`.

Due to an update in the specification, the values of many color roles have
changed between `Scheme`, and the new dynamic schemes `SchemeTonalSpot` and
`SchemeContent`. After migrating, you may need to update your tests.

For `SchemeTonalSpot`, color roles using the "primary" and "neutral" palettes,
such as `onPrimary` and `outline`, may be affected. Also, the roles `background`
and `surface` have updated tones.

For `SchemeContent`, all colors may have been affected, because `SchemeContent`
is a fidelity scheme: the tones of color roles may depend on the tone of the
seed color.
