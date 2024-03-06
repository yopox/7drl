extends Node2D

@onready var sprite: Sprite2D = $Sprite2D

func _ready():
	sprite.texture = AtlasTexture.new()
	var at = sprite.texture as AtlasTexture
	at.atlas = load("res://assets/MRMOTEXT_EX.png")
	at.region.size = Vector2(8, 8)
	at.region.position = Vector2(80, 48)
	match randi_range(0, 2):
		1:
			at.region.position.x = 88
		2:
			at.region.position.x = 96
