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
	"image"
	"image/color"
	"testing"
)

// TestFromImage tests extracting pixels from a simple image.
func TestFromImage(t *testing.T) {
	// Create a simple 2x2 test image
	img := &testImage{
		bounds: image.Rect(0, 0, 2, 2),
		colors: []color.Color{
			color.RGBA{255, 0, 0, 255},   // Red
			color.RGBA{0, 255, 0, 255},   // Green
			color.RGBA{0, 0, 255, 255},   // Blue
			color.RGBA{255, 255, 255, 255}, // White
		},
	}
	
	pixels := FromImage(img)
	
	if len(pixels) != 4 {
		t.Errorf("Expected 4 pixels, got %d", len(pixels))
	}
	
	// Check specific colors (ARGB format)
	expectedColors := []uint32{
		0xFFFF0000, // Red
		0xFF00FF00, // Green
		0xFF0000FF, // Blue
		0xFFFFFFFF, // White
	}
	
	for i, expected := range expectedColors {
		if pixels[i] != expected {
			t.Errorf("Pixel %d: expected 0x%08X, got 0x%08X", i, expected, pixels[i])
		}
	}
}

// TestFromImageSubset tests extracting pixels from a region of an image.
func TestFromImageSubset(t *testing.T) {
	// Create a 3x3 test image
	img := &testImage{
		bounds: image.Rect(0, 0, 3, 3),
		colors: []color.Color{
			color.RGBA{255, 0, 0, 255}, color.RGBA{0, 255, 0, 255}, color.RGBA{0, 0, 255, 255},
			color.RGBA{255, 255, 0, 255}, color.RGBA{255, 0, 255, 255}, color.RGBA{0, 255, 255, 255},
			color.RGBA{128, 128, 128, 255}, color.RGBA{64, 64, 64, 255}, color.RGBA{192, 192, 192, 255},
		},
	}
	
	// Extract top-left 2x2 region
	region := image.Rect(0, 0, 2, 2)
	pixels := FromImageSubset(img, region)
	
	if len(pixels) != 4 {
		t.Errorf("Expected 4 pixels from subset, got %d", len(pixels))
	}
	
	// Should get the first 4 colors
	expectedColors := []uint32{
		0xFFFF0000, // Red
		0xFF00FF00, // Green
		0xFFFFFF00, // Yellow
		0xFFFF00FF, // Magenta
	}
	
	for i, expected := range expectedColors {
		if pixels[i] != expected {
			t.Errorf("Subset pixel %d: expected 0x%08X, got 0x%08X", i, expected, pixels[i])
		}
	}
}

// TestFromImageSampled tests sampling pixels from an image.
func TestFromImageSampled(t *testing.T) {
	// Create a 4x4 test image
	img := &testImage{
		bounds: image.Rect(0, 0, 4, 4),
		colors: make([]color.Color, 16),
	}
	
	// Fill with alternating red and blue
	for i := 0; i < 16; i++ {
		if i%2 == 0 {
			img.colors[i] = color.RGBA{255, 0, 0, 255} // Red
		} else {
			img.colors[i] = color.RGBA{0, 0, 255, 255} // Blue
		}
	}
	
	// Sample every other pixel (step = 2)
	pixels := FromImageSampled(img, 2)
	
	// Should get 4 pixels (2x2 sampling of 4x4 image)
	if len(pixels) != 4 {
		t.Errorf("Expected 4 sampled pixels, got %d", len(pixels))
	}
	
	// All sampled pixels should be red (even positions)
	for i, pixel := range pixels {
		if pixel != 0xFFFF0000 {
			t.Errorf("Sampled pixel %d: expected red (0xFFFF0000), got 0x%08X", i, pixel)
		}
	}
}

// TestColorToARGB tests the color conversion function.
func TestColorToARGB(t *testing.T) {
	tests := []struct {
		color    color.Color
		expected uint32
	}{
		{color.RGBA{255, 0, 0, 255}, 0xFFFF0000}, // Red
		{color.RGBA{0, 255, 0, 255}, 0xFF00FF00}, // Green
		{color.RGBA{0, 0, 255, 255}, 0xFF0000FF}, // Blue
		{color.RGBA{255, 255, 255, 255}, 0xFFFFFFFF}, // White
		{color.RGBA{0, 0, 0, 255}, 0xFF000000}, // Black
		{color.RGBA{128, 128, 128, 255}, 0xFF808080}, // Gray
		{color.RGBA{255, 0, 0, 128}, 0x80FF0000}, // Semi-transparent red
	}
	
	for _, test := range tests {
		result := colorToARGB(test.color)
		if result != test.expected {
			t.Errorf("colorToARGB(%+v): expected 0x%08X, got 0x%08X", test.color, test.expected, result)
		}
	}
}

// TestFromImageSubsetEmpty tests subset extraction with empty region.
func TestFromImageSubsetEmpty(t *testing.T) {
	img := &testImage{
		bounds: image.Rect(0, 0, 2, 2),
		colors: []color.Color{
			color.RGBA{255, 0, 0, 255},
			color.RGBA{0, 255, 0, 255},
			color.RGBA{0, 0, 255, 255},
			color.RGBA{255, 255, 255, 255},
		},
	}
	
	// Extract region outside image bounds
	region := image.Rect(10, 10, 20, 20)
	pixels := FromImageSubset(img, region)
	
	if len(pixels) != 0 {
		t.Errorf("Expected 0 pixels from empty subset, got %d", len(pixels))
	}
}

// testImage is a simple image implementation for testing.
type testImage struct {
	bounds image.Rectangle
	colors []color.Color
}

func (t *testImage) ColorModel() color.Model {
	return color.RGBAModel
}

func (t *testImage) Bounds() image.Rectangle {
	return t.bounds
}

func (t *testImage) At(x, y int) color.Color {
	if !image.Pt(x, y).In(t.bounds) {
		return color.RGBA{0, 0, 0, 0}
	}
	
	width := t.bounds.Dx()
	index := (y-t.bounds.Min.Y)*width + (x-t.bounds.Min.X)
	
	if index < 0 || index >= len(t.colors) {
		return color.RGBA{0, 0, 0, 0}
	}
	
	return t.colors[index]
}