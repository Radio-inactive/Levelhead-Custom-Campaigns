## Parent node of the map
extends Node2D

onready var LevelOrbs := $LevelOrbs
onready var SpaceShip := $SpaceShip
onready var StartUI := $UI/PanelContainer
onready var StartUIText := $UI/PanelContainer/VBoxContainer/Label
onready var Connections := $Connections
onready var RumpusReq := $RumpusRequests
onready var StartMenu := $UI/BaseUI
onready var LevelInfo := $UI/LevelInfo
onready var CampaignStats := $UI/Stats

signal update_ui(level)

# Called when the node enters the scene tree for the first time.
func _ready():
	# get campaign from url
	var url_cc = RumpusReq.get_user_campaign_from_param()
	if url_cc != null:
		LevelOrbs.load_user_campaign_from_json(url_cc)
		StartMenu.show_return()
		StartUI.show()
		StartUIText.text = url_cc.campaignName + " by " + url_cc.creatorName
	else:
		StartMenu.load_saved_campaigns(LevelOrbs.get_all_saved_campaigns())
		StartMenu.show()
	$UI/BaseUI.delegation_key_present = RumpusReq.delegation_key == "NOKEY"

# start button builds all paths
func _on_StartButton_pressed():
	if RumpusReq.delegation_key == "NOKEY":
		LevelInfo.bookmark_button.hide()
	Connections.make_all_paths()
	var startPos = LevelOrbs.find_start_orb()
	if startPos == null:
		StartUI.hide()
		return
	SpaceShip.current_orb = startPos
	SpaceShip.position = startPos.position
	SpaceShip.calculate_possible_movement()
	emit_signal("update_ui", startPos)
	$UI/Stats.update_stats(LevelOrbs.update_statistics())
	StartUI.hide()


## Completion Checkmarks

func updateLevelProperty(property_name: String, button_pressed: bool, butt : CheckBox):
	if !button_pressed:
		return
	
	butt.disabled = true
	var curr_lvl = SpaceShip.current_orb
	if curr_lvl != null:
		curr_lvl[property_name] = button_pressed
		LevelOrbs.update_unlocks_after_level(curr_lvl.levelID)
		CampaignStats.update_stats(LevelOrbs.update_statistics())
		SpaceShip.calculate_possible_movement()
		Connections.refresh_all_paths()
		LevelOrbs.set_current_saved(false)


func _on_CompletedCheck_toggled(button_pressed):
	updateLevelProperty("level_completed", button_pressed, $UI/LevelInfo/HBoxContainer/VBoxContainer/Checks/CompletedCheck)


func _on_AllJems_toggled(button_pressed):
	updateLevelProperty("level_all_jems", button_pressed, $UI/LevelInfo/HBoxContainer/VBoxContainer/Checks/AllJems)


func _on_AllBugs_toggled(button_pressed):
	updateLevelProperty("level_all_bug_pieces", button_pressed, $UI/LevelInfo/HBoxContainer/VBoxContainer/Checks/AllBugs)


func _on_Benchmark_toggled(button_pressed):
	updateLevelProperty("level_otd_met", button_pressed, $UI/LevelInfo/HBoxContainer/VBoxContainer/Checks/Benchmark)


func _on_FoundGR17_toggled(button_pressed):
	updateLevelProperty("level_found_gr17", button_pressed, $UI/LevelInfo/HBoxContainer/VBoxContainer/Checks/FoundGR17)


func _on_score_bench_toggled(button_pressed):
	updateLevelProperty("level_score_bench_met", button_pressed, $UI/LevelInfo/HBoxContainer/VBoxContainer/Checks/score_bench)

## When a level is selected in the start menu

func _on_BaseUI_load_campaign_from_start_menu(campaign):
	LevelOrbs.load_user_campaign_from_json(campaign)
	StartUI.show()
	StartUIText.text = campaign.campaignName + " by " + campaign.creatorName
	StartMenu.hide()

func _on_Return_pressed():
	StartMenu.load_saved_campaigns(LevelOrbs.get_all_saved_campaigns())
	StartMenu.show()

