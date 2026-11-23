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

from hct.cam16 import *
from hct.hct import *
from utils.color_utils import *
from utils.math_utils import *

# // libmonet is designed to have a consistent API across platforms
# // and modular components that can be moved around easily. Using a class as a
# // namespace facilitates this.
# //
# // tslint:disable:class-as-namespace
# /**
#  * Functions for blending in HCT and CAM16.
#  */
class Blend:
    # /**
    #  * Blend the design color's HCT hue towards the key color's HCT
    #  * hue, in a way that leaves the original color recognizable and
    #  * recognizably shifted towards the key color.
    #  *
    #  * @param designColor ARGB representation of an arbitrary color.
    #  * @param sourceColor ARGB representation of the main theme color.
    #  * @return The design color with a hue shifted towards the
    #  * system's color, a slightly warmer/cooler variant of the design
    #  * color's hue.
    #  */
    # Changed var differenceDegrees to differenceDegrees_v to avoid overwrite
    @staticmethod
    def harmonize(designColor, sourceColor):
        fromHct = Hct.fromInt(designColor)
        toHct = Hct.fromInt(sourceColor)
        differenceDegrees_v = differenceDegrees(fromHct.hue, toHct.hue)
        rotationDegrees = min(differenceDegrees_v * 0.5, 15.0)
        outputHue = sanitizeDegreesDouble(fromHct.hue + rotationDegrees * Blend.rotationDirection(fromHct.hue, toHct.hue))
        return Hct.fromHct(outputHue, fromHct.chroma, fromHct.tone).toInt()

    # /**
    #  * Blends hue from one color into another. The chroma and tone of
    #  * the original color are maintained.
    #  *
    #  * @param from ARGB representation of color
    #  * @param to ARGB representation of color
    #  * @param amount how much blending to perform; 0.0 >= and <= 1.0
    #  * @return from, with a hue blended towards to. Chroma and tone
    #  * are constant.
    #  */
    # Changed "from" arg to "from_v", from is reserved in Python
    @staticmethod
    def hctHue(from_v, to, amount):
        ucs = Blend.cam16Ucs(from_v, to, amount)
        ucsCam = Cam16.fromInt(ucs)
        fromCam = Cam16.fromInt(from_v)
        blended = Hct.fromHct(ucsCam.hue, fromCam.chroma, lstarFromArgb(from_v))
        return blended.toInt()

    # /**
    #  * Blend in CAM16-UCS space.
    #  *
    #  * @param from ARGB representation of color
    #  * @param to ARGB representation of color
    #  * @param amount how much blending to perform; 0.0 >= and <= 1.0
    #  * @return from, blended towards to. Hue, chroma, and tone will
    #  * change.
    #  */
    # Changed "from" arg to "from_v", from is reserved in Python
    @staticmethod
    def cam16Ucs(from_v, to, amount):
        fromCam = Cam16.fromInt(from_v)
        toCam = Cam16.fromInt(to)
        fromJ = fromCam.jstar
        fromA = fromCam.astar
        fromB = fromCam.bstar
        toJ = toCam.jstar
        toA = toCam.astar
        toB = toCam.bstar
        jstar = fromJ + (toJ - fromJ) * amount
        astar = fromA + (toA - fromA) * amount
        bstar = fromB + (toB - fromB) * amount
        return Cam16.fromUcs(jstar, astar, bstar).toInt()

    # /**
    #  * Sign of direction change needed to travel from one angle to
    #  * another.
    #  *
    #  * @param from The angle travel starts from, in degrees.
    #  * @param to The angle travel ends at, in degrees.
    #  * @return -1 if decreasing from leads to the shortest travel
    #  * distance, 1 if increasing from leads to the shortest travel
    #  * distance.
    #  */
    # Changed "from" arg to "from_v", from is reserved in Python
    @staticmethod
    def rotationDirection(from_v, to):
        a = to - from_v
        b = to - from_v + 360.0
        c = to - from_v - 360.0
        aAbs = abs(a)
        bAbs = abs(b)
        cAbs = abs(c)
        if (aAbs <= bAbs and aAbs <= cAbs):
            return 1.0 if a >= 0.0 else -1.0
        elif (bAbs <= aAbs and bAbs <= cAbs):
            return 1.0 if b >= 0.0 else -1.0
        else:
            return 1.0 if c >= 0.0 else -1.0
