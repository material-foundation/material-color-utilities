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

// Package dislike provides utilities to check and fix universally disliked colors.
package dislike

import (
	"math"

	"github.com/material-foundation/material-color-utilities/go/cam"
)

// IsDisliked returns true if color is disliked.
//
// Disliked is defined as a dark yellow-green that is not neutral.
//
// Color science studies of color preference indicate universal distaste for dark yellow-greens,
// and also show this is correlated to distaste for biological waste and rotting food.
//
// See Palmer and Schloss, 2010 or Schloss and Palmer's Chapter 21 in Handbook of Color
// Psychology (2015).
func IsDisliked(hct *cam.HCT) bool {
	huePasses := math.Round(hct.Hue) >= 90.0 && math.Round(hct.Hue) <= 111.0
	chromaPasses := math.Round(hct.Chroma) > 16.0
	tonePasses := math.Round(hct.Tone) < 65.0

	return huePasses && chromaPasses && tonePasses
}

// FixIfDisliked returns the color, lightened if it is disliked to make it likable.
func FixIfDisliked(hct *cam.HCT) *cam.HCT {
	if IsDisliked(hct) {
		return cam.From(hct.Hue, hct.Chroma, 70.0)
	}

	return hct
}
