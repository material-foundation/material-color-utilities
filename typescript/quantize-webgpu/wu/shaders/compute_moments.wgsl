@group(0) @binding(0) var<storage, read_write> weights: array<u32>;
@group(0) @binding(1) var<storage, read_write> moments_r: array<u32>;
@group(0) @binding(2) var<storage, read_write> moments_g: array<u32>;
@group(0) @binding(3) var<storage, read_write> moments_b: array<u32>;
@group(0) @binding(4) var<storage, read_write> moments: array<u32>;

@group(1) @binding(0) var<uniform> axis: u32;

const INDEX_BITS = 5u;
const SIDE_LENGTH = 33u;

fn get_index(r: u32, g: u32, b: u32) -> u32 {
    return (r << (2 * INDEX_BITS)) + (r << (INDEX_BITS + 1)) + r + (g << INDEX_BITS) + g + b;
}

@compute @workgroup_size(16, 16)
fn cs(@builtin(global_invocation_id) id: vec3u) {
    let x = id.x + 1u;
    let y = id.y + 1u;

    if (x >= SIDE_LENGTH || y >= SIDE_LENGTH) {
        return;
    }
    
    var index = 0u;
    var sum_weights = 0u;
    var sum_moments_r = 0u;
    var sum_moments_g = 0u;
    var sum_moments_b = 0u;
    var sum_moments = 0f;
    for (var i = 1u; i < SIDE_LENGTH; i++) {
        if (axis == 0u) {
            index = get_index(i, x, y);
        } else if (axis == 1u) {
            index = get_index(x, i, y);
        } else {
            index = get_index(x, y, i);
        }

        sum_weights += weights[index];
        sum_moments_r += moments_r[index];
        sum_moments_g += moments_g[index];
        sum_moments_b += moments_b[index];

        // to prevent u32 overflow in moments, they are stored as f32 bitcasted to u32
        // after the first axis pass, they are all bitcasted f32
        // using f32 initially is not possible since atomic operations are used in build_histogram
        if (axis == 0) {
            sum_moments += f32(moments[index]);
        } else {
            sum_moments += bitcast<f32>(moments[index]);
        }

        weights[index] = sum_weights;
        moments_r[index] = sum_moments_r;
        moments_g[index] = sum_moments_g;
        moments_b[index] = sum_moments_b;
        moments[index] = bitcast<u32>(sum_moments);
    }
}
