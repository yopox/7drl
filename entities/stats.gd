class_name Stats extends Node

@export var HP: int = 20
@export var ATK: int = 5
@export var SPD: int = 10
@export var ATK_SPD: int = 5

# Compute movements by: normalized direction * delta * SPD * SPD_SCALE
var SPD_SCALE := 200.0

var CURRENT_HP: int = HP

@onready var timer: Timer = $Timer

func shoot() -> bool:
	if not timer.is_stopped():
		return false
		
	timer.start(5.0 / max(1.0, ATK_SPD))
	return true


func _on_hit(stats: Stats):
	CURRENT_HP -= stats.ATK
	if CURRENT_HP <= 0:
		get_parent().queue_free()