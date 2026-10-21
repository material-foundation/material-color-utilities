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

// Package quantize provides color quantization algorithms for extracting
// color palettes from images.
package quantize

// Quantizer interface defines the contract for color quantization algorithms.
type Quantizer interface {
	// Quantize reduces the number of colors in the input pixels to at most maxColors.
	// Returns a map of colors to their counts.
	Quantize(pixels []uint32, maxColors int) map[uint32]int
}

// PointProvider interface defines a contract for providing Lab color points.
type PointProvider interface {
	// FromInt converts an ARGB color to a point in 3D space.
	FromInt(argb uint32) []float64
	
	// ToInt converts a point in 3D space back to an ARGB color.
	ToInt(point []float64) uint32
	
	// Distance calculates the distance between two points.
	Distance(a, b []float64) float64
}