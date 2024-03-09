extends Enemy

@onready var zone: Area2D = $Area2D
@onready var decay: Timer = $Decay

var base_velocity: Vector2 = Vector2.ZERO
var bomb = preload("res://attacks/throw_bomb.tscn")


func process_enemy(delta):
	if zone.get_overlapping_bodies().size() > 0 and stats.shoot():
		var angle = (Util.hero.global_position - global_position).angle()
		var gamma = 2 * PI / 3
		
		# Send bombs
		for i in range(3):
			var alpha = angle + gamma * i
			var b: ThrowBomb = bomb.instantiate()
			add_sibling(b)
			b.bomb.body_ignored.append(self)
			b.position = position + Vector2.from_angle(alpha) * 8
			b.apply_impulse(Vector2.from_angle(alpha) * (1.25 if not stats.elite else randf_range(0.75, 1.25)))
		
		# Move towards the bomb
		base_velocity = Vector2.from_angle(angle + 2 * PI / 3 * randi_range(0, 2)) * stats.SPD * stats.SPD_SCALE
		decay.start()
	
	velocity = base_velocity * delta * (decay.time_left / 1.5) ** 2
	move_and_slide()
