// rollout_fragment.frag  (FRAGMENT)

uniform mat4 u_Color;
uniform sampler2D u_Tex0;
uniform float u_Time;
uniform vec2 u_Resolution;

uniform float u_RollAmount;
uniform float u_SpinSpeed;

varying vec2 v_TexCoord;
varying vec2 v_TexCoord2;
varying vec2 v_TexCoord3;
varying vec2 v_Position;

void main()
{
    // centro da UV pra girar
    vec2 center = vec2(0.5, 0.5);
    vec2 uv = v_TexCoord;

    // movimento lateral pra dar sensação de rolando no chão
    uv.x += u_Time * 0.3 * u_RollAmount;

    // rotação da textura
    float angle = u_Time * u_SpinSpeed * u_RollAmount;
    float c = cos(angle);
    float s = sin(angle);
    mat2 rot = mat2(c, -s,
                    s,  c);

    vec2 uvRot = uv - center;
    uvRot = rot * uvRot;
    uvRot += center;

    // leve achatada/esticada também na UV
    float stretchX = mix(1.0, 1.5, u_RollAmount);
    float flattenY = mix(1.0, 0.7, u_RollAmount);
    vec2 uvScaled = uvRot;
    uvScaled.x = (uvScaled.x - center.x) / stretchX + center.x;
    uvScaled.y = (uvScaled.y - center.y) / flattenY + center.y;

    vec4 baseCol = texture2D(u_Tex0, uvScaled);

    // teu engine manda cor como mat4, vamos pegar a coluna 0
    vec4 colorMul = vec4(u_Color[0][0], u_Color[1][0], u_Color[2][0], u_Color[3][0]);
    vec4 finalColor = baseCol * colorMul;

    if (finalColor.a < 0.01) {
        discard;
    }

    gl_FragColor = finalColor;
}
