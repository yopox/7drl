class_name Counter extends TileMap

@export var text: String = "HP 10/10": set = set_text
@export var has_bar: bool = false
@export var bar_progress: float = 1
@export var fg: Color = Color(0.953, 0.953, 0.953)
@export var bg: Color = Color(0.114, 0.094, 0.094)
@export var bar_fg: Color = Color(0.953, 0.953, 0.953)

@onready var bar: TileMap = $Bar

var shader: ShaderMaterial = ShaderMaterial.new()
var bar_shader: ShaderMaterial = ShaderMaterial.new()

func _ready():
	shader.shader = load("res://scenes/textmode.gdshader")
	shader.set_shader_parameter("fg", Vector4(fg.r, fg.g, fg.b, 1))
	shader.set_shader_parameter("bg", Vector4(bg.r, bg.g, bg.b, 1))
	material = shader
	
	bar_shader.shader = load("res://scenes/textmode.gdshader")
	bar_shader.set_shader_parameter("fg", Vector4(bar_fg.r, bar_fg.g, bar_fg.b, 1))
	bar_shader.set_shader_parameter("bg", Vector4(bg.r, bg.g, bg.b, 1))
	bar.material = bar_shader
	
	draw()


func set_text(value):
	text = value
	draw()


func draw():
	for x in range(text.length()):
		set_cell(0, Vector2i(x, 0), 0, Util.get_char_pos(text, x))
			
	if has_bar:
		var progress = round(bar_progress * 14)
		for x in range(7):
			var n = progress - 2 * x
			if n <= 0:
				bar.set_cell(0, Vector2i(x, 0), 0, Vector2i(0, 0))
			elif n == 1:
				bar.set_cell(0, Vector2i(x, 0), 0, Vector2i(20, 6))
			else:
				bar.set_cell(0, Vector2i(x, 0), 0, Vector2i(18, 2))
