extends RigidBody2D

var item_drop = preload("res://items/item_drop.tscn")
signal hit(stats)


func _ready():
	hit.connect(open)


func open(_stats):
	for _i in range(2):
		var item = item_drop.instantiate()
		item.position = position
		var angle = randf() * 2 * PI
		item.apply_impulse(Vector2(cos(angle), sin(angle)) * 2)
		(func():
			add_sibling(item)
			item.randomize()
		).call_deferred()
		
	queue_free()
