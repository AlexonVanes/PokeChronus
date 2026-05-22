// Desfoque Gaussiano 2D separavel — qualidade identica ao Photoshop
// Implementacao: convolucao 7x7 = 49 amostras, sigma=2.0
//
// Ajuste BLUR_STEP para controlar a intensidade:
//   1.0  = suave    (~Photoshop Gaussian Blur radius 2)
//   2.0  = moderado (~Photoshop Gaussian Blur radius 5)  <- default
//   3.5  = forte    (~Photoshop Gaussian Blur radius 8)
//   5.0  = muito forte (~Photoshop Gaussian Blur radius 12)

uniform sampler2D u_Tex0;
uniform vec2 u_Resolution;
varying vec2 v_TexCoord;

const float BLUR_STEP = 2.0;

// Pesos Gaussianos 1D normalizados — sigma=2.0, 7 taps, radius=3
// g(x) = exp(-x^2 / (2 * sigma^2)) = exp(-x^2 / 8.0)
// Normalizados: soma = 1.0 (garante que o brilho nao muda)
//   g(0) = 1.0000 -> w0 = 0.2161
//   g(1) = 0.8825 -> w1 = 0.1907
//   g(2) = 0.6065 -> w2 = 0.1311
//   g(3) = 0.3247 -> w3 = 0.0701
const float w0 = 0.2161;
const float w1 = 0.1907;
const float w2 = 0.1311;
const float w3 = 0.0701;

// Acumula uma fileira horizontal da convolucao para um dado deslocamento Y.
// uv: coordenada UV base (ja com offset vertical aplicado)
// tx: tamanho de um passo horizontal em coordenadas UV
vec4 sampleRow(vec2 uv, float tx) {
    return
        texture2D(u_Tex0, clamp(uv + vec2(-3.0 * tx, 0.0), vec2(0.0), vec2(1.0))) * w3 +
        texture2D(u_Tex0, clamp(uv + vec2(-2.0 * tx, 0.0), vec2(0.0), vec2(1.0))) * w2 +
        texture2D(u_Tex0, clamp(uv + vec2(-1.0 * tx, 0.0), vec2(0.0), vec2(1.0))) * w1 +
        texture2D(u_Tex0, clamp(uv                        , vec2(0.0), vec2(1.0))) * w0 +
        texture2D(u_Tex0, clamp(uv + vec2(+1.0 * tx, 0.0), vec2(0.0), vec2(1.0))) * w1 +
        texture2D(u_Tex0, clamp(uv + vec2(+2.0 * tx, 0.0), vec2(0.0), vec2(1.0))) * w2 +
        texture2D(u_Tex0, clamp(uv + vec2(+3.0 * tx, 0.0), vec2(0.0), vec2(1.0))) * w3;
}

void main() {
    // Tamanho de um passo em coordenadas UV (BLUR_STEP pixels)
    float tx = BLUR_STEP / u_Resolution.x;
    float ty = BLUR_STEP / u_Resolution.y;

    // Gaussian 2D separavel: G(x,y) = G_1D(x) * G_1D(y)
    // Aplica 7 fileiras horizontais ponderadas pelos pesos verticais correspondentes.
    // Total: 7 linhas x 7 colunas = 49 amostras de textura.
    // Os pesos 1D normalizados garantem que o produto 2D tambem some 1.0.
    vec4 color =
        sampleRow(v_TexCoord + vec2(0.0, -3.0 * ty), tx) * w3 +
        sampleRow(v_TexCoord + vec2(0.0, -2.0 * ty), tx) * w2 +
        sampleRow(v_TexCoord + vec2(0.0, -1.0 * ty), tx) * w1 +
        sampleRow(v_TexCoord                        , tx) * w0 +
        sampleRow(v_TexCoord + vec2(0.0, +1.0 * ty), tx) * w1 +
        sampleRow(v_TexCoord + vec2(0.0, +2.0 * ty), tx) * w2 +
        sampleRow(v_TexCoord + vec2(0.0, +3.0 * ty), tx) * w3;

    // Escurecimento leve (efeito vidro fosco — igual ao Photoshop em ~88% opacidade)
    // Remover esta linha para manter as cores originais sem escurecimento.
    color.rgb *= 0.95;

    gl_FragColor = color;
}
