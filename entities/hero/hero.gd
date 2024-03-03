extends CharacterBody2D

@onready var shoot_timer: Timer = $ShootTimer
@onready var stats: Stats = $Stats

var arrow = preload("res://attacks/arrow.tscn")

func _process(delta):
	attack()

func _physics_process(delta):
	var input_dir = Input.get_vector("left", "right", "up", "down")
	velocity = input_dir * stats.SPD * delta * 200.0
	move_and_slide()

func attack():
	if shoot_timer.time_left > 0.05:
		return
	
	var attack_dir = Input.get_vector("attack_left", "attack_right", "attack_up", "attack_down")
	
	if abs(attack_dir.x) < 0.001 and abs(attack_dir.y) < 0.001:
		return
	
	shoot_timer.start()
	
	var bullet: RigidBody2D = arrow.instantiate()
	bullet.position.x = position.x + 10 * cos(attack_dir.angle())
	bullet.position.y = position.y + 10 * sin(attack_dir.angle())
	bullet.rotation = attack_dir.angle() - PI / 2.0
	bullet.apply_impulse(attack_dir)
	
	get_parent().add_child(bullet)
