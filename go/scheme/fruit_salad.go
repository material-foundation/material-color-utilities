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

// FruitSalad represents a fruit salad scheme.
// A playful theme - the source color's hue does not appear in the theme.
type FruitSalad struct {
	*dynamiccolor.DynamicScheme
}

// NewFruitSalad creates a new fruit salad scheme.
func NewFruitSalad(sourceColorHct *cam.HCT, isDark bool, contrastLevel float64) *FruitSalad {
	hue := sourceColorHct.Hue

	scheme := &FruitSalad{
		DynamicScheme: &dynamiccolor.DynamicScheme{
			SourceColorArgb:       sourceColorHct.ToInt(),
			Variant:               dynamiccolor.VariantFruitSalad,
			ContrastLevel:         contrastLevel,
			IsDark:                isDark,
			PrimaryPalette:        palettes.TonalFromHueAndChroma(utils.SanitizeDegreesDouble(hue-50.0), 48.0),
			SecondaryPalette:      palettes.TonalFromHueAndChroma(utils.SanitizeDegreesDouble(hue-50.0), 36.0),
			TertiaryPalette:       palettes.TonalFromHueAndChroma(hue, 36.0),
			NeutralPalette:        palettes.TonalFromHueAndChroma(hue, 10.0),
			NeutralVariantPalette: palettes.TonalFromHueAndChroma(hue, 16.0),
			ErrorPalette:          palettes.TonalFromHueAndChroma(25.0, 84.0),
		},
	}

	// Adjust palettes to avoid source color while maintaining vibrancy
	scheme.PrimaryPalette = palettes.TonalFromHueAndChroma(utils.SanitizeDegreesDouble(hue-50.0), 48.0)
	scheme.SecondaryPalette = palettes.TonalFromHueAndChroma(utils.SanitizeDegreesDouble(hue-50.0), 36.0)

	return scheme
}

// NewFruitSaladFromArgb creates a new fruit salad scheme from an ARGB color.
func NewFruitSaladFromArgb(sourceColorArgb uint32, isDark bool, contrastLevel float64) *FruitSalad {
	return NewFruitSalad(cam.HctFromInt(sourceColorArgb), isDark, contrastLevel)
}