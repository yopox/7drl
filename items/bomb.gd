class_name Bomb extends Node2D

@export var damage: int = 15
@export var progress: float = 0.0

@export var sprites: Array[Sprite2D]

@export var bomb_event: EventAsset
var bomb_instance: EventInstance
var body_ignored = [self]

@onready var color_rect: ColorRect = $ColorRect
@onready var area: Area2D = $Area2D
@onready var emitter: GPUParticles2D = $GPUParticles2D

signal detonated()


func _ready():
	bomb_instance = FMODRuntime.create_instance(bomb_event)
	color_rect.material = ShaderMaterial.new()
	(color_rect.material as ShaderMaterial).shader = load("res://items/wave.gdshader")
	
func _process(_delta):
	var size = color_rect.size.x / 2
	(color_rect.material as ShaderMaterial).set_shader_parameter("progress", progress)
	
	if progress < 0.01:
		return

	for body in area.get_overlapping_bodies():
		if not body.has_signal("hit"):
			continue
		var space_state = get_world_2d().direct_space_state
		var dir = (body.global_position - global_position).normalized()
		
		var r1 = raycast(
			global_position - dir * 8,
			global_position + dir * size * progress,
			space_state
		)
		if r1.is_empty() or r1.collider != body:
			continue
			
		var r2 = raycast(
			global_position + dir * (size + 8),
			global_position + dir * size * progress,
			space_state
		)
		if r2.is_empty() or r2.collider != body:
			continue
		
		var stats = Stats.new()
		stats.ATK = damage
		body.hit.emit(stats)


func raycast(start, end, state):
	var query = PhysicsRayQueryParameters2D.create(
		start, end,
		area.collision_mask, body_ignored
	)
	return state.intersect_ray(query)


func explode():
	for sprite in sprites:
		sprite.visible = false
	emitter.emitting = true
	bomb_instance.start()


func detonate():
	detonated.emit()
