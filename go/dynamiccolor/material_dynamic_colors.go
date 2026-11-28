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

import "github.com/material-foundation/material-color-utilities/go/palettes"

// Palette helpers
func palettePrimary(scheme *DynamicScheme) *palettes.Tonal   { return scheme.PrimaryPalette }
func paletteSecondary(scheme *DynamicScheme) *palettes.Tonal { return scheme.SecondaryPalette }
func paletteTertiary(scheme *DynamicScheme) *palettes.Tonal  { return scheme.TertiaryPalette }
func paletteError(scheme *DynamicScheme) *palettes.Tonal     { return scheme.ErrorPalette }
func paletteNeutral(scheme *DynamicScheme) *palettes.Tonal   { return scheme.NeutralPalette }
func paletteNeutralVariant(scheme *DynamicScheme) *palettes.Tonal {
	return scheme.NeutralVariantPalette
}

// Tone helpers
func tone(light, dark float64) func(*DynamicScheme) float64 {
	return func(scheme *DynamicScheme) float64 {
		if scheme.IsDark {
			return dark
		}
		return light
	}
}

// General dynamic color helper
func makeDynamicColor(
	name string,
	paletteFunc func(*DynamicScheme) *palettes.Tonal,
	toneFunc func(*DynamicScheme) float64,
	isBackground bool,
	backgroundFunc func(*DynamicScheme) *DynamicColor,
) *DynamicColor {
	dc := NewDynamicColor(name, paletteFunc, toneFunc, isBackground)
	if backgroundFunc != nil {
		return dc.WithBackground(backgroundFunc)
	}
	return dc
}

// MaterialColors provides the standard Material Design 3 dynamic colors.
type MaterialColors struct{}

// NewMaterialColors creates a new MaterialColors instance.
func NewMaterialColors() *MaterialColors {
	return &MaterialColors{}
}

// Primary returns the primary dynamic color.
func (mdc *MaterialColors) Primary() *DynamicColor {
	return makeDynamicColor("primary", palettePrimary, tone(40.0, 80.0), false, nil)
}

// OnPrimary returns the on-primary dynamic color.
func (mdc *MaterialColors) OnPrimary() *DynamicColor {
	return makeDynamicColor("on_primary", palettePrimary, tone(100.0, 20.0), false,
		func(scheme *DynamicScheme) *DynamicColor { return mdc.Primary() })
}

// PrimaryContainer returns the primary container dynamic color.
func (mdc *MaterialColors) PrimaryContainer() *DynamicColor {
	return makeDynamicColor("primary_container", palettePrimary, tone(90.0, 30.0), true, nil)
}

// OnPrimaryContainer returns the on-primary container dynamic color.
func (mdc *MaterialColors) OnPrimaryContainer() *DynamicColor {
	return makeDynamicColor("on_primary_container", palettePrimary, tone(10.0, 90.0), false,
		func(scheme *DynamicScheme) *DynamicColor { return mdc.PrimaryContainer() })
}

// Secondary returns the secondary dynamic color.
func (mdc *MaterialColors) Secondary() *DynamicColor {
	return makeDynamicColor("secondary", paletteSecondary, tone(40.0, 80.0), false, nil)
}

// OnSecondary returns the on-secondary dynamic color.
func (mdc *MaterialColors) OnSecondary() *DynamicColor {
	return makeDynamicColor("on_secondary", paletteSecondary, tone(100.0, 20.0), false,
		func(scheme *DynamicScheme) *DynamicColor { return mdc.Secondary() })
}

// SecondaryContainer returns the secondary container dynamic color.
func (mdc *MaterialColors) SecondaryContainer() *DynamicColor {
	return makeDynamicColor("secondary_container", paletteSecondary, tone(90.0, 30.0), true, nil)
}

// OnSecondaryContainer returns the on-secondary container dynamic color.
func (mdc *MaterialColors) OnSecondaryContainer() *DynamicColor {
	return makeDynamicColor("on_secondary_container", paletteSecondary, tone(10.0, 90.0), false,
		func(scheme *DynamicScheme) *DynamicColor { return mdc.SecondaryContainer() })
}

// Tertiary returns the tertiary dynamic color.
func (mdc *MaterialColors) Tertiary() *DynamicColor {
	return makeDynamicColor("tertiary", paletteTertiary, tone(40.0, 80.0), false, nil)
}

// OnTertiary returns the on-tertiary dynamic color.
func (mdc *MaterialColors) OnTertiary() *DynamicColor {
	return makeDynamicColor("on_tertiary", paletteTertiary, tone(100.0, 20.0), false,
		func(scheme *DynamicScheme) *DynamicColor { return mdc.Tertiary() })
}

// TertiaryContainer returns the tertiary container dynamic color.
func (mdc *MaterialColors) TertiaryContainer() *DynamicColor {
	return makeDynamicColor("tertiary_container", paletteTertiary, tone(90.0, 30.0), true, nil)
}

// OnTertiaryContainer returns the on-tertiary container dynamic color.
func (mdc *MaterialColors) OnTertiaryContainer() *DynamicColor {
	return makeDynamicColor("on_tertiary_container", paletteTertiary, tone(10.0, 90.0), false,
		func(scheme *DynamicScheme) *DynamicColor { return mdc.TertiaryContainer() })
}

// Error returns the error dynamic color.
func (mdc *MaterialColors) Error() *DynamicColor {
	return makeDynamicColor("error", paletteError, tone(40.0, 80.0), false, nil)
}

// OnError returns the on-error dynamic color.
func (mdc *MaterialColors) OnError() *DynamicColor {
	return makeDynamicColor("on_error", paletteError, tone(100.0, 20.0), false,
		func(scheme *DynamicScheme) *DynamicColor { return mdc.Error() })
}

// ErrorContainer returns the error container dynamic color.
func (mdc *MaterialColors) ErrorContainer() *DynamicColor {
	return makeDynamicColor("error_container", paletteError, tone(90.0, 30.0), true, nil)
}

// OnErrorContainer returns the on-error container dynamic color.
func (mdc *MaterialColors) OnErrorContainer() *DynamicColor {
	return makeDynamicColor("on_error_container", paletteError, tone(10.0, 90.0), false,
		func(scheme *DynamicScheme) *DynamicColor { return mdc.ErrorContainer() })
}

// Background returns the background dynamic color.
func (mdc *MaterialColors) Background() *DynamicColor {
	return makeDynamicColor("background", paletteNeutral, tone(99.0, 10.0), true, nil)
}

// OnBackground returns the on-background dynamic color.
func (mdc *MaterialColors) OnBackground() *DynamicColor {
	return makeDynamicColor("on_background", paletteNeutral, tone(10.0, 90.0), false,
		func(scheme *DynamicScheme) *DynamicColor { return mdc.Background() })
}

// Surface returns the surface dynamic color.
func (mdc *MaterialColors) Surface() *DynamicColor {
	return makeDynamicColor("surface", paletteNeutral, tone(99.0, 10.0), true, nil)
}

// OnSurface returns the on-surface dynamic color.
func (mdc *MaterialColors) OnSurface() *DynamicColor {
	return makeDynamicColor("on_surface", paletteNeutral, tone(10.0, 90.0), false,
		func(scheme *DynamicScheme) *DynamicColor { return mdc.Surface() })
}

// SurfaceVariant returns the surface variant dynamic color.
func (mdc *MaterialColors) SurfaceVariant() *DynamicColor {
	return makeDynamicColor("surface_variant", paletteNeutralVariant, tone(90.0, 30.0), true, nil)
}

// OnSurfaceVariant returns the on-surface variant dynamic color.
func (mdc *MaterialColors) OnSurfaceVariant() *DynamicColor {
	return makeDynamicColor("on_surface_variant", paletteNeutralVariant, tone(30.0, 80.0), false,
		func(scheme *DynamicScheme) *DynamicColor { return mdc.SurfaceVariant() })
}

// Outline returns the outline dynamic color.
func (mdc *MaterialColors) Outline() *DynamicColor {
	return makeDynamicColor("outline", paletteNeutralVariant, tone(50.0, 60.0), false, nil)
}

// OutlineVariant returns the outline variant dynamic color.
func (mdc *MaterialColors) OutlineVariant() *DynamicColor {
	return makeDynamicColor("outline_variant", paletteNeutralVariant, tone(80.0, 30.0), false, nil)
}

// Shadow returns the shadow dynamic color.
func (mdc *MaterialColors) Shadow() *DynamicColor {
	return makeDynamicColor("shadow", paletteNeutral, func(scheme *DynamicScheme) float64 { return 0.0 }, false, nil)
}

// Scrim returns the scrim dynamic color.
func (mdc *MaterialColors) Scrim() *DynamicColor {
	return makeDynamicColor("scrim", paletteNeutral, func(scheme *DynamicScheme) float64 { return 0.0 }, false, nil)
}

// InverseSurface returns the inverse surface dynamic color.
func (mdc *MaterialColors) InverseSurface() *DynamicColor {
	return makeDynamicColor("inverse_surface", paletteNeutral, tone(20.0, 90.0), true, nil)
}

// InverseOnSurface returns the inverse on-surface dynamic color.
func (mdc *MaterialColors) InverseOnSurface() *DynamicColor {
	return makeDynamicColor("inverse_on_surface", paletteNeutral, tone(95.0, 20.0), false,
		func(scheme *DynamicScheme) *DynamicColor { return mdc.InverseSurface() })
}

// InversePrimary returns the inverse primary dynamic color.
func (mdc *MaterialColors) InversePrimary() *DynamicColor {
	return makeDynamicColor("inverse_primary", palettePrimary, tone(80.0, 40.0), false,
		func(scheme *DynamicScheme) *DynamicColor { return mdc.InverseSurface() })
}
