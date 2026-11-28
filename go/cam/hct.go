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

package cam

import (
	"math"

	"github.com/material-foundation/material-color-utilities/go/utils"
)

// HCT represents a color in the HCT (Hue, Chroma, Tone) color space.
// HCT is a color system built using CAM16 hue and chroma, and L* from L*a*b*.
//
// Using L* creates a link between the color system, contrast, and thus accessibility.
// Contrast ratio depends on relative luminance, or Y in the XYZ color space.
// L*, or perceptual luminance can be calculated from Y.
//
// Unlike Y, L* is linear to human perception, allowing trivial creation of
// accurate color tones.
//
// Unlike contrast ratio, measuring contrast in L* is linear, and simple to
// calculate. A difference of 40 in HCT tone guarantees a contrast ratio >= 3.0,
// and a difference of 50 guarantees a contrast ratio >= 4.5.
type HCT struct {
	Hue    float64 // 0 <= hue < 360; invalid values are corrected
	Chroma float64 // 0 <= chroma < ?; Informally, colorfulness
	Tone   float64 // 0 <= tone <= 100; invalid values are corrected
	argb   uint32  // Internal ARGB representation
}

// From creates an HCT color from hue, chroma, and tone.
func From(hue, chroma, tone float64) *HCT {
	argb := SolveToInt(hue, chroma, tone)
	// The HCT values should represent what's actually achievable,
	// so we need to get the actual values from the ARGB result
	return HctFromInt(argb)
}

// HctFromInt creates an HCT color from an ARGB representation.
func HctFromInt(argb uint32) *HCT {
	cam := FromInt(argb)
	tone := utils.LstarFromArgb(argb)
	return &HCT{
		Hue:    cam.Hue,
		Chroma: cam.Chroma,
		Tone:   tone,
		argb:   argb,
	}
}

// ToInt returns the ARGB representation of this HCT color.
func (h *HCT) ToInt() uint32 {
	return h.argb
}

// SetHue sets the hue of this color. Chroma may decrease because chroma has
// a different maximum for any given hue and tone.
func (h *HCT) SetHue(newHue float64) {
	h.Hue = utils.SanitizeDegreesDouble(newHue)
	h.argb = SolveToInt(h.Hue, h.Chroma, h.Tone)
	h.updateFromArgb()
}

// SetChroma sets the chroma of this color. Chroma may decrease because chroma
// has a different maximum for any given hue and tone.
func (h *HCT) SetChroma(newChroma float64) {
	h.Chroma = math.Max(0, newChroma)
	h.argb = SolveToInt(h.Hue, h.Chroma, h.Tone)
	h.updateFromArgb()
}

// SetTone sets the tone of this color. Chroma may decrease because chroma has
// a different maximum for any given hue and tone.
func (h *HCT) SetTone(newTone float64) {
	h.Tone = utils.ClampFloat(newTone/100.0) * 100.0
	h.argb = SolveToInt(h.Hue, h.Chroma, h.Tone)
	h.updateFromArgb()
}

// updateFromArgb updates the HCT values based on the current ARGB value.
func (h *HCT) updateFromArgb() {
	cam := FromInt(h.argb)
	h.Hue = cam.Hue
	h.Chroma = cam.Chroma
	h.Tone = utils.LstarFromArgb(h.argb)
}
