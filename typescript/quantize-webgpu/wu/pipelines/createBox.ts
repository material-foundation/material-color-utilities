interface CreateBoxResult {
    momentsBuffer: GPUBuffer;
    momentsBindGroup: GPUBindGroup;
    cubesBuffer: GPUBuffer;
    totalCubesNumUniformBuffer: GPUBuffer;
    momentsBindGroupLayout: GPUBindGroupLayout;
    cubesBindGroup: GPUBindGroup;
    createBoxPipeline: GPUComputePipeline;
}

export async function setupCreateBox(device: GPUDevice, K: number): Promise<CreateBoxResult> {
    const SIDE_LENGTH = 33;
    const TOTAL_SIZE = 35937;

    const momentsBuffer = device.createBuffer({
        size: 5 * TOTAL_SIZE * Uint32Array.BYTES_PER_ELEMENT,
        usage: GPUBufferUsage.STORAGE | GPUBufferUsage.COPY_DST
    });
    const momentsBindGroupLayout = device.createBindGroupLayout({
        entries: [{
            binding: 0,
            visibility: GPUShaderStage.COMPUTE,
            buffer: { type: 'read-only-storage' }
        }]
    });
    const momentsBindGroup = device.createBindGroup({
        layout: momentsBindGroupLayout,
        entries: [
            { binding: 0, resource: { buffer: momentsBuffer } }
        ]
    });

    const cubesBuffer = device.createBuffer({
        size: 6 * K * Uint32Array.BYTES_PER_ELEMENT,
        usage: GPUBufferUsage.STORAGE | GPUBufferUsage.COPY_DST
    });
    device.queue.writeBuffer(cubesBuffer, 0, new Uint32Array([0, SIDE_LENGTH - 1, 0, SIDE_LENGTH - 1, 0, SIDE_LENGTH - 1]));

    const variancesBuffer = device.createBuffer({
        size: K * Float32Array.BYTES_PER_ELEMENT,
        usage: GPUBufferUsage.STORAGE
    });
    const currentCubeIdxBuffer = device.createBuffer({
        size: Uint32Array.BYTES_PER_ELEMENT,
        usage: GPUBufferUsage.STORAGE
    });
    const totalCubesNumUniformBuffer = device.createBuffer({
        size: Uint32Array.BYTES_PER_ELEMENT,
        usage: GPUBufferUsage.UNIFORM | GPUBufferUsage.COPY_DST
    });
    const cubesBindGroupLayout = device.createBindGroupLayout({
        entries: [{
            binding: 0,
            visibility: GPUShaderStage.COMPUTE,
            buffer: { type: 'storage' }
        }, {
            binding: 1,
            visibility: GPUShaderStage.COMPUTE,
            buffer: { type: 'storage' }
        }, {
            binding: 2,
            visibility: GPUShaderStage.COMPUTE,
            buffer: { type: 'storage' }
        }, {
            binding: 3,
            visibility: GPUShaderStage.COMPUTE,
            buffer: { type: 'uniform' }
        }]
    });
    const cubesBindGroup = device.createBindGroup({
        layout: cubesBindGroupLayout,
        entries: [
            { binding: 0, resource: { buffer: cubesBuffer } },
            { binding: 1, resource: { buffer: variancesBuffer } },
            { binding: 2, resource: { buffer: currentCubeIdxBuffer } },
            { binding: 3, resource: { buffer: totalCubesNumUniformBuffer } }
        ]
    });

    const createBoxModule = device.createShaderModule({
        code: await fetch(new URL('../shaders/create_box.wgsl', import.meta.url).toString()).then(res => res.text())
    });
    const createBoxPipelineLayout = device.createPipelineLayout({
        bindGroupLayouts: [momentsBindGroupLayout, cubesBindGroupLayout]
    });
    const createBoxPipeline = device.createComputePipeline({
        layout: createBoxPipelineLayout,
        compute: { module: createBoxModule }
    });

    return {
        momentsBuffer,
        momentsBindGroup,
        cubesBuffer,
        totalCubesNumUniformBuffer,
        momentsBindGroupLayout,
        cubesBindGroup,
        createBoxPipeline
    };
} 