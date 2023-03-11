### Manages all connections on the map
extends Node2D

@onready var LevelOrbs := $"../LevelOrbs"
@onready var RumpusReq := $"../RumpusRequests"
const LevelConnection := preload("res://LevelConnections.gd")

# creates all paths from scratch.
func make_all_paths():
	Util.delete_children(self)
	var line_buf
	for level in LevelOrbs.get_all_level_orbs():
		#instantiate new line for each previous level
		for prev_level in level.pre:
			line_buf = preload("res://LevelConnectionLine.tscn").instantiate()
			line_buf.set_from_level_line(LevelOrbs.get_level_by_id(prev_level), level)
			add_child(line_buf)

# returns a list of paths going to/from a level orb
func get_paths_from_node(levelId : String):
	var arr_out : Array = []
	for connection in get_children():
		if (connection.origin == levelId) || \
		(connection.destination == levelId):
			arr_out.append(connection)
	return arr_out

func refresh_all_paths():
	for path in get_children():
		path.refresh_path()
