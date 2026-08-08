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

	"github.com/material-foundation/material-color-utilities/go/utils"
)

// Color space conversion matrices
var (
	// XyzToCam16Rgb transforms XYZ color space coordinates to 'cone'/'RGB' responses in CAM16
	XyzToCam16Rgb = [][]float64{
		{0.401288, 0.650173, -0.051461},
		{-0.250268, 1.204414, 0.045854},
		{-0.002079, 0.048952, 0.953127},
	}

	// Cam16RgbToXyz transforms 'cone'/'RGB' responses in CAM16 to XYZ color space coordinates
	Cam16RgbToXyz = [][]float64{
		{1.8620678, -1.0112547, 0.14918678},
		{0.38752654, 0.62144744, -0.00897398},
		{-0.01584150, -0.03412294, 1.0499644},
	}
)

// Cam16 represents a color in the CAM16 color appearance model.
// CAM16 is a color appearance model where colors are not just defined by their
// hex code, but rather by a hex code and viewing conditions.
type Cam16 struct {
	// CAM16 color dimensions
	Hue    float64 // Hue in CAM16
	Chroma float64 // Chroma in CAM16
	J      float64 // Lightness in CAM16
	Q      float64 // Brightness in CAM16
	M      float64 // Colorfulness in CAM16
	S      float64 // Saturation in CAM16

	// Coordinates in UCS space, used to determine color distance
	Jstar float64 // Lightness coordinate in CAM16-UCS
	Astar float64 // a* coordinate in CAM16-UCS
	Bstar float64 // b* coordinate in CAM16-UCS
}

// Distance calculates the distance between two CAM16 colors in CAM16-UCS space.
func (c *Cam16) Distance(other *Cam16) float64 {
	dJ := c.Jstar - other.Jstar
	dA := c.Astar - other.Astar
	dB := c.Bstar - other.Bstar
	dEPrime := math.Sqrt(dJ*dJ + dA*dA + dB*dB)
	dE := 1.41 * math.Pow(dEPrime, 0.63)
	return dE
}

// FromInt creates a CAM16 color from ARGB representation, assuming default viewing conditions.
func FromInt(argb uint32) *Cam16 {
	return FromIntInViewingConditions(argb, DefaultViewingConditions)
}

// FromIntInViewingConditions creates a CAM16 color from ARGB in specified viewing conditions.
func FromIntInViewingConditions(argb uint32, viewingConditions *ViewingConditions) *Cam16 {
	red := float64(utils.RedFromArgb(argb))
	green := float64(utils.GreenFromArgb(argb))
	blue := float64(utils.BlueFromArgb(argb))
	redL := utils.Linearized(int(red))
	greenL := utils.Linearized(int(green))
	blueL := utils.Linearized(int(blue))

	x := 0.41233895*redL + 0.35762064*greenL + 0.18051042*blueL
	y := 0.2126*redL + 0.7152*greenL + 0.0722*blueL
	z := 0.01932141*redL + 0.11916382*greenL + 0.95034478*blueL

	matrix := XyzToCam16Rgb
	rC := x*matrix[0][0] + y*matrix[0][1] + z*matrix[0][2]
	gC := x*matrix[1][0] + y*matrix[1][1] + z*matrix[1][2]
	bC := x*matrix[2][0] + y*matrix[2][1] + z*matrix[2][2]

	rD := viewingConditions.RgbD[0] * rC
	gD := viewingConditions.RgbD[1] * gC
	bD := viewingConditions.RgbD[2] * bC

	rAF := math.Pow(viewingConditions.Fl*math.Abs(rD)/100.0, 0.42)
	gAF := math.Pow(viewingConditions.Fl*math.Abs(gD)/100.0, 0.42)
	bAF := math.Pow(viewingConditions.Fl*math.Abs(bD)/100.0, 0.42)

	rA := utils.Signum(rD) * 400.0 * rAF / (rAF + 27.13)
	gA := utils.Signum(gD) * 400.0 * gAF / (gAF + 27.13)
	bA := utils.Signum(bD) * 400.0 * bAF / (bAF + 27.13)

	a := (11.0*rA + (-12.0)*gA + bA) / 11.0
	b := (rA + gA - 2.0*bA) / 9.0

	u := (20.0*rA + 20.0*gA + 21.0*bA) / 20.0
	p2 := (40.0*rA + 20.0*gA + bA) / 20.0

	atan2 := math.Atan2(b, a)
	atanDegrees := atan2 * 180.0 / math.Pi
	hue := utils.SanitizeDegreesDouble(atanDegrees)
	if hue < 0 {
		hue += 360.0
	}

	ac := p2 * viewingConditions.Nbb

	j := 100.0 * math.Pow(ac/viewingConditions.Aw, viewingConditions.C*viewingConditions.Z)

	q := (4.0 / viewingConditions.C) * math.Sqrt(j/100.0) *
		(viewingConditions.Aw + 4.0) * viewingConditions.FlRoot

	huePrime := hue
	if hue < 20.14 {
		huePrime += 360
	}

	eHue := 0.25 * (math.Cos(huePrime*math.Pi/180.0+2.0) + 3.8)
	p1 := 50000.0 / 13.0 * eHue * viewingConditions.Nc * viewingConditions.Ncb
	t := p1 * math.Sqrt(a*a+b*b) / (u + 0.305)
	alpha := math.Pow(t, 0.9) * math.Pow(1.64-math.Pow(0.29, viewingConditions.N), 0.73)

	c := alpha * math.Sqrt(j/100.0)
	m := c * viewingConditions.FlRoot
	s := 50.0 * math.Sqrt((alpha*viewingConditions.C)/(viewingConditions.Aw+4.0))

	jstar := (1.0 + 100.0*0.007) * j / (1.0 + 0.007*j)
	mstar := 1.0 / 0.0228 * math.Log(1.0+0.0228*m)
	astar := mstar * math.Cos(hue*math.Pi/180.0)
	bstar := mstar * math.Sin(hue*math.Pi/180.0)

	return &Cam16{
		Hue:    hue,
		Chroma: c,
		J:      j,
		Q:      q,
		M:      m,
		S:      s,
		Jstar:  jstar,
		Astar:  astar,
		Bstar:  bstar,
	}
}

// FromJch creates a CAM16 color from J (lightness), C (chroma), and H (hue).
func FromJch(j, c, h float64) *Cam16 {
	return FromJchInViewingConditions(j, c, h, DefaultViewingConditions)
}

// FromJchInViewingConditions creates a CAM16 color from JCH in specified viewing conditions.
func FromJchInViewingConditions(j, c, h float64, viewingConditions *ViewingConditions) *Cam16 {
	q := (4.0 / viewingConditions.C) * math.Sqrt(j/100.0) *
		(viewingConditions.Aw + 4.0) * viewingConditions.FlRoot

	m := c * viewingConditions.FlRoot
	alpha := c / math.Sqrt(j/100.0)
	s := 50.0 * math.Sqrt((alpha*viewingConditions.C)/(viewingConditions.Aw+4.0))

	hueRadians := h * math.Pi / 180.0
	jstar := (1.0 + 100.0*0.007) * j / (1.0 + 0.007*j)
	mstar := 1.0 / 0.0228 * math.Log(1.0+0.0228*m)
	astar := mstar * math.Cos(hueRadians)
	bstar := mstar * math.Sin(hueRadians)

	return &Cam16{
		Hue:    h,
		Chroma: c,
		J:      j,
		Q:      q,
		M:      m,
		S:      s,
		Jstar:  jstar,
		Astar:  astar,
		Bstar:  bstar,
	}
}

// FromUcs creates a CAM16 color from CAM16-UCS coordinates.
func FromUcs(jstar, astar, bstar float64) *Cam16 {
	return FromUcsInViewingConditions(jstar, astar, bstar, DefaultViewingConditions)
}

// FromUcsInViewingConditions creates a CAM16 color from UCS coordinates in specified viewing conditions.
func FromUcsInViewingConditions(jstar, astar, bstar float64, viewingConditions *ViewingConditions) *Cam16 {
	a := astar
	b := bstar
	m := math.Sqrt(a*a + b*b)
	M := (math.Exp(m*0.0228) - 1.0) / 0.0228
	c := M / viewingConditions.FlRoot
	h := math.Atan2(b, a) * 180.0 / math.Pi
	if h < 0.0 {
		h += 360.0
	}
	j := jstar / (1.0 - (jstar-100.0)*0.007)

	return FromJchInViewingConditions(j, c, h, viewingConditions)
}

// ToInt converts the CAM16 color to ARGB representation.
func (c *Cam16) ToInt() uint32 {
	return c.ViewedInViewingConditions(DefaultViewingConditions)
}

// ViewedInViewingConditions converts the CAM16 color to ARGB in specified viewing conditions.
func (c *Cam16) ViewedInViewingConditions(viewingConditions *ViewingConditions) uint32 {
	alpha := 0.0
	if c.Chroma != 0.0 && c.J != 0.0 {
		alpha = c.Chroma / math.Sqrt(c.J/100.0)
	}

	t := math.Pow(alpha/math.Pow(1.64-math.Pow(0.29, viewingConditions.N), 0.73), 1.0/0.9)
	hRad := c.Hue * math.Pi / 180.0

	eHue := 0.25 * (math.Cos(hRad+2.0) + 3.8)
	ac := viewingConditions.Aw * math.Pow(c.J/100.0, 1.0/viewingConditions.C/viewingConditions.Z)
	p1 := eHue * (50000.0 / 13.0) * viewingConditions.Nc * viewingConditions.Ncb
	p2 := ac / viewingConditions.Nbb

	hSin := math.Sin(hRad)
	hCos := math.Cos(hRad)

	gamma := 23.0 * (p2 + 0.305) * t / (23.0*p1 + 11.0*t*hCos + 108.0*t*hSin)
	a := gamma * hCos
	b := gamma * hSin
	rA := (460.0*p2 + 451.0*a + 288.0*b) / 1403.0
	gA := (460.0*p2 - 891.0*a - 261.0*b) / 1403.0
	bA := (460.0*p2 - 220.0*a - 6300.0*b) / 1403.0

	rCBase := math.Max(0, (27.13*math.Abs(rA))/(400.0-math.Abs(rA)))
	rC := utils.Signum(rA) * (100.0 / viewingConditions.Fl) * math.Pow(rCBase, 1.0/0.42)
	gCBase := math.Max(0, (27.13*math.Abs(gA))/(400.0-math.Abs(gA)))
	gC := utils.Signum(gA) * (100.0 / viewingConditions.Fl) * math.Pow(gCBase, 1.0/0.42)
	bCBase := math.Max(0, (27.13*math.Abs(bA))/(400.0-math.Abs(bA)))
	bC := utils.Signum(bA) * (100.0 / viewingConditions.Fl) * math.Pow(bCBase, 1.0/0.42)

	rF := rC / viewingConditions.RgbD[0]
	gF := gC / viewingConditions.RgbD[1]
	bF := bC / viewingConditions.RgbD[2]

	matrix := Cam16RgbToXyz
	x := rF*matrix[0][0] + gF*matrix[0][1] + bF*matrix[0][2]
	y := rF*matrix[1][0] + gF*matrix[1][1] + bF*matrix[1][2]
	z := rF*matrix[2][0] + gF*matrix[2][1] + bF*matrix[2][2]

	argb := utils.ArgbFromXyz(x, y, z)
	return argb
}
