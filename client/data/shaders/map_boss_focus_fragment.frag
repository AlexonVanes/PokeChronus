// map_boss_focus_fragment.frag
// Efeito de foco em boss durante cast de skill.
//
// Funcionamento:
//   - Circulo nitido centrado no boss (u_FocusPos em UV do framebuffer)
//   - Fora do circulo: blur gaussiano 7x7 + leve escurecimento
//   - Borda suave com smoothstep (15% do raio)
//   - Fade in/out controlado por u_FadeT (0=sem efeito, 1=efeito pleno)
//
// Pipeline de coordenadas (Lua -> shader):
//   O framebuffer do mapa tem drawDimension tiles * spriteSize px por tile.
//   Em light mode (ts=32): tipicamente 27*32=864px, sem downscale.
//   Em HD mode (!lightMode, ts=64): drawDim*64 pode exceder 2048 -> downscale para 2048x2048.
//   O v_TexCoord e' UV 0..1 sobre o framebuffer real (apos downscale se houver).
//   offsetScreen=2 em HD mode corrige o fator de escala 2x interno do engine.
//   u_FocusPos e u_FocusRadius sao calculados em shaders.lua/_calcUV e _calcTexSize.
//
// Uniforms automaticos do engine:
//   u_Tex0       - textura do framebuffer do mapa (upsideDown=true: Y=0 no topo)
//   u_Resolution - viewport em pixels (NAO usar para calculos de UV do mapa)
//
// Uniforms setados por Lua (BossFocus em game_shaders/shaders.lua):
//   u_FocusPos    vec2  - UV do boss no framebuffer (0..1, Y=0 no topo)
//   u_FadeT       float - fade in/out: 0=invisivel, 1=efeito completo
//   u_FocusRadius float - raio do circulo em UV do framebuffer
//                         = radius_tiles * ts / (texH * offsetScreen)
//   u_TexSize     vec2  - tamanho real do framebuffer (texW, texH) em pixels
//                         usado para blur step e aspect ratio corretos

uniform sampler2D u_Tex0;
uniform vec2      u_Resolution;  // viewport (reservado, nao usado diretamente)

uniform vec2  u_FocusPos;    // posicao UV do centro do foco
uniform float u_FadeT;       // fade in/out (0..1)
uniform float u_FocusRadius; // raio do circulo de foco em UV
uniform vec2  u_TexSize;     // srcRect do framebuffer: vec2(visW*ts, visH*ts)

// ── Gaussian 7x7 identico ao map_gaussian ──────────────────────────────────
// sigma=2.0, BLUR_STEP=2.5 (levemente mais forte fora do foco)
const float BLUR_STEP = 2.5;
const float w0 = 0.2161;
const float w1 = 0.1907;
const float w2 = 0.1311;
const float w3 = 0.0701;

vec4 sampleRow(vec2 uv, float tx) {
    return
        texture2D(u_Tex0, clamp(uv + vec2(-3.0*tx, 0.0), vec2(0.0), vec2(1.0))) * w3 +
        texture2D(u_Tex0, clamp(uv + vec2(-2.0*tx, 0.0), vec2(0.0), vec2(1.0))) * w2 +
        texture2D(u_Tex0, clamp(uv + vec2(-1.0*tx, 0.0), vec2(0.0), vec2(1.0))) * w1 +
        texture2D(u_Tex0, clamp(uv,                       vec2(0.0), vec2(1.0))) * w0 +
        texture2D(u_Tex0, clamp(uv + vec2(+1.0*tx, 0.0), vec2(0.0), vec2(1.0))) * w1 +
        texture2D(u_Tex0, clamp(uv + vec2(+2.0*tx, 0.0), vec2(0.0), vec2(1.0))) * w2 +
        texture2D(u_Tex0, clamp(uv + vec2(+3.0*tx, 0.0), vec2(0.0), vec2(1.0))) * w3;
}

vec4 gaussianBlur(vec2 uv) {
    // Usa u_TexSize (srcRect do framebuffer) e nao u_Resolution (tela).
    // Em HD mode o srcRect e' 2x maior que a tela; usar u_Resolution causaria
    // blur duplo pois cada passo UV cobriria o dobro de pixels do framebuffer.
    float tx = BLUR_STEP / u_TexSize.x;
    float ty = BLUR_STEP / u_TexSize.y;
    return
        sampleRow(uv + vec2(0.0, -3.0*ty), tx) * w3 +
        sampleRow(uv + vec2(0.0, -2.0*ty), tx) * w2 +
        sampleRow(uv + vec2(0.0, -1.0*ty), tx) * w1 +
        sampleRow(uv,                       tx) * w0 +
        sampleRow(uv + vec2(0.0, +1.0*ty), tx) * w1 +
        sampleRow(uv + vec2(0.0, +2.0*ty), tx) * w2 +
        sampleRow(uv + vec2(0.0, +3.0*ty), tx) * w3;
}
// ───────────────────────────────────────────────────────────────────────────

varying vec2 v_TexCoord;

void main() {
    vec4 original = texture2D(u_Tex0, v_TexCoord);

    // Sem efeito: retorna original
    if (u_FadeT <= 0.0) {
        gl_FragColor = original;
        return;
    }

    // Raio efetivo (default 0.18 se nao setado)
    float radius = (u_FocusRadius > 0.001) ? u_FocusRadius : 0.18;

    // Distancia corrigida pelo aspect ratio do grid de tiles (tiles sao quadrados
    // na tela, entao visW/visH = u_TexSize.x/u_TexSize.y e' o ratio correto).
    float aspect  = u_TexSize.x / u_TexSize.y;
    vec2  delta   = (v_TexCoord - u_FocusPos) * vec2(aspect, 1.0);
    float dist    = length(delta);

    // Mascara: 1.0 dentro do foco, 0.0 fora; borda suave de 15% do raio
    float innerEdge = radius * 0.85;
    float outerEdge = radius;
    float focusMask = 1.0 - smoothstep(innerEdge, outerEdge, dist);

    // Fora do foco: blur gaussiano + 80% escurecimento
    vec4 blurred = gaussianBlur(v_TexCoord);
    blurred.rgb *= 0.90; // 5% dark (95% de brilho restante)

    // Resultado: original dentro, blurred+escuro fora
    vec4 focused = mix(blurred, original, focusMask);

    // Fade in/out: interpola entre original e o efeito completo
    gl_FragColor = mix(original, focused, u_FadeT);
}
