class_name Stats extends Node

@export var HP: int = 20:
	set(value):
		CURRENT_HP = value
		HP = value
@export var ATK: int = 5
@export var SPD: int = 10
@export var ATK_SPD: int = 5

var CURRENT_HP: int = HP
@export var sprite: Sprite2D

var invulnerable = false: set = set_invulnerable

# Compute movements by: normalized direction * delta * SPD * SPD_SCALE
var SPD_SCALE := 200.0


@onready var timer: Timer = $Timer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var emitter: GPUParticles2D = $GPUParticles2D

func shoot() -> bool:
	if not timer.is_stopped():
		return false
		
	timer.start(5.0 / max(1.0, ATK_SPD))
	return true


func _on_hit(stats: Stats):
	if invulnerable:
		return
	CURRENT_HP -= stats.ATK
	if CURRENT_HP <= 0:
		emitter.amount *= 2
		emitter.lifetime *= 1.6
	emitter.emitting = true
	animation_player.play("hit")


func hide_sprite():
	if sprite != null:
		sprite.visible = false
	
	
func show_sprite():
	if sprite != null:
		sprite.visible = true


func set_invulnerable(value):
	invulnerable = value


func check_death():
	if CURRENT_HP <= 0:
		get_parent().queue_free()
