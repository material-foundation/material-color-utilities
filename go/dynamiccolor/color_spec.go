// Copyright 2021 Google LLC
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

// SpecVersion represents the Material Design specification version.
type SpecVersion int

const (
	Spec2021 SpecVersion = iota
	Spec2025
)

// Platform represents the target platform for color calculations.
type Platform int

const (
	PlatformPhone Platform = iota
	PlatformWatch
)

// ColorSpec defines all the necessary methods that could be different between specs.
type ColorSpec interface {
	////////////////////////////////////////////////////////////////
	// Main Palettes                                              //
	////////////////////////////////////////////////////////////////

	PrimaryPaletteKeyColor() *DynamicColor
	SecondaryPaletteKeyColor() *DynamicColor
	TertiaryPaletteKeyColor() *DynamicColor
	NeutralPaletteKeyColor() *DynamicColor
	NeutralVariantPaletteKeyColor() *DynamicColor
	ErrorPaletteKeyColor() *DynamicColor

	////////////////////////////////////////////////////////////////
	// Surfaces [S]                                               //
	////////////////////////////////////////////////////////////////

	Background() *DynamicColor
	OnBackground() *DynamicColor
	Surface() *DynamicColor
	SurfaceDim() *DynamicColor
	SurfaceBright() *DynamicColor
	SurfaceContainerLowest() *DynamicColor
	SurfaceContainerLow() *DynamicColor
	SurfaceContainer() *DynamicColor
	SurfaceContainerHigh() *DynamicColor
	SurfaceContainerHighest() *DynamicColor
	OnSurface() *DynamicColor
	SurfaceVariant() *DynamicColor
	OnSurfaceVariant() *DynamicColor
	InverseSurface() *DynamicColor
	InverseOnSurface() *DynamicColor
	Outline() *DynamicColor
	OutlineVariant() *DynamicColor
	Shadow() *DynamicColor
	Scrim() *DynamicColor
	SurfaceTint() *DynamicColor

	////////////////////////////////////////////////////////////////
	// Primaries [P]                                              //
	////////////////////////////////////////////////////////////////

	Primary() *DynamicColor
	PrimaryDim() *DynamicColor // Can be nil for 2021 spec
	OnPrimary() *DynamicColor
	PrimaryContainer() *DynamicColor
	OnPrimaryContainer() *DynamicColor
	InversePrimary() *DynamicColor

	////////////////////////////////////////////////////////////////
	// Secondaries [Q]                                            //
	////////////////////////////////////////////////////////////////

	Secondary() *DynamicColor
	SecondaryDim() *DynamicColor // Can be nil for 2021 spec
	OnSecondary() *DynamicColor
	SecondaryContainer() *DynamicColor
	OnSecondaryContainer() *DynamicColor

	////////////////////////////////////////////////////////////////
	// Tertiaries [T]                                             //
	////////////////////////////////////////////////////////////////

	Tertiary() *DynamicColor
	TertiaryDim() *DynamicColor // Can be nil for 2021 spec
	OnTertiary() *DynamicColor
	TertiaryContainer() *DynamicColor
	OnTertiaryContainer() *DynamicColor

	////////////////////////////////////////////////////////////////
	// Errors [E]                                                 //
	////////////////////////////////////////////////////////////////

	Error() *DynamicColor
	ErrorDim() *DynamicColor // Can be nil for 2021 spec
	OnError() *DynamicColor
	ErrorContainer() *DynamicColor
	OnErrorContainer() *DynamicColor

	////////////////////////////////////////////////////////////////
	// Primary Fixed Colors [PF]                                  //
	////////////////////////////////////////////////////////////////

	PrimaryFixed() *DynamicColor
	PrimaryFixedDim() *DynamicColor
	OnPrimaryFixed() *DynamicColor
	OnPrimaryFixedVariant() *DynamicColor

	////////////////////////////////////////////////////////////////
	// Secondary Fixed Colors [QF]                                //
	////////////////////////////////////////////////////////////////

	SecondaryFixed() *DynamicColor
	SecondaryFixedDim() *DynamicColor
	OnSecondaryFixed() *DynamicColor
	OnSecondaryFixedVariant() *DynamicColor

	////////////////////////////////////////////////////////////////
	// Tertiary Fixed Colors [TF]                                 //
	////////////////////////////////////////////////////////////////

	TertiaryFixed() *DynamicColor
	TertiaryFixedDim() *DynamicColor
	OnTertiaryFixed() *DynamicColor
	OnTertiaryFixedVariant() *DynamicColor

	//////////////////////////////////////////////////////////////////
	// Android-only Colors                                          //
	//////////////////////////////////////////////////////////////////

	ControlActivated() *DynamicColor
	ControlNormal() *DynamicColor
	ControlHighlight() *DynamicColor
	TextPrimaryInverse() *DynamicColor
	TextSecondaryAndTertiaryInverse() *DynamicColor
	TextPrimaryInverseDisableOnly() *DynamicColor
	TextSecondaryAndTertiaryInverseDisabled() *DynamicColor
	TextHintInverse() *DynamicColor

	////////////////////////////////////////////////////////////////
	// Other                                                      //
	////////////////////////////////////////////////////////////////

	HighestSurface(s *DynamicScheme) *DynamicColor

	/////////////////////////////////////////////////////////////////
	// Color value calculations                                    //
	/////////////////////////////////////////////////////////////////

	Hct(scheme *DynamicScheme, color *DynamicColor) *cam.HCT
	Tone(scheme *DynamicScheme, color *DynamicColor) float64

	//////////////////////////////////////////////////////////////////
	// Scheme Palettes                                              //
	//////////////////////////////////////////////////////////////////

	PrimaryPalette(variant Variant, sourceColorHct *cam.HCT, isDark bool, platform Platform, contrastLevel float64) *palettes.Tonal
	SecondaryPalette(variant Variant, sourceColorHct *cam.HCT, isDark bool, platform Platform, contrastLevel float64) *palettes.Tonal
	TertiaryPalette(variant Variant, sourceColorHct *cam.HCT, isDark bool, platform Platform, contrastLevel float64) *palettes.Tonal
	NeutralPalette(variant Variant, sourceColorHct *cam.HCT, isDark bool, platform Platform, contrastLevel float64) *palettes.Tonal
	NeutralVariantPalette(variant Variant, sourceColorHct *cam.HCT, isDark bool, platform Platform, contrastLevel float64) *palettes.Tonal
	ErrorPalette(variant Variant, sourceColorHct *cam.HCT, isDark bool, platform Platform, contrastLevel float64) *palettes.Tonal
}

////////////////////////////////////////////////////////////////
// Color Spec Utilities                                       //
////////////////////////////////////////////////////////////////

// ColorSpecs is a utility to get the correct color spec for a given spec version.
type ColorSpecs struct{}

var (
	spec2021 ColorSpec = &ColorSpec2021{}
	spec2025 ColorSpec = NewColorSpec2025()
)

// DefaultColorSpec returns the default color spec (2021).
func DefaultColorSpec() ColorSpec {
	return ByVersion(Spec2021)
}

// ByVersion returns the color spec for the specified version.
func ByVersion(specVersion SpecVersion) ColorSpec {
	return ByVersionWithFidelity(specVersion, false)
}

// ByVersionWithFidelity returns the color spec for the specified version and fidelity.
func ByVersionWithFidelity(specVersion SpecVersion, isExtendedFidelity bool) ColorSpec {
	if specVersion == Spec2025 {
		return spec2025
	}
	return spec2021
}

////////////////////////////////////////////////////////////////
// Helper Functions                                           //
////////////////////////////////////////////////////////////////

// helper for palette + key color tone
func dynamicColorKeyColor(name string, paletteFn func(*DynamicScheme) *palettes.Tonal) *DynamicColor {
	return &DynamicColor{
		Name:    name,
		Palette: paletteFn,
		Tone: func(s *DynamicScheme) float64 {
			return paletteFn(s).KeyColor.Tone
		},
	}
}

// helper for palette + fixed tone (light/dark switch)
func dynamicColorFixedTone(name string, paletteFn func(*DynamicScheme) *palettes.Tonal, lightTone, darkTone float64) *DynamicColor {
	return &DynamicColor{
		Name:    name,
		Palette: paletteFn,
		Tone: func(s *DynamicScheme) float64 {
			if s.IsDark {
				return darkTone
			}
			return lightTone
		},
	}
}