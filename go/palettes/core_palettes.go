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

package palettes

import (
	"github.com/material-foundation/material-color-utilities/go/cam"
)

// CorePalettes manages multiple CorePalette instances for advanced color theming.
type CorePalettes struct {
	palettes []*Core
}

// NewCorePalettes creates a new CorePalettes instance.
func NewCorePalettes() *CorePalettes {
	return &CorePalettes{
		palettes: make([]*Core, 0),
	}
}

// FromColors creates CorePalettes from multiple source colors.
func FromColors(colors []uint32) *CorePalettes {
	cp := NewCorePalettes()
	for _, color := range colors {
		cp.Add(Of(color))
	}
	return cp
}

// Add adds a CorePalette to the collection.
func (cp *CorePalettes) Add(palette *Core) {
	cp.palettes = append(cp.palettes, palette)
}

// Get returns the CorePalette at the specified index.
func (cp *CorePalettes) Get(index int) *Core {
	if index < 0 || index >= len(cp.palettes) {
		return nil
	}
	return cp.palettes[index]
}

// Count returns the number of CorePalettes.
func (cp *CorePalettes) Count() int {
	return len(cp.palettes)
}

// GetPrimary returns the primary palette (first palette if available).
func (cp *CorePalettes) GetPrimary() *Core {
	if len(cp.palettes) > 0 {
		return cp.palettes[0]
	}
	return nil
}

// GetSecondary returns the secondary palette (second palette if available).
func (cp *CorePalettes) GetSecondary() *Core {
	if len(cp.palettes) > 1 {
		return cp.palettes[1]
	}
	return nil
}

// GetTertiary returns the tertiary palette (third palette if available).
func (cp *CorePalettes) GetTertiary() *Core {
	if len(cp.palettes) > 2 {
		return cp.palettes[2]
	}
	return nil
}

// Blend creates a blended palette from all palettes in the collection.
func (cp *CorePalettes) Blend() *Core {
	if len(cp.palettes) == 0 {
		return Of(0xFF808080) // Gray fallback
	}

	if len(cp.palettes) == 1 {
		return cp.palettes[0]
	}

	// Blend the first two palettes
	blended := cp.palettes[0]
	for i := 1; i < len(cp.palettes); i++ {
		blended = cp.blendTwoPalettes(blended, cp.palettes[i])
	}

	return blended
}

// blendTwoPalettes blends two CorePalettes together.
func (cp *CorePalettes) blendTwoPalettes(palette1, palette2 *Core) *Core {
	// Get representative colors from each palette
	color1 := palette1.A1.Tone(50) // Mid-tone from primary
	color2 := palette2.A1.Tone(50) // Mid-tone from primary

	// Create HCT colors
	hct1 := cam.HctFromInt(color1)
	hct2 := cam.HctFromInt(color2)

	// Blend hues and chromas
	blendedHue := (hct1.Hue + hct2.Hue) / 2.0
	blendedChroma := (hct1.Chroma + hct2.Chroma) / 2.0

	// Create new blended color
	blendedHct := cam.From(blendedHue, blendedChroma, 50.0)

	return Of(blendedHct.ToInt())
}

// GetAllColors returns all unique colors from all palettes at the specified tone.
func (cp *CorePalettes) GetAllColors(tone int) []uint32 {
	var colors []uint32
	colorSet := make(map[uint32]bool)

	for _, palette := range cp.palettes {
		// Get colors from each tonal palette
		palettes := []*Tonal{
			palette.A1, palette.A2, palette.A3,
			palette.N1, palette.N2, palette.Error,
		}

		for _, tonalPalette := range palettes {
			color := tonalPalette.Tone(tone)
			if !colorSet[color] {
				colors = append(colors, color)
				colorSet[color] = true
			}
		}
	}

	return colors
}

// GetDominantColors returns the most representative colors from the collection.
func (cp *CorePalettes) GetDominantColors(maxColors int) []uint32 {
	if len(cp.palettes) == 0 {
		return []uint32{}
	}

	var colors []uint32

	// Get primary colors from each palette
	for i, palette := range cp.palettes {
		if i >= maxColors {
			break
		}
		colors = append(colors, palette.A1.Tone(50))
	}

	// Fill remaining slots with secondary/tertiary colors if needed
	remaining := maxColors - len(colors)
	for i := 0; i < remaining && i < len(cp.palettes); i++ {
		palette := cp.palettes[i]
		if len(colors) < maxColors {
			colors = append(colors, palette.A2.Tone(50))
		}
		if len(colors) < maxColors {
			colors = append(colors, palette.A3.Tone(50))
		}
	}

	return colors
}
