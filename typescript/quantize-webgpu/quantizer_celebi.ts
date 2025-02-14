import { extractDominantColorsWuGPU } from './wu/index.js';
import { extractDominantColorsKMeansGPU } from './kmeans/index.js';
import * as colorUtils from '../utils/color_utils.js';

export class QuantizerCelebi {
    static async quantize(pixels: number[], maxColors: number): Promise<number[]> {
        if (typeof navigator === 'undefined') {
            throw new Error('Not in browser environment');
        }

        const adapter = await navigator.gpu.requestAdapter();
        const device = await adapter.requestDevice();
        if (!device) {
            throw new Error('WebGPU not supported');
        }

        const textureData = colorUtils.pixelsToTextureData(pixels);
        const textureSize = pixels.length;
        const texture = device.createTexture({
            size: [textureSize, 1],
            format: 'rgba8unorm',
            usage: GPUTextureUsage.TEXTURE_BINDING | 
                   GPUTextureUsage.COPY_DST |
                   GPUTextureUsage.RENDER_ATTACHMENT |
                   GPUTextureUsage.STORAGE_BINDING |
                   GPUTextureUsage.COPY_SRC
        });

        device.queue.writeTexture(
            { texture },
            textureData,
            { bytesPerRow: pixels.length * 4, rowsPerImage: 1 },
            { width: pixels.length, height: 1 }
        );

        const wuResultsBuffer = await extractDominantColorsWuGPU(device, texture, textureSize, maxColors);
        const resultsBuffer = await extractDominantColorsKMeansGPU(device, pixels, maxColors, wuResultsBuffer);

        const stagingResultsBuffer = device.createBuffer({
            size: 3 * maxColors * Float32Array.BYTES_PER_ELEMENT,
            usage: GPUBufferUsage.COPY_DST | GPUBufferUsage.MAP_READ
        });

        const encoder = device.createCommandEncoder();
        encoder.copyBufferToBuffer(
            resultsBuffer, 0,
            stagingResultsBuffer, 0,
            3 * maxColors * Float32Array.BYTES_PER_ELEMENT
        );
        device.queue.submit([encoder.finish()]);

        await stagingResultsBuffer.mapAsync(GPUMapMode.READ, 0, 3 * maxColors * Float32Array.BYTES_PER_ELEMENT);
        const mappedData = stagingResultsBuffer.getMappedRange();
        const colors = new Float32Array(mappedData.slice(0));
        stagingResultsBuffer.unmap();

        const result = [];
        for (let i = 0; i < colors.length; i += 3) {
            const isValid = [colors[i], colors[i + 1], colors[i + 2]].every(x => !isNaN(x) && x >= 0);
            if (isValid) {
                const r = Math.round(colors[i] * 255);
                const g = Math.round(colors[i + 1] * 255);
                const b = Math.round(colors[i + 2] * 255);
                const argb = colorUtils.argbFromRgb(r, g, b);
                result.push(argb);
            }
        }

        texture.destroy();
        return result;
    }
}
