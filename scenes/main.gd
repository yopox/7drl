extends Node2D

@onready var hero: CharacterBody2D = $Hero
@onready var tilemap: TileMap = $TileMap
@onready var generator: NoiseGenerator = $NoiseGenerator

func _ready():
	hero.visible = false


func find_starting_pos() -> Vector2i:
	var start = Vector2i(0, 0) 
	while generator.get_grid().get_valuexy(start.x, start.y, 0).id != "sand":
		start.x = randi_range(0, 255)
		start.y = randi_range(0, 255)
	return start

func _on_noise_generator_grid_updated():
	if generator.get_grid().get_valuexy(0, 0, 0) == null:
		return
	
	# Generate a starting position in the sand
	var start := find_starting_pos()
	
	# Update the hero position
	hero.position.x = start.x * tilemap.tile_set.tile_size.x + tilemap.tile_set.tile_size.x / 2
	if start.y % 2 == 1:
		hero.position.x -= tilemap.tile_set.tile_size.x / 2
	hero.position.y = start.y * tilemap.tile_set.tile_size.y + tilemap.tile_set.tile_size.y / 2
	hero.visible = true
	
