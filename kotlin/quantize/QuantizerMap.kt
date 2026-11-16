/*
 * Copyright 2025 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package quantize

import java.util.LinkedHashMap

/** The load factor that a `LinkedHashMap` uses when it is not given one. */
private const val DEFAULT_LOAD_FACTOR = 0.75

/** Creates a dictionary with keys of colors, and values of count of the color */
class QuantizerMap : Quantizer {
  var colorToCount: MutableMap<Int, Int>? = null
    private set

  override fun quantize(pixels: IntArray, maxColors: Int): QuantizerResult {
    val pixelCounts = PixelCounts(pixels)
    // Sized to hold every distinct color without growing.
    val pixelByCount: MutableMap<Int, Int> =
      LinkedHashMap((pixelCounts.size / DEFAULT_LOAD_FACTOR).toInt() + 1)
    for (i in 0 until pixelCounts.size) {
      pixelByCount[pixelCounts.colors[i]] = pixelCounts.counts[i]
    }
    colorToCount = pixelByCount
    return QuantizerResult(pixelByCount)
  }
}
