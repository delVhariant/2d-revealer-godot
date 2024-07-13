extends CharacterBody2D

const GRAVITY = 200.0
@export var speed: float = 600


func get_input():
	var input_dir = Input.get_axis("move_left", "move_right")
	velocity.x = input_dir * speed
	if velocity.x != 0:
		if input_dir > 0:
			$AnimatedSprite2D.flip_h = false
		else:
			$AnimatedSprite2D.flip_h = true

		$AnimatedSprite2D.play("walk")
	else:
		$AnimatedSprite2D.play("default")


func _process(delta):
	get_input()
	velocity.y += GRAVITY * delta
	move_and_slide()
