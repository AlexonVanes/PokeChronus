uniform mat4 u_Color;
varying vec2 v_TexCoord;
varying vec2 v_TexCoord2;
varying vec2 v_TexCoord3;
varying vec2 v_Position;
uniform sampler2D u_Tex0;
uniform float u_Time;
uniform vec2 u_Resolution;

vec3 hsv2rgb(vec3 c) {
  vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
  vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
  return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

#pragma glslify: export(hsv2rgb)

// Converte alpha parcial em presenca binaria suave para deteccao de borda.
// Sprites semi-transparentes (fogo, brush) contribuem como se fossem solidos.
float solidAlpha(vec2 uv) {
    return smoothstep(0.05, 0.4, texture2D(u_Tex0, uv).a);
}

float sampleGlowBlur(vec2 uv, vec2 texel, float radius) {
    // radius em pixels (ex: 2.0, 4.0, 6.0, 10.0)
    vec2 t = texel * radius;

    float w0 = 0.227027; // center
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

    return sum;
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

    if(gl_FragColor.a < 0.15) {
        vec2 safeResolution = max(u_Resolution, vec2(1.0));
        vec2 texel = vec2(2.0) / safeResolution;
        float glowMask = sampleGlowBlur(v_TexCoord3, texel, 10.0);


        if(glowMask > 0.02) {
            float glow = smoothstep(0.02, 2.58, glowMask);
            float pulse = 0.82 + 0.18 * sin(u_Time * 9.28318);
            float hueOffset = length(v_Position) * 0.0015;
            vec3 rainbow = hsv2rgb(vec3(mod(u_Time * 0.18 + hueOffset, 1.0), 0.9, 1.0));
            vec3 glowColor = rainbow * (0.7 + glow * 0.75) * pulse;
            float alpha = min(1.0, glow * 1.25);
            gl_FragColor = vec4(glowColor, alpha);
        } else {
            discard;
        }
    }
}
