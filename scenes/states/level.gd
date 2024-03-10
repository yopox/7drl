extends Node2D

var hero: Hero
@onready var tilemap: TileMap = $TileMap
@onready var generator: NoiseGenerator = $NoiseGenerator
var grid: GaeaGrid


func generate():
	generator.generate()
	grid = generator.grid
	init_level()


func setup_hero(hero_class: Hero.Class, stats: Stats) -> Hero:
	hero = load("res://entities/hero/hero.tscn").instantiate()
	hero.visible = false
	hero.hero_class = hero_class
	add_child(hero)
	hero.stats.copy(stats,  false)
	return hero


func find_starting_pos() -> Vector2i:
	var start = Vector2i(0, 0)
	while grid.get_value(start, 0).id != "sand":
		start.x = randi_range(0, 255)
		start.y = randi_range(0, 255)
	return start


func find_exit() -> Vector2i:
	var exit = Vector2i(0, 0)
	while grid.get_value(exit, 0).id != "rock":
		exit.x = randi_range(0, 255)
		exit.y = randi_range(0, 255)
	return exit


func init_level():
	var gui = load("res://scenes/ui/gui.tscn").instantiate()
	add_child(gui)
	
	# Generate a starting position in the sand
	var start := find_starting_pos()
	var exit := find_exit()
	Util.exit = tilemap.map_to_local(exit)
	
	Util.tile_map.place_enemies(start, exit, grid)
	
	# Update the hero position
	hero.position = tilemap.map_to_local(start)
	hero.visible = true

