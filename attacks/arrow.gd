extends RigidBody2D

var stats: Stats

func _process(_delta):
	var collisions = get_colliding_bodies()
	
	for body in collisions:
		if body is Enemy:
			body.hit.emit(stats)
	
	if collisions.size() > 0:
		queue_free()
