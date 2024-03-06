class_name Enemy extends CharacterBody2D

@export var stats: Stats

signal hit(stats: Stats)

var xp_ball = preload("res://entities/xp.tscn")


func process_enemy(delta):
	pass


func die():
	# Spawn loot
	for _n in range(stats.LVL):
		var ball = xp_ball.instantiate()
		ball.position.x = position.x
		ball.position.y = position.y
		var angle = randf() * 2 * PI
		ball.apply_impulse(Vector2(cos(angle), sin(angle)))
		get_parent().add_child(ball)
		
	queue_free()
