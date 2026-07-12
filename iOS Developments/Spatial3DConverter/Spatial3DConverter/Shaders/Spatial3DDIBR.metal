#include <metal_stdlib>
using namespace metal;

struct Spatial3DDIBRUniforms {
    float strength;
    float maxDisparity;
    float direction;
    float2 imageSize;
};

kernel void spatial3d_dibr_warp(
    texture2d<float, access::read> source [[texture(0)]],
    texture2d<float, access::read> depth [[texture(1)]],
    texture2d<float, access::write> output [[texture(2)]],
    constant Spatial3DDIBRUniforms &uniforms [[buffer(0)]],
    uint2 gid [[thread_position_in_grid]]
) {
    if (gid.x >= output.get_width() || gid.y >= output.get_height()) {
        return;
    }

    float d = depth.read(gid).r;
    float shift = (1.0 - d) * uniforms.maxDisparity * uniforms.strength * uniforms.direction;
    int2 sampleCoord = int2(gid) + int2(shift, 0);
    sampleCoord.x = clamp(sampleCoord.x, 0, int(source.get_width()) - 1);
    sampleCoord.y = clamp(sampleCoord.y, 0, int(source.get_height()) - 1);
    output.write(source.read(uint2(sampleCoord)), gid);
}
