extends Node2D

onready var LevelOrbs := $"../LevelOrbs"
const LevelConnection := preload("res://LevelConnections.gd")

func make_all_paths():
	var line_buf
	for level in LevelOrbs.get_children():
		#instantiate new line for each previous level
		for prev_level in level.pre:
			line_buf = preload("res://LevelConnectionLine.tscn").instance()
			line_buf.set_from_level_line(LevelOrbs.get_level_by_id(prev_level), level)
			add_child(line_buf)


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

# Called when the node enters the scene tree for the first time.
func _ready():
	pass



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
