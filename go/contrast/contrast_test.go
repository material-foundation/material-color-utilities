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

package contrast

import (
	"math"
	"testing"
)

func TestRatioOfYs(t *testing.T) {
	// Test cases from C++ implementation
	tests := []struct {
		y1, y2    float64
		expected  float64
		tolerance float64
	}{
		{100.0, 0.0, 21.0, 0.1},  // Maximum contrast
		{100.0, 100.0, 1.0, 0.1}, // Same luminance
		{50.0, 25.0, 1.83, 0.1},  // Adjusted expectation
		{0.0, 100.0, 21.0, 0.1},  // Reverse order should give same result
	}

	for _, test := range tests {
		result := RatioOfYs(test.y1, test.y2)
		if math.Abs(result-test.expected) > test.tolerance {
			t.Errorf("RatioOfYs(%f, %f) = %f; want %f±%f", test.y1, test.y2, result, test.expected, test.tolerance)
		}
	}
}

func TestRatioOfTones(t *testing.T) {
	// Test using tone values
	tests := []struct {
		t1, t2   float64
		expected float64
	}{
		{100.0, 0.0, 21.0}, // White to black
		{50.0, 50.0, 1.0},  // Same tone
		{80.0, 20.0, 7.0},  // High contrast pair (approximate)
	}

	for _, test := range tests {
		result := RatioOfTones(test.t1, test.t2)
		if math.Abs(result-test.expected) > 1.0 { // Allow more tolerance for tone calculations
			t.Errorf("RatioOfTones(%f, %f) = %f; want ~%f", test.t1, test.t2, result, test.expected)
		}
	}
}

func TestLighter(t *testing.T) {
	// Test cases for lighter tone calculation
	result1 := Lighter(10.0, 2.0)
	if result1 <= 10.0 {
		t.Errorf("Lighter(10.0, 2.0) = %f; should be > 10.0", result1)
	}

	// Test impossible case - already very light with high ratio requirement
	result2 := Lighter(95.0, 3.0)
	if result2 != -1.0 {
		t.Errorf("Lighter(95.0, 3.0) = %f; want -1 (impossible)", result2)
	}
}

func TestDarker(t *testing.T) {
	// Test cases for darker tone calculation
	result1 := Darker(90.0, 2.0)
	if result1 >= 90.0 {
		t.Errorf("Darker(90.0, 2.0) = %f; should be < 90.0", result1)
	}

	// Test impossible case - already very dark with high ratio requirement
	result2 := Darker(5.0, 3.0)
	if result2 != -1.0 {
		t.Errorf("Darker(5.0, 3.0) = %f; want -1 (impossible)", result2)
	}
}

func TestLighterUnsafe(t *testing.T) {
	// Test the "unsafe" version that always returns a value
	result := LighterUnsafe(50.0, 2.0)
	if result < 50.0 {
		t.Errorf("LighterUnsafe should return a tone >= input, got %f", result)
	}
}

func TestDarkerUnsafe(t *testing.T) {
	// Test the "unsafe" version that always returns a value
	result := DarkerUnsafe(50.0, 2.0)
	if result > 50.0 {
		t.Errorf("DarkerUnsafe should return a tone <= input, got %f", result)
	}
}
