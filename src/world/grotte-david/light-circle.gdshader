shader_type canvas_item;

uniform sampler2D screen_tex : hint_screen_texture;

void fragment()
{
	vec4 baseColor = texture(TEXTURE, UV);
    vec4 blendColor = texture(screen_tex, SCREEN_UV);

    COLOR = baseColor * blendColor;
}