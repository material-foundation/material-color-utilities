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
	"github.com/material-foundation/material-color-utilities/go/temperature"
)

// Fidelity represents a fidelity scheme.
// A scheme that places the source color in Scheme.primaryContainer.
//
// Primary Container is the source color, adjusted for color relativity.
// It maintains constant appearance in light mode and dark mode.
// This adds ~5 tone in light mode, and subtracts ~5 tone in dark mode.
//
// Tertiary Container is the complement to the source color, using TemperatureCache.
// It also maintains constant appearance.
type Fidelity struct {
	*dynamiccolor.DynamicScheme
}

// NewFidelity creates a new fidelity scheme.
func NewFidelity(sourceColorHct *cam.HCT, isDark bool, contrastLevel float64) *Fidelity {
	// Calculate complement using temperature cache
	tempCache := temperature.NewCache(sourceColorHct)
	complement := tempCache.Complement()

	scheme := &Fidelity{
		DynamicScheme: &dynamiccolor.DynamicScheme{
			SourceColorArgb:       sourceColorHct.ToInt(),
			Variant:               dynamiccolor.VariantFidelity,
			ContrastLevel:         contrastLevel,
			IsDark:                isDark,
			PrimaryPalette:        palettes.TonalFromHueAndChroma(sourceColorHct.Hue, sourceColorHct.Chroma),
			SecondaryPalette:      palettes.TonalFromHueAndChroma(sourceColorHct.Hue, sourceColorHct.Chroma-32.0),
			TertiaryPalette:       palettes.TonalFromHueAndChroma(complement.Hue, complement.Chroma),
			NeutralPalette:        palettes.TonalFromHueAndChroma(sourceColorHct.Hue, sourceColorHct.Chroma/8.0),
			NeutralVariantPalette: palettes.TonalFromHueAndChroma(sourceColorHct.Hue, (sourceColorHct.Chroma/8.0)+4.0),
			ErrorPalette:          palettes.TonalFromHueAndChroma(25.0, 84.0),
		},
	}
	return scheme
}

// NewFidelityFromArgb creates a new fidelity scheme from an ARGB color.
func NewFidelityFromArgb(sourceColorArgb uint32, isDark bool, contrastLevel float64) *Fidelity {
	return NewFidelity(cam.HctFromInt(sourceColorArgb), isDark, contrastLevel)
}