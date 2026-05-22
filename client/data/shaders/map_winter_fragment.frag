varying vec2 v_TexCoord;
varying vec2 v_TexCoord2;

uniform vec4 u_Color;
uniform sampler2D u_Tex0;
uniform sampler2D u_Tex1;

void main()
{
    // Obter a cor da primeira textura e ajustar a opacidade
    vec4 color0 = texture2D(u_Tex0, v_TexCoord);
    color0.a = 0.05; // Definindo a opacidade para 0.1

    // Multiplicar pela cor uniforme
    vec4 finalColor = color0 * u_Color;

    // Adicionar a segunda textura
    finalColor += texture2D(u_Tex1, v_TexCoord2);

    // Descartar fragmentos com baixa opacidade
    if (finalColor.a < 0.01)
        discard;

    gl_FragColor = finalColor;
}
