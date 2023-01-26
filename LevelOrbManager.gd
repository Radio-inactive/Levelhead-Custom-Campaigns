### Manages Level Orbs
extends Node2D

onready var connections := $"../Connections"
onready var LandmarkManager := $"../LandmarkManager"

const LevelOrb = preload("LevelOrb.gd")
const user_campaign_base = \
{
"creatorName":"radio",
"creatorCode":"fck11l",
"campaignName":"campaign_test",
"version":1,
"mapNodes":[],
"landmarks":[]
}

var window = JavaScript.get_interface("window")

var campaignName : String = "NO CAMPAIGN NAME"
var creatorName : String = "UNKNOWN CREATOR"
var creatorCode : String = "NO CREATOR CODE"
var version : int = 1

func find_start_orb() -> LevelOrb:
	for level in get_all_level_orbs():
		if(level.is_first_level()):
			return level
	print_debug("no start level found in find_start_orb")
	return null

func get_level_by_id(levelId : String) -> LevelOrb:
	for level in get_all_level_orbs():
		if level.levelID == levelId:
			return level
	print_debug("no result in get_level_by_id")
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
	var arr_out := []
	for node in get_children():
		if ("t" in node) and (node.t == 0): # 0 -> node type is "level"
			arr_out.append(node)
	return arr_out

##loading and saving

func get_all_saved_campaigns() -> Array:
	var campaigns_out := []
	campaigns_out = Util.get_files_that_match_uc("SavedCampaigns/Saved/")
	return campaigns_out

func get_campaign_id() -> String:
	return "UC_" + campaignName + "_" + creatorCode

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
func save_user_campaign():
	var dict_out := user_campaign_base.duplicate(true)
	dict_out.campaignName = campaignName
	dict_out.creatorName = creatorName
	dict_out.creatorCode = creatorCode
	dict_out.version = version
	dict_out.mapNodes = get_levels_as_dict_arr()
	dict_out.landmarks = LandmarkManager.get_landmarks_as_dict_array()
	
	Util.set_file(get_campaign_id(), JSON.print(dict_out), "SavedCampaigns/Saved/")
	 

func load_user_campaign_from_json(json):
	Util.delete_children(self)
	Util.delete_children(LandmarkManager)
	# get meta data from json
	campaignName = json.campaignName if "campaignName" in json else "NO NAME"
	creatorName = json.creatorName if "creatorName" in json else "ANONYMOUS"
	creatorCode = json.creatorCode if "creatorCode" in json else "NO CREATOR CODE"
	var prev_save = Util.get_file(get_campaign_id(), "SavedCampaigns/Saved/")
	if prev_save != null && prev_save != "":
		var buf = JSON.parse(prev_save).result
		if (buf.has("version") and json.has("version")) and buf.version >= json.version:
			json = buf
	
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
