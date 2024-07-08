class_name RevealableGroup extends Node2D

signal do_reveal(value)
signal set_reveal_target(value)
signal set_revealer(value)
signal set_z_index(value)

@export var revealable_parent: Sprite2D
@export var revealable_targets: Array[Sprite2D]
@export var modulate_targets: Array[Node2D]
@export var revealable_mask: Sprite2D
@export var default_z_index := RevealableUtils.RevealableZIndexes.BEHIND
@export var revealed_z_index := RevealableUtils.RevealableZIndexes.IN_FRONT
@export var reveal_state := RevealableUtils.RevealStates.WAITING
@export_range(0, 3) var reveal_group_depth: int = 0
@export_range(0.0, 1.0) var reveal_amount: float
@export_range(0, 10, 0.05) var reveal_time: float = 0.4

var revealables: Array[Revealable]
var mask_rect: Rect2
var mask_size: Vector2
var reveal_material_resource = preload("res://addons/revealer/materials/revealable.tres")
var reveal_material: ShaderMaterial


func _ready() -> void:
	if !revealable_parent:
		printerr("No revealable_parent assigned to RevealableGroup {0}".format([self.name]))
		process_mode = Node.PROCESS_MODE_DISABLED
		return
	if !revealable_mask:
		printerr("No revealable_mask assigned to RevealableGroup {0}".format([self.name]))
		process_mode = Node.PROCESS_MODE_DISABLED
		return
	# Clone the material
	setup_material()
	setup_mask()
	setup_parent()
	setup_group()


func setup_material() -> void:
	reveal_material = reveal_material_resource.duplicate()
	reveal_material.set_shader_parameter("mask_sampler", revealable_mask.texture)
	reveal_material.set_shader_parameter("reveal_depth", reveal_group_depth)


func setup_parent() -> void:
	setup_revealer(revealable_parent)


func setup_group() -> void:
	for r in revealable_targets:
		setup_revealer(r)


func setup_revealer(r: Sprite2D):
	var o = Revealable.new(r, reveal_material)
	do_reveal.connect(o.reveal)
	# set_reveal_target.connect(o.set_reveal_target)
	revealables.append(o)


func _process(delta: float) -> void:
	if reveal_amount > 0.0:
		set_mask_screen_rect()
	if reveal_state == RevealableUtils.RevealStates.WAITING:
		return

	if reveal_state == RevealableUtils.RevealStates.REVEAL:
		reveal_amount += delta * (1 / reveal_time)
	elif reveal_state == RevealableUtils.RevealStates.CONCEAL:
		reveal_amount -= delta * (1 / reveal_time)

	# do_reveal.emit(reveal_amount)
	reveal_material.set_shader_parameter("revealed_amount", reveal_amount)
	do_modulate(1.0 - reveal_amount)
	if reveal_amount > 1.0 or reveal_amount < 0.0:
		reveal_amount = round(reveal_amount)
		reveal_state = RevealableUtils.RevealStates.WAITING


func enable_processing(value: bool):
	if value:
		revealable_parent.process_mode = Node.PROCESS_MODE_INHERIT
	else:
		revealable_parent.process_mode = Node.PROCESS_MODE_DISABLED


func begin_reveal(_position: Vector2):
	reveal_state = RevealableUtils.RevealStates.REVEAL
	set_mask_screen_rect()
	reveal_material.set_shader_parameter("revealed_amount_target", 1.0)


func begin_conceal(_position: Vector2):
	reveal_state = RevealableUtils.RevealStates.CONCEAL
	reveal_material.set_shader_parameter("revealed_amount_target", 0.0)


func do_modulate(value: float):
	for t in modulate_targets:
		t.modulate.a = value


func setup_mask() -> void:
	mask_size = revealable_mask.get_rect().size


func get_camera_zoom():
	var vp := get_viewport()
	if !vp:
		return 1.0
	var cam = get_viewport().get_camera_2d()
	if !cam:
		return 1.0
	return cam.zoom


func set_mask_screen_rect() -> void:
	var offset = (mask_size / 2) * revealable_mask.scale * get_camera_zoom()
	#var rect_min = revealable_mask.get_global_transform_with_canvas().origin - offset
	#var rect_max = revealable_mask.get_global_transform_with_canvas().origin + offset

	var rect_min = revealable_mask.get_screen_transform().origin
	var rect_max = revealable_mask.get_screen_transform().origin
	if revealable_mask.centered:
		rect_min -= offset
		rect_max += offset
	else:
		rect_max += (offset * 2)
	RevealableUtils.set_bounds(
		reveal_group_depth, Vector4(rect_min.x, rect_min.y, rect_max.x, rect_max.y)
	)
