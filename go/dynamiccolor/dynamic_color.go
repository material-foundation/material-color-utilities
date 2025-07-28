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
	"math"

	"github.com/material-foundation/material-color-utilities/go/cam"
	"github.com/material-foundation/material-color-utilities/go/contrast"
	"github.com/material-foundation/material-color-utilities/go/palettes"
	"github.com/material-foundation/material-color-utilities/go/utils"
)

// DynamicScheme represents a color scheme state (light/dark mode, contrast level, etc.)
type DynamicScheme struct {
	SourceColorArgb       uint32
	Variant               Variant
	ContrastLevel         float64
	IsDark                bool
	PrimaryPalette        *palettes.Tonal
	SecondaryPalette      *palettes.Tonal
	TertiaryPalette       *palettes.Tonal
	NeutralPalette        *palettes.Tonal
	NeutralVariantPalette *palettes.Tonal
	ErrorPalette          *palettes.Tonal
}

// DynamicColor represents a color that adjusts itself based on UI state.
//
// This color automatically adjusts to accommodate a desired contrast level, or other adjustments
// such as differing in light mode versus dark mode, or what the theme is, or what the color that
// produced the theme is, etc.
//
// Colors without backgrounds do not change tone when contrast changes. Colors with backgrounds
// become closer to their background as contrast lowers, and further when contrast increases.
type DynamicColor struct {
	Name             string
	Palette          func(*DynamicScheme) *palettes.Tonal
	Tone             func(*DynamicScheme) float64
	IsBackground     bool
	ChromaMultiplier func(*DynamicScheme) float64
	Background       func(*DynamicScheme) *DynamicColor
	SecondBackground func(*DynamicScheme) *DynamicColor
	ContrastCurve    func(*DynamicScheme) *ContrastCurve
	ToneDeltaPair    func(*DynamicScheme) *ToneDeltaPair
	Opacity          func(*DynamicScheme) float64

	// Cache for computed HCT values
	hctCache map[*DynamicScheme]*cam.HCT
}

// NewDynamicColor creates a new DynamicColor with required parameters.
func NewDynamicColor(
	name string,
	palette func(*DynamicScheme) *palettes.Tonal,
	tone func(*DynamicScheme) float64,
	isBackground bool,
) *DynamicColor {
	return &DynamicColor{
		Name:             name,
		Palette:          palette,
		Tone:             tone,
		IsBackground:     isBackground,
		ChromaMultiplier: func(*DynamicScheme) float64 { return 1.0 },
		Background:       func(*DynamicScheme) *DynamicColor { return nil },
		SecondBackground: func(*DynamicScheme) *DynamicColor { return nil },
		ContrastCurve:    func(*DynamicScheme) *ContrastCurve { return NewContrastCurve(3.0, 4.5, 7.0, 11.0) },
		ToneDeltaPair:    func(*DynamicScheme) *ToneDeltaPair { return nil },
		Opacity:          func(*DynamicScheme) float64 { return 1.0 },
		hctCache:         make(map[*DynamicScheme]*cam.HCT),
	}
}

// WithBackground sets the background color function.
func (dc *DynamicColor) WithBackground(background func(*DynamicScheme) *DynamicColor) *DynamicColor {
	dc.Background = background
	return dc
}

// WithContrastCurve sets the contrast curve function.
func (dc *DynamicColor) WithContrastCurve(contrastCurve func(*DynamicScheme) *ContrastCurve) *DynamicColor {
	dc.ContrastCurve = contrastCurve
	return dc
}

// WithChromaMultiplier sets the chroma multiplier function.
func (dc *DynamicColor) WithChromaMultiplier(chromaMultiplier func(*DynamicScheme) float64) *DynamicColor {
	dc.ChromaMultiplier = chromaMultiplier
	return dc
}

// WithToneDeltaPair sets the tone delta pair function.
func (dc *DynamicColor) WithToneDeltaPair(toneDeltaPair func(*DynamicScheme) *ToneDeltaPair) *DynamicColor {
	dc.ToneDeltaPair = toneDeltaPair
	return dc
}

// GetArgb returns the ARGB color value for this dynamic color in the given scheme.
func (dc *DynamicColor) GetArgb(scheme *DynamicScheme) uint32 {
	argb := dc.GetHct(scheme).ToInt()

	// Apply opacity if less than 1.0
	if dc.Opacity != nil {
		opacity := dc.Opacity(scheme)
		if opacity < 1.0 {
			alpha := uint32(math.Round(opacity * 255))
			return (alpha << 24) | (argb & 0x00FFFFFF)
		}
	}

	return argb
}

// GetHct returns the HCT color value for this dynamic color in the given scheme.
func (dc *DynamicColor) GetHct(scheme *DynamicScheme) *cam.HCT {
	// Check cache first
	if cached, exists := dc.hctCache[scheme]; exists {
		return cached
	}

	// Calculate tone considering all constraints
	tone := dc.calculateTone(scheme)

	// Get palette and create HCT
	palette := dc.Palette(scheme)
	chroma := palette.Chroma * dc.ChromaMultiplier(scheme)
	hue := palette.Hue

	hct := cam.From(hue, chroma, tone)

	// Cache the result
	dc.hctCache[scheme] = hct

	return hct
}

// calculateTone calculates the appropriate tone considering background, contrast, and delta constraints.
func (dc *DynamicColor) calculateTone(scheme *DynamicScheme) float64 {
	baseTone := dc.Tone(scheme)

	// If no background, return base tone
	background := dc.Background(scheme)
	if background == nil {
		return baseTone
	}

	// Calculate background tone
	backgroundTone := background.calculateTone(scheme)

	// Apply contrast curve adjustments
	contrastCurve := dc.ContrastCurve(scheme)
	desiredRatio := contrastCurve.LevelNormalized(scheme.ContrastLevel)

	// Calculate tone that achieves desired contrast
	adjustedTone := dc.calculateToneForContrast(baseTone, backgroundTone, desiredRatio)

	// Apply tone delta pair constraints if they exist
	toneDeltaPair := dc.ToneDeltaPair(scheme)
	if toneDeltaPair != nil {
		adjustedTone = dc.applyToneDeltaConstraint(adjustedTone, toneDeltaPair, scheme)
	}

	return utils.ClampFloat(adjustedTone/100.0) * 100.0
}

// calculateToneForContrast calculates a tone that achieves the desired contrast ratio.
func (dc *DynamicColor) calculateToneForContrast(baseTone, backgroundTone, desiredRatio float64) float64 {
	// If we need higher contrast, move away from background
	if desiredRatio > 1.0 {
		if backgroundTone > 50 {
			// Background is light, make foreground darker
			return contrast.Darker(backgroundTone, desiredRatio)
		} else {
			// Background is dark, make foreground lighter
			return contrast.Lighter(backgroundTone, desiredRatio)
		}
	}

	return baseTone
}

// applyToneDeltaConstraint applies tone delta pair constraints.
func (dc *DynamicColor) applyToneDeltaConstraint(tone float64, deltaPair *ToneDeltaPair, scheme *DynamicScheme) float64 {
	var otherTone float64

	// Determine which role this color plays and get the other tone
	if deltaPair.RoleA == dc {
		otherTone = deltaPair.RoleB.calculateTone(scheme)
	} else if deltaPair.RoleB == dc {
		otherTone = deltaPair.RoleA.calculateTone(scheme)
	} else {
		return tone // This color is not part of the delta pair
	}

	delta := math.Abs(tone - otherTone)

	// Apply polarity constraints
	switch deltaPair.Polarity {
	case TonePolarityDarker:
		if tone > otherTone {
			return otherTone - deltaPair.Delta
		}
	case TonePolarityLighter:
		if tone < otherTone {
			return otherTone + deltaPair.Delta
		}
	case TonePolarityRelativeDarker:
		// Implementation depends on light/dark mode
		return tone
	case TonePolarityRelativeLighter:
		// Implementation depends on light/dark mode
		return tone
	}

	// Ensure minimum delta is maintained
	if delta < deltaPair.Delta {
		if tone > otherTone {
			return otherTone + deltaPair.Delta
		} else {
			return otherTone - deltaPair.Delta
		}
	}

	return tone
}

// FromPalette creates a DynamicColor from a palette and tone.
func FromPalette(name string, palette func(*DynamicScheme) *palettes.Tonal, tone func(*DynamicScheme) float64) *DynamicColor {
	return NewDynamicColor(name, palette, tone, false)
}

// FromArgb creates a DynamicColor from a fixed ARGB color.
func FromArgb(name string, argb uint32) *DynamicColor {
	hct := cam.HctFromInt(argb)
	return NewDynamicColor(
		name,
		func(*DynamicScheme) *palettes.Tonal {
			return palettes.TonalFromHueAndChroma(hct.Hue, hct.Chroma)
		},
		func(*DynamicScheme) float64 { return hct.Tone },
		false,
	)
}
