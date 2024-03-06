shader_type canvas_item;
render_mode blend_mul;

void fragment() {
	COLOR.rgb = COLOR.rgb * COLOR.a;
}