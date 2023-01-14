## Creates URLs to be used with the Rumpus API
extends Node

var use_beta := false

# Base class for URL-related classes that fetch levels
class URLBase:
	var params : Dictionary
	var sort_supported : PoolStringArray
	#base URL functions
	static func bscotch_net(is_api := true) -> String:
		var url_out := ""
		if RumpusURL.use_beta:
			url_out += "https://beta.bscotch.net/"
		else:
			url_out += "https://www.bscotch.net/"
		
		if is_api:
			url_out += "api/"
		
		return url_out
	
	static func levelhead_api() -> String:
		return bscotch_net() + "levelhead/"

	# returns the finished URL. Used for Level-related api calls
	func get_url():
		var url_out : String = levelhead_api() + "levels"
		var first_param := true
		#iterate through parameters
		for key in params.keys():
			if params[key] != null:
				#first parameter must be preceeded by ? instead of &
				if !first_param:
					url_out += "&"
				else:
					url_out += "?"
					first_param = false
				url_out += key + "=" + String(params[key]).to_lower()
		return url_out

## The following classes are part of levels returned by the Rumpus API

class Alias:
	var userId : String = "???"
	var alias : String = "???"
	var avatarId : String = "bureau-employee"
	var reports : int = 0
	var whitelisted : bool = false
	var anonymous : bool = false
	var context : String = ""
	
	func _init(lv_alias : Dictionary):
		Util.apply_all_dict_to_obj(lv_alias, self)

class Stats:
	var Attempts : int = 0
	var Favorites : int = 0
	var Likes : int = 0
	var PerkPoints : int = 0
	var PlayTime : float = 0
	var Players : int = 0
	var HiddenGem : int = 0
	var ReplayValue : int = 0
	var ClearRate : float = 0
	var Diamonds : int = 0
	var Successes : int = 0
	var TimePerWin : float = 0
	var ExposureBucks : int = 0
	var FailureRate : float = 0
	
	func _init(lv_stats : Dictionary):
		Util.apply_all_dict_to_obj(lv_stats, self)

class Content:
	var World : int = 0
	var Movement : int = 0
	var Puzzles : int = 0
	var Enemies : int = 0
	var Hazards : int = 0
	
	func _init(lv_content : Dictionary):
		Util.apply_all_dict_to_obj(lv_content, self)

class Record:
	var userId : String = ""
	var alias : Alias = null
	var value : float = 0
	
	func _init(lv_record : Dictionary):
		Util.apply_all_dict_to_obj(lv_record, self)

class Records:
	var HighScore : Array = []
	var FastestTime : Array = []
	
	func _init(lv_records : Dictionary):
		if lv_records.has("FastestTime"):
			for time in lv_records["FastestTime"]:
				self.FastestTime.append(Record.new(lv_records["FastestTime"]))
		if lv_records.has("HighScore"):
			for time in lv_records["HighScore"]:
				self.HighScore.append(Record.new(lv_records["HighScore"]))

class Interactions:
	var bookmarked : bool = false
	var liked : bool = false
	var favorited : bool = false
	
	func _init(lv_interactions : Dictionary):
		Util.apply_all_dict_to_obj(lv_interactions, self)

class Level:
	var _id : String = ""
	var cv : int = 0
	var levelId : String = ""
	var userId : String = ""
	var avatarId : String = "bureau-employee"
	var title : String = "???"
	var localeId : int = 0
	var locale : String = ""
	var createdAt : String = ""
	var updatedAt : String = ""
	var tower : bool = false
	var dailyBuild : bool = false
	var towerTrial : bool = false
	var requiredPlayers : int = 1
	var creatorTime : float = 0
	var gameVersion : float = 0
	var createdAgo : float = 0
	var tags : Array = []
	var tagNames : Array = []
	var content : Content = null
	var alias : Alias = null
	var stats : Stats = null
	var records : Records = null
	var interactions : Interactions = null
	
	func _init(lv : Dictionary):
		for key in lv.keys():
			if key == "alias":
				alias = Alias.new(lv[key])
			elif key == "stats":
				stats = Stats.new(lv[key])
			elif key == "records":
				records = Records.new(lv[key])
			elif key == "interactions":
				interactions = Interactions.new(lv[key])
			elif key == "content":
				content = Content.new(lv[key])
			else:
				Util.apply_to_obj_from_dict(lv, self, key)

## Level related URL classes

class TowerLevelURL extends URLBase:
	#a dictionary that contains the possible URL parameters
	
	func _init():
		params = {
		"limit" : 128,
		"tags" : "",
		"includeStats" : true,
		"includeAliases" : true,
		"includeMyInteractions" : false,
		"includeBeta" : true,
		"minPlayTime" : null,
		"maxPlayTime" : null,
		"minReplayValue" : null,
		"maxReplayValue" : null,
		"minHiddenGem" : null,
		"maxHiddenGem" : null,
		"diamonds" : null,
		"minDiamonds" : null,
		"maxDiamonds" : null,
		"minCreatedAt" : null,
		"maxCreatedAt" : null,
		"sort" : null
		}
		sort_supported = [
		"createdAt",
		"-createdAt",
		"PlayTime",
		"-PlayTime",
		"ReplayValue",
		"-ReplayValue",
		"HiddenGem",
		"-HiddenGem"
		]
	

class MDLevelURL extends URLBase:
	
	func _init():
		params = {
		"limit" : 128,
		"tags" : "",
		"includeStats" : true,
		"includeAliases" : true,
		"includeMyInteractions" : false,
		"includeBeta" : true,
		"diamonds" : null,
		"minSecondsAgo" : null,
		"maxSecondsAgo" : null,
		"minExposureBucks" : null,
		"maxExposureBucks" : null
		}
	

## URL Functions, not necessarily level related

func bookmark_url(level_list : PoolStringArray) -> String:
	var url_out = URLBase.levelhead_api() + "bookmarks/"
	for level_code in level_list:
		url_out += level_code + ","
	return url_out

## Constants, used for various things

const TAGS_ALL = [
	"ltag_brawler",
	"ltag_intense",
	"ltag_precise",
	"ltag_simple",
	"ltag_newbie",
	"ltag_musicbox",
	"ltag_complex",
	"ltag_casual",
	"ltag_paced",
	"ltag_eye",
	"ltag_secret",
	"ltag_teach",
	"ltag_clever",
	"ltag_choice",
	"ltag_kaizo",
	"ltag_contraption",
	"ltag_paths",
	"ltag_explore",
	"ltag_juicefusion",
	"ltag_elite",
	"ltag_boss",
	"ltag_onescreen",
	"ltag_electrodongle",
	"ltag_precarious",
	"ltag_powerup",
	"ltag_panic",
	"ltag_raceway",
	"ltag_pjp",
	"ltag_blasters",
	"ltag_chase",
	"ltag_puzzle",
	"ltag_faceblaster",
	"ltag_bombs",
	"ltag_throwing",
	"ltag_switch",
	"ltag_igneum",
	"ltag_shade",
	"ltag_troll",
	"ltag_traps",
	"ltag_dontmove",
	"ltag_shop"
	]


var AVATAR_TITLES := [
	"bureau-employee",
	"gr18-whistle",
	"gr18-serious",
	"gr18-woo",
	"lets-move",
	"grappler", 
	"soaring-leap",
	"sproing-slam",
	"gr18-confused",
	"gr18-dead",
	"death-vortex",
	"gr-bored",
	"gr-bonding",
	"gr-pumped",
	"gr18-sprint",
	"two-players",
	"three-players",
	"four-players",
	"jet-propulsion",
	"ripcord-n-chill",
	"copter-concentrate",
	"rebound-abyss",
	"rebound-thoughts",
	"rebound-orbs",
	"rebound-surprise",
	"rebound-awe",
	"waylay-hangtime",
	"waylay-megapunch",
	"waylay-whoa",
	"gr18-waylay",
	"zipper-party",
	"gr18-zip",
	"gr18-zipper_flip",
	"wallslide",
	"gr18-shrub",
	"shade-sense",
	"shade-rune",
	"shade-flip",
	"goal-love",
	"package", 
	"nervous-package",
	"budde-happy",
	"budde-angry",
	"cloods",
	"spookstone-screamer",
	"goo-curtain",
	"prize-time",
	"jem-gate",
	"key-door",
	"battle-gate",
	"regret",
	"powered-gate",
	"sky-wiggler",
	"trigblaster",
	"flingo-swarm",
	"toe-slider",
	"flyblock",
	"long-flyblocks",
	"bumpers",
	"puncher-gold",
	"puncher-green",
	"puncher-blue",
	"puncher-fuchsia",
	"puncher-punching",
	"puncher-diagonal",
	"rift-blue",
	"rift-gold",
	"rift-green",
	"rift-fuchsia",
	"jem-force-five",
	"peeking-jems",
	"jem-shower",
	"ripcord",
	"tiptow",
	"waylay",
	"rebound",
	"zipper",
	"shade",
	"the-armory",
	"armor-plate",
	"stackable-plate",
	"lectroshield-power",
	"dbot-surprise",
	"guardian-dbot", 
	"slurb-juice",
	"tbot-wave",
	"tbot-closeup",
	"tbot-squint",
	"stackables",
	"golden-key",
	"bomb-flash", 
	"smoky-blast",
	"vacsteak",
	"lizumi-thorns", 
	"battery",
	"whizblade-whiz",
	"whizblade-sandwich",
	"spikeblock-reveal",
	"look-up",
	"incoming-steel",
	"homing", 
	"rocket", 
	"twin-steel",
	"lookannon",
	"hot-fire",
	"wild-fire",
	"spiketrap",
	"spiketron-focus",
	"spiketron-surprise",
	"crombler",
	"crombler-rage",
	"crombler-taunt",
	"spikechain",
	"incoming-enemy",
	"security",
	"flippy-squad",
	"lever-love",
	"switch-stare",
	"huge-mistake",
	"charge-switch",
	"battle-switch",
	"battle-switch-lurker",
	"battle-switches",
	"battle-switch-smear",
	"ticking-clock",
	"countdown",
	"jem-switch",
	"keyswitch-dunk",
	"suspicious-chest",
	"chest-happiness",
	"the-watchers",
	"baddie-gaze",
	"packagecam",
	"input-switch",
	"camera-stare",
	"jingle-power",
	"weatherbox-radiance",
	"fair-weather-friend",
	"zoom-time", 
	"wacky-arrows",
	"boombox-jams",
	"jukebox",
	"gr17-sadness",
	"ejection-surprise", 
	"stranded-longing",
	"design-flaw", 
	"peace-out",
	"warp-speed", 
	"bug-hunt", 
	"employee-baby",
	"maya-smile",
	"maya-angry",
	"maya-hate-bugs",
	"debugger",
	"book-throw", 
	"noisy-robot", 
	"graduation",
	"ocula-love",
	"vacrat",
	"sleepy-vacrat",
	"scrubb-love",
	"chump-snooze",
	"ocula-friendo",
	"flipwip-hibernation",
	"flipwip-attack",
	"tripwip",
	"swoopadoop-fury",
	"drill-goose",
	"popjaw-mouth",
	"popjaw-prep",
	"flapjack",
	"lizumi",
	"lizumi-eye",
	"blopfush-album",
	"blopfush-love",
	"canoodle-charge",
	"canoodle-walk",
	"canoodle-core",
	"peanut-corner",
	"peanut-glare",
	"jabber-smear",
	"jabber-dive",
	"jibber-jaw",
	"jibber-chomp",
	"jabber-aggro",
	"jabber-swarm",
	"workshop",
	"tower",
	"bscotch",
	"bscotchseth",
	"bscotchsam",
	"bscotchadam",
	"bscotchshi",
	"bscotchsampy"
]
