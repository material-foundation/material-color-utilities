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

import (
	"github.com/material-foundation/material-color-utilities/go/cam"
)

// NewDynamicScheme creates a new DynamicScheme from a source color using default settings.
func NewDynamicScheme(sourceColorArgb uint32, variant Variant, isDark bool, contrastLevel float64) *DynamicScheme {
	return NewDynamicSchemeWithSpec(sourceColorArgb, variant, isDark, contrastLevel, Spec2021, PlatformPhone)
}

// NewDynamicSchemeWithSpec creates a new DynamicScheme with specific spec version and platform.
func NewDynamicSchemeWithSpec(sourceColorArgb uint32, variant Variant, isDark bool, contrastLevel float64, specVersion SpecVersion, platform Platform) *DynamicScheme {
	sourceHct := cam.HctFromInt(sourceColorArgb)
	colorSpec := ByVersion(specVersion)

	return &DynamicScheme{
		SourceColorArgb:       sourceColorArgb,
		Variant:               variant,
		ContrastLevel:         contrastLevel,
		IsDark:                isDark,
		Platform:              platform,
		SpecVersion:           specVersion,
		PrimaryPalette:        colorSpec.PrimaryPalette(variant, sourceHct, isDark, platform, contrastLevel),
		SecondaryPalette:      colorSpec.SecondaryPalette(variant, sourceHct, isDark, platform, contrastLevel),
		TertiaryPalette:       colorSpec.TertiaryPalette(variant, sourceHct, isDark, platform, contrastLevel),
		NeutralPalette:        colorSpec.NeutralPalette(variant, sourceHct, isDark, platform, contrastLevel),
		NeutralVariantPalette: colorSpec.NeutralVariantPalette(variant, sourceHct, isDark, platform, contrastLevel),
		ErrorPalette:          colorSpec.ErrorPalette(variant, sourceHct, isDark, platform, contrastLevel),
	}
}
