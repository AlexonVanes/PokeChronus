varying vec2 v_TexCoord;
uniform vec4 u_Color;
uniform sampler2D u_Tex0;
uniform vec2 u_Resolution;

float lumaOf(vec3 color)
{
    return dot(color, vec3(0.299, 0.587, 0.114));
}

vec3 saturateColor(vec3 color, float amount)
{
    float luma = lumaOf(color);
    return mix(vec3(luma), color, amount);
}

vec3 tex(vec2 uv, vec2 offset)
{
    return texture2D(u_Tex0, uv + offset).rgb;
}

vec3 softBloom(vec2 uv, vec2 px, vec3 color)
{
    vec3 bloom = vec3(0.0);
    bloom += tex(uv, vec2(-2.0,  0.0) * px);
    bloom += tex(uv, vec2( 2.0,  0.0) * px);
    bloom += tex(uv, vec2( 0.0, -2.0) * px);
    bloom += tex(uv, vec2( 0.0,  2.0) * px);
    bloom += tex(uv, vec2(-1.5, -1.5) * px);
    bloom += tex(uv, vec2( 1.5,  1.5) * px);
    bloom *= 0.1666667;

    float highlight = smoothstep(0.48, 1.0, max(max(bloom.r, bloom.g), bloom.b));
    return color + bloom * highlight * 0.085;
}

vec3 weightByLuma(vec3 base, vec3 sampleColor, float strength)
{
    float diff = abs(lumaOf(base) - lumaOf(sampleColor));
    float weight = exp(-diff * strength);
    return sampleColor * weight;
}

float lumaWeight(vec3 base, vec3 sampleColor, float strength)
{
    float diff = abs(lumaOf(base) - lumaOf(sampleColor));
    return exp(-diff * strength);
}

void main()
{
    vec2 resolution = max(u_Resolution, vec2(1.0));
    vec2 px = 1.0 / resolution;
    vec2 uv = v_TexCoord;

    vec4 baseSample = texture2D(u_Tex0, uv);
    vec3 c = baseSample.rgb;

    vec3 n  = tex(uv, vec2( 0.0, -1.0) * px);
    vec3 s  = tex(uv, vec2( 0.0,  1.0) * px);
    vec3 e  = tex(uv, vec2( 1.0,  0.0) * px);
    vec3 w  = tex(uv, vec2(-1.0,  0.0) * px);
    vec3 ne = tex(uv, vec2( 1.0, -1.0) * px);
    vec3 nw = tex(uv, vec2(-1.0, -1.0) * px);
    vec3 se = tex(uv, vec2( 1.0,  1.0) * px);
    vec3 sw = tex(uv, vec2(-1.0,  1.0) * px);

    vec3 h0 = tex(uv, vec2(-0.45,  0.0) * px);
    vec3 h1 = tex(uv, vec2( 0.45,  0.0) * px);
    vec3 v0 = tex(uv, vec2( 0.0, -0.45) * px);
    vec3 v1 = tex(uv, vec2( 0.0,  0.45) * px);
    vec3 d0 = tex(uv, vec2(-0.42, -0.42) * px);
    vec3 d1 = tex(uv, vec2( 0.42,  0.42) * px);
    vec3 d2 = tex(uv, vec2( 0.42, -0.42) * px);
    vec3 d3 = tex(uv, vec2(-0.42,  0.42) * px);

    float cL = lumaOf(c);
    float nL = lumaOf(n);
    float sL = lumaOf(s);
    float eL = lumaOf(e);
    float wL = lumaOf(w);
    float neL = lumaOf(ne);
    float nwL = lumaOf(nw);
    float seL = lumaOf(se);
    float swL = lumaOf(sw);

    float sobelX = (neL + 2.0 * eL + seL) - (nwL + 2.0 * wL + swL);
    float sobelY = (swL + 2.0 * sL + seL) - (nwL + 2.0 * nL + neL);
    float edge = clamp(sqrt(sobelX * sobelX + sobelY * sobelY) * 1.9, 0.0, 1.0);
    float edgeMask = smoothstep(0.035, 0.30, edge);

    vec3 bilateral = c * 0.55;
    float total = 0.55;
    float wgt;

    wgt = lumaWeight(c, n, 7.5) * 0.09;  bilateral += n * wgt;  total += wgt;
    wgt = lumaWeight(c, s, 7.5) * 0.09;  bilateral += s * wgt;  total += wgt;
    wgt = lumaWeight(c, e, 7.5) * 0.09;  bilateral += e * wgt;  total += wgt;
    wgt = lumaWeight(c, w, 7.5) * 0.09;  bilateral += w * wgt;  total += wgt;
    wgt = lumaWeight(c, ne, 7.5) * 0.045; bilateral += ne * wgt; total += wgt;
    wgt = lumaWeight(c, nw, 7.5) * 0.045; bilateral += nw * wgt; total += wgt;
    wgt = lumaWeight(c, se, 7.5) * 0.045; bilateral += se * wgt; total += wgt;
    wgt = lumaWeight(c, sw, 7.5) * 0.045; bilateral += sw * wgt; total += wgt;
    bilateral /= total;

    vec3 subPixel =
        c  * 0.30 +
        h0 * 0.10 + h1 * 0.10 +
        v0 * 0.10 + v1 * 0.10 +
        d0 * 0.075 + d1 * 0.075 +
        d2 * 0.075 + d3 * 0.075;

    vec3 horizontal = (e + w + h0 + h1) * 0.25;
    vec3 vertical = (n + s + v0 + v1) * 0.25;
    vec3 diagA = (ne + sw + d2 + d3) * 0.25;
    vec3 diagB = (nw + se + d0 + d1) * 0.25;

    float hErr = abs(eL - wL) + abs(lumaOf(h0) - lumaOf(h1));
    float vErr = abs(nL - sL) + abs(lumaOf(v0) - lumaOf(v1));
    float daErr = abs(neL - swL) + abs(lumaOf(d2) - lumaOf(d3));
    float dbErr = abs(nwL - seL) + abs(lumaOf(d0) - lumaOf(d1));

    vec3 directional = horizontal;
    float bestErr = hErr;
    if(vErr < bestErr) {
        directional = vertical;
        bestErr = vErr;
    }
    if(daErr < bestErr) {
        directional = diagA;
        bestErr = daErr;
    }
    if(dbErr < bestErr) {
        directional = diagB;
    }

    vec3 rounded = mix(subPixel, bilateral, 0.52);
    rounded = mix(rounded, directional, edgeMask * 0.72);

    vec3 wideBlur =
        rounded * 0.52 +
        (n + s + e + w) * 0.085 +
        (ne + nw + se + sw) * 0.035;

    vec3 color = mix(rounded, wideBlur, 0.30 + edgeMask * 0.18);

    vec3 detail = rounded - wideBlur;
    color += detail * (0.055 * (1.0 - edgeMask));

    color = saturateColor(color, 1.42);
    color = (color - 0.5) * 1.11 + 0.5;
    color *= 1.065;
    color = softBloom(uv, px, color);
    color = pow(max(color, vec3(0.0)), vec3(0.90));

    gl_FragColor = vec4(clamp(color, 0.0, 1.0), baseSample.a) * u_Color;
    if(gl_FragColor.a < 0.01)
        discard;
}
