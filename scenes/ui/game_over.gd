class_name GameOver extends TileMap


func _process(_delta):
	if visible and Input.is_action_just_pressed("use_item"):
		Util.return_to_title.emit()
		
	if not visible and Util.game_over:
		visible = true
