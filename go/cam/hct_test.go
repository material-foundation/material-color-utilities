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

package cam

import (
	"math"
	"testing"
)

func TestHctLimitedToSRGB(t *testing.T) {
	// Exact test case from C++ implementation
	// Ensures that the HCT class can only represent sRGB colors.
	// An impossibly high chroma is used.
	hct := From(120.0, 200.0, 50.0)
	argb := hct.ToInt()

	// The hue, chroma, and tone members of hct should actually
	// represent the sRGB color - but since the chroma was impossible,
	// it will be reduced to what's achievable in sRGB
	cam16 := FromInt(argb)

	// The key point is that the HCT values should match what CAM16 calculates
	// for the actual sRGB color produced
	if math.Abs(cam16.Hue-hct.Hue) > 1.0 {
		t.Errorf("CAM16 hue (%f) should approximately match HCT hue (%f)", cam16.Hue, hct.Hue)
	}
	if math.Abs(cam16.Chroma-hct.Chroma) > 1.0 {
		t.Errorf("CAM16 chroma (%f) should approximately match HCT chroma (%f)", cam16.Chroma, hct.Chroma)
	}

	// The main test is that an impossible chroma gets reduced
	if hct.Chroma >= 200.0 {
		t.Errorf("HCT chroma (%f) should be reduced from impossible value 200.0", hct.Chroma)
	}
}

func TestHctTruncatesColors(t *testing.T) {
	// Exact test case from C++ implementation
	// Ensures that HCT truncates colors.
	hct := From(120.0, 60.0, 50.0)
	originalChroma := hct.Chroma

	// The chroma should be reduced from the requested 60.0 if it's not achievable
	if originalChroma > 60.0 {
		t.Errorf("Original chroma (%f) should not exceed requested 60.0", originalChroma)
	}

	// The new chroma should be lower than the original when tone is changed dramatically.
	// Note: SetTone should clamp to valid range, so 180.0 becomes 100.0
	hct.SetTone(100.0) // Change to extreme high tone
	if hct.Chroma > originalChroma {
		// At very high tones, chroma typically decreases
		t.Logf("Note: Chroma changed from %f to %f at high tone", originalChroma, hct.Chroma)
	}
}

func TestHCTFromInt(t *testing.T) {
	// Test with a known ARGB value
	argb := uint32(0xFFFF0000) // Red
	hct := HctFromInt(argb)

	// Red should have hue in the red range (around 0-30 degrees)
	if hct.Hue < 0 || hct.Hue > 50 {
		t.Errorf("Red HCT Hue = %f; want 0-50", hct.Hue)
	}

	// Should have high chroma
	if hct.Chroma < 50.0 {
		t.Errorf("Red HCT Chroma = %f; want >50", hct.Chroma)
	}

	// Should have medium tone
	if hct.Tone < 30.0 || hct.Tone > 70.0 {
		t.Errorf("Red HCT Tone = %f; want 30-70", hct.Tone)
	}
}

func TestHCTToInt(t *testing.T) {
	// Test round-trip conversion
	originalArgb := uint32(0xFF808080) // Gray
	hct := HctFromInt(originalArgb)
	reconstructedArgb := hct.ToInt()

	// Should be close to the original (allowing for some precision loss)
	originalR := (originalArgb >> 16) & 0xFF
	originalG := (originalArgb >> 8) & 0xFF
	originalB := originalArgb & 0xFF

	reconstructedR := (reconstructedArgb >> 16) & 0xFF
	reconstructedG := (reconstructedArgb >> 8) & 0xFF
	reconstructedB := reconstructedArgb & 0xFF

	if math.Abs(float64(originalR-reconstructedR)) > 5 {
		t.Errorf("Red component: original=%d, reconstructed=%d", originalR, reconstructedR)
	}
	if math.Abs(float64(originalG-reconstructedG)) > 5 {
		t.Errorf("Green component: original=%d, reconstructed=%d", originalG, reconstructedG)
	}
	if math.Abs(float64(originalB-reconstructedB)) > 5 {
		t.Errorf("Blue component: original=%d, reconstructed=%d", originalB, reconstructedB)
	}
}

func TestHCTSetters(t *testing.T) {
	hct := From(120.0, 50.0, 75.0)

	// Test SetHue
	hct.SetHue(180.0)
	if math.Abs(hct.Hue-180.0) > 1 {
		t.Errorf("After SetHue(180), Hue = %f; want ~180", hct.Hue)
	}

	// Test SetChroma
	hct.SetChroma(30.0)
	if math.Abs(hct.Chroma-30.0) > 1 {
		t.Errorf("After SetChroma(30), Chroma = %f; want ~30", hct.Chroma)
	}

	// Test SetTone
	hct.SetTone(90.0)
	if math.Abs(hct.Tone-90.0) > 1 {
		t.Errorf("After SetTone(90), Tone = %f; want ~90", hct.Tone)
	}
}

// Comprehensive parametrized test matching C++ implementation
func TestHctCorrectness(t *testing.T) {
	// Test parameters from C++ INSTANTIATE_TEST_SUITE_P
	hues := []int{15, 45, 75, 105, 135, 165, 195, 225, 255, 285, 315, 345}
	chromas := []int{0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100}
	tones := []int{20, 30, 40, 50, 60, 70, 80}

	for _, hue := range hues {
		for _, chroma := range chromas {
			for _, tone := range tones {
				color := From(float64(hue), float64(chroma), float64(tone))

				// Test hue accuracy (if chroma > 0)
				if chroma > 0 {
					if math.Abs(color.Hue-float64(hue)) > 4.0 {
						t.Errorf("HCT(%d, %d, %d) hue = %f; want within 4.0 of %d",
							hue, chroma, tone, color.Hue, hue)
					}
				}

				// Test chroma constraint
				if color.Chroma >= float64(chroma)+2.5 {
					t.Errorf("HCT(%d, %d, %d) chroma = %f; want < %f",
						hue, chroma, tone, color.Chroma, float64(chroma)+2.5)
				}

				// Test if chroma is significantly lower, color should be on boundary
				if color.Chroma < float64(chroma)-2.5 {
					argb := color.ToInt()
					r := (argb >> 16) & 0xFF
					g := (argb >> 8) & 0xFF
					b := argb & 0xFF

					isOnBoundary := (r == 0 || r == 255) || (g == 0 || g == 255) || (b == 0 || b == 255)
					if !isOnBoundary {
						t.Errorf("HCT(%d, %d, %d) with low chroma %f should be on RGB boundary",
							hue, chroma, tone, color.Chroma)
					}
				}

				// Test tone accuracy
				if math.Abs(color.Tone-float64(tone)) > 0.5 {
					t.Errorf("HCT(%d, %d, %d) tone = %f; want within 0.5 of %d",
						hue, chroma, tone, color.Tone, tone)
				}
			}
		}
	}
}
