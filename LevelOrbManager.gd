### Manages Level Orbs
extends Node2D

onready var connections := $"../Connections"
onready var LandmarkManager := $"../LandmarkManager"
onready var Ship := $"../SpaceShip"

const LevelOrb = preload("LevelOrb.gd")
const user_campaign_base = \
{
"creatorName":"radio",
"creatorCode":"fck11l",
"campaignName":"campaign_test",
"version":1,
"mapNodes":[],
"landmarks":[],
"shipStartPosition":""
}

var window = JavaScript.get_interface("window")

export var campaignName : String = "NO CAMPAIGN NAME"
export var creatorName : String = "UNKNOWN CREATOR"
export var creatorCode : String = "NO CREATOR CODE"
export var is_lhcc : bool = false
export var version : int = 1
export var ship_start_pos : String = ""

func find_start_orb() -> LevelOrb:
	if ship_start_pos != "":
		var from_start_pos = get_level_by_id(ship_start_pos)
		if from_start_pos != null:
			return from_start_pos
	for level in get_all_level_orbs():
		if(level.is_first_level()):
			return level
	print_debug("no start level found in find_start_orb")
	return null

func get_level_by_id(levelId : String) -> LevelOrb:
	for level in get_all_level_orbs():
		if level.levelID == levelId:
			return level
	print_debug("no result in get_level_by_id. Code: " + String(levelId))
	return null

#gets all level orbs following the one that belongs to the levelId
func get_following_orbs(levelId : String) -> Array:
	var levels_out : Array = []
	for level in get_all_level_orbs():
		if level.pre.has(levelId):
			levels_out.append(level)
	return levels_out

func update_unlocks_after_level(levelId : String) -> void:
	for level in get_following_orbs(levelId):
		level.check_unlock()

func get_all_level_orbs() -> Array:
	return get_children()

##loading and saving

func get_all_saved_campaigns() -> Array:
	var campaigns_out := []
	campaigns_out = Util.get_files_that_match_uc("SavedCampaigns/Saved/")
	return campaigns_out

func get_campaign_id(type : String = "UC_") -> String:
	return type + campaignName + "_" + creatorCode

func get_levels_as_dict_arr() -> Array:
	var arr_out := []
	for level in get_children():
		if level.has_method("to_dictionary"):
			arr_out.append(level.to_dictionary())
	return arr_out

func save_workshop_campaign_as_json():
	pass #todo

func load_workshop_from_json():
	pass #todo

# Name in Browser local Storage: UC_<campaignName>_<creatorCode>
# File name: UC_<campaignName>_<creatorCode>.json
func save_user_campaign(type : String = "UC_"):
	var dict_out := user_campaign_base.duplicate(true)
	dict_out.campaignName = campaignName
	dict_out.creatorName = creatorName
	dict_out.creatorCode = creatorCode
	dict_out.version = version
	dict_out.mapNodes = get_levels_as_dict_arr()
	dict_out.landmarks = LandmarkManager.get_landmarks_as_dict_array()
	dict_out.shipStartPosition = Ship.current_orb.levelID if Ship.current_orb != null else ""
	if is_lhcc: type = "LHCC_"
	
	Util.set_file(get_campaign_id(type), JSON.print(dict_out), "SavedCampaigns/Saved/")
	

func apply_old_save_to_new_ver(old : Dictionary, new : Dictionary):
	if "mapNodes" in new and "mapNodes" in old:
		for new_lvl in new.mapNodes:
			for old_lvl in old.mapNodes: #todo: maybe check if values exist
				if old_lvl.levelID == new_lvl.levelID:
					new_lvl.level_completed = old_lvl.level_completed
					new_lvl.level_all_jems = old_lvl.level_all_jems
					new_lvl.level_found_gr17 = old_lvl.level_found_gr17
					new_lvl.level_all_bug_pieces = old_lvl.level_all_bug_pieces
					new_lvl.level_otd_met = old_lvl.level_otd_met
					new_lvl.level_score_bench_met = old_lvl.level_score_bench_met
	

func load_user_campaign_from_json(json, type : String = "UC_"):
	Util.delete_children(self)
	Util.delete_children(LandmarkManager)
	# get meta data from json
	campaignName = json.campaignName if "campaignName" in json else "NO NAME"
	creatorName = json.creatorName if "creatorName" in json else "ANONYMOUS"
	creatorCode = json.creatorCode if "creatorCode" in json else "NO CREATOR CODE"
	is_lhcc = "is_lhcc" in json
	if is_lhcc: type = "LHCC_"
	
	var prev_save = Util.get_file(get_campaign_id(type), "SavedCampaigns/Saved/")
	if prev_save != null && prev_save != "":
		var buf = JSON.parse(prev_save).result
		if (buf.has("version") and json.has("version")) and buf.version < json.version:
			apply_old_save_to_new_ver(buf, json)
		elif (buf.has("version") and json.has("version")) and buf.version >= json.version:
			json = buf
		ship_start_pos = json.shipStartPosition if ("shipStartPosition" in json) and (json.shipStartPosition != "") else ""
	
	# building the map
	if "version" in json: version = json.version
	# get levels
	if "mapNodes" in json:
		for n in json["mapNodes"]:
			#todo: add support for other nodes
			var new_n = preload("res://LevelOrb.tscn").instance()
			new_n.instance_from_json(n)
			add_child(new_n)
	if "landmarks" in json:
		LandmarkManager.load_landmarks_from_array(json.landmarks)
	

func _on_SaveButton_pressed():
	save_user_campaign()
