extends Node2D

@export var event: EventAsset
@export var dungeonmusicevent: EventAsset
@export var bossmusicevent: EventAsset
@onready var scene_container: Node2D = $SceneContainer
@onready var buttons: Control = $Buttons
@onready var bgm: BGM = $Bgm

var title = preload("res://scenes/states/title.tscn")
var character_selection = preload("res://scenes/states/character_selection.tscn")
var level = preload("res://scenes/states/level.tscn")
var dungeon = preload("res://scenes/states/cave.tscn")
var boss = preload("res://scenes/tile_maps/final_boss.tscn")
var title_music: EventInstance
var boss_music: EventInstance
var hero_node


func _ready():
	if OS.get_name() != "Android":
		buttons.queue_free()
	else:
		buttons.visible = true

	title_music = FMODRuntime.create_instance(event)
	spawn_title()
	boss_music = FMODRuntime.create_instance(bossmusicevent)
	Util.enter_dungeon.connect(enter_dungeon)
	Util.enter_boss.connect(enter_boss)
	Util.return_to_title.connect(return_to_title)


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
	bgm.play_lvl1()
	Util.items = Util.starting_items
	Util.dungeon = false
	Util.game_over = false
	Util.boss_defeated = false
	var scene = level.instantiate()
	scene_container.add_child(scene)
	hero_node = scene.setup_hero(hero, stats)
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


func enter_dungeon():
	bgm.play_lvl3()
	Util.dungeon = true
	var scene = dungeon.instantiate()
	scene_container.add_child(scene)
	hero_node.global_position = scene.hero.global_position
	scene.hero.stats.copy(hero_node.stats)
	scene.hero.hero_class = hero_node.hero_class
	scene.hero.update_stuff()
	scene.hero.death_color = Vector4(0.208, 0.196, 0.196, 1.0)
	hero_node = scene.hero
	scene_container.get_children()[0].queue_free()


func enter_boss():
	bgm.play_boss()
	var scene = boss.instantiate()
	(func():
		scene_container.add_child(scene)
		hero_node.global_position = scene.hero.global_position
		scene.hero.stats.copy(hero_node.stats)
		scene.hero.hero_class = hero_node.hero_class
		scene.hero.update_stuff()
		scene.hero.death_color = Vector4(0.208, 0.196, 0.196, 1.0)
		hero_node = scene.hero
		scene_container.get_children()[0].queue_free()).call_deferred()


func return_to_title():
	scene_container.get_children()[0].queue_free()
	hero_node.queue_free()
	bgm.stop()
	spawn_title()
