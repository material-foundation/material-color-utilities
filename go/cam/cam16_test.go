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

package cam

import (
	"math"
	"testing"
)

func TestCam16RoundTrip(t *testing.T) {
	// Test basic colors for round-trip conversion
	colors := []uint32{
		0xFFFF0000, // Red
		0xFF00FF00, // Green
		0xFF0000FF, // Blue
		0xFFFFFFFF, // White
		0xFF000000, // Black
		0xFF808080, // Gray
	}

	for _, original := range colors {
		cam16 := FromInt(original)
		reconstructed := cam16.ToInt()

		// Allow small differences due to precision
		origR := (original >> 16) & 0xFF
		origG := (original >> 8) & 0xFF
		origB := original & 0xFF

		recR := (reconstructed >> 16) & 0xFF
		recG := (reconstructed >> 8) & 0xFF
		recB := reconstructed & 0xFF

		if math.Abs(float64(origR-recR)) > 2 ||
			math.Abs(float64(origG-recG)) > 2 ||
			math.Abs(float64(origB-recB)) > 2 {
			t.Errorf("Round trip failed for 0x%08x -> 0x%08x", original, reconstructed)
		}
	}
}

func TestCam16Properties(t *testing.T) {
	// Test CAM16 properties for known colors
	// Red should have hue around 0-30 degrees
	red := FromInt(0xFFFF0000)
	if red.Hue < 0 || red.Hue > 50 {
		t.Errorf("Red hue = %f; want 0-50", red.Hue)
	}
	if red.Chroma < 50 {
		t.Errorf("Red chroma = %f; want >50", red.Chroma)
	}

	// Blue should have hue around 240-290 degrees
	blue := FromInt(0xFF0000FF)
	if blue.Hue < 200 || blue.Hue > 320 {
		t.Errorf("Blue hue = %f; want 200-320", blue.Hue)
	}
	if blue.Chroma < 50 {
		t.Errorf("Blue chroma = %f; want >50", blue.Chroma)
	}

	// White should have low chroma
	white := FromInt(0xFFFFFFFF)
	if white.Chroma > 5 {
		t.Errorf("White chroma = %f; want <5", white.Chroma)
	}
	if white.J < 95 {
		t.Errorf("White lightness J = %f; want >95", white.J)
	}

	// Black should have low chroma and low lightness
	black := FromInt(0xFF000000)
	if black.Chroma > 5 {
		t.Errorf("Black chroma = %f; want <5", black.Chroma)
	}
	if black.J > 5 {
		t.Errorf("Black lightness J = %f; want <5", black.J)
	}
}

func TestCam16Distance(t *testing.T) {
	// Test distance calculation
	red := FromInt(0xFFFF0000)
	blue := FromInt(0xFF0000FF)
	white := FromInt(0xFFFFFFFF)

	// Distance from red to blue should be reasonably large
	redBlueDistance := red.Distance(blue)
	if redBlueDistance < 10 {
		t.Errorf("Red-Blue distance = %f; want >10", redBlueDistance)
	}

	// Distance from red to white should be moderate
	redWhiteDistance := red.Distance(white)
	if redWhiteDistance < 5 {
		t.Errorf("Red-White distance = %f; want >5", redWhiteDistance)
	}

	// Distance from red to itself should be 0
	redRedDistance := red.Distance(red)
	if redRedDistance > 0.1 {
		t.Errorf("Red-Red distance = %f; want ~0", redRedDistance)
	}
}

func TestCam16UcsCoordinates(t *testing.T) {
	// Test UCS coordinate calculation
	red := FromInt(0xFFFF0000)

	// Just verify UCS coordinates are reasonable
	if math.IsNaN(red.Jstar) || math.IsInf(red.Jstar, 0) {
		t.Errorf("Red Jstar = %f; should be finite", red.Jstar)
	}
	if math.IsNaN(red.Astar) || math.IsInf(red.Astar, 0) {
		t.Errorf("Red Astar = %f; should be finite", red.Astar)
	}
	if math.IsNaN(red.Bstar) || math.IsInf(red.Bstar, 0) {
		t.Errorf("Red Bstar = %f; should be finite", red.Bstar)
	}
}

func TestFromUcs(t *testing.T) {
	// Test creating CAM16 from UCS coordinates
	red := FromInt(0xFFFF0000)

	// Create a new CAM16 from the UCS coordinates
	reconstructed := FromUcs(red.Jstar, red.Astar, red.Bstar)

	// Should be approximately the same
	if math.Abs(red.Hue-reconstructed.Hue) > 1 {
		t.Errorf("UCS round-trip hue: %f -> %f", red.Hue, reconstructed.Hue)
	}
	if math.Abs(red.Chroma-reconstructed.Chroma) > 1 {
		t.Errorf("UCS round-trip chroma: %f -> %f", red.Chroma, reconstructed.Chroma)
	}
}
