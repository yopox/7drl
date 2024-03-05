class_name Stats extends Node

@export_category("Character Stats")

@export var HP: int = 20:
	set(value):
		CURRENT_HP = value
		HP = value
@export var ATK: int = 5
@export var SPD: int = 10
@export var ATK_SPD: int = 5

@export_category("Nodes")

var CURRENT_HP: int = HP
@export var sprite: Sprite2D

@export_category("SFX")

@export var hit_event: EventAsset
@export var death_event: EventAsset
var instance_hit: EventInstance
var instance_death: EventInstance

var invulnerable = false

# Compute movements by: normalized direction * delta * SPD * SPD_SCALE
var SPD_SCALE := 200.0

@onready var timer: Timer = $Timer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var emitter: GPUParticles2D = $GPUParticles2D

signal damaged()
signal dead()


func _ready():
	instance_hit = FMODRuntime.create_instance(hit_event)
	instance_death = FMODRuntime.create_instance(death_event)
	if get_parent() is Enemy:
		dead.connect((get_parent() as Enemy).die)
	
func shoot() -> bool:
	if not timer.is_stopped():
		return false
		
	timer.start(5.0 / max(1.0, ATK_SPD))
	return true


func _on_hit(stats: Stats):
	if invulnerable || CURRENT_HP <= 0:
		return
	
	# Take damage
	CURRENT_HP -= stats.ATK
	damaged.emit()
	invulnerable = true
	
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
		invulnerable = false
