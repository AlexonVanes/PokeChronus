// infinito_fragment.glsl — cores misturadas + opacidade controlável (0.0..1.0)
// GLES2 compatível

#ifdef GL_ES
precision mediump float;
#endif

uniform sampler2D u_Tex0;
uniform float u_Time;

// Intensidades
uniform float u_Energy;      // 0..1
uniform float u_Bloom;       // 0..2
uniform float u_Flicker;     // 0..1
uniform float u_Pulse;       // 0..1

// Velocidades
uniform float u_PulseSpeed;       // ~Hz (ex.: 3.0)
uniform float u_ColorShiftSpeed;  // ~Hz (ex.: 5.0)

// Aura geométrica
uniform float u_AuraRadius;  // px
uniform float u_AuraWidth;   // px
uniform float u_AuraSpin;    // rad/s

// Máscara
uniform bool  u_HasMask;
uniform float u_MaskTight;   // 0..1

// Escala
uniform float u_PixelScale;  // 1.0 se v_PosRel está em px

// OPACIDADE do efeito (NOVO)
uniform float u_OverlayOpacity;   // 0..1  (use 0.5 pra atender seu pedido)

// Mistura extra (NOVO): 0 = pouco blend entre cores, 1 = muito blend
uniform float u_ColorMix;         // 0..1 (sugestão 0.6)

varying vec2 v_TexCoord;
varying vec2 v_TexCoord2;
varying vec2 v_PosRel;

// ---------- helpers ----------
float hash21(vec2 p){
    p = fract(p*vec2(123.34,456.21));
    p += dot(p, p+45.32);
    return fract(p.x*p.y);
}

float smoothNoise(vec2 p){
    // ruído suave 0..1
    vec2 i = floor(p), f = fract(p);
    float a = hash21(i);
    float b = hash21(i + vec2(1.0, 0.0));
    float c = hash21(i + vec2(0.0, 1.0));
    float d = hash21(i + vec2(1.0, 1.0));
    vec2 u = f*f*(3.0-2.0*f);
    return mix(mix(a,b,u.x), mix(c,d,u.x), u.y);
}

// ---------- paleta (quatro cores) ----------
const vec3 COL_GREEN   = vec3(0.00, 1.00, 0.50);
const vec3 COL_YELLOW  = vec3(1.00, 1.00, 0.30);
const vec3 COL_MAGENTA = vec3(1.00, 0.30, 1.00);
const vec3 COL_BLUE    = vec3(0.30, 0.80, 1.00);

void main() {
    vec4 base = texture2D(u_Tex0, v_TexCoord);
    if(base.a <= 0.01) discard;

    // --- MÁSCARA ---
    float maskVal;
    if(u_HasMask){
        vec4 m = texture2D(u_Tex0, v_TexCoord2);
        maskVal = max(max(m.r, m.g), m.b);
    } else {
        maskVal = base.a;
    }
    maskVal = smoothstep(u_MaskTight, 1.0, maskVal);

    // --- ESPAÇO ---
    vec2  pos = v_PosRel * u_PixelScale;
    float r   = length(pos);

    // ===== PULSO RÁPIDO =====
    float pulseHz = max(0.6, u_PulseSpeed);
    float beat = 0.5 + 0.5 * sin(6.2831853 * pulseHz * (u_Time) * (1.0 + 0.6*u_Energy));
    beat = mix(beat, 1.0, u_Energy) + u_Pulse * 0.35;

    // Anel da aura
    float ringCenter = u_AuraRadius + sin(u_Time*0.7)*2.0*u_Energy;
    float ring = 1.0 - smoothstep(ringCenter - u_AuraWidth, ringCenter, r)
                 +    smoothstep(ringCenter, ringCenter + u_AuraWidth, r);
    ring *= maskVal;

    // Núcleo radial
    float core = smoothstep(0.0, 24.0, 24.0 - r) * maskVal;

    // Cintilâncias
    float grain = hash21(pos*0.05 + u_Time*vec2(0.7,1.3));
    float spark = step(0.92, grain) * u_Flicker * maskVal;

    // Trilhas
    float trails = (0.5 + 0.5*sin(u_Time*6.0 + r*0.12)) * core * 0.9;

    // ===== MISTURA DE CORES (sempre presentes e variando) =====
    float shiftHz = max(0.1, u_ColorShiftSpeed);
    float t = 6.2831853 * shiftHz * u_Time * 4.5; // 3.5x mais rápido!

    // Pesos baseados no tempo (defasados) + variação espacial por ruído (MUITO mais rápido)
    float n  = smoothNoise(pos*0.07 + u_Time*1.8);             // 6x mais rápido (era 0.3)
    float n2 = smoothNoise(pos*0.11 + vec2(u_Time*1.5, 0.0));  // 7.5x mais rápido (era 0.2)

    // bias garante todas as cores presentes; oscilações trazem vida (amplitudes maiores)
    float wG = 0.25 + 0.30*sin(t + 0.00) + 0.25*(n - 0.5);
    float wY = 0.25 + 0.30*sin(t + 1.57) + 0.25*(n2 - 0.5);
    float wM = 0.25 + 0.30*sin(t + 3.14) + 0.25*(n - n2);
    float wB = 0.25 + 0.30*sin(t + 4.71) + 0.25*(n2 - n);

    // clamp e normalização leve para manter energia estável
    wG = max(0.0, wG); wY = max(0.0, wY); wM = max(0.0, wM); wB = max(0.0, wB);
    float sumW = max(1e-4, (wG + wY + wM + wB));
    wG /= sumW; wY /= sumW; wM /= sumW; wB /= sumW;

    // Mistura extra controla o quanto as cores "invadem" umas às outras
    float mixFactor = clamp(u_ColorMix, 0.0, 1.0);
    // pesos suavizados (mais blend) vs. originais (menos blend)
    float s = 0.5 + 0.5*sin(t*0.5);
    wG = mix(wG, (wG + s*(wY+wM+wB)/3.0), mixFactor);
    wY = mix(wY, (wY + s*(wG+wM+wB)/3.0), mixFactor);
    wM = mix(wM, (wM + s*(wG+wY+wB)/3.0), mixFactor);
    wB = mix(wB, (wB + s*(wG+wY+wM)/3.0), mixFactor);

    // Cores finais por componente
    vec3 mixCol = COL_GREEN*wG + COL_YELLOW*wY + COL_MAGENTA*wM + COL_BLUE*wB;

    // Núcleo e anel usam a mesma mistura (com ganho diferente)
    vec3 coreCol = mixCol * (0.9 + 0.4*beat);
    vec3 ringCol = mixCol * (0.8 + 0.3*beat);

    // Sparks/trails também usam a mistura
    vec3 sparkCol  = mixCol;
    vec3 trailsCol = mixCol;

    // Emissão (aditiva interna do shader)
    vec3 emissive = vec3(0.0);
    emissive += coreCol  * core  * (0.6 + 1.6*u_Energy);
    emissive += ringCol  * ring  * (0.7 + 1.5*u_Energy);
    emissive += sparkCol * spark * (0.8 + 1.8*u_Energy);
    emissive += trailsCol* trails* 0.7;

    float glow = (0.65 + 1.35*u_Energy) * (1.0 + u_Bloom);

    // ===== OPACIDADE DO OVERLAY (0.5 sugerido) =====
    // “blend” entre a cor base e a base+emissão, controlado por u_OverlayOpacity.
    vec3 blended = base.rgb + emissive * glow;
    float overlay = clamp(u_OverlayOpacity, 0.3, 0.5) * maskVal;

    vec3 color = mix(base.rgb, blended, overlay);

    gl_FragColor = vec4(color, base.a);
}
