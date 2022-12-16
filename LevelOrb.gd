extends MapEntityGeneric

onready var Manager := $".."

export(t_types) var t;
#GR-17 present
export(gr17_present) var ch : int
#bug pieces present
export(bug_pieces_present) var gr18 : int
#on-time delivery
export var b_time : float
#requires all previous levels
export(pre_all_previous_completed) var pre_all : int
#requires all previous bug pieces
export(pre_all_bug_pieces) var pre_gr18 : int
#requires all jems of previous levels
export(pre_coin_all) var pre_coin : int
#requires all GR-17s of previous levels
export(pre_chall_all) var pre_chall : int
#list of IDs of previous nodes
export var pre : PoolStringArray = ["preceeding levelIDs"]
#name of the level
export var n : String = "Level Name"
#size of the sprite in the in-game map
#export var scale : float #NOTE: ALREADY A NODE PROPERTY
var x # x-position, set by getting position from godot
var y # y-position, set by getting position from godot
export(has_weather) var weather : int
export(on_main_path) var main : int
export(bm_biome) var bm : int
export(sc_hidden) var sc : int
export(scpre_hidden) var scpre : int
export(scpost_hidden) var scpost : int

#custom variables (not part of standard level node)
export var levelID : String = "level code"
export var level_completed := false
export var level_all_jems := false
export var level_found_gr17 := false
export var level_all_bug_pieces := false

#not needed in levels:
# export var dat : String - likely not necessary for web map
# pre_actual - id of the level/presentation/icon pack at the start of this series of path nodes (only appears on path assist nodes)
# post_actual - id of the level/presentation/icon pack at the end of this series of path nodes (only appears on path assist nodes)

func is_first_level():
	return pre.size() == 0



#checks if all unlock conditions are met
func check_unlock() -> bool:
	#first level is always unlocked
	if is_first_level() == true:
		return true
	#all previous levels required
	if pre_all:
		for levelId in pre:
			var level_buf = Manager.get_level_by_id(levelId)
			if !level_buf.level_completed ||\
			   (pre_gr18 == 1 && !level_buf.level_all_bug_pieces) ||\
			   (pre_coin == 1 && !level_buf.level_all_jems) ||\
			   (pre_chall == 1 && !level_buf.level_found_gr17) \
			:
				if sc:
					hide()
				return false
		show()
		return true
	#only one previous required
	var level_buf
	for levelId in pre:
		level_buf = Manager.get_level_by_id(levelId)
		if level_buf.level_completed &&\
			   ((pre_gr18 == 1 && level_buf.level_all_bug_pieces) || pre_gr18 == 0) &&\
			   ((pre_coin == 1 && level_buf.level_all_jems) || pre_coin == 0) &&\
			   ((pre_chall == 1 && level_buf.level_found_gr17) || pre_chall == 0 )\
		:
			show()
			return true
	if sc:
		hide()
	return false



# Called when the node enters the scene tree for the first time.
func _ready():
	x = global_position.x
	y = global_position.y


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
