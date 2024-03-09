extends Attack

@onready var sprite: Sprite2D = $Sprite2D
@onready var bomb: Bomb = $Bomb
@onready var bomb_anim: AnimationPlayer = $AnimationPlayer
@onready var timer: Timer = $Timer

var detonated = false


func after_contact():
	sleeping = true
	detonated = true
	bomb.explode()
	bomb_anim.play("explosion")


func _on_timer_timeout():
	if !detonated:
		after_contact()
