// Package hctconverter provides functions for converting between RGB and HCT
// color encodings.
package hctconverter

/*
#cgo LDFLAGS: -L libs -lmaterial-colors -lmaterial_color_utilities_lib -lm
#include "cpp/src/mylib/mylib.h"
*/
import "C"

// HCTToRGB converts a HCT-encoded color to an RGB-encoded one.
func HCTToRGB(hue, chroma, tone float64) (red, green, blue int) {
	cHCT := C.BuildHct(C.double(hue), C.double(chroma), C.double(tone))
	cRGB := C.HctToRgb(cHCT)
	return int(cRGB.Red), int(cRGB.Green), int(cRGB.Blue)
}

// RGBToHCT converts an RGB-encoded color to a HCT-encoded one.
func RGBToHCT(red, green, blue int) (hue, chroma, tone float64) {
	cRGB := C.BuildRgb(C.int(red), C.int(green), C.int(blue))
	cHCT := C.RgbToHct(cRGB)
	return float64(cHCT.Hue), float64(cHCT.Chroma), float64(cHCT.Tone)
}
