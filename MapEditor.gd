extends Node2D

onready var LevelOrbs := $LevelOrbs
onready var SpaceShip := $SpaceShip
onready var StartUI := $UI/PanelContainer
onready var Connections := $Connections

signal update_ui(level)

# Called when the node enters the scene tree for the first time.
func _ready():
	var startPos = LevelOrbs.find_start_orb()
	if startPos != null:
		SpaceShip.position = startPos.position


func _on_StartButton_pressed():
	Connections.make_all_paths()
	SpaceShip.calculate_possible_movement()
	for level in LevelOrbs.get_children():
		level.check_unlock()
		if level.is_first_level():
			emit_signal("update_ui", level)
	StartUI.hide()


func _on_CompletedCheck_toggled(button_pressed):
	if !button_pressed:
		return
	var curr_lvl = SpaceShip.get_current_level()
	if curr_lvl != null:
		LevelOrbs.get_level_by_id(curr_lvl.get_level_id()) \
		.level_completed = button_pressed
		LevelOrbs.update_unlocks_after_level(curr_lvl.get_level_id())
		SpaceShip.calculate_possible_movement()
		#update adjacent paths
		Connections.refresh_all_paths()


func _on_AllJems_toggled(button_pressed):
	if !button_pressed:
		return
	var curr_lvl = SpaceShip.get_current_level()
	if curr_lvl != null:
		LevelOrbs.get_level_by_id(curr_lvl.get_level_id()) \
		.level_all_jems = button_pressed
		LevelOrbs.update_unlocks_after_level(curr_lvl.get_level_id())
		SpaceShip.calculate_possible_movement()
		#update adjacent paths
		Connections.refresh_all_paths()


func _on_AllBugs_toggled(button_pressed):
	if !button_pressed:
		return
	var curr_lvl = SpaceShip.get_current_level()
	if curr_lvl != null:
		LevelOrbs.get_level_by_id(curr_lvl.get_level_id()) \
		.level_all_bug_pieces = button_pressed
		LevelOrbs.update_unlocks_after_level(curr_lvl.get_level_id())
		SpaceShip.calculate_possible_movement()
		#update adjacent paths
		Connections.refresh_all_paths()


func _on_Benchmark_toggled(button_pressed): #ToDo: how are benchmarks handled?
	if !button_pressed:
		return
	var curr_lvl = SpaceShip.get_current_level()
	if curr_lvl != null:
		LevelOrbs.get_level_by_id(curr_lvl.get_level_id()) \
		.level_completed = button_pressed
		LevelOrbs.update_unlocks_after_level(curr_lvl.get_level_id())
		SpaceShip.calculate_possible_movement()
		#update adjacent paths
		Connections.refresh_all_paths()


func _on_FoundGR17_toggled(button_pressed):
	if !button_pressed:
		return
	var curr_lvl = SpaceShip.get_current_level()
	if curr_lvl != null:
		LevelOrbs.get_level_by_id(curr_lvl.get_level_id()) \
		.level_found_gr17 = button_pressed
		LevelOrbs.update_unlocks_after_level(curr_lvl.get_level_id())
		SpaceShip.calculate_possible_movement()
		#update adjacent paths
		Connections.refresh_all_paths()

