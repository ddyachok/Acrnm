//
//  WaterDropWaveShader.metal
//  Acrnm
//
//  Created by Danylo Dyachok on 06.07.2024.
//

#include <metal_stdlib>
using namespace metal;

struct VertexIn {
    float4 position [[position]];
    float2 texCoord;
};

vertex VertexIn vertex_main(uint vertexID [[vertex_id]]) {
    const float4 positions[4] = {
        float4(-1.0, -1.0, 0.0, 1.0),
        float4( 1.0, -1.0, 0.0, 1.0),
        float4(-1.0,  1.0, 0.0, 1.0),
        float4( 1.0,  1.0, 0.0, 1.0)
    };
    
    const float2 texCoords[4] = {
        float2(0.0, 0.0),
        float2(1.0, 0.0),
        float2(0.0, 1.0),
        float2(1.0, 1.0)
    };
    
    VertexIn out;
    out.position = positions[vertexID];
    out.texCoord = texCoords[vertexID];
    
    return out;
}

fragment float4 fragment_main(VertexIn in [[stage_in]],
                              texture2d<float> texture [[texture(0)]],
                              constant float &time [[buffer(0)]]) {
    constexpr sampler textureSampler (mag_filter::linear, min_filter::linear);
    float2 uv = in.texCoord;
    float wave = sin(10.0 * length(uv - 0.5) - time * 2.0) * 0.02;
    uv += wave;
    
    return texture.sample(textureSampler, uv);
}
