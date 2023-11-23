# Making and using schemes



With a seed color, you may create a dynamic color scheme using the
`DynamicScheme` class and its subclasses.

Then, you can get color roles from the scheme using the `DynamicColor` class.

## What a `DynamicScheme` is

A `DynamicScheme` object contains all the information you need to generate all
color roles.

It includes the following information:

-   The source color (seed color) of the theme
    *   `sourceColorArgb` is the color in ARGB format, and `sourceColorHct` is
        in HCT format.
-   The variant this scheme uses - `variant`
-   Whether the scheme is in light mode or dark mode
    *   using the boolean `isDark`
-   The current contrast level
    *   stored in `contrastLevel` as a `double`
    *   `0.0` is the default contrast level
    *   `0.5` is medium
    *   `1.0` is high
    *   `-1.0` is reduced
-   Six tonal palettes:
    *   `primaryPalette`
    *   `secondaryPalette`
    *   `tertiaryPalette`
    *   `neutralPalette`
    *   `neutralVariantPalette`
    *   `errorPalette`

A `DynamicScheme` object does not store the ARGB or HCT values of individual
color roles; they are generated upon demand (see below for more information)

## Migrating from `Scheme`

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

## Step 1 — Generating a scheme

### Method 1 — Using a variant

The easiest way to generate a scheme from a seed color is using a variant scheme
constructor, such as `SchemeTonalSpot`.

All you need is to specify: - a source color, as an `Hct` object; - a boolean
indicating whether the scheme is in dark mode; - the contrast level.

The following example uses an HCT object `hct` as seed, and generates a
`SchemeTonalSpot` in light mode with default contrast.

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

Currently the following variants are available:

*   Content
*   Expressive
*   Fidelity
*   Fruit salad
*   Monochrome
*   Neutral
*   Rainbow
*   Tonal spot
*   Vibrant

### Method 2 — Specifying palettes

You can also create a `DynamicScheme` object by specifying each individual
palette and providing additional information (source color, variant, light or
dark mode, contrast).

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

## Step 2 — Obtaining colors

To obtain a color from a dynamic scheme, use a `DynamicColor` object on a
`DynamicScheme`.

Use the `getArgb` method to get the desired color as an integer in ARGB format,
or the `getHct` method for the color as an `Hct` object.

Dynamic colors used in Material Design are defined in the
`MaterialDynamicColors` class. Below are examples of obtaining the `primary`
color from a given `scheme`.

<section>

###### Dart

```dart
final argb = scheme.primary;
final hct = scheme.getHct(MaterialDynamicColors.primary);
```

Alternatively:

```dart
final argb = MaterialDynamicColors.primary.getArgb(scheme);
final hct = MaterialDynamicColors.primary.getHct(scheme);
```

###### Java

```java
MaterialDynamicColors materialDynamicColors = new MaterialDynamicColors();
int argb = materialDynamicColors.primary().getArgb(scheme);
Hct hct = materialDynamicColors.primary().getHct(scheme);
```

###### TypeScript

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
let argb = MaterialDynamicColors.primary.getArgb(scheme)
let hct = MaterialDynamicColors.primary.getHct(scheme)
```

</section>
