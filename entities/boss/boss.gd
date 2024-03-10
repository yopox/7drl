class_name Boss extends Node2D

enum Pattern { NONE, CRY_LEFT, CRY_RIGHT, ELITE, BOMBS, SHMUP, MADNESS }

@onready var l_eye = $BossEye
@onready var r_eye = $BossEye2
@onready var l_hand = $BossHand
@onready var r_hand = $BossHand2

var base_pos: Vector2
var time: float = 0.0
var hp_sum: float

var patterns := [Pattern.NONE, Pattern.CRY_LEFT, Pattern.CRY_RIGHT, Pattern.BOMBS, Pattern.SHMUP, Pattern.MADNESS]
var phase_one = true


func _ready():
	base_pos = position
	l_eye.is_left = true
	for e in [l_eye, r_eye, l_hand, r_hand]:
		hp_sum += e.stats.CURRENT_HP


func _process(delta):
	time += delta
	
	if phase_one:
		var hp = 0
		for e in [l_eye, r_eye, l_hand, r_hand]:
			hp += e.stats.CURRENT_HP
		if hp <= hp_sum / 2:
			phase_one = false
			for enemy: Enemy in [l_eye, r_eye, l_hand, r_hand]:
				enemy.stats.elite = true
				enemy.elite_emitter.emitting = true
	
	position = base_pos + Vector2(0, sin(time * 2) * 4)
	

func _on_timer_timeout():
	var pattern = patterns.pick_random()
	for enemy in [l_eye, r_eye, l_hand, r_hand]:
		enemy.pattern = pattern


func spawn_elite():
	pass
