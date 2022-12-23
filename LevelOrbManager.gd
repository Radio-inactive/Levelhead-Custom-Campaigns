### Manages Level Orbs
extends Node2D

onready var connections := $"../Connections"

const LevelOrb = preload("LevelOrb.gd")

var campaign_name : String = ""

func find_start_orb() -> LevelOrb:
	for level in get_children():
		if(level.is_first_level()):
			return level
	print_debug("no start level found in find_start_orb")
	return null

func get_level_by_id(levelId : String) -> LevelOrb:
	for level in get_children():
		if level.levelID == levelId:
			return level
	print_debug("no result in get_level_by_id")
	return null

#gets all level orbs following the one that belongs to the levelId
func get_following_orbs(levelId : String) -> Array:
	var levels_out : Array = []
	for level in get_children():
		if level.pre.has(levelId):
			levels_out.append(level)
	return levels_out

func update_unlocks_after_level(levelId : String) -> void:
	for level in get_following_orbs(levelId):
		level.check_unlock()


##loading and saving

func save_workshop_level_as_json():
	pass #todo

func save_user_campaign_progress():
	pass #todo

func load_workshop_from_json():
	pass #todo

func load_user_campaign_from_json(json):
	Util.delete_children(self)
	print(json)
	if "MapNodes" in json:
		for n in json["MapNodes"]:
			#todo: add support for other nodes
			var new_n = preload("res://LevelOrb.tscn").instance()
			new_n.instance_from_json(n)
			add_child(new_n)
