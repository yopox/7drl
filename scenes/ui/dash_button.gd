extends TouchScreenButton


func _on_pressed():
	Util.android_start = true
	if Util.gui == null:
		return
	Util.hero.use_item()
