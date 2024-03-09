extends Node2D

@onready var stats: Stats = $Stats
@onready var zone: Area2D = $Area2D


func _process(delta):
	for body in zone.get_overlapping_bodies():
		if body.has_signal("hit"):
			body.hit.emit(stats)
