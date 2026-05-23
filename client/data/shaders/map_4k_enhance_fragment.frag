varying vec2 v_TexCoord;
uniform vec4 u_Color;
uniform sampler2D u_Tex0;
uniform vec2 u_Resolution;

float luma(vec3 color)
{
    return dot(color, vec3(0.299, 0.587, 0.114));
}

vec3 sampleMap(vec2 uv, vec2 offset)
{
    return texture2D(u_Tex0, uv + offset).rgb;
}

void main()
{
    vec2 px = 1.0 / max(u_Resolution, vec2(1.0));
    vec2 uv = v_TexCoord;
    vec4 baseSample = texture2D(u_Tex0, uv);
    vec3 base = baseSample.rgb;

    vec3 north = sampleMap(uv, vec2( 0.0, -1.0) * px);
    vec3 south = sampleMap(uv, vec2( 0.0,  1.0) * px);
    vec3 east  = sampleMap(uv, vec2( 1.0,  0.0) * px);
    vec3 west  = sampleMap(uv, vec2(-1.0,  0.0) * px);
    vec3 nearAverage = (north + south + east + west) * 0.25;

    float localEdge = abs(luma(base) - luma(nearAverage));
    float sharpenStrength = mix(0.32, 0.68, smoothstep(0.025, 0.22, localEdge));
    vec3 detail = base - nearAverage;
    vec3 color = base + detail * sharpenStrength;

    float baseLuma = luma(base);
    float contrast = mix(1.035, 1.075, smoothstep(0.04, 0.30, localEdge));
    color = (color - vec3(0.5)) * contrast + vec3(0.5);

    float saturation = 1.06;
    color = mix(vec3(luma(color)), color, saturation);

    vec3 glowSamples =
        sampleMap(uv, vec2(-2.0,  0.0) * px) +
        sampleMap(uv, vec2( 2.0,  0.0) * px) +
        sampleMap(uv, vec2( 0.0, -2.0) * px) +
        sampleMap(uv, vec2( 0.0,  2.0) * px);
    vec3 glow = glowSamples * 0.25;
    float highlight = smoothstep(0.78, 1.0, max(max(glow.r, glow.g), glow.b));
    color += glow * highlight * 0.025;

    float whiteProtection = smoothstep(0.82, 1.0, baseLuma);
    color = mix(color, min(color, vec3(1.0)), whiteProtection * 0.35);

    gl_FragColor = vec4(clamp(color, 0.0, 1.0), baseSample.a) * u_Color;
    if (gl_FragColor.a < 0.01)
        discard;
}
