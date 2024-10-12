shader_type canvas_item;
render_mode blend_add,light_only;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 tex_color = texture(TEXTURE, UV);
	COLOR = vec4(0.08, 0.19, 0.30, tex_color.a);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
