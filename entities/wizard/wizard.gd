extends Enemy

@onready var area: Area2D = $Area2D
@onready var decay: Timer = $Decay
@export var cast_event: EventAsset
var cast_sfx: EventInstance

var base_velocity: Vector2 = Vector2.ZERO

func _ready():
	cast_sfx = FMODRuntime.create_instance(cast_event)
	
	
func process_enemy(delta):
	if area.get_overlapping_bodies().size() > 0 and stats.shoot():
		var angle = (Util.hero.global_position - global_position).angle()
		
		# Spawn fireball
		var f = load("res://attacks/fireball.tscn").instantiate()
		cast_sfx.start()
		f.stats = stats
		f.position.x = position.x + 8 * cos(angle)
		f.position.y = position.y + 8 * sin(angle)
		f.apply_impulse(Vector2.from_angle(angle) * stats.SPD / 10.0)
		add_sibling(f)
		
		# Recoil
		base_velocity = Vector2.from_angle(angle + PI) * stats.SPD * stats.SPD_SCALE
		decay.start()
	
	velocity = base_velocity * (decay.time_left / 0.75) ** 2 * delta
	move_and_slide()
