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

// Package utils provides color science utilities and color space conversions.
package utils

import "math"

// Color space conversion matrices
var (
	SrgbToXyz = [][]float64{
		{0.41233895, 0.35762064, 0.18051042},
		{0.2126, 0.7152, 0.0722},
		{0.01932141, 0.11916382, 0.95034478},
	}

	XyzToSrgb = [][]float64{
		{3.2413774792388685, -1.5376652402851851, -0.49885366846268053},
		{-0.9691452513005321, 1.8758853451067872, 0.04156585616912061},
		{0.05562093689691305, -0.20395524564742123, 1.0571799111220335},
	}

	LinearSrgbToOklab = [][]float64{
		{0.4122214708, 0.5363325363, 0.0514459929},
		{0.2119034982, 0.6806995451, 0.1073969566},
		{0.0883024619, 0.2817188376, 0.6299787005},
	}

	OklabToLinearSrgb = [][]float64{
		{4.0767416621, -3.3077115913, 0.2309699292},
		{-1.2684380046, 2.6097574011, -0.3413193965},
		{-0.0041960863, -0.7034186147, 1.7076147010},
	}

	WhitePointD65 = []float64{95.047, 100.0, 108.883}
)

// ArgbFromRgb converts RGB components to ARGB format.
func ArgbFromRgb(red, green, blue uint8) uint32 {
	return (0xFF << 24) | (uint32(red) << 16) | (uint32(green) << 8) | uint32(blue)
}

// ArgbFromLinrgb converts linear RGB components to ARGB format.
func ArgbFromLinrgb(linrgb []float64) uint32 {
	r := Delinearized(linrgb[0])
	g := Delinearized(linrgb[1])
	b := Delinearized(linrgb[2])
	return ArgbFromRgb(uint8(r), uint8(g), uint8(b))
}

// AlphaFromArgb returns the alpha component of a color in ARGB format.
func AlphaFromArgb(argb uint32) uint8 {
	return uint8((argb >> 24) & 0xFF)
}

// RedFromArgb returns the red component of a color in ARGB format.
func RedFromArgb(argb uint32) uint8 {
	return uint8((argb >> 16) & 0xFF)
}

// GreenFromArgb returns the green component of a color in ARGB format.
func GreenFromArgb(argb uint32) uint8 {
	return uint8((argb >> 8) & 0xFF)
}

// BlueFromArgb returns the blue component of a color in ARGB format.
func BlueFromArgb(argb uint32) uint8 {
	return uint8(argb & 0xFF)
}

// IsOpaque returns whether a color in ARGB format is opaque.
func IsOpaque(argb uint32) bool {
	return AlphaFromArgb(argb) == 255
}

// ArgbFromXyz converts a color from XYZ to ARGB.
func ArgbFromXyz(x, y, z float64) uint32 {
	matrix := XyzToSrgb
	linearR := matrix[0][0]*x + matrix[0][1]*y + matrix[0][2]*z
	linearG := matrix[1][0]*x + matrix[1][1]*y + matrix[1][2]*z
	linearB := matrix[2][0]*x + matrix[2][1]*y + matrix[2][2]*z
	r := Delinearized(linearR)
	g := Delinearized(linearG)
	b := Delinearized(linearB)
	return ArgbFromRgb(uint8(r), uint8(g), uint8(b))
}

// XyzFromArgb converts a color from ARGB to XYZ.
func XyzFromArgb(argb uint32) []float64 {
	r := Linearized(int(RedFromArgb(argb)))
	g := Linearized(int(GreenFromArgb(argb)))
	b := Linearized(int(BlueFromArgb(argb)))
	return MatrixMultiply([]float64{r, g, b}, SrgbToXyz)
}

// ArgbFromLab converts a color represented in Lab color space into an ARGB integer.
func ArgbFromLab(l, a, b float64) uint32 {
	whitePoint := WhitePointD65
	fy := (l + 16.0) / 116.0
	fx := a/500.0 + fy
	fz := fy - b/200.0
	xNormalized := labInvf(fx)
	yNormalized := labInvf(fy)
	zNormalized := labInvf(fz)
	x := xNormalized * whitePoint[0]
	y := yNormalized * whitePoint[1]
	z := zNormalized * whitePoint[2]
	return ArgbFromXyz(x, y, z)
}

// LabFromArgb converts a color from ARGB representation to L*a*b* representation.
func LabFromArgb(argb uint32) []float64 {
	linearR := Linearized(int(RedFromArgb(argb)))
	linearG := Linearized(int(GreenFromArgb(argb)))
	linearB := Linearized(int(BlueFromArgb(argb)))
	matrix := SrgbToXyz
	x := matrix[0][0]*linearR + matrix[0][1]*linearG + matrix[0][2]*linearB
	y := matrix[1][0]*linearR + matrix[1][1]*linearG + matrix[1][2]*linearB
	z := matrix[2][0]*linearR + matrix[2][1]*linearG + matrix[2][2]*linearB
	whitePoint := WhitePointD65
	xNormalized := x / whitePoint[0]
	yNormalized := y / whitePoint[1]
	zNormalized := z / whitePoint[2]
	fx := labF(xNormalized)
	fy := labF(yNormalized)
	fz := labF(zNormalized)
	l := 116.0*fy - 16
	a := 500.0 * (fx - fy)
	b := 200.0 * (fy - fz)
	return []float64{l, a, b}
}

// ArgbFromLstar converts an L* value to an ARGB representation.
func ArgbFromLstar(lstar float64) uint32 {
	y := YFromLstar(lstar)
	component := Delinearized(y)
	return ArgbFromRgb(uint8(component), uint8(component), uint8(component))
}

// LstarFromArgb computes the L* value of a color in ARGB representation.
func LstarFromArgb(argb uint32) float64 {
	y := XyzFromArgb(argb)[1]
	return 116.0*labF(y/100.0) - 16.0
}

// YFromLstar converts an L* value to a Y value.
func YFromLstar(lstar float64) float64 {
	return 100.0 * labInvf((lstar+16.0)/116.0)
}

// LstarFromY converts a Y value to an L* value.
func LstarFromY(y float64) float64 {
	return labF(y/100.0)*116.0 - 16.0
}

// Linearized converts an RGB component to linear RGB space.
func Linearized(rgbComponent int) float64 {
	normalized := float64(rgbComponent) / 255.0
	if normalized <= 0.040449936 {
		return normalized / 12.92 * 100.0
	}
	return math.Pow((normalized+0.055)/1.055, 2.4) * 100.0
}

// Delinearized converts a linear RGB component to RGB space.
func Delinearized(rgbComponent float64) int {
	normalized := rgbComponent / 100.0
	var delinearized float64
	if normalized <= 0.0031308 {
		delinearized = normalized * 12.92
	} else {
		delinearized = 1.055*math.Pow(normalized, 1.0/2.4) - 0.055
	}
	return clampInt(0, 255, int(math.Round(delinearized*255.0)))
}

// labF is the LAB conversion function.
func labF(t float64) float64 {
	e := 216.0 / 24389.0
	kappa := 24389.0 / 27.0
	if t > e {
		return math.Pow(t, 1.0/3.0)
	}
	return (kappa*t + 16.0) / 116.0
}

// labInvf is the inverse of the LAB conversion function.
func labInvf(ft float64) float64 {
	e := 216.0 / 24389.0
	kappa := 24389.0 / 27.0
	ft3 := ft * ft * ft
	if ft3 > e {
		return ft3
	}
	return (116.0*ft - 16.0) / kappa
}

func clampInt(min, max, value int) int {
	if value < min {
		return min
	}
	if value > max {
		return max
	}
	return value
}

// OklabFromArgb converts a color from ARGB to OKLAB.
func OklabFromArgb(argb uint32) []float64 {
	linearR := Linearized(int(RedFromArgb(argb))) / 100.0
	linearG := Linearized(int(GreenFromArgb(argb))) / 100.0
	linearB := Linearized(int(BlueFromArgb(argb))) / 100.0
	
	l := 0.4122214708*linearR + 0.5363325363*linearG + 0.0514459929*linearB
	m := 0.2119034982*linearR + 0.6806995451*linearG + 0.1073969566*linearB
	s := 0.0883024619*linearR + 0.2817188376*linearG + 0.6299787005*linearB
	
	l_ := math.Cbrt(l)
	m_ := math.Cbrt(m)
	s_ := math.Cbrt(s)
	
	return []float64{
		0.2104542553*l_ + 0.7936177850*m_ - 0.0040720468*s_,
		1.9779984951*l_ - 2.4285922050*m_ + 0.4505937099*s_,
		0.0259040371*l_ + 0.7827717662*m_ - 0.8086757660*s_,
	}
}

// ArgbFromOklab converts a color from OKLAB to ARGB.
func ArgbFromOklab(l, a, b float64) uint32 {
	l_ := l + 0.3963377774*a + 0.2158037573*b
	m_ := l - 0.1055613458*a - 0.0638541728*b
	s_ := l - 0.0894841775*a - 1.2914855480*b
	
	l_cubed := l_ * l_ * l_
	m_cubed := m_ * m_ * m_
	s_cubed := s_ * s_ * s_
	
	linearR := 4.0767416621*l_cubed - 3.3077115913*m_cubed + 0.2309699292*s_cubed
	linearG := -1.2684380046*l_cubed + 2.6097574011*m_cubed - 0.3413193965*s_cubed
	linearB := -0.0041960863*l_cubed - 0.7034186147*m_cubed + 1.7076147010*s_cubed
	
	r := Delinearized(linearR * 100.0)
	g := Delinearized(linearG * 100.0)
	bInt := Delinearized(linearB * 100.0)
	
	return ArgbFromRgb(uint8(r), uint8(g), uint8(bInt))
}

// OklabAFromArgb converts a color from ARGB to OKLAB with alpha.
func OklabAFromArgb(argb uint32) []float64 {
	oklab := OklabFromArgb(argb)
	alpha := float64(AlphaFromArgb(argb)) / 255.0
	return []float64{oklab[0], oklab[1], oklab[2], alpha}
}

// ArgbFromOklabA converts a color from OKLAB with alpha to ARGB.
func ArgbFromOklabA(l, a, b, alpha float64) uint32 {
	argb := ArgbFromOklab(l, a, b)
	alphaByte := uint8(alpha * 255.0)
	return (uint32(alphaByte) << 24) | (argb & 0x00FFFFFF)
}

// OklchFromArgb converts a color from ARGB to OKLCH.
func OklchFromArgb(argb uint32) []float64 {
	oklab := OklabFromArgb(argb)
	return oklchFromOklab(oklab[0], oklab[1], oklab[2])
}

// ArgbFromOklch converts a color from OKLCH to ARGB.
func ArgbFromOklch(l, c, h float64) uint32 {
	oklab := oklabFromOklch(l, c, h)
	return ArgbFromOklab(oklab[0], oklab[1], oklab[2])
}

// OklchAFromArgb converts a color from ARGB to OKLCH with alpha.
func OklchAFromArgb(argb uint32) []float64 {
	oklch := OklchFromArgb(argb)
	alpha := float64(AlphaFromArgb(argb)) / 255.0
	return []float64{oklch[0], oklch[1], oklch[2], alpha}
}

// ArgbFromOklchA converts a color from OKLCH with alpha to ARGB.
func ArgbFromOklchA(l, c, h, alpha float64) uint32 {
	argb := ArgbFromOklch(l, c, h)
	alphaByte := uint8(alpha * 255.0)
	return (uint32(alphaByte) << 24) | (argb & 0x00FFFFFF)
}

// oklchFromOklab converts OKLAB to OKLCH.
func oklchFromOklab(l, a, b float64) []float64 {
	c := math.Sqrt(a*a + b*b)
	h := math.Atan2(b, a) * 180.0 / math.Pi
	if h < 0 {
		h += 360.0
	}
	return []float64{l, c, h}
}

// oklabFromOklch converts OKLCH to OKLAB.
func oklabFromOklch(l, c, h float64) []float64 {
	hRad := h * math.Pi / 180.0
	a := c * math.Cos(hRad)
	b := c * math.Sin(hRad)
	return []float64{l, a, b}
}

// LabAFromArgb converts a color from ARGB to L*a*b* with alpha.
func LabAFromArgb(argb uint32) []float64 {
	lab := LabFromArgb(argb)
	alpha := float64(AlphaFromArgb(argb)) / 255.0
	return []float64{lab[0], lab[1], lab[2], alpha}
}

// ArgbFromLabA converts a color from L*a*b* with alpha to ARGB.
func ArgbFromLabA(l, a, b, alpha float64) uint32 {
	argb := ArgbFromLab(l, a, b)
	alphaByte := uint8(alpha * 255.0)
	return (uint32(alphaByte) << 24) | (argb & 0x00FFFFFF)
}

// XyzAFromArgb converts a color from ARGB to XYZ with alpha.
func XyzAFromArgb(argb uint32) []float64 {
	xyz := XyzFromArgb(argb)
	alpha := float64(AlphaFromArgb(argb)) / 255.0
	return []float64{xyz[0], xyz[1], xyz[2], alpha}
}

// ArgbFromXyzA converts a color from XYZ with alpha to ARGB.
func ArgbFromXyzA(x, y, z, alpha float64) uint32 {
	argb := ArgbFromXyz(x, y, z)
	alphaByte := uint8(alpha * 255.0)
	return (uint32(alphaByte) << 24) | (argb & 0x00FFFFFF)
}
