extends Node2D

@onready var hero = $Hero
@onready var tile_map = $CaveTileMap


func _ready():
	tile_map.generate()


func _on_cave_tile_map_generated(pos: Vector2):
	hero.position = pos
