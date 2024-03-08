extends Node

enum SFX { Select, Back }

func play_sfx(sfx: SFX):
	match sfx:
		SFX.Select:
			FMODRuntime.play_one_shot_path("event:/UI_Select")
		SFX.Back:
			FMODRuntime.play_one_shot_path("event:/UI_Back")


