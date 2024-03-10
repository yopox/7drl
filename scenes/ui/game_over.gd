class_name GameOver extends TileMap


func _process(_delta):
	if visible and Input.is_action_just_pressed("use_item"):
		Util.return_to_title.emit()
	
	if not visible and Util.game_over:
		setup()
		visible = true

func setup():
	var m1 = "   YOU WON!  " if Util.boss_defeated else "   GAME OVER!   "
	for x in range(len(m1)):
		set_cell(0, Vector2i(x, 4), 0, Util.get_char_pos(m1, x))
	
	var c = ""
	match Util.hero.hero_class:
		Hero.Class.Archer:
			c = "   ARCHER,      "
		Hero.Class.Fighter:
			c = "   WARRIOR,     "
		Hero.Class.Wizard:
			c = "   WIZARD,      "
	
	for x in range(len(c)):
		set_cell(0, Vector2i(x, 6), 0, Util.get_char_pos(c, x))
	
	var m2 = "   THE JADE IS YOURS!" if Util.boss_defeated else "   YOU WERE DEFEATED."
	for x in range(len(m2)):
		set_cell(0, Vector2i(x, 7), 0, Util.get_char_pos(m2, x))
	
	var time = "       TIME: %02d:%02d:%02d " % [Util.chrono.time / 3600, Util.chrono.time / 60, ceil(fmod(Util.chrono.time, 60))]
	for x in range(len(time)):
		set_cell(0, Vector2i(x, 10), 0, Util.get_char_pos(time, x))
