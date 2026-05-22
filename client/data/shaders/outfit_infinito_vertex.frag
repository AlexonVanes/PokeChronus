#ifdef GL_ES
precision mediump float;
#endif

attribute vec4 a_Vertex;
attribute vec2 a_TexCoord;

uniform mat3 u_TextureMatrix;
uniform mat3 u_TransformMatrix;
uniform mat3 u_ProjectionMatrix;

// OPCIONAL: passe o centro do personagem (em coords do a_Vertex)
uniform vec2 u_Center;     // default (0,0) = usar auto center
uniform vec2 u_Size;       // largura/altura da quad (px), ex.: frame do sprite

varying vec2 v_TexCoord;
varying vec2 v_TexCoord2;
varying vec2 v_PosRel;

uniform vec2 u_Offset;     // offset da segunda amostra (se houver máscara)

void main() {
    vec3 world = u_TransformMatrix * vec3(a_Vertex.xy, 1.0);
    vec2 clip  = (u_ProjectionMatrix * vec3(world.xy, 1.0)).xy;
    gl_Position = vec4(clip, 1.0, 1.0);

    // centro automático se u_Center = (0,0)
    vec2 center = (u_Center == vec2(0.0)) ? (u_Size * 0.5) : u_Center;
    v_PosRel = a_Vertex.xy - center;

    v_TexCoord  = (u_TextureMatrix * vec3(a_TexCoord, 1.0)).xy;
    v_TexCoord2 = (u_TextureMatrix * vec3(a_TexCoord + u_Offset, 1.0)).xy;
}
