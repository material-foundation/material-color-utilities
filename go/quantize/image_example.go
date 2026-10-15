// Copyright 2021 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package quantize

import (
	"fmt"
	"image"
	"image/jpeg"
	"image/png"
	"os"
)

// ExampleFromImage demonstrates extracting colors from an image file.
func ExampleFromImage() {
	// Open an image file
	file, err := os.Open("example.png")
	if err != nil {
		fmt.Printf("Error opening file: %v\n", err)
		return
	}
	defer file.Close()
	
	// Decode the image
	img, _, err := image.Decode(file)
	if err != nil {
		fmt.Printf("Error decoding image: %v\n", err)
		return
	}
	
	// Extract pixels
	pixels := FromImage(img)
	fmt.Printf("Extracted %d pixels from image\n", len(pixels))
	
	// Quantize colors
	quantizer := NewCelebi()
	colors := quantizer.Quantize(pixels, 16)
	
	fmt.Printf("Found %d dominant colors:\n", len(colors))
	for color, count := range colors {
		fmt.Printf("  Color: 0x%08X, Count: %d\n", color, count)
	}
}

// ExampleFromImageSampled demonstrates extracting colors with sampling for performance.
func ExampleFromImageSampled() {
	file, err := os.Open("large_image.jpg")
	if err != nil {
		fmt.Printf("Error opening file: %v\n", err)
		return
	}
	defer file.Close()
	
	img, err := jpeg.Decode(file)
	if err != nil {
		fmt.Printf("Error decoding image: %v\n", err)
		return
	}
	
	// Sample every 4th pixel for better performance on large images
	pixels := FromImageSampled(img, 4)
	fmt.Printf("Sampled %d pixels from large image\n", len(pixels))
	
	quantizer := NewCelebi()
	colors := quantizer.Quantize(pixels, 8)
	
	fmt.Printf("Extracted %d colors from sampled pixels\n", len(colors))
}

// ExampleFromImageSubset demonstrates extracting colors from a specific region.
func ExampleFromImageSubset() {
	file, err := os.Open("photo.png")
	if err != nil {
		fmt.Printf("Error opening file: %v\n", err)
		return
	}
	defer file.Close()
	
	img, err := png.Decode(file)
	if err != nil {
		fmt.Printf("Error decoding image: %v\n", err)
		return
	}
	
	// Extract colors from center 200x200 region
	bounds := img.Bounds()
	centerX := bounds.Dx() / 2
	centerY := bounds.Dy() / 2
	region := image.Rect(centerX-100, centerY-100, centerX+100, centerY+100)
	
	pixels := FromImageSubset(img, region)
	fmt.Printf("Extracted %d pixels from center region\n", len(pixels))
	
	quantizer := NewCelebi()
	colors := quantizer.Quantize(pixels, 12)
	
	fmt.Printf("Found %d colors in center region\n", len(colors))
}