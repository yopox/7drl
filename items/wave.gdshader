shader_type canvas_item;

uniform float width;
uniform float progress;

void fragment() {
	vec2 center = vec2(0.5, 0.5);
	vec2 disp = UV - center;
	float dist = length(disp) * 2.0;
	if (dist <= progress - width) {
		COLOR.a /= 4.0;
	} else if (dist <= progress) {
		COLOR.a /= 2.0;
	} else if (dist <= 1.0) {
		COLOR.a /= 4.0;
	} else {
		COLOR.a = 0.0;
	}
}