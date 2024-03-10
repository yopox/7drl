class_name Bear extends Enemy

@onready var decay: Timer = $Decay 
@onready var area: Area2D = $Area2D 

var rushing = false
var base_velocity: Vector2 = Vector2.ZERO
var bomb = false
var bear_bomb = preload("res://entities/bear/bear_bomb.tscn")


func process_enemy(delta):
	if area.get_overlapping_bodies().size() > 0 and not rushing and not bomb:
		if not Util.dungeon and Util.hero.terrain == 1:
			return
		rushing = true
		decay.start()
		var angle = (Util.hero.global_position - global_position).angle()
		base_velocity = Vector2.from_angle(angle) * stats.SPD * stats.SPD_SCALE
	
	if rushing:
		velocity = base_velocity * delta * (decay.time_left / 1.5) ** 0.5
		if decay.time_left < 0.5 and not bomb:
			bomb = true
			var b: Bomb = bear_bomb.instantiate()
			add_child(b)
			b.detonated.connect(detonated)
			b.damage = stats.ATK
			b.body_ignored.append(self)
		if decay.time_left < 0.01:
			rushing = false
	else:
		velocity = Vector2.ZERO
	
	move_and_slide()


func detonated():
	bomb = false
