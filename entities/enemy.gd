class_name Enemy extends CharacterBody2D

signal hit(stats: Stats)


func die():
	# TODO: Spawn loot
	queue_free()
