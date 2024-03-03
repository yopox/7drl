extends CharacterBody2D

const SPEED = 10

func _physics_process(delta):
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * SPEED * delta * 200.0
	move_and_slide()
