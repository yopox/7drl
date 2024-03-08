extends Node2D

@onready var title = $Title


func _on_title_exit_title():
	title.queue_free()
	add_child(load("res://scenes/states/level.tscn").instantiate())
