class_name RevealArea extends Area2D

@export var leaves: RevealableGroup
@export var enters: RevealableGroup
@export var inside: bool = false
@export var auto: bool = false

var active: bool = false


func _ready() -> void:
	body_entered.connect(self._on_body_entered)
	body_exited.connect(self._on_body_exited)


func _on_body_entered(_body: Node2D):
	active = true
	$Sprite2D.show()


func _on_body_exited(_body: Node2D):
	if auto:
		do_reveal()
	else:
		active = false
	$Sprite2D.hide()


func _unhandled_input(event: InputEvent) -> void:
	if active and event.is_action_released("interact"):
		do_reveal()


func do_reveal() -> void:
	if inside:
		leaves.begin_reveal(self.global_position)
		leaves.enable_processing(false)
		enters.enable_processing(true)
	else:
		leaves.begin_conceal(self.position)
		leaves.enable_processing(true)
		enters.enable_processing(false)
	inside = !inside
