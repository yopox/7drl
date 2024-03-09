extends TileMap

@export var room_size = Vector2i(20, 9)
@export var rooms_y = 4
@export var rooms_x = 4
@export var corridor_x = Vector2i(4, 3)
@export var corridor_y = Vector2i(2, 2)

var start_pattern = preload("res://patterns/dungeon/start.tscn")
var exit_pattern = preload("res://patterns/dungeon/exit.tscn")

signal generated(pos: Vector2)


#func _process(delta):
	#if Input.is_action_pressed("use_item"):
		#generate()


func generate():
	clear()
	
	# generate layout
	var rooms = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]
	var connections = [
		[0, 1], [1, 2], [2, 3],
		[0, 4], [1, 5], [2, 6], [3, 7],
		[4, 5], [5, 6], [6, 7],
		[4, 8], [5, 9], [6, 10], [7, 11],
		[8, 9], [9, 10], [10, 11],
		[8, 12], [9, 13], [10, 14], [11, 15],
		[12, 13], [13, 14], [14, 15],
	]
	
	var col = [0, 1, 2, 3]
	var row = [0, 1, 2, 3]
	var safe = []
	
	# remove 3 connections
	for i in range(3):
		var rem_col = col.pick_random()
		col.erase(rem_col)
		var rem_row = row.pick_random()
		row.erase(rem_row)
		var room = rem_row * 4 + rem_col
		safe.append(room)
		var to_remove = connections.filter(func(a): return \
			a[0] == room and not a[1] in safe\
			or a[1] == room and not a[0] in safe\
		).pick_random()
		connections.erase(to_remove)
		if to_remove[0] == room:
			safe.append(to_remove[1])
		else:
			safe.append(to_remove[0])
		#print("Removed connection [%s, %s]" % to_remove)
	
	#print("Safe: " + str(safe))
	
	# remove 2 rooms
	for i in range(2):
		var room = rooms.filter(func(r): return not r in safe).pick_random()
		if room == null:
			generate()
			return
		rooms.erase(room)
		connections = connections.filter(func(c): return c[0] != room and c[1] != room)
		safe.append_array([room - 5, room - 4, room - 3, room - 1, room, room + 1, room + 3, room + 4, room + 5])
		#print("Erased %s" % room)
	
	var starting = rooms.pick_random()
	var graph = build_graph(starting, connections, rooms)
	if graph.size() < 14:
		generate()
		return
		
	#print("%s -> %s / graph: %s" % [starting, graph.keys()[-1], graph])
	var exit = graph.keys()[-1]
	
	# fill rooms
	for y in range(rooms_y):
		for x in range(rooms_x):
			if x + 4 * y not in rooms:
				continue
				
			var r_x = (room_size.x + corridor_x.x) * x
			var r_y = (room_size.y + corridor_y.y) * y
			
			# draw room
			for dy in range(room_size.y):
				for dx in range(room_size.x):
					set_cell(0, Vector2i(r_x + dx, r_y + dy), 0, Vector2i(0, 0))

			# draw corridor x
			if x < rooms_x - 1 and [x + 4 * y, x + 4 * y + 1] in connections: 
				var start = Vector2i(room_size.x, (room_size.y - corridor_x.y) / 2)
				for dy in range(corridor_x.y):
					for dx in range(corridor_x.x):
						set_cell(0, Vector2i(r_x + start.x + dx, r_y + start.y + dy), 0, Vector2i(0, 0))
					
			# draw corridor y
			if y < rooms_y - 1 and [x + 4 * y, x + 4 * (y + 1)] in connections:
				var start_y = Vector2i((room_size.x - corridor_y.x) / 2, room_size.y)
				for dy in range(corridor_y.y):
					for dx in range(corridor_y.x):
						set_cell(0, Vector2i(r_x + start_y.x + dx, r_y + start_y.y + dy), 0, Vector2i(0, 0))
	
	# fill walls
	for y in range(rooms_y + 4):
		for x in range(rooms_x + 4):
			var r_x = (room_size.x + corridor_x.x) * (x - 2)
			var r_y = (room_size.y + corridor_y.y) * (y - 2)
			
			for dy in range(room_size.y + corridor_y.y):
				for dx in range(room_size.x + corridor_x.x):
					var cell = get_cell_tile_data(0, Vector2i(r_x + dx, r_y + dy))
					if cell == null:
						if get_cell_tile_data(0, Vector2i(r_x + dx, r_y + dy + 1)) == null:
							set_cell(0, Vector2i(r_x + dx, r_y + dy), 0, Vector2i(31, 31))
						else:
							set_cell(0, Vector2i(r_x + dx, r_y + dy), 0, Vector2i(2, 21))
	
	# spawn patterns
	for room in rooms:
		var pattern
		if room == starting:
			pattern = start_pattern.instantiate()
		elif room == exit:
			pattern = exit_pattern.instantiate()
		else:
			pass
		if pattern != null:
			pattern.position = room_to_pos(room)
			add_sibling(pattern)
	
	generated.emit(room_to_pos(starting) + Vector2(room_size.x * 4.0, room_size.y * 4.0))


func room_to_pos(room: int) -> Vector2:
	return map_to_local(Vector2i(
		(room % 4) * (room_size.x + corridor_x.x),
		(room / 4) * (room_size.y + corridor_y.y)
	)) - Vector2(4, 4)

func build_graph(start_node: int, connections: Array, rooms: Array):
	var graph = { start_node: 0 }
	var visited = [start_node]
	var modified = true
	
	while modified:
		modified = false
		var unvisited = rooms.filter(func(r): return r not in visited)
		var found = []
		for r1 in visited:
			for r2 in unvisited:
				if r2 in found:
					continue
				if [r1, r2] in connections or [r2, r1] in connections:
					graph[r2] = graph[r1] + 1
					found.append(r2)
					modified = true
		visited.append_array(found)

	return graph
