// Copyright 2023 Google LLC
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

import "github.com/material-foundation/material-color-utilities/go/utils"

// ContrastCurve contains a value that changes with the contrast level.
//
// Usually represents the contrast requirements for a dynamic color on its background. The four
// values correspond to values for contrast levels -1.0, 0.0, 0.5, and 1.0, respectively.
type ContrastCurve struct {
	Low    float64 // Value for contrast level -1.0
	Normal float64 // Value for contrast level 0.0
	Medium float64 // Value for contrast level 0.5
	High   float64 // Value for contrast level 1.0
}

// NewContrastCurve creates a ContrastCurve object.
func NewContrastCurve(low, normal, medium, high float64) *ContrastCurve {
	return &ContrastCurve{
		Low:    low,
		Normal: normal,
		Medium: medium,
		High:   high,
	}
}

// LevelNormalized returns the value at a given contrast level.
//
// contrastLevel: The contrast level. 0.0 is the default (normal); -1.0 is the lowest; 1.0 is the highest.
// Returns: The value. For contrast ratios, a number between 1.0 and 21.0.
func (c *ContrastCurve) LevelNormalized(contrastLevel float64) float64 {
	if contrastLevel <= -1.0 {
		return c.Low
	} else if contrastLevel < 0.0 {
		return utils.Lerp(c.Low, c.Normal, (contrastLevel+1)/1)
	} else if contrastLevel < 0.5 {
		return utils.Lerp(c.Normal, c.Medium, contrastLevel/0.5)
	} else if contrastLevel < 1.0 {
		return utils.Lerp(c.Medium, c.High, (contrastLevel-0.5)/0.5)
	} else {
		return c.High
	}
}
