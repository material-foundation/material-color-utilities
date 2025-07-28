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
