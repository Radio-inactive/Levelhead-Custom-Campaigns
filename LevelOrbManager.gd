extends Node2D

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

func load_user_campaign_from_json():
	pass #todo

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
