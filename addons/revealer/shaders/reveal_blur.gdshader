shader_type canvas_item;
/* DEFINES */
#define DESATURATE(c, f) mix(c.rgb, vec3(dot(vec3(0.299, 0.587, 0.114), c.rgb)), f)
#define NUM_MASKS 3


uniform sampler2D screen_texture: hint_screen_texture, repeat_disable, filter_linear_mipmap;
// The lod level to use when blurring. Higher values will blur more.
uniform float lod: hint_range(0.0, 2) = 0.8;
// The target amount of saturation. 1 will be fully saturated, 0 will be fully desaturated
uniform float saturation: hint_range(0.0, 1) = 0.65;

// Set by the RevealPostProcess object
uniform vec4[NUM_MASKS] masks;
uniform sampler2D[NUM_MASKS] samplers;

void fragment() {
	vec4 color = texture(screen_texture, SCREEN_UV);
	for(int i = 0; i < NUM_MASKS; i++) {
		if(masks[i] == vec4(0.0)) {
			continue;
		}
		// Increase the mask size by 1% of its total when checking bounds
		vec2 sz = (masks[i].zw - masks[i].xy) * 0.01;
		vec2 b = step(masks[i].xy + sz, FRAGCOORD.xy)
			- step(masks[i].zw - sz, FRAGCOORD.xy);
		float in_bounds = abs((b.x * b.y) - 1.0);

		if(in_bounds < 0.001) {
			continue;
		}

		// Get the alpha level of the mask texture at the current coord
		vec2 mask_uv = FRAGCOORD.xy / masks[i].zw;
    	float mask_alpha = texture(samplers[i], mask_uv).a;
		if(mask_alpha < 0.001) {
			continue;
		}

		color = texture(screen_texture, SCREEN_UV, lod);
		color.rgb = DESATURATE(color, (1.0 - saturation));
		break; // Don't apply multiple times if we happen to be in multiple masks
	}
	COLOR = color;

}