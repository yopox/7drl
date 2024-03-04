extends Enemy

@onready var stats: Stats = $Stats
@onready var zone: Area2D = $Zone

var following: bool = false
var hero: Hero = null


func _physics_process(delta):
	if stats.invulnerable:
		velocity = Vector2.ZERO
	elif following and hero != null:
		var direction = (hero.position - position).normalized()
		#print(direction * delta * stats.SPD * stats.SPD_SCALE)
		velocity = direction * delta * stats.SPD * stats.SPD_SCALE
	else:
		velocity = Vector2.ZERO
	
	move_and_slide()


func _on_zone_body_entered(body):
	if not body is Hero:
		return
	following = true
	hero = body


func _on_zone_body_exited(body):
	if !body is Hero:
		return
	following = false
