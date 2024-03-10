extends Node

var BGM: BGM

var game_over: bool = false
var boss_defeated: bool = false
var dungeon: bool = false

var hero: Hero = null: set = set_hero
var gui: GUI = null: set = set_gui
var tile_map: TileMap = null

var exit: Vector2 = Vector2.ZERO

var move_vector: Vector2 = Vector2.ZERO
var attack_vector: Vector2 = Vector2.ZERO

var android_start: bool = false
var android_select1: bool = false
var android_select2: bool = false

var starting_items: Array[Inventory.Item] = [
	Inventory.Item.Bomb,
	Inventory.Item.Potion
]
var items: Array[Inventory.Item] = []
var selected_item: int = 0

signal enter_dungeon
signal enter_boss
signal return_to_title


func set_hero(value):
	hero = value
	if gui != null:
		gui.update_gui()


func set_gui(value):
	gui = value
	if hero != null:
		gui.update_gui()


func get_char_pos(text: String, i: int) -> Vector2i:
	if i >= text.length():
		return Vector2i.ZERO
		
	var unicode = text.unicode_at(i)
	
	if unicode >= "@".unicode_at(0):
		return Vector2i(unicode - "@".unicode_at(0), 28)
	elif unicode >= "!".unicode_at(0):
		return Vector2i(1 + unicode - "!".unicode_at(0), 27)
	else:
		return Vector2i.ZERO


func item_name(item: Inventory.Item):
	match item:
		Inventory.Item.Dash:
			return "DASH"
		Inventory.Item.Bomb:
			return "BOMB"
		Inventory.Item.Potion:
			return "POTION"


func update_weights(table) -> int:
	var w = 0
	for i in range(len(table)):
		w += table[i][0]
		table[i][0] = w
	return w
