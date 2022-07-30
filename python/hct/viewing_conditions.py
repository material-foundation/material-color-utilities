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
from utils.math_utils import *
import math

# /**
#  * In traditional color spaces, a color can be identified solely by the
#  * observer's measurement of the color. Color appearance models such as CAM16
#  * also use information about the environment where the color was
#  * observed, known as the viewing conditions.
#  *
#  * For example, white under the traditional assumption of a midday sun white
#  * point is accurately measured as a slightly chromatic blue by CAM16. (roughly,
#  * hue 203, chroma 3, lightness 100)
#  *
#  * This class caches intermediate values of the CAM16 conversion process that
#  * depend only on viewing conditions, enabling speed ups.
#  */
class ViewingConditions:
    # /**
    #  * Parameters are intermediate values of the CAM16 conversion process. Their
    #  * names are shorthand for technical color science terminology, this class
    #  * would not benefit from documenting them individually. A brief overview
    #  * is available in the CAM16 specification, and a complete overview requires
    #  * a color science textbook, such as Fairchild's Color Appearance Models.
    #  */
    def __init__(self, n, aw, nbb, ncb, c, nc, rgbD, fl, fLRoot, z):
        self.n = n
        self.aw = aw
        self.nbb = nbb
        self.ncb = ncb
        self.c = c
        self.nc = nc
        self.rgbD = rgbD
        self.fl = fl
        self.fLRoot = fLRoot
        self.z = z

    # /**
    #  * Create ViewingConditions from a simple, physically relevant, set of
    #  * parameters.
    #  *
    #  * @param whitePoint White point, measured in the XYZ color space.
    #  *     default = D65, or sunny day afternoon
    #  * @param adaptingLuminance The luminance of the adapting field. Informally,
    #  *     how bright it is in the room where the color is viewed. Can be
    #  *     calculated from lux by multiplying lux by 0.0586. default = 11.72,
    #  *     or 200 lux.
    #  * @param backgroundLstar The lightness of the area surrounding the color.
    #  *     measured by L* in L*a*b*. default = 50.0
    #  * @param surround A general description of the lighting surrounding the
    #  *     color. 0 is pitch dark, like watching a movie in a theater. 1.0 is a
    #  *     dimly light room, like watching TV at home at night. 2.0 means there
    #  *     is no difference between the lighting on the color and around it.
    #  *     default = 2.0
    #  * @param discountingIlluminant Whether the eye accounts for the tint of the
    #  *     ambient lighting, such as knowing an apple is still red in green light.
    #  *     default = false, the eye does not perform this process on
    #  *       self-luminous objects like displays.
    #  */
    @staticmethod
    def make(whitePoint = whitePointD65(), adaptingLuminance = (200.0 / math.pi) * yFromLstar(50.0) / 100.0, backgroundLstar = 50.0, surround = 2.0, discountingIlluminant = False):
        xyz = whitePoint
        rW = xyz[0] * 0.401288 + xyz[1] * 0.650173 + xyz[2] * -0.051461
        gW = xyz[0] * -0.250268 + xyz[1] * 1.204414 + xyz[2] * 0.045854
        bW = xyz[0] * -0.002079 + xyz[1] * 0.048952 + xyz[2] * 0.953127
        f = 0.8 + surround / 10.0
        c = lerp(0.59, 0.69, (f - 0.9) * 10.0) if f >= 0.9 else lerp(0.525, 0.59, (f - 0.8) * 10.0)
        d = 1.0 if discountingIlluminant else f * (1.0 - (1.0 / 3.6) * math.exp((-adaptingLuminance - 42.0) / 92.0))
        d = 1.0 if d > 1.0 else 0.0 if d < 0.0 else d
        nc = f
        rgbD = [
            d * (100.0 / rW) + 1.0 - d,
            d * (100.0 / gW) + 1.0 - d,
            d * (100.0 / bW) + 1.0 - d,
        ]
        k = 1.0 / (5.0 * adaptingLuminance + 1.0)
        k4 = k * k * k * k
        k4F = 1.0 - k4
        fl = k4 * adaptingLuminance + 0.1 * k4F * k4F * ((5.0 * adaptingLuminance)**(1. / 3))
        n = yFromLstar(backgroundLstar) / whitePoint[1]
        z = 1.48 + math.sqrt(n)
        nbb = 0.725 / pow(n, 0.2)
        ncb = nbb
        rgbAFactors = [
            pow((fl * rgbD[0] * rW) / 100.0, 0.42),
            pow((fl * rgbD[1] * gW) / 100.0, 0.42),
            pow((fl * rgbD[2] * bW) / 100.0, 0.42),
        ]
        rgbA = [
            (400.0 * rgbAFactors[0]) / (rgbAFactors[0] + 27.13),
            (400.0 * rgbAFactors[1]) / (rgbAFactors[1] + 27.13),
            (400.0 * rgbAFactors[2]) / (rgbAFactors[2] + 27.13),
        ]
        aw = (2.0 * rgbA[0] + rgbA[1] + 0.05 * rgbA[2]) * nbb
        return ViewingConditions(n, aw, nbb, ncb, c, nc, rgbD, fl, pow(fl, 0.25), z)
# /** sRGB-like viewing conditions.  */
ViewingConditions.DEFAULT = ViewingConditions.make()