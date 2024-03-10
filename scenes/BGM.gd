class_name BGM extends Node

@export var event_lvl1: EventAsset
@export var event_lvl2: EventAsset
@export var event_lvl3: EventAsset
@export var event_boss: EventAsset

var instance_lvl1: EventInstance
var instance_lvl2: EventInstance
var instance_lvl3: EventInstance
var instance_boss: EventInstance

func _ready():
	Util.BGM = self
	instance_lvl1 = FMODRuntime.create_instance(event_lvl1)
	instance_lvl2 = FMODRuntime.create_instance(event_lvl2)
	instance_lvl3 = FMODRuntime.create_instance(event_lvl3)
	instance_boss = FMODRuntime.create_instance(event_boss)


func set_parameter(name: String, label: String, ignore_seek_speed: bool):
	for instance: EventInstance in [instance_lvl1, instance_lvl2, instance_lvl3]:
		instance.set_parameter_by_name_with_label(name, label, ignore_seek_speed)


func play_lvl1():
	instance_lvl1.start()
	for i in [instance_lvl2, instance_lvl3]:
		i.stop(FMODStudioModule.FMOD_STUDIO_STOP_ALLOWFADEOUT)


func play_lvl2():
	instance_lvl2.start()
	for i in [instance_lvl1, instance_lvl3]:
		i.stop(FMODStudioModule.FMOD_STUDIO_STOP_ALLOWFADEOUT)


func play_lvl3():
	instance_lvl3.start()
	for i in [instance_lvl1, instance_lvl2]:
		i.stop(FMODStudioModule.FMOD_STUDIO_STOP_ALLOWFADEOUT)


func play_boss():
	instance_boss.start()
	for i in [instance_lvl1, instance_lvl2, instance_lvl3]:
		i.stop(FMODStudioModule.FMOD_STUDIO_STOP_ALLOWFADEOUT)


func stop():
	for i in [instance_lvl1, instance_lvl2, instance_lvl3, instance_boss]:
		i.stop(FMODStudioModule.FMOD_STUDIO_STOP_ALLOWFADEOUT)
