extends Node2D

@export var event: EventAsset

@onready var scene_container: Node2D = $SceneContainer
@onready var buttons: Control = $Buttons

var title = preload("res://scenes/states/title.tscn")
var character_selection = preload("res://scenes/states/character_selection.tscn")
var level = preload("res://scenes/states/level.tscn")
var title_music: EventInstance
	

func _ready():
	if OS.get_name() != "Android":
		buttons.queue_free()
	else:
		buttons.visible = true

	title_music = FMODRuntime.create_instance(event)
	spawn_title()


func spawn_title():
	var scene = title.instantiate()
	title_music.start()
	scene_container.add_child(scene)
	scene.exit_title.connect(_on_title_exit_title)


func spawn_character_selection():
	var scene = character_selection.instantiate()
	Util.android_start = false
	Util.android_select1 = false
	Util.android_select2 = false
	scene_container.add_child(scene)
	scene.confirm.connect(_on_character_confirm)
	scene.cancel.connect(_on_character_cancel)


func spawn_level(hero: Hero.Class, stats: Stats):
	title_music.stop(FMODStudioModule.FMOD_STUDIO_STOP_ALLOWFADEOUT)
	var scene = level.instantiate()
	scene_container.add_child(scene)
	scene.setup_hero(hero, stats)
	scene.generate()


func _on_title_exit_title():
	scene_container.get_children()[0].queue_free()
	spawn_character_selection()


func _on_character_confirm(hero: Hero.Class, stats: Stats):
	scene_container.get_children()[0].queue_free()
	spawn_level(hero, stats)


func _on_character_cancel():
	scene_container.get_children()[0].queue_free()
	spawn_title()
