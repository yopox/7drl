extends TileMap

@export var generate_enemies = true

var xp = preload("res://entities/terrain/bloc.tscn")
var content_generator: ContentGenerator

func _ready():
	Util.tile_map = self
	content_generator = preload("res://entities/content_generator.tscn").instantiate()
	content_generator.prepare()
	place_enemies()

func place_enemies():
	if !generate_enemies:
		return
	
	var div_x = 12
	var div_y = 6
	
	for y in range(256 / div_y):
		var dx = div_x / 2 if y % 2 == 1 else 0
		for x in range(256 / div_x):
			var tile_x = x * div_x + dx + randi_range(-2, 2)
			var tile_y = y * div_y + randi_range(-1, 1)
			var cell = get_cell_tile_data(0, Vector2i(tile_x, tile_y))
			
			if cell == null:
				continue
			
			var pattern: Node2D = content_generator.generate(cell.terrain)
			if pattern == null:
				continue
			
			pattern.position += map_to_local(Vector2i(tile_x, tile_y))
			pattern.visible = true
			add_sibling.call_deferred(pattern)
