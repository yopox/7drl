extends Node2D

@onready var tile_map = $TileMap
@onready var press_start = $PressStart
@onready var logo = $Logo

var time: float = 0
var logo_time: float = 0

signal exit_title


func _ready():
	var version: String = ProjectSettings.get_setting("application/config/version")
	for i in range(len(version)):
		var cell = Util.get_char_pos(version, i)
		tile_map.set_cell(0, Vector2i(33 + i, 20), 0, cell)

func _process(delta):
	time += delta
	press_start.visible = time < 1 
	time = fmod(time, 2)
	
	logo_time += delta
	logo_time = fmod(logo_time, 2 * PI * 0.8)
	logo.position.y = 63.5 - sin(logo_time / 0.8)
	
	if Input.is_action_just_pressed("use_item") or Util.android_start:
		Util.android_start = false
		Audio.play_sfx(Audio.SFX.Select)
		exit_title.emit()
