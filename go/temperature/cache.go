// Copyright 2022 Google LLC
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

// Package temperature provides utilities for color temperature theory.
package temperature

import (
	"math"
	"sort"

	"github.com/material-foundation/material-color-utilities/go/cam"
	"github.com/material-foundation/material-color-utilities/go/utils"
)

// Cache provides design utilities using color temperature theory.
// Supports finding analogous colors, complementary colors, and efficiently
// generates data for calculations when needed.
type Cache struct {
	input *cam.HCT

	precomputedComplement *cam.HCT
	precomputedHctsByTemp []*cam.HCT
	precomputedHctsByHue  []*cam.HCT
	precomputedTempsByHct map[*cam.HCT]float64
	precomputedColdest    *cam.HCT
	precomputedWarmest    *cam.HCT
}

// NewCache creates a cache that allows calculation of complementary and analogous colors.
func NewCache(input *cam.HCT) *Cache {
	return &Cache{
		input: input,
	}
}

// Complement returns a color that complements the input color aesthetically.
// In art, this is usually described as being across the color wheel.
func (c *Cache) Complement() *cam.HCT {
	if c.precomputedComplement != nil {
		return c.precomputedComplement
	}

	coldest := c.Coldest()
	coldestTemp := c.TempsByHct()[coldest]
	warmest := c.Warmest()
	warmestTemp := c.TempsByHct()[warmest]
	tempRange := warmestTemp - coldestTemp
	startHueIsColdestToWarmest := isBetween(c.input.Hue, coldest.Hue, warmest.Hue)

	var startHue, endHue float64
	if startHueIsColdestToWarmest {
		startHue = warmest.Hue
		endHue = coldest.Hue
	} else {
		startHue = coldest.Hue
		endHue = warmest.Hue
	}

	directionOfRotation := 1.0
	smallestError := 1000.0
	answer := c.HctsByHue()[int(math.Round(c.input.Hue))]

	complementRelativeTemp := 1.0 - c.RelativeTemperature(c.input)

	// Find the color in the other section, closest to the inverse percentile
	for hueAddend := 0.0; hueAddend <= 360.0; hueAddend += 1.0 {
		hue := utils.SanitizeDegreesDouble(startHue + directionOfRotation*hueAddend)
		if !isBetween(hue, startHue, endHue) {
			continue
		}
		possibleAnswer := c.HctsByHue()[int(math.Round(hue))]
		relativeTemp := (c.TempsByHct()[possibleAnswer] - coldestTemp) / tempRange
		error := math.Abs(complementRelativeTemp - relativeTemp)
		if error < smallestError {
			smallestError = error
			answer = possibleAnswer
		}
	}

	c.precomputedComplement = answer
	return c.precomputedComplement
}

// AnalogousColors returns a set of colors with differing hues, equidistant in temperature.
func (c *Cache) AnalogousColors(count int, divisions int) []*cam.HCT {
	// The starting hue is the hue of the input color.
	startHue := int(math.Round(c.input.Hue))
	startHct := c.HctsByHue()[startHue]
	lastTemp := c.RelativeTemperature(startHct)

	allColors := []*cam.HCT{startHct}

	absoluteTotalTempDelta := 0.0
	for i := 0; i < 360; i++ {
		hue := utils.SanitizeDegreesInt(startHue + i)
		hct := c.HctsByHue()[hue]
		temp := c.RelativeTemperature(hct)
		tempDelta := math.Abs(temp - lastTemp)
		lastTemp = temp
		absoluteTotalTempDelta += tempDelta
	}

	hueAddend := 1
	tempStep := absoluteTotalTempDelta / float64(divisions)
	totalTempDelta := 0.0
	lastTemp = c.RelativeTemperature(startHct)

	for len(allColors) < divisions {
		hue := utils.SanitizeDegreesInt(startHue + hueAddend)
		hct := c.HctsByHue()[hue]
		temp := c.RelativeTemperature(hct)
		tempDelta := math.Abs(temp - lastTemp)
		totalTempDelta += tempDelta

		desiredTotalTempDeltaForIndex := float64(len(allColors)) * tempStep
		indexSatisfied := totalTempDelta >= desiredTotalTempDeltaForIndex
		indexAddend := 1

		// Keep adding this hue to the answers until its temperature is
		// insufficient. This ensures consistent behavior when there aren't
		// `divisions` discrete steps between 0 and 360 in hue with `tempStep`
		// delta in temperature between them.
		//
		// For example, white and black have no analogues: there are no other
		// colors at T100/T0. Therefore, they should just be added to the array
		// as answers.
		for indexSatisfied && len(allColors) < divisions {
			allColors = append(allColors, hct)
			desiredTotalTempDeltaForIndex = float64(len(allColors)+indexAddend) * tempStep
			indexSatisfied = totalTempDelta >= desiredTotalTempDeltaForIndex
			indexAddend++
		}
		lastTemp = temp
		hueAddend++

		if hueAddend > 360 {
			for len(allColors) < divisions {
				allColors = append(allColors, hct)
			}
			break
		}
	}

	answers := []*cam.HCT{c.input}

	ccwCount := int(math.Floor((float64(count) - 1.0) / 2.0))
	for i := 1; i < (ccwCount + 1); i++ {
		index := 0 - i
		for index < 0 {
			index = len(allColors) + index
		}
		if index >= len(allColors) {
			index = index % len(allColors)
		}
		answers = append([]*cam.HCT{allColors[index]}, answers...)
	}

	cwCount := count - ccwCount - 1
	for i := 1; i < (cwCount + 1); i++ {
		index := i
		for index < 0 {
			index = len(allColors) + index
		}
		if index >= len(allColors) {
			index = index % len(allColors)
		}
		answers = append(answers, allColors[index])
	}

	return answers
}

// AnalogousColorsDefault returns 5 colors that pair well with the input color.
func (c *Cache) AnalogousColorsDefault() []*cam.HCT {
	return c.AnalogousColors(5, 12)
}

// RelativeTemperature returns the relative temperature of a color.
func (c *Cache) RelativeTemperature(hct *cam.HCT) float64 {
	tempsByHct := c.TempsByHct()
	coldest := c.Coldest()
	warmest := c.Warmest()
	tempRange := tempsByHct[warmest] - tempsByHct[coldest]
	differenceFromColdest := tempsByHct[hct] - tempsByHct[coldest]
	// Handle when there's no difference in temperature between warmest and
	// coldest: for example, at T100, only one color is available, white.
	if tempRange == 0.0 {
		return 0.5
	}
	return differenceFromColdest / tempRange
}

// Coldest returns the HCT color with the coldest temperature.
func (c *Cache) Coldest() *cam.HCT {
	if c.precomputedColdest != nil {
		return c.precomputedColdest
	}
	c.precomputedColdest = c.HctsByTemp()[0]
	return c.precomputedColdest
}

// Warmest returns the HCT color with the warmest temperature.
func (c *Cache) Warmest() *cam.HCT {
	if c.precomputedWarmest != nil {
		return c.precomputedWarmest
	}
	hctsByTemp := c.HctsByTemp()
	c.precomputedWarmest = hctsByTemp[len(hctsByTemp)-1]
	return c.precomputedWarmest
}

// HctsByTemp returns HCT colors sorted by temperature, coldest to warmest.
func (c *Cache) HctsByTemp() []*cam.HCT {
	if c.precomputedHctsByTemp != nil {
		return c.precomputedHctsByTemp
	}

	hcts := make([]*cam.HCT, len(c.HctsByHue()))
	copy(hcts, c.HctsByHue())
	hcts = append(hcts, c.input)

	tempsByHct := c.TempsByHct()
	sort.Slice(hcts, func(i, j int) bool {
		return tempsByHct[hcts[i]] < tempsByHct[hcts[j]]
	})

	c.precomputedHctsByTemp = hcts
	return c.precomputedHctsByTemp
}

// HctsByHue returns HCT colors indexed by hue.
func (c *Cache) HctsByHue() []*cam.HCT {
	if c.precomputedHctsByHue != nil {
		return c.precomputedHctsByHue
	}

	hcts := make([]*cam.HCT, 361)
	for i := 0; i <= 360; i++ {
		hcts[i] = cam.From(float64(i), c.input.Chroma, c.input.Tone)
	}

	c.precomputedHctsByHue = hcts
	return c.precomputedHctsByHue
}

// TempsByHct returns a map of HCT colors to their temperatures.
func (c *Cache) TempsByHct() map[*cam.HCT]float64 {
	if c.precomputedTempsByHct != nil {
		return c.precomputedTempsByHct
	}

	allHcts := make([]*cam.HCT, len(c.HctsByHue()))
	copy(allHcts, c.HctsByHue())
	allHcts = append(allHcts, c.input)

	temps := make(map[*cam.HCT]float64)
	for _, hct := range allHcts {
		temps[hct] = RawTemperature(hct)
	}

	c.precomputedTempsByHct = temps
	return c.precomputedTempsByHct
}

// RawTemperature calculates the raw temperature of an HCT color.
func RawTemperature(color *cam.HCT) float64 {
	lab := utils.LabFromArgb(color.ToInt())
	hue := utils.SanitizeDegreesDouble(math.Atan2(lab[2], lab[1]) * 180.0 / math.Pi)
	chroma := math.Sqrt(lab[1]*lab[1] + lab[2]*lab[2])
	return -0.5 + 0.02*math.Pow(chroma, 1.07)*math.Cos(utils.SanitizeDegreesDouble(hue-50.0)*math.Pi/180.0)
}

// isBetween checks if angle is between start and end in circular fashion.
func isBetween(angle, start, end float64) bool {
	if end >= start {
		return start <= angle && angle <= end
	}
	return start <= angle || angle <= end
}
