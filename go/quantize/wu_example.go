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
	"github.com/material-foundation/material-color-utilities/go/utils"
)

// Example demonstrates how to use the Wu quantizer.
func ExampleWuQuantizer() {
	// Create a Wu quantizer
	quantizer := NewWu()
	
	// Create some sample pixels with various colors
	pixels := []uint32{
		utils.ArgbFromRgb(255, 0, 0),     // Red
		utils.ArgbFromRgb(255, 100, 100), // Light red
		utils.ArgbFromRgb(200, 0, 0),     // Dark red
		utils.ArgbFromRgb(0, 255, 0),     // Green
		utils.ArgbFromRgb(100, 255, 100), // Light green
		utils.ArgbFromRgb(0, 200, 0),     // Dark green
		utils.ArgbFromRgb(0, 0, 255),     // Blue
		utils.ArgbFromRgb(100, 100, 255), // Light blue
		utils.ArgbFromRgb(0, 0, 200),     // Dark blue
		utils.ArgbFromRgb(255, 255, 255), // White
		utils.ArgbFromRgb(128, 128, 128), // Gray
		utils.ArgbFromRgb(0, 0, 0),       // Black
	}
	
	// Quantize to 8 colors
	result := quantizer.Quantize(pixels, 8)
	
	fmt.Printf("Wu Quantizer reduced %d input colors to %d output colors:\n", 
		len(pixels), len(result))
	
	// Print the resulting colors
	for color := range result {
		r := utils.RedFromArgb(color)
		g := utils.GreenFromArgb(color)
		b := utils.BlueFromArgb(color)
		fmt.Printf("  RGB(%d, %d, %d)\n", r, g, b)
	}
}

// ExampleCompareQuantizers demonstrates the difference between Map and Wu quantizers.
func ExampleCompareQuantizers() {
	// Create test pixels with gradients
	var pixels []uint32
	
	// Add red gradient
	for i := 0; i < 50; i++ {
		val := uint8((i * 255) / 49)
		pixels = append(pixels, utils.ArgbFromRgb(255, val, val))
	}
	
	// Add green gradient  
	for i := 0; i < 50; i++ {
		val := uint8((i * 255) / 49)
		pixels = append(pixels, utils.ArgbFromRgb(val, 255, val))
	}
	
	// Add blue gradient
	for i := 0; i < 50; i++ {
		val := uint8((i * 255) / 49)
		pixels = append(pixels, utils.ArgbFromRgb(val, val, 255))
	}
	
	// Quantize with both algorithms
	mapQuantizer := NewMap()
	wuQuantizer := NewWu()
	
	mapResult := mapQuantizer.Quantize(pixels, 8)
	wuResult := wuQuantizer.Quantize(pixels, 8)
	
	fmt.Printf("Input: %d colors\n", len(pixels))
	fmt.Printf("Map Quantizer result: %d colors\n", len(mapResult))
	fmt.Printf("Wu Quantizer result: %d colors\n", len(wuResult))
	
	fmt.Println("\nWu Quantizer colors:")
	for color := range wuResult {
		r := utils.RedFromArgb(color)
		g := utils.GreenFromArgb(color)
		b := utils.BlueFromArgb(color)
		fmt.Printf("  RGB(%d, %d, %d)\n", r, g, b)
	}
}