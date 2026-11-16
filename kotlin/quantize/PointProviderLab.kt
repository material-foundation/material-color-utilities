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

import utils.ColorUtils

/**
 * Provides conversions needed for K-Means quantization. Converting input to points, and converting
 * the final state of the K-Means algorithm to colors.
 */
class PointProviderLab : PointProvider {
  /**
   * Convert a color represented in ARGB to a 3-element array of L*a*b* coordinates of the color.
   */
  override fun fromInt(argb: Int): DoubleArray {
    val lab = DoubleArray(3)
    labFromArgb(argb, lab, 0)
    return lab
  }

  /** Convert a 3-element array to a color represented in ARGB. */
  override fun toInt(point: DoubleArray): Int {
    return ColorUtils.argbFromLab(point[0], point[1], point[2])
  }

  /**
   * Standard CIE 1976 delta E formula also takes the square root, unneeded here. This method is
   * used by quantization algorithms to compare distance, and the relative ordering is the same,
   * with or without a square root.
   *
   * This relatively minor optimization is helpful because this method is called at least once for
   * each pixel in an image.
   */
  override fun distance(a: DoubleArray, b: DoubleArray): Double {
    val dL = a[0] - b[0]
    val dA = a[1] - b[1]
    val dB = a[2] - b[2]
    return dL * dL + dA * dA + dB * dB
  }

  internal companion object {
    /** [ColorUtils.linearized] of each 8-bit channel value, computed once. */
    private val LINEARIZED = DoubleArray(256) { ColorUtils.linearized(it) }

    /**
     * Writes the L*a*b* coordinates of [argb] to [out], from [offset]: the same values, computed in
     * the same order, as [ColorUtils.labFromArgb], with each channel linearized by a table lookup.
     */
    fun labFromArgb(argb: Int, out: DoubleArray, offset: Int) {
      val linearR = LINEARIZED[ColorUtils.redFromArgb(argb)]
      val linearG = LINEARIZED[ColorUtils.greenFromArgb(argb)]
      val linearB = LINEARIZED[ColorUtils.blueFromArgb(argb)]
      val x = 0.41233895 * linearR + 0.35762064 * linearG + 0.18051042 * linearB
      val y = 0.2126 * linearR + 0.7152 * linearG + 0.0722 * linearB
      val z = 0.01932141 * linearR + 0.11916382 * linearG + 0.95034478 * linearB
      val fx = ColorUtils.labF(x / 95.047)
      val fy = ColorUtils.labF(y / 100.0)
      val fz = ColorUtils.labF(z / 108.883)
      out[offset] = 116.0 * fy - 16
      out[offset + 1] = 500.0 * (fx - fy)
      out[offset + 2] = 200.0 * (fy - fz)
    }
  }
}
