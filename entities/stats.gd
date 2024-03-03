class_name Stats extends Node

@export var HP: int = 20
@export var ATK: int = 5
@export var SPD: int = 10
@export var ATK_SPD: int = 10

# Compute movements by: normalized direction * delta * SPD * SPD_SCALE
var SPD_SCALE := 200.0
