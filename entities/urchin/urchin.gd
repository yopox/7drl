extends Enemy

@onready var spikes_timer: Timer = $SpikesTimer

var spike = preload("res://attacks/spike.tscn")


func counter_attack():
	spikes_timer.start()


func _on_spikes_timer_timeout():
	var hero = Util.hero
	if hero == null:
		return
	
	var angle = (hero.position - position).angle()
	
	for i in range(8):
		var bullet: RigidBody2D = spike.instantiate()
		bullet.stats = stats
		bullet.position.x = position.x + 8 * cos(angle)
		bullet.position.y = position.y + 8 * sin(angle)
		bullet.rotation = angle
		bullet.apply_impulse(Vector2(cos(angle), sin(angle)))
		
		get_parent().add_child(bullet)
		angle += PI / 4
