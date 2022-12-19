extends Node

var delegation_key : String = "NOKEY"

var console = JavaScript.get_interface("console")
var window = JavaScript.get_interface("window")

func _ready():
	if OS.has_feature("HTML5") and OS.has_feature("JavaScript"):
		if window.localStorage.getItem('DelegationKey') != null:
			var js_user_data = parse_json(window.localStorage.getItem('DelegationKey'))
			delegation_key = js_user_data.Key
			console.log(delegation_key)
		else:
			console.log("DelegationKey not found")

signal bookmark_set_result(result, response_code, headers, body)

func get_level_info(level_code : String):
	var req = RumpusURL.url_tower_levels.new()
	print(req.get_url())
	$BookmarkSet.request(req.get_url())

########## BOOKMARKS

func set_bookmark(level_code : String, set : bool):
	if delegation_key == "NOKEY":
		return
	if set:
		$BookmarkSet.request(RumpusURL.bookmark_url([level_code]),["Rumpus-Delegation-Key:" + delegation_key], true, HTTPClient.METHOD_PUT)
	else:
		$BookmarkSet.request(RumpusURL.bookmark_url([level_code]),["Rumpus-Delegation-Key:" + delegation_key], true, HTTPClient.METHOD_DELETE)


func _on_BookmarkSet_request_completed(result, response_code, headers, body):
	emit_signal("bookmark_set_result", result, response_code, headers, body)


func _on_LevelInfo_current_level_bookmark(level_code, set):
	set_bookmark(level_code, set)

