shader_type canvas_item;

#include "utils.gdshaderinc"

// Th amount of the texture to reveal, as a percentage
uniform float revealed_amount : hint_range(0.0, 1.0) = 0;

// The start position in screen pixels
// This is the local position of the start point in world space
uniform vec2 start_position = vec2(0, 0);

uniform int reveal_depth : hint_range(0, 3) = 0;

// Mask information
uniform sampler2D mask_sampler;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	if(in_mask_bounds(reveal_depth, SCREEN_UV, SCREEN_PIXEL_SIZE)) {
		// Calculate the transparency of the mask at the current position
		vec4 mask = mask_bounds[reveal_depth];
		vec2 mask_uv = FRAGCOORD.xy / mask.zw;
		float mask_alpha = texture(mask_sampler, mask_uv).a;
		float alpha = min(revealed_amount, mask_alpha);

		// Support transparency within the texture
		COLOR.a = alpha = min(COLOR.a, 1.0 - alpha);
	}
}