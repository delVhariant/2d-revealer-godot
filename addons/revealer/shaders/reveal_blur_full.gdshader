shader_type canvas_item;
/* DEFINES */
#define DESATURATE(c, f) mix(c.rgb, vec3(dot(vec3(0.299, 0.587, 0.114), c.rgb)), f)
// Screen texture from the backbuffer copy
uniform sampler2D screen_texture: hint_screen_texture, repeat_disable, filter_linear_mipmap;
// The lod level to use when blurring. Higher values will blur more.
uniform float lod: hint_range(0.0, 2) = 0.8;
// The target amount of saturation. 1 will be fully saturated, 0 will be fully desaturated
uniform float saturation: hint_range(0.0, 1) = 0.65;
// Whether the blur / desaturate effect is active
uniform bool blurred = false;


void fragment() {
	vec4 color = texture(screen_texture, SCREEN_UV);
	if(blurred) {
		color = texture(screen_texture, SCREEN_UV, lod);
		color.rgb = DESATURATE(color, (1.0 - saturation));
	}
	COLOR = color;
}