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

package palettes

import (
	"math"

	"github.com/material-foundation/material-color-utilities/go/cam"
)

// Core is an intermediate concept between the key color for a UI theme,
// and a full color scheme. 5 sets of tones are generated, all except one use
// the same hue as the key color, and all vary in chroma.
type Core struct {
	A1    *Tonal // Primary palette
	A2    *Tonal // Secondary palette
	A3    *Tonal // Tertiary palette
	N1    *Tonal // Neutral palette
	N2    *Tonal // Neutral variant palette
	Error *Tonal // Error palette
}

// Of creates key tones from a color.
func Of(argb uint32) *Core {
	return newCorePalette(argb, false)
}

// ContentOf creates content key tones from a color.
func ContentOf(argb uint32) *Core {
	return newCorePalette(argb, true)
}

// newCorePalette creates a new Core from an ARGB color.
func newCorePalette(argb uint32, isContent bool) *Core {
	hct := cam.HctFromInt(argb)
	hue := hct.Hue
	chroma := hct.Chroma

	var a1, a2, a3, n1, n2 *Tonal

	if isContent {
		a1 = TonalFromHueAndChroma(hue, chroma)
		a2 = TonalFromHueAndChroma(hue, chroma/3.0)
		a3 = TonalFromHueAndChroma(hue+60.0, chroma/2.0)
		n1 = TonalFromHueAndChroma(hue, math.Min(chroma/12.0, 4.0))
		n2 = TonalFromHueAndChroma(hue, math.Min(chroma/6.0, 8.0))
	} else {
		a1 = TonalFromHueAndChroma(hue, math.Max(48.0, chroma))
		a2 = TonalFromHueAndChroma(hue, 16.0)
		a3 = TonalFromHueAndChroma(hue+60.0, 24.0)
		n1 = TonalFromHueAndChroma(hue, 4.0)
		n2 = TonalFromHueAndChroma(hue, 8.0)
	}

	error := TonalFromHueAndChroma(25.0, 84.0)

	return &Core{
		A1:    a1,
		A2:    a2,
		A3:    a3,
		N1:    n1,
		N2:    n2,
		Error: error,
	}
}
