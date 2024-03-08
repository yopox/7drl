extends TouchScreenButton


func _on_pressed():
	Util.android_select2 = true
	if Util.gui == null:
		return
	Util.gui.select_stat()
