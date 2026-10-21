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

// Monochrome represents a monochrome scheme.
// A grayscale scheme, no colors except black / white / gray.
type Monochrome struct {
	*dynamiccolor.DynamicScheme
}

// NewMonochrome creates a new monochrome scheme.
func NewMonochrome(sourceColorHct *cam.HCT, isDark bool, contrastLevel float64) *Monochrome {
	scheme := &Monochrome{
		DynamicScheme: &dynamiccolor.DynamicScheme{
			SourceColorArgb:       sourceColorHct.ToInt(),
			Variant:               dynamiccolor.VariantMonochrome,
			ContrastLevel:         contrastLevel,
			IsDark:                isDark,
			PrimaryPalette:        palettes.TonalFromHueAndChroma(sourceColorHct.Hue, 0.0),
			SecondaryPalette:      palettes.TonalFromHueAndChroma(sourceColorHct.Hue, 0.0),
			TertiaryPalette:       palettes.TonalFromHueAndChroma(sourceColorHct.Hue, 0.0),
			NeutralPalette:        palettes.TonalFromHueAndChroma(sourceColorHct.Hue, 0.0),
			NeutralVariantPalette: palettes.TonalFromHueAndChroma(sourceColorHct.Hue, 0.0),
			ErrorPalette:          palettes.TonalFromHueAndChroma(25.0, 84.0),
		},
	}
	return scheme
}

// NewMonochromeFromArgb creates a new monochrome scheme from an ARGB color.
func NewMonochromeFromArgb(sourceColorArgb uint32, isDark bool, contrastLevel float64) *Monochrome {
	return NewMonochrome(cam.HctFromInt(sourceColorArgb), isDark, contrastLevel)
}