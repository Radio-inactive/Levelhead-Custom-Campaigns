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
onready var return_button := $"../Return"
onready var level_code_label := $HBoxContainer/VBoxContainer/TitleBookmark/LevelCode

onready var LevelOrbs := $"../../LevelOrbs"
onready var RumpusReq := $"../../RumpusRequests"
onready var SpaceShip := $"../../SpaceShip"

const LevelOrb := preload("LevelOrb.gd")

signal current_level_bookmark(level_code, set)

func time_format(time):
	var seconds = int(time) % 60
	var minutes = int((int(time) - seconds) / 60)
	var str_out = ""
	str_out += "%02d:"%minutes
	str_out += "%02d"%seconds
	return str_out

func update_info_from_level(level: LevelOrb):
	self.show()
	if RumpusReq.delegation_key != "NOKEY":
		bookmark_button.show()
	else:
		var delegation_key_set_success : bool = RumpusReq.get_delegation_key()
		if delegation_key_set_success:
			$"../BaseUI".delegation_key_present = true
			bookmark_button.show()
		else:
			$"../BaseUI".delegation_key_present = false
			bookmark_button.hide()
	return_button.show()
	if level != null:
		if level.t == level.t_types.PATH_SHAPE_ASSIST:
			title.text = ""
			level_code_label.text = ""
			completed.hide()
			all_jems.hide()
			found_gr17.hide()
			all_bugs.hide()
			bench.hide()
			score.hide()
			clipboard_button.hide()
			return
		
		clipboard_button.show()
		title.text = level.n
		level_code_label.text = " (" + level.levelID + ")"
		
		bookmark_button.set_pressed_no_signal(false)
		bookmark_status.text = ""
		
		completed.show()
		completed.set_pressed_no_signal(level.level_completed)
		completed.disabled = level.level_completed
		
		all_jems.show()
		all_jems.set_pressed_no_signal(level.level_all_jems)
		all_jems.disabled = level.level_all_jems
		
		found_gr17.visible = level.ch == MapEntityGeneric.gr17_present.GR17_PRESENT
		found_gr17.set_pressed_no_signal(level.level_found_gr17)
		found_gr17.disabled = level.level_found_gr17
		
		all_bugs.visible = level.gr18 == MapEntityGeneric.bug_pieces_present.BUG_PIECES_PRESENT
		all_bugs.set_pressed_no_signal(level.level_all_bug_pieces)
		all_bugs.disabled = level.level_all_bug_pieces
		
		bench.visible = level.b_time != 0
		bench.set_pressed_no_signal(level.level_otd_met)
		bench.disabled = level.level_otd_met
		# todo: time formatting
		bench.text = time_format(level.b_time)
		
		score.visible = level.level_score_bench != 0
		score.set_pressed_no_signal(level.level_score_bench_met)
		score.disabled = level.level_score_bench_met
		# todo: formatting
		score.text = "Score (" + String(level.level_score_bench) + ")"
		
		clipboard_button.set_pressed_no_signal(false)
	else:
		print("no level in update_info_from_level")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_move_ship_to(_destination):
	self.hide()
	return_button.hide()


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
	print(result)
	if result == HTTPRequest.RESULT_NO_RESPONSE:
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
