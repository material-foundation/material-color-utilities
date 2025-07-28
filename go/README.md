# Material Color Utilities for Go

Go implementation of Google's Material Color Utilities, which provides algorithms for color extraction and dynamic color in Material Design.

## Installation

```bash
go get github.com/material-foundation/material-color-utilities/go
```

## Usage

### HCT Color Space

```go
import "github.com/material-foundation/material-color-utilities/go/cam"

// Create HCT color from ARGB
hct := cam.FromInt(0xFF4285F4) // Google Blue

// Access HCT components
fmt.Printf("Hue: %.2f, Chroma: %.2f, Tone: %.2f\n", hct.Hue, hct.Chroma, hct.Tone)

// Create HCT from components
hct2 := cam.From(120.0, 50.0, 60.0)
argb := hct2.ToInt()
```

### Color Schemes

```go
import "github.com/material-foundation/material-color-utilities/go/scheme"

// Generate a light scheme from a source color
lightScheme := scheme.Light(0xFF4285F4)

// Access scheme colors
fmt.Printf("Primary: %#08x\n", lightScheme.Primary)
fmt.Printf("Secondary: %#08x\n", lightScheme.Secondary)
fmt.Printf("Background: %#08x\n", lightScheme.Background)
```

### Color Harmonization

```go
import "github.com/material-foundation/material-color-utilities/go/blend"

// Harmonize design color towards theme color
harmonized := blend.Harmonize(0xFFE91E63, 0xFF4285F4)
```

### Tonal Palettes

```go
import "github.com/material-foundation/material-color-utilities/go/palettes"

// Create a tonal palette from a color
palette := palettes.TonalFromInt(0xFF4285F4)

// Get specific tones
tone50 := palette.Tone(50)
tone90 := palette.Tone(90)
```

### Color Extraction from Images

```go
import (
    "image"
    "image/png"
    "os"
    "github.com/material-foundation/material-color-utilities/go/quantize"
)

// Load an image
file, _ := os.Open("photo.png")
defer file.Close()
img, _ := png.Decode(file)

// Extract pixel data
pixels := quantize.FromImage(img)

// Or sample every 4th pixel for better performance
pixels = quantize.FromImageSampled(img, 4)

// Or extract from a specific region
region := image.Rect(100, 100, 300, 300)
pixels = quantize.FromImageSubset(img, region)

// Quantize to dominant colors
quantizer := quantize.NewCelebi()
colors := quantizer.Quantize(pixels, 16)
```

## Features

- **HCT Color Space**: A perceptually accurate color space that enables smooth color transitions
- **Dynamic Color Schemes**: Generate complete Material Design 3 color schemes from a single source color
- **Color Harmonization**: Blend colors while maintaining visual relationships
- **Tonal Palettes**: Create tonal variations of colors for consistent design
- **Quantization**: Extract dominant colors from images
- **Contrast Utilities**: Calculate and ensure accessible color contrast ratios

## License

Licensed under the Apache License, Version 2.0. See LICENSE file for details.