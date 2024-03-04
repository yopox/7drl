extends Area2D


func _ready():
	pass


func _process(_delta):
	var enemies = get_overlapping_bodies()
	var enemy_count = enemies.size()
