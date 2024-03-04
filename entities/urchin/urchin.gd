extends Enemy

@onready var stats: Stats = $Stats
@onready var spikes_timer: Timer = $SpikesTimer

var spike = preload("res://attacks/spike.tscn")


func _ready():
	hit.connect(counter_attack)


func counter_attack(_stats):
	spikes_timer.start()


func _on_spikes_timer_timeout():
	var hero = HeroUtil.hero
	if hero == null:
		return
	
	var angle = (hero.position - position).angle()
	
	for i in range(8):
		var bullet: RigidBody2D = spike.instantiate()
		bullet.stats = stats
		bullet.position.x = position.x + 6 * cos(angle)
		bullet.position.y = position.y + 6 * sin(angle)
		bullet.rotation = angle
		bullet.apply_impulse(Vector2(cos(angle), sin(angle)))
		
		get_parent().add_child(bullet)
		angle += PI / 4
