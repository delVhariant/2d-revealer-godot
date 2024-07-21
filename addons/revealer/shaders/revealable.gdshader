shader_type canvas_item;

#include "utils.gdshaderinc"

// Th amount of the texture to reveal, as a percentage
uniform float revealed_amount : hint_range(0.0, 1.0)= 0 ;

// This is the screen position of the start point
uniform vec2 start_position = vec2(0, 0);

uniform int reveal_depth : hint_range(0, 3)= 0 ;

uniform vec4 mask_vignette = vec4(10.0, 10.0, 10.0, 0.0);
uniform vec3 mask_vignette_color : source_color = vec3(0.0);

// true will draw a circle, false will be uniform fade
uniform bool circular_reveal = false;

// Mask information
uniform sampler2D mask_sampler;

void vertex() {
    // Called for every vertex the material is visible on.
}

void fragment() {
    //
    vec4 mask = mask_bounds[reveal_depth];
    // Check if the current fragment is in the mask bounds
    vec2 v = smoothstep(mask.xy, mask.xy + mask_vignette.xy, FRAGCOORD.xy) -
            smoothstep(mask.zw - mask_vignette.zw, mask.zw, FRAGCOORD.xy);
    float in_bounds = abs(v.x * v.y);

    float alpha = revealed_amount * ceil(in_bounds);

    // Get the transparency of the mask at the current position
    vec2 mask_uv = FRAGCOORD.xy / mask.zw;
    float mask_alpha = texture(mask_sampler, mask_uv).a;

    if (circular_reveal) {
        alpha = step(distance(FRAGCOORD.xy, start_position), distance(mask.xy, mask.zw) * revealed_amount) * in_bounds;
    } else {
        alpha = min(alpha, mask_alpha);
    }

    // draw the mask vignette
    if (mask_vignette != vec4(0.0) && in_bounds > 0.0 && in_bounds < 1.0) {
        vec3 c = mix(mask_vignette_color, COLOR.rgb, clamp(1.0 - in_bounds, 0.0, 1.0));
        COLOR.rgb = mix(COLOR.rgb, c, revealed_amount);
    } else {
        // Support transparency within the texture
        COLOR.a = min(COLOR.a, (1.0 - alpha));
    }
}
