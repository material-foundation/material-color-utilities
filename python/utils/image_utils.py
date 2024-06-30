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

from quantize.quantizer_celebi import *
from score.score import *
from utils.color_utils import *
from PIL import Image

# /**
#  * Get the source color from an image.
#  *
#  * @param image The image element
#  * @return Source color - the color most suitable for creating a UI theme
#  */
def sourceColorFromImage(image):
    # // Convert Image data to Pixel Array
    # const imageBytes = await new Promise((resolve, reject) => {
    #     const canvas = document.createElement('canvas');
    #     const context = canvas.getContext('2d');
    #     if (!context) {
    #         return reject(new Error('Could not get canvas context'));
    #     }
    #     image.onload = () => {
    #         canvas.width = image.width;
    #         canvas.height = image.height;
    #         context.drawImage(image, 0, 0);
    #         resolve(context.getImageData(0, 0, image.width, image.height).data);
    #     };
    # });
    # // Convert Image data to Pixel Array
    # const pixels = [];
    # for (let i = 0; i < imageBytes.length; i += 4) {
    #     const r = imageBytes[i];
    #     const g = imageBytes[i + 1];
    #     const b = imageBytes[i + 2];
    #     const a = imageBytes[i + 3];
    #     if (a < 255) {
    #         continue;
    #     }
    #     const argb = argbFromRgb(r, g, b);
    #     pixels.push(argb);
    # }
    if (image.mode == 'RGB'):
        image = image.convert('RGBA')
    if (image.mode != 'RGBA'):
        print("Warning: Image not in RGB|RGBA format - Converting...")
        image = image.convert('RGBA')

    pixels = []
    for x in range(image.width):
        for y in range(image.height):
            # for the given pixel at w,h, lets check its value against the threshold
            pixel = image.getpixel((x, y))
            r = pixel[0]
            g = pixel[1]
            b = pixel[2]
            a = pixel[3]
            if (a < 255):
                continue
            argb = argbFromRgb(r, g, b)
            pixels.append(argb)

    # // Convert Pixels to Material Colors
    result = QuantizerCelebi.quantize(pixels, 128)
    ranked = Score.score(result)
    top = ranked[0]
    return top
