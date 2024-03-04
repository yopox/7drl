extends TileMap

var N := Vector2i(14, 28)
var E := Vector2i(5, 28)
var S := Vector2i(19, 28)
var W := Vector2i(23, 28)

var CARD_POINTS = [
	[0, E],
	[PI / 2, N],
	[PI, W],
	[3 * PI / 2, S],
]

var EMPTY := Vector2i(31, 31)
var CHEST := Vector2i(31, 15)
var GOAL := Vector2i(30, 15)

var angle = 0
var SPAN = 170.0 * PI / 180.0
var SEGMENT = SPAN / 9.0

func _process(delta):
	var hero: Hero = HeroUtil.hero
	if hero != null:
		if abs(hero.velocity[0]) > 0.1 or abs(hero.velocity[1]) > 0.1:
			var beta = hero.velocity.angle()
			if angle - beta > PI:
				beta += 2 * PI
			angle = fposmod((angle * 5 + beta) / 6, 2 * PI)
			
	var current = angle - SPAN / 2
	for i in range(9):
		set_cell(0, Vector2i(i, 0), 0, cardinal(current))
		current += SPAN / 9.0

func cardinal(angle) -> Vector2i:
	for tile in CARD_POINTS:
		if is_beta_shown(angle, tile[0]):
			return tile[1]
	return EMPTY

func is_beta_shown(alpha, beta) -> bool:
	if alpha <= beta and beta < alpha + SEGMENT:
		return true
		
	var beta2 = beta - 2 * PI
	if alpha <= beta2 and beta2 < alpha + SEGMENT:
		return true
	
	var beta3 = beta + 2 * PI
	return alpha <= beta3 and beta3 < alpha + SEGMENT
