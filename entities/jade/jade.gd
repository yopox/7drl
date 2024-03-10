extends Node2D


func _ready():
	Util.exit = global_position

func _on_area_2d_body_entered(body):
	Util.enter_boss.emit()
