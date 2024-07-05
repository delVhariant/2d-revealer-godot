class_name RevealableGroup extends Node2D

@export var revealable_parent: Sprite2D
@export var revealable_targets : Array[Sprite2D]
@export var group_mask: Sprite2D
@export_range(0.0, 1.0) var reveal_amount : float
@export_range(0, 10, 0.05) var reveal_time : float = 0.4
@export var reveal_state : RevealableUtils.RevealStates = RevealableUtils.RevealStates.WAITING
@export_range(0, 3) var reveal_group_depth : int = 0
@export var default_z_index: RevealableUtils.RevealableZIndexes = RevealableUtils.RevealableZIndexes.BEHIND
@export var revealed_z_index: RevealableUtils.RevealableZIndexes = RevealableUtils.RevealableZIndexes.IN_FRONT

signal do_reveal(value)
signal set_reveal_target(value)
signal set_revealer(value)
signal set_z_index(value)

var revealables : Array[Revealable]

var mask_rect : Rect2
var mask_size : Vector2
var reveal_material = preload("res://addons/revealer/materials/revealable.tres")

func _ready() -> void:
	if !revealable_parent:
		printerr("No revealable_parent assigned to RevealableGroup {0}".format([self.name]))
		process_mode = Node.PROCESS_MODE_DISABLED
		return
	if !group_mask:
		printerr("No group_mask assigned to RevealableGroup {0}".format([self.name]))
		process_mode = Node.PROCESS_MODE_DISABLED
		return
	populate_mask_details()
	setup_parent()
	#setup_group()
	for r in revealable_targets:
		r.use_parent_material = true

func setup_parent() -> void:
	setup_revealer(revealable_parent)

func setup_group() -> void:
	for r in revealable_targets:
		setup_revealer(r)

func setup_revealer(r: Sprite2D):
	var o = Revealable.new(r, reveal_material, reveal_group_depth, revealable_parent, group_mask)
	do_reveal.connect(o.reveal)
	set_reveal_target.connect(o.set_reveal_target)
	#set_revealer.connect(o.set_revealer_position)
	#set_z_index.connect(o.target.set_z_index)
	revealables.append(o)

func _process(delta: float) -> void:
	process_reveal(delta)

func process_reveal(delta: float) -> void:
	if reveal_amount > 0.0:
		set_mask_screen_rect()

	if reveal_state == RevealableUtils.RevealStates.WAITING:
		return

	if reveal_state == RevealableUtils.RevealStates.REVEAL:
		reveal_amount += delta * (1 / reveal_time)
	elif reveal_state == RevealableUtils.RevealStates.CONCEAL:
		reveal_amount -= delta * (1 / reveal_time)

	do_reveal.emit(reveal_amount)
	if reveal_amount > 1.0 or reveal_amount < 0.0:
		reveal_amount = round(reveal_amount)
		reveal_state = RevealableUtils.RevealStates.WAITING

func enable_processing(value: bool):
	if value:
		revealable_parent.process_mode = Node.PROCESS_MODE_INHERIT
	else:
		revealable_parent.process_mode = Node.PROCESS_MODE_DISABLED

func begin_reveal(position : Vector2):
	reveal_state = RevealableUtils.RevealStates.REVEAL
	set_mask_screen_rect()
	#set_revealer.emit(position)
	set_reveal_target.emit(1.0)
	#set_z_index.emit(default_z_index)

func begin_conceal(position : Vector2):
	reveal_state = RevealableUtils.RevealStates.CONCEAL
	#set_revealer.emit(position)
	set_reveal_target.emit(0.0)
	#set_z_index.emit(revealed_z_index)

func populate_mask_details() -> void:
	#mask_rect = group_mask.get_rect()
	mask_size = group_mask.get_rect().size
	mask_rect = Rect2(group_mask.global_position - (mask_size / 2), mask_size)

func set_mask_screen_rect() -> void:
	var zoom = get_viewport().get_camera_2d().zoom
	var offset = (mask_size / 2) * group_mask.scale * zoom
	#var rect_min = group_mask.get_global_transform_with_canvas().origin - offset
	#var rect_max = group_mask.get_global_transform_with_canvas().origin + offset

	var rect_min = group_mask.get_screen_transform().origin - offset
	var rect_max = group_mask.get_screen_transform().origin + offset
	%RevealableUtils.set_bounds(reveal_group_depth, Vector4(rect_min.x, rect_min.y, rect_max.x, rect_max.y))

