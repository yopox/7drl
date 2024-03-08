class_name FightZone extends Area2D

@export var event_lvl1: EventAsset
@export var event_lvl2: EventAsset

var instance_lvl1: EventInstance
var instance_lvl2: EventInstance
 
var terrain = 1

func _ready():
	instance_lvl1 = FMODRuntime.create_instance(event_lvl1)
	instance_lvl1.start()
	instance_lvl2 = FMODRuntime.create_instance(event_lvl2)


func update_instance():
	var enemies = get_overlapping_bodies()
	var has_elites = enemies.filter(func(e): return e is Enemy and (e as Enemy).stats.elite).size() > 0
	var enemy_count = enemies.size()
	if enemy_count >= 1 and has_elites == false: 
		instance_lvl1.set_parameter_by_name_with_label("EnterCombatTest", "InBattle", true)
		instance_lvl2.set_parameter_by_name_with_label("EnterCombatTest", "InBattle", true)
	else:
		instance_lvl1.set_parameter_by_name_with_label("EnterCombatTest", "InBattle", false)
		instance_lvl1.set_parameter_by_name_with_label("EnterCombatTest", "OutBattle", true)
		instance_lvl2.set_parameter_by_name_with_label("EnterCombatTest", "InBattle", false)
		instance_lvl2.set_parameter_by_name_with_label("EnterCombatTest", "OutBattle", true)
	if has_elites == true: 
		instance_lvl1.set_parameter_by_name_with_label("EnterCombatTest", "OutBattle", false)
		instance_lvl1.set_parameter_by_name_with_label("EnterCombatTest", "InBattle", false)
		instance_lvl1.set_parameter_by_name_with_label("EnterCombatTest", "InBattleElite", true)
		instance_lvl2.set_parameter_by_name_with_label("EnterCombatTest", "OutBattle", false)
		instance_lvl2.set_parameter_by_name_with_label("EnterCombatTest", "InBattle", false)
		instance_lvl2.set_parameter_by_name_with_label("EnterCombatTest", "InBattleElite", true)


func update_music(hero_terrain):
	if hero_terrain == 2 and terrain != 2:
		terrain = 2
		instance_lvl1.stop(0)
		instance_lvl2.start()
	elif hero_terrain == 1 and terrain != 1:
		terrain = 1
		instance_lvl2.stop(0)
		instance_lvl1.start()

func _on_body_entered(_body):
	update_instance()


func _on_body_exited(_body):
	update_instance()
