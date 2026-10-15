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
	"math"

	"github.com/material-foundation/material-color-utilities/go/cam"
	"github.com/material-foundation/material-color-utilities/go/palettes"
)

// ColorSpec2025 implements ColorSpec for the 2025 Material Design specification.
// This implementation includes enhancements like Dim colors, improved contrast,
// and platform-specific adjustments.
type ColorSpec2025 struct {
	// Embed ColorSpec2021 and override specific methods
	spec2021 *ColorSpec2021
}

func NewColorSpec2025() *ColorSpec2025 {
	return &ColorSpec2025{
		spec2021: &ColorSpec2021{},
	}
}

// Most methods delegate to 2021 spec, with 2025-specific overrides below

////////////////////////////////////////////////////////////////
// Main Palettes - same as 2021                              //
////////////////////////////////////////////////////////////////

func (c *ColorSpec2025) PrimaryPaletteKeyColor() *DynamicColor {
	return c.spec2021.PrimaryPaletteKeyColor()
}

func (c *ColorSpec2025) SecondaryPaletteKeyColor() *DynamicColor {
	return c.spec2021.SecondaryPaletteKeyColor()
}

func (c *ColorSpec2025) TertiaryPaletteKeyColor() *DynamicColor {
	return c.spec2021.TertiaryPaletteKeyColor()
}

func (c *ColorSpec2025) NeutralPaletteKeyColor() *DynamicColor {
	return c.spec2021.NeutralPaletteKeyColor()
}

func (c *ColorSpec2025) NeutralVariantPaletteKeyColor() *DynamicColor {
	return c.spec2021.NeutralVariantPaletteKeyColor()
}

func (c *ColorSpec2025) ErrorPaletteKeyColor() *DynamicColor {
	return c.spec2021.ErrorPaletteKeyColor()
}

////////////////////////////////////////////////////////////////
// Surfaces - Enhanced for 2025                              //
////////////////////////////////////////////////////////////////

func (c *ColorSpec2025) Background() *DynamicColor {
	return c.spec2021.Background()
}

func (c *ColorSpec2025) OnBackground() *DynamicColor {
	return c.spec2021.OnBackground()
}

func (c *ColorSpec2025) Surface() *DynamicColor {
	return c.spec2021.Surface()
}

// Enhanced surface dim for 2025
func (c *ColorSpec2025) SurfaceDim() *DynamicColor {
	return &DynamicColor{
		Name: "surface_dim",
		Palette: func(s *DynamicScheme) *palettes.Tonal {
			return s.NeutralPalette
		},
		Tone: func(s *DynamicScheme) float64 {
			if s.IsDark {
				return 6.0
			}
			return 87.0
		},
	}
}

func (c *ColorSpec2025) SurfaceBright() *DynamicColor {
	return &DynamicColor{
		Name: "surface_bright",
		Palette: func(s *DynamicScheme) *palettes.Tonal {
			return s.NeutralPalette
		},
		Tone: func(s *DynamicScheme) float64 {
			if s.IsDark {
				return 24.0
			}
			return 98.0
		},
	}
}

func (c *ColorSpec2025) SurfaceContainerLowest() *DynamicColor {
	return c.spec2021.SurfaceContainerLowest()
}

func (c *ColorSpec2025) SurfaceContainerLow() *DynamicColor {
	return c.spec2021.SurfaceContainerLow()
}

func (c *ColorSpec2025) SurfaceContainer() *DynamicColor {
	return c.spec2021.SurfaceContainer()
}

func (c *ColorSpec2025) SurfaceContainerHigh() *DynamicColor {
	return c.spec2021.SurfaceContainerHigh()
}

func (c *ColorSpec2025) SurfaceContainerHighest() *DynamicColor {
	return c.spec2021.SurfaceContainerHighest()
}

func (c *ColorSpec2025) OnSurface() *DynamicColor {
	return c.spec2021.OnSurface()
}

func (c *ColorSpec2025) SurfaceVariant() *DynamicColor {
	return c.spec2021.SurfaceVariant()
}

// Enhanced for better contrast
func (c *ColorSpec2025) OnSurfaceVariant() *DynamicColor {
	return &DynamicColor{
		Name: "on_surface_variant",
		Palette: func(s *DynamicScheme) *palettes.Tonal {
			return s.NeutralVariantPalette
		},
		Tone: func(s *DynamicScheme) float64 {
			if s.IsDark {
				return 80.0
			}
			return 30.0
		},
	}
}

func (c *ColorSpec2025) InverseSurface() *DynamicColor {
	return c.spec2021.InverseSurface()
}

func (c *ColorSpec2025) InverseOnSurface() *DynamicColor {
	return c.spec2021.InverseOnSurface()
}

func (c *ColorSpec2025) Outline() *DynamicColor {
	return c.spec2021.Outline()
}

func (c *ColorSpec2025) OutlineVariant() *DynamicColor {
	return c.spec2021.OutlineVariant()
}

func (c *ColorSpec2025) Shadow() *DynamicColor {
	return c.spec2021.Shadow()
}

func (c *ColorSpec2025) Scrim() *DynamicColor {
	return c.spec2021.Scrim()
}

func (c *ColorSpec2025) SurfaceTint() *DynamicColor {
	return c.spec2021.SurfaceTint()
}

////////////////////////////////////////////////////////////////
// Primaries - Enhanced with Dim colors for 2025            //
////////////////////////////////////////////////////////////////

func (c *ColorSpec2025) Primary() *DynamicColor {
	return c.spec2021.Primary()
}

// Primary Dim available in 2025 spec
func (c *ColorSpec2025) PrimaryDim() *DynamicColor {
	return &DynamicColor{
		Name: "primary_dim",
		Palette: func(s *DynamicScheme) *palettes.Tonal {
			return s.PrimaryPalette
		},
		Tone: func(s *DynamicScheme) float64 {
			if s.IsDark {
				return 60.0
			}
			return 30.0
		},
	}
}

func (c *ColorSpec2025) OnPrimary() *DynamicColor {
	return c.spec2021.OnPrimary()
}

func (c *ColorSpec2025) PrimaryContainer() *DynamicColor {
	return c.spec2021.PrimaryContainer()
}

func (c *ColorSpec2025) OnPrimaryContainer() *DynamicColor {
	return c.spec2021.OnPrimaryContainer()
}

func (c *ColorSpec2025) InversePrimary() *DynamicColor {
	return c.spec2021.InversePrimary()
}

////////////////////////////////////////////////////////////////
// Secondaries - Enhanced with Dim colors for 2025          //
////////////////////////////////////////////////////////////////

func (c *ColorSpec2025) Secondary() *DynamicColor {
	return c.spec2021.Secondary()
}

// Secondary Dim available in 2025 spec
func (c *ColorSpec2025) SecondaryDim() *DynamicColor {
	return &DynamicColor{
		Name: "secondary_dim",
		Palette: func(s *DynamicScheme) *palettes.Tonal {
			return s.SecondaryPalette
		},
		Tone: func(s *DynamicScheme) float64 {
			if s.IsDark {
				return 60.0
			}
			return 30.0
		},
	}
}

func (c *ColorSpec2025) OnSecondary() *DynamicColor {
	return c.spec2021.OnSecondary()
}

func (c *ColorSpec2025) SecondaryContainer() *DynamicColor {
	return c.spec2021.SecondaryContainer()
}

func (c *ColorSpec2025) OnSecondaryContainer() *DynamicColor {
	return c.spec2021.OnSecondaryContainer()
}

////////////////////////////////////////////////////////////////
// Tertiaries - Enhanced with Dim colors for 2025           //
////////////////////////////////////////////////////////////////

func (c *ColorSpec2025) Tertiary() *DynamicColor {
	return c.spec2021.Tertiary()
}

// Tertiary Dim available in 2025 spec
func (c *ColorSpec2025) TertiaryDim() *DynamicColor {
	return &DynamicColor{
		Name: "tertiary_dim",
		Palette: func(s *DynamicScheme) *palettes.Tonal {
			return s.TertiaryPalette
		},
		Tone: func(s *DynamicScheme) float64 {
			if s.IsDark {
				return 60.0
			}
			return 30.0
		},
	}
}

func (c *ColorSpec2025) OnTertiary() *DynamicColor {
	return c.spec2021.OnTertiary()
}

func (c *ColorSpec2025) TertiaryContainer() *DynamicColor {
	return c.spec2021.TertiaryContainer()
}

func (c *ColorSpec2025) OnTertiaryContainer() *DynamicColor {
	return c.spec2021.OnTertiaryContainer()
}

////////////////////////////////////////////////////////////////
// Errors - Enhanced with Dim colors for 2025               //
////////////////////////////////////////////////////////////////

func (c *ColorSpec2025) Error() *DynamicColor {
	return c.spec2021.Error()
}

// Error Dim available in 2025 spec
func (c *ColorSpec2025) ErrorDim() *DynamicColor {
	return &DynamicColor{
		Name: "error_dim",
		Palette: func(s *DynamicScheme) *palettes.Tonal {
			return s.ErrorPalette
		},
		Tone: func(s *DynamicScheme) float64 {
			if s.IsDark {
				return 60.0
			}
			return 30.0
		},
	}
}

func (c *ColorSpec2025) OnError() *DynamicColor {
	return c.spec2021.OnError()
}

func (c *ColorSpec2025) ErrorContainer() *DynamicColor {
	return c.spec2021.ErrorContainer()
}

func (c *ColorSpec2025) OnErrorContainer() *DynamicColor {
	return c.spec2021.OnErrorContainer()
}

// Delegate remaining methods to 2021 spec
func (c *ColorSpec2025) PrimaryFixed() *DynamicColor {
	return c.spec2021.PrimaryFixed()
}

func (c *ColorSpec2025) PrimaryFixedDim() *DynamicColor {
	return c.spec2021.PrimaryFixedDim()
}

func (c *ColorSpec2025) OnPrimaryFixed() *DynamicColor {
	return c.spec2021.OnPrimaryFixed()
}

func (c *ColorSpec2025) OnPrimaryFixedVariant() *DynamicColor {
	return c.spec2021.OnPrimaryFixedVariant()
}

func (c *ColorSpec2025) SecondaryFixed() *DynamicColor {
	return c.spec2021.SecondaryFixed()
}

func (c *ColorSpec2025) SecondaryFixedDim() *DynamicColor {
	return c.spec2021.SecondaryFixedDim()
}

func (c *ColorSpec2025) OnSecondaryFixed() *DynamicColor {
	return c.spec2021.OnSecondaryFixed()
}

func (c *ColorSpec2025) OnSecondaryFixedVariant() *DynamicColor {
	return c.spec2021.OnSecondaryFixedVariant()
}

func (c *ColorSpec2025) TertiaryFixed() *DynamicColor {
	return c.spec2021.TertiaryFixed()
}

func (c *ColorSpec2025) TertiaryFixedDim() *DynamicColor {
	return c.spec2021.TertiaryFixedDim()
}

func (c *ColorSpec2025) OnTertiaryFixed() *DynamicColor {
	return c.spec2021.OnTertiaryFixed()
}

func (c *ColorSpec2025) OnTertiaryFixedVariant() *DynamicColor {
	return c.spec2021.OnTertiaryFixedVariant()
}

func (c *ColorSpec2025) ControlActivated() *DynamicColor {
	return c.spec2021.ControlActivated()
}

func (c *ColorSpec2025) ControlNormal() *DynamicColor {
	return c.spec2021.ControlNormal()
}

func (c *ColorSpec2025) ControlHighlight() *DynamicColor {
	return c.spec2021.ControlHighlight()
}

func (c *ColorSpec2025) TextPrimaryInverse() *DynamicColor {
	return c.spec2021.TextPrimaryInverse()
}

func (c *ColorSpec2025) TextSecondaryAndTertiaryInverse() *DynamicColor {
	return c.spec2021.TextSecondaryAndTertiaryInverse()
}

func (c *ColorSpec2025) TextPrimaryInverseDisableOnly() *DynamicColor {
	return c.spec2021.TextPrimaryInverseDisableOnly()
}

func (c *ColorSpec2025) TextSecondaryAndTertiaryInverseDisabled() *DynamicColor {
	return c.spec2021.TextSecondaryAndTertiaryInverseDisabled()
}

func (c *ColorSpec2025) TextHintInverse() *DynamicColor {
	return c.spec2021.TextHintInverse()
}

func (c *ColorSpec2025) HighestSurface(s *DynamicScheme) *DynamicColor {
	return c.spec2021.HighestSurface(s)
}

func (c *ColorSpec2025) Hct(scheme *DynamicScheme, color *DynamicColor) *cam.HCT {
	return c.spec2021.Hct(scheme, color)
}

func (c *ColorSpec2025) Tone(scheme *DynamicScheme, color *DynamicColor) float64 {
	return c.spec2021.Tone(scheme, color)
}

// Enhanced palette generation with chroma multipliers
func (c *ColorSpec2025) PrimaryPalette(variant Variant, sourceColorHct *cam.HCT, isDark bool, platform Platform, contrastLevel float64) *palettes.Tonal {
	chromaMultiplier := 1.2
	if platform == PlatformWatch {
		chromaMultiplier = 1.1
	}
	
	chroma := math.Max(48.0, sourceColorHct.Chroma*chromaMultiplier)
	return palettes.TonalFromHueAndChroma(sourceColorHct.Hue, chroma)
}

func (c *ColorSpec2025) SecondaryPalette(variant Variant, sourceColorHct *cam.HCT, isDark bool, platform Platform, contrastLevel float64) *palettes.Tonal {
	chroma := 16.0
	if platform == PlatformPhone {
		chroma = 20.0
	}
	return palettes.TonalFromHueAndChroma(sourceColorHct.Hue, chroma)
}

func (c *ColorSpec2025) TertiaryPalette(variant Variant, sourceColorHct *cam.HCT, isDark bool, platform Platform, contrastLevel float64) *palettes.Tonal {
	hue := sourceColorHct.Hue + 60.0
	chroma := 24.0
	if platform == PlatformPhone {
		chroma = 28.0
	}
	return palettes.TonalFromHueAndChroma(hue, chroma)
}

func (c *ColorSpec2025) NeutralPalette(variant Variant, sourceColorHct *cam.HCT, isDark bool, platform Platform, contrastLevel float64) *palettes.Tonal {
	return c.spec2021.NeutralPalette(variant, sourceColorHct, isDark, platform, contrastLevel)
}

func (c *ColorSpec2025) NeutralVariantPalette(variant Variant, sourceColorHct *cam.HCT, isDark bool, platform Platform, contrastLevel float64) *palettes.Tonal {
	return c.spec2021.NeutralVariantPalette(variant, sourceColorHct, isDark, platform, contrastLevel)
}

func (c *ColorSpec2025) ErrorPalette(variant Variant, sourceColorHct *cam.HCT, isDark bool, platform Platform, contrastLevel float64) *palettes.Tonal {
	return c.spec2021.ErrorPalette(variant, sourceColorHct, isDark, platform, contrastLevel)
}