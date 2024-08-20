shader_type canvas_item;
uniform float deadzone = 0.6;
uniform float strength = 1.0;
void fragment() {
	if(UV.y > deadzone) {
		COLOR.a -= (UV.y - deadzone) * strength;
	}
}