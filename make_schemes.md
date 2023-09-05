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
