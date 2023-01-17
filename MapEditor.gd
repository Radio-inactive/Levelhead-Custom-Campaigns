## Parent node of the map
extends Node2D

onready var LevelOrbs := $LevelOrbs
onready var SpaceShip := $SpaceShip
onready var StartUI := $UI/PanelContainer
onready var StartUIText := $UI/PanelContainer/VBoxContainer/Label
onready var Connections := $Connections
onready var RumpusReq := $RumpusRequests
onready var StartMenu := $UI/BaseUI

signal update_ui(level)

# Called when the node enters the scene tree for the first time.
func _ready():
	# get campaign from url
	var url_cc = RumpusReq.get_user_campaign_from_param()
	if url_cc != null:
		LevelOrbs.load_user_campaign_from_json(url_cc)
		StartUIText.text = "Campaign: " + url_cc.campaignName + " by " + url_cc.creatorName
	else:
		StartMenu.load_saved_campaigns(LevelOrbs.get_all_saved_campaigns())
		StartMenu.show()
	if OS.has_feature("HTML5") and OS.has_feature("JavaScript"):
		JavaScript.eval("console.log('I am running on a browser!')")

# start button builds all paths
func _on_StartButton_pressed():
	Connections.make_all_paths()
	var startPos = LevelOrbs.find_start_orb()
	SpaceShip.current_orb = startPos
	SpaceShip.calculate_possible_movement()
	for level in LevelOrbs.get_all_level_orbs():
		level.check_unlock()
		if level.is_first_level():
			emit_signal("update_ui", level)
	
	if startPos != null:
		SpaceShip.position = startPos.position
	StartUI.hide()

## Completion Checkmarks

func _on_CompletedCheck_toggled(button_pressed):
	# de-completing is buggy and thus not allowed
	if !button_pressed:
		return
	var curr_lvl = SpaceShip.current_orb
	if curr_lvl != null:
		curr_lvl.level_completed = button_pressed
		LevelOrbs.update_unlocks_after_level(curr_lvl.levelID)
		SpaceShip.calculate_possible_movement()
		Connections.refresh_all_paths()


func _on_AllJems_toggled(button_pressed):
	if !button_pressed:
		return
	var curr_lvl = SpaceShip.current_orb
	if curr_lvl != null:
		curr_lvl.level_all_jems = button_pressed
		LevelOrbs.update_unlocks_after_level(curr_lvl.levelID)
		SpaceShip.calculate_possible_movement()
		Connections.refresh_all_paths()


func _on_AllBugs_toggled(button_pressed):
	if !button_pressed:
		return
	var curr_lvl = SpaceShip.current_orb
	if curr_lvl != null:
		curr_lvl.level_all_bug_pieces = button_pressed
		LevelOrbs.update_unlocks_after_level(curr_lvl.levelID)
		SpaceShip.calculate_possible_movement()
		Connections.refresh_all_paths()


func _on_Benchmark_toggled(button_pressed): #ToDo: how are benchmarks handled?
	if !button_pressed:
		return
	var curr_lvl = SpaceShip.current_orb
	if curr_lvl != null:
		curr_lvl.level_completed = button_pressed
		LevelOrbs.update_unlocks_after_level(curr_lvl.levelID)
		SpaceShip.calculate_possible_movement()
		Connections.refresh_all_paths()


func _on_FoundGR17_toggled(button_pressed):
	if !button_pressed:
		return
	var curr_lvl = SpaceShip.current_orb
	if curr_lvl != null:
		curr_lvl.level_found_gr17 = button_pressed
		LevelOrbs.update_unlocks_after_level(curr_lvl.levelID)
		SpaceShip.calculate_possible_movement()
		Connections.refresh_all_paths()

## When a level is selected in the start menu

func _on_BaseUI_load_campaign_from_start_menu(campaign):
	LevelOrbs.load_user_campaign_from_json(campaign)
	StartUIText.text = "Campaign: " + campaign.campaignName + " by " + campaign.creatorName
	StartMenu.hide()
