uniform mat4 u_Color;
varying vec2 v_TexCoord;
varying vec2 v_TexCoord2;
varying vec2 v_TexCoord3;
varying vec2 v_Position;
uniform sampler2D u_Tex0;
uniform float u_Time;
uniform vec2 u_Resolution;

void main()
{
    vec2 offset = vec2(
        sin(u_Time * 55.0) * 0.01, // Tremor horizontal (eixo X)
        0.0 // Não há tremor no eixo Y
    );
    vec2 texCoord = v_TexCoord + offset;

    vec4 texcolor = texture2D(u_Tex0, v_TexCoord2);
    vec4 texcolor2 = texture2D(u_Tex0, v_TexCoord3);
    
    vec2 distortion = vec2(
        sin(texCoord.y * 40.0) * 0.01, // Distorção horizontal baseada na coordenada Y
        cos(texCoord.x * 30.0) * 0.03  // Distorção vertical baseada na coordenada X
    );

    vec2 distortedTexCoord = texCoord + distortion;

    vec4 finalColor = texture2D(u_Tex0, distortedTexCoord);

    if(finalColor.a < 0.01) {
        if(texcolor2.a > 0.01) {
            float blurAmount = 0.005;
            float total = 0.0;
            vec4 blurColor = vec4(0.0);

            for (float i = -4.0; i <= 4.0; i++) {
                vec2 blurOffset = vec2(i * blurAmount, 0.0);
                blurColor += texture2D(u_Tex0, distortedTexCoord + blurOffset) * 0.05;
                total += 0.05;
            }

            finalColor = blurColor / total;
        } else {
            discard;
        }
    }

    gl_FragColor = finalColor;
}
