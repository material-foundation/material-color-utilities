/**
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

import * as math from 'utils/math_utils';

/**
 * Utility methods for color science constants and color space
 *     conversions that aren't HCT or CAM16.
 */

/**
 * Standard white point; white on a sunny day.
 */
export const WHITE_POINT_D65: number[] = [95.047, 100.0, 108.883];

/**
 * @param argb ARGB representation of a color.
 * @return The alpha of the color, from 0 to 255.
 */
export const alphaFromInt = (argb: number) => {
  return ((argb & 0xff000000) >> 24) >>> 0;
};

/**
 * @param argb ARGB representation of a color.
 * @return The red channel of the color, from 0 to 255.
 */
export const redFromInt = (argb: number) => {
  return (argb & 0x00ff0000) >> 16;
};

/**
 * @param argb ARGB representation of a color.
 * @return The green channel of the color, from 0 to 255.
 */
export const greenFromInt = (argb: number) => {
  return (argb & 0x0000ff00) >> 8;
};

/**
 * @param argb ARGB representation of a color.
 * @return The blue channel of the color, from 0 to 255.
 */
export const blueFromInt = (argb: number) => {
  return argb & 0x000000ff;
};

/**
 * @param argb ARGB representation of a color.
 * @return L*, from L*a*b*, coordinate of the color.
 */
export const lstarFromInt = (argb: number) => {
  const red = (argb & 0x00ff0000) >> 16;
  const green = (argb & 0x0000ff00) >> 8;
  const blue = (argb & 0x000000ff);
  const redL = linearized(red / 255.0) * 100.0;
  const greenL = linearized(green / 255.0) * 100.0;
  const blueL = linearized(blue / 255.0) * 100.0;
  let y = 0.2126 * redL + 0.7152 * greenL + 0.0722 * blueL;
  y = y / 100.0;
  const e = 216.0 / 24389.0;
  let yIntermediate;
  if (y <= e) {
    yIntermediate = (24389.0 / 27.0) * y;
    // If y < e, can skip consecutive steps of / 116 + 16 followed by * 116
    // - 16.
    return yIntermediate;
  } else {
    yIntermediate = Math.pow(y, 1.0 / 3.0);
  }
  return 116.0 * yIntermediate - 16.0;
};

/**
 * @param argb ARGB representation of a color.
 * @return Hex string representing color, ex. #ff0000 for red.
 */
export const hexFromInt = (argb: number) => {
  const r = redFromInt(argb);
  const g = greenFromInt(argb);
  const b = blueFromInt(argb);
  const outParts = [r.toString(16), g.toString(16), b.toString(16)];

  // Pad single-digit output values
  for (const [i, part] of outParts.entries()) {
    if (part.length === 1) {
      outParts[i] = '0' + part;
    }
  }

  return '#' + outParts.join('');
};

/**
 * @param argb ARGB representation of a color.
 * @return Color's coordinates in the XYZ color space.
 */
export const xyzFromInt = (argb: number) => {
  const red = (argb & 0x00ff0000) >> 16;
  const green = (argb & 0x0000ff00) >> 8;
  const blue = (argb & 0x000000ff);
  const redL = linearized(red / 255.0) * 100.0;
  const greenL = linearized(green / 255.0) * 100.0;
  const blueL = linearized(blue / 255.0) * 100.0;
  const x = 0.41233895 * redL + 0.35762064 * greenL + 0.18051042 * blueL;
  const y = 0.2126 * redL + 0.7152 * greenL + 0.0722 * blueL;
  const z = 0.01932141 * redL + 0.11916382 * greenL + 0.95034478 * blueL;
  return [x, y, z];
};

/**
 * @param rgb Array with 3 components between 0 and 255, representing red,
 *     green, and blue.
 * @return ARGB representation of the color.
 */
export const intFromRgb = (rgb: number[]) => {
  return (
      ((255 << 24) | ((rgb[0] & 0x0ff) << 16) | ((rgb[1] & 0x0ff) << 8) |
       (rgb[2] & 0x0ff)) >>>
      0);
};

/**
 * @param argb ARGB representation of a color.
 * @return Color's coordinates in the L*a*b* color space.
 */
export const labFromInt = (argb: number) => {
  const e = 216.0 / 24389.0;
  const kappa = 24389.0 / 27.0;

  const red = (argb & 0x00ff0000) >> 16;
  const green = (argb & 0x0000ff00) >> 8;
  const blue = (argb & 0x000000ff);
  const redL = linearized(red / 255.0) * 100.0;
  const greenL = linearized(green / 255.0) * 100.0;
  const blueL = linearized(blue / 255.0) * 100.0;
  const x = 0.41233895 * redL + 0.35762064 * greenL + 0.18051042 * blueL;
  const y = 0.2126 * redL + 0.7152 * greenL + 0.0722 * blueL;
  const z = 0.01932141 * redL + 0.11916382 * greenL + 0.95034478 * blueL;

  const yNormalized = y / WHITE_POINT_D65[1];
  let fy;
  if (yNormalized > e) {
    fy = Math.pow(yNormalized, 1.0 / 3.0);
  } else {
    fy = (kappa * yNormalized + 16) / 116;
  }

  const xNormalized = x / WHITE_POINT_D65[0];
  let fx;
  if (xNormalized > e) {
    fx = Math.pow(xNormalized, 1.0 / 3.0);
  } else {
    fx = (kappa * xNormalized + 16) / 116;
  }

  const zNormalized = z / WHITE_POINT_D65[2];
  let fz;
  if (zNormalized > e) {
    fz = Math.pow(zNormalized, 1.0 / 3.0);
  } else {
    fz = (kappa * zNormalized + 16) / 116;
  }

  const l = 116.0 * fy - 16;
  const a = 500.0 * (fx - fy);
  const b = 200.0 * (fy - fz);
  return [l, a, b];
};

/**
 * @return ARGB representation of color in the L*a*b* color space.
 */
export const intFromLab = (l: number, a: number, b: number) => {
  const e = 216.0 / 24389.0;
  const kappa = 24389.0 / 27.0;
  const ke = 8.0;

  const fy = (l + 16.0) / 116.0;
  const fx = a / 500.0 + fy;
  const fz = fy - b / 200.0;
  const fx3 = fx * fx * fx;
  const xNormalized = fx3 > e ? fx3 : (116.0 * fx - 16.0) / kappa;
  const yNormalized = l > ke ? fy * fy * fy : l / kappa;
  const fz3 = fz * fz * fz;
  const zNormalized = fz3 > e ? fz3 : (116.0 * fz - 16.0) / kappa;
  const x = xNormalized * WHITE_POINT_D65[0];
  const y = yNormalized * WHITE_POINT_D65[1];
  const z = zNormalized * WHITE_POINT_D65[2];
  return intFromXyz([x, y, z]);
};

/**
 * @return ARGB representation of color in the XYZ color space.
 */
export const intFromXyzComponents = (x: number, y: number, z: number) => {
  x = x / 100.0;
  y = y / 100.0;
  z = z / 100.0;

  const rL = x * 3.2406 + y * -1.5372 + z * -0.4986;
  const gL = x * -0.9689 + y * 1.8758 + z * 0.0415;
  const bL = x * 0.0557 + y * -0.204 + z * 1.057;
  const r = delinearized(rL);
  const g = delinearized(gL);
  const b = delinearized(bL);

  const rInt = Math.round(math.clamp(0, 255, r * 255));
  const gInt = Math.round(math.clamp(0, 255, g * 255));
  const bInt = Math.round(math.clamp(0, 255, b * 255));
  return intFromRgb([rInt, gInt, bInt]);
};

/**
 * @return ARGB representation of color in the XYZ color space.
 */
export const intFromXyz = (xyz: number[]) => {
  return intFromXyzComponents(xyz[0], xyz[1], xyz[2]);
};

/**
 * @param hex String representing color as hex code. Accepts strings with or
 *     without leading #, and string representing the color using 3, 6, or 8
 *     hex characters.
 * @return ARGB representation of color.
 */
export const intFromHex = (hex: string) => {
  hex = hex.replace('#', '');
  const isThree = hex.length === 3;
  const isSix = hex.length === 6;
  const isEight = hex.length === 8;
  if (!isThree && !isSix && !isEight) {
    throw new Error('unexpected hex ' + hex);
  }
  let r = 0;
  let g = 0;
  let b = 0;
  if (isThree) {
    r = parseIntHex(hex.slice(0, 1).repeat(2));
    g = parseIntHex(hex.slice(1, 2).repeat(2));
    b = parseIntHex(hex.slice(2, 3).repeat(2));
  } else if (isSix) {
    r = parseIntHex(hex.slice(0, 2));
    g = parseIntHex(hex.slice(2, 4));
    b = parseIntHex(hex.slice(4, 6));
  } else if (isEight) {
    r = parseIntHex(hex.slice(2, 4));
    g = parseIntHex(hex.slice(4, 6));
    b = parseIntHex(hex.slice(6, 8));
  }

  return (
      ((255 << 24) | ((r & 0x0ff) << 16) | ((g & 0x0ff) << 8) | (b & 0x0ff)) >>>
      0);
};

function parseIntHex(value: string) {
  // tslint:disable-next-line:ban
  return parseInt(value, 16);
}

/**
 * @param lstar L* in L*a*b*
 * @return ARGB representation of grayscale color with lightness matching L*
 */
export const intFromLstar = (lstar: number) => {
  const fy = (lstar + 16.0) / 116.0;
  const fz = fy;
  const fx = fy;
  const kappa = 24389 / 27;
  const epsilon = 216 / 24389;
  const cubeExceedEpsilon = fy * fy * fy > epsilon;
  const lExceedsEpsilonKappa = lstar > 8.0;
  const y = lExceedsEpsilonKappa ? fy * fy * fy : lstar / kappa;
  const x = cubeExceedEpsilon ? fx * fx * fx : (116 * fx - 16) / kappa;
  const z = cubeExceedEpsilon ? fz * fz * fz : (116 * fx - 16) / kappa;
  const xyz =
      [x * WHITE_POINT_D65[0], y * WHITE_POINT_D65[1], z * WHITE_POINT_D65[2]];
  return intFromXyz(xyz);
};

/**
 * L* in L*a*b* and Y in XYZ measure the same quantity, luminance.
 * L* measures perceptual luminance, a linear scale.
 * Y in XYZ measures relative luminance, a logarithmic scale.
 * @param lstar L* in L*a*b*
 * @return Y in XYZ
 */
export const yFromLstar = (lstar: number) => {
  const ke = 8.0;
  if (lstar > ke) {
    return Math.pow((lstar + 16.0) / 116.0, 3) * 100.0;
  } else {
    return (lstar / (24389.0 / 27.0)) * 100.0;
  }
};

/**
 * @param rgb 0.0 <= rgb <= 1.0, represents R/G/B channel
 * @return color channel converted to linear RGB space
 */
export const linearized = (rgb: number) => {
  if (rgb <= 0.04045) {
    return rgb / 12.92;
  } else {
    return Math.pow((rgb + 0.055) / 1.055, 2.4);
  }
};

/**
 * @param rgb 0.0 <= rgb <= 1.0, represents linear R/G/B channel
 * @return color channel converted to regular RGB space
 */
export const delinearized = (rgb: number) => {
  if (rgb <= 0.0031308) {
    return rgb * 12.92;
  } else {
    return 1.055 * Math.pow(rgb, 1.0 / 2.4) - 0.055;
  }
};
