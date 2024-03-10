class_name Chrono extends Node

var started = false
var time: float = 0


func _process(delta):
	if started:
		if Util.game_over:
			started = false
			return
			
		time += delta


func start():
	time = 0
	started = true
