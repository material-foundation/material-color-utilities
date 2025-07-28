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

// Package palettes provides color palette utilities for Material Design.
package palettes

import (
	"github.com/material-foundation/material-color-utilities/go/cam"
	"github.com/material-foundation/material-color-utilities/go/utils"
)

// Tonal is a convenience class for retrieving colors that are constant
// in hue and chroma, but vary in tone.
type Tonal struct {
	cache    map[int]uint32
	keyColor *cam.HCT
	Hue      float64
	Chroma   float64
}

// TonalFromInt creates tones using the HCT hue and chroma from a color.
func TonalFromInt(argb uint32) *Tonal {
	return TonalFromHct(cam.HctFromInt(argb))
}

// TonalFromHct creates tones using an HCT color.
func TonalFromHct(hct *cam.HCT) *Tonal {
	return &Tonal{
		cache:    make(map[int]uint32),
		Hue:      hct.Hue,
		Chroma:   hct.Chroma,
		keyColor: hct,
	}
}

// TonalFromHueAndChroma creates tones from a defined HCT hue and chroma.
func TonalFromHueAndChroma(hue, chroma float64) *Tonal {
	keyColor := createKeyColor(hue, chroma)
	return &Tonal{
		cache:    make(map[int]uint32),
		Hue:      hue,
		Chroma:   chroma,
		keyColor: keyColor,
	}
}

// Tone creates an ARGB color with HCT hue and chroma of this TonalPalette instance,
// and the provided HCT tone.
func (tp *Tonal) Tone(tone int) uint32 {
	if color, exists := tp.cache[tone]; exists {
		return color
	}

	var color uint32
	if tone == 99 && isYellow(tp.Hue) {
		color = averageArgb(tp.Tone(98), tp.Tone(100))
	} else {
		color = cam.From(tp.Hue, tp.Chroma, float64(tone)).ToInt()
	}

	tp.cache[tone] = color
	return color
}

// GetHct returns an HCT color with the palette's hue and chroma, and the given tone.
func (tp *Tonal) GetHct(tone float64) *cam.HCT {
	return cam.From(tp.Hue, tp.Chroma, tone)
}

// createKeyColor creates a key color from hue and chroma.
func createKeyColor(hue, chroma float64) *cam.HCT {
	startTone := 50.0
	smallestDeltaHct := cam.From(hue, chroma, startTone)
	smallestDelta := (smallestDeltaHct.Chroma - chroma)
	if smallestDelta < 0 {
		smallestDelta = -smallestDelta
	}

	for delta := 1.0; delta < 50.0; delta += 1.0 {
		// Darker
		if startTone-delta >= 0 {
			hctAdd := cam.From(hue, chroma, startTone-delta)
			hctAddDelta := (hctAdd.Chroma - chroma)
			if hctAddDelta < 0 {
				hctAddDelta = -hctAddDelta
			}
			if hctAddDelta < smallestDelta {
				smallestDelta = hctAddDelta
				smallestDeltaHct = hctAdd
			}
		}

		// Lighter
		if startTone+delta <= 100 {
			hctAdd := cam.From(hue, chroma, startTone+delta)
			hctAddDelta := (hctAdd.Chroma - chroma)
			if hctAddDelta < 0 {
				hctAddDelta = -hctAddDelta
			}
			if hctAddDelta < smallestDelta {
				smallestDelta = hctAddDelta
				smallestDeltaHct = hctAdd
			}
		}
	}

	return smallestDeltaHct
}

// isYellow checks if a hue is in the yellow range.
func isYellow(hue float64) bool {
	return hue >= 60 && hue <= 110
}

// averageArgb averages two ARGB colors.
func averageArgb(argb1, argb2 uint32) uint32 {
	red1 := utils.RedFromArgb(argb1)
	green1 := utils.GreenFromArgb(argb1)
	blue1 := utils.BlueFromArgb(argb1)
	red2 := utils.RedFromArgb(argb2)
	green2 := utils.GreenFromArgb(argb2)
	blue2 := utils.BlueFromArgb(argb2)

	red := (int(red1) + int(red2)) / 2
	green := (int(green1) + int(green2)) / 2
	blue := (int(blue1) + int(blue2)) / 2

	return utils.ArgbFromRgb(uint8(red), uint8(green), uint8(blue))
}

