extends Node

enum SFX { Select, Back, GrabItem }

func play_sfx(sfx: SFX):
	match sfx:
		SFX.Select:
			FMODRuntime.play_one_shot_path("event:/UI_Select")
		SFX.Back:
			FMODRuntime.play_one_shot_path("event:/UI_Back")
		SFX.GrabItem:
			FMODRuntime.play_one_shot_path("event:/Grab Item")


