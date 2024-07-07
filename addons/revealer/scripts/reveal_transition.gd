class_name RevealTransition extends Node2D

@export var from: RevealableGroup
@export var to: RevealableGroup
@export var current: RevealableGroup


func _process(delta: float) -> void:
	if current.reveal_state != RevealableUtils.RevealStates.WAITING:
		current.process_reveal(delta)


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
