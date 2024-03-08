extends TileMap

var N := Vector2i(14, 28)
var E := Vector2i(5, 28)
var S := Vector2i(19, 28)
var W := Vector2i(23, 28)

var CARD_POINTS = [
	[0, E],
	[PI / 2, S],
	[PI, W],
	[3 * PI / 2, N],
]

var EMPTY := Vector2i(0, 0)
var CHEST := Vector2i(31, 15)
var GOAL := Vector2i(30, 15)

var angle = 3 * PI / 2
var SPAN = 170.0 * PI / 180.0
var SEGMENT = SPAN / 9.0


func _process(_delta):
	var hero: Hero = Util.hero
	if hero != null:
		if abs(hero.velocity[0]) > 0.1 or abs(hero.velocity[1]) > 0.1:
			var beta = hero.velocity.angle()
			if angle - beta > PI:
				beta += 2 * PI
			angle = fposmod((angle * 15 + beta) / 16, 2 * PI)
			
	var current = angle - SPAN / 2
	var important = [
		[(Util.exit - hero.global_position).angle(), GOAL]
	]
	for i in range(9):
		set_cell(0, Vector2i(i, 0), 0, tile(current, important))
		current += SPAN / 9.0


func tile(alpha, important: Array) -> Vector2i:
	for interest in important:
		if is_beta_shown(alpha, interest[0]):
			return interest[1]
	for cardinal in CARD_POINTS:
		if is_beta_shown(alpha, cardinal[0]):
			return cardinal[1]
	return EMPTY


func is_beta_shown(alpha, beta) -> bool:
	if alpha <= beta and beta < alpha + SEGMENT:
		return true
		
	var beta2 = beta - 2 * PI
	if alpha <= beta2 and beta2 < alpha + SEGMENT:
		return true
	
	var beta3 = beta + 2 * PI
	return alpha <= beta3 and beta3 < alpha + SEGMENT
