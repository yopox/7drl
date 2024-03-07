class_name Hero extends CharacterBody2D

@export var water_dmg: int

@onready var stats: Stats = $Stats
@onready var dash_manager: DashManager = $DashManager
@onready var dash_timer: Timer = $DashTimer
@onready var dash_particles: GPUParticles2D = $DashParticles
@onready var sprite: Sprite2D = $Sprite2D

@export var lvlup_event: EventAsset
var lvlup_instance: EventInstance

var arrow = preload("res://attacks/arrow.tscn")

var dash = false
var dash_vel: Vector2
var dead = false
var terrain = 1: set = set_terrain

signal hit(stats: Stats)


func _ready():
	lvlup_instance = FMODRuntime.create_instance(lvlup_event)
	Util.hero = self


func _process(_delta):
	if dead:
		return
	
	check_terrain()
	water_damage()
	enemy_damage()
	attack()


func _physics_process(delta):
	if dead:
		return
		
	var input_dir = Input.get_vector("left", "right", "up", "down")
	if dash:
		velocity = dash_vel
	else:
		velocity = input_dir * delta * stats.SPD * stats.SPD_SCALE
		
	if !dash and Input.is_action_just_pressed("use_item"):
		match Util.gui.inventory.selected_item:
			Inventory.Item.Dash:
				if dash_manager.dash():
					start_dash()
					velocity = dash_vel
	
	move_and_slide()


func set_terrain(value):
	terrain = value
	# TODO: update music


func check_terrain():
	var map = Util.tile_map
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


func enemy_damage():
	for i in get_slide_collision_count():
		var body = get_slide_collision(i).get_collider()
		if body is Enemy:
			hit.emit((body as Enemy).stats)
			(body as Enemy).hit_player.emit()


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
	stats.invulnerable["dash"] = true
	dash_timer.start()
	dash_particles.emitting = true
	collision_mask = 16
	dash_vel = velocity * 6


func _on_dash_timer_timeout():
	dash = false
	stats.invulnerable["dash"] = false
	dash_particles.emitting = false
	collision_mask = 4 + 8 + 16


func _on_stats_dead():
	dead = true
	(sprite.material as ShaderMaterial).set_shader_parameter("tile_color", Vector4(0.114, 0.094, 0.094, 1))
	collision_layer = 16


func _on_stats_level_up():
	lvlup_instance.start()
	var gui = Util.gui
	if gui != null:
		match gui.stat_selected:
			0:
				stats.HP += 2
			1:
				stats.ATK += 1
			2:
				stats.FRQ += 1
			3:
				stats.SPD += 1
		stats.CURRENT_HP = min(stats.HP, stats.CURRENT_HP + stats.HP / 4)
		gui.update_gui()


func _on_stats_changed():
	var gui = Util.gui
	if gui != null:
		gui.update_gui()
