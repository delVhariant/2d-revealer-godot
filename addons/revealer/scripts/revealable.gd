class_name Revealable extends Object
var target : Sprite2D
var target_rect: Rect2

func _init(target: Sprite2D, material: ShaderMaterial ,depth: int, parent: Sprite2D, mask: Sprite2D):
	self.target = target
	#self.target_rect = target.get_rect()
	#self.set_material(material)
	#self.set_reveal_depth(depth)
	#self.set_parent_details(parent)

func reveal(value: float):
	target.material.set_shader_parameter("revealed_amount", value)

func set_reveal_target(value: float):
	target.material.set_shader_parameter("revealed_amount_target", value)


func set_material(material: ShaderMaterial) -> void:
	target.set_material(material.duplicate())

func set_revealer_position(r: Vector2):
	target.material.set_shader_parameter("start_position", target.to_local(r))

# Sets the reveal_depth for this fadeable sprite
func set_reveal_depth(value : int) -> void:
	target.material.set_shader_parameter("reveal_depth", value)

func set_parent_details(parent : Sprite2D):
	var parent_rect = parent.get_rect()
	var offset = (target_rect.position - parent_rect.position) / target_rect.size
	var ratio = target_rect.size / parent_rect.size
	target.material.set_shader_parameter("parent_tex", parent.texture)
	target.material.set_shader_parameter("parent_offset", offset)
	target.material.set_shader_parameter("parent_ratio", ratio)
