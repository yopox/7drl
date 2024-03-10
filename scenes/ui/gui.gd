class_name GUI extends Control

@onready var LVL: Counter = $CanvasLayer/Level
@onready var HP: Counter = $CanvasLayer/HP
@onready var ATK: Counter = $CanvasLayer/ATK
@onready var FRQ: Counter = $CanvasLayer/FRQ
@onready var SPD: Counter = $CanvasLayer/SPD
@onready var stat_select: Node2D = $CanvasLayer/StatSelect
@onready var inventory: Inventory = $CanvasLayer/Inventory

var stat_selected: int = 0

func _ready():
	update_gui()
	Util.gui = self


func _process(_delta):
	if Util.game_over:
		return
	
	if Input.is_action_just_pressed("stat"):
		select_stat()


func select_stat():
	stat_selected = (stat_selected + 1) % 4
	update_gui()


func update_gui():
	var hero: Hero = Util.hero
	if hero == null:
		return
	
	LVL.bar_progress = hero.stats.XP * 1.0 / hero.stats.level_xp(hero.stats.LVL)
	LVL.text = "LVL  %02d" % hero.stats.LVL
	HP.bar_progress = hero.stats.CURRENT_HP * 1.0 / hero.stats.HP
	HP.text = "HP   %02d" % hero.stats.CURRENT_HP
	ATK.text = "ATK  %02d" % hero.stats.ATK
	FRQ.text = "FRQ  %02d" % hero.stats.FRQ
	SPD.text = "SPD  %02d" % hero.stats.SPD
	
	match stat_selected:
		0:
			stat_select.position.y = 88
		1:
			stat_select.position.y = 88 + 16
		2:
			stat_select.position.y = 88 + 24
		3:
			stat_select.position.y = 88 + 32
