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

// DeltaConstraint describes how to fulfill a tone delta pair constraint.
type DeltaConstraint int

const (
	DeltaConstraintExact DeltaConstraint = iota
	DeltaConstraintNearer
	DeltaConstraintFarther
)

// ToneDeltaPair documents a constraint between two DynamicColors, in which their tones must have a certain
// distance from each other.
//
// Prefer a DynamicColor with a background, this is for special cases when designers want tonal
// distance, literally contrast, between two colors that don't have a background / foreground
// relationship or a contrast guarantee.
type ToneDeltaPair struct {
	// The first role in a pair.
	RoleA *DynamicColor

	// The second role in a pair.
	RoleB *DynamicColor

	// Required difference between tones. Absolute value, negative values have undefined behavior.
	Delta float64

	// The relative relation between tones of roleA and roleB.
	Polarity TonePolarity

	// Whether these two roles should stay on the same side of the "awkward zone" (T50-59).
	// This is necessary for certain cases where we don't want to accidentally hit the awkward zone.
	StayTogether bool
}

// NewToneDeltaPair creates a new ToneDeltaPair.
func NewToneDeltaPair(roleA, roleB *DynamicColor, delta float64, polarity TonePolarity, stayTogether bool) *ToneDeltaPair {
	return &ToneDeltaPair{
		RoleA:        roleA,
		RoleB:        roleB,
		Delta:        delta,
		Polarity:     polarity,
		StayTogether: stayTogether,
	}
}