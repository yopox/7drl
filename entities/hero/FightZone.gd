extends Area2D
@export var event: EventAsset
var instance: EventInstance

func _ready():
	instance = FMODRuntime.create_instance(event)
	instance.start()
	instance.set_parameter_by_name_with_label("EnterCombatTest", "InBattle", false)


func update_instance():
	var enemies = get_overlapping_bodies()
	var has_elites = enemies.filter(func(e): return e is Enemy and (e as Enemy).stats.elite).size() > 0
	var enemy_count = enemies.size()
	if enemy_count >= 1 and has_elites == false: 
		instance.set_parameter_by_name_with_label("EnterCombatTest", "InBattle", true)
	else:
		instance.set_parameter_by_name_with_label("EnterCombatTest", "InBattle", false)
		instance.set_parameter_by_name_with_label("EnterCombatTest", "OutBattle", true)
	if has_elites == true: 
		instance.set_parameter_by_name_with_label("EnterCombatTest", "OutBattle", false)
		instance.set_parameter_by_name_with_label("EnterCombatTest", "InBattle", false)
		instance.set_parameter_by_name_with_label("EnterCombatTest", "InBattleElite", true)



func _on_body_entered(_body):
	update_instance()


func _on_body_exited(_body):
	update_instance()
