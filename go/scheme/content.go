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
	"github.com/material-foundation/material-color-utilities/go/dislike"
	"github.com/material-foundation/material-color-utilities/go/dynamiccolor"
	"github.com/material-foundation/material-color-utilities/go/palettes"
	"github.com/material-foundation/material-color-utilities/go/temperature"
)

// Content represents a content-based scheme.
// A scheme that places the source color in Scheme.primaryContainer.
//
// Primary Container is the source color, adjusted for color relativity.
// It maintains constant appearance in light mode and dark mode.
// This adds ~5 tone in light mode, and subtracts ~5 tone in dark mode.
//
// Tertiary Container is an analogous color, specifically, the analog of a
// color wheel divided into 6, and the precise analog is the one found by
// increasing hue. It also maintains constant appearance.
type Content struct {
	*dynamiccolor.DynamicScheme
}

// NewContent creates a new content scheme.
func NewContent(sourceColorHct *cam.HCT, isDark bool, contrastLevel float64) *Content {
	// Fix the source color if it's disliked
	adjustedSourceColor := dislike.FixIfDisliked(sourceColorHct)

	// Calculate analogous color using temperature cache
	tempCache := temperature.NewCache(adjustedSourceColor)
	analogous := tempCache.AnalogousColorsDefault()
	var tertiaryHct *cam.HCT
	if len(analogous) >= 3 {
		tertiaryHct = analogous[2] // Third analogous color
	} else {
		// Fallback if not enough analogous colors
		tertiaryHct = cam.From(adjustedSourceColor.Hue+60.0, adjustedSourceColor.Chroma, 50.0)
	}

	scheme := &Content{
		DynamicScheme: &dynamiccolor.DynamicScheme{
			SourceColorArgb:       sourceColorHct.ToInt(),
			Variant:               dynamiccolor.VariantContent,
			ContrastLevel:         contrastLevel,
			IsDark:                isDark,
			PrimaryPalette:        palettes.TonalFromHueAndChroma(adjustedSourceColor.Hue, adjustedSourceColor.Chroma),
			SecondaryPalette:      palettes.TonalFromHueAndChroma(adjustedSourceColor.Hue, adjustedSourceColor.Chroma-32.0),
			TertiaryPalette:       palettes.TonalFromHueAndChroma(tertiaryHct.Hue, tertiaryHct.Chroma),
			NeutralPalette:        palettes.TonalFromHueAndChroma(adjustedSourceColor.Hue, adjustedSourceColor.Chroma/8.0),
			NeutralVariantPalette: palettes.TonalFromHueAndChroma(adjustedSourceColor.Hue, (adjustedSourceColor.Chroma/8.0)+4.0),
			ErrorPalette:          palettes.TonalFromHueAndChroma(25.0, 84.0),
		},
	}
	return scheme
}

// NewContentFromArgb creates a new content scheme from an ARGB color.
func NewContentFromArgb(sourceColorArgb uint32, isDark bool, contrastLevel float64) *Content {
	return NewContent(cam.HctFromInt(sourceColorArgb), isDark, contrastLevel)
}