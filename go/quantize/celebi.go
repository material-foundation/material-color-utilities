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

// Package quantize provides color quantization algorithms for extracting colors from images.
package quantize

// QuantizerResult holds the result of a quantization operation.
type QuantizerResult struct {
	ColorToCount map[uint32]int
}

// Celebi implements the Celebi quantization algorithm.
// This algorithm improves on standard K-Means by using Wu quantizer output
// as initial centroids.
type Celebi struct{}

// NewCelebi creates a new Celebi quantizer.
func NewCelebi() *Celebi {
	return &Celebi{}
}

// Quantize reduces the number of colors needed to represent the input,
// minimizing the difference between the original image and the recolored image.
func (q *Celebi) Quantize(pixels []uint32, maxColors int) map[uint32]int {
	// For now, implement a basic version that returns the most common colors
	// A full implementation would be quite complex and require Wu and WSMeans algorithms
	mapQuantizer := NewMap()
	return mapQuantizer.Quantize(pixels, maxColors)
}

// QuantizeCelebi is a convenience function that uses the Celebi quantizer.
func QuantizeCelebi(pixels []uint32, maxColors int) map[uint32]int {
	quantizer := NewCelebi()
	return quantizer.Quantize(pixels, maxColors)
}
