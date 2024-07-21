class_name RevealTransition extends Area2D

signal reveal_started(reveal: bool)
signal conceal_started(reveal: bool)

enum TransitionType { EXIT, ENTRANCE, DYNAMIC }

const ENTER_TEXT = "Enter (f)"
const LEAVE_TEXT = "Leave (f)"

@export var reveal: Array[RevealLayer]
@export var conceal: Array[RevealLayer]
@export var revealed: bool = false
@export var type: TransitionType = TransitionType.DYNAMIC
@export var auto: bool = false
@export var linked: RevealTransition

var active: bool = false
var label: Label


func _ready() -> void:
	body_entered.connect(self._on_body_entered)
	body_exited.connect(self._on_body_exited)
	label = $Label
	if type == TransitionType.ENTRANCE:
		label.text = ENTER_TEXT
	elif type == TransitionType.EXIT:
		label.text = LEAVE_TEXT
	for l in reveal:
		reveal_started.connect(l.start_transition)
	for l in conceal:
		conceal_started.connect(l.start_transition)


func _on_body_entered(body: Node2D):
	if not body is CharacterBody2D:
		return
	if auto:
		do_transition()
		return

	_update_label_text()
	active = true
	label.show()


func _update_label_text():
	if type != TransitionType.DYNAMIC:
		return
	if !revealed:
		label.text = ENTER_TEXT
	else:
		label.text = LEAVE_TEXT


func _on_body_exited(body: Node2D):
	if not body is CharacterBody2D:
		return

	if auto:
		do_transition()
		return

	active = false
	label.hide()


func _unhandled_key_input(event: InputEvent) -> void:
	if active and event.is_action_pressed("interact"):
		do_transition()
		get_viewport().set_input_as_handled()


func do_transition():
	if revealed:
		reveal_started.emit(false)
		conceal_started.emit(true)
		revealed = false
	else:
		reveal_started.emit(true)
		conceal_started.emit(false)
		revealed = true

	if linked:
		linked.active = true
		linked.revealed = !revealed
	_update_label_text()
