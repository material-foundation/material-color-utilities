package hctconverter

/*
#cgo LDFLAGS: -L libs -lmaterial-colors -lmaterial_color_utilities_lib -lm
#include "cpp/src/mylib/mylib.h"
*/
import "C"

import "math"

func HCTToRGB(hue, chroma, tone int) (red, green, blue int) {
	cHCT := C.BuildHct(C.double(hue), C.double(chroma), C.double(tone))
	cRGB := C.HctToRgb(cHCT)
	return int(cRGB.Red), int(cRGB.Green), int(cRGB.Blue)
}

func RGBToHCT(red, green, blue int) (hue, chroma, tone int) {
	cRGB := C.BuildRgb(C.int(red), C.int(green), C.int(blue))
	cHCT := C.RgbToHct(cRGB)
	hue = int(math.Round(float64(cHCT.Hue)))
	chroma = int(math.Round(float64(cHCT.Chroma)))
	tone = int(math.Round(float64(cHCT.Tone)))
	return
}
