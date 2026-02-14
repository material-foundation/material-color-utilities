import * as colorUtils from '../../../utils/color_utils.js';

interface ComputeResult {
    colorCount: number;
    centroidsBuffer: GPUBuffer;
    centroidsDeltaBuffer: GPUBuffer;
    assignPipeline: GPUComputePipeline;
    updatePipeline: GPUComputePipeline;
    computeBindGroup: GPUBindGroup;
}

export async function setupCompute(
    device: GPUDevice,
    pixels: number[],
    K: number
): Promise<ComputeResult> {
    const colorHistogram = new Map<number, number>();
    for (let i = 0; i < pixels.length; i++) {
        const pixel = pixels[i];
        const r = colorUtils.redFromArgb(pixel);
        const g = colorUtils.greenFromArgb(pixel);
        const b = colorUtils.blueFromArgb(pixel);
        const key = (r << 16) | (g << 8) | b;
        colorHistogram.set(key, (colorHistogram.get(key) ?? 0) + 1);
    }

    const colorCount = colorHistogram.size;
    const histogramArray = new Float32Array(colorCount * 4);
    let i = 0;
    for (const [key, count] of colorHistogram) {
        const r = (key >> 16) & 0xFF;
        const g = (key >> 8) & 0xFF;
        const b = key & 0xFF;

        histogramArray[i * 4] = r / 255;
        histogramArray[i * 4 + 1] = g / 255;
        histogramArray[i * 4 + 2] = b / 255;
        histogramArray[i * 4 + 3] = count;
        i++;
    }

    const countsUniformBuffer = device.createBuffer({
        size: 2 * Uint32Array.BYTES_PER_ELEMENT,
        usage: GPUBufferUsage.UNIFORM | GPUBufferUsage.COPY_DST
    });
    device.queue.writeBuffer(countsUniformBuffer, 0, new Uint32Array([K, colorCount]));

    const histogramBuffer = device.createBuffer({
        label: 'histogram-compute',
        size: histogramArray.byteLength,
        usage: GPUBufferUsage.STORAGE | GPUBufferUsage.COPY_DST
    });
    device.queue.writeBuffer(histogramBuffer, 0, histogramArray);

    const centroidsBuffer = device.createBuffer({
        label: 'centroids-compute',
        size: 3 * K * Float32Array.BYTES_PER_ELEMENT,
        usage: GPUBufferUsage.STORAGE | GPUBufferUsage.COPY_DST | GPUBufferUsage.COPY_SRC
    });

    const clustersBuffer = device.createBuffer({
        label: 'clusters-compute',
        size: colorCount * Uint32Array.BYTES_PER_ELEMENT,
        usage: GPUBufferUsage.STORAGE | GPUBufferUsage.COPY_SRC
    });

    const centroidsDeltaBuffer = device.createBuffer({
        label: 'centroids-delta-compute',
        size: K * Float32Array.BYTES_PER_ELEMENT,
        usage: GPUBufferUsage.STORAGE | GPUBufferUsage.COPY_SRC
    });

    const kUniformBuffer = device.createBuffer({
        size: Uint32Array.BYTES_PER_ELEMENT,
        usage: GPUBufferUsage.UNIFORM | GPUBufferUsage.COPY_DST
    });
    device.queue.writeBuffer(kUniformBuffer, 0, new Uint32Array([K]));

    const assignModule = device.createShaderModule({
        code: await fetch(new URL('../shaders/assign.wgsl', import.meta.url).toString()).then(res => res.text())
    });
    const updateModule = device.createShaderModule({
        code: await fetch(new URL('../shaders/update.wgsl', import.meta.url).toString()).then(res => res.text())
    });

    const computeBindGroupLayout = device.createBindGroupLayout({
        entries: [{
            binding: 0,
            visibility: GPUShaderStage.COMPUTE,
            buffer: { type: 'read-only-storage' }
        },
        {
            binding: 1,
            visibility: GPUShaderStage.COMPUTE,
            buffer: { type: 'uniform' }
        },
        {
            binding: 2,
            visibility: GPUShaderStage.COMPUTE,
            buffer: { type: 'storage' }
        },
        {
            binding: 3,
            visibility: GPUShaderStage.COMPUTE,
            buffer: { type: 'storage' }
        },
        {
            binding: 4,
            visibility: GPUShaderStage.COMPUTE,
            buffer: { type: 'storage' }
        }]
    });

    const computeBindGroup = device.createBindGroup({
        layout: computeBindGroupLayout,
        entries: [
            { binding: 0, resource: { buffer: histogramBuffer } },
            { binding: 1, resource: { buffer: countsUniformBuffer } },
            { binding: 2, resource: { buffer: centroidsBuffer } },
            { binding: 3, resource: { buffer: clustersBuffer } },
            { binding: 4, resource: { buffer: centroidsDeltaBuffer } }
        ]
    });
    const computePipelineLayout = device.createPipelineLayout({
        bindGroupLayouts: [computeBindGroupLayout]
    });

    const updatePipeline = device.createComputePipeline({
        layout: computePipelineLayout,
        compute: { module: updateModule }
    });
    const assignPipeline = device.createComputePipeline({
        layout: computePipelineLayout,
        compute: { module: assignModule }
    });

    return {
        colorCount,
        centroidsBuffer,
        centroidsDeltaBuffer,
        assignPipeline,
        updatePipeline,
        computeBindGroup
    };
} 