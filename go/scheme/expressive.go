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
	"github.com/material-foundation/material-color-utilities/go/utils"
)

// Expressive represents an expressive scheme.
// A playful theme - the source color's hue does not appear in the theme.
type Expressive struct {
	*dynamiccolor.DynamicScheme
}

// NewExpressive creates a new expressive scheme.
func NewExpressive(sourceColorHct *cam.HCT, isDark bool, contrastLevel float64) *Expressive {
	hue := sourceColorHct.Hue
	chroma := sourceColorHct.Chroma

	scheme := &Expressive{
		DynamicScheme: &dynamiccolor.DynamicScheme{
			SourceColorArgb:       sourceColorHct.ToInt(),
			Variant:               dynamiccolor.VariantExpressive,
			ContrastLevel:         contrastLevel,
			IsDark:                isDark,
			PrimaryPalette:        palettes.TonalFromHueAndChroma(utils.SanitizeDegreesDouble(hue+240.0), 40.0),
			SecondaryPalette:      palettes.TonalFromHueAndChroma(utils.SanitizeDegreesDouble(hue+15.0), chroma-15.0),
			TertiaryPalette:       palettes.TonalFromHueAndChroma(utils.SanitizeDegreesDouble(hue+15.0), math.Max(chroma-15.0, 0.0)),
			NeutralPalette:        palettes.TonalFromHueAndChroma(hue+15.0, (chroma-15.0)*0.5),
			NeutralVariantPalette: palettes.TonalFromHueAndChroma(hue+15.0, (chroma-15.0)*0.6),
			ErrorPalette:          palettes.TonalFromHueAndChroma(25.0, 84.0),
		},
	}
	return scheme
}

// NewExpressiveFromArgb creates a new expressive scheme from an ARGB color.
func NewExpressiveFromArgb(sourceColorArgb uint32, isDark bool, contrastLevel float64) *Expressive {
	return NewExpressive(cam.HctFromInt(sourceColorArgb), isDark, contrastLevel)
}