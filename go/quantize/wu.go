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
	"github.com/material-foundation/material-color-utilities/go/utils"
)

// Direction represents the axis direction for cube cutting.
type Direction int

const (
	DirectionRed Direction = iota
	DirectionGreen
	DirectionBlue
)

// Wu implements Wu's color quantization algorithm.
// An image quantizer that divides the image's pixels into clusters by recursively cutting an RGB
// cube, based on the weight of pixels in each area of the cube.
//
// The algorithm was described by Xiaolin Wu in Graphic Gems II, published in 1991.
type Wu struct {
	weights  []int
	momentsR []int
	momentsG []int
	momentsB []int
	moments  []float64
	cubes    []*Box
}

// Box represents a 3D RGB cube for quantization.
type Box struct {
	r0, r1 int
	g0, g1 int
	b0, b1 int
	vol    int
}

// MaximizeResult holds the result of the maximize operation.
type maximizeResult struct {
	cutLocation int // < 0 if cut impossible
	maximum     float64
}

// CreateBoxesResult holds the result of the createBoxes operation.
type createBoxesResult struct {
	requestedCount int
	resultCount    int
}

// A histogram of all the input colors is constructed. It has the shape of a
// cube. The cube would be too large if it contained all 16 million colors:
// historical best practice is to use 5 bits of the 8 in each channel,
// reducing the histogram to a volume of ~32,000.
const (
	indexBits  = 5
	indexCount = 33    // ((1 << indexBits) + 1)
	totalSize  = 35937 // indexCount * indexCount * indexCount
)

// NewWu creates a new Wu quantizer instance.
func NewWu() *Wu {
	return &Wu{}
}

// Quantize reduces the number of colors in the input pixels using Wu's algorithm.
func (w *Wu) Quantize(pixels []uint32, colorCount int) map[uint32]int {
	// Step 1: Build histogram from input pixels
	pixelCounts := make(map[uint32]int)
	for _, px := range pixels {
		pixelCounts[px]++
	}

	if len(pixelCounts) == 0 {
		return map[uint32]int{}
	}

	// Step 2: Construct histogram and moments
	w.constructHistogram(pixelCounts)
	w.createMoments()

	// Step 3: Split the color space into boxes
	boxesResult := w.createBoxes(colorCount)
	palette := w.createResult(boxesResult.resultCount)

	// Step 4: Map each input pixel to its quantized color
	colorMap := make(map[uint32]int)
	for _, px := range pixels {
		minDist := -1.0
		bestIdx := 0
		r := int(utils.RedFromArgb(px))
		g := int(utils.GreenFromArgb(px))
		b := int(utils.BlueFromArgb(px))
		for i, color := range palette {
			pr := int(utils.RedFromArgb(color))
			pg := int(utils.GreenFromArgb(color))
			pb := int(utils.BlueFromArgb(color))
			dr := float64(r - pr)
			dg := float64(g - pg)
			db := float64(b - pb)
			dist := dr*dr + dg*dg + db*db
			if minDist < 0 || dist < minDist {
				minDist = dist
				bestIdx = i
			}
		}
		colorMap[palette[bestIdx]]++
	}
	return colorMap
}

// rgbIdx calculates the index in the 3D histogram for given RGB coordinates.
func rgbIdx(r, g, b int) int {
	return (r << (indexBits * 2)) + (r << (indexBits + 1)) + r + (g << indexBits) + g + b
}

// constructHistogram builds the 3D histogram from the input pixels.
func (w *Wu) constructHistogram(pixels map[uint32]int) {
	w.weights = make([]int, totalSize)
	w.momentsR = make([]int, totalSize)
	w.momentsG = make([]int, totalSize)
	w.momentsB = make([]int, totalSize)
	w.moments = make([]float64, totalSize)

	for pixel, count := range pixels {
		red := int(utils.RedFromArgb(pixel))
		green := int(utils.GreenFromArgb(pixel))
		blue := int(utils.BlueFromArgb(pixel))

		bitsToRemove := 8 - indexBits
		iR := (red >> bitsToRemove) + 1
		iG := (green >> bitsToRemove) + 1
		iB := (blue >> bitsToRemove) + 1

		idx := rgbIdx(iR, iG, iB)
		w.weights[idx] += count
		w.momentsR[idx] += red * count
		w.momentsG[idx] += green * count
		w.momentsB[idx] += blue * count
		w.moments[idx] += float64(count) * float64((red*red)+(green*green)+(blue*blue))
	}
}

// createMoments computes the moments for variance calculation.
func (w *Wu) createMoments() {
	for r := 1; r < indexCount; r++ {
		area := make([]int, indexCount)
		areaR := make([]int, indexCount)
		areaG := make([]int, indexCount)
		areaB := make([]int, indexCount)
		area2 := make([]float64, indexCount)

		for g := 1; g < indexCount; g++ {
			line := 0
			lineR := 0
			lineG := 0
			lineB := 0
			line2 := 0.0

			for b := 1; b < indexCount; b++ {
				idx := rgbIdx(r, g, b)
				line += w.weights[idx]
				lineR += w.momentsR[idx]
				lineG += w.momentsG[idx]
				lineB += w.momentsB[idx]
				line2 += w.moments[idx]

				area[b] += line
				areaR[b] += lineR
				areaG[b] += lineG
				areaB[b] += lineB
				area2[b] += line2

				previousIdx := rgbIdx(r-1, g, b)
				w.weights[idx] = w.weights[previousIdx] + area[b]
				w.momentsR[idx] = w.momentsR[previousIdx] + areaR[b]
				w.momentsG[idx] = w.momentsG[previousIdx] + areaG[b]
				w.momentsB[idx] = w.momentsB[previousIdx] + areaB[b]
				w.moments[idx] = w.moments[previousIdx] + area2[b]
			}
		}
	}
}

// createBoxes recursively splits the RGB cube to create the optimal color boxes.
func (w *Wu) createBoxes(maxColorCount int) *createBoxesResult {
	w.cubes = make([]*Box, maxColorCount)
	for i := 0; i < maxColorCount; i++ {
		w.cubes[i] = &Box{}
	}

	volumeVariance := make([]float64, maxColorCount)
	firstBox := w.cubes[0]
	firstBox.r1 = indexCount - 1
	firstBox.g1 = indexCount - 1
	firstBox.b1 = indexCount - 1

	generatedColorCount := maxColorCount
	next := 0

	for i := 1; i < maxColorCount; i++ {
		if w.cut(w.cubes[next], w.cubes[i]) {
			if w.cubes[next].vol > 1 {
				volumeVariance[next] = w.variance(w.cubes[next])
			} else {
				volumeVariance[next] = 0.0
			}
			if w.cubes[i].vol > 1 {
				volumeVariance[i] = w.variance(w.cubes[i])
			} else {
				volumeVariance[i] = 0.0
			}
		} else {
			volumeVariance[next] = 0.0
			i--
		}

		next = 0
		temp := volumeVariance[0]
		for j := 1; j <= i; j++ {
			if volumeVariance[j] > temp {
				temp = volumeVariance[j]
				next = j
			}
		}
		if temp <= 0.0 {
			generatedColorCount = i + 1
			break
		}
	}

	return &createBoxesResult{
		requestedCount: maxColorCount,
		resultCount:    generatedColorCount,
	}
}

// createResult generates the final color palette from the boxes.
func (w *Wu) createResult(colorCount int) []uint32 {
	var colors []uint32
	for i := 0; i < colorCount; i++ {
		cube := w.cubes[i]
		weight := w.volume(cube, w.weights)
		if weight > 0 {
			r := w.volume(cube, w.momentsR) / weight
			g := w.volume(cube, w.momentsG) / weight
			b := w.volume(cube, w.momentsB) / weight
			color := utils.ArgbFromRgb(uint8(r), uint8(g), uint8(b))
			colors = append(colors, color)
		}
	}
	return colors
}

// variance calculates the variance of a cube for splitting decisions.
func (w *Wu) variance(cube *Box) float64 {
	dr := w.volume(cube, w.momentsR)
	dg := w.volume(cube, w.momentsG)
	db := w.volume(cube, w.momentsB)

	xx := w.moments[rgbIdx(cube.r1, cube.g1, cube.b1)] -
		w.moments[rgbIdx(cube.r1, cube.g1, cube.b0)] -
		w.moments[rgbIdx(cube.r1, cube.g0, cube.b1)] +
		w.moments[rgbIdx(cube.r1, cube.g0, cube.b0)] -
		w.moments[rgbIdx(cube.r0, cube.g1, cube.b1)] +
		w.moments[rgbIdx(cube.r0, cube.g1, cube.b0)] +
		w.moments[rgbIdx(cube.r0, cube.g0, cube.b1)] -
		w.moments[rgbIdx(cube.r0, cube.g0, cube.b0)]

	hypotenuse := dr*dr + dg*dg + db*db
	volume := w.volume(cube, w.weights)
	return xx - float64(hypotenuse)/float64(volume)
}

// cut attempts to split a cube into two parts, returning true if successful.
func (w *Wu) cut(one, two *Box) bool {
	wholeR := w.volume(one, w.momentsR)
	wholeG := w.volume(one, w.momentsG)
	wholeB := w.volume(one, w.momentsB)
	wholeW := w.volume(one, w.weights)

	maxRResult := w.maximize(one, DirectionRed, one.r0+1, one.r1, wholeR, wholeG, wholeB, wholeW)
	maxGResult := w.maximize(one, DirectionGreen, one.g0+1, one.g1, wholeR, wholeG, wholeB, wholeW)
	maxBResult := w.maximize(one, DirectionBlue, one.b0+1, one.b1, wholeR, wholeG, wholeB, wholeW)

	var cutDirection Direction
	maxR := maxRResult.maximum
	maxG := maxGResult.maximum
	maxB := maxBResult.maximum

	if maxR >= maxG && maxR >= maxB {
		if maxRResult.cutLocation < 0 {
			return false
		}
		cutDirection = DirectionRed
	} else if maxG >= maxR && maxG >= maxB {
		cutDirection = DirectionGreen
	} else {
		cutDirection = DirectionBlue
	}

	two.r1 = one.r1
	two.g1 = one.g1
	two.b1 = one.b1

	switch cutDirection {
	case DirectionRed:
		one.r1 = maxRResult.cutLocation
		two.r0 = one.r1
		two.g0 = one.g0
		two.b0 = one.b0
	case DirectionGreen:
		one.g1 = maxGResult.cutLocation
		two.r0 = one.r0
		two.g0 = one.g1
		two.b0 = one.b0
	case DirectionBlue:
		one.b1 = maxBResult.cutLocation
		two.r0 = one.r0
		two.g0 = one.g0
		two.b0 = one.b1
	}

	one.vol = (one.r1 - one.r0) * (one.g1 - one.g0) * (one.b1 - one.b0)
	two.vol = (two.r1 - two.r0) * (two.g1 - two.g0) * (two.b1 - two.b0)

	return true
}

// maximize finds the optimal cutting point along a given direction.
func (w *Wu) maximize(cube *Box, direction Direction, first, last, wholeR, wholeG, wholeB, wholeW int) *maximizeResult {
	bottomR := w.bottom(cube, direction, w.momentsR)
	bottomG := w.bottom(cube, direction, w.momentsG)
	bottomB := w.bottom(cube, direction, w.momentsB)
	bottomW := w.bottom(cube, direction, w.weights)

	max := 0.0
	cut := -1

	var halfR, halfG, halfB, halfW int
	for i := first; i < last; i++ {
		halfR = bottomR + w.top(cube, direction, i, w.momentsR)
		halfG = bottomG + w.top(cube, direction, i, w.momentsG)
		halfB = bottomB + w.top(cube, direction, i, w.momentsB)
		halfW = bottomW + w.top(cube, direction, i, w.weights)

		if halfW == 0 {
			continue
		}

		tempNumerator := float64(halfR*halfR + halfG*halfG + halfB*halfB)
		tempDenominator := float64(halfW)
		temp := tempNumerator / tempDenominator

		halfR = wholeR - halfR
		halfG = wholeG - halfG
		halfB = wholeB - halfB
		halfW = wholeW - halfW

		if halfW == 0 {
			continue
		}

		tempNumerator = float64(halfR*halfR + halfG*halfG + halfB*halfB)
		tempDenominator = float64(halfW)
		temp += tempNumerator / tempDenominator

		if temp > max {
			max = temp
			cut = i
		}
	}

	return &maximizeResult{
		cutLocation: cut,
		maximum:     max,
	}
}

// volume calculates the volume of a box using the given moment array.
func (w *Wu) volume(cube *Box, moment []int) int {
	return moment[rgbIdx(cube.r1, cube.g1, cube.b1)] -
		moment[rgbIdx(cube.r1, cube.g1, cube.b0)] -
		moment[rgbIdx(cube.r1, cube.g0, cube.b1)] +
		moment[rgbIdx(cube.r1, cube.g0, cube.b0)] -
		moment[rgbIdx(cube.r0, cube.g1, cube.b1)] +
		moment[rgbIdx(cube.r0, cube.g1, cube.b0)] +
		moment[rgbIdx(cube.r0, cube.g0, cube.b1)] -
		moment[rgbIdx(cube.r0, cube.g0, cube.b0)]
}

// bottom calculates the bottom face value of a cube in a given direction.
func (w *Wu) bottom(cube *Box, direction Direction, moment []int) int {
	switch direction {
	case DirectionRed:
		return -moment[rgbIdx(cube.r0, cube.g1, cube.b1)] +
			moment[rgbIdx(cube.r0, cube.g1, cube.b0)] +
			moment[rgbIdx(cube.r0, cube.g0, cube.b1)] -
			moment[rgbIdx(cube.r0, cube.g0, cube.b0)]
	case DirectionGreen:
		return -moment[rgbIdx(cube.r1, cube.g0, cube.b1)] +
			moment[rgbIdx(cube.r1, cube.g0, cube.b0)] +
			moment[rgbIdx(cube.r0, cube.g0, cube.b1)] -
			moment[rgbIdx(cube.r0, cube.g0, cube.b0)]
	case DirectionBlue:
		return -moment[rgbIdx(cube.r1, cube.g1, cube.b0)] +
			moment[rgbIdx(cube.r1, cube.g0, cube.b0)] +
			moment[rgbIdx(cube.r0, cube.g1, cube.b0)] -
			moment[rgbIdx(cube.r0, cube.g0, cube.b0)]
	default:
		return 0
	}
}

// top calculates the top face value of a cube in a given direction at a specific position.
func (w *Wu) top(cube *Box, direction Direction, position int, moment []int) int {
	switch direction {
	case DirectionRed:
		return moment[rgbIdx(position, cube.g1, cube.b1)] -
			moment[rgbIdx(position, cube.g1, cube.b0)] -
			moment[rgbIdx(position, cube.g0, cube.b1)] +
			moment[rgbIdx(position, cube.g0, cube.b0)]
	case DirectionGreen:
		return moment[rgbIdx(cube.r1, position, cube.b1)] -
			moment[rgbIdx(cube.r1, position, cube.b0)] -
			moment[rgbIdx(cube.r0, position, cube.b1)] +
			moment[rgbIdx(cube.r0, position, cube.b0)]
	case DirectionBlue:
		return moment[rgbIdx(cube.r1, cube.g1, position)] -
			moment[rgbIdx(cube.r1, cube.g0, position)] -
			moment[rgbIdx(cube.r0, cube.g1, position)] +
			moment[rgbIdx(cube.r0, cube.g0, position)]
	default:
		return 0
	}
}
