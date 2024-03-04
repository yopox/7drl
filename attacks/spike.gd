extends RigidBody2D

var stats: Stats


func _on_lifetime_timeout():
	queue_free()
