extends Line2D

const LevelOrb = preload("LevelOrb.gd")

var origin : String
var destination : String
var origin_node : LevelOrb
var destination_node : LevelOrb

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_from_level_line(from_node : LevelOrb, to_node : LevelOrb):
	origin = from_node.levelID
	destination = to_node.levelID
	points[0] = from_node.global_position
	points[1] = to_node.global_position
	origin_node = from_node
	destination_node = to_node
	update_path(from_node, to_node)

func update_path(from_node : LevelOrb, to_node : LevelOrb):
	if !(from_node.check_unlock() && to_node.check_unlock()):
		if from_node.scpost || to_node.scpre:
			hide()
		default_color = Color.red
	else:
		show()
		default_color = Color.white

func refresh_path():
	update_path(origin_node, destination_node)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
