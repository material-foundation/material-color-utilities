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

from hct.hct import *
from collections import OrderedDict

# /**
#  *  A convenience class for retrieving colors that are constant in hue and
#  *  chroma, but vary in tone.
#  */
class TonalPalette:
    # Using OrderedDict() as replacement for Map()
    def __init__(self, hue, chroma):
        self.hue = hue
        self.chroma = chroma
        self.cache = OrderedDict()

    # /**
    #  * @param argb ARGB representation of a color
    #  * @return Tones matching that color's hue and chroma.
    #  */
    @staticmethod
    def fromInt(argb):
        hct = Hct.fromInt(argb)
        return TonalPalette.fromHueAndChroma(hct.hue, hct.chroma)

    # /**
    #  * @param hue HCT hue
    #  * @param chroma HCT chroma
    #  * @return Tones matching hue and chroma.
    #  */
    @staticmethod
    def fromHueAndChroma(hue, chroma):
        return TonalPalette(hue, chroma)

    # /**
    #  * @param tone HCT tone, measured from 0 to 100.
    #  * @return ARGB representation of a color with that tone.
    #  */
    def tone(self, tone):
        argb = None
        if (tone not in self.cache.keys()):
            argb = Hct.fromHct(self.hue, self.chroma, tone).toInt()
            self.cache[tone] = argb
        else:
            argb = self.cache[tone]
        return argb
