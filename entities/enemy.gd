class_name Enemy extends CharacterBody2D

@export var stats: Stats
@export var elite_emitter: GPUParticles2D
@export var can_be_elite: bool = true

signal hit(stats: Stats)
signal hit_player

var xp_ball = preload("res://entities/xp.tscn")
var item_drop = preload("res://items/item_drop.tscn")


func _ready():
	if can_be_elite and randi_range(0, 20) == 0:
		stats.elite = true
		elite_emitter.emitting = true


func process_enemy(_delta):
	pass


func die():
	# Spawn loot
	if stats.elite:
		var item = item_drop.instantiate()
		item.position = position
		add_sibling(item)
		item.randomize()
	
	# Spawn XP
	for _n in range(stats.LVL):
		var ball = xp_ball.instantiate()
		ball.position = position
		var angle = randf() * 2 * PI
		ball.apply_impulse(Vector2(cos(angle), sin(angle)))
		add_sibling(ball)
	
	on_dead()

func on_dead():
	queue_free()
