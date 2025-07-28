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

package dynamiccolor

import (
	"github.com/material-foundation/material-color-utilities/go/cam"
	"github.com/material-foundation/material-color-utilities/go/palettes"
)

// NewDynamicScheme creates a new DynamicScheme from a source color.
func NewDynamicScheme(sourceColorArgb uint32, variant Variant, isDark bool, contrastLevel float64) *DynamicScheme {
	sourceHct := cam.HctFromInt(sourceColorArgb)
	
	return &DynamicScheme{
		SourceColorArgb:       sourceColorArgb,
		Variant:               variant,
		ContrastLevel:         contrastLevel,
		IsDark:                isDark,
		PrimaryPalette:        palettes.TonalFromHueAndChroma(sourceHct.Hue, sourceHct.Chroma),
		SecondaryPalette:      palettes.TonalFromHueAndChroma(sourceHct.Hue, sourceHct.Chroma/2),
		TertiaryPalette:       palettes.TonalFromHueAndChroma(sourceHct.Hue+60, sourceHct.Chroma/2),
		NeutralPalette:        palettes.TonalFromHueAndChroma(sourceHct.Hue, 4),
		NeutralVariantPalette: palettes.TonalFromHueAndChroma(sourceHct.Hue, 8),
		ErrorPalette:          palettes.TonalFromHueAndChroma(25, 84),
	}
}

