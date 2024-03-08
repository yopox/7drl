class_name Sword extends RigidBody2D

@onready var color_rect: ColorRect = $ColorRect
var stats: Stats
var time: float = 0.0


func _ready():
	(color_rect.material as ShaderMaterial).set_shader_parameter("progress", 0)


func _process(delta):
	var shader_t = min(time, 0.2)
	var progress = 1 - (1 - shader_t / 0.2) ** 3
	(color_rect.material as ShaderMaterial).set_shader_parameter("progress", progress)
	time += delta


func _on_area_2d_body_entered(body):
	if body.has_signal("hit"):
		body.hit.emit(stats)
