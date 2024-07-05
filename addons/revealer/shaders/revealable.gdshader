shader_type canvas_item;

#include "utils.gdshaderinc"

// Th amount of the texture to reveal, as a percentage
uniform float revealed_amount : hint_range(0.0, 1.0) = 0;
uniform float revealed_amount_target = 0;
// The amount of feathering to apply to the revealed circle
uniform float feather : hint_range(0.0, 0.1) = 0.05;
uniform float points = 5;
// The start position in screen pixels
// This is the local position of the start point in world space
uniform vec2 start_position = vec2(0, 0);

uniform int reveal_depth : hint_range(0, 3) = 0;

// Parent information
//uniform sampler2D parent_tex; // The sampler for the parent sprite
//uniform vec2 parent_offset; // Amount to offset the parent from this sprite
//uniform vec2 parent_ratio = vec2(1, 1); // Ratio of parent sprite to this sprite


void vertex() {
	// Called for every vertex the material is visible on.
}


void fragment() {

	if(in_mask_bounds(reveal_depth, SCREEN_UV, SCREEN_PIXEL_SIZE)) {
		float alpha = COLOR.a;
		//COLOR.rgb = vec3(1.0, 0, 0);
		// Get the correct pixel ratio so circles work properly
		//vec2 ratio = get_texture_ratio(TEXTURE_PIXEL_SIZE);
//
		//// Convert start position to UV, with 0,0 being the center
		//vec2 point = vec2(0.5) + (start_position * TEXTURE_PIXEL_SIZE);
		//vec2 offset_uv = (UV - point) * ratio;
//
		//// Speed up the reveal relative to the position of the parent
		//if(parent_offset != vec2(0)) {
			//offset_uv *= length(parent_offset * TEXTURE_PIXEL_SIZE);
		//}
		//alpha = circle(offset_uv, revealed_amount, revealed_amount * feather);

		// Support transparency within the texture
		alpha = min(COLOR.a, 1.0 - revealed_amount);
		COLOR.a = alpha;
	} else {
		COLOR = desaturate(COLOR, revealed_amount);
	}
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
