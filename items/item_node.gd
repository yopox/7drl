class_name ItemNode extends Sprite2D

@export var item: Inventory.Item: set = set_item


func _ready():
	texture = AtlasTexture.new()
	texture.atlas = load("res://assets/MRMOTEXT_EX.png")
	texture.region.size = Vector2(8, 8)
	material = ShaderMaterial.new()
	material.shader = load("res://scenes/textmode.gdshader")
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
	var sm = material as ShaderMaterial
	match item:
		Inventory.Item.Dash:
			t.region.position = Vector2(24, 56)
			sm.set_shader_parameter("fg", Color("#deb964"))
		Inventory.Item.Potion:
			t.region.position = Vector2(104, 120)
			sm.set_shader_parameter("fg", Color("#ea3a3a"))
		Inventory.Item.Bomb:
			t.region.position = Vector2(120, 104)
			sm.set_shader_parameter("fg", Color("#524d4d"))
