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
	"image"
	"image/color"
)

// FromImage extracts ARGB pixel data from a standard Go image.Image.
// Returns a slice of uint32 values representing ARGB colors.
func FromImage(img image.Image) []uint32 {
	bounds := img.Bounds()
	width := bounds.Dx()
	height := bounds.Dy()
	
	pixels := make([]uint32, width*height)
	
	for y := bounds.Min.Y; y < bounds.Max.Y; y++ {
		for x := bounds.Min.X; x < bounds.Max.X; x++ {
			c := img.At(x, y)
			pixels[(y-bounds.Min.Y)*width+(x-bounds.Min.X)] = colorToARGB(c)
		}
	}
	
	return pixels
}

// FromImageSubset extracts ARGB pixel data from a rectangular region of an image.
// The region is defined by the given bounds rectangle.
func FromImageSubset(img image.Image, region image.Rectangle) []uint32 {
	bounds := img.Bounds().Intersect(region)
	if bounds.Empty() {
		return []uint32{}
	}
	
	width := bounds.Dx()
	height := bounds.Dy()
	pixels := make([]uint32, width*height)
	
	for y := bounds.Min.Y; y < bounds.Max.Y; y++ {
		for x := bounds.Min.X; x < bounds.Max.X; x++ {
			c := img.At(x, y)
			pixels[(y-bounds.Min.Y)*width+(x-bounds.Min.X)] = colorToARGB(c)
		}
	}
	
	return pixels
}

// FromImageSampled extracts ARGB pixel data by sampling every nth pixel.
// This is useful for large images where you want to reduce processing time.
// A step of 1 extracts every pixel, 2 extracts every other pixel, etc.
func FromImageSampled(img image.Image, step int) []uint32 {
	if step < 1 {
		step = 1
	}
	
	bounds := img.Bounds()
	var pixels []uint32
	
	for y := bounds.Min.Y; y < bounds.Max.Y; y += step {
		for x := bounds.Min.X; x < bounds.Max.X; x += step {
			c := img.At(x, y)
			pixels = append(pixels, colorToARGB(c))
		}
	}
	
	return pixels
}

// colorToARGB converts a Go color.Color to ARGB uint32 format.
func colorToARGB(c color.Color) uint32 {
	// Convert to RGBA values (0-65535 range)
	r, g, b, a := c.RGBA()
	
	// Convert to 8-bit values (0-255 range)
	r8 := uint32(r >> 8)
	g8 := uint32(g >> 8)
	b8 := uint32(b >> 8)
	a8 := uint32(a >> 8)
	
	// Pack into ARGB format
	return (a8 << 24) | (r8 << 16) | (g8 << 8) | b8
}