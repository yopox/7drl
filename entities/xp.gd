extends RigidBody2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var area: Area2D = $Area2D

func set_filled(filled: bool):
	if filled:
		(sprite.texture as AtlasTexture).region.position.x = 241
	else:
		(sprite.texture as AtlasTexture).region.position.x = 249


func _process(_delta):
	for body in area.get_overlapping_bodies():
		if body is Hero:
			var angle = (body.position - position).angle()
			apply_impulse(Vector2(cos(angle), sin(angle)) * 0.15)
	
	for body in get_colliding_bodies():
		if body is Hero:
			(body as Hero).stats.add_xp(1)
			queue_free()
