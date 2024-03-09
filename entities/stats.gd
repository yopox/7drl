class_name Stats extends Node

@export_category("Character Stats")
@export var LVL: int = 1: get = get_lvl
@export var HP: int = 20: get = get_hp
@export var ATK: int = 5: get = get_atk
@export var FRQ: int = 5: get = get_frq
@export var SPD: int = 10: get = get_spd
@export var elite: bool = false
var XP: int = 0


@export_category("Nodes")

var CURRENT_HP: int = HP
@export var sprite: Sprite2D

@export_category("SFX")

@export var hit_event: EventAsset
@export var death_event: EventAsset

var instance_hit: EventInstance
var instance_death: EventInstance

var invulnerable = {}

# Compute movements by: normalized direction * delta * SPD * SPD_SCALE
var SPD_SCALE := 200.0

@onready var timer: Timer = $Timer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var emitter: GPUParticles2D = $GPUParticles2D

signal damaged()
signal dead()
signal changed()
signal level_up()


func _ready():
	CURRENT_HP = HP
	instance_hit = FMODRuntime.create_instance(hit_event)
	instance_death = FMODRuntime.create_instance(death_event)
	
	if get_parent() is Enemy:
		dead.connect((get_parent() as Enemy).die)


func get_lvl():
	return LVL if not elite else 4 * LVL


func get_hp():
	return HP if not elite else 2 * HP


func get_atk():
	return ATK if not elite else 1.5 * ATK


func get_frq():
	return FRQ if not elite else 1.5 * FRQ


func get_spd():
	return SPD if not elite else 1.5 * SPD


func shoot() -> bool:
	if not timer.is_stopped():
		return false
		
	timer.start(5.0 / max(1.0, FRQ))
	return true


func is_invulnerable():
	return invulnerable.values().any(func(b): return b)


func _on_hit(stats: Stats):
	if is_invulnerable() or CURRENT_HP <= 0:
		return
	
	# Take damage
	invulnerable["hit"] = true
	CURRENT_HP -= stats.ATK
	CURRENT_HP = max(CURRENT_HP, 0)
	damaged.emit()
	changed.emit()
	
	if CURRENT_HP <= 0:
		# death
		instance_death.start()
		
		emitter.amount *= 2
		emitter.lifetime *= 1.6
	else: 
		# hit
		instance_hit.start()
		
	emitter.emitting = true
	animation_player.stop()
	animation_player.play("hit")


func hide_sprite():
	if sprite != null:
		sprite.visible = false
	
	
func show_sprite():
	if sprite != null:
		sprite.visible = true


func check_death():
	if CURRENT_HP <= 0:
		dead.emit()
	else:
		invulnerable["hit"] = false


func level_xp(level: int) -> int:
	if level <= 0:
		return 0
	return int(5 * 1.25 ** (level - 1))


func add_xp(amount: int):
	XP += amount
	while XP >= level_xp(LVL):
		XP -= level_xp(LVL)
		LVL += 1
		level_up.emit()
	changed.emit()


func heal():
	CURRENT_HP = HP
	changed.emit()


func copy(s: Stats):
	HP = s.HP
	CURRENT_HP = HP
	ATK = s.ATK
	FRQ = s.FRQ
	SPD = s.SPD
