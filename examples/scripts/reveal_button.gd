extends Button

@export var reveal_transition: RevealTransition

func _clicked():
    if reveal_transition.current == reveal_transition.from:
        self.visible = false
    else:
        self.text = "Enter"
    reveal_transition.do_reveal()
