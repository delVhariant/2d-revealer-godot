class_name RevealableUtils extends Node2D

# TODO this should be a manager class that tracks all revealables / materials
# that way each revealable can more easily track multiple layers/masks
# without the groups needing to be aware of each other

enum RevealStates { REVEAL, CONCEAL, WAITING }

enum LayerIndexes {
	BEHIND = 0,
	PLAYER = 1,
	IN_FRONT = 2,
}

static var bounds: Array[Vector4] = [Vector4(), Vector4(), Vector4(), Vector4()]


static func set_bounds(depth: int, value: Vector4):
	bounds[depth] = value
	RenderingServer.global_shader_parameter_set(
		"mask_bounds", Projection(bounds[0], bounds[1], bounds[2], bounds[3])
	)
