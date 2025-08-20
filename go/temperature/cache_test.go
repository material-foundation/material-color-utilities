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

package temperature

import (
	"testing"

	"github.com/material-foundation/material-color-utilities/go/cam"
)

func TestTemperatureCache(t *testing.T) {
	// Test with a known color - red
	input := cam.HctFromInt(0xFFFF0000)

	// Test that we get a finite temperature
	temp := RawTemperature(input)
	if temp != temp { // Check for NaN
		t.Errorf("RawTemperature should be finite, got %f", temp)
	}
}

func TestRelativeTemperature(t *testing.T) {
	// Test with a red color
	input := cam.HctFromInt(0xFFFF0000)
	cache := NewCache(input)

	relTemp := cache.RelativeTemperature(input)
	if relTemp < 0 || relTemp > 1 {
		t.Errorf("RelativeTemperature should be in [0,1], got %f", relTemp)
	}
}

func TestComplementaryColors(t *testing.T) {
	// Test with red - should get a complement color
	input := cam.HctFromInt(0xFFFF0000)
	cache := NewCache(input)

	complement := cache.Complement()
	if complement == nil {
		t.Error("Complement should return a color")
	}

	// Verify it returns a valid HCT color
	if complement.ToInt() == 0 {
		t.Error("Complement color should not be transparent")
	}
}

func TestAnalogousColors(t *testing.T) {
	// Test with red - should get colors in the red-orange-pink region
	input := cam.HctFromInt(0xFFFF0000)
	cache := NewCache(input)

	analogous := cache.AnalogousColors(5, 12)
	if len(analogous) != 5 {
		t.Errorf("AnalogousColors(5, 12) should return 5 colors, got %d", len(analogous))
	}

	// Verify all returned colors are valid
	for i, color := range analogous {
		if color == nil {
			t.Errorf("Analogous color %d should not be nil", i)
		}
		if color.ToInt() == 0 {
			t.Errorf("Analogous color %d should not be transparent", i)
		}
	}
}

func TestAnalogousColorsDefault(t *testing.T) {
	// Test the default analogous colors method
	input := cam.HctFromInt(0xFF00FF00) // Green
	cache := NewCache(input)

	analogous := cache.AnalogousColorsDefault()
	if len(analogous) != 5 {
		t.Errorf("AnalogousColorsDefault should return 5 colors, got %d", len(analogous))
	}
}
