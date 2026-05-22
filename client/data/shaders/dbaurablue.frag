uniform mat4 u_Color;
varying vec2 v_TexCoord;
varying vec2 v_TexCoord2;
varying vec2 v_Position;
uniform sampler2D u_Tex0;
uniform float u_Time;
uniform vec2 u_Resolution;

// CONFIG
float auraSize = 14.0;       // Tamanho da aura
float auraIntensity = 3.0;   // Intensidade da aura
float flameSpeed = 2.5;      // Velocidade da animação ascendente
float pulseSpeed = 3.0;      // Velocidade da pulsação da aura
float colorShiftSpeed = 3.5; // Velocidade da mudança de tom
float transparency = 0.4;    // Transparência geral da aura
// CONFIG END

// COR DA AURA
// 0.0 = Vermelho
// 0.33 = Verde
// 0.55-0.65 = Azul
// 0.8 = Roxo/Rosa
float baseHue = 0.65;         // Vermelho (Super Saiyajin Deus)
float hueVariation = 0.05;   // Variação do tom para animação

// Função auxiliar para converter HSV para RGB
vec3 hsv2rgb(vec3 c) {
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

// Função de ruído para efeito de fogo/fumaça
float noise(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898, 78.233))) * 43758.5453);
}

// Ruído mais suave
float smoothNoise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    
    // Quatro cantos do quadrado
    float a = noise(i);
    float b = noise(i + vec2(1.0, 0.0));
    float c = noise(i + vec2(0.0, 1.0));
    float d = noise(i + vec2(1.0, 1.0));
    
    // Suavização
    vec2 u = f * f * (3.0 - 2.0 * f);
    
    return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

// Turbulência para gera efeito de fogo/fumaça
float turbulence(vec2 p, int octaves) {
    float value = 0.0;
    float amplitude = 1.0;
    float frequency = 1.0;
    
    for (int i = 0; i < octaves; i++) {
        value += amplitude * smoothNoise(p * frequency);
        amplitude *= 0.5;
        frequency *= 2.0;
    }
    
    return value;
}

// Função para criar o efeito de movimento vertical
float verticalEffect(vec2 pos, float time) {
    // Maior influência na parte inferior, diminuindo conforme sobe
    float verticalFactor = max(0.0, 1.0 - (pos.y + 10.0) / 20.0);
    
    // Noise ascendente
    float noiseVal = smoothNoise(vec2(pos.x * 0.1, pos.y * 0.1 - time * flameSpeed));
    
    // Combina para criar movimento vertical mais forte na base
    return verticalFactor * noiseVal * 2.0;
}

void main()
{
    // Obter cores originais
    vec4 originalColor = texture2D(u_Tex0, v_TexCoord);
    vec4 texcolor = texture2D(u_Tex0, v_TexCoord2);
    
    // Aplicar cores normais ao sprite (sem modificação)
    gl_FragColor = originalColor;
    
    // Colorização original
    if(texcolor.r > 0.9) {
        gl_FragColor *= texcolor.g > 0.9 ? u_Color[0] : u_Color[1];
    } else if(texcolor.g > 0.9) {
        gl_FragColor *= u_Color[2];
    } else if(texcolor.b > 0.9) {
        gl_FragColor *= u_Color[3];
    }
    
    // Efeito de aura apenas em pixels visíveis do sprite
    if(originalColor.a > 0.1) {
        // Calcular distância do centro
        float dist = length(v_Position);
        
        // Efeito de movimento ascendente mais forte
        float verticalMovement = verticalEffect(v_Position, u_Time);
        
        // Calcula pulsação da aura
        float pulseFactor = sin(u_Time * pulseSpeed) * 0.2 + 0.8;
        
        // Calcula a influência da aura baseada na distância
        float auraFactor = auraSize / (dist + 4.0);
        
        // Coordenadas para o efeito de chama subindo
        vec2 flameCoord = v_Position * 0.1;
        // Movimento ascendente fortemente direcionado para cima
        flameCoord.y += u_Time * flameSpeed * 1.5;
        
        // Turbulência para aparência de fumaça
        float flameTurbulence = turbulence(flameCoord, 3);
        
        // Cor da aura - vermelho com variação sutil
        float hue = baseHue + hueVariation * sin(u_Time * colorShiftSpeed);
        vec3 auraColor = hsv2rgb(vec3(hue, 0.9, 1.0)); // Mais saturado para vermelho mais vivo
        
        // Para aura vermelha, adicionamos leves toques alaranjados com a turbulência
        vec3 flameColor = hsv2rgb(vec3(
            hue + flameTurbulence * 0.07, // Variação sutil para tons alaranjados
            0.9 + flameTurbulence * 0.1,  // Alta saturação para vermelho vibrante
            0.9 + verticalMovement * 0.1  // Brilho variando com o movimento vertical
        ));
        
        // Mistura cores com mais influência do movimento vertical
        vec3 finalAuraColor = mix(auraColor, flameColor, flameTurbulence + verticalMovement * 0.5);
        
        // Aplica a cor da aura como brilho adicional, com transparência
        vec3 auraEffect = finalAuraColor * auraFactor * auraIntensity * pulseFactor * transparency;
        
        // Adiciona a aura suavemente à cor original
        gl_FragColor.rgb = mix(gl_FragColor.rgb, gl_FragColor.rgb + auraEffect, transparency);
        
        // Limita a cor para evitar oversaturação
        gl_FragColor.rgb = min(gl_FragColor.rgb, vec3(1.0));
    }
    
    // Descarta pixels totalmente transparentes
    if(gl_FragColor.a < 0.01) discard;
}