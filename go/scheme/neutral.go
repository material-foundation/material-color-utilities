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

package scheme

import (
	"github.com/material-foundation/material-color-utilities/go/cam"
	"github.com/material-foundation/material-color-utilities/go/dynamiccolor"
	"github.com/material-foundation/material-color-utilities/go/palettes"
)

// Neutral represents a neutral scheme.
// A scheme that places the source color in Scheme.primaryContainer.
//
// Primary Container is the source color, adjusted for color relativity.
// It maintains constant appearance in light mode and dark mode.
// This adds ~5 tone in light mode, and subtracts ~5 tone in dark mode.
//
// Tertiary Container is an analogous color, specifically, the analog of a
// color wheel divided into 6, and the precise analog is the one found by
// increasing hue. It also maintains constant appearance.
type Neutral struct {
	*dynamiccolor.DynamicScheme
}

// NewNeutral creates a new neutral scheme.
func NewNeutral(sourceColorHct *cam.HCT, isDark bool, contrastLevel float64) *Neutral {
	scheme := &Neutral{
		DynamicScheme: &dynamiccolor.DynamicScheme{
			SourceColorArgb:       sourceColorHct.ToInt(),
			Variant:               dynamiccolor.VariantNeutral,
			ContrastLevel:         contrastLevel,
			IsDark:                isDark,
			PrimaryPalette:        palettes.TonalFromHueAndChroma(sourceColorHct.Hue, 12.0),
			SecondaryPalette:      palettes.TonalFromHueAndChroma(sourceColorHct.Hue, 8.0),
			TertiaryPalette:       palettes.TonalFromHueAndChroma(sourceColorHct.Hue+60.0, 16.0),
			NeutralPalette:        palettes.TonalFromHueAndChroma(sourceColorHct.Hue, 2.0),
			NeutralVariantPalette: palettes.TonalFromHueAndChroma(sourceColorHct.Hue, 2.0),
			ErrorPalette:          palettes.TonalFromHueAndChroma(25.0, 84.0),
		},
	}
	return scheme
}

// NewNeutralFromArgb creates a new neutral scheme from an ARGB color.
func NewNeutralFromArgb(sourceColorArgb uint32, isDark bool, contrastLevel float64) *Neutral {
	return NewNeutral(cam.HctFromInt(sourceColorArgb), isDark, contrastLevel)
}