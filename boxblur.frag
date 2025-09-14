#version 310 es
precision highp float;

layout(location = 0) in vec2 qt_TexCoord0;
layout(location = 0) out vec4 fragColor;

layout(std140, binding = 0) uniform buf {
    mat4 qt_Matrix;
    float qt_Opacity;
    vec2 pixelStep;
    int radius;
    float cornerRadius;
};

layout(binding = 1) uniform sampler2D src;

float roundedBoxSDF(vec2 fragCoordPx, vec2 sizePx, float radiusPx) {
    vec2 halfSize = sizePx * 0.5 - vec2(radiusPx);
    vec2 centered = fragCoordPx - sizePx * 0.5;
    vec2 q = abs(centered) - halfSize;
    return length(max(q, vec2(0.0))) + min(max(q.x, q.y), 0.0) - radiusPx;
}

void main(void)
{

    float width = 1.0 / pixelStep.x;
    float height = 1.0 / pixelStep.y;
    vec2 sizePx = vec2(width, height);
    vec2 fragCoordPx = qt_TexCoord0 * sizePx;

    float d = roundedBoxSDF(fragCoordPx, sizePx, cornerRadius);
    if (d > 0.0)
        discard;

    vec3 sum = vec3(0.0);
    int count = 0;

    for (int dx = -radius; dx <= radius; ++dx) {
        for (int dy = -radius; dy <= radius; ++dy) {
            vec2 offset = vec2(float(dx), float(dy)) * pixelStep;
            sum += texture(src, qt_TexCoord0 + offset).rgb;
            count += 1;
        }
    }

    vec3 avg = sum / float(count);
    fragColor = vec4(avg, 1.0) * qt_Opacity;
}

