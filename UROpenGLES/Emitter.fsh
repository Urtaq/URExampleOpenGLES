// Fragment Shader

static const char* EmitterFS = STRINGIFY
(

 // Input from Vertex Shader
 varying highp vec3 vShade;

 // Uniforms
 uniform highp vec3 uColor;

 void main(void)
{
    highp vec4 color = vec4((uColor+vShade), 1.0);
    color.rgb = clamp(color.rgb, vec3(0.0), vec3(1.0));
    gl_FragColor = color;
}

);
