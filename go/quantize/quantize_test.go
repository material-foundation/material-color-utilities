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

package quantize

import "testing"

func TestAllQuantizers(t *testing.T) {
	// Test data: red, green, blue, white, black
	pixels := []uint32{
		0xFFFF0000, 0xFFFF0000, 0xFFFF0000,
		0xFF00FF00, 0xFF00FF00,
		0xFF0000FF,
		0xFFFFFFFF,
		0xFF000000,
	}

	quantizers := map[string]Quantizer{
		"Map":     NewMap(),
		"Celebi":  NewCelebi(),
		"Wu":      NewWu(),
		"WSMeans": NewWSMeans(),
	}

	for name, quantizer := range quantizers {
		t.Run(name, func(t *testing.T) {
			result := quantizer.Quantize(pixels, 4)

			if len(result) == 0 {
				t.Errorf("%s quantizer returned empty result", name)
			}

			if len(result) > 4 {
				t.Errorf("%s quantizer returned %d colors, expected max 4", name, len(result))
			}

			// Verify all colors have positive counts
			for color, count := range result {
				if count <= 0 {
					t.Errorf("%s quantizer returned color 0x%08X with count %d", name, color, count)
				}
			}
		})
	}
}

func TestLabPointProvider(t *testing.T) {
	provider := NewLabPointProvider()
	
	// Test white
	white := uint32(0xFFFFFFFF)
	point := provider.FromInt(white)
	reconstructed := provider.ToInt(point)
	
	// Should reconstruct to same color (allowing for rounding)
	if (reconstructed>>16)&0xFF < 250 || (reconstructed>>8)&0xFF < 250 || reconstructed&0xFF < 250 {
		t.Errorf("Lab conversion failed: 0x%08X -> %v -> 0x%08X", white, point, reconstructed)
	}
	
	// Test distance
	red := provider.FromInt(0xFFFF0000)
	blue := provider.FromInt(0xFF0000FF)
	distance := provider.Distance(red, blue)
	
	if distance <= 0 {
		t.Errorf("Expected positive distance between red and blue, got %f", distance)
	}
}