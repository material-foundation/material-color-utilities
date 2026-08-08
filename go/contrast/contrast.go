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

// Package contrast provides utilities for calculating and ensuring color contrast ratios.
package contrast

import (
	"math"

	"github.com/material-foundation/material-color-utilities/go/utils"
)

// Standard contrast ratio constants
const (
	RatioMin = 1.0  // Minimum contrast ratio of two colors
	RatioMax = 21.0 // Maximum contrast ratio of two colors
	Ratio30  = 3.0  // WCAG AA normal text
	Ratio45  = 4.5  // WCAG AA large text
	Ratio70  = 7.0  // WCAG AAA
)

// Internal constants for contrast calculations
const (
	contrastRatioEpsilon       = 0.04 // Tolerance for contrast ratio calculations
	luminanceGamutMapTolerance = 0.4  // Tolerance for gamut mapping
)

// RatioOfYs calculates the contrast ratio of two Y values (relative luminance).
// This is the standard WCAG contrast ratio calculation.
func RatioOfYs(y1, y2 float64) float64 {
	lighter := math.Max(y1, y2)
	var darker float64
	if lighter == y2 {
		darker = y1
	} else {
		darker = y2
	}
	return (lighter + 5.0) / (darker + 5.0)
}

// RatioOfTones calculates the contrast ratio of two tones (T in HCT, L* in L*a*b*).
func RatioOfTones(t1, t2 float64) float64 {
	return RatioOfYs(utils.YFromLstar(t1), utils.YFromLstar(t2))
}

// Lighter returns a tone >= the input tone that ensures the given contrast ratio.
// Returns -1 if the ratio cannot be achieved.
func Lighter(tone, ratio float64) float64 {
	if tone < 0.0 || tone > 100.0 {
		return -1.0
	}

	// Invert the contrast ratio equation to determine lighter Y given a ratio and darker Y
	darkY := utils.YFromLstar(tone)
	lightY := ratio*(darkY+5.0) - 5.0
	if lightY < 0.0 || lightY > 100.0 {
		return -1.0
	}

	realContrast := RatioOfYs(lightY, darkY)
	delta := math.Abs(realContrast - ratio)
	if realContrast < ratio && delta > contrastRatioEpsilon {
		return -1.0
	}

	returnValue := utils.LstarFromY(lightY) + luminanceGamutMapTolerance
	if returnValue < 0 || returnValue > 100 {
		return -1.0
	}
	return returnValue
}

// LighterUnsafe returns a tone >= the input tone that ensures the given contrast ratio.
// Unlike Lighter, this function does not validate the result and returns 100 if
// the ratio cannot be achieved.
func LighterUnsafe(tone, ratio float64) float64 {
	lighter := Lighter(tone, ratio)
	if lighter < 0 {
		return 100.0
	}
	return lighter
}

// Darker returns a tone <= the input tone that ensures the given contrast ratio.
// Returns -1 if the ratio cannot be achieved.
func Darker(tone, ratio float64) float64 {
	if tone < 0.0 || tone > 100.0 {
		return -1.0
	}

	// Invert the contrast ratio equation to determine darker Y given a ratio and lighter Y
	lightY := utils.YFromLstar(tone)
	darkY := ((lightY + 5.0) / ratio) - 5.0
	if darkY < 0.0 || darkY > 100.0 {
		return -1.0
	}

	realContrast := RatioOfYs(lightY, darkY)
	delta := math.Abs(realContrast - ratio)
	if realContrast < ratio && delta > contrastRatioEpsilon {
		return -1.0
	}

	returnValue := utils.LstarFromY(darkY) - luminanceGamutMapTolerance
	if returnValue < 0 || returnValue > 100 {
		return -1.0
	}
	return returnValue
}

// DarkerUnsafe returns a tone <= the input tone that ensures the given contrast ratio.
// Unlike Darker, this function does not validate the result and returns 0 if
// the ratio cannot be achieved.
func DarkerUnsafe(tone, ratio float64) float64 {
	darker := Darker(tone, ratio)
	if darker < 0 {
		return 0.0
	}
	return darker
}
