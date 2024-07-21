class_name RevealableGroup extends Node2D

signal do_reveal(value)
signal do_conceal(value)
signal set_target(value)
signal set_reveal_depth(value)
signal set_conceal_depth(value)
signal set_revealer(value)
signal set_sampler(value)
signal set_z_index(value)

@export var processing_target: Node2D
@export var targets: Array[Sprite2D]
@export var reveal_targets: Array[Sprite2D]
@export var conceal_targets: Array[Sprite2D]
@export var modulate_targets: Array[Node2D]
@export var revealable_mask: Sprite2D
# @export var default_z_index := RevealableUtils.RevealableZIndexes.BEHIND
# @export var revealed_z_index := RevealableUtils.RevealableZIndexes.IN_FRONT
@export var reveal_state := RevealableUtils.RevealStates.WAITING
@export_range(0, 3) var reveal_group_depth: int = 0
@export_range(0.0, 1.0) var reveal_amount: float
@export_range(0, 10, 0.05) var reveal_time: float = 0.4

var mask_rect: Rect2
var mask_size: Vector2
var reveal_material_resource = preload("res://addons/revealer/materials/revealable.tres")
var reveal_material: ShaderMaterial


func _ready() -> void:
	if !revealable_mask:
		printerr("No revealable_mask assigned to RevealableGroup {0}".format([self.name]))
		process_mode = Node.PROCESS_MODE_DISABLED
		return
	# Clone the material
	setup_mask()
	setup_targets()
	setup_reveal_targets()
	setup_conceal_targets()
	do_reveal.emit(reveal_amount)
	do_conceal.emit(reveal_amount)


func setup_targets() -> void:
	for s in targets:
		var r = Revealable.new(s, reveal_material_resource, reveal_group_depth)
		setup_target(r)
		setup_revealer(r)
		setup_concealer(r)


func setup_reveal_targets() -> void:
	for s in reveal_targets:
		var r = Revealable.new(s, reveal_material_resource, reveal_group_depth)
		setup_target(r)
		setup_revealer(r)


func setup_conceal_targets() -> void:
	for s in conceal_targets:
		var r = Revealable.new(s, reveal_material_resource, reveal_group_depth)
		setup_target(r)
		setup_concealer(r)


func setup_target(r: Revealable):
	set_sampler.connect(r.set_sampler)
	set_target.connect(r.set_reveal_target)


func setup_revealer(r: Revealable):
	do_reveal.connect(r.reveal)
	set_reveal_depth.connect(r.set_reveal_depth)


func setup_concealer(r: Revealable):
	do_conceal.connect(r.reveal)
	set_conceal_depth.connect(r.set_reveal_depth)


func _process(delta: float) -> void:
	if reveal_amount > 0.0:
		set_mask_screen_rect()
	if reveal_state == RevealableUtils.RevealStates.WAITING:
		return

	if reveal_state == RevealableUtils.RevealStates.REVEAL:
		reveal_amount += delta * (1 / reveal_time)
		do_reveal.emit(reveal_amount)
	elif reveal_state == RevealableUtils.RevealStates.CONCEAL:
		reveal_amount -= delta * (1 / reveal_time)
		do_conceal.emit(reveal_amount)

	do_modulate(1.0 - reveal_amount)
	if reveal_amount > 1.0 or reveal_amount < 0.0:
		reveal_amount = round(reveal_amount)
		reveal_state = RevealableUtils.RevealStates.WAITING


func enable_processing(value: bool):
	if !processing_target:
		return
	if value:
		processing_target.process_mode = Node.PROCESS_MODE_INHERIT
	else:
		processing_target.process_mode = Node.PROCESS_MODE_DISABLED


func begin_reveal(_position: Vector2):
	print("Begin Reveal on {0}".format([self.name]))
	reveal_state = RevealableUtils.RevealStates.REVEAL
	set_mask_screen_rect()
	set_mask_and_depth(true)
	# reveal_material.set_shader_parameter("revealed_amount_target", 1.0)


func begin_conceal(_position: Vector2):
	print("Begin Conceal on {0}".format([self.name]))
	reveal_state = RevealableUtils.RevealStates.CONCEAL
	set_mask_screen_rect()
	set_mask_and_depth(false)
	# reveal_material.set_shader_parameter("revealed_amount_target", 0.0)


func do_modulate(value: float):
	for t in modulate_targets:
		t.modulate.a = value


func setup_mask() -> void:
	mask_size = revealable_mask.get_rect().size


func set_mask_and_depth(reveal: bool):
	set_sampler.emit(revealable_mask)
	if reveal:
		print("Set reveal Depth/Mask on {0}".format([self.name]))
		set_reveal_depth.emit(reveal_group_depth)
	else:
		print("Set conceal Depth/Mask on {0}".format([self.name]))
		set_conceal_depth.emit(reveal_group_depth)


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
