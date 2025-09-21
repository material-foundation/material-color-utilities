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

# /**
#  * A color system built using CAM16 hue and chroma, and L* from
#  * L*a*b*.
#  *
#  * Using L* creates a link between the color system, contrast, and thus
#  * accessibility. Contrast ratio depends on relative luminance, or Y in the XYZ
#  * color space. L*, or perceptual luminance can be calculated from Y.
#  *
#  * Unlike Y, L* is linear to human perception, allowing trivial creation of
#  * accurate color tones.
#  *
#  * Unlike contrast ratio, measuring contrast in L* is linear, and simple to
#  * calculate. A difference of 40 in HCT tone guarantees a contrast ratio >= 3.0,
#  * and a difference of 50 guarantees a contrast ratio >= 4.5.
#  */
from utils.color_utils import *
from utils.math_utils import *
from hct.cam16 import *
from hct.viewing_conditions import *

# /**
#  * When the delta between the floor & ceiling of a binary search for maximum
#  * chroma at a hue and tone is less than this, the binary search terminates.
#  */
CHROMA_SEARCH_ENDPOINT = 0.4

# /**
#  * The maximum color distance, in CAM16-UCS, between a requested color and the
#  * color returned.
#  */
DE_MAX = 1.0

# /** The maximum difference between the requested L* and the L* returned. */
DL_MAX = 0.2

# /**
#  * When the delta between the floor & ceiling of a binary search for J,
#  * lightness in CAM16, is less than this, the binary search terminates.
#  */
LIGHTNESS_SEARCH_ENDPOINT = 0.01

# /**
#  * @param hue CAM16 hue
#  * @param chroma CAM16 chroma
#  * @param tone L*a*b* lightness
#  * @return CAM16 instance within error tolerance of the provided dimensions,
#  *     or null.
#  */
def findCamByJ(hue, chroma, tone):
    low = 0.0
    high = 100.0
    mid = 0.0
    bestdL = 1000.0
    bestdE = 1000.0
    bestCam = None
    while (abs(low - high) > LIGHTNESS_SEARCH_ENDPOINT):
        mid = low + (high - low) / 2
        camBeforeClip = Cam16.fromJch(mid, chroma, hue)
        clipped = camBeforeClip.toInt()
        clippedLstar = lstarFromArgb(clipped)
        dL = abs(tone - clippedLstar)
        if (dL < DL_MAX):
            camClipped = Cam16.fromInt(clipped)
            dE = camClipped.distance(Cam16.fromJch(camClipped.j, camClipped.chroma, hue))
            if (dE <= DE_MAX and dE <= bestdE):
                bestdL = dL
                bestdE = dE
                bestCam = camClipped
        if (bestdL == 0 and bestdE == 0):
            break
        if (clippedLstar < tone):
            low = mid
        else:
            high = mid
    return bestCam

# /**
#  * @param hue CAM16 hue.
#  * @param chroma CAM16 chroma.
#  * @param tone L*a*b* lightness.
#  * @param viewingConditions Information about the environment where the color
#  *     was observed.
#  */
def getIntInViewingConditions(hue, chroma, tone, viewingConditions):
    if (chroma < 1.0 or round(tone) <= 0.0 or round(tone) >= 100.0):
        return argbFromLstar(tone)

    hue = sanitizeDegreesDouble(hue)
    high = chroma
    mid = chroma
    low = 0.0
    isFirstLoop = True
    answer = None
    while (abs(low - high) >= CHROMA_SEARCH_ENDPOINT):
        possibleAnswer = findCamByJ(hue, mid, tone)
        if (isFirstLoop):
            if (possibleAnswer != None):
                return possibleAnswer.viewed(viewingConditions)
            else:
                isFirstLoop = False
                mid = low + (high - low) / 2.0
                continue
        if (possibleAnswer == None):
            high = mid
        else:
            answer = possibleAnswer
            low = mid
        mid = low + (high - low) / 2.0
    if (answer == None):
        return argbFromLstar(tone)
    return answer.viewed(viewingConditions)

# /**
#  * @param hue a number, in degrees, representing ex. red, orange, yellow, etc.
#  *     Ranges from 0 <= hue < 360.
#  * @param chroma Informally, colorfulness. Ranges from 0 to roughly 150.
#  *    Like all perceptually accurate color systems, chroma has a different
#  *    maximum for any given hue and tone, so the color returned may be lower
#  *    than the requested chroma.
#  * @param tone Lightness. Ranges from 0 to 100.
#  * @return ARGB representation of a color in default viewing conditions
#  */
def getInt(hue, chroma, tone):
    return getIntInViewingConditions(sanitizeDegreesDouble(hue), chroma, clampDouble(0.0, 100.0, tone), ViewingConditions.DEFAULT)

# /**
#  * HCT, hue, chroma, and tone. A color system that provides a perceptually
#  * accurate color measurement system that can also accurately render what colors
#  * will appear as in different lighting environments.
#  */
class Hct:
    def __init__(self, internalHue, internalChroma, internalTone):
        self.internalHue = internalHue
        self.internalChroma = internalChroma
        self.internalTone = internalTone
        self.setInternalState(self.toInt())

    # /**
    #  * @param hue 0 <= hue < 360; invalid values are corrected.
    #  * @param chroma 0 <= chroma < ?; Informally, colorfulness. The color
    #  *     returned may be lower than the requested chroma. Chroma has a different
    #  *     maximum for any given hue and tone.
    #  * @param tone 0 <= tone <= 100; invalid values are corrected.
    #  * @return HCT representation of a color in default viewing conditions.
    #  */
    # Function renamed from "from" to "fromHct", from is reserved in Python
    @staticmethod
    def fromHct(hue, chroma, tone):
        return Hct(hue, chroma, tone)

    # /**
    #  * @param argb ARGB representation of a color.
    #  * @return HCT representation of a color in default viewing conditions
    #  */
    @staticmethod
    def fromInt(argb):
        cam = Cam16.fromInt(argb)
        tone = lstarFromArgb(argb)
        return Hct(cam.hue, cam.chroma, tone)

    def toInt(self):
        return getInt(self.internalHue, self.internalChroma, self.internalTone)

    # /**
    #  * A number, in degrees, representing ex. red, orange, yellow, etc.
    #  * Ranges from 0 <= hue < 360.
    #  */
    def get_hue(self):
        return self.internalHue

    # /**
    #  * @param newHue 0 <= newHue < 360; invalid values are corrected.
    #  * Chroma may decrease because chroma has a different maximum for any given
    #  * hue and tone.
    #  */
    def set_hue(self, newHue):
        self.setInternalState(getInt(sanitizeDegreesDouble(newHue), self.internalChroma, self.internalTone))

    def get_chroma(self):
        return self.internalChroma

    # /**
    #  * @param newChroma 0 <= newChroma < ?
    #  * Chroma may decrease because chroma has a different maximum for any given
    #  * hue and tone.
    #  */
    def set_chroma(self, newChroma):
        self.setInternalState(getInt(self.internalHue, newChroma, self.internalTone))

    # /** Lightness. Ranges from 0 to 100. */
    def get_tone(self):
        return self.internalTone

    # /**
    #  * @param newTone 0 <= newTone <= 100; invalid valids are corrected.
    #  * Chroma may decrease because chroma has a different maximum for any given
    #  * hue and tone.
    #  */
    def set_tone(self, newTone):
        self.setInternalState(getInt(self.internalHue, self.internalChroma, newTone))

    def setInternalState(self, argb):
        cam = Cam16.fromInt(argb)
        tone = lstarFromArgb(argb)
        self.internalHue = cam.hue
        self.internalChroma = cam.chroma
        self.internalTone = tone

    # Adding properties for getters and setters
    hue = property(get_hue, set_hue)
    chroma = property(get_chroma, set_chroma)
    tone = property(get_tone, set_tone)
