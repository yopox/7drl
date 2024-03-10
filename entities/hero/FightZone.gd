class_name FightZone extends Area2D

@onready var intent_timer: Timer = $IntentTimer
 
var terrain = 1
var terrain_intent = 0


func update_instance():
	if Util.bgm == null:
		return
	var enemies = get_overlapping_bodies()
	var has_elites = enemies.filter(
		func(e): return e is Enemy and e.stats != null and (e as Enemy).stats.elite
	).size() > 0
	var enemy_count = enemies.size()
	if enemy_count >= 1 and has_elites == false: 
		Util.bgm.set_parameter("EnterCombatTest", "InBattle", true)
	else:
		Util.bgm.set_parameter("EnterCombatTest", "InBattle", false)
		Util.bgm.set_parameter("EnterCombatTest", "OutBattle", true)
	if has_elites == true: 
		Util.bgm.set_parameter("EnterCombatTest", "OutBattle", false)
		Util.bgm.set_parameter("EnterCombatTest", "InBattle", false)
		Util.bgm.set_parameter("EnterCombatTest", "InBattleElite", true)


func update_music(hero_terrain):
	if hero_terrain == 3 and terrain != 3:
		terrain_intent = 3
		intent_timer.start()
	elif (hero_terrain == 1 or hero_terrain == 2) and terrain != 1:
		terrain_intent = 1
		intent_timer.start()


func _on_body_entered(_body):
	update_instance()


func _on_body_exited(_body):
	update_instance()


func _on_intent_timer_timeout():
	if Util.hero.terrain == terrain_intent or Util.hero.terrain == 2 and terrain_intent == 1:
		terrain = terrain_intent
		terrain_intent = 0
		match terrain:
			1:
				Util.bgm.play_lvl1()
			3:
				Util.bgm.play_lvl2()
