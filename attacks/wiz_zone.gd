class_name WizZone extends RigidBody2D

@onready var zone: Area2D = $Area2D
var stats: Stats
@export var cast_event: EventAsset
var cast_sfx: EventInstance

func _ready():
	cast_sfx = FMODRuntime.create_instance(cast_event)
	cast_sfx.start()

func collide():
	for body in zone.get_overlapping_bodies():
		if body.has_signal("hit"):
			body.hit.emit(stats)
