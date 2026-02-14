interface CreateResultResult {
    resultsBuffer: GPUBuffer;
    cubesResultBindGroup: GPUBindGroup;
    resultsBindGroup: GPUBindGroup;
    createResultPipeline: GPUComputePipeline;
}

export async function setupCreateResult(
    device: GPUDevice,
    K: number,
    momentsBindGroupLayout: GPUBindGroupLayout,
    cubesBuffer: GPUBuffer,
    totalCubesNumUniformBuffer: GPUBuffer
): Promise<CreateResultResult> {
    const cubesResultBindGroupLayout = device.createBindGroupLayout({
        entries: [{
            binding: 0,
            visibility: GPUShaderStage.COMPUTE,
            buffer: { type: 'read-only-storage' }
        }, {
            binding: 1,
            visibility: GPUShaderStage.COMPUTE,
            buffer: { type: 'uniform' }
        }]
    });
    const cubesResultBindGroup = device.createBindGroup({
        layout: cubesResultBindGroupLayout,
        entries: [
            { binding: 0, resource: { buffer: cubesBuffer } },
            { binding: 1, resource: { buffer: totalCubesNumUniformBuffer } }
        ]
    });

    const resultsBuffer = device.createBuffer({
        size: 3 * K * Float32Array.BYTES_PER_ELEMENT,
        usage: GPUBufferUsage.STORAGE | GPUBufferUsage.COPY_SRC
    });
    const resultsBindGroupLayout = device.createBindGroupLayout({
        entries: [{
            binding: 0,
            visibility: GPUShaderStage.COMPUTE,
            buffer: { type: 'storage' }
        }]
    });
    const resultsBindGroup = device.createBindGroup({
        layout: resultsBindGroupLayout,
        entries: [
            { binding: 0, resource: { buffer: resultsBuffer } }
        ]
    });

    const createResultModule = device.createShaderModule({
        code: await fetch(new URL('../shaders/create_result.wgsl', import.meta.url).toString()).then(res => res.text())
    });
    const createResultPipelineLayout = device.createPipelineLayout({
        bindGroupLayouts: [momentsBindGroupLayout, cubesResultBindGroupLayout, resultsBindGroupLayout]
    });
    const createResultPipeline = device.createComputePipeline({
        layout: createResultPipelineLayout,
        compute: { module: createResultModule }
    });

    return {
        resultsBuffer,
        cubesResultBindGroup,
        resultsBindGroup,
        createResultPipeline
    };
} 