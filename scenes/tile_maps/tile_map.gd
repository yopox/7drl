extends TileMap

@export var generate_enemies = true

var stairs = preload("res://entities/stairs/stairs.tscn")
var content_generator: ContentGenerator

func _ready():
	Util.tile_map = self
	content_generator = preload("res://entities/content_generator.tscn").instantiate()
	content_generator.prepare()


func place_enemies(start_pos: Vector2i, exit_pos: Vector2i, grid: GaeaGrid):
	if !generate_enemies:
		return
	
	var div_x = 10
	var div_y = 5
	
	for y in range(256 / div_y):
		var dx = div_x / 2 if y % 2 == 1 else 0
		for x in range(256 / div_x):
			var tile_x = x * div_x + dx + randi_range(-2, 2)
			var tile_y = y * div_y + randi_range(-1, 1)
			var pos = Vector2i(tile_x, tile_y)
			
			if (start_pos - pos).length_squared() < 64:
				continue
			if (exit_pos - pos).length_squared() < 64:
				continue
			
			var cell = grid.get_value(pos, 0)
			if cell == null:
				continue
			
			var pattern: Node2D = content_generator.generate(cell.id)
			if pattern == null:
				continue
			
			pattern.position = map_to_local(Vector2i(tile_x, tile_y))
			pattern.visible = true
			add_sibling.call_deferred(pattern)

	var exit = stairs.instantiate()
	exit.position = map_to_local(exit_pos)
	add_sibling(exit)
	
	var fake_exit = stairs.instantiate()
	fake_exit.position = map_to_local(start_pos) + Vector2(8, 8)
	add_sibling(fake_exit)
