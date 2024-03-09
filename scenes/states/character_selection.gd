extends Node2D

@onready var tile_map = $Gui/CanvasLayer/TileMap
@onready var character_name: Counter = $Gui/CanvasLayer/Name
@onready var HP: Counter = $Gui/CanvasLayer/HP
@onready var ATK: Counter = $Gui/CanvasLayer/ATK
@onready var FRQ: Counter = $Gui/CanvasLayer/FRQ
@onready var SPD: Counter = $Gui/CanvasLayer/SPD
@onready var archer = $Gui/CanvasLayer/Archer
@onready var archer_stats = $Gui/CanvasLayer/Archer/Stats
@onready var fighter = $Gui/CanvasLayer/Fighter
@onready var fighter_stats = $Gui/CanvasLayer/Fighter/Stats
@onready var wizard = $Gui/CanvasLayer/Wizard
@onready var wizard_stats = $Gui/CanvasLayer/Wizard/Stats

var arrow = preload("res://attacks/arrow.tscn")
var sword = preload("res://attacks/sword.tscn")
var wiz_zone = preload("res://attacks/wiz_zone.tscn")

var bullet = Vector2i(30, 15)
var hero_selected = 0
var select = true

signal confirm(hero: Hero.Class, stats: Stats)
signal cancel()

func _ready():
	update()


func _process(delta):
	match hero_selected:
		0:
			if archer_stats.shoot():
				launch_arrow()
		1:
			if fighter_stats.shoot():
				use_sword()
		2:
			if wizard_stats.shoot():
				launch_zone()
	
	if Input.is_action_just_pressed("right") or Input.is_action_just_pressed("attack_right") or Util.android_select1:
		Util.android_select1 = false
		Audio.play_sfx(Audio.SFX.Select)
		hero_selected += 1
		update()
	elif Input.is_action_just_pressed("left") or Input.is_action_just_pressed("attack_left"):
		Audio.play_sfx(Audio.SFX.Select)
		hero_selected -= 1
		update()
	
	if Input.is_action_just_pressed("up") or Input.is_action_just_pressed("down")\
		or Input.is_action_just_pressed("attack_up") or Input.is_action_just_pressed("attack_down")\
		or Util.android_select2:
		Util.android_select2 = false
		Audio.play_sfx(Audio.SFX.Select)
		select = not select
		update()

	if Input.is_action_just_pressed("use_item") or Util.android_start:
		Util.android_start = false
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
		tile_map.set_cell(0, Vector2i(7 + 6 * x, 19), 0, tile)
	
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
			character_name.text = "WARRIOR"
		2:
			stats = wizard_stats
			character_name.text = "WIZARD "
	HP.bar_progress = stats.HP * 1.0 / fighter_stats.HP
	HP.text = "HP   %02d" % stats.HP
	ATK.text = "ATK  %02d" % stats.ATK
	FRQ.text = "FRQ  %02d" % stats.FRQ
	SPD.text = "SPD  %02d" % stats.SPD


func launch_arrow():
	var bullet: RigidBody2D = arrow.instantiate()
	bullet.stats = archer_stats
	bullet.position.x = archer.position.x + 8 * cos(-PI / 2)
	bullet.position.y = archer.position.y + 8 * sin(-PI / 2)
	bullet.rotation = 0
	bullet.apply_impulse(Vector2.from_angle(-PI / 2) * archer_stats.SPD / 10.0)
	archer.add_sibling(bullet)


func use_sword():
	var sword_body = sword.instantiate()
	sword_body.stats = fighter_stats
	sword_body.rotation = -PI / 2
	fighter.add_child(sword_body)


func launch_zone():
	var zone: WizZone = wiz_zone.instantiate()
	zone.stats = wizard_stats
	zone.position = wizard.position
	zone.apply_impulse(Vector2(0, -1) * wizard_stats.SPD / 10.0)
	wizard.add_sibling(zone)
