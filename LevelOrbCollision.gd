### Collision of the Level Orb. Used to retrieve level information
extends Area2D

@onready var LevelOrb := $".."

func get_level_id() -> String:
	return LevelOrb.levelID

func get_level():
	return LevelOrb

