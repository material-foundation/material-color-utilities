# Extracting colors from an image

See [Color Extraction](../concepts/color_extraction.md) for a conceptual
overview.

## Step 1 — Image to Pixels

The first step is to convert an image into **an array of pixels in ARGB
format**. Prior to that, please resize it to 128 × 128 dimensions for faster
processing.

MCU does not provide this feature, so you’ll have to rely on the idiomatic
method in your programming language. For example, in Java, one may use the
`BufferedImage.getRGB` method:

```java
import java.awt.image.BufferedImage;

class ImageUtils {
  // ...

  public static int[] imageToPixels(BufferedImage image) {
    int width = image.getWidth();
    int height = image.getHeight();
    BufferedImage outputImage = new BufferedImage(width, height, BufferedImage.TYPE_INT_ARGB);
    return image.getRGB(0, 0, width, height, null, 0, width);
  }
}
```

## Step 2 — Pixels to Prominent Colors

Once you have the array of pixels, pass it into `QuantizerCelebi.quantize`
provided by the `quantize` library.

<section>

###### Dart

```dart
final quantizerResult = await QuantizerCelebi.quantize(pixels, maxColors);
```

###### Java

```java
QuantizerResult quantizerResult = QuantizerCelebi.quantize(pixels, maxColors);
```

###### TypeScript

```typescript
const quantizerResult = QuantizerCelebi.quantize(pixels, maxColors);
```

###### C++

```cpp
QuantizerResult quantizer_result = QuantizeCelebi(pixels, max_colors);
```

###### Swift

```swift
let quantizerResult = QuantizerCelebi().quantize(pixels, maxColors)
```

</section>

The parameter `maxColors` is a limit on the number of colors returned by the
quantizer. A reasonable default is 128.

## Step 3 — Prominent Colors to Source Colors

Use the `Score.score` method provided by the `score` library to extract colors
that are suitable as seeds for color schemes, ranked by decreasing suitability.

<section>

###### Dart

```dart
final colors = Score.score(quantizerResult.colorToCount);
```

###### Java

```java
List<Integer> colors = Score.score(quantizerResult);
```

###### TypeScript

```typescript
final colors = Score.score(quantizerResult);
```

###### C++

```cpp
std::vector<Argb> colors = RankedSuggestions(quantizer_result.color_to_count);
```

###### Swift

```swift
let colors = Score.score(quantizerResult.colorToCount)
```

</section>
