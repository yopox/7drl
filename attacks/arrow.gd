extends RigidBody2D

func _process(_delta):
	var collisions = get_colliding_bodies()
	if collisions.size() > 0:
		queue_free()
