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

package dislike

import (
	"testing"

	"github.com/material-foundation/material-color-utilities/go/cam"
)

func TestSkinToneColorsLiked(t *testing.T) {
	// Monk Skin Tone Scale colors from C++ tests - these should all be liked
	skinToneColors := []uint32{
		0xfff6ede4, 0xfff3e7db, 0xfff7ead0, 0xffeadaba,
		0xffd7bd96, 0xffa07e56, 0xff825c43, 0xff604134,
		0xff3a312a, 0xff292420,
	}

	for _, argb := range skinToneColors {
		hct := cam.HctFromInt(argb)
		if IsDisliked(hct) {
			t.Errorf("Skin tone color 0x%08X should not be disliked", argb)
		}
	}
}

func TestBileColorsDisliked(t *testing.T) {
	// Bile colors from C++ tests - these should all be disliked
	bileColors := []uint32{
		0xff95884B, 0xff716B40, 0xffB08E00, 0xff4C4308, 0xff464521,
	}

	for _, argb := range bileColors {
		hct := cam.HctFromInt(argb)
		if !IsDisliked(hct) {
			t.Errorf("Bile color 0x%08X should be disliked", argb)
		}
	}
}

func TestBileColorsFix(t *testing.T) {
	// Test fixing bile colors from C++ tests
	bileColors := []uint32{
		0xff95884B, 0xff716B40, 0xffB08E00, 0xff4C4308, 0xff464521,
	}

	for _, argb := range bileColors {
		bileHct := cam.HctFromInt(argb)
		if !IsDisliked(bileHct) {
			t.Errorf("Original bile color 0x%08X should be disliked", argb)
			continue
		}

		fixedHct := FixIfDisliked(bileHct)
		if IsDisliked(fixedHct) {
			t.Errorf("Fixed bile color should not be disliked")
		}
	}
}

func TestTone67Liked(t *testing.T) {
	// Exact test case from C++ implementation
	hct := cam.From(100.0, 50.0, 67.0)
	if IsDisliked(hct) {
		t.Error("Color with tone 67 should not be disliked")
	}

	fixedHct := FixIfDisliked(hct)
	if fixedHct.ToInt() != hct.ToInt() {
		t.Error("Non-disliked color should not be changed by FixIfDisliked")
	}
}
