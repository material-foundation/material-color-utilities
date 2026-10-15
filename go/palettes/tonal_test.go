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

package palettes

import (
	"testing"
)

func TestTonalFromInt(t *testing.T) {
	argb := uint32(0xFF0000FF) // Blue
	palette := TonalFromInt(argb)

	// Check that we have a valid palette
	if palette == nil {
		t.Fatal("TonalFromInt returned nil")
	}

	// Test some specific tones
	tone0 := palette.Tone(0)     // Should be very dark
	tone50 := palette.Tone(50)   // Middle tone
	tone100 := palette.Tone(100) // Should be very light

	// Check that tones get lighter as expected
	// Extract lightness from each color
	l0 := lightness(tone0)
	l50 := lightness(tone50)
	l100 := lightness(tone100)

	if l0 >= l50 {
		t.Errorf("Tone 0 lightness (%f) should be less than tone 50 (%f)", l0, l50)
	}
	if l50 >= l100 {
		t.Errorf("Tone 50 lightness (%f) should be less than tone 100 (%f)", l50, l100)
	}
}

func TestTonalFromHueAndChroma(t *testing.T) {
	hue := 240.0 // Blue hue
	chroma := 50.0
	palette := TonalFromHueAndChroma(hue, chroma)

	if palette == nil {
		t.Fatal("TonalFromHueAndChroma returned nil")
	}

	// Test that different tones produce different colors
	tone25 := palette.Tone(25)
	tone75 := palette.Tone(75)

	if tone25 == tone75 {
		t.Error("Different tones should produce different colors")
	}
}

func TestTonalPaletteCache(t *testing.T) {
	palette := TonalFromHueAndChroma(120.0, 50.0)

	// Get the same tone twice
	tone50_1 := palette.Tone(50)
	tone50_2 := palette.Tone(50)

	// Should return the same value (cached)
	if tone50_1 != tone50_2 {
		t.Errorf("Cached tone values should be identical: %x vs %x", tone50_1, tone50_2)
	}
}

func TestTonalPaletteEdgeCases(t *testing.T) {
	palette := TonalFromHueAndChroma(0.0, 30.0)

	// Test edge tones
	tone0 := palette.Tone(0)
	tone100 := palette.Tone(100)

	// Tone 0 should be very dark (close to black)
	r0 := (tone0 >> 16) & 0xFF
	g0 := (tone0 >> 8) & 0xFF
	b0 := tone0 & 0xFF
	if r0 > 20 || g0 > 20 || b0 > 20 {
		t.Errorf("Tone 0 should be very dark: R=%d G=%d B=%d", r0, g0, b0)
	}

	// Tone 100 should be very light (close to white)
	r100 := (tone100 >> 16) & 0xFF
	g100 := (tone100 >> 8) & 0xFF
	b100 := tone100 & 0xFF
	if r100 < 235 || g100 < 235 || b100 < 235 {
		t.Errorf("Tone 100 should be very light: R=%d G=%d B=%d", r100, g100, b100)
	}
}

// Helper function to extract perceived lightness from ARGB
func lightness(argb uint32) float64 {
	r := float64((argb >> 16) & 0xFF)
	g := float64((argb >> 8) & 0xFF)
	b := float64(argb & 0xFF)

	// Simple luminance calculation (not exact, but good enough for testing)
	return 0.299*r + 0.587*g + 0.114*b
}
