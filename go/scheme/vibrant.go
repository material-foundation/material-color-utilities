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
	"math"

	"github.com/material-foundation/material-color-utilities/go/cam"
	"github.com/material-foundation/material-color-utilities/go/dynamiccolor"
	"github.com/material-foundation/material-color-utilities/go/palettes"
)

// Vibrant represents a vibrant scheme.
// A loud theme, colorfulness is maximum for Primary palette, increased for others.
type Vibrant struct {
	*dynamiccolor.DynamicScheme
}

// NewVibrant creates a new vibrant scheme.
func NewVibrant(sourceColorHct *cam.HCT, isDark bool, contrastLevel float64) *Vibrant {
	scheme := &Vibrant{
		DynamicScheme: &dynamiccolor.DynamicScheme{
			SourceColorArgb:       sourceColorHct.ToInt(),
			Variant:               dynamiccolor.VariantVibrant,
			ContrastLevel:         contrastLevel,
			IsDark:                isDark,
			PrimaryPalette:        palettes.TonalFromHueAndChroma(sourceColorHct.Hue, 200.0),
			SecondaryPalette:      palettes.TonalFromHueAndChroma(sourceColorHct.Hue, 24.0),
			TertiaryPalette:       palettes.TonalFromHueAndChroma(sourceColorHct.Hue+60.0, 32.0),
			NeutralPalette:        palettes.TonalFromHueAndChroma(sourceColorHct.Hue, 10.0),
			NeutralVariantPalette: palettes.TonalFromHueAndChroma(sourceColorHct.Hue, 12.0),
			ErrorPalette:          palettes.TonalFromHueAndChroma(25.0, 84.0),
		},
	}

	// Adjust palettes for maximum vibrancy
	scheme.PrimaryPalette = palettes.TonalFromHueAndChroma(sourceColorHct.Hue, math.Max(sourceColorHct.Chroma, 200.0))

	return scheme
}

// NewVibrantFromArgb creates a new vibrant scheme from an ARGB color.
func NewVibrantFromArgb(sourceColorArgb uint32, isDark bool, contrastLevel float64) *Vibrant {
	return NewVibrant(cam.HctFromInt(sourceColorArgb), isDark, contrastLevel)
}