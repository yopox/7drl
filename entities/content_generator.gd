class_name ContentGenerator extends Node

var sand_patterns = [
	[8, null],
	[3, preload("res://entities/patterns/bloc.tscn")],
	[2, preload("res://entities/patterns/bloc_2.tscn")],
	[3, preload("res://entities/patterns/crab_l2.tscn")],
	[3, preload("res://entities/patterns/shrimp_l2.tscn")],
	[6, preload("res://entities/patterns/urchin.tscn")],
	[1, preload("res://entities/patterns/shrimp_blocs.tscn")],
	[1, preload("res://entities/patterns/shrimp_urchin.tscn")],
	[3, preload("res://entities/patterns/urchin_2.tscn")],
]
var sand_weights: int = 0


func prepare():
	sand_weights = update_weights(sand_patterns)


func update_weights(table) -> int:
	var w = 0
	for i in range(len(table)):
		w += table[i][0]
		table[i][0] = w
	return w


func generate(terrain: String) -> Node2D:
	var pattern = null
	
	var pool: Array
	if terrain == "sand":
		pool = [sand_weights, sand_patterns]
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
