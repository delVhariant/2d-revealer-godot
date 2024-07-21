class_name RevealPostProcess extends ColorRect

@export var masks: Array[Vector4] = [Vector4.ZERO, Vector4.ZERO, Vector4.ZERO]
@export var samplers: Array[Sprite2D] = [null, null, null]


func _process(_delta: float) -> void:
	setup_masks()
	material.set_shader_parameter("masks", masks)


func set_mask(index: int, sprite: Sprite2D):
	samplers[index] = sprite
	material.set_shader_parameter("samplers", samplers)


func setup_masks() -> void:
	for i in range(samplers.size()):
		if samplers[i] == null:
			masks[i] = Vector4.ZERO
			continue
		masks[i] = get_mask_rect(samplers[i])


func get_mask_rect(sampler: Sprite2D) -> Vector4:
	var size := sampler.get_rect().size
	var offset = ((size / 2) * sampler.scale * get_camera_zoom()).round()
	var rect_min = sampler.get_screen_transform().origin.round()
	var rect_max = rect_min
	if sampler.centered:
		rect_min -= offset
		rect_max += offset
	else:
		rect_max += offset * 2
	return Vector4(rect_min.x, rect_min.y, rect_max.x, rect_max.y)


func get_camera_zoom():
	var vp := get_viewport()
	if !vp:
		return 1.0
	var cam = get_viewport().get_camera_2d()
	if !cam:
		return 1.0
	return cam.zoom
