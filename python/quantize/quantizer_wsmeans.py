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

from quantize.lab_point_provider import *
from collections import OrderedDict
import random
import math

MAX_ITERATIONS = 10
MIN_MOVEMENT_DISTANCE = 3.0

# /**
#  * An image quantizer that improves on the speed of a standard K-Means algorithm
#  * by implementing several optimizations, including deduping identical pixels
#  * and a triangle inequality rule that reduces the number of comparisons needed
#  * to identify which cluster a point should be moved to.
#  *
#  * Wsmeans stands for Weighted Square Means.
#  *
#  * This algorithm was designed by M. Emre Celebi, and was found in their 2011
#  * paper, Improving the Performance of K-Means for Color Quantization.
#  * https://arxiv.org/abs/1101.0395
#  */
# // libmonet is designed to have a consistent API across platforms
# // and modular components that can be moved around easily. Using a class as a
# // namespace facilitates this.
# //
# // tslint:disable-next-line:class-as-namespace
class QuantizerWsmeans:
    # /**
    #  * @param inputPixels Colors in ARGB format.
    #  * @param startingClusters Defines the initial state of the quantizer. Passing
    #  *     an empty array is fine, the implementation will create its own initial
    #  *     state that leads to reproducible results for the same inputs.
    #  *     Passing an array that is the result of Wu quantization leads to higher
    #  *     quality results.
    #  * @param maxColors The number of colors to divide the image into. A lower
    #  *     number of colors may be returned.
    #  * @return Colors in ARGB format.
    #  */
    # Replacing Map() with OrderedDict()
    @staticmethod
    def quantize(inputPixels, startingClusters, maxColors):
        random.seed(69)
        pixelToCount = OrderedDict()
        points = []
        pixels = []
        pointProvider = LabPointProvider()
        pointCount = 0
        for i in range(len(inputPixels)):
            inputPixel = inputPixels[i]
            if (inputPixel not in pixelToCount.keys()):
                pointCount += 1
                points.append(pointProvider.fromInt(inputPixel))
                pixels.append(inputPixel)
                pixelToCount[inputPixel] = 1
            else:
                pixelToCount[inputPixel] = pixelToCount[inputPixel] + 1
        counts = []
        for i in range(pointCount):
            pixel = pixels[i]
            if (pixel in pixelToCount.keys()):
                # counts[i] = pixelToCount[pixel]
                counts.append(pixelToCount[pixel])
        clusterCount = min(maxColors, pointCount)
        if (len(startingClusters) > 0):
            clusterCount = min(clusterCount, len(startingClusters))
        clusters = []
        for i in range(len(startingClusters)):
            clusters.append(pointProvider.fromInt(startingClusters[i]))
        additionalClustersNeeded = clusterCount - len(clusters)
        if (len(startingClusters) == 0 and additionalClustersNeeded > 0):
            for i in range(additionalClustersNeeded):
                l = random.uniform(0, 1) * 100.0
                a = random.uniform(0, 1) * (100.0 - (-100.0) + 1) + -100
                b = random.uniform(0, 1) * (100.0 - (-100.0) + 1) + -100
                clusters.append([l, a, b])
        clusterIndices = []
        for i in range(pointCount):
            clusterIndices.append(math.floor(random.uniform(0, 1) * clusterCount))
        indexMatrix = []
        for i in range(clusterCount):
            indexMatrix.append([])
            for j in range(clusterCount):
                indexMatrix[i].append(0)
        distanceToIndexMatrix = []
        for i in range(clusterCount):
            distanceToIndexMatrix.append([])
            for j in range(clusterCount):
                distanceToIndexMatrix[i].append(DistanceAndIndex())
        pixelCountSums = []
        for i in range(clusterCount):
            pixelCountSums.append(0)
        for iteration in range(MAX_ITERATIONS):
            for i in range(clusterCount):
                for j in range(i + 1, clusterCount):
                    distance = pointProvider.distance(clusters[i], clusters[j])
                    distanceToIndexMatrix[j][i].distance = distance
                    distanceToIndexMatrix[j][i].index = i
                    distanceToIndexMatrix[i][j].distance = distance
                    distanceToIndexMatrix[i][j].index = j
                # This sort here doesn't seem to do anything because arr of objects
                # leaving just in case though
                # distanceToIndexMatrix[i].sort()
                for j in range(clusterCount):
                    indexMatrix[i][j] = distanceToIndexMatrix[i][j].index
            pointsMoved = 0
            for i in range(pointCount):
                point = points[i]
                previousClusterIndex = clusterIndices[i]
                previousCluster = clusters[previousClusterIndex]
                previousDistance = pointProvider.distance(point, previousCluster)
                minimumDistance = previousDistance
                newClusterIndex = -1
                for j in range(clusterCount):
                    if (distanceToIndexMatrix[previousClusterIndex][j].distance >= 4 * previousDistance):
                        continue
                    distance = pointProvider.distance(point, clusters[j])
                    if (distance < minimumDistance):
                        minimumDistance = distance
                        newClusterIndex = j
                if (newClusterIndex != -1):
                    distanceChange = abs((math.sqrt(minimumDistance) - math.sqrt(previousDistance)))
                    if (distanceChange > MIN_MOVEMENT_DISTANCE):
                        pointsMoved += 1
                        clusterIndices[i] = newClusterIndex
            if (pointsMoved == 0 and iteration != 0):
                break
            componentASums = [0] * clusterCount
            componentBSums = [0] * clusterCount
            componentCSums = [0] * clusterCount
            for i in range(clusterCount):
                pixelCountSums[i] = 0
            for i in range(pointCount):
                clusterIndex = clusterIndices[i]
                point = points[i]
                count = counts[i]
                pixelCountSums[clusterIndex] += count
                componentASums[clusterIndex] += (point[0] * count)
                componentBSums[clusterIndex] += (point[1] * count)
                componentCSums[clusterIndex] += (point[2] * count)
            for i in range(clusterCount):
                count = pixelCountSums[i]
                if (count == 0):
                    clusters[i] = [0.0, 0.0, 0.0]
                    continue
                a = componentASums[i] / count
                b = componentBSums[i] / count
                c = componentCSums[i] / count
                clusters[i] = [a, b, c]
        argbToPopulation = OrderedDict()
        for i in range(clusterCount):
            count = pixelCountSums[i]
            if (count == 0):
                continue
            possibleNewCluster = pointProvider.toInt(clusters[i])
            if (possibleNewCluster in argbToPopulation.keys()):
                continue
            argbToPopulation[possibleNewCluster] = count
        return argbToPopulation

# /**
#  *  A wrapper for maintaining a table of distances between K-Means clusters.
#  */
class DistanceAndIndex:
    def __init__(self):
        self.distance = -1
        self.index = -1
