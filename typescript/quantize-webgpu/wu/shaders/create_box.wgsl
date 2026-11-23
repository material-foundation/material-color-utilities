const INDEX_BITS = 5u;
const SIDE_LENGTH = 33u;
const TOTAL_SIZE = 35937u;

struct Box {
    r0: u32,
    r1: u32,
    g0: u32,
    g1: u32,
    b0: u32,
    b1: u32
}

struct Moments {
    r: array<u32, TOTAL_SIZE>,
    g: array<u32, TOTAL_SIZE>,
    b: array<u32, TOTAL_SIZE>,
    w: array<u32, TOTAL_SIZE>,
    quad: array<f32, TOTAL_SIZE>
}

var<workgroup> cut_variances_r: array<f32, SIDE_LENGTH>;
var<workgroup> cut_variances_g: array<f32, SIDE_LENGTH>;
var<workgroup> cut_variances_b: array<f32, SIDE_LENGTH>;
var<workgroup> best_cut: array<u32, 3>;

@group(0) @binding(0) var<storage> moments: Moments;

@group(1) @binding(0) var<storage, read_write> cubes: array<Box>;
@group(1) @binding(1) var<storage, read_write> variances: array<f32>;
@group(1) @binding(2) var<storage, read_write> current_cube_idx: u32;
@group(1) @binding(3) var<uniform> total_cubes_num: u32;

fn get_index(r: u32, g: u32, b: u32) -> u32 {
    return (r << (2 * INDEX_BITS)) + (r << (INDEX_BITS + 1)) + r + (g << INDEX_BITS) + g + b;
}

fn volume(cube: Box, moment: ptr<storage, array<u32, TOTAL_SIZE>>) -> f32 {
    return f32(
        (*moment)[get_index(cube.r1, cube.g1, cube.b1)] -
        (*moment)[get_index(cube.r1, cube.g1, cube.b0)] -
        (*moment)[get_index(cube.r1, cube.g0, cube.b1)] +
        (*moment)[get_index(cube.r1, cube.g0, cube.b0)] -
        (*moment)[get_index(cube.r0, cube.g1, cube.b1)] +
        (*moment)[get_index(cube.r0, cube.g1, cube.b0)] +
        (*moment)[get_index(cube.r0, cube.g0, cube.b1)] -
        (*moment)[get_index(cube.r0, cube.g0, cube.b0)]
    );
}

fn variance(cube: Box) -> f32 {
    let vol = volume(cube, &moments.w);
    if (vol <= 1f) {
        return 0f;
    }
    let dr = volume(cube, &moments.r);
    let dg = volume(cube, &moments.g);
    let db = volume(cube, &moments.b);
    let xx = moments.quad[get_index(cube.r1, cube.g1, cube.b1)] -
        moments.quad[get_index(cube.r1, cube.g1, cube.b0)] -
        moments.quad[get_index(cube.r1, cube.g0, cube.b1)] +
        moments.quad[get_index(cube.r1, cube.g0, cube.b0)] -
        moments.quad[get_index(cube.r0, cube.g1, cube.b1)] +
        moments.quad[get_index(cube.r0, cube.g1, cube.b0)] +
        moments.quad[get_index(cube.r0, cube.g0, cube.b1)] -
        moments.quad[get_index(cube.r0, cube.g0, cube.b0)];
    let hypotenuse = dr * dr + dg * dg + db * db;
    return xx - hypotenuse / vol;
}

fn bottom(cube: Box, dir: u32, moment: ptr<storage, array<u32, TOTAL_SIZE>>) -> f32 {
    if (dir == 0) {
        return f32(
            (*moment)[get_index(cube.r0, cube.g1, cube.b0)] -
            (*moment)[get_index(cube.r0, cube.g1, cube.b1)] +
            (*moment)[get_index(cube.r0, cube.g0, cube.b1)] -
            (*moment)[get_index(cube.r0, cube.g0, cube.b0)]
        );
    } else if (dir == 1) {
        return f32(
            (*moment)[get_index(cube.r1, cube.g0, cube.b0)] -
            (*moment)[get_index(cube.r1, cube.g0, cube.b1)] +
            (*moment)[get_index(cube.r0, cube.g0, cube.b1)] -
            (*moment)[get_index(cube.r0, cube.g0, cube.b0)]
        );
    } else if (dir == 2) {
        return f32(
            (*moment)[get_index(cube.r1, cube.g0, cube.b0)] -
            (*moment)[get_index(cube.r1, cube.g1, cube.b0)] +
            (*moment)[get_index(cube.r0, cube.g1, cube.b0)] -
            (*moment)[get_index(cube.r0, cube.g0, cube.b0)]
        );
    }
    return 0;
}

fn top(cube: Box, dir: u32, cut: u32, moment: ptr<storage, array<u32, TOTAL_SIZE>>) -> f32 {
    if (dir == 0) {
        return f32(
            (*moment)[get_index(cut, cube.g1, cube.b1)] -
            (*moment)[get_index(cut, cube.g1, cube.b0)] -
            (*moment)[get_index(cut, cube.g0, cube.b1)] +
            (*moment)[get_index(cut, cube.g0, cube.b0)]
        );
    } else if (dir == 1) {
        return f32(
            (*moment)[get_index(cube.r1, cut, cube.b1)] -
            (*moment)[get_index(cube.r1, cut, cube.b0)] -
            (*moment)[get_index(cube.r0, cut, cube.b1)] +
            (*moment)[get_index(cube.r0, cut, cube.b0)]
        );
    } else if (dir == 2) {
        return f32(
            (*moment)[get_index(cube.r1, cube.g1, cut)] -
            (*moment)[get_index(cube.r1, cube.g0, cut)] -
            (*moment)[get_index(cube.r0, cube.g1, cut)] +
            (*moment)[get_index(cube.r0, cube.g0, cut)]
        );
    }
    return 0;
}

struct MaxVarianceResult {
    max_variance: f32,
    max_variance_idx: u32,
}

fn find_max_variance_cut(cuts_variances: ptr<workgroup, array<f32, SIDE_LENGTH>>, first: u32, last: u32) -> MaxVarianceResult {
    var max_variance = (*cuts_variances)[first];
    var max_variance_idx = first;

    for (var i = first + 1; i < last; i++) {
        if ((*cuts_variances)[i] > max_variance) {
            max_variance = (*cuts_variances)[i];
            max_variance_idx = i;
        }
    }

    return MaxVarianceResult(max_variance, max_variance_idx);
}

@compute @workgroup_size(3, 33)
fn cs(@builtin(global_invocation_id) id: vec3u) {
    let channel = id.x;
    let cut = id.y;

    let cube = cubes[current_cube_idx];
    var first = 0u;
    var last = SIDE_LENGTH;
    if (channel == 0) {
        first = cube.r0 + 1;
        last = cube.r1;
    } else if (channel == 1) {
        first = cube.g0 + 1;
        last = cube.g1;
    } else if (channel == 2) {
        first = cube.b0 + 1;
        last = cube.b1;
    }

    if (cut >= first && cut < last && channel < 3) {
        let whole = vec4f(
            volume(cube, &moments.r),
            volume(cube, &moments.g),
            volume(cube, &moments.b),
            volume(cube, &moments.w)
        );

        let bottom = vec4f(
            bottom(cube, channel, &moments.r),
            bottom(cube, channel, &moments.g),
            bottom(cube, channel, &moments.b),
            bottom(cube, channel, &moments.w)
        );

        let top = vec4f(
            top(cube, channel, cut, &moments.r),
            top(cube, channel, cut, &moments.g),
            top(cube, channel, cut, &moments.b),
            top(cube, channel, cut, &moments.w)
        );

        var half = bottom + top;

        var variance_sum = 0f;
        if (half[3] > 0) {
            variance_sum = (half[0] * half[0] + half[1] * half[1] + half[2] * half[2]) / half[3];

            half = whole - half;

            if (half[3] > 0) {
                variance_sum += (half[0] * half[0] + half[1] * half[1] + half[2] * half[2]) / half[3];
            } else {
                variance_sum = 0f;
            }
        }
        if (channel == 0) {
            cut_variances_r[cut] = variance_sum;
        } else if (channel == 1) {
            cut_variances_g[cut] = variance_sum;
        } else if (channel == 2) {
            cut_variances_b[cut] = variance_sum;
        }
    }
    
    workgroupBarrier();

    if (cut == 0) {
        var result = MaxVarianceResult(0f, 0u);

        if (channel == 0) {
            result = find_max_variance_cut(&cut_variances_r, first, last);
        } else if (channel == 1) {
            result = find_max_variance_cut(&cut_variances_g, first, last);
        } else {
            result = find_max_variance_cut(&cut_variances_b, first, last);
        }

        best_cut[channel] = result.max_variance_idx;

        if (channel == 0) {
            cut_variances_r[0] = result.max_variance;
        } else if (channel == 1) {
            cut_variances_g[0] = result.max_variance;
        } else {
            cut_variances_b[0] = result.max_variance;
        }
    }

    workgroupBarrier();
    
    if (cut == 0 && channel == 0) {
        let best_variance_r = cut_variances_r[0];
        let best_variance_g = cut_variances_g[0];
        let best_variance_b = cut_variances_b[0];
    
        var direction = 0u;
        if(best_variance_r > best_variance_g && best_variance_r > best_variance_b) {
            direction = 0;
        } else if (best_variance_g > best_variance_r && best_variance_g > best_variance_b) {
            direction = 1;
        } else {
            direction = 2;
        }

        let chosen_cut = best_cut[direction];
        var new_cube = cubes[total_cubes_num];
        new_cube.r1 = cubes[current_cube_idx].r1;
        new_cube.g1 = cubes[current_cube_idx].g1;
        new_cube.b1 = cubes[current_cube_idx].b1;
        if (direction == 0) {
            cubes[current_cube_idx].r1 = chosen_cut;
            new_cube.r0 = chosen_cut;
            new_cube.g0 = cube.g0;
            new_cube.b0 = cube.b0;
        } else if (direction == 1) {
            cubes[current_cube_idx].g1 = chosen_cut;
            new_cube.r0 = cube.r0;
            new_cube.g0 = chosen_cut;
            new_cube.b0 = cube.b0;
        } else {
            cubes[current_cube_idx].b1 = chosen_cut;
            new_cube.r0 = cube.r0;
            new_cube.g0 = cube.g0;
            new_cube.b0 = chosen_cut;
        }

        cubes[total_cubes_num] = new_cube;

        variances[current_cube_idx] = variance(cubes[current_cube_idx]);
        variances[total_cubes_num] = variance(new_cube);

        var next_idx = 0u;
        var next_variance = variances[0];
        for (var i = 0u; i <= total_cubes_num; i++) {
            if (variances[i] > next_variance) {
                next_variance = variances[i];
                next_idx = i;
            }
        }

        current_cube_idx = next_idx;
    }
}
