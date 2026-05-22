// rollout_vertex.frag (VERTEX) - bola com escala

attribute vec2 a_TexCoord;
attribute vec2 a_Vertex;

uniform mat3 u_TextureMatrix;
uniform mat3 u_TransformMatrix;
uniform mat3 u_ProjectionMatrix;

uniform vec2 u_Offset;
uniform vec2 u_Resolution;
uniform vec2 u_Center;

uniform float u_Time;

varying vec2 v_TexCoord;
varying vec2 v_TexCoord2;
varying vec2 v_TexCoord3;
varying vec2 v_Position;

void main()
{
    // você pode travar aqui se quiser sempre cheio:
    const float amount = 0.3;
    const float ROLL_SPEED = 50.0;

    // posição base
    vec2 vertex = a_Vertex;
    vec2 local = vertex - u_Center;

    // 1) QUAD -> CÍRCULO
    float r = max(abs(local.x), abs(local.y));
    float lenLocal = length(local);
    if (lenLocal > 0.0001) {
        vec2 dir = local / lenLocal;
        local = dir * r;
    }

    // 2) ESCALA DA BOLA usando o amount
    // quando amount = 0 → 1.0 (tamanho normal)
    // quando amount = 1 → 1.6 (maior)
    float scale = mix(1.0, 1.6, amount);
    local *= scale;

    // 3) GIRAR
    float angle = u_Time * ROLL_SPEED;
    float c = cos(angle);
    float s = sin(angle);
    vec2 rotated;
    rotated.x = local.x * c - local.y * s;
    rotated.y = local.x * s + local.y * c;

    // volta pro centro
    vertex = rotated + u_Center;

    // UVs padrão
    vec2 text  = a_TexCoord;
    vec2 text2 = a_TexCoord + u_Offset;

    gl_Position = vec4((u_ProjectionMatrix * u_TransformMatrix * vec3(vertex, 1.0)).xy, 1.0, 1.0);

    v_Position = a_Vertex - u_Center;
    v_TexCoord  = (u_TextureMatrix * vec3(text, 1.0)).xy;
    v_TexCoord2 = (u_TextureMatrix * vec3(text + u_Offset, 1.0)).xy;
    v_TexCoord3 = (u_TextureMatrix * vec3(text2, 1.0)).xy;
}
