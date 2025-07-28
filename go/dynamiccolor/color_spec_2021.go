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

// ColorSpec2021 implements ColorSpec for the 2021 Material Design specification.
type ColorSpec2021 struct{}


////////////////////////////////////////////////////////////////
// Main Palettes                                              //
////////////////////////////////////////////////////////////////

func (c *ColorSpec2021) PrimaryPaletteKeyColor() *DynamicColor {
	return dynamicColorKeyColor("primary_palette_key_color", func(s *DynamicScheme) *palettes.Tonal { return s.PrimaryPalette })
}

func (c *ColorSpec2021) SecondaryPaletteKeyColor() *DynamicColor {
	return dynamicColorKeyColor("secondary_palette_key_color", func(s *DynamicScheme) *palettes.Tonal { return s.SecondaryPalette })
}

func (c *ColorSpec2021) TertiaryPaletteKeyColor() *DynamicColor {
	return dynamicColorKeyColor("tertiary_palette_key_color", func(s *DynamicScheme) *palettes.Tonal { return s.TertiaryPalette })
}

func (c *ColorSpec2021) NeutralPaletteKeyColor() *DynamicColor {
	return dynamicColorKeyColor("neutral_palette_key_color", func(s *DynamicScheme) *palettes.Tonal { return s.NeutralPalette })
}

func (c *ColorSpec2021) NeutralVariantPaletteKeyColor() *DynamicColor {
	return dynamicColorKeyColor("neutral_variant_palette_key_color", func(s *DynamicScheme) *palettes.Tonal { return s.NeutralVariantPalette })
}

func (c *ColorSpec2021) ErrorPaletteKeyColor() *DynamicColor {
	return dynamicColorKeyColor("error_palette_key_color", func(s *DynamicScheme) *palettes.Tonal { return s.ErrorPalette })
}

////////////////////////////////////////////////////////////////
// Surfaces [S]                                               //
////////////////////////////////////////////////////////////////

func (c *ColorSpec2021) Background() *DynamicColor {
	return dynamicColorFixedTone("background", func(s *DynamicScheme) *palettes.Tonal { return s.NeutralPalette }, 99.0, 10.0)
}

func (c *ColorSpec2021) OnBackground() *DynamicColor {
	return dynamicColorFixedTone("on_background", func(s *DynamicScheme) *palettes.Tonal { return s.NeutralPalette }, 10.0, 90.0)
}

func (c *ColorSpec2021) OnSurface() *DynamicColor {
	return dynamicColorFixedTone("on_surface", func(s *DynamicScheme) *palettes.Tonal { return s.NeutralPalette }, 10.0, 90.0)
}

func (c *ColorSpec2021) Surface() *DynamicColor {
	return dynamicColorFixedTone("surface", func(s *DynamicScheme) *palettes.Tonal { return s.NeutralPalette }, 99.0, 10.0)
}

func (c *ColorSpec2021) SurfaceDim() *DynamicColor {
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

func (c *ColorSpec2021) SurfaceBright() *DynamicColor {
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

func (c *ColorSpec2021) SurfaceContainerLowest() *DynamicColor {
	return &DynamicColor{
		Name: "surface_container_lowest",
		Palette: func(s *DynamicScheme) *palettes.Tonal {
			return s.NeutralPalette
		},
		Tone: func(s *DynamicScheme) float64 {
			if s.IsDark {
				return 4.0
			}
			return 100.0
		},
	}
}

func (c *ColorSpec2021) SurfaceContainerLow() *DynamicColor {
	return &DynamicColor{
		Name: "surface_container_low",
		Palette: func(s *DynamicScheme) *palettes.Tonal {
			return s.NeutralPalette
		},
		Tone: func(s *DynamicScheme) float64 {
			if s.IsDark {
				return 10.0
			}
			return 96.0
		},
	}
}

func (c *ColorSpec2021) SurfaceContainer() *DynamicColor {
	return &DynamicColor{
		Name: "surface_container",
		Palette: func(s *DynamicScheme) *palettes.Tonal {
			return s.NeutralPalette
		},
		Tone: func(s *DynamicScheme) float64 {
			if s.IsDark {
				return 12.0
			}
			return 94.0
		},
	}
}

func (c *ColorSpec2021) SurfaceContainerHigh() *DynamicColor {
	return &DynamicColor{
		Name: "surface_container_high",
		Palette: func(s *DynamicScheme) *palettes.Tonal {
			return s.NeutralPalette
		},
		Tone: func(s *DynamicScheme) float64 {
			if s.IsDark {
				return 17.0
			}
			return 92.0
		},
	}
}

func (c *ColorSpec2021) SurfaceContainerHighest() *DynamicColor {
	return &DynamicColor{
		Name: "surface_container_highest",
		Palette: func(s *DynamicScheme) *palettes.Tonal {
			return s.NeutralPalette
		},
		Tone: func(s *DynamicScheme) float64 {
			if s.IsDark {
				return 22.0
			}
			return 90.0
		},
	}
}

func (c *ColorSpec2021) SurfaceVariant() *DynamicColor {
	return &DynamicColor{
		Name: "surface_variant",
		Palette: func(s *DynamicScheme) *palettes.Tonal {
			return s.NeutralVariantPalette
		},
		Tone: func(s *DynamicScheme) float64 {
			if s.IsDark {
				return 30.0
			}
			return 90.0
		},
	}
}

func (c *ColorSpec2021) OnSurfaceVariant() *DynamicColor {
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

func (c *ColorSpec2021) InverseSurface() *DynamicColor {
	return &DynamicColor{
		Name: "inverse_surface",
		Palette: func(s *DynamicScheme) *palettes.Tonal {
			return s.NeutralPalette
		},
		Tone: func(s *DynamicScheme) float64 {
			if s.IsDark {
				return 90.0
			}
			return 20.0
		},
	}
}

func (c *ColorSpec2021) InverseOnSurface() *DynamicColor {
	return &DynamicColor{
		Name: "inverse_on_surface",
		Palette: func(s *DynamicScheme) *palettes.Tonal {
			return s.NeutralPalette
		},
		Tone: func(s *DynamicScheme) float64 {
			if s.IsDark {
				return 20.0
			}
			return 95.0
		},
	}
}

func (c *ColorSpec2021) Outline() *DynamicColor {
	return &DynamicColor{
		Name: "outline",
		Palette: func(s *DynamicScheme) *palettes.Tonal {
			return s.NeutralVariantPalette
		},
		Tone: func(s *DynamicScheme) float64 {
			return 50.0
		},
	}
}

func (c *ColorSpec2021) OutlineVariant() *DynamicColor {
	return &DynamicColor{
		Name: "outline_variant",
		Palette: func(s *DynamicScheme) *palettes.Tonal {
			return s.NeutralVariantPalette
		},
		Tone: func(s *DynamicScheme) float64 {
			if s.IsDark {
				return 30.0
			}
			return 80.0
		},
	}
}

func (c *ColorSpec2021) Shadow() *DynamicColor {
	return &DynamicColor{
		Name: "shadow",
		Palette: func(s *DynamicScheme) *palettes.Tonal {
			return s.NeutralPalette
		},
		Tone: func(s *DynamicScheme) float64 {
			return 0.0
		},
	}
}

func (c *ColorSpec2021) Scrim() *DynamicColor {
	return &DynamicColor{
		Name: "scrim",
		Palette: func(s *DynamicScheme) *palettes.Tonal {
			return s.NeutralPalette
		},
		Tone: func(s *DynamicScheme) float64 {
			return 0.0
		},
	}
}

func (c *ColorSpec2021) SurfaceTint() *DynamicColor {
	return &DynamicColor{
		Name: "surface_tint",
		Palette: func(s *DynamicScheme) *palettes.Tonal {
			return s.PrimaryPalette
		},
		Tone: func(s *DynamicScheme) float64 {
			if s.IsDark {
				return 80.0
			}
			return 40.0
		},
	}
}

////////////////////////////////////////////////////////////////
// Primaries [P]                                              //
////////////////////////////////////////////////////////////////

func (c *ColorSpec2021) Primary() *DynamicColor {
	return &DynamicColor{
		Name: "primary",
		Palette: func(s *DynamicScheme) *palettes.Tonal {
			return s.PrimaryPalette
		},
		Tone: func(s *DynamicScheme) float64 {
			if s.IsDark {
				return 80.0
			}
			return 40.0
		},
	}
}

func (c *ColorSpec2021) PrimaryDim() *DynamicColor {
	// Not available in 2021 spec
	return nil
}

func (c *ColorSpec2021) OnPrimary() *DynamicColor {
	return &DynamicColor{
		Name: "on_primary",
		Palette: func(s *DynamicScheme) *palettes.Tonal {
			return s.PrimaryPalette
		},
		Tone: func(s *DynamicScheme) float64 {
			if s.IsDark {
				return 20.0
			}
			return 100.0
		},
	}
}

func (c *ColorSpec2021) PrimaryContainer() *DynamicColor {
	return &DynamicColor{
		Name: "primary_container",
		Palette: func(s *DynamicScheme) *palettes.Tonal {
			return s.PrimaryPalette
		},
		Tone: func(s *DynamicScheme) float64 {
			if s.IsDark {
				return 30.0
			}
			return 90.0
		},
	}
}

func (c *ColorSpec2021) OnPrimaryContainer() *DynamicColor {
	return &DynamicColor{
		Name: "on_primary_container",
		Palette: func(s *DynamicScheme) *palettes.Tonal {
			return s.PrimaryPalette
		},
		Tone: func(s *DynamicScheme) float64 {
			if s.IsDark {
				return 90.0
			}
			return 10.0
		},
	}
}

func (c *ColorSpec2021) InversePrimary() *DynamicColor {
	return &DynamicColor{
		Name: "inverse_primary",
		Palette: func(s *DynamicScheme) *palettes.Tonal {
			return s.PrimaryPalette
		},
		Tone: func(s *DynamicScheme) float64 {
			if s.IsDark {
				return 40.0
			}
			return 80.0
		},
	}
}

////////////////////////////////////////////////////////////////
// Secondaries [Q]                                            //
////////////////////////////////////////////////////////////////

func (c *ColorSpec2021) Secondary() *DynamicColor {
	return &DynamicColor{
		Name: "secondary",
		Palette: func(s *DynamicScheme) *palettes.Tonal {
			return s.SecondaryPalette
		},
		Tone: func(s *DynamicScheme) float64 {
			if s.IsDark {
				return 80.0
			}
			return 40.0
		},
	}
}

func (c *ColorSpec2021) SecondaryDim() *DynamicColor {
	// Not available in 2021 spec
	return nil
}

func (c *ColorSpec2021) OnSecondary() *DynamicColor {
	return &DynamicColor{
		Name: "on_secondary",
		Palette: func(s *DynamicScheme) *palettes.Tonal {
			return s.SecondaryPalette
		},
		Tone: func(s *DynamicScheme) float64 {
			if s.IsDark {
				return 20.0
			}
			return 100.0
		},
	}
}

func (c *ColorSpec2021) SecondaryContainer() *DynamicColor {
	return &DynamicColor{
		Name: "secondary_container",
		Palette: func(s *DynamicScheme) *palettes.Tonal {
			return s.SecondaryPalette
		},
		Tone: func(s *DynamicScheme) float64 {
			if s.IsDark {
				return 30.0
			}
			return 90.0
		},
	}
}

func (c *ColorSpec2021) OnSecondaryContainer() *DynamicColor {
	return &DynamicColor{
		Name: "on_secondary_container",
		Palette: func(s *DynamicScheme) *palettes.Tonal {
			return s.SecondaryPalette
		},
		Tone: func(s *DynamicScheme) float64 {
			if s.IsDark {
				return 90.0
			}
			return 10.0
		},
	}
}

////////////////////////////////////////////////////////////////
// Tertiaries [T]                                             //
////////////////////////////////////////////////////////////////

func (c *ColorSpec2021) Tertiary() *DynamicColor {
	return &DynamicColor{
		Name: "tertiary",
		Palette: func(s *DynamicScheme) *palettes.Tonal {
			return s.TertiaryPalette
		},
		Tone: func(s *DynamicScheme) float64 {
			if s.IsDark {
				return 80.0
			}
			return 40.0
		},
	}
}

func (c *ColorSpec2021) TertiaryDim() *DynamicColor {
	// Not available in 2021 spec
	return nil
}

func (c *ColorSpec2021) OnTertiary() *DynamicColor {
	return &DynamicColor{
		Name: "on_tertiary",
		Palette: func(s *DynamicScheme) *palettes.Tonal {
			return s.TertiaryPalette
		},
		Tone: func(s *DynamicScheme) float64 {
			if s.IsDark {
				return 20.0
			}
			return 100.0
		},
	}
}

func (c *ColorSpec2021) TertiaryContainer() *DynamicColor {
	return &DynamicColor{
		Name: "tertiary_container",
		Palette: func(s *DynamicScheme) *palettes.Tonal {
			return s.TertiaryPalette
		},
		Tone: func(s *DynamicScheme) float64 {
			if s.IsDark {
				return 30.0
			}
			return 90.0
		},
	}
}

func (c *ColorSpec2021) OnTertiaryContainer() *DynamicColor {
	return &DynamicColor{
		Name: "on_tertiary_container",
		Palette: func(s *DynamicScheme) *palettes.Tonal {
			return s.TertiaryPalette
		},
		Tone: func(s *DynamicScheme) float64 {
			if s.IsDark {
				return 90.0
			}
			return 10.0
		},
	}
}

////////////////////////////////////////////////////////////////
// Errors [E]                                                 //
////////////////////////////////////////////////////////////////

func (c *ColorSpec2021) Error() *DynamicColor {
	return &DynamicColor{
		Name: "error",
		Palette: func(s *DynamicScheme) *palettes.Tonal {
			return s.ErrorPalette
		},
		Tone: func(s *DynamicScheme) float64 {
			if s.IsDark {
				return 80.0
			}
			return 40.0
		},
	}
}

func (c *ColorSpec2021) ErrorDim() *DynamicColor {
	// Not available in 2021 spec
	return nil
}

func (c *ColorSpec2021) OnError() *DynamicColor {
	return &DynamicColor{
		Name: "on_error",
		Palette: func(s *DynamicScheme) *palettes.Tonal {
			return s.ErrorPalette
		},
		Tone: func(s *DynamicScheme) float64 {
			if s.IsDark {
				return 20.0
			}
			return 100.0
		},
	}
}

func (c *ColorSpec2021) ErrorContainer() *DynamicColor {
	return &DynamicColor{
		Name: "error_container",
		Palette: func(s *DynamicScheme) *palettes.Tonal {
			return s.ErrorPalette
		},
		Tone: func(s *DynamicScheme) float64 {
			if s.IsDark {
				return 30.0
			}
			return 90.0
		},
	}
}

func (c *ColorSpec2021) OnErrorContainer() *DynamicColor {
	return &DynamicColor{
		Name: "on_error_container",
		Palette: func(s *DynamicScheme) *palettes.Tonal {
			return s.ErrorPalette
		},
		Tone: func(s *DynamicScheme) float64 {
			if s.IsDark {
				return 90.0
			}
			return 10.0
		},
	}
}

// Fixed colors
func (c *ColorSpec2021) PrimaryFixed() *DynamicColor {
	return &DynamicColor{Name: "primary_fixed", Palette: func(s *DynamicScheme) *palettes.Tonal { return s.PrimaryPalette }, Tone: func(s *DynamicScheme) float64 { return 90.0 }}
}

func (c *ColorSpec2021) PrimaryFixedDim() *DynamicColor {
	return &DynamicColor{Name: "primary_fixed_dim", Palette: func(s *DynamicScheme) *palettes.Tonal { return s.PrimaryPalette }, Tone: func(s *DynamicScheme) float64 { return 80.0 }}
}

func (c *ColorSpec2021) OnPrimaryFixed() *DynamicColor {
	return &DynamicColor{
		Name:    "on_primary_fixed",
		Palette: func(s *DynamicScheme) *palettes.Tonal { return s.PrimaryPalette },
		Tone: func(s *DynamicScheme) float64 {
			return 10.0
		},
	}
}

func (c *ColorSpec2021) OnPrimaryFixedVariant() *DynamicColor {
	return &DynamicColor{
		Name:    "on_primary_fixed_variant",
		Palette: func(s *DynamicScheme) *palettes.Tonal { return s.PrimaryPalette },
		Tone: func(s *DynamicScheme) float64 {
			return 30.0
		},
	}
}

func (c *ColorSpec2021) SecondaryFixed() *DynamicColor {
	return &DynamicColor{
		Name:    "secondary_fixed",
		Palette: func(s *DynamicScheme) *palettes.Tonal { return s.SecondaryPalette },
		Tone: func(s *DynamicScheme) float64 {
			return 90.0
		},
	}
}

func (c *ColorSpec2021) SecondaryFixedDim() *DynamicColor {
	return &DynamicColor{
		Name:    "secondary_fixed_dim",
		Palette: func(s *DynamicScheme) *palettes.Tonal { return s.SecondaryPalette },
		Tone: func(s *DynamicScheme) float64 {
			return 80.0
		},
	}
}

func (c *ColorSpec2021) OnSecondaryFixed() *DynamicColor {
	return &DynamicColor{
		Name:    "on_secondary_fixed",
		Palette: func(s *DynamicScheme) *palettes.Tonal { return s.SecondaryPalette },
		Tone: func(s *DynamicScheme) float64 {
			return 10.0
		},
	}
}

func (c *ColorSpec2021) OnSecondaryFixedVariant() *DynamicColor {
	return &DynamicColor{
		Name:    "on_secondary_fixed_variant",
		Palette: func(s *DynamicScheme) *palettes.Tonal { return s.SecondaryPalette },
		Tone: func(s *DynamicScheme) float64 {
			return 30.0
		},
	}
}

func (c *ColorSpec2021) TertiaryFixed() *DynamicColor {
	return &DynamicColor{
		Name:    "tertiary_fixed",
		Palette: func(s *DynamicScheme) *palettes.Tonal { return s.TertiaryPalette },
		Tone: func(s *DynamicScheme) float64 {
			return 90.0
		},
	}
}

func (c *ColorSpec2021) TertiaryFixedDim() *DynamicColor {
	return &DynamicColor{
		Name:    "tertiary_fixed_dim",
		Palette: func(s *DynamicScheme) *palettes.Tonal { return s.TertiaryPalette },
		Tone: func(s *DynamicScheme) float64 {
			return 80.0
		},
	}
}

func (c *ColorSpec2021) OnTertiaryFixed() *DynamicColor {
	return &DynamicColor{
		Name:    "on_tertiary_fixed",
		Palette: func(s *DynamicScheme) *palettes.Tonal { return s.TertiaryPalette },
		Tone: func(s *DynamicScheme) float64 {
			return 10.0
		},
	}
}

func (c *ColorSpec2021) OnTertiaryFixedVariant() *DynamicColor {
	return &DynamicColor{Name: "on_tertiary_fixed_variant", Palette: func(s *DynamicScheme) *palettes.Tonal { return s.TertiaryPalette }, Tone: func(s *DynamicScheme) float64 { return 30.0 }}
}

// Android-only colors - simplified implementations
func (c *ColorSpec2021) ControlActivated() *DynamicColor {
	return c.Primary()
}

func (c *ColorSpec2021) ControlNormal() *DynamicColor {
	return c.OutlineVariant()
}

func (c *ColorSpec2021) ControlHighlight() *DynamicColor {
	return &DynamicColor{Name: "control_highlight", Palette: func(s *DynamicScheme) *palettes.Tonal { return s.PrimaryPalette }, Tone: func(s *DynamicScheme) float64 {
		if s.IsDark {
			return 25.0
		}
		return 90.0
	}}
}

func (c *ColorSpec2021) TextPrimaryInverse() *DynamicColor {
	return c.InverseOnSurface()
}

func (c *ColorSpec2021) TextSecondaryAndTertiaryInverse() *DynamicColor {
	return &DynamicColor{Name: "text_secondary_and_tertiary_inverse", Palette: func(s *DynamicScheme) *palettes.Tonal { return s.NeutralPalette }, Tone: func(s *DynamicScheme) float64 {
		if s.IsDark {
			return 30.0
		}
		return 80.0
	}}
}

func (c *ColorSpec2021) TextPrimaryInverseDisableOnly() *DynamicColor {
	return c.TextPrimaryInverse()
}

func (c *ColorSpec2021) TextSecondaryAndTertiaryInverseDisabled() *DynamicColor {
	return c.TextSecondaryAndTertiaryInverse()
}

func (c *ColorSpec2021) TextHintInverse() *DynamicColor {
	return &DynamicColor{Name: "text_hint_inverse", Palette: func(s *DynamicScheme) *palettes.Tonal { return s.NeutralPalette }, Tone: func(s *DynamicScheme) float64 {
		if s.IsDark {
			return 25.0
		}
		return 85.0
	}}
}

func (c *ColorSpec2021) HighestSurface(s *DynamicScheme) *DynamicColor {
	if s.IsDark {
		return c.SurfaceBright()
	}
	return c.SurfaceDim()
}

func (c *ColorSpec2021) Hct(scheme *DynamicScheme, color *DynamicColor) *cam.HCT {
	tone := c.Tone(scheme, color)
	palette := color.Palette(scheme)
	hct := palette.KeyColor
	hct.Tone = tone
	return hct
}

func (c *ColorSpec2021) Tone(scheme *DynamicScheme, color *DynamicColor) float64 {
	return color.Tone(scheme)
}

// Palette generation methods - basic implementations
func (c *ColorSpec2021) PrimaryPalette(variant Variant, sourceColorHct *cam.HCT, isDark bool, platform Platform, contrastLevel float64) *palettes.Tonal {
	return palettes.TonalFromHueAndChroma(sourceColorHct.Hue, math.Max(48.0, sourceColorHct.Chroma))
}

func (c *ColorSpec2021) SecondaryPalette(variant Variant, sourceColorHct *cam.HCT, isDark bool, platform Platform, contrastLevel float64) *palettes.Tonal {
	return palettes.TonalFromHueAndChroma(sourceColorHct.Hue, 16.0)
}

func (c *ColorSpec2021) TertiaryPalette(variant Variant, sourceColorHct *cam.HCT, isDark bool, platform Platform, contrastLevel float64) *palettes.Tonal {
	return palettes.TonalFromHueAndChroma(sourceColorHct.Hue+60.0, 24.0)
}

func (c *ColorSpec2021) NeutralPalette(variant Variant, sourceColorHct *cam.HCT, isDark bool, platform Platform, contrastLevel float64) *palettes.Tonal {
	return palettes.TonalFromHueAndChroma(sourceColorHct.Hue, 4.0)
}

func (c *ColorSpec2021) NeutralVariantPalette(variant Variant, sourceColorHct *cam.HCT, isDark bool, platform Platform, contrastLevel float64) *palettes.Tonal {
	return palettes.TonalFromHueAndChroma(sourceColorHct.Hue, 8.0)
}

func (c *ColorSpec2021) ErrorPalette(variant Variant, sourceColorHct *cam.HCT, isDark bool, platform Platform, contrastLevel float64) *palettes.Tonal {
	return palettes.TonalFromHueAndChroma(25.0, 84.0)
}