shader_type canvas_item;

#include "utils.gdshaderinc"

uniform sampler2D screen_texture: hint_screen_texture, repeat_disable, filter_linear_mipmap;
uniform float lod: hint_range(0.0, 5) = 2.0;
uniform float saturation: hint_range(0.0, 1) = 0.65;
//uniform float progress: hint_range(0.0, 1) = 0.0;

void fragment() {
    vec4 color = texture(screen_texture, SCREEN_UV);
	color = texture(screen_texture, SCREEN_UV, lod);
	color = desaturate(color, (1.0 - saturation));
	COLOR = color;
}