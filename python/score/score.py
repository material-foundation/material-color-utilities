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
from utils.color_utils import *
from utils.math_utils import *
from collections import OrderedDict

# /**
#  *  Given a large set of colors, remove colors that are unsuitable for a UI
#  *  theme, and rank the rest based on suitability.
#  *
#  *  Enables use of a high cluster count for image quantization, thus ensuring
#  *  colors aren't muddied, while curating the high cluster count to a much
#  *  smaller number of appropriate choices.
#  */
class Score:
    def __init__(self):
        pass

    # /**
    #  * Given a map with keys of colors and values of how often the color appears,
    #  * rank the colors based on suitability for being used for a UI theme.
    #  *
    #  * @param colorsToPopulation map with keys of colors and values of how often
    #  *     the color appears, usually from a source image.
    #  * @return Colors sorted by suitability for a UI theme. The most suitable
    #  *     color is the first item, the least suitable is the last. There will
    #  *     always be at least one color returned. If all the input colors
    #  *     were not suitable for a theme, a default fallback color will be
    #  *     provided, Google Blue.
    #  */
    # Using OrderedDict for JavaScript Map
    @staticmethod
    def score(colorsToPopulation):
        # // Determine the total count of all colors.
        populationSum = 0
        for population in colorsToPopulation.values():
            populationSum += population
        # // Turn the count of each color into a proportion by dividing by the total
        # // count. Also, fill a cache of CAM16 colors representing each color, and
        # // record the proportion of colors for each CAM16 hue.
        colorsToProportion = OrderedDict()
        colorsToCam = OrderedDict()
        hueProportions = [0] * 361
        for (color, population) in colorsToPopulation.items():
            proportion = population / populationSum
            colorsToProportion[color] = proportion
            cam = Cam16.fromInt(color)
            colorsToCam[color] = cam
            hue = round(cam.hue)
            hueProportions[hue] += proportion
        # // Determine the proportion of the colors around each color, by summing the
        # // proportions around each color's hue.
        colorsToExcitedProportion = OrderedDict()
        for (color, cam) in colorsToCam.items():
            hue = round(cam.hue)
            excitedProportion = 0
            for i in range((hue - 15), (hue + 15)):
                neighborHue = sanitizeDegreesInt(i)
                excitedProportion += hueProportions[neighborHue]
            colorsToExcitedProportion[color] = excitedProportion
        # // Score the colors by their proportion, as well as how chromatic they are.
        colorsToScore = OrderedDict()
        for (color, cam) in colorsToCam.items():
            proportion = colorsToExcitedProportion[color]
            proportionScore = proportion * 100.0 * Score.WEIGHT_PROPORTION
            chromaWeight = Score.WEIGHT_CHROMA_BELOW if cam.chroma < Score.TARGET_CHROMA else Score.WEIGHT_CHROMA_ABOVE
            chromaScore = (cam.chroma - Score.TARGET_CHROMA) * chromaWeight
            score = proportionScore + chromaScore
            colorsToScore[color] = score
        # // Remove colors that are unsuitable, ex. very dark or unchromatic colors.
        # // Also, remove colors that are very similar in hue.
        filteredColors = Score.filter(colorsToExcitedProportion, colorsToCam)
        dedupedColorsToScore = OrderedDict()
        for color in filteredColors:
            duplicateHue = False
            hue = colorsToCam[color].hue
            for alreadyChosenColor in dedupedColorsToScore:
                alreadyChosenHue = colorsToCam[alreadyChosenColor].hue
                if (differenceDegrees(hue, alreadyChosenHue) < 15):
                    duplicateHue = True
                    break
            if (duplicateHue):
                continue
            dedupedColorsToScore[color] = colorsToScore[color]
        # // Ensure the list of colors returned is sorted such that the first in the
        # // list is the most suitable, and the last is the least suitable.
        colorsByScoreDescending = list(dedupedColorsToScore.items())
        colorsByScoreDescending.sort(reverse = True, key = lambda x: x[1])
        answer = list(map(lambda x: x[0], colorsByScoreDescending))
        # // Ensure that at least one color is returned.
        if (len(answer) == 0):
            answer.append(0xff4285F4) # // Google Blue
        return answer

    @staticmethod
    def filter(colorsToExcitedProportion, colorsToCam):
        filtered = []
        for (color, cam) in colorsToCam.items():
            proportion = colorsToExcitedProportion[color]
            if (cam.chroma >= Score.CUTOFF_CHROMA and
                lstarFromArgb(color) >= Score.CUTOFF_TONE and
                proportion >= Score.CUTOFF_EXCITED_PROPORTION):
                filtered.append(color)
        return filtered

Score.TARGET_CHROMA = 48.0
Score.WEIGHT_PROPORTION = 0.7
Score.WEIGHT_CHROMA_ABOVE = 0.3
Score.WEIGHT_CHROMA_BELOW = 0.1
Score.CUTOFF_CHROMA = 15.0
Score.CUTOFF_TONE = 10.0
Score.CUTOFF_EXCITED_PROPORTION = 0.01
