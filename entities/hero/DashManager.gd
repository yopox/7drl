class_name DashManager extends Node

@onready var timer: Timer = $Timer

@export var max_dashes = 1
var dashes = max_dashes

func dash() -> bool:
	if dashes <= 0:
		return false
	dashes -= 1
	timer.start()
	return true


func _on_timer_timeout():
	if dashes < max_dashes:
		dashes += 1
	if dashes < max_dashes:
		timer.start()
