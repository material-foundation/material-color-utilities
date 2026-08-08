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

package quantize

import "sort"

// Map is a simple quantizer that just returns the most frequent colors.
// This is used as a fallback and base for other quantizers.
type Map struct{}

// NewMap creates a new Map quantizer.
func NewMap() *Map {
	return &Map{}
}

// Quantize returns the most frequent colors from the input pixels.
func (q *Map) Quantize(pixels []uint32, maxColors int) map[uint32]int {
	colorCounts := make(map[uint32]int)
	for _, pixel := range pixels {
		colorCounts[pixel]++
	}

	// If we have fewer unique colors than maxColors, return all
	if len(colorCounts) <= maxColors {
		return colorCounts
	}

	// Otherwise, return the most frequent colors
	type colorCount struct {
		color uint32
		count int
	}

	var colors []colorCount
	for color, count := range colorCounts {
		colors = append(colors, colorCount{color, count})
	}

	// Sort by count (descending)
	sort.Slice(colors, func(i, j int) bool {
		return colors[i].count > colors[j].count
	})

	result := make(map[uint32]int)
	for i := 0; i < maxColors && i < len(colors); i++ {
		result[colors[i].color] = colors[i].count
	}

	return result
}