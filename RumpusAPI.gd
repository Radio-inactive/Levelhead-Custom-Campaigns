## Used to make requests to the Rumpus API
extends Node

var delegation_key : String = "NOKEY"

# get interfaces from Javascript
var console = JavaScript.get_interface("console")
var window = JavaScript.get_interface("window")
var url_params = JavaScript.get_interface("URLSearchParams")

func _ready():
	# Check if on browser. if so, get delegation key
	if OS.has_feature("HTML5") and OS.has_feature("JavaScript"):
		# gets the delegation key from the local storage of the site it is run on.
		# on the levelkit.netlify.app site, the delegation key is set in the site settings
		if window.localStorage.getItem('DelegationKey') != null:
			var js_user_data = parse_json(window.localStorage.getItem('DelegationKey'))
			delegation_key = js_user_data.Key
			console.log(delegation_key)
		else:
			console.log("DelegationKey not found")
	else:
		print("NO HTML5 AND/OR JS")
		print(delegation_key)

func get_level_info(level_code : String):
	var req = RumpusURL.url_tower_levels.new()
	print(req.get_url())
	#ToDo: Implement request

func get_user_campaign_from_param():
	var param = JavaScript.eval("""
	var url_string = window.location;
	var url = new URL(url_string);
	url.searchParams.get('userCampaign')
	""")
	if param != null:
		param = parse_json(param)
		return param
	else:
		return null

########## BOOKMARKS

signal bookmark_set_result(result, response_code, headers, body)

func set_bookmark(level_code : String, set : bool):
	if delegation_key == "NOKEY":
		emit_signal("bookmark_set_result", 1, null, null, null)
		return
	if set:
		$BookmarkSet.request(RumpusURL.bookmark_url([level_code]),["Rumpus-Delegation-Key:" + delegation_key], true, HTTPClient.METHOD_PUT)
	else:
		$BookmarkSet.request(RumpusURL.bookmark_url([level_code]),["Rumpus-Delegation-Key:" + delegation_key], true, HTTPClient.METHOD_DELETE)


func _on_BookmarkSet_request_completed(result, response_code, headers, body):
	emit_signal("bookmark_set_result", result, response_code, headers, body)


func _on_LevelInfo_current_level_bookmark(level_code, set):
	set_bookmark(level_code, set)

