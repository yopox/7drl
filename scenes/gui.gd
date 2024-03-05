extends Control

@onready var LVL: Counter = $CanvasLayer/Level
@onready var HP: Counter = $CanvasLayer/HP
@onready var ATK: Counter = $CanvasLayer/ATK
@onready var FRQ: Counter = $CanvasLayer/FRQ
@onready var SPD: Counter = $CanvasLayer/SPD

func _process(delta):
	var hero: Hero = HeroUtil.hero
	if hero == null:
		return
	
	HP.bar_progress = hero.stats.CURRENT_HP * 1.0 / hero.stats.HP
	HP.text = "HP   %02d" % hero.stats.CURRENT_HP
	ATK.text = "ATK  %02d" % hero.stats.ATK
	FRQ.text = "FRQ  %02d" % hero.stats.FRQ
	SPD.text = "SPD  %02d" % hero.stats.SPD
