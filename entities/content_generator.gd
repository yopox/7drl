class_name ContentGenerator extends Node

var sand_patterns = [
	[17, null],
	[3, preload("res://patterns/sand/bloc.tscn")],
	[2, preload("res://patterns/sand/bloc_2.tscn")],
	[3, preload("res://patterns/sand/crab_l3.tscn")],
	[3, preload("res://patterns/sand/shrimp_l2.tscn")],
	[6, preload("res://patterns/sand/urchin_l2.tscn")],
	[1, preload("res://patterns/sand/shrimp_blocs.tscn")],
	[1, preload("res://patterns/sand/shrimp_urchin.tscn")],
	[3, preload("res://patterns/sand/urchin_2.tscn")],
	[1, preload("res://entities/chest/chest.tscn")],
]
var sand_weights: int = 0

var grass_patterns = [
	[13, null],
	[1, preload("res://patterns/grass/spiders_2.tscn")],
	[3, preload("res://patterns/grass/potion.tscn")],
	[3, preload("res://patterns/sand/bloc_2.tscn")],
	[1, preload("res://entities/spikes/spikes.tscn")],
	[4, preload("res://patterns/grass/bear_l4.tscn")],
	[3, preload("res://patterns/grass/spider_l8.tscn")],
]
var grass_weights: int = 0

var rock_patterns = [
	[12, null],
	[2, preload("res://patterns/rock/crab_l6.tscn")],
	[1, preload("res://patterns/grass/potion.tscn")],
	[2, preload("res://patterns/sand/bloc_2.tscn")],
	[3, preload("res://entities/spikes/spikes.tscn")],
	[3, preload("res://patterns/rock/shrimp_blocs_l6.tscn")],
	[2, preload("res://patterns/rock/spider_l9.tscn")],
	[2, preload("res://patterns/rock/shrimp_urchin_l8.tscn")],
]

var rock_weights: int = 0

func prepare():
	sand_weights = Util.update_weights(sand_patterns)
	grass_weights = Util.update_weights(grass_patterns)
	rock_weights = Util.update_weights(rock_patterns)


func generate(terrain: String) -> Node2D:
	var pattern = null
	
	var pool: Array
	if terrain == "sand":
		pool = [sand_weights, sand_patterns]
	elif terrain == "grass":
		pool = [grass_weights, grass_patterns]
	elif terrain == "rock":
		pool = [rock_weights, rock_patterns]
	else:
		return null
	
	# Get random pattern
	var index = randi_range(1, pool[0])
	for p in pool[1]:
		if p[0] >= index:
			pattern = p[1]
			break
	
	# Rotate pattern instance
	if pattern != null:
		var node := pattern.instantiate() as Node2D
		var rotation = PI / 4 * randi_range(0, 7)
		for child in node.get_children():
			if child is Node2D:
				child.position = child.position.rotated(rotation)
		return node
		
	return null
