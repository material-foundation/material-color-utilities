struct Counts {
    centroids: u32,
    colors: u32
};

@group(0) @binding(0) var<storage> histogram: array<f32>;
@group(0) @binding(1) var<uniform> counts: Counts;
@group(0) @binding(2) var<storage, read_write> centroids: array<f32>;
@group(0) @binding(3) var<storage, read_write> clusters: array<u32>;

fn dist(a: vec3f, b: vec3f) -> f32 {
    return pow((a.x - b.x), 2) + pow((a.y - b.y), 2) + pow((a.z - b.z), 2);
}

@compute @workgroup_size(256)
fn cs(@builtin(global_invocation_id) id: vec3u) {
    if (id.x >= counts.colors) {
        return;
    }

    let pos = vec3f(histogram[id.x * 4], histogram[id.x * 4 + 1], histogram[id.x * 4 + 2]);
    let count = histogram[id.x * 4 + 3];

    var min_dist = -1.;
    var closest = 0u;
    
    for (var i = 0u; i < counts.centroids; i++) {
        let centroid = vec3f(centroids[3*i], centroids[3*i + 1], centroids[3*i + 2]);
        if (centroid.x == -1.0 || centroid.y == -1.0 || centroid.z == -1.0) {
            continue;
        }
        let d = dist(pos, centroid);
        if (min_dist == -1 || d < min_dist){
            closest = i;
            min_dist = d;
        }
    }

    clusters[id.x] = closest;
}
