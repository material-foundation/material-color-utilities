/**
 * @license
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

import {rankedColorsFromImageBytes} from './image_utils_converter.js';

/**
 * Get the source color from an image.
 *
 * @param image The image element
 * @return Source color - the color most suitable for creating a UI theme
 */
export async function sourceColorFromImage(image: HTMLImageElement) {
  // Convert Image data to Pixel Array
  const imageBytes = await new Promise<Uint8ClampedArray>((resolve, reject) => {
    const element = document.createElement('canvas');
    const canvas = 'OffscreenCanvas' in window ? element.transferControlToOffscreen() : element;
    const context = canvas.getContext('2d');
    if (!context) {
      reject(new Error('Could not get canvas context'));
      return;
    }
    const loadCallback = () => {
      canvas.width = image.width;
      canvas.height = image.height;
      // @ts-ignore
      context.drawImage(image, 0, 0);
      let rect = [0, 0, image.width, image.height];
      const area = image.dataset['area'];
      if (area && /^\d+(\s*,\s*\d+){3}$/.test(area)) {
        rect = area.split(/\s*,\s*/).map(s => {
          // tslint:disable-next-line:ban
          return parseInt(s, 10);
        });
      }
      const [sx, sy, sw, sh] = rect;
      // @ts-ignore
      resolve(context.getImageData(sx, sy, sw, sh).data);
    };
    const errorCallback = () => {
      reject(new Error('Image load failed'));
    };
    if (image.complete) {
      loadCallback();
    } else {
      image.onload = loadCallback;
      image.onerror = errorCallback;
    }
  });

  let ranked: number[];

  if (window.Worker) {
    const worker = new Worker(new URL('./image_utils_worker.js', import.meta.url), {type: 'module'});

    worker.postMessage(imageBytes);
  
    ranked = await new Promise((resolve) => {
      worker.onmessage = (event) => {
        const ranked = event.data;
        resolve(ranked);
      };
    });
  } else {
    ranked = rankedColorsFromImageBytes(imageBytes);
  }

  const top = ranked[0];
  return top;
}
