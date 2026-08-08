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

# /**
#  * Utility methods for hexadecimal representations of colors.
#  */
# /**
#  * @param argb ARGB representation of a color.
#  * @return Hex string representing color, ex. #ff0000 for red.
#  */
def hexFromArgb(argb):
    r = redFromArgb(argb)
    g = greenFromArgb(argb)
    b = blueFromArgb(argb)
    outParts = [f'{r:x}', f'{g:x}', f'{b:x}']
    # Pad single-digit output values
    for i, part in enumerate(outParts):
        if (len(part) == 1):
            outParts[i] = '0' + part
    return '#' + ''.join(outParts)

# /**
#  * @param hex String representing color as hex code. Accepts strings with or
#  *     without leading #, and string representing the color using 3, 6, or 8
#  *     hex characters.
#  * @return ARGB representation of color.
#  */
def parseIntHex(value):
    # tslint:disable-next-line:ban
    return int(value, 16)

def argbFromHex(hex):
    hex = hex.replace('#', '')
    isThree = len(hex) == 3
    isSix = len(hex) == 6
    isEight = len(hex) == 8
    if (not isThree and not isSix and not isEight):
        raise Exception('unexpected hex ' + hex)
    
    r = 0
    g = 0
    b = 0
    if (isThree):
        r = parseIntHex(hex[0:1]*2)
        g = parseIntHex(hex[1:2]*2)
        b = parseIntHex(hex[2:3]*2)
    elif (isSix):
        r = parseIntHex(hex[0:2])
        g = parseIntHex(hex[2:4])
        b = parseIntHex(hex[4:6])
    elif (isEight):
        r = parseIntHex(hex[2:4])
        g = parseIntHex(hex[4:6])
        b = parseIntHex(hex[6:8])
    
    return rshift(((255 << 24) | ((r & 0x0ff) << 16) | ((g & 0x0ff) << 8) | (b & 0x0ff)), 0)
