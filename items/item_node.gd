class_name ItemNode extends Sprite2D

@export var item: Inventory.Item = Inventory.Item.Bomb: set = set_item
var init = false

func _ready():
	if not init:
		init_sprite()


func init_sprite():
	texture = AtlasTexture.new()
	texture.atlas = load("res://assets/MRMOTEXT_EX.png")
	texture.region.size = Vector2(8, 8)
	material = ShaderMaterial.new()
	material.shader = load("res://scenes/textmode.gdshader")
	init = true
	update()


func _process(_delta):
	if item == Inventory.Item.Dash:
		if Util.hero.dash:
			pass


func set_item(value: Inventory.Item):
	item = value
	if not init:
		init_sprite()
	else:
		update()


func update():
	var t = texture as AtlasTexture
	var sm = material as ShaderMaterial
	match item:
		Inventory.Item.Dash:
			t.region.position = Vector2(24, 56)
			sm.set_shader_parameter("fg", Color("#d28f46"))
		Inventory.Item.Potion:
			t.region.position = Vector2(104, 120)
			sm.set_shader_parameter("fg", Color("#ea3a3a"))
		Inventory.Item.Bomb:
			t.region.position = Vector2(120, 104)
			sm.set_shader_parameter("fg", Color("#4652d2"))
		Inventory.Item.Clover:
			t.region.position = Vector2(113, 184)
			sm.set_shader_parameter("fg", Color("#52d246"))
			
