class_name Attack extends RigidBody2D

var stats: Stats: set = set_stats
var attack = 0


func set_stats(value):
	stats = value
	attack = stats.ATK


func contact(body):
	if stats == null:
		stats = Stats.new()
		stats.ATK = attack
	
	if body.has_signal("hit"):
		body.hit.emit(stats)
	
	queue_free()
