class_name Attack extends RigidBody2D

var stats: Stats: set = set_stats
var attack = 0


func set_stats(value):
	stats = value
	attack = stats.ATK


func _process(_delta):
	if stats == null:
		stats = Stats.new()
		stats.ATK = attack
	var collisions = get_colliding_bodies()
	
	for body in collisions:
		if body.has_signal("hit"):
			body.hit.emit(stats)
	
	if collisions.size() > 0:
		queue_free()
