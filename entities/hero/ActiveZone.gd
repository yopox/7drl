extends Area2D

func _physics_process(delta):
	for body in get_overlapping_bodies():
		if body is Enemy:
			body.pre_process_enemy(delta)
