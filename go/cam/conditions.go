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

// Package cam provides color appearance models including CAM16 and HCT.
package cam

import (
	"math"

	"github.com/material-foundation/material-color-utilities/go/utils"
)

// ViewingConditions represents the environment where a color was observed.
// In traditional color spaces, a color can be identified solely by the observer's
// measurement of the color. Color appearance models such as CAM16 also use
// information about the environment where the color was observed.
type ViewingConditions struct {
	Aw     float64   // Achromatic response
	Nbb    float64   // Brightness nonlinearity
	Ncb    float64   // Colorfulness nonlinearity
	C      float64   // Exponential nonlinearity
	Nc     float64   // Chromatic induction factor
	N      float64   // Background factor
	RgbD   []float64 // RGB adaptation factor
	Fl     float64   // Luminance level adaptation factor
	FlRoot float64   // Square root of Fl
	Z      float64   // Base exponential nonlinearity
}

// DefaultViewingConditions are sRGB-like viewing conditions.
var DefaultViewingConditions = Make(
	utils.WhitePointD65,
	200.0/math.Pi*utils.YFromLstar(50.0)/100.0,
	50.0,
	2.0,
	false,
)

// Make creates ViewingConditions from physically relevant parameters.
func Make(whitePoint []float64, adaptingLuminance, backgroundLstar, surround float64, discountingIlluminant bool) *ViewingConditions {
	// A background of pure black is non-physical and leads to infinities
	backgroundLstar = math.Max(0.1, backgroundLstar)

	// Transform white point XYZ to 'cone'/'rgb' responses
	matrix := XyzToCam16Rgb
	xyz := whitePoint
	rW := xyz[0]*matrix[0][0] + xyz[1]*matrix[0][1] + xyz[2]*matrix[0][2]
	gW := xyz[0]*matrix[1][0] + xyz[1]*matrix[1][1] + xyz[2]*matrix[1][2]
	bW := xyz[0]*matrix[2][0] + xyz[1]*matrix[2][1] + xyz[2]*matrix[2][2]

	f := 0.8 + surround/10.0

	var c float64
	if f >= 0.9 {
		c = utils.Lerp(0.59, 0.69, (f-0.9)*10.0)
	} else {
		c = utils.Lerp(0.525, 0.59, (f-0.8)*10.0)
	}

	var d float64
	if discountingIlluminant {
		d = 1.0
	} else {
		d = f * (1.0 - (1.0/3.6)*math.Exp((-adaptingLuminance-42.0)/92.0))
	}
	d = utils.ClampFloat(d)

	nc := f
	rgbD := []float64{
		d*(100.0/rW) + 1.0 - d,
		d*(100.0/gW) + 1.0 - d,
		d*(100.0/bW) + 1.0 - d,
	}

	k := 1.0 / (5.0*adaptingLuminance + 1.0)
	k4 := k * k * k * k
	k4F := 1.0 - k4
	fl := k4*adaptingLuminance + 0.1*k4F*k4F*math.Cbrt(5.0*adaptingLuminance)
	n := utils.YFromLstar(backgroundLstar) / whitePoint[1]
	z := 1.48 + math.Sqrt(n)
	nbb := 0.725 / math.Pow(n, 0.2)
	ncb := nbb

	rgbAFactors := []float64{
		math.Pow(fl*rgbD[0]*rW/100.0, 0.42),
		math.Pow(fl*rgbD[1]*gW/100.0, 0.42),
		math.Pow(fl*rgbD[2]*bW/100.0, 0.42),
	}

	rgbA := []float64{
		400.0 * rgbAFactors[0] / (rgbAFactors[0] + 27.13),
		400.0 * rgbAFactors[1] / (rgbAFactors[1] + 27.13),
		400.0 * rgbAFactors[2] / (rgbAFactors[2] + 27.13),
	}

	aw := (2.0*rgbA[0] + rgbA[1] + 0.05*rgbA[2]) * nbb

	return &ViewingConditions{
		Aw:     aw,
		Nbb:    nbb,
		Ncb:    ncb,
		C:      c,
		Nc:     nc,
		N:      n,
		RgbD:   rgbD,
		Fl:     fl,
		FlRoot: math.Sqrt(fl),
		Z:      z,
	}
}
