extends Enemy

@onready var sprite: Sprite2D = $Sprite2D

var pattern: Boss.Pattern = Boss.Pattern.NONE
var is_left: bool = false
var is_dead = false
var bubble := preload("res://attacks/bubble.tscn")

func process_enemy(_delta):
	if is_dead or Util.game_over:
		return
	
	match pattern:
		Boss.Pattern.CRY_LEFT:
			if not is_left:
				return
			stats.FRQ = 14
			shoot_cry()
		Boss.Pattern.CRY_RIGHT:
			if is_left:
				return
			stats.FRQ = 14
			shoot_cry()
		Boss.Pattern.MADNESS:
			stats.FRQ = 6
			shoot_madness()


func shoot_cry():
	if stats.shoot():
		var alpha = (Util.hero.global_position - global_position).angle()
		var b = bubble.instantiate()
		var dir = Vector2.from_angle(alpha)
		b.stats = stats
		b.global_position = global_position + dir * 10
		b.apply_impulse(dir * 90)
		get_parent().add_sibling(b)


func shoot_madness():
	if stats.shoot():
		var alpha = (Util.hero.global_position - global_position).angle()
		alpha += randf_range(-PI / 8, 0) * (1.0 if is_left else -1.0)
		var b = bubble.instantiate()
		var dir = Vector2.from_angle(alpha)
		b.stats = stats
		b.global_position = global_position + dir * 10
		b.apply_impulse(dir * 90)
		get_parent().add_sibling(b)


func on_dead():
	is_dead = true
	collision_layer = 0
	collision_mask = 0
	(sprite.material as ShaderMaterial).set_shader_parameter("tile_color", Vector4(0.322, 0.302, 0.302, 1.0))
