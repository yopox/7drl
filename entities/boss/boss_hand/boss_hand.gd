extends Enemy

@onready var sprite: Sprite2D = $Sprite2D

var pattern: Boss.Pattern = Boss.Pattern.NONE
var bomb := preload("res://attacks/throw_bomb.tscn")
var spike := preload("res://attacks/spike.tscn")
var is_dead = false


func process_enemy(_delta):
	if is_dead or Util.game_over:
		return
		
	match pattern:
		Boss.Pattern.BOMBS:
			stats.FRQ = 2
			shoot_bomb()
		Boss.Pattern.SHMUP:
			stats.FRQ = 6
			shoot_shmup()
		Boss.Pattern.MADNESS:
			stats.FRQ = 8
			shoot_madness()


func shoot_bomb():
	if stats.shoot():
		var alpha = (Util.hero.global_position - global_position).angle()
		var b: ThrowBomb = bomb.instantiate()
		get_parent().add_sibling(b)
		b.global_position = global_position + Vector2.from_angle(alpha) * 8
		b.apply_impulse(Vector2.from_angle(alpha) * 1.5 * (1.25 if not stats.elite else randf_range(0.75, 1.25)))


func shoot_shmup():
	if stats.shoot():
		var alpha = (Util.hero.global_position - global_position).angle()

		for i in range(3):
			var beta = alpha + PI / 6 * (i - 1)
			var s: Attack = spike.instantiate()
			s.stats = stats
			s.global_position = global_position + Vector2(cos(beta), sin(beta)) * 8
			s.rotation = beta
			s.apply_impulse(Vector2.from_angle(beta))
			get_parent().add_sibling(s)


func shoot_madness():
	if stats.shoot():
		var alpha = (Util.hero.global_position - global_position).angle()

		for i in [-1, 1]:
			var beta = alpha + PI / 8 * i
			var s: Attack = spike.instantiate()
			s.stats = stats
			s.global_position = global_position + Vector2(cos(beta), sin(beta)) * 8
			s.rotation = beta
			s.apply_impulse(Vector2.from_angle(beta))
			get_parent().add_sibling(s)


func on_dead():
	is_dead = true
	collision_layer = 0
	collision_mask = 0
	(sprite.material as ShaderMaterial).set_shader_parameter("tile_color", Vector4(0.322, 0.302, 0.302, 1.0))
