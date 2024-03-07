class_name ItemNode extends Sprite2D

@export var item: Inventory.Item: set = set_item


func _ready():
	texture = AtlasTexture.new()
	texture.atlas = load("res://assets/MRMOTEXT_EX.png")
	texture.region.size = Vector2(8, 8)
	update()


func _process(_delta):
	if item == Inventory.Item.Dash:
		if Util.hero.dash:
			pass


func set_item(value: Inventory.Item):
	item = value
	update()


func update():
	var t = texture as AtlasTexture
	match item:
		Inventory.Item.Dash:
			t.region.position = Vector2(24, 56)
		Inventory.Item.Potion:
			t.region.position = Vector2(104, 120)
		Inventory.Item.Bomb:
			t.region.position = Vector2(120, 104)
