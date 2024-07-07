class_name Reveal_Tester extends Node2D
@export var test_reveal: bool = false
@export var revealable_group: RevealableGroup

func _process(delta: float) -> void:
	if !revealable_group:
		return

	if revealable_group.reveal_state != RevealableUtils.RevealStates.WAITING:
		revealable_group.process_reveal(delta)
	elif test_reveal:
		test_reveal = false
		if revealable_group.reveal_amount <= 0:
			revealable_group.begin_reveal(self.global_position)
		else:
			revealable_group.begin_conceal(self.global_position)
