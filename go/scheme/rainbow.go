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
	"github.com/material-foundation/material-color-utilities/go/utils"
)

// Rainbow represents a rainbow scheme.
// A playful theme - the source color's hue does not appear in the theme.
type Rainbow struct {
	*dynamiccolor.DynamicScheme
}

// NewRainbow creates a new rainbow scheme.
func NewRainbow(sourceColorHct *cam.HCT, isDark bool, contrastLevel float64) *Rainbow {
	hue := sourceColorHct.Hue

	scheme := &Rainbow{
		DynamicScheme: &dynamiccolor.DynamicScheme{
			SourceColorArgb:       sourceColorHct.ToInt(),
			Variant:               dynamiccolor.VariantRainbow,
			ContrastLevel:         contrastLevel,
			IsDark:                isDark,
			PrimaryPalette:        palettes.TonalFromHueAndChroma(hue, 48.0),
			SecondaryPalette:      palettes.TonalFromHueAndChroma(utils.SanitizeDegreesDouble(hue+60.0), 16.0),
			TertiaryPalette:       palettes.TonalFromHueAndChroma(utils.SanitizeDegreesDouble(hue+120.0), 24.0),
			NeutralPalette:        palettes.TonalFromHueAndChroma(hue, 0.0),
			NeutralVariantPalette: palettes.TonalFromHueAndChroma(hue, 0.0),
			ErrorPalette:          palettes.TonalFromHueAndChroma(25.0, 84.0),
		},
	}

	// Ensure high chroma for vibrant rainbow effect
	scheme.PrimaryPalette = palettes.TonalFromHueAndChroma(hue, 48.0)
	scheme.SecondaryPalette = palettes.TonalFromHueAndChroma(utils.SanitizeDegreesDouble(hue+60.0), 16.0)
	scheme.TertiaryPalette = palettes.TonalFromHueAndChroma(utils.SanitizeDegreesDouble(hue+120.0), 24.0)

	return scheme
}

// NewRainbowFromArgb creates a new rainbow scheme from an ARGB color.
func NewRainbowFromArgb(sourceColorArgb uint32, isDark bool, contrastLevel float64) *Rainbow {
	return NewRainbow(cam.HctFromInt(sourceColorArgb), isDark, contrastLevel)
}