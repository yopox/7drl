class_name WizZone extends RigidBody2D

@onready var zone: Area2D = $Area2D
var stats: Stats


func collide():
	for body in zone.get_overlapping_bodies():
		if body.has_signal("hit"):
			body.hit.emit(stats)
