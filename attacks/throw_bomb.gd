class_name ThrowBomb extends RigidBody2D

@onready var bomb = $Bomb


func _on_bomb_exploded():
	collision_layer = 0
	collision_mask = 0


func _on_bomb_detonated():
	queue_free()
