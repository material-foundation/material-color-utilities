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

// TonalSpot represents a tonal spot scheme.
// The default scheme. Builds a tonal color palette from a single color.
type TonalSpot struct {
	*dynamiccolor.DynamicScheme
}

// NewTonalSpot creates a new tonal spot scheme.
func NewTonalSpot(sourceColorHct *cam.HCT, isDark bool, contrastLevel float64) *TonalSpot {
	scheme := &TonalSpot{
		DynamicScheme: &dynamiccolor.DynamicScheme{
			SourceColorArgb:       sourceColorHct.ToInt(),
			Variant:               dynamiccolor.VariantTonalSpot,
			ContrastLevel:         contrastLevel,
			IsDark:                isDark,
			PrimaryPalette:        palettes.TonalFromHueAndChroma(sourceColorHct.Hue, 36.0),
			SecondaryPalette:      palettes.TonalFromHueAndChroma(sourceColorHct.Hue, 16.0),
			TertiaryPalette:       palettes.TonalFromHueAndChroma(sourceColorHct.Hue+60.0, 24.0),
			NeutralPalette:        palettes.TonalFromHueAndChroma(sourceColorHct.Hue, 6.0),
			NeutralVariantPalette: palettes.TonalFromHueAndChroma(sourceColorHct.Hue, 8.0),
			ErrorPalette:          palettes.TonalFromHueAndChroma(25.0, 84.0),
		},
	}
	return scheme
}

// NewTonalSpotFromArgb creates a new tonal spot scheme from an ARGB color.
func NewTonalSpotFromArgb(sourceColorArgb uint32, isDark bool, contrastLevel float64) *TonalSpot {
	return NewTonalSpot(cam.HctFromInt(sourceColorArgb), isDark, contrastLevel)
}