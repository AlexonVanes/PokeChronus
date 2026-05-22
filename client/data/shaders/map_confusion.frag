uniform sampler2D u_Tex0;
varying vec2 v_TexCoord;
uniform vec2 u_Resolution;
uniform float u_Time; // Adicionar tempo como uma variável uniforme

const int NUM_SAMPLES = 2;
const float BLUR_AMOUNT = 0.01;

void main(void) {
    vec2 center = vec2(-0.05, 0.1);
    vec2 normCoord = 2.0 * v_TexCoord - 1.0;
    vec2 dir = normCoord - center;

    vec4 color = vec4(0.0);
    float total = 0.0;

    // Parâmetros para o efeito de 'embriaguez'
    float wobbleAmount = 0.009; // Quantidade de distorção
    float speed = 1.0; // Velocidade da ondulação

    for (int i = 0; i < NUM_SAMPLES; ++i) {
        float t = float(i) * BLUR_AMOUNT;
        vec2 wobble = vec2(sin(u_Time * speed + normCoord.y * 10.0), cos(u_Time * speed + normCoord.x * 10.0)) * wobbleAmount;
        vec2 samplePos = v_TexCoord + dir * t + wobble; // Adicionar distorção ondulante
        vec4 sampleCol = texture2D(u_Tex0, samplePos);
        color += sampleCol;
        total += 1.0;
    }

    color /= total;

    gl_FragColor = color;
}
