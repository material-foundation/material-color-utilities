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

// TonePolarity describes the relationship in lightness between two colors.
//
// 'RelativeDarker' and 'RelativeLighter' describes the tone adjustment relative to the surface
// color trend (white in light mode; black in dark mode). For instance, ToneDeltaPair(A, B, 10,
// 'RelativeLighter', 'Farther') states that A should be at least 10 lighter than B in light mode,
// and at least 10 darker than B in dark mode.
//
// See `ToneDeltaPair` for details.
type TonePolarity int

const (
	TonePolarityDarker TonePolarity = iota
	TonePolarityLighter
	TonePolarityRelativeDarker
	TonePolarityRelativeLighter
)
