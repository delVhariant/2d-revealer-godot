class_name Revealable extends Object

# TODO support multiple layers/masks
var target: Sprite2D


func _init(
	sprite: Sprite2D,
	material: ShaderMaterial,
	depth: int,
):
	self.target = sprite
	self.target.set_material(material.duplicate())
	self.set_reveal_depth(depth)


func set_reveal_depth(value: int):
	print("{0} depth is now: {1}".format([self.target.name, value]))
	target.material.set_shader_parameter("reveal_depth", value)


func reveal(value: float):
	target.material.set_shader_parameter("revealed_amount", value)


func set_reveal_target(value: float):
	target.material.set_shader_parameter("revealed_amount_target", value)


func set_sampler(value: Sprite2D):
	target.material.set_shader_parameter("mask_sample", value)
