### Manages the part of the UI displaying the level information
extends PanelContainer

onready var title := $HBoxContainer/VBoxContainer/TitleBookmark/LevelTitle
onready var completed := $HBoxContainer/VBoxContainer/Checks/CompletedCheck
onready var all_jems := $HBoxContainer/VBoxContainer/Checks/AllJems
onready var found_gr17 := $HBoxContainer/VBoxContainer/Checks/FoundGR17
onready var all_bugs := $HBoxContainer/VBoxContainer/Checks/AllBugs
onready var bench := $HBoxContainer/VBoxContainer/Checks/Benchmark
onready var score := $HBoxContainer/VBoxContainer/Checks/score_bench
onready var bookmark_status := $HBoxContainer/VBoxContainer/TitleBookmark/BookmarkStatus
onready var bookmark_button := $HBoxContainer/VBoxContainer/TitleBookmark/BookmarkButton
onready var clipboard_button := $HBoxContainer/VBoxContainer/TitleBookmark/TextureButton

onready var LevelOrbs := $"../../LevelOrbs"

onready var SpaceShip := $"../../SpaceShip"

const LevelOrb := preload("LevelOrb.gd")

signal current_level_bookmark(level_code, set)

func update_info_from_level(level : LevelOrb):
	if level != null:
		title.text = level.n
		
		bookmark_button.pressed = false
		bookmark_status.text = ""
		
		completed.pressed = level.level_completed
		completed.disabled = level.level_completed
		
		all_jems.pressed = level.level_all_jems
		all_jems.disabled = level.level_all_jems
		
		found_gr17.visible = level.ch == MapEntityGeneric.gr17_present.GR17_PRESENT
		found_gr17.pressed = level.level_found_gr17
		found_gr17.disabled = level.level_found_gr17
		
		all_bugs.visible = level.gr18 == MapEntityGeneric.bug_pieces_present.BUG_PIECES_PRESENT
		all_bugs.pressed = level.level_all_bug_pieces
		all_bugs.disabled = level.level_all_bug_pieces
		
		bench.visible = level.b_time != 0
		bench.pressed = level.level_otd_met
		bench.disabled = level.level_otd_met
		#todo: time formatting
		bench.text = "OTD (" + String(level.b_time) + ")"
		#todo: fix
		score.visible = level.level_score_bench != 0
		score.pressed = level.level_score_bench_met
		score.disabled = level.level_score_bench_met
		#todo: formatting
		score.text = "Score (" + String(level.level_score_bench) + ")"
		
		clipboard_button.pressed = false
	else:
		print("no level in update_info_from_level")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.




func _on_SpaceShip_update_ui(level):
	if level == null:
		return
	update_info_from_level(level)


func _on_Node2D_update_ui(level):
	if level == null:
		return
	update_info_from_level(level)


func _on_Node2D_set_toggle_ui_switch(node_name, to):
	match(node_name):
		"CompletedCheck":
			$VBoxContainer/Checks/CompletedCheck.pressed = to
			return
		"AllJems":
			$VBoxContainer/Checks/AllJems.pressed = to
			return
		"FoundGR17":
			$VBoxContainer/Checks/FoundGR17.pressed = to
			return
		"AllBugs":
			$VBoxContainer/Checks/AllBugs.pressed = to
			return
		"Benchmark":
			$VBoxContainer/Checks/Benchmark.pressed = to
			return
	print("default in LevelInfo::_on_Node2D_set_toggle_ui_switch")


func _on_RumpusRequests_bookmark_set_result(result, response_code, headers, body):
	if result == 0:
		bookmark_status.text = "SUCCESS"
	else:
		bookmark_status.text = "FAILURE"
	bookmark_button.disabled = false


func _on_BookmarkButton_toggled(button_pressed):
	bookmark_status.text = "LOADING..."
	bookmark_button.disabled = true
	emit_signal("current_level_bookmark", SpaceShip.current_orb.levelID, button_pressed)


func _on_TextureButton_toggled(button_pressed):
	if button_pressed:
		if SpaceShip.current_orb != null:
			OS.clipboard = SpaceShip.current_orb.levelID
	else:
		if SpaceShip.current_orb != null:
			OS.clipboard = SpaceShip.current_orb.levelID
			clipboard_button.pressed = true
