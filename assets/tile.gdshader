shader_type canvas_item;

uniform vec4 move_param = vec4(0.0, 0.0, 0.0, 0.0);
uniform vec4 tile_color = vec4(0.18, 0.173, 0.231, 0.5);

void vertex() {
	if (move_param[0] > 0.05 || move_param[2] > 0.05) {
		VERTEX += vec2(cos(TIME * move_param[0]) * move_param[1], sin(TIME * move_param[2]) * move_param[3]);
	}
}

void fragment() {
	COLOR = texture(TEXTURE, UV);

	if (COLOR.r == 0.0) {
		COLOR.a = 0.0;
	} else {
		COLOR.r = tile_color.r;
		COLOR.g = tile_color.g;
		COLOR.b = tile_color.b;
		COLOR.a = tile_color.a;
	}
}
