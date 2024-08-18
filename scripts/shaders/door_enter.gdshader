shader_type canvas_item;
uniform float size = 10.0;
void fragment() {
	if (((UV.x - 0.5) * (UV.x - 0.5)) * 810.0 + ((UV.y - 0.5) * (UV.y - 0.5)) * 270.0 < size) {
		COLOR.a = 0.0;
	}
}