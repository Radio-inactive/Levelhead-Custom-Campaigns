extends Area2D

onready var LevelOrb := $".."

func get_level_id() -> String:
	return LevelOrb.levelID

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
