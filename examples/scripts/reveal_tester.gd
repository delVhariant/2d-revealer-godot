class_name Reveal_Tester extends Node2D
@export var test_reveal: bool = false
@export var revealable_group: RevealableGroup

func _process(_delta: float) -> void:
    if !revealable_group:
        return

    if test_reveal:
        test_reveal = false
        if revealable_group.reveal_amount <= 0:
            revealable_group.begin_reveal(self.global_position)
        else:
            revealable_group.begin_conceal(self.global_position)
