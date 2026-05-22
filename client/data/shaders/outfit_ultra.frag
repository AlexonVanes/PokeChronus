uniform mat4 u_Color;
varying vec2 v_TexCoord;
varying vec2 v_TexCoord2;
varying vec2 v_TexCoord3;
varying vec2 v_Position;
uniform sampler2D u_Tex0;
uniform float u_Time;
uniform vec2 u_Resolution;

const vec3 COL_WHITE  = vec3(1.0, 1.0, 1.0);
const vec3 COL_CYAN   = vec3(0.5, 0.9, 1.0);
const vec3 COL_BLUE   = vec3(0.1, 0.3, 1.0);
const vec3 COL_INDIGO = vec3(0.05, 0.05, 0.55);
const vec3 COL_DEEP   = vec3(0.01, 0.01, 0.3);

float hash(float n) {
    return fract(sin(n) * 43758.5453);
}

float hash2(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}

float valueNoise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    f = f * f * (3.0 - 2.0 * f);
    float a = hash2(i);
    float b = hash2(i + vec2(1.0, 0.0));
    float c = hash2(i + vec2(0.0, 1.0));
    float d = hash2(i + vec2(1.0, 1.0));
    return mix(mix(a, b, f.x), mix(c, d, f.x), f.y);
}

float fbm(vec2 p) {
    float v = 0.0;
    float a = 0.5;
    for(int i = 0; i < 5; i++) {
        v += a * valueNoise(p);
        p *= 2.15;
        a *= 0.5;
    }
    return v;
}

float solidAlpha(vec2 uv) {
    return smoothstep(0.05, 0.4, texture2D(u_Tex0, uv).a);
}

// Blur com mais amostras e maior alcance
float glowBlur(vec2 uv, vec2 texel, float radius) {
    vec2 t = texel * radius;

    float w0 = 0.227027;
    float w1 = 0.1945946;
    float w2 = 0.1216216;
    float w3 = 0.054054;
    float w4 = 0.016216;

    float sum = 0.0;
    sum += solidAlpha(uv) * w0;

    sum += solidAlpha(uv + vec2(1.0, 0.0) * t) * w1;
    sum += solidAlpha(uv - vec2(1.0, 0.0) * t) * w1;
    sum += solidAlpha(uv + vec2(0.0, 1.0) * t) * w1;
    sum += solidAlpha(uv - vec2(0.0, 1.0) * t) * w1;

    sum += solidAlpha(uv + vec2(2.0, 0.0) * t) * w2;
    sum += solidAlpha(uv - vec2(2.0, 0.0) * t) * w2;
    sum += solidAlpha(uv + vec2(0.0, 2.0) * t) * w2;
    sum += solidAlpha(uv - vec2(0.0, 2.0) * t) * w2;

    sum += solidAlpha(uv + vec2(3.0, 0.0) * t) * w3;
    sum += solidAlpha(uv - vec2(3.0, 0.0) * t) * w3;
    sum += solidAlpha(uv + vec2(0.0, 3.0) * t) * w3;
    sum += solidAlpha(uv - vec2(0.0, 3.0) * t) * w3;

    sum += solidAlpha(uv + vec2(4.0, 0.0) * t) * w4;
    sum += solidAlpha(uv - vec2(4.0, 0.0) * t) * w4;
    sum += solidAlpha(uv + vec2(0.0, 4.0) * t) * w4;
    sum += solidAlpha(uv - vec2(0.0, 4.0) * t) * w4;

    sum += solidAlpha(uv + vec2(1.0, 1.0) * t * 0.707) * w1 * 0.5;
    sum += solidAlpha(uv - vec2(1.0, 1.0) * t * 0.707) * w1 * 0.5;
    sum += solidAlpha(uv + vec2(1.0,-1.0) * t * 0.707) * w1 * 0.5;
    sum += solidAlpha(uv - vec2(1.0,-1.0) * t * 0.707) * w1 * 0.5;

    return sum;
}

float particles(vec2 pixPos, float time, float glowMask, float seed) {
    float result = 0.0;
    if(glowMask < 0.01) return 0.0;

    for(float i = 0.0; i < 50.0; i++) {
        float s1 = hash(i * 73.15 + seed);
        float s2 = hash(i * 127.3 + 45.0 + seed);
        float s3 = hash(i * 31.77 + 92.0 + seed);
        float s4 = hash(i * 251.1 + 17.0 + seed);

        float life = 0.8 + s1 * 1.8;
        float phase = mod(time * 0.75 + s1 * life, life);
        float age = phase / life;

        float angle = s2 * 6.28318;
        float rad = 0.01 + s3 * 0.025;
        vec2 pos = vec2(cos(angle), sin(angle)) * rad;

        pos.x += sin(time * 2.0 + s1 * 6.28 + i) * 0.01 * (age + 0.2);
        pos.y -= age * 0.05;

        float dist = length(pixPos - pos);
        float sz = (0.001 + s4 * 0.0025) * (1.0 - age * 0.3);
        float a = smoothstep(0.0, 0.05, age) * smoothstep(1.0, 0.35, age);

        float core = smoothstep(sz, sz * 0.01, dist);
        float glow = smoothstep(sz * 4.5, sz * 0.05, dist) * 0.4;
        float p = (core + glow) * a;

        p *= 0.5 + 0.5 * sin(time * 7.0 + s1 * 30.0);
        p *= smoothstep(0.0, 0.1, glowMask);

        result += p;
    }
    return clamp(result, 0.0, 1.5);
}

void main()
{
    gl_FragColor = texture2D(u_Tex0, v_TexCoord);
    vec4 texcolor = texture2D(u_Tex0, v_TexCoord2);

    if(texcolor.r > 0.9) {
        gl_FragColor *= texcolor.g > 0.9 ? u_Color[0] : u_Color[1];
    } else if(texcolor.g > 0.9) {
        gl_FragColor *= u_Color[2];
    } else if(texcolor.b > 0.9) {
        gl_FragColor *= u_Color[3];
    }

    vec2 safeRes = max(u_Resolution, vec2(1.0));
    vec2 texel = vec2(2.0) / safeRes;
    float time = u_Time;
    float breathe = 0.82 + 0.18 * sin(time * 2.2);

    // Calcular glow médio para partículas (ambos caminhos precisam)
    float g2 = glowBlur(v_TexCoord3, texel, 10.0);
    vec2 pixPos = v_Position / max(safeRes, vec2(1.0));
    float frontPtcl = particles(pixPos, time * 1.1 + 30.0, g2, 500.0);

    if(gl_FragColor.a > 0.15) {
        // Sprite intacto + rim + partículas por cima
        float edgeness = 0.0;
        for(float a = 0.0; a < 6.28; a += 0.785) {
            vec2 dir = vec2(cos(a), sin(a));
            float s1 = solidAlpha(v_TexCoord3 + dir * texel * 1.0);
            float s2 = solidAlpha(v_TexCoord3 + dir * texel * 2.0);
            float s3 = solidAlpha(v_TexCoord3 + dir * texel * 3.0);
            edgeness += (1.0 - s1) * 0.5;
            edgeness += (1.0 - s2) * 0.3;
            edgeness += (1.0 - s3) * 0.2;
        }
        edgeness = clamp(edgeness / 8.0, 0.0, 1.0);

        float rimPulse = 0.7 + 0.3 * sin(time * 2.5);
        vec3 rimColor = mix(COL_BLUE, COL_CYAN, edgeness * 0.6);
        gl_FragColor.rgb += rimColor * edgeness * rimPulse * 0.3 * breathe;

        if(frontPtcl > 0.01) {
            vec3 pCol = mix(COL_CYAN, COL_WHITE, frontPtcl * 0.6);
            gl_FragColor.rgb += pCol * frontPtcl * breathe * 0.5;
        }

        gl_FragColor.rgb = min(gl_FragColor.rgb, gl_FragColor.rgb + vec3(0.3));
        return;
    }

    // ==========================================
    // AURA FORA DO SPRITE
    // ==========================================

    // 4 camadas com raios progressivos
    float g0 = glowBlur(v_TexCoord3, texel, 2.0);   // colado
    float g1 = glowBlur(v_TexCoord3, texel, 5.0);   // inner
    // g2 já calculado acima (10.0)                    // mid
    float g3 = glowBlur(v_TexCoord3, texel, 18.0);   // outer

    // Glow máximo - indica proximidade ao sprite
    float maxGlow = max(max(g0, g1), max(g2, g3));

    if(maxGlow < 0.02) {
        discard;
        return;
    }

    float fast = 0.9 + 0.1 * sin(time * 6.5);

    vec2 pxN = v_Position / max(safeRes.x, safeRes.y);
    float upBias = smoothstep(0.2, -0.4, pxN.y);

    float n1 = fbm(vec2(pxN.x * 12.0, pxN.y * 8.0 - time * 1.4));
    float n2 = fbm(vec2(pxN.x * 8.0 + 50.0, pxN.y * 10.0 - time * 1.8));

    // Edge glow - colado à silhueta, branco-cyan brilhante
    float edge = smoothstep(0.05, 1.2, g0) * breathe * 1.6;

    // Inner glow - cyan
    float inner = smoothstep(0.04, 0.8, g1);
    inner *= breathe * (0.85 + n1 * 0.15);

    // Mid - azul royal
    float mid = smoothstep(0.03, 0.5, g2);
    mid *= (0.55 + n1 * 0.3 + n2 * 0.15);
    mid *= (0.6 + upBias * 0.4) * breathe * fast;
    float midR = max(0.0, mid - inner * 0.45);

    // Outer - índigo, fade longo
    float outer = smoothstep(0.01, 0.3, g3);
    outer *= (0.3 + n2 * 0.5 + n1 * 0.2);
    outer *= (upBias * 0.7 + 0.3) * breathe;
    float outerR = max(0.0, outer - mid * 0.3);

    // Flame tips
    float tips = 0.0;
    for(float i = 0.0; i < 5.0; i++) {
        float off = (hash(i * 47.3) - 0.5) * 0.15;
        float spd = 0.8 + hash(i * 13.7) * 0.8;
        float n = valueNoise(vec2(
            (pxN.x + off) * 14.0,
            pxN.y * 6.0 - time * spd + i * 10.0
        ));
        float tipX = pxN.x - off;
        float tip = n * exp(-tipX * tipX * 250.0);
        tip *= smoothstep(0.1, -0.3, pxN.y);
        tip *= smoothstep(0.0, 0.06, g3);
        tips += tip;
    }
    tips = clamp(tips * 0.4, 0.0, 0.5);

    // Partículas
    float backPtcl = particles(pixPos, time, g2, 0.0);

    // ==========================================
    // COMPOSIÇÃO - ordem de trás pra frente
    // ==========================================
    vec3 col = vec3(0.0);
    float alpha = 0.0;

    // Outer (fundo, fade longo)
    col += mix(COL_DEEP, COL_INDIGO, outerR) * outerR * 0.8;
    alpha += outerR * 0.5;

    // Tips
    col += mix(COL_INDIGO, COL_BLUE, tips) * tips * 1.1;
    alpha += tips * 0.55;

    // Mid
    col += mix(COL_BLUE, COL_CYAN, midR * 0.5) * midR;
    alpha += midR * 0.7;

    // Inner
    col += mix(COL_CYAN, COL_WHITE, inner * 0.6) * inner * 1.4;
    alpha += inner * 0.85;

    // Edge (mais brilhante, colado)
    vec3 edgeCol = mix(COL_CYAN, COL_WHITE, edge * 0.4);
    col += edgeCol * edge;
    alpha += edge * 0.9;

    // Partículas trás
    vec3 bpCol = mix(COL_CYAN, COL_WHITE, backPtcl * 0.6);
    col += bpCol * backPtcl * breathe;
    alpha += backPtcl * 0.7;

    // Partículas frente
    vec3 fpCol = mix(COL_CYAN, COL_WHITE, frontPtcl * 0.6);
    col += fpCol * frontPtcl * breathe;
    alpha += frontPtcl * 0.7;

    // Bloom
    float bloom = smoothstep(0.0, 0.08, g3) * 0.1 * breathe;
    col += COL_BLUE * bloom;
    alpha += bloom * 0.12;

    alpha = clamp(alpha, 0.0, 1.0);

    // ==========================================
    // FADE SUAVE - chave para eliminar recortes
    // ==========================================
    // Fade baseado no glow mais forte disponível
    // Quanto menor o glow, mais transparente
    float fadeMask = smoothstep(0.02, 0.25, maxGlow);

    // Fade extra: usar glow3 (mais largo) como guia de suavidade
    float softFade = smoothstep(0.01, 0.2, g3);

    // Combinar os dois fades
    float finalFade = fadeMask * softFade;

    alpha *= finalFade;
    col *= finalFade;

    if(alpha < 0.01) {
        discard;
        return;
    }

    gl_FragColor = vec4(col, alpha);
}