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

import "math"

// Signum returns the sign of a number.
// Returns 1 if positive, -1 if negative, 0 if zero.
func Signum(value float64) float64 {
	if value < 0 {
		return -1
	} else if value == 0 {
		return 0
	}
	return 1
}

// Lerp performs linear interpolation between two values.
func Lerp(start, stop, amount float64) float64 {
	return (1.0-amount)*start + amount*stop
}

// ClampInt clamps an integer between min and max values.
func ClampInt(min, max, value int) int {
	if value < min {
		return min
	}
	if value > max {
		return max
	}
	return value
}

// ClampFloat clamps a float between 0.0 and 1.0.
func ClampFloat(value float64) float64 {
	if value < 0.0 {
		return 0.0
	}
	if value > 1.0 {
		return 1.0
	}
	return value
}

// SanitizeDegreesInt ensures degrees are in the range [0, 360).
func SanitizeDegreesInt(degrees int) int {
	degrees = degrees % 360
	if degrees < 0 {
		degrees += 360
	}
	return degrees
}

// SanitizeDegreesDouble ensures degrees are in the range [0, 360).
func SanitizeDegreesDouble(degrees float64) float64 {
	degrees = math.Mod(degrees, 360.0)
	if degrees < 0 {
		degrees += 360.0
	}
	return degrees
}

// RotationDirection calculates the direction to rotate from one angle to another.
func RotationDirection(from, to float64) float64 {
	increasingDifference := SanitizeDegreesDouble(to - from)
	if increasingDifference <= 180.0 {
		return 1.0
	}
	return -1.0
}

// DifferenceDegrees calculates the difference between two angles in degrees.
func DifferenceDegrees(a, b float64) float64 {
	return 180.0 - math.Abs(math.Abs(a-b)-180.0)
}

// MatrixMultiply multiplies a row vector by a matrix.
func MatrixMultiply(row []float64, matrix [][]float64) []float64 {
	result := make([]float64, len(matrix))
	for i := range matrix {
		sum := 0.0
		for j := range row {
			sum += row[j] * matrix[i][j]
		}
		result[i] = sum
	}
	return result
}
