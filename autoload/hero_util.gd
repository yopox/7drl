extends Node

var hero: Hero = null: set = set_hero
var gui: GUI = null: set = set_gui


func set_hero(value):
	hero = value
	if gui != null:
		gui.update_gui()


func set_gui(value):
	gui = value
	if hero != null:
		gui.update_gui()
