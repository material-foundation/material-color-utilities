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
	"math"
	"math/rand"
)

// WSMeans implements weighted k-means clustering for color quantization.
// This algorithm uses k-means clustering in Lab color space for better perceptual results.
type WSMeans struct {
	pointProvider PointProvider
	maxIterations int
}

// NewWSMeans creates a new WSMeans quantizer.
func NewWSMeans() *WSMeans {
	return &WSMeans{
		pointProvider: NewLabPointProvider(),
		maxIterations: 10,
	}
}

// centroid represents a cluster center with its associated colors and weights.
type centroid struct {
	point  []float64
	colors []uint32
	counts []int
}

// Quantize performs weighted k-means clustering on the input pixels.
func (q *WSMeans) Quantize(pixels []uint32, maxColors int) map[uint32]int {
	if len(pixels) == 0 {
		return make(map[uint32]int)
	}

	// Count unique colors
	colorCounts := make(map[uint32]int)
	for _, pixel := range pixels {
		colorCounts[pixel]++
	}

	// If we have fewer unique colors than requested, return all
	if len(colorCounts) <= maxColors {
		return colorCounts
	}

	// Convert colors to points in Lab space
	colors := make([]uint32, 0, len(colorCounts))
	points := make([][]float64, 0, len(colorCounts))
	counts := make([]int, 0, len(colorCounts))

	for color, count := range colorCounts {
		colors = append(colors, color)
		points = append(points, q.pointProvider.FromInt(color))
		counts = append(counts, count)
	}

	// Initialize centroids using k-means++ initialization
	centroids := q.initializeCentroids(points, counts, maxColors)

	// Perform k-means iterations
	for iter := 0; iter < q.maxIterations; iter++ {
		// Assign points to closest centroids
		assignments := make([]int, len(points))
		changed := false

		for i, point := range points {
			bestCentroid := 0
			bestDistance := math.Inf(1)

			for j, centroid := range centroids {
				distance := q.pointProvider.Distance(point, centroid.point)
				if distance < bestDistance {
					bestDistance = distance
					bestCentroid = j
				}
			}

			if assignments[i] != bestCentroid {
				changed = true
			}
			assignments[i] = bestCentroid
		}

		// Update centroids
		q.updateCentroids(centroids, colors, counts, assignments)

		// Converged if no assignments changed
		if !changed {
			break
		}
	}

	// Build result map
	result := make(map[uint32]int)
	for _, centroid := range centroids {
		if len(centroid.colors) > 0 {
			// Use the most representative color from the cluster
			bestColor := centroid.colors[0]
			totalCount := 0
			for _, count := range centroid.counts {
				totalCount += count
			}
			result[bestColor] = totalCount
		}
	}

	return result
}

// initializeCentroids uses k-means++ initialization to select good starting centroids.
func (q *WSMeans) initializeCentroids(points [][]float64, counts []int, k int) []*centroid {
	if len(points) == 0 {
		return make([]*centroid, 0)
	}

	centroids := make([]*centroid, 0, k)

	// Choose first centroid randomly, weighted by pixel count
	firstIndex := q.weightedRandomChoice(counts)
	centroids = append(centroids, &centroid{
		point:  points[firstIndex],
		colors: make([]uint32, 0),
		counts: make([]int, 0),
	})

	// Choose remaining centroids using k-means++
	for len(centroids) < k && len(centroids) < len(points) {
		distances := make([]float64, len(points))
		
		// Calculate distance to nearest existing centroid
		for i, point := range points {
			minDistance := math.Inf(1)
			for _, centroid := range centroids {
				distance := q.pointProvider.Distance(point, centroid.point)
				if distance < minDistance {
					minDistance = distance
				}
			}
			distances[i] = minDistance * minDistance * float64(counts[i])
		}

		// Choose next centroid proportional to squared distance
		nextIndex := q.weightedRandomChoiceFloat(distances)
		centroids = append(centroids, &centroid{
			point:  points[nextIndex],
			colors: make([]uint32, 0),
			counts: make([]int, 0),
		})
	}

	return centroids
}

// updateCentroids recalculates centroid positions based on assigned points.
func (q *WSMeans) updateCentroids(centroids []*centroid, colors []uint32, counts []int, assignments []int) {
	// Clear existing assignments
	for _, centroid := range centroids {
		centroid.colors = make([]uint32, 0)
		centroid.counts = make([]int, 0)
	}

	// Group points by centroid
	for i, assignment := range assignments {
		centroids[assignment].colors = append(centroids[assignment].colors, colors[i])
		centroids[assignment].counts = append(centroids[assignment].counts, counts[i])
	}

	// Recalculate centroid positions as weighted averages
	for _, centroid := range centroids {
		if len(centroid.colors) == 0 {
			continue
		}

		totalWeight := 0
		weightedSum := make([]float64, 3)

		for i, color := range centroid.colors {
			point := q.pointProvider.FromInt(color)
			weight := centroid.counts[i]
			totalWeight += weight

			for j := 0; j < 3; j++ {
				weightedSum[j] += point[j] * float64(weight)
			}
		}

		if totalWeight > 0 {
			for j := 0; j < 3; j++ {
				centroid.point[j] = weightedSum[j] / float64(totalWeight)
			}
		}
	}
}

// weightedRandomChoice selects an index randomly based on integer weights.
func (q *WSMeans) weightedRandomChoice(weights []int) int {
	totalWeight := 0
	for _, weight := range weights {
		totalWeight += weight
	}

	target := rand.Intn(totalWeight)
	current := 0

	for i, weight := range weights {
		current += weight
		if current > target {
			return i
		}
	}

	return len(weights) - 1
}

// weightedRandomChoiceFloat selects an index randomly based on float weights.
func (q *WSMeans) weightedRandomChoiceFloat(weights []float64) int {
	totalWeight := 0.0
	for _, weight := range weights {
		totalWeight += weight
	}

	if totalWeight == 0 {
		return rand.Intn(len(weights))
	}

	target := rand.Float64() * totalWeight
	current := 0.0

	for i, weight := range weights {
		current += weight
		if current >= target {
			return i
		}
	}

	return len(weights) - 1
}