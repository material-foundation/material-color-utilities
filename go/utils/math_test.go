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

func TestSignum(t *testing.T) {
	// Test cases from C++ implementation
	tests := []struct {
		input    float64
		expected float64
	}{
		{0.001, 1},
		{3.0, 1},
		{100.0, 1},
		{-0.002, -1},
		{-4.0, -1},
		{-101.0, -1},
		{0.0, 0},
	}

	for _, test := range tests {
		result := Signum(test.input)
		if result != test.expected {
			t.Errorf("Signum(%f) = %f; want %f", test.input, result, test.expected)
		}
	}
}

func TestLerp(t *testing.T) {
	tests := []struct {
		start, stop, amount, expected float64
	}{
		{0.0, 10.0, 0.0, 0.0},
		{0.0, 10.0, 1.0, 10.0},
		{0.0, 10.0, 0.5, 5.0},
		{-5.0, 5.0, 0.25, -2.5},
	}

	for _, test := range tests {
		result := Lerp(test.start, test.stop, test.amount)
		if math.Abs(result-test.expected) > 0.001 {
			t.Errorf("Lerp(%f, %f, %f) = %f; want %f",
				test.start, test.stop, test.amount, result, test.expected)
		}
	}
}

func TestClampInt(t *testing.T) {
	tests := []struct {
		min, max, input, expected int
	}{
		{0, 10, 5, 5},
		{0, 10, -1, 0},
		{0, 10, 15, 10},
		{-5, 5, 0, 0},
	}

	for _, test := range tests {
		result := ClampInt(test.min, test.max, test.input)
		if result != test.expected {
			t.Errorf("ClampInt(%d, %d, %d) = %d; want %d",
				test.min, test.max, test.input, result, test.expected)
		}
	}
}

func TestClampFloat(t *testing.T) {
	tests := []struct {
		input, expected float64
	}{
		{0.5, 0.5},
		{-1.0, 0.0},
		{1.5, 1.0},
		{0.0, 0.0},
		{1.0, 1.0},
	}

	for _, test := range tests {
		result := ClampFloat(test.input)
		if result != test.expected {
			t.Errorf("ClampFloat(%f) = %f; want %f",
				test.input, result, test.expected)
		}
	}
}

func TestSanitizeDegreesInt(t *testing.T) {
	// Test cases from C++ implementation
	tests := []struct {
		input, expected int
	}{
		{30, 30},
		{240, 240},
		{360, 0},
		{-30, 330},
		{-750, 330},
		{-54321, 39},
	}

	for _, test := range tests {
		result := SanitizeDegreesInt(test.input)
		if result != test.expected {
			t.Errorf("SanitizeDegreesInt(%d) = %d; want %d", test.input, result, test.expected)
		}
	}
}

func TestSanitizeDegreesDouble(t *testing.T) {
	// Test cases from C++ implementation with exact expected values and tolerance
	tests := []struct {
		input, expected, tolerance float64
	}{
		{30.0, 30.0, 1e-4},
		{240.0, 240.0, 1e-4},
		{360.0, 0.0, 1e-4},
		{-30.0, 330.0, 1e-4},
		{-750.0, 330.0, 1e-4},
		{-54321.0, 39.0, 1e-4},
		{360.125, 0.125, 1e-4},
		{-11111.11, 48.89, 1e-4},
	}

	for _, test := range tests {
		result := SanitizeDegreesDouble(test.input)
		if math.Abs(result-test.expected) > test.tolerance {
			t.Errorf("SanitizeDegreesDouble(%f) = %f; want %f", test.input, result, test.expected)
		}
	}
}

func TestRotationDirectionPositive(t *testing.T) {
	// Test cases from C++ implementation - positive (counterclockwise) rotation
	tests := []struct {
		from, to float64
	}{
		{0.0, 30.0},
		{0.0, 60.0},
		{0.0, 150.0},
		{90.0, 240.0},
		{300.0, 30.0},
		{270.0, 60.0},
		{360.0 * 2, 15.0},
		{360.0*3 + 15.0, -360.0*4 + 30.0},
	}

	for _, test := range tests {
		result := RotationDirection(test.from, test.to)
		if result != 1.0 {
			t.Errorf("RotationDirection(%f, %f) = %f; want 1.0", test.from, test.to, result)
		}
	}
}

func TestRotationDirectionNegative(t *testing.T) {
	// Test cases from C++ implementation - negative (clockwise) rotation
	tests := []struct {
		from, to float64
	}{
		{30.0, 0.0},
		{60.0, 0.0},
		{150.0, 0.0},
		{240.0, 90.0},
		{30.0, 300.0},
		{60.0, 270.0},
		{15.0, -360.0 * 2},
		{-360.0*4 + 270.0, 360.0*5 + 180.0},
	}

	for _, test := range tests {
		result := RotationDirection(test.from, test.to)
		if result != -1.0 {
			t.Errorf("RotationDirection(%f, %f) = %f; want -1.0", test.from, test.to, result)
		}
	}
}

func TestDifferenceDegrees(t *testing.T) {
	// Test cases from C++ implementation (DiffDegrees function)
	tests := []struct {
		a, b, expected float64
	}{
		{0.0, 30.0, 30.0},
		{0.0, 60.0, 60.0},
		{0.0, 150.0, 150.0},
		{90.0, 240.0, 150.0},
		{300.0, 30.0, 90.0},
		{270.0, 60.0, 150.0},
		// Reverse direction - should give same results
		{30.0, 0.0, 30.0},
		{60.0, 0.0, 60.0},
		{150.0, 0.0, 150.0},
		{240.0, 90.0, 150.0},
		{30.0, 300.0, 90.0},
		{60.0, 270.0, 150.0},
	}

	for _, test := range tests {
		result := DifferenceDegrees(test.a, test.b)
		if math.Abs(result-test.expected) > 0.001 {
			t.Errorf("DifferenceDegrees(%f, %f) = %f; want %f",
				test.a, test.b, result, test.expected)
		}
	}
}

func TestMatrixMultiply(t *testing.T) {
	// Test cases from C++ implementation using the same matrix
	matrix := [][]float64{
		{1, 2, 3},
		{-4, 5, -6},
		{-7, -8, -9},
	}

	tests := []struct {
		input, expected []float64
	}{
		{[]float64{1, 3, 5}, []float64{22, -19, -76}},
		{[]float64{-11.1, 22.2, -33.3}, []float64{-66.6, 355.2, 199.8}},
	}

	for _, test := range tests {
		result := MatrixMultiply(test.input, matrix)
		for i, val := range result {
			if math.Abs(val-test.expected[i]) > 0.001 {
				t.Errorf("MatrixMultiply(%v, matrix) result[%d] = %f; want %f", test.input, i, val, test.expected[i])
			}
		}
	}
}
