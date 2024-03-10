extends Node2D


func _on_area_2d_body_entered(_body):
	Util.enter_dungeon.emit()
