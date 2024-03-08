shader_type canvas_item;

uniform float progress;

void fragment() {
	vec2 center = vec2(0.5, 0.5);
	vec2 disp = UV - center;
	float dist = length(disp) * 2.0;
	float progress_angle = -PI / 4.0 + progress * PI / 2.0;
	float angle = atan(disp.y / disp.x);
	if (dist <= 0.65) {
		COLOR.a = 0.0;
	} else if (disp.x > 0.1 && angle + PI / 4.0 > 0.0 && angle <= progress_angle && dist <= 1.0) {
		COLOR.a /= 2.0;
	} else {
		COLOR.a = 0.0;
	}
}