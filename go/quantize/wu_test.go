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
	"testing"

	"github.com/material-foundation/material-color-utilities/go/utils"
)

func TestWuQuantizer_Basic(t *testing.T) {
	quantizer := NewWu()

	// Test with basic RGB colors
	pixels := []uint32{
		utils.ArgbFromRgb(255, 0, 0),     // Red
		utils.ArgbFromRgb(0, 255, 0),     // Green
		utils.ArgbFromRgb(0, 0, 255),     // Blue
		utils.ArgbFromRgb(255, 255, 0),   // Yellow
		utils.ArgbFromRgb(255, 0, 255),   // Magenta
		utils.ArgbFromRgb(0, 255, 255),   // Cyan
		utils.ArgbFromRgb(255, 255, 255), // White
		utils.ArgbFromRgb(0, 0, 0),       // Black
	}

	result := quantizer.Quantize(pixels, 8)

	if len(result) == 0 {
		t.Fatal("Expected non-empty result")
	}

	if len(result) > 8 {
		t.Fatalf("Expected at most 8 colors, got %d", len(result))
	}
}

func TestWuQuantizer_SingleColor(t *testing.T) {
	quantizer := NewWu()

	// Test with single color
	red := utils.ArgbFromRgb(255, 0, 0)
	pixels := []uint32{red, red, red, red}

	result := quantizer.Quantize(pixels, 4)

	if len(result) != 1 {
		t.Fatalf("Expected 1 color for single color input, got %d", len(result))
	}

	// Check if the result contains the red color
	found := false
	for color := range result {
		if color == red {
			found = true
			break
		}
	}

	if !found {
		t.Fatal("Expected result to contain the input red color")
	}
}

func TestWuQuantizer_Empty(t *testing.T) {
	quantizer := NewWu()

	result := quantizer.Quantize([]uint32{}, 5)

	if len(result) != 0 {
		t.Fatalf("Expected empty result for empty input, got %d colors", len(result))
	}
}

func TestWuQuantizer_MoreColorsRequestedThanAvailable(t *testing.T) {
	quantizer := NewWu()

	// Only provide 3 distinct colors
	pixels := []uint32{
		utils.ArgbFromRgb(255, 0, 0), // Red
		utils.ArgbFromRgb(0, 255, 0), // Green
		utils.ArgbFromRgb(0, 0, 255), // Blue
	}

	// Request 10 colors
	result := quantizer.Quantize(pixels, 10)

	// Should get at most 3 colors since that's all we have
	if len(result) > 3 {
		t.Fatalf("Expected at most 3 colors, got %d", len(result))
	}
}

func TestGetIndex(t *testing.T) {
	// Test the index calculation function
	tests := []struct {
		r, g, b  int
		expected int
	}{
		{0, 0, 0, 0},
		{1, 0, 0, rgbIdx(1, 0, 0)},
		{0, 1, 0, rgbIdx(0, 1, 0)},
		{0, 0, 1, rgbIdx(0, 0, 1)},
		{1, 1, 1, rgbIdx(1, 1, 1)},
	}

	for _, test := range tests {
		result := rgbIdx(test.r, test.g, test.b)
		if test.expected == 0 && result != test.expected {
			t.Errorf("getIndex(%d, %d, %d) = %d, expected %d",
				test.r, test.g, test.b, result, test.expected)
		}

		// Basic sanity check - index should be non-negative and within bounds
		if result < 0 || result >= totalSize {
			t.Errorf("getIndex(%d, %d, %d) = %d, should be in range [0, %d)",
				test.r, test.g, test.b, result, totalSize)
		}
	}
}

func TestBox(t *testing.T) {
	box := &Box{
		r0: 0, r1: 10,
		g0: 0, g1: 10,
		b0: 0, b1: 10,
		vol: 1000,
	}

	if box.vol != 1000 {
		t.Errorf("Expected volume 1000, got %d", box.vol)
	}

	// Test that the box dimensions are set correctly
	if box.r0 != 0 || box.r1 != 10 {
		t.Errorf("Expected r0=0, r1=10, got r0=%d, r1=%d", box.r0, box.r1)
	}
	if box.g0 != 0 || box.g1 != 10 {
		t.Errorf("Expected g0=0, g1=10, got g0=%d, g1=%d", box.g0, box.g1)
	}
	if box.b0 != 0 || box.b1 != 10 {
		t.Errorf("Expected b0=0, b1=10, got b0=%d, b1=%d", box.b0, box.b1)
	}
}

func BenchmarkWuQuantizer(b *testing.B) {
	quantizer := NewWu()

	// Create a larger set of test pixels
	pixels := make([]uint32, 1000)
	for i := 0; i < 1000; i++ {
		r := uint8(i % 256)
		g := uint8((i * 2) % 256)
		bl := uint8((i * 3) % 256)
		pixels[i] = utils.ArgbFromRgb(r, g, bl)
	}

	b.ResetTimer()
	for i := 0; i < b.N; i++ {
		quantizer.Quantize(pixels, 16)
	}
}
