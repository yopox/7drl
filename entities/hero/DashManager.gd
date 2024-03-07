class_name DashManager extends Node

@export var max_dashes = 1
@export var update_gui = false

@export var event: EventAsset
var instance: EventInstance

@onready var timer: Timer = $Timer

var dashes = max_dashes: set = set_dashes


func _ready():
	instance = FMODRuntime.create_instance(event)


func dash() -> bool:
	if dashes <= 0:
		return false
	dashes -= 1
	timer.start()
	instance.start()
	return true


func _on_timer_timeout():
	if dashes < max_dashes:
		dashes += 1
	if dashes < max_dashes:
		timer.start()


func set_dashes(value):
	dashes = value
	if update_gui:
		Util.gui.inventory.update_dash(value > 0)
