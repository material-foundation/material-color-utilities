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

// Package blend provides functions for blending colors in HCT and CAM16 color spaces.
package blend

import (
	"math"

	"github.com/material-foundation/material-color-utilities/go/cam"
	"github.com/material-foundation/material-color-utilities/go/utils"
)

// Harmonize blends the design color's HCT hue towards the key color's HCT hue,
// in a way that leaves the original color recognizable and recognizably shifted
// towards the key color.
func Harmonize(designColor, sourceColor uint32) uint32 {
	fromHct := cam.HctFromInt(designColor)
	toHct := cam.HctFromInt(sourceColor)
	differenceDegrees := utils.DifferenceDegrees(fromHct.Hue, toHct.Hue)
	rotationDegrees := math.Min(differenceDegrees*0.5, 15.0)
	outputHue := utils.SanitizeDegreesDouble(
		fromHct.Hue + rotationDegrees*utils.RotationDirection(fromHct.Hue, toHct.Hue))
	return cam.From(outputHue, fromHct.Chroma, fromHct.Tone).ToInt()
}

// HctHue blends hue from one color into another. The chroma and tone of the
// original color are maintained. Matches C++ implementation approach.
func HctHue(from, to uint32, amount float64) uint32 {
	ucs := Cam16Ucs(from, to, amount)
	ucsHct := cam.HctFromInt(ucs)
	fromHct := cam.HctFromInt(from)
	fromHct.SetHue(ucsHct.Hue)
	return fromHct.ToInt()
}

// Cam16Ucs blends colors in CAM16-UCS space.
func Cam16Ucs(from, to uint32, amount float64) uint32 {
	fromCam := cam.FromInt(from)
	toCam := cam.FromInt(to)
	fromJ := fromCam.Jstar
	fromA := fromCam.Astar
	fromB := fromCam.Bstar
	toJ := toCam.Jstar
	toA := toCam.Astar
	toB := toCam.Bstar
	jstar := fromJ + (toJ-fromJ)*amount
	astar := fromA + (toA-fromA)*amount
	bstar := fromB + (toB-fromB)*amount
	return cam.FromUcs(jstar, astar, bstar).ToInt()
}
