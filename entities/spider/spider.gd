extends Enemy

@onready var zone: Area2D = $Area2D

var sting = preload("res://attacks/sting.tscn")
var move = false


func process_enemy(delta):
	if move:
		move = false
		var angle = randf() * 2 * PI
		var dest = Util.tile_map.local_to_map(global_position + Vector2.from_angle(angle) * 16)
		if Util.tile_map.get_cell_tile_data(0, dest).terrain == 2:
			velocity = Vector2.from_angle(angle) * delta * stats.SPD * stats.SPD_SCALE

	if zone.get_overlapping_bodies().size() > 0:
		if Util.hero.terrain == 2:
			var hero_diff := Util.hero.global_position - global_position
			var dist = hero_diff.length()
			if dist > 48 and stats.shoot():
				shoot(hero_diff)

	velocity *= 0.95
	move_and_slide()


func _on_timer_timeout():
	move = true


func shoot(hero_diff: Vector2):
	var angle = hero_diff.angle() - PI / 8
	
	for i in range(3):
		var beta = angle + PI / 8 * i
		var s: RigidBody2D = sting.instantiate()
		s.stats = stats
		s.position.x = position.x + 8 * cos(beta)
		s.position.y = position.y + 8 * sin(beta)
		s.rotation = beta
		s.apply_impulse(Vector2.from_angle(beta) * stats.SPD / 10.0)
		add_sibling(s)
