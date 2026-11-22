/*
 * Copyright 2021 Google LLC
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

package quantize;

import utils.ColorUtils;

/**
 * Provides conversions needed for K-Means quantization. Converting input to points, and converting
 * the final state of the K-Means algorithm to colors.
 */
public final class PointProviderLab implements PointProvider {
  /** ColorUtils.linearized(i) for every 8-bit channel value i. */
  private static final double[] linearizedChannels = computeLinearizedChannels();

  /**
   * Convert a color represented in ARGB to a 3-element array of L*a*b* coordinates of the color.
   */
  @Override
  public double[] fromInt(int argb) {
    double[] lab = new double[3];
    labFromArgb(argb, lab, 0);
    return lab;
  }

  /** Convert a 3-element array to a color represented in ARGB. */
  @Override
  public int toInt(double[] lab) {
    return ColorUtils.argbFromLab(lab[0], lab[1], lab[2]);
  }

  /**
   * Standard CIE 1976 delta E formula also takes the square root, unneeded here. This method is
   * used by quantization algorithms to compare distance, and the relative ordering is the same,
   * with or without a square root.
   *
   * <p>This relatively minor optimization is helpful because this method is called at least once
   * for each pixel in an image.
   */
  @Override
  public double distance(double[] one, double[] two) {
    double dL = (one[0] - two[0]);
    double dA = (one[1] - two[1]);
    double dB = (one[2] - two[2]);
    return (dL * dL + dA * dA + dB * dB);
  }

  /**
   * Writes the L*a*b* coordinates of a color in ARGB format to out, from index offset.
   *
   * <p>Gives exactly what ColorUtils.labFromArgb gives, with the same operations in the same order,
   * but looks up the linearized channels in a table instead of computing them.
   */
  static void labFromArgb(int argb, double[] out, int offset) {
    double linearR = linearizedChannels[ColorUtils.redFromArgb(argb)];
    double linearG = linearizedChannels[ColorUtils.greenFromArgb(argb)];
    double linearB = linearizedChannels[ColorUtils.blueFromArgb(argb)];
    // The SRGB_TO_XYZ matrix and the D65 white point of ColorUtils.
    double x = 0.41233895 * linearR + 0.35762064 * linearG + 0.18051042 * linearB;
    double y = 0.2126 * linearR + 0.7152 * linearG + 0.0722 * linearB;
    double z = 0.01932141 * linearR + 0.11916382 * linearG + 0.95034478 * linearB;
    double fx = labF(x / 95.047);
    double fy = labF(y / 100.0);
    double fz = labF(z / 108.883);
    out[offset] = 116.0 * fy - 16;
    out[offset + 1] = 500.0 * (fx - fy);
    out[offset + 2] = 200.0 * (fy - fz);
  }

  private static double[] computeLinearizedChannels() {
    double[] table = new double[256];
    for (int i = 0; i < table.length; i++) {
      table[i] = ColorUtils.linearized(i);
    }
    return table;
  }

  /** The same as ColorUtils.labF, which is not visible here. */
  private static double labF(double t) {
    double e = 216.0 / 24389.0;
    double kappa = 24389.0 / 27.0;
    if (t > e) {
      return Math.pow(t, 1.0 / 3.0);
    } else {
      return (kappa * t + 16) / 116;
    }
  }
}
