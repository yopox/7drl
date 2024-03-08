extends Node2D

@onready var tile_map = $Gui/CanvasLayer/TileMap
@onready var character_name: Counter = $Gui/CanvasLayer/Name
@onready var HP: Counter = $Gui/CanvasLayer/HP
@onready var ATK: Counter = $Gui/CanvasLayer/ATK
@onready var FRQ: Counter = $Gui/CanvasLayer/FRQ
@onready var SPD: Counter = $Gui/CanvasLayer/SPD
@onready var archer_stats = $Gui/CanvasLayer/Archer/Stats
@onready var fighter_stats = $Gui/CanvasLayer/Fighter/Stats
@onready var wizard_stats = $Gui/CanvasLayer/Wizard/Stats

var bullet = Vector2i(30, 15)
var hero_selected = 0
var select = true

signal confirm(hero: Hero.Class, stats: Stats)
signal cancel()

func _ready():
	update()


func _process(delta):
	if Input.is_action_just_pressed("right") or Input.is_action_just_pressed("attack_right"):
		Audio.play_sfx(Audio.SFX.Select)
		hero_selected += 1
		update()
	elif Input.is_action_just_pressed("left") or Input.is_action_just_pressed("attack_left"):
		Audio.play_sfx(Audio.SFX.Select)
		hero_selected -= 1
		update()
	
	if Input.is_action_just_pressed("up") or Input.is_action_just_pressed("down")\
		or Input.is_action_just_pressed("attack_up") or Input.is_action_just_pressed("attack_down"):
		Audio.play_sfx(Audio.SFX.Select)
		select = not select
		update()

	if Input.is_action_just_pressed("use_item"):
		if select:
			match hero_selected:
				0:
					confirm.emit(Hero.Class.Archer, archer_stats)
				1:
					confirm.emit(Hero.Class.Fighter, fighter_stats)
				2:
					confirm.emit(Hero.Class.Wizard, wizard_stats)
		else:
			Audio.play_sfx(Audio.SFX.Back)
			cancel.emit()

func update():
	hero_selected = posmod(hero_selected, 3)
	for x in range(3):
		var tile = bullet if x == hero_selected else Vector2i.ZERO
		tile_map.set_cell(0, Vector2i(7 + 6 * x, 18), 0, tile)
	
	for y in range(2):
		var tile = bullet if select == (y == 0) else Vector2i.ZERO
		tile_map.set_cell(0, Vector2i(28, 18 + y), 0, tile)
	
	var stats: Stats
	match hero_selected:
		0:
			stats = archer_stats
			character_name.text = "ARCHER "
		1:
			stats = fighter_stats
			character_name.text = "FIGHTER"
		2:
			stats = wizard_stats
			character_name.text = "WIZARD "
	HP.bar_progress = stats.HP * 1.0 / fighter_stats.HP
	HP.text = "HP   %02d" % stats.HP
	ATK.text = "ATK  %02d" % stats.ATK
	FRQ.text = "FRQ  %02d" % stats.FRQ
	SPD.text = "SPD  %02d" % stats.SPD
