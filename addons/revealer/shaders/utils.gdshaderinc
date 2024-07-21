
#include "globals.gdshaderinc"

// Gets the size ratio of a texture so that circles don't draw as ovals
vec2 get_texture_ratio(vec2 texture_size) {
	vec2 ps = texture_size;
    return (ps.x > ps.y) ? vec2(ps.y / ps.x, 1) : vec2(1, ps.x / ps.y);
}

vec2 get_min_mask_bounds(int mask, vec2 screen_size) {
	return mask_bounds[mask].xy * screen_size;
}

vec2 get_max_mask_bounds(int mask, vec2 screen_size) {
	return mask_bounds[mask].zw * screen_size;
}

bool approx_equal(float a, float b) {
	return abs(a - b) < 0.001;
}

// adapted from https://stackoverflow.com/a/26697650
bool in_mask_bounds(int mask, vec2 screen_uv, vec2 screen_size) {
	vec2 s = step(get_min_mask_bounds(mask, screen_size), screen_uv) -
			 step(get_max_mask_bounds(mask, screen_size), screen_uv);
	return abs((s.x * s.y) - 1.0) < 0.0001;
}

// adapted from https://stackoverflow.com/a/37426532
float get_mask_vignette(int mask, vec2 uv, vec2 size) {
	vec2 minM = get_min_mask_bounds(mask, size);
	vec2 maxM = get_max_mask_bounds(mask, size);
	//float vignette = length(get_max_mask_bounds(size) - get_min_mask_bounds(size));
	float vignette = length(maxM - minM);
	vec2 radius_x = vec2(0.05);
	vec2 radius_y = vec2(0.05, 0.0);
	//vec2 s = smoothstep(get_min_mask_bounds(size), get_min_mask_bounds(size) + (radius_x * vignette), uv) -
			 //smoothstep(get_max_mask_bounds(size) - (radius_y * vignette), get_max_mask_bounds(size), uv);
	vec2 s = smoothstep(minM, minM + (radius_x * vignette), uv) -
			 smoothstep(maxM - (radius_y * vignette), maxM, uv);
    return (s.x * s.y);
}

// Desaturates a color by the provided factor
vec4 desaturate(vec4 color, float factor)
{
	vec3 lum = vec3(0.299, 0.587, 0.114);
	vec3 gray = vec3(dot(lum, color.rgb));
	return vec4(mix(color.rgb, gray, factor), color.a);
}

mat2 rotate2d(float _angle){
    return mat2(vec2(cos(_angle),-sin(_angle)),
                vec2(sin(_angle),cos(_angle)));
}

float circle(vec2 position, float radius, float feather)
{
	return smoothstep(radius, radius+feather, length(position));
}

float star(vec2 position, float radius, float feather, float points)
{
	float point_amount = sin(atan(position.y, position.x) * points + PI / 2.0) * radius;
	return smoothstep(radius, radius+feather, length(position) + (point_amount/points));
}
