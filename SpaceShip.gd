## The Space ship moving around the Map
extends Node2D

onready var cam := $Camera2D
onready var Connections := $"../Connections"
onready var Collision := $Area2D
onready var LevelOrbs := $"../LevelOrbs"
onready var DirectionArrows := $DirectionArrows

signal update_ui(level)

# returns the collision of a level. see LevelOrbCollision.gd
func get_current_level():
	var current_level = Collision.get_overlapping_areas()
	if current_level.size() != 0:
		current_level = current_level[0]
		return current_level
	else:
		return null

func calculate_possible_movement():
	var current_level = get_current_level()
	if current_level == null:
		return
	var paths = Connections.get_paths_from_node(current_level.get_level_id())
	var path_buf
	var level_buf
	for path in paths:
		path_buf = preload("res://MapArrow.tscn").instance()
		if path.destination == current_level.get_level_id():
			path_buf.destination = path.origin
		else:
			path_buf.destination = path.destination
		level_buf = LevelOrbs.get_level_by_id(path_buf.destination)
		if level_buf.check_unlock():
			path_buf.set_rotation(get_angle_to(level_buf.position))
			DirectionArrows.add_child(path_buf)
			path_buf.connect("move_ship_to", self, "_on_move_ship_to")

# Called when the node enters the scene tree for the first time.
func _ready():
	cam.make_current()

static func delete_children(node):
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()

func _on_move_ship_to(destination):
	print_debug("ARROW DEST. " + destination)
	var level = LevelOrbs.get_level_by_id(destination)
	if level != null:
		delete_children(DirectionArrows)
		var tween = get_node("Tween")
		tween.interpolate_property(self, "position",
		position, level.position, 0.5,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.start()
		$Sprite.rotation = get_angle_to(level.position)


func _on_Tween_tween_completed(_object, _key):
	calculate_possible_movement()
	emit_signal("update_ui", get_current_level())
	$Sprite.rotation = 0
