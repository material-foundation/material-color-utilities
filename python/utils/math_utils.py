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

#
# Utility methods for mathematical operations.
# 
#
# The signum function.
#  
# @return 1 if num > 0, -1 if num < 0, and 0 if num = 0
#
def signum(num):
    if (num < 0):
        return -1
    elif (num == 0):
        return 0
    else:
        return 1

# /**
#  * The linear interpolation function.
#  *
#  * @return start if amount = 0 and stop if amount = 1
#  */
def lerp(start, stop, amount):
    return (1.0 - amount) * start + amount * stop

# /**
#  * Clamps an integer between two integers.
#  *
#  * @return input when min <= input <= max, and either min or max
#  * otherwise.
#  */
def clampInt(min, max, input):
    if (input < min):
        return min
    elif (input > max):
        return max
    return input

# /**
#  * Clamps an integer between two floating-point numbers.
#  *
#  * @return input when min <= input <= max, and either min or max
#  * otherwise.
#  */
def clampDouble(min, max, input):
    if (input < min):
        return min
    elif (input > max):
        return max
    return input

# /**
#  * Sanitizes a degree measure as an integer.
#  *
#  * @return a degree measure between 0 (inclusive) and 360
#  * (exclusive).
#  */
def sanitizeDegreesInt(degrees):
    degrees = degrees % 360
    if (degrees < 0):
        degrees = degrees + 360
    return degrees

# /**
#  * Sanitizes a degree measure as a floating-point number.
#  *
#  * @return a degree measure between 0.0 (inclusive) and 360.0
#  * (exclusive).
#  */
def sanitizeDegreesDouble(degrees):
    degrees = degrees % 360.0
    if (degrees < 0):
        degrees = degrees + 360.0
    return degrees

# /**
#  * Distance of two points on a circle, represented using degrees.
#  */
def differenceDegrees(a, b):
    return 180.0 - abs(abs(a - b) - 180.0)

# /**
#  * Multiplies a 1x3 row vector with a 3x3 matrix.
#  */
def matrixMultiply(row, matrix):
    a = row[0] * matrix[0][0] + row[1] * matrix[0][1] + row[2] * matrix[0][2]
    b = row[0] * matrix[1][0] + row[1] * matrix[1][1] + row[2] * matrix[1][2]
    c = row[0] * matrix[2][0] + row[1] * matrix[2][1] + row[2] * matrix[2][2]
    return [a, b, c];