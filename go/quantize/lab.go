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

import (
	"math"

	"github.com/material-foundation/material-color-utilities/go/utils"
)

// LabPointProvider provides Lab color space points for quantization.
// Lab color space is more perceptually uniform than RGB.
type LabPointProvider struct{}

// NewLabPointProvider creates a new LabPointProvider.
func NewLabPointProvider() *LabPointProvider {
	return &LabPointProvider{}
}

// FromInt converts an ARGB color to a Lab color point.
func (p *LabPointProvider) FromInt(argb uint32) []float64 {
	lab := utils.LabFromArgb(argb)
	return []float64{lab[0], lab[1], lab[2]}
}

// ToInt converts a Lab color point back to an ARGB color.
func (p *LabPointProvider) ToInt(point []float64) uint32 {
	return utils.ArgbFromLab(point[0], point[1], point[2])
}

// Distance calculates the Euclidean distance between two Lab points.
func (p *LabPointProvider) Distance(a, b []float64) float64 {
	dL := a[0] - b[0]
	dA := a[1] - b[1]
	dB := a[2] - b[2]
	return math.Sqrt(dL*dL + dA*dA + dB*dB)
}