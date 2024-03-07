class_name Inventory extends TileMap

enum Item { Dash, Bomb, Potion, }

@export var items: Array[Item] = [Item.Bomb, Item.Potion]

@onready var items_node: Node2D = $Items
@onready var dash: Sprite2D = $Dash

var selected: int = 0
var selected_item: Item = Item.Dash
var item_scene = preload("res://items/item_node.tscn")
var bomb_scene = preload("res://items/bomb.tscn")

var white = Color("#f3f3f3")


func _ready():
	update()


func _process(_delta):
	if Input.is_action_just_pressed("select_item"):
		selected = (selected + 1) % 7
		update()


func item_used():
	match selected_item:
		Item.Bomb:
			var bomb = bomb_scene.instantiate()
			bomb.position = Util.hero.position
			Util.hero.add_sibling(bomb)
		Item.Potion:
			Util.hero.stats.heal()

	if selected > 0:
		items.remove_at(selected - 1)
		selected = 0
		update()

func update():
	if selected > items.size():
		selected = 0
	if selected >= 1:
		selected_item = items[selected - 1]
	else:
		selected_item = Item.Dash
	
	while items_node.get_children().size() < items.size():
		var scene = item_scene.instantiate()
		items_node.add_child(scene)
		
	while items_node.get_children().size() > items.size():
		items_node.remove_child(items_node.get_children()[-1])
	
	var children = items_node.get_children()
	for i in range(children.size()):
		var child = children[i] as ItemNode
		child.position = Vector2(4 + 8 * i, 4)
		child.item = items[i]
	
	var item_name = Util.item_name(selected_item)
	for i in range(10):
		set_cell(0, Vector2i(10 + i, 0), 0, Util.get_char_pos(item_name, i))
	for i in range(7):
		set_cell(0, Vector2i(1 + i, 1), 0, Vector2i(0, 0) if i != selected else Vector2i(30, 28))


func update_dash(available: bool):
	if available:
		dash.update()
	else:
		(dash.material as ShaderMaterial).set_shader_parameter("fg", white)
