extends Enemy

@onready var spikes_timer: Timer = $SpikesTimer

var spike = preload("res://attacks/spike.tscn")


func counter_attack():
	spikes_timer.start()


func _on_spikes_timer_timeout():
	var hero = Util.hero
	if stats == null or hero == null:
		return
	
	var angle = (hero.global_position - global_position).angle()
	
	for i in range(8 if not stats.elite else 16):
		var bullet: RigidBody2D = spike.instantiate()
		bullet.stats = stats
		bullet.position.x = position.x + 8 * cos(angle)
		bullet.position.y = position.y + 8 * sin(angle)
		bullet.rotation = angle
		bullet.apply_impulse(Vector2(cos(angle), sin(angle)))
		
		add_sibling(bullet)
		angle += PI / (4 if not stats.elite else 8)
