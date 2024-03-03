extends RigidBody2D

func _process(delta):
	var collisions = get_colliding_bodies()
	if collisions.size() > 0:
		queue_free()
