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

// Package score provides utilities for ranking colors by suitability for UI themes.
package score

import (
	"math"
	"sort"

	"github.com/material-foundation/material-color-utilities/go/cam"
	"github.com/material-foundation/material-color-utilities/go/utils"
)

// Scoring constants
const (
	targetChroma            = 48.0 // A1 Chroma
	weightProportion        = 0.7
	weightChromaAbove       = 0.3
	weightChromaBelow       = 0.1
	cutoffChroma            = 5.0
	cutoffExcitedProportion = 0.01
)

// Google Blue fallback color
const fallbackColorArgb = 0xFF4285F4

// colorScore represents a color with its calculated score
type colorScore struct {
	color uint32
	score float64
}

// Score ranks colors by suitability for UI themes with default parameters.
func Score(colorsToPopulation map[uint32]int) []uint32 {
	return ScoreWithOptions(colorsToPopulation, 4, fallbackColorArgb, true)
}

// ScoreWithDesired ranks colors by suitability for UI themes with specified count.
func ScoreWithDesired(colorsToPopulation map[uint32]int, desired int) []uint32 {
	return ScoreWithOptions(colorsToPopulation, desired, fallbackColorArgb, true)
}

// ScoreWithFallback ranks colors by suitability for UI themes with custom fallback.
func ScoreWithFallback(colorsToPopulation map[uint32]int, desired int, fallbackColorArgb uint32) []uint32 {
	return ScoreWithOptions(colorsToPopulation, desired, fallbackColorArgb, true)
}

// ScoreWithOptions ranks colors by suitability for UI themes with full customization.
func ScoreWithOptions(colorsToPopulation map[uint32]int, desired int, fallbackColorArgb uint32, filter bool) []uint32 {
	// Get HCT color for each ARGB value, while finding per hue count and total count
	var colorsHct []*cam.HCT
	huePopulation := make([]int, 360)
	populationSum := 0.0

	for color, population := range colorsToPopulation {
		hct := cam.HctFromInt(color)
		colorsHct = append(colorsHct, hct)
		hue := int(math.Floor(hct.Hue))
		huePopulation[hue] += population
		populationSum += float64(population)
	}

	// Hues with more usage in neighboring 30 degree slice get a larger number
	hueExcitedProportions := make([]float64, 360)
	for hue := 0; hue < 360; hue++ {
		proportion := float64(huePopulation[hue]) / populationSum
		for i := hue - 14; i < hue+16; i++ {
			neighborHue := utils.SanitizeDegreesInt(i)
			hueExcitedProportions[neighborHue] += proportion
		}
	}

	// Score colors
	var colorScores []colorScore
	i := 0
	for color := range colorsToPopulation {
		hct := colorsHct[i]
		hue := utils.SanitizeDegreesInt(int(math.Round(hct.Hue)))
		proportion := hueExcitedProportions[hue]

		if filter && (hct.Chroma < cutoffChroma || proportion <= cutoffExcitedProportion) {
			i++
			continue
		}

		proportionScore := proportion * 100.0 * weightProportion
		var chromaWeight float64
		if hct.Chroma < targetChroma {
			chromaWeight = weightChromaBelow
		} else {
			chromaWeight = weightChromaAbove
		}
		chromaScore := (hct.Chroma - targetChroma) * chromaWeight
		score := proportionScore + chromaScore

		colorScores = append(colorScores, colorScore{color, score})
		i++
	}

	// Sort by score (descending)
	sort.Slice(colorScores, func(i, j int) bool {
		return colorScores[i].score > colorScores[j].score
	})

	// Extract colors
	var colors []uint32
	for i := 0; i < desired && i < len(colorScores); i++ {
		colors = append(colors, colorScores[i].color)
	}

	// Ensure we always return at least one color
	if len(colors) == 0 {
		colors = append(colors, fallbackColorArgb)
	}

	return colors
}
