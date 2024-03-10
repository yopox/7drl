class_name Hero extends CharacterBody2D

enum Class { Archer, Fighter, Wizard }

@export var water_dmg: int

@onready var stats: Stats = $Stats
@onready var dash_manager: DashManager = $DashManager
@onready var dash_timer: Timer = $DashTimer
@onready var dash_particles: GPUParticles2D = $DashParticles
@onready var sprite: Sprite2D = $Sprite2D
@onready var fight_zone: FightZone = $FightZone

@export var lvlup_event: EventAsset
var lvlup_instance: EventInstance

var arrow = preload("res://attacks/arrow.tscn")
var sword = preload("res://attacks/sword.tscn")
var wiz_zone = preload("res://attacks/wiz_zone.tscn")

var hero_class: Class = Class.Archer
var alive_color = Vector4(0.953, 0.953, 0.953, 1)
var death_color = Vector4(0.114, 0.094, 0.094, 1)
var dash = false
var dash_vel: Vector2
var dead = false
var terrain = 1: set = set_terrain
var just_init = true

signal hit(stats: Stats)


func _ready():
	lvlup_instance = FMODRuntime.create_instance(lvlup_event)
	(sprite.material as ShaderMaterial).set_shader_parameter("tile_color", alive_color)
	update_stuff()


func update_stuff():
	match hero_class:
		Class.Archer:
			dash_manager.timer.wait_time = 3
			(sprite.texture as AtlasTexture).region.position = Vector2(0, 224)
		Class.Fighter:
			dash_manager.timer.wait_time = 1.5			
			(sprite.texture as AtlasTexture).region.position = Vector2(224, 240)
		Class.Wizard:
			dash_manager.timer.wait_time = 3			
			(sprite.texture as AtlasTexture).region.position = Vector2(128, 240)
	Util.hero = self


func _process(_delta):
	if Util.game_over:
		return
	
	check_terrain()
	water_damage()
	attack()
	
	if just_init:
		just_init = false
	elif Input.is_action_just_pressed("use_item"):
		use_item()


func _physics_process(delta):
	if Util.game_over:
		return
	
	var input_dir = Input.get_vector("left", "right", "up", "down") + Util.move_vector
	if input_dir.length() < 0.2:
		input_dir = Vector2.ZERO
	else:
		input_dir = input_dir.normalized()
	if dash:
		velocity = dash_vel
	else:
		velocity = input_dir * delta * stats.SPD * stats.SPD_SCALE
	
	move_and_slide()
	enemy_damage()


func use_item():
	if Util.gui.inventory.selected_item == Inventory.Item.Dash:
		if !dash and dash_manager.dash():
			start_dash()
			velocity = dash_vel
	Util.gui.inventory.item_used()


func set_terrain(value):
	terrain = value
	fight_zone.update_music(terrain)


func check_terrain():
	var map = Util.tile_map
	if map == null:
		return
	var cell_pos = map.local_to_map(global_position)
	if cell_pos == null:
		return
	var cell = map.get_cell_tile_data(0, cell_pos)
	if cell != null and cell.terrain != terrain:
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
	if attack_dir.length() < 0.1:
		attack_dir = Util.attack_vector
	
	if abs(attack_dir.x) < 0.001 and abs(attack_dir.y) < 0.001:
		return
	
	if not stats.shoot():
		return
	
	match hero_class:
		Class.Archer:
			launch_arrow(attack_dir)
		Class.Fighter:
			use_sword(attack_dir)
		Class.Wizard:
			launch_zone(attack_dir)


func launch_arrow(attack_dir: Vector2):
	var bullet: RigidBody2D = arrow.instantiate()
	bullet.stats = stats
	
	var angle = attack_dir.angle()
	var enemies_in_zone = fight_zone.get_overlapping_bodies()\
		.filter(func(e): return e is Enemy)
	
	var closest = [20000, 0]
	for body in enemies_in_zone:
		var diff = body.global_position - global_position
		var beta = diff.angle()
		if abs(angle - beta) < PI / 4 or abs(angle - beta - 2 * PI) < PI / 4:
			var dist = diff.length_squared()
			if dist < closest[0]:
				closest = [dist, beta]
	
	if closest[0] < 19999:
		angle = closest[1]
	
	bullet.position.x = position.x + 8 * cos(angle)
	bullet.position.y = position.y + 8 * sin(angle)
	bullet.rotation = angle - PI / 2.0
	bullet.apply_impulse(Vector2.from_angle(angle) * stats.SPD / 10.0)
	add_sibling(bullet)


func use_sword(attack_dir: Vector2):
	var sword_body = sword.instantiate()
	sword_body.stats = stats
	sword_body.rotation = attack_dir.angle()
	add_child(sword_body)


func launch_zone(attack_dir: Vector2):
	var zone: WizZone = wiz_zone.instantiate()
	zone.stats = stats
	zone.position.x = position.x
	zone.position.y = position.y
	zone.apply_impulse(attack_dir.normalized() * stats.SPD / 10.0)
	add_sibling(zone)


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
	Util.game_over = true
	(sprite.material as ShaderMaterial).set_shader_parameter("tile_color", death_color)
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
		
		
