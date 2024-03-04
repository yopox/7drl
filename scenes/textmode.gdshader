shader_type canvas_item;

uniform vec4 fg = vec4(1.0, 1.0, 1.0, 1.0);
uniform vec4 bg = vec4(0.0, 0.0, 0.0, 1.0);

void fragment() {
	COLOR = texture(TEXTURE, UV);
	
	if (COLOR.r == 0.0) {
		COLOR = bg;
	} else {
		COLOR = fg;
	}
}
