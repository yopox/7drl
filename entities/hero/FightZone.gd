extends Area2D
@export var event: EventAsset
var instance: EventInstance

func _ready():
	instance = FMODRuntime.create_instance(event)
	instance.start()
	instance.set_parameter_by_name_with_label("EnterCombatTest", "InBattle", false)


func _process(delta):
	var enemies = get_overlapping_bodies()
	var enemy_count = enemies.size()
	if enemy_count >= 1: 
		instance.set_parameter_by_name_with_label("EnterCombatTest", "InBattle", true)
	else:
		instance.set_parameter_by_name_with_label("EnterCombatTest", "InBattle", false)
		instance.set_parameter_by_name_with_label("EnterCombatTest", "OutBattle", true)
