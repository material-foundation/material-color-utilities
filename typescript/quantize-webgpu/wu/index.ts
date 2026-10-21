import { setupBuildHistogram } from './pipelines/buildHistogram.js';
import { setupComputeMoments } from './pipelines/computeMoments.js';
import { setupCreateBox } from './pipelines/createBox.js';
import { setupCreateResult } from './pipelines/createResult.js';

export async function extractDominantColorsWuGPU(
    device: GPUDevice,
    texture: GPUTexture,
    textureSize: number,
    K: number
): Promise<GPUBuffer> {
    const WORKGROUP_SIZE = 16;

    const TOTAL_SIZE = 35937;
    const {
        weightsBuffer,
        momentsRBuffer,
        momentsGBuffer,
        momentsBBuffer,
        momentsBuffer: mBuffer,
        buildHistogramPipeline,
        inputBindGroup,
        buildHistogramBindGroup,
        buildHistogramBindGroupLayout
    } = await setupBuildHistogram(device, texture);

    const {
        computeMomentsAxisBindGroups,
        computeMomentsPipeline
    } = await setupComputeMoments(device, buildHistogramBindGroupLayout);

    const {
        momentsBuffer,
        momentsBindGroup,
        totalCubesNumUniformBuffer,
        momentsBindGroupLayout,
        cubesBuffer,
        cubesBindGroup,
        createBoxPipeline
    } = await setupCreateBox(device, K);

    const {
        resultsBuffer,
        cubesResultBindGroup,
        resultsBindGroup,
        createResultPipeline
    } = await setupCreateResult(device, K, momentsBindGroupLayout, cubesBuffer, totalCubesNumUniformBuffer);

    let encoder = device.createCommandEncoder();
    const buildHistogramPass = encoder.beginComputePass();
    buildHistogramPass.setPipeline(buildHistogramPipeline);
    buildHistogramPass.setBindGroup(0, inputBindGroup);
    buildHistogramPass.setBindGroup(1, buildHistogramBindGroup);
    buildHistogramPass.dispatchWorkgroups(Math.ceil(textureSize / 256));
    buildHistogramPass.end();

    const workGroupsPerDim = Math.ceil(32 / WORKGROUP_SIZE);
    const momentPass = encoder.beginComputePass();
    momentPass.setPipeline(computeMomentsPipeline);
    momentPass.setBindGroup(0, buildHistogramBindGroup);
    for (let axis = 0; axis < 3; axis++) {
        momentPass.setBindGroup(1, computeMomentsAxisBindGroups[axis]);
        momentPass.dispatchWorkgroups(workGroupsPerDim, workGroupsPerDim);
    }
    momentPass.end();

    encoder.copyBufferToBuffer(
        momentsRBuffer, 0,
        momentsBuffer, 0,
        TOTAL_SIZE * Uint32Array.BYTES_PER_ELEMENT
    );
    encoder.copyBufferToBuffer(
        momentsGBuffer, 0,
        momentsBuffer, TOTAL_SIZE * Uint32Array.BYTES_PER_ELEMENT,
        TOTAL_SIZE * Uint32Array.BYTES_PER_ELEMENT
    );
    encoder.copyBufferToBuffer(
        momentsBBuffer, 0,
        momentsBuffer, 2 * TOTAL_SIZE * Uint32Array.BYTES_PER_ELEMENT,
        TOTAL_SIZE * Uint32Array.BYTES_PER_ELEMENT
    );
    encoder.copyBufferToBuffer(
        weightsBuffer, 0,
        momentsBuffer, 3 * TOTAL_SIZE * Uint32Array.BYTES_PER_ELEMENT,
        TOTAL_SIZE * Uint32Array.BYTES_PER_ELEMENT
    );
    encoder.copyBufferToBuffer(
        mBuffer, 0,
        momentsBuffer, 4 * TOTAL_SIZE * Uint32Array.BYTES_PER_ELEMENT,
        TOTAL_SIZE * Uint32Array.BYTES_PER_ELEMENT
    );
    device.queue.submit([encoder.finish()]);

    for (let i = 1; i < K; i++) {
        encoder = device.createCommandEncoder();
        const pass = encoder.beginComputePass();
        pass.setPipeline(createBoxPipeline);
        device.queue.writeBuffer(totalCubesNumUniformBuffer, 0, new Uint32Array([i]));

        pass.setBindGroup(0, momentsBindGroup);
        pass.setBindGroup(1, cubesBindGroup);
        pass.dispatchWorkgroups(1);
        pass.end();
        device.queue.submit([encoder.finish()]);
    }

    encoder = device.createCommandEncoder();
    const pass = encoder.beginComputePass();
    pass.setPipeline(createResultPipeline);
    pass.setBindGroup(0, momentsBindGroup);
    pass.setBindGroup(1, cubesResultBindGroup);
    pass.setBindGroup(2, resultsBindGroup);
    pass.dispatchWorkgroups(1);
    pass.end();
    device.queue.submit([encoder.finish()]);
    await device.queue.onSubmittedWorkDone();

    return resultsBuffer;
}
