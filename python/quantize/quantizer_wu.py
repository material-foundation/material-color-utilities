# /**
#  * @license
#  * Copyright 2021 Google LLC
#  *
#  * Licensed under the Apache License, Version 2.0 (the "License");
#  * you may not use this file except in compliance with the License.
#  * You may obtain a copy of the License at
#  *
#  *      http://www.apache.org/licenses/LICENSE-2.0
#  *
#  * Unless required by applicable law or agreed to in writing, software
#  * distributed under the License is distributed on an "AS IS" BASIS,
#  * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  * See the License for the specific language governing permissions and
#  * limitations under the License.
#  */

from utils.color_utils import *
from quantize.quantizer_map import *

INDEX_BITS = 5
SIDE_LENGTH = 33 # ((1 << INDEX_INDEX_BITS) + 1)
TOTAL_SIZE = 35937 # SIDE_LENGTH * SIDE_LENGTH * SIDE_LENGTH
directions = {
    "RED" : 'red',
    "GREEN" : 'green',
    "BLUE": 'blue',
}

# /**
#  * An image quantizer that divides the image's pixels into clusters by
#  * recursively cutting an RGB cube, based on the weight of pixels in each area
#  * of the cube.
#  *
#  * The algorithm was described by Xiaolin Wu in Graphic Gems II, published in
#  * 1991.
#  */
class QuantizerWu:
    def __init__(self, weights = [], momentsR = [], momentsG = [], momentsB = [], moments = [], cubes = []):
        self.weights = weights
        self.momentsR = momentsR
        self.momentsG = momentsG
        self.momentsB = momentsB
        self.moments = moments
        self.cubes = cubes

    # /**
    #  * @param pixels Colors in ARGB format.
    #  * @param maxColors The number of colors to divide the image into. A lower
    #  *     number of colors may be returned.
    #  * @return Colors in ARGB format.
    #  */
    def quantize(self, pixels, maxColors):
        self.constructHistogram(pixels)
        self.computeMoments()
        createBoxesResult = self.createBoxes(maxColors)
        results = self.createResult(createBoxesResult.resultCount)
        return results

    def constructHistogram(self, pixels):
        _a = None
        self.weights = [0] * TOTAL_SIZE
        self.momentsR = [0] * TOTAL_SIZE
        self.momentsG = [0] * TOTAL_SIZE
        self.momentsB = [0] * TOTAL_SIZE
        self.moments = [0] * TOTAL_SIZE
        countByColor = QuantizerMap.quantize(pixels)
        for (pixel, count) in countByColor.items():
            red = redFromArgb(pixel)
            green = greenFromArgb(pixel)
            blue = blueFromArgb(pixel)
            bitsToRemove = 8 - INDEX_BITS
            iR = (red >> bitsToRemove) + 1
            iG = (green >> bitsToRemove) + 1
            iB = (blue >> bitsToRemove) + 1
            index = self.getIndex(iR, iG, iB)
            self.weights[index] = (self.weights[index] if len(self.weights) > index else 0) + count
            self.momentsR[index] += count * red
            self.momentsG[index] += count * green
            self.momentsB[index] += count * blue
            self.moments[index] += count * (red * red + green * green + blue * blue)

    def computeMoments(self):
        for r in range(1, SIDE_LENGTH):
            area = [0] * SIDE_LENGTH
            areaR = [0] * SIDE_LENGTH
            areaG = [0] * SIDE_LENGTH
            areaB = [0] * SIDE_LENGTH
            area2 = [0.0] * SIDE_LENGTH
            for g in range(1, SIDE_LENGTH):
                line = 0
                lineR = 0
                lineG = 0
                lineB = 0
                line2 = 0.0
                for b in range(1, SIDE_LENGTH):
                    index = self.getIndex(r, g, b)
                    line += self.weights[index]
                    lineR += self.momentsR[index]
                    lineG += self.momentsG[index]
                    lineB += self.momentsB[index]
                    line2 += self.moments[index]
                    area[b] += line
                    areaR[b] += lineR
                    areaG[b] += lineG
                    areaB[b] += lineB
                    area2[b] += line2
                    previousIndex = self.getIndex(r - 1, g, b)
                    self.weights[index] = self.weights[previousIndex] + area[b]
                    self.momentsR[index] = self.momentsR[previousIndex] + areaR[b]
                    self.momentsG[index] = self.momentsG[previousIndex] + areaG[b]
                    self.momentsB[index] = self.momentsB[previousIndex] + areaB[b]
                    self.moments[index] = self.moments[previousIndex] + area2[b]

    def createBoxes(self, maxColors):
        self.cubes = [Box() for x in [0] * maxColors]
        volumeVariance = [0.0] * maxColors
        self.cubes[0].r0 = 0
        self.cubes[0].g0 = 0
        self.cubes[0].b0 = 0
        self.cubes[0].r1 = SIDE_LENGTH - 1
        self.cubes[0].g1 = SIDE_LENGTH - 1
        self.cubes[0].b1 = SIDE_LENGTH - 1
        generatedColorCount = maxColors
        next = 0
        for i in range(1, maxColors):
            if (self.cut(self.cubes[next], self.cubes[i])):
                volumeVariance[next] = self.variance(self.cubes[next]) if self.cubes[next].vol > 1 else 0.0
                volumeVariance[i] = self.variance(self.cubes[i]) if self.cubes[i].vol > 1 else 0.0
            else:
                volumeVariance[next] = 0.0
                i -= 1
            next = 0
            temp = volumeVariance[0]
            for j in range(1, i):
                if (volumeVariance[j] > temp):
                    temp = volumeVariance[j]
                    next = j
            if (temp <= 0.0):
                generatedColorCount = i + 1
                break
        return CreateBoxesResult(maxColors, generatedColorCount)

    def createResult(self, colorCount):
        colors = []
        for i in range(colorCount):
            cube = self.cubes[i]
            weight = self.volume(cube, self.weights)
            if (weight > 0):
                r = round(self.volume(cube, self.momentsR) / weight)
                g = round(self.volume(cube, self.momentsG) / weight)
                b = round(self.volume(cube, self.momentsB) / weight)
                color = (255 << 24) | ((r & 0x0ff) << 16) | ((g & 0x0ff) << 8) | (b & 0x0ff)
                colors.append(color)
        return colors

    def variance(self, cube):
        dr = self.volume(cube, self.momentsR)
        dg = self.volume(cube, self.momentsG)
        db = self.volume(cube, self.momentsB)
        xx = self.moments[self.getIndex(cube.r1, cube.g1, cube.b1)] - self.moments[self.getIndex(cube.r1, cube.g1, cube.b0)] - self.moments[self.getIndex(cube.r1, cube.g0, cube.b1)] + self.moments[self.getIndex(cube.r1, cube.g0, cube.b0)] - self.moments[self.getIndex(cube.r0, cube.g1, cube.b1)] + self.moments[self.getIndex(cube.r0, cube.g1, cube.b0)] + self.moments[self.getIndex(cube.r0, cube.g0, cube.b1)] - self.moments[self.getIndex(cube.r0, cube.g0, cube.b0)]
        hypotenuse = dr * dr + dg * dg + db * db
        volume = self.volume(cube, self.weights)
        return xx - hypotenuse / volume

    def cut(self, one, two):
        wholeR = self.volume(one, self.momentsR)
        wholeG = self.volume(one, self.momentsG)
        wholeB = self.volume(one, self.momentsB)
        wholeW = self.volume(one, self.weights)
        maxRResult = self.maximize(one, directions["RED"], one.r0 + 1, one.r1, wholeR, wholeG, wholeB, wholeW)
        maxGResult = self.maximize(one, directions["GREEN"], one.g0 + 1, one.g1, wholeR, wholeG, wholeB, wholeW)
        maxBResult = self.maximize(one, directions["BLUE"], one.b0 + 1, one.b1, wholeR, wholeG, wholeB, wholeW)
        direction = None
        maxR = maxRResult.maximum
        maxG = maxGResult.maximum
        maxB = maxBResult.maximum
        if (maxR >= maxG and maxR >= maxB):
            if (maxRResult.cutLocation < 0):
                return False
            direction = directions["RED"]
        elif (maxG >= maxR and maxG >= maxB):
            direction = directions["GREEN"]
        else:
            direction = directions["BLUE"]
        two.r1 = one.r1
        two.g1 = one.g1
        two.b1 = one.b1

        if (direction == directions["RED"]):
            one.r1 = maxRResult.cutLocation
            two.r0 = one.r1
            two.g0 = one.g0
            two.b0 = one.b0
        elif (direction == directions["GREEN"]):
            one.g1 = maxGResult.cutLocation
            two.r0 = one.r0
            two.g0 = one.g1
            two.b0 = one.b0
        elif (direction == directions["BLUE"]):
            one.b1 = maxBResult.cutLocation
            two.r0 = one.r0
            two.g0 = one.g0
            two.b0 = one.b1
        else:
            raise Exception('unexpected direction ' + direction)

        one.vol = (one.r1 - one.r0) * (one.g1 - one.g0) * (one.b1 - one.b0)
        two.vol = (two.r1 - two.r0) * (two.g1 - two.g0) * (two.b1 - two.b0)
        return True

    def maximize(self, cube, direction, first, last, wholeR, wholeG, wholeB, wholeW):
        bottomR = self.bottom(cube, direction, self.momentsR)
        bottomG = self.bottom(cube, direction, self.momentsG)
        bottomB = self.bottom(cube, direction, self.momentsB)
        bottomW = self.bottom(cube, direction, self.weights)
        max = 0.0
        cut = -1
        halfR = 0
        halfG = 0
        halfB = 0
        halfW = 0
        for i in range(first, last):
            halfR = bottomR + self.top(cube, direction, i, self.momentsR)
            halfG = bottomG + self.top(cube, direction, i, self.momentsG)
            halfB = bottomB + self.top(cube, direction, i, self.momentsB)
            halfW = bottomW + self.top(cube, direction, i, self.weights)
            if (halfW == 0):
                continue
            tempNumerator = (halfR * halfR + halfG * halfG + halfB * halfB) * 1.0
            tempDenominator = halfW * 1.0
            temp = tempNumerator / tempDenominator
            halfR = wholeR - halfR
            halfG = wholeG - halfG
            halfB = wholeB - halfB
            halfW = wholeW - halfW
            if (halfW == 0):
                continue
            tempNumerator = (halfR * halfR + halfG * halfG + halfB * halfB) * 1.0
            tempDenominator = halfW * 1.0
            temp += tempNumerator / tempDenominator
            if (temp > max):
                max = temp
                cut = i
        return MaximizeResult(cut, max)

    def volume(self, cube, moment):
        return (moment[self.getIndex(cube.r1, cube.g1, cube.b1)] - moment[self.getIndex(cube.r1, cube.g1, cube.b0)] - moment[self.getIndex(cube.r1, cube.g0, cube.b1)] + moment[self.getIndex(cube.r1, cube.g0, cube.b0)] - moment[self.getIndex(cube.r0, cube.g1, cube.b1)] + moment[self.getIndex(cube.r0, cube.g1, cube.b0)] + moment[self.getIndex(cube.r0, cube.g0, cube.b1)] - moment[self.getIndex(cube.r0, cube.g0, cube.b0)])

    def bottom(self, cube, direction, moment):
        if (direction == directions["RED"]):
            return (-moment[self.getIndex(cube.r0, cube.g1, cube.b1)] + moment[self.getIndex(cube.r0, cube.g1, cube.b0)] + moment[self.getIndex(cube.r0, cube.g0, cube.b1)] - moment[self.getIndex(cube.r0, cube.g0, cube.b0)])
        elif (direction == directions["GREEN"]):
            return (-moment[self.getIndex(cube.r1, cube.g0, cube.b1)] + moment[self.getIndex(cube.r1, cube.g0, cube.b0)] + moment[self.getIndex(cube.r0, cube.g0, cube.b1)] - moment[self.getIndex(cube.r0, cube.g0, cube.b0)])
        elif (direction == directions["BLUE"]):
            return (-moment[self.getIndex(cube.r1, cube.g1, cube.b0)] + moment[self.getIndex(cube.r1, cube.g0, cube.b0)] + moment[self.getIndex(cube.r0, cube.g1, cube.b0)] - moment[self.getIndex(cube.r0, cube.g0, cube.b0)])
        else:
            raise Exception('unexpected direction ' + direction)

    def top(self, cube, direction, position, moment):
        if (direction == directions["RED"]):
            return (moment[self.getIndex(position, cube.g1, cube.b1)] - moment[self.getIndex(position, cube.g1, cube.b0)] - moment[self.getIndex(position, cube.g0, cube.b1)] + moment[self.getIndex(position, cube.g0, cube.b0)])
        elif (direction == directions["GREEN"]):
            return (moment[self.getIndex(cube.r1, position, cube.b1)] - moment[self.getIndex(cube.r1, position, cube.b0)] - moment[self.getIndex(cube.r0, position, cube.b1)] + moment[self.getIndex(cube.r0, position, cube.b0)])
        elif (direction == directions["BLUE"]):
            return (moment[self.getIndex(cube.r1, cube.g1, position)] - moment[self.getIndex(cube.r1, cube.g0, position)] - moment[self.getIndex(cube.r0, cube.g1, position)] + moment[self.getIndex(cube.r0, cube.g0, position)])
        else:
            raise Exception('unexpected direction ' + direction)

    def getIndex(self, r, g, b):
        return (r << (INDEX_BITS * 2)) + (r << (INDEX_BITS + 1)) + r + (g << INDEX_BITS) + g + b

# /**
#  * Keeps track of the state of each box created as the Wu  quantization
#  * algorithm progresses through dividing the image's pixels as plotted in RGB.
#  */
class Box:
    def __init__(self, r0 = 0, r1 = 0, g0 = 0, g1 = 0, b0 = 0, b1 = 0, vol = 0):
        self.r0 = r0
        self.r1 = r1
        self.g0 = g0
        self.g1 = g1
        self.b0 = b0
        self.b1 = b1
        self.vol = vol

# /**
#  * Represents final result of Wu algorithm.
#  */
class CreateBoxesResult:
    # /**
    #  * @param requestedCount how many colors the caller asked to be returned from
    #  *     quantization.
    #  * @param resultCount the actual number of colors achieved from quantization.
    #  *     May be lower than the requested count.
    #  */
    def __init__(self, requestedCount, resultCount):
        self.requestedCount = requestedCount
        self.resultCount = resultCount

# /**
#  * Represents the result of calculating where to cut an existing box in such
#  * a way to maximize variance between the two new boxes created by a cut.
#  */
class MaximizeResult:
    def __init__(self, cutLocation, maximum):
        self.cutLocation = cutLocation
        self.maximum = maximum
