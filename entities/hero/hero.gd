class_name Hero extends CharacterBody2D

@export var water_dmg: int

@onready var stats: Stats = $Stats
@onready var dash_manager: DashManager = $DashManager
@onready var dash_timer: Timer = $DashTimer
@onready var dash_particles: GPUParticles2D = $DashParticles
@onready var sprite: Sprite2D = $Sprite2D

var arrow = preload("res://attacks/arrow.tscn")

var dash = false
var dash_vel: Vector2
var dead = false
var terrain = 1: set = set_terrain

signal hit(stats: Stats)


func _ready():
	HeroUtil.hero = self


func _process(_delta):
	if dead:
		return
	
	check_terrain()
	water_damage()
	attack()


func _physics_process(delta):
	if dead:
		return
	var input_dir = Input.get_vector("left", "right", "up", "down")
	if dash:
		velocity = dash_vel
	else:
		velocity = input_dir * delta * stats.SPD * stats.SPD_SCALE
		
	if !dash and Input.is_action_just_pressed("dash") and dash_manager.dash():
		start_dash()
		velocity = dash_vel
	
	move_and_slide()


func set_terrain(value):
	terrain = value
	# TODO: update music


func check_terrain():
	var map = MapUtil.tile_map
	if map == null:
		return
	var cell_pos = map.local_to_map(global_position)
	if cell_pos == null:
		return
	var cell = map.get_cell_tile_data(0, cell_pos)
	if cell.terrain != terrain:
		terrain = cell.terrain


func water_damage():
	if terrain == 0:
		var water_stats = Stats.new()
		water_stats.ATK = water_dmg
		hit.emit(water_stats)


func attack():
	var attack_dir = Input.get_vector("attack_left", "attack_right", "attack_up", "attack_down")
	
	if abs(attack_dir.x) < 0.001 and abs(attack_dir.y) < 0.001:
		return
	
	if not stats.shoot():
		return
	
	var bullet: RigidBody2D = arrow.instantiate()
	bullet.stats = stats
	bullet.position.x = position.x + 8 * cos(attack_dir.angle())
	bullet.position.y = position.y + 8 * sin(attack_dir.angle())
	bullet.rotation = attack_dir.angle() - PI / 2.0
	bullet.apply_impulse(attack_dir)
	
	get_parent().add_child(bullet)


func start_dash():
	dash = true
	dash_timer.start()
	dash_particles.emitting = true
	collision_mask = 16
	dash_vel = velocity * 6


func _on_dash_timer_timeout():
	dash = false
	dash_particles.emitting = false
	collision_mask = 4 + 8 + 16


func _on_stats_dead():
	dead = true
	(sprite.material as ShaderMaterial).set_shader_parameter("tile_color", Vector4(0.114, 0.094, 0.094, 1))
	collision_layer = 16
