extends TouchScreenButton


func _on_pressed():
	Util.android_select1 = true
	if Util.gui == null:
		return
	Util.gui.inventory.select_item()
