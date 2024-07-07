class_name RevealableUtils extends Node2D

enum RevealStates { REVEAL, CONCEAL, WAITING }

enum RevealableZIndexes {
	BEHIND = 0,
	PLAYER = 1,
	IN_FRONT = 2,
}

static var bounds: Array[Vector4] = [Vector4(), Vector4(), Vector4(), Vector4()]


static func set_primary_bounds(value: Vector4):
	RenderingServer.global_shader_parameter_set("primary_mask_bounds", value)


static func set_secondary_bounds(value: Vector4):
	RenderingServer.global_shader_parameter_set("secondary_mask_bounds", value)


static func set_bounds(depth: int, value: Vector4):
	bounds[depth] = value
	RenderingServer.global_shader_parameter_set(
		"mask_bounds", Projection(bounds[0], bounds[1], bounds[2], bounds[3])
	)
