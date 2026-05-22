uniform sampler2D u_Tex0;
varying vec2 v_TexCoord;
uniform vec2 u_Resolution;
uniform float u_Darkness; // Fator de escurecimento (0.0 = sem escurecimento, 1.0 = completamente escuro)

const int NUM_SAMPLES = 10;
const float BLUR_AMOUNT = 3.1;

void main(void) {
    vec2 texelSize = 1.0 / u_Resolution; // Tamanho de um texel
    vec4 color = vec4(0.0);
    float total = 0.0;

    // Coeficientes gaussianos (simétricos)
    float weights[NUM_SAMPLES];
    weights[0] = 0.227027;
    weights[1] = 0.1945946;
    weights[2] = 0.1216216;
    weights[3] = 0.054054;
    weights[4] = 0.016216;
    weights[5] = 0.016216;
    weights[6] = 0.054054;
    weights[7] = 0.1216216;
    weights[8] = 0.1945946;
    weights[9] = 0.227027;

    // Aplicando o desfoque horizontal
    for (int i = -NUM_SAMPLES / 2; i <= NUM_SAMPLES / 2; ++i) {
        int index = (i < 0) ? -i : i;
        vec2 offset = vec2(float(i) * BLUR_AMOUNT, 0.0) * texelSize;
        vec2 samplePos = clamp(v_TexCoord + offset, 0.0, 1.0); // Garante que samplePos esteja dentro dos limites
        color += texture2D(u_Tex0, samplePos) * weights[index];
        total += weights[index];
    }

    // Aplicando o desfoque vertical
    vec4 finalColor = vec4(0.0);
    for (int i = -NUM_SAMPLES / 2; i <= NUM_SAMPLES / 2; ++i) {
        int index = (i < 0) ? -i : i;
        vec2 offset = vec2(0.0, float(i) * BLUR_AMOUNT) * texelSize;
        vec2 samplePos = clamp(v_TexCoord + offset, 0.0, 1.0); // Garante que samplePos esteja dentro dos limites
        finalColor += texture2D(u_Tex0, samplePos) * weights[index];
    }

    // Média final das cores
    finalColor /= total;

    // Aplicar escurecimento
    finalColor.rgb *= (1.0 - 0.1);

    gl_FragColor = finalColor;
}
