shader_type canvas_item;

uniform float percent : hint_range(0.0, 1.0);
uniform bool enable;
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

void fragment() {
	vec4 col = texture(screen_texture, SCREEN_UV);
	col.r = (col.r+col.g+col.b)/3.0;
	if (col.r > percent && col.a != 0.0 && enable) {
		COLOR = vec4(1,0,0,1);
	}
	else if (col.a != 0.0 && enable) {
		COLOR = vec4(0,0,0,1);
	}
	else if (!enable) {
		COLOR = texture(screen_texture, SCREEN_UV);
	}
}
