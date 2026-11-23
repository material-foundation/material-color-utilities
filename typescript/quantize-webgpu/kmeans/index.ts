import { setupCompute } from './pipelines/compute.js';

export async function extractDominantColorsKMeansGPU(
    device: GPUDevice,
    pixels: number[],
    K: number,
    initialCentroidsBuffer: GPUBuffer | null = null
): Promise<GPUBuffer> {
    const MAX_ITERATIONS = 256;
    const CONVERGENCE_EPS = 0.01;
    const CONVERGENCE_CHECK = 8;

    const {
        colorCount,
        centroidsBuffer,
        centroidsDeltaBuffer,
        assignPipeline,
        updatePipeline,
        computeBindGroup
    } = await setupCompute(device, pixels, K);

    const stagingCentroidsDeltaBuffer = device.createBuffer({
        label: 'centroids-delta-staging',
        size: K * Float32Array.BYTES_PER_ELEMENT,
        usage: GPUBufferUsage.COPY_DST | GPUBufferUsage.MAP_READ
    });

    let encoder = device.createCommandEncoder();

    if (initialCentroidsBuffer) {
        encoder.copyBufferToBuffer(
            initialCentroidsBuffer, 0,
            centroidsBuffer, 0,
            3 * K * Float32Array.BYTES_PER_ELEMENT
        );
    } else {
        const centroids = new Float32Array(3 * K);
        for (let i = 0; i < 3 * K; i++) {
            centroids[i] = Math.random();
        }
        device.queue.writeBuffer(centroidsBuffer, 0, centroids);
    }

    for (let i = 0; i < MAX_ITERATIONS; i++) {
        const assignPass = encoder.beginComputePass();
        assignPass.setPipeline(assignPipeline);
        assignPass.setBindGroup(0, computeBindGroup);
        assignPass.dispatchWorkgroups(Math.ceil(colorCount / 256));
        assignPass.end();

        const updatePass = encoder.beginComputePass();
        updatePass.setPipeline(updatePipeline);
        updatePass.setBindGroup(0, computeBindGroup);
        updatePass.dispatchWorkgroups(Math.ceil(K / 16));
        updatePass.end();

        if (i !== 0 && i % CONVERGENCE_CHECK === 0) {
            encoder.copyBufferToBuffer(
                centroidsDeltaBuffer, 0,
                stagingCentroidsDeltaBuffer, 0,
                K * Float32Array.BYTES_PER_ELEMENT
            );

            const commandBuffer = encoder.finish();
            device.queue.submit([commandBuffer]);
            encoder = device.createCommandEncoder();

            await stagingCentroidsDeltaBuffer.mapAsync(GPUMapMode.READ, 0, K * Float32Array.BYTES_PER_ELEMENT);
            const centroidsDeltaData = new Float32Array(stagingCentroidsDeltaBuffer.getMappedRange());
            const deltaSum = centroidsDeltaData.reduce((acc, val) => acc + val, 0);
            stagingCentroidsDeltaBuffer.unmap();
            if (deltaSum < CONVERGENCE_EPS) {
                console.log(`Convergence reached at iteration ${i}`);
                break;
            }
        }
    }

    device.queue.submit([encoder.finish()]);
    await device.queue.onSubmittedWorkDone();

    return centroidsBuffer;
}

