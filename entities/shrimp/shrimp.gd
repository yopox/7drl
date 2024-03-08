extends Enemy

@onready var timer = $Timer
var attacking = false
var stopped = false
var hero: Hero = null
var bubble = preload("res://attacks/bubble.tscn")
var count = 0


func process_enemy(_delta):
	if attacking and not stopped and stats.shoot():
		shoot()


func shoot():
	count += 1
	if count == 3:
		timer.start()
		stopped = true
	var bullet: Attack = bubble.instantiate()
	var attack_dir = (hero.global_position - global_position).normalized()
	bullet.position.x = position.x + 10 * cos(attack_dir.angle())
	bullet.position.y = position.y + 10 * sin(attack_dir.angle())
	bullet.apply_impulse(attack_dir * 60)
	bullet.stats = stats
	
	add_sibling(bullet)


func _on_zone_body_entered(body):
	if not body is Hero:
		return
	attacking = true
	hero = body


func _on_zone_body_exited(body):
	if not body is Hero:
		return
	attacking = false


func _on_timer_timeout():
	count = 0	
	stopped = false
