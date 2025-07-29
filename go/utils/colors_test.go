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

package utils

import (
	"math"
	"testing"
)

func TestArgbFromRgb(t *testing.T) {
	// Test cases from C++ implementation
	tests := []struct {
		r, g, b  uint8
		expected uint32
	}{
		{0, 0, 0, 0xff000000},       // Black - matches C++ test
		{255, 255, 255, 0xffffffff}, // White - matches C++ test
		{50, 150, 250, 0xff3296fa},  // Random color - matches C++ test
	}

	for _, test := range tests {
		result := ArgbFromRgb(test.r, test.g, test.b)
		if result != test.expected {
			t.Errorf("ArgbFromRgb(%d, %d, %d) = 0x%08X; want 0x%08X",
				test.r, test.g, test.b, result, test.expected)
		}
	}
}

func TestArgbComponents(t *testing.T) {
	// Test cases from C++ implementation
	tests := []struct {
		argb  uint32
		alpha uint8
		red   uint8
		green uint8
		blue  uint8
	}{
		{0xff123456, 0xff, 0x12, 0x34, 0x56}, // From C++ test
		{0xffabcdef, 0xff, 0xab, 0xcd, 0xef}, // From C++ test
	}

	for _, test := range tests {
		if alpha := AlphaFromArgb(test.argb); alpha != test.alpha {
			t.Errorf("AlphaFromArgb(0x%08X) = 0x%02X; want 0x%02X", test.argb, alpha, test.alpha)
		}

		if red := RedFromArgb(test.argb); red != test.red {
			t.Errorf("RedFromArgb(0x%08X) = 0x%02X; want 0x%02X", test.argb, red, test.red)
		}

		if green := GreenFromArgb(test.argb); green != test.green {
			t.Errorf("GreenFromArgb(0x%08X) = 0x%02X; want 0x%02X", test.argb, green, test.green)
		}

		if blue := BlueFromArgb(test.argb); blue != test.blue {
			t.Errorf("BlueFromArgb(0x%08X) = 0x%02X; want 0x%02X", test.argb, blue, test.blue)
		}
	}
}

func TestLinearized(t *testing.T) {
	// Test cases from C++ implementation with exact expected values
	tests := []struct {
		input     int
		expected  float64
		tolerance float64
	}{
		{0, 0.0, 1e-4},
		{1, 0.0303527, 1e-4},
		{2, 0.0607054, 1e-4},
		{8, 0.242822, 1e-4},
		{9, 0.273174, 1e-4},
		{16, 0.518152, 1e-4},
		{32, 1.44438, 1e-4},
		{64, 5.12695, 1e-4},
		{128, 21.5861, 1e-4},
		{255, 100.0, 1e-4},
	}

	for _, test := range tests {
		result := Linearized(test.input)
		if math.Abs(result-test.expected) > test.tolerance {
			t.Errorf("Linearized(%d) = %f; want %f", test.input, result, test.expected)
		}
	}
}

func TestDelinearized(t *testing.T) {
	// Test cases from C++ implementation with exact expected values
	tests := []struct {
		input    float64
		expected int
	}{
		{0.0, 0},
		{0.0303527, 1},
		{0.0607054, 2},
		{0.242822, 8},
		{0.273174, 9},
		{0.518152, 16},
		{1.44438, 32},
		{5.12695, 64},
		{21.5861, 128},
		{100.0, 255},
		{25.0, 137},
		{50.0, 188},
		{75.0, 225},
		// Test clamping behavior
		{-1.0, 0},
		{-10000.0, 0},
		{101.0, 255},
		{10000.0, 255},
	}

	for _, test := range tests {
		result := Delinearized(test.input)
		if result != test.expected {
			t.Errorf("Delinearized(%f) = %d; want %d", test.input, result, test.expected)
		}
	}
}

func TestWhitePointD65(t *testing.T) {
	wp := WhitePointD65
	expected := []float64{95.047, 100.0, 108.883}

	for i, val := range wp {
		if math.Abs(val-expected[i]) > 0.001 {
			t.Errorf("WhitePointD65[%d] = %f; want %f", i, val, expected[i])
		}
	}
}

func TestXyzFromArgb(t *testing.T) {
	// Test white
	white := uint32(0xFFFFFFFF)
	xyz := XyzFromArgb(white)
	expected := []float64{95.047, 100.0, 108.883}

	for i, val := range xyz {
		if math.Abs(val-expected[i]) > 1 {
			t.Errorf("XyzFromArgb(white)[%d] = %f; want %f", i, val, expected[i])
		}
	}
}

func TestArgbFromXyz(t *testing.T) {
	// Test white point
	xyz := []float64{95.047, 100.0, 108.883}
	argb := ArgbFromXyz(xyz[0], xyz[1], xyz[2])
	expected := uint32(0xFFFFFFFF)

	if argb != expected {
		t.Errorf("ArgbFromXyz(white point) = 0x%08X; want 0x%08X", argb, expected)
	}
}

func TestLabFromArgb(t *testing.T) {
	// Test white
	white := uint32(0xFFFFFFFF)
	lab := LabFromArgb(white)

	// White should have L* = 100, a* ≈ 0, b* ≈ 0
	if math.Abs(lab[0]-100.0) > 0.1 {
		t.Errorf("LabFromArgb(white)[0] = %f; want ~100", lab[0])
	}
	if math.Abs(lab[1]) > 0.1 {
		t.Errorf("LabFromArgb(white)[1] = %f; want ~0", lab[1])
	}
	if math.Abs(lab[2]) > 0.1 {
		t.Errorf("LabFromArgb(white)[2] = %f; want ~0", lab[2])
	}
}

func TestLstarFromArgb(t *testing.T) {
	// Test cases from C++ implementation with exact expected values
	tests := []struct {
		argb      uint32
		expected  float64
		tolerance float64
	}{
		{0xff89bce1, 74.011, 1e-3},   // From C++ test
		{0xff010204, 0.529651, 1e-6}, // From C++ test
	}

	for _, test := range tests {
		result := LstarFromArgb(test.argb)
		if math.Abs(result-test.expected) > test.tolerance {
			t.Errorf("LstarFromArgb(0x%08X) = %f; want %f", test.argb, result, test.expected)
		}
	}
}

func TestYFromLstar(t *testing.T) {
	// Test cases from C++ implementation with exact expected values and tolerance
	tests := []struct {
		input, expected, tolerance float64
	}{
		{0.0, 0.0, 1e-5},
		{0.1, 0.0110705, 1e-5},
		{0.2, 0.0221411, 1e-5},
		{0.3, 0.0332116, 1e-5},
		{0.4, 0.0442822, 1e-5},
		{0.5, 0.0553528, 1e-5},
		{1.0, 0.1107056, 1e-5},
		{2.0, 0.2214112, 1e-5},
		{3.0, 0.3321169, 1e-5},
		{4.0, 0.4428225, 1e-5},
		{5.0, 0.5535282, 1e-5},
		{8.0, 0.8856451, 1e-5},
		{10.0, 1.1260199, 1e-5},
		{15.0, 1.9085832, 1e-5},
		{20.0, 2.9890524, 1e-5},
		{25.0, 4.4154767, 1e-5},
		{30.0, 6.2359055, 1e-5},
		{40.0, 11.2509737, 1e-5},
		{50.0, 18.4186518, 1e-5},
		{60.0, 28.1233342, 1e-5},
		{70.0, 40.7494157, 1e-5},
		{80.0, 56.6812907, 1e-5},
		{90.0, 76.3033539, 1e-5},
		{95.0, 87.6183294, 1e-5},
		{99.0, 97.4360239, 1e-5},
		{100.0, 100.0, 1e-5},
	}

	for _, test := range tests {
		result := YFromLstar(test.input)
		if math.Abs(result-test.expected) > test.tolerance {
			t.Errorf("YFromLstar(%f) = %f; want %f", test.input, result, test.expected)
		}
	}
}

func TestArgbFromLstar(t *testing.T) {
	// Test cases from C++ implementation IntFromLstar
	tests := []struct {
		lstar    float64
		expected uint32
	}{
		{0.0, 0xff000000},
		{0.25, 0xff010101},
		{0.5, 0xff020202},
		{1.0, 0xff040404},
		{2.0, 0xff070707},
		{4.0, 0xff0e0e0e},
		{8.0, 0xff181818},
		{25.0, 0xff3b3b3b},
		{50.0, 0xff777777},
		{75.0, 0xffb9b9b9},
		{99.0, 0xfffcfcfc},
		{100.0, 0xffffffff},
		// Test clamping
		{-1.0, 0xff000000},
		{101.0, 0xffffffff},
	}

	for _, test := range tests {
		result := ArgbFromLstar(test.lstar)
		if result != test.expected {
			t.Errorf("ArgbFromLstar(%f) = 0x%x; want 0x%x", test.lstar, result, test.expected)
		}
	}
}

func TestOklabConversions(t *testing.T) {
	// Test cases with known OKLAB values
	tests := []struct {
		name      string
		argb      uint32
		expectedL float64
		expectedA float64
		expectedB float64
		tolerance float64
	}{
		{"Black", 0xFF000000, 0.0, 0.0, 0.0, 0.001},
		{"White", 0xFFFFFFFF, 1.0, 0.0, 0.0, 0.001},
		{"Red", 0xFFFF0000, 0.62796, 0.22486, 0.12585, 0.001},
		{"Green", 0xFF00FF00, 0.86644, -0.23389, 0.17950, 0.001},
		{"Blue", 0xFF0000FF, 0.45201, -0.03245, -0.31153, 0.001},
		{"Cyan", 0xFF00FFFF, 0.90540, -0.14944, -0.03940, 0.001},
		{"Magenta", 0xFFFF00FF, 0.70167, 0.27458, -0.16916, 0.001},
		{"Yellow", 0xFFFFFF00, 0.96798, -0.07137, 0.19857, 0.001},
	}

	for _, test := range tests {
		oklab := OklabFromArgb(test.argb)
		if math.Abs(oklab[0]-test.expectedL) > test.tolerance ||
			math.Abs(oklab[1]-test.expectedA) > test.tolerance ||
			math.Abs(oklab[2]-test.expectedB) > test.tolerance {
			t.Errorf("OklabFromArgb(%s/0x%08X) = [%.5f, %.5f, %.5f]; want [%.5f, %.5f, %.5f]",
				test.name, test.argb, oklab[0], oklab[1], oklab[2],
				test.expectedL, test.expectedA, test.expectedB)
		}

		// Test round-trip conversion
		roundTrip := ArgbFromOklab(oklab[0], oklab[1], oklab[2])
		if !colorsMatch(roundTrip, test.argb, 2) {
			t.Errorf("Round-trip failed for %s: ArgbFromOklab(OklabFromArgb(0x%08X)) = 0x%08X",
				test.name, test.argb, roundTrip)
		}
	}
}

func TestOklchConversions(t *testing.T) {
	// Test cases
	tests := []struct {
		name      string
		argb      uint32
		expectedL float64
		expectedC float64
		expectedH float64
		tolerance float64
	}{
		{"Black", 0xFF000000, 0.0, 0.0, 0.0, 0.001},
		{"White", 0xFFFFFFFF, 1.0, 0.0, 0.0, 0.001},
		{"Red", 0xFFFF0000, 0.62796, 0.25769, 29.158, 0.5},
		{"Green", 0xFF00FF00, 0.86644, 0.29483, 142.511, 0.5},
		{"Blue", 0xFF0000FF, 0.45201, 0.31320, 264.074, 0.5},
		{"Cyan", 0xFF00FFFF, 0.90540, 0.15480, 194.814, 0.5},
		{"Magenta", 0xFFFF00FF, 0.70167, 0.32250, 328.382, 0.5},
		{"Yellow", 0xFFFFFF00, 0.96798, 0.21102, 109.782, 0.5},
	}

	for _, test := range tests {
		oklch := OklchFromArgb(test.argb)
		if math.Abs(oklch[0]-test.expectedL) > test.tolerance ||
			math.Abs(oklch[1]-test.expectedC) > test.tolerance ||
			(test.expectedC > 0.001 && math.Abs(angleDifference(oklch[2], test.expectedH)) > 1.0) {
			t.Errorf("OklchFromArgb(%s/0x%08X) = [%.5f, %.5f, %.3f]; want [%.5f, %.5f, %.3f]",
				test.name, test.argb, oklch[0], oklch[1], oklch[2],
				test.expectedL, test.expectedC, test.expectedH)
		}

		// Test round-trip conversion
		roundTrip := ArgbFromOklch(oklch[0], oklch[1], oklch[2])
		if !colorsMatch(roundTrip, test.argb, 2) {
			t.Errorf("Round-trip failed for %s: ArgbFromOklch(OklchFromArgb(0x%08X)) = 0x%08X",
				test.name, test.argb, roundTrip)
		}
	}
}

func TestOklabAlphaConversions(t *testing.T) {
	tests := []struct {
		name  string
		argb  uint32
		alpha float64
	}{
		{"Opaque Red", 0xFFFF0000, 1.0},
		{"Semi-transparent Green", 0x8000FF00, 0.5},
		{"Quarter-transparent Blue", 0x400000FF, 0.25},
		{"Transparent Black", 0x00000000, 0.0},
	}

	for _, test := range tests {
		oklabA := OklabAFromArgb(test.argb)
		if math.Abs(oklabA[3]-test.alpha) > 0.01 {
			t.Errorf("OklabAFromArgb(%s/0x%08X) alpha = %.3f; want %.3f",
				test.name, test.argb, oklabA[3], test.alpha)
		}

		// Test round-trip with alpha
		roundTrip := ArgbFromOklabA(oklabA[0], oklabA[1], oklabA[2], oklabA[3])
		if roundTrip != test.argb {
			t.Errorf("Round-trip with alpha failed for %s: ArgbFromOklabA(OklabAFromArgb(0x%08X)) = 0x%08X",
				test.name, test.argb, roundTrip)
		}
	}
}

func TestOklchAlphaConversions(t *testing.T) {
	tests := []struct {
		name  string
		argb  uint32
		alpha float64
	}{
		{"Opaque Yellow", 0xFFFFFF00, 1.0},
		{"Semi-transparent Cyan", 0x8000FFFF, 0.5},
		{"Quarter-transparent Magenta", 0x40FF00FF, 0.25},
		{"Transparent White", 0x00FFFFFF, 0.0},
	}

	for _, test := range tests {
		oklchA := OklchAFromArgb(test.argb)
		if math.Abs(oklchA[3]-test.alpha) > 0.01 {
			t.Errorf("OklchAFromArgb(%s/0x%08X) alpha = %.3f; want %.3f",
				test.name, test.argb, oklchA[3], test.alpha)
		}

		// Test round-trip with alpha
		roundTrip := ArgbFromOklchA(oklchA[0], oklchA[1], oklchA[2], oklchA[3])
		if roundTrip != test.argb {
			t.Errorf("Round-trip with alpha failed for %s: ArgbFromOklchA(OklchAFromArgb(0x%08X)) = 0x%08X",
				test.name, test.argb, roundTrip)
		}
	}
}

func TestLabAlphaConversions(t *testing.T) {
	tests := []struct {
		name  string
		argb  uint32
		alpha float64
	}{
		{"Opaque Black", 0xFF000000, 1.0},
		{"Semi-transparent Gray", 0x80808080, 0.5},
		{"Transparent Red", 0x00FF0000, 0.0},
	}

	for _, test := range tests {
		labA := LabAFromArgb(test.argb)
		if math.Abs(labA[3]-test.alpha) > 0.01 {
			t.Errorf("LabAFromArgb(%s/0x%08X) alpha = %.3f; want %.3f",
				test.name, test.argb, labA[3], test.alpha)
		}

		// Test round-trip with alpha
		roundTrip := ArgbFromLabA(labA[0], labA[1], labA[2], labA[3])
		if roundTrip != test.argb {
			t.Errorf("Round-trip with alpha failed for %s: ArgbFromLabA(LabAFromArgb(0x%08X)) = 0x%08X",
				test.name, test.argb, roundTrip)
		}
	}
}

func TestXyzAlphaConversions(t *testing.T) {
	tests := []struct {
		name  string
		argb  uint32
		alpha float64
	}{
		{"Opaque White", 0xFFFFFFFF, 1.0},
		{"Semi-transparent Blue", 0x800000FF, 0.5},
		{"Transparent Green", 0x0000FF00, 0.0},
	}

	for _, test := range tests {
		xyzA := XyzAFromArgb(test.argb)
		if math.Abs(xyzA[3]-test.alpha) > 0.01 {
			t.Errorf("XyzAFromArgb(%s/0x%08X) alpha = %.3f; want %.3f",
				test.name, test.argb, xyzA[3], test.alpha)
		}

		// Test round-trip with alpha
		roundTrip := ArgbFromXyzA(xyzA[0], xyzA[1], xyzA[2], xyzA[3])
		if roundTrip != test.argb {
			t.Errorf("Round-trip with alpha failed for %s: ArgbFromXyzA(XyzAFromArgb(0x%08X)) = 0x%08X",
				test.name, test.argb, roundTrip)
		}
	}
}

// Helper function to check if two colors match within a tolerance
func colorsMatch(c1, c2 uint32, tolerance int) bool {
	r1, g1, b1 := int(RedFromArgb(c1)), int(GreenFromArgb(c1)), int(BlueFromArgb(c1))
	r2, g2, b2 := int(RedFromArgb(c2)), int(GreenFromArgb(c2)), int(BlueFromArgb(c2))
	
	return abs(r1-r2) <= tolerance && abs(g1-g2) <= tolerance && abs(b1-b2) <= tolerance
}

// Helper function for absolute value
func abs(x int) int {
	if x < 0 {
		return -x
	}
	return x
}

// Helper function to calculate angle difference
func angleDifference(a1, a2 float64) float64 {
	diff := math.Abs(a1 - a2)
	if diff > 180 {
		diff = 360 - diff
	}
	return diff
}
