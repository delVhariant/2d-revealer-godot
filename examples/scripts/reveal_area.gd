class_name RevealArea extends Area2D

signal linked_b2f
signal linked_f2b

@export var group_in_front: RevealableGroup
@export var group_behind: RevealableGroup
@export var behind: bool = false
@export var auto: bool = false
@export var invert: bool = false
@export var b_to_f_skip_conceal: bool = false
@export var b_to_f_skip_reveal: bool = false
@export var f_to_b_skip_conceal: bool = false
@export var f_to_b_skip_reveal: bool = false

var active: bool = false
var current: RevealableGroup


func _ready() -> void:
	body_entered.connect(self._on_body_entered)
	body_exited.connect(self._on_body_exited)
	if behind:
		current = group_behind
	else:
		current = group_in_front


func _on_body_entered(body: Node2D):
	if not body is CharacterBody2D:
		return
	if auto:
		do_reveal()
		return

	if current == group_in_front:
		$Label.text = "Enter (f)"
	else:
		$Label.text = "Leave (f)"
	active = true
	$Label.show()


func _on_body_exited(body: Node2D):
	if not body is CharacterBody2D:
		return
	if auto:
		do_reveal()
		return

	active = false
	$Label.hide()


func _unhandled_input(event: InputEvent) -> void:
	if active and event.is_action_released("interact"):
		do_reveal()


func back_to_front():
	print("b2f called on {0}".format([self.name]))
	linked_b2f.emit()
	current = group_in_front
	if !invert:
		_reveal_front(true)
	else:
		_reveal_back(true)


func front_to_back():
	print("f2b called on {0}".format([self.name]))
	linked_f2b.emit()
	current = group_behind
	if !invert:
		_reveal_back(false)
	else:
		_reveal_front(false)


func _reveal_front(b_to_f: bool):
	var skip_reveal: bool = f_to_b_skip_reveal
	var skip_conceal: bool = f_to_b_skip_conceal
	if b_to_f:
		skip_reveal = b_to_f_skip_reveal
		skip_conceal = b_to_f_skip_conceal

	if not skip_reveal and group_in_front:
		group_in_front.begin_reveal(self.position)
	if not skip_conceal and group_behind:
		group_behind.begin_conceal(self.position)


func _reveal_back(b_to_f: bool):
	var skip_reveal: bool = f_to_b_skip_reveal
	var skip_conceal: bool = f_to_b_skip_conceal
	if b_to_f:
		skip_reveal = b_to_f_skip_reveal
		skip_conceal = b_to_f_skip_conceal
	if not skip_conceal and group_in_front:
		group_in_front.begin_conceal(self.position)
	if not skip_reveal and group_behind:
		group_behind.begin_reveal(self.position)


func do_reveal() -> void:
	if behind:  # go outside
		self.back_to_front()
	else:  # go behind
		self.front_to_back()
	behind = !behind
	if current == group_in_front:
		$Label.text = "Enter (f)"
	else:
		$Label.text = "Leave (f)"
