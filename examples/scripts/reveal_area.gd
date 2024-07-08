extends Area2D

@export var from: RevealableGroup
@export var to:  RevealableGroup
@export var current: RevealableGroup

var active: bool = false

func _ready() -> void:
	body_entered.connect(self._on_body_entered)
	body_exited.connect(self._on_body_exited)
	if !current:
		current = from

func _on_body_entered(_body: Node2D):
	active = true
	$Sprite2D.show()

func _on_body_exited(_body: Node2D):
	active = false
	$Sprite2D.hide()

func _unhandled_input(event: InputEvent) -> void:
	if active and event.is_action_released("interact"):
		do_reveal()

func do_reveal() -> void:
	if from == current:
		from.begin_reveal(self.global_position)
		from.enable_processing(false)
		to.enable_processing(true)
		current = to
	else:
		from.begin_conceal(self.position)
		from.enable_processing(true)
		to.enable_processing(false)
		current = from

