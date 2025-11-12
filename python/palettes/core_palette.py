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
from palettes.tonal_palette import *

# /**
#  * An intermediate concept between the key color for a UI theme, and a full
#  * color scheme. 5 sets of tones are generated, all except one use the same hue
#  * as the key color, and all vary in chroma.
#  */
class CorePalette:
    def __init__(self, argb):
        hct = Hct.fromInt(argb)
        hue = hct.hue
        self.a1 = TonalPalette.fromHueAndChroma(hue, max(48, hct.chroma))
        self.a2 = TonalPalette.fromHueAndChroma(hue, 16)
        self.a3 = TonalPalette.fromHueAndChroma(hue + 60, 24)
        self.n1 = TonalPalette.fromHueAndChroma(hue, 4)
        self.n2 = TonalPalette.fromHueAndChroma(hue, 8)
        self.error = TonalPalette.fromHueAndChroma(25, 84)

    # /**
    #  * @param argb ARGB representation of a color
    #  */
    @staticmethod
    def of(argb):
        return CorePalette(argb);
