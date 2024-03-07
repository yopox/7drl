shader_type canvas_item;

uniform vec4 fg = vec4(0.953, 0.953, 0.953, 1.0);
uniform vec4 bg = vec4(0.114, 0.094, 0.094, 1.0);
uniform bool no_bg = false;

void fragment() {
	COLOR = texture(TEXTURE, UV);

	if (COLOR.r == 0.0) {
		if (no_bg) {
			COLOR.a = 0.0;
		} else {
			COLOR = bg;
		}
	} else {
		COLOR = fg;
	}
}
