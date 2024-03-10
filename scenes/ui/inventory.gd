class_name Inventory extends TileMap

enum Item { Dash, Bomb, Potion, }

@onready var items_node: Node2D = $Items
@onready var dash: Sprite2D = $Dash

var selected_item: Item = Item.Dash
var item_scene = preload("res://items/item_node.tscn")
var bomb_scene = preload("res://items/bomb.tscn")

var disabled_color = Color("#524d4d")


func _ready():
	update()


func _process(_delta):
	if Util.game_over:
		return
	
	if Input.is_action_just_pressed("select_item"):
		Util.selected_item = (Util.selected_item + 1) % 7
		Audio.play_sfx(Audio.SFX.Select)
		update()


func is_full() -> bool:
	return Util.items.size() >= 6


func add_item(item: Item):
	Util.items.append(item)
	Audio.play_sfx(Audio.SFX.GrabItem)
	update()


func item_used():
	match selected_item:
		Item.Bomb:
			var bomb = bomb_scene.instantiate()
			bomb.position = Util.hero.position
			bomb.damage *= Util.hero.stats.ATK / 5.0
			Util.hero.add_sibling(bomb)
		Item.Potion:
			Util.hero.stats.heal()

	if Util.selected_item > 0:
		Util.items.remove_at(Util.selected_item - 1)
		Util.selected_item = 0
		update()

func update():
	if Util.selected_item > Util.items.size():
		Util.selected_item = 0
	if Util.selected_item >= 1:
		selected_item = Util.items[Util.selected_item - 1]
	else:
		selected_item = Item.Dash
	
	while items_node.get_children().size() < Util.items.size():
		var scene = item_scene.instantiate()
		items_node.add_child(scene)
		
	while items_node.get_children().size() > Util.items.size():
		items_node.remove_child(items_node.get_children()[-1])
	
	var children = items_node.get_children()
	for i in range(children.size()):
		var child = children[i] as ItemNode
		child.position = Vector2(4 + 8 * i, 4)
		child.item = Util.items[i]
	
	var item_name = Util.item_name(selected_item)
	for i in range(10):
		set_cell(0, Vector2i(10 + i, 0), 0, Util.get_char_pos(item_name, i))
	for i in range(7):
		set_cell(0, Vector2i(1 + i, 1), 0, Vector2i(0, 0) if i != Util.selected_item else Vector2i(30, 28))


func update_dash(available: bool):
	if available:
		dash.update()
	else:
		(dash.material as ShaderMaterial).set_shader_parameter("fg", disabled_color)
