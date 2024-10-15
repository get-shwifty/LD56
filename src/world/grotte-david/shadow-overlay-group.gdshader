shader_type canvas_item;

uniform float alpha: hint_range(0.0, 1.0, 0.1) = 1;
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

void fragment() {
	vec4 c = textureLod(screen_texture, SCREEN_UV, 0.0);

	if (c.a > 0.0001) {
		c.rgb /= c.a;
	}
	vec4 tmp = COLOR * c;
	COLOR = vec4(0, 0, 0, (1.0 - tmp.r)*alpha);
}