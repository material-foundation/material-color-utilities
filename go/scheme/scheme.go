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

// Package scheme provides Material Design color scheme generation.
package scheme

import (
	"github.com/material-foundation/material-color-utilities/go/palettes"
)

// Scheme represents a Material color scheme, a mapping of color roles to colors.
type Scheme struct {
	Primary, OnPrimary                               uint32
	PrimaryContainer, OnPrimaryContainer             uint32
	Secondary, OnSecondary                           uint32
	SecondaryContainer, OnSecondaryContainer         uint32
	Tertiary, OnTertiary                             uint32
	TertiaryContainer, OnTertiaryContainer           uint32
	Error, OnError                                   uint32
	ErrorContainer, OnErrorContainer                 uint32
	Background, OnBackground                         uint32
	Surface, OnSurface                               uint32
	SurfaceVariant, OnSurfaceVariant                 uint32
	Outline, OutlineVariant                          uint32
	Shadow, Scrim                                    uint32
	InverseSurface, InverseOnSurface, InversePrimary uint32
}

// Light creates a light theme Scheme from a source color in ARGB.
func Light(argb uint32) *Scheme {
	return lightFromCorePalette(palettes.Of(argb))
}

// Dark creates a dark theme Scheme from a source color in ARGB.
func Dark(argb uint32) *Scheme {
	return darkFromCorePalette(palettes.Of(argb))
}

// LightContent creates a light theme content-based Scheme from a source color in ARGB.
func LightContent(argb uint32) *Scheme {
	return lightFromCorePalette(palettes.ContentOf(argb))
}

// DarkContent creates a dark theme content-based Scheme from a source color in ARGB.
func DarkContent(argb uint32) *Scheme {
	return darkFromCorePalette(palettes.ContentOf(argb))
}

// lightFromCorePalette creates a light scheme from a core palette.
func lightFromCorePalette(core *palettes.Core) *Scheme {
	return &Scheme{
		Primary:              core.A1.Tone(40),
		OnPrimary:            core.A1.Tone(100),
		PrimaryContainer:     core.A1.Tone(90),
		OnPrimaryContainer:   core.A1.Tone(10),
		Secondary:            core.A2.Tone(40),
		OnSecondary:          core.A2.Tone(100),
		SecondaryContainer:   core.A2.Tone(90),
		OnSecondaryContainer: core.A2.Tone(10),
		Tertiary:             core.A3.Tone(40),
		OnTertiary:           core.A3.Tone(100),
		TertiaryContainer:    core.A3.Tone(90),
		OnTertiaryContainer:  core.A3.Tone(10),
		Error:                core.Error.Tone(40),
		OnError:              core.Error.Tone(100),
		ErrorContainer:       core.Error.Tone(90),
		OnErrorContainer:     core.Error.Tone(10),
		Background:           core.N1.Tone(99),
		OnBackground:         core.N1.Tone(10),
		Surface:              core.N1.Tone(99),
		OnSurface:            core.N1.Tone(10),
		SurfaceVariant:       core.N2.Tone(90),
		OnSurfaceVariant:     core.N2.Tone(30),
		Outline:              core.N2.Tone(50),
		OutlineVariant:       core.N2.Tone(80),
		Shadow:               core.N1.Tone(0),
		Scrim:                core.N1.Tone(0),
		InverseSurface:       core.N1.Tone(20),
		InverseOnSurface:     core.N1.Tone(95),
		InversePrimary:       core.A1.Tone(80),
	}
}

// darkFromCorePalette creates a dark scheme from a core palette.
func darkFromCorePalette(core *palettes.Core) *Scheme {
	return &Scheme{
		Primary:              core.A1.Tone(80),
		OnPrimary:            core.A1.Tone(20),
		PrimaryContainer:     core.A1.Tone(30),
		OnPrimaryContainer:   core.A1.Tone(90),
		Secondary:            core.A2.Tone(80),
		OnSecondary:          core.A2.Tone(20),
		SecondaryContainer:   core.A2.Tone(30),
		OnSecondaryContainer: core.A2.Tone(90),
		Tertiary:             core.A3.Tone(80),
		OnTertiary:           core.A3.Tone(20),
		TertiaryContainer:    core.A3.Tone(30),
		OnTertiaryContainer:  core.A3.Tone(90),
		Error:                core.Error.Tone(80),
		OnError:              core.Error.Tone(20),
		ErrorContainer:       core.Error.Tone(30),
		OnErrorContainer:     core.Error.Tone(80),
		Background:           core.N1.Tone(10),
		OnBackground:         core.N1.Tone(90),
		Surface:              core.N1.Tone(10),
		OnSurface:            core.N1.Tone(90),
		SurfaceVariant:       core.N2.Tone(30),
		OnSurfaceVariant:     core.N2.Tone(80),
		Outline:              core.N2.Tone(60),
		OutlineVariant:       core.N2.Tone(30),
		Shadow:               core.N1.Tone(0),
		Scrim:                core.N1.Tone(0),
		InverseSurface:       core.N1.Tone(90),
		InverseOnSurface:     core.N1.Tone(20),
		InversePrimary:       core.A1.Tone(40),
	}
}
