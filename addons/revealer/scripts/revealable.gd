class_name Revealable extends Object
var target: Sprite2D


func _init(
	target: Sprite2D,
	material: ShaderMaterial,
):
	self.target = target
	self.target.set_material(material)


func reveal(value: float):
	target.material.set_shader_parameter("revealed_amount", value)


func set_reveal_target(value: float):
	target.material.set_shader_parameter("revealed_amount_target", value)
