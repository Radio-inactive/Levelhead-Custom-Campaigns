extends Control

onready var CampaignTitle := $VBoxContainer/CampaignTitle/Label
onready var SavedCampaigns := $VBoxContainer/HBoxContainer/Menu/Campaigns/SavedLevelsContainer/SavedLevelsContainer/Campaigns
onready var FileLoad := $FileLoad
onready var FileLoadMessage := $FileLoad/PanelContainer/VBoxContainer/Message
onready var LoadCampaignButton := $"VBoxContainer/Load Campaign"
onready var TextFileLoad := $FileLoad/PanelContainer/VBoxContainer/Text
onready var FromFileButton := $FileLoad/PanelContainer/VBoxContainer/FromFile

export var HIDE_RETURN_ON_START_FLAG := true

var fileInput

var delegation_key_present : bool setget set_delegation_key_warnig

var js_document := JavaScript.get_interface("document")
var js_url := JavaScript.get_interface("URL")

func set_delegation_key_warnig(vis : bool):
	$VBoxContainer/HBoxContainer/Logo/PanelContainer.visible = vis
	delegation_key_present = vis

signal load_campaign_from_start_menu(campaign, override_existing)

func load_saved_campaigns(campaigns : Array):
	LoadCampaignButton.disabled = true
	SavedCampaigns.clear()
	for campaign in campaigns:
		if "creatorName" in campaign:
			SavedCampaigns.add_item(campaign.campaignName)
			SavedCampaigns.set_item_metadata(SavedCampaigns.get_item_count()-1, campaign)
		else:
			SavedCampaigns.add_item("Unknown Creator")
			SavedCampaigns.set_item_metadata(SavedCampaigns.get_item_count()-1, campaign)
	CampaignTitle.text = ""

func show_return():
	$Return.show()

func _on_Campaigns_item_selected(index):
	LoadCampaignButton.disabled = false
	if "campaignName" in SavedCampaigns.get_item_metadata(index):
		CampaignTitle.text = SavedCampaigns.get_item_metadata(index).campaignName + " by " + SavedCampaigns.get_item_metadata(index).creatorName
	else:
		CampaignTitle.text = "No Title."
	

func _on_Campaigns_item_activated(index):
	emit_signal("load_campaign_from_start_menu", SavedCampaigns.get_item_metadata(index))
	show_return()

func _on_Return_pressed():
	hide()

var fileCallback = JavaScript.create_callback(self, "handle_file")
var fileReader = JavaScript.create_object("FileReader")
var fileReader_succ_callback = JavaScript.create_callback(self, "file_load_succ")
var fileReader_fail_callback = JavaScript.create_callback(self, "file_load_fail")

func _ready():
	if HIDE_RETURN_ON_START_FLAG:
		$Return.hide()
	# instantiate necessary vars for file upload
	if OS.has_feature("HTML5") and OS.has_feature("JavaScript"):
		fileInput = JavaScript.get_interface("document").createElement("input")
		fileInput.type = "file"
		fileInput.accept=".json"
		fileInput.addEventListener('change', fileCallback)
		fileReader.onload = fileReader_succ_callback
		fileReader.onerror = fileReader_fail_callback
		
	else:
		FromFileButton.hide()

# load from JSON file upload

func handle_file(event):
	print("handle file works!")
	fileReader.readAsText(fileInput.files[0])

func file_load_fail(event):
	print("file load fail works!")
	FileLoadMessage.text = "LOAD FAILED"
	FileLoadMessage.show()

func file_load_succ(event):
	print("file load succ works!")
	var campaign_clip = JSON.parse(fileReader.result)
	if campaign_clip.error == OK:
		campaign_clip = campaign_clip.result
		if campaign_clip.has("campaignName") and campaign_clip.has("creatorCode"):
			print(campaign_clip)
			emit_signal("load_campaign_from_start_menu", campaign_clip, true)
			FileLoad.hide()
	else:
		FileLoadMessage.text = "LOAD FAILED"
		FileLoadMessage.show()

# download file

func get_lhcc_id() -> String:
	return "LHCC_" + lhcc.campaignName + "_" + lhcc.creatorCode

func download_lhcc_progress():
	var camp := Util.get_file(get_lhcc_id(), "SavedCampaigns/Saved/")
	if !camp:
		return
	print(camp)
	var blob = JavaScript.create_object("Blob", JavaScript.create_object("Array", camp), { "type": "application/json" })
	var a_elem = js_document.createElement("a")
	a_elem.href = js_url.createObjectURL(blob);
	a_elem.download = get_lhcc_id() + ".json";
	
	a_elem.click()

# FILE LOADING

func _on_Load_pressed():
	FileLoad.show()
	FileLoadMessage.hide()

func _on_Clipboard_pressed():
	var campaign_clip = JSON.parse(OS.clipboard)
	if campaign_clip.error == OK:
		campaign_clip = campaign_clip.result
		if campaign_clip.has("campaignName") and campaign_clip.has("creatorCode"):
			emit_signal("load_campaign_from_start_menu", campaign_clip)
			FileLoad.hide()
	else:
		FileLoadMessage.text = "LOAD FAILED"
		FileLoadMessage.show()

func _on_Close_pressed():
	FileLoad.hide()
	TextFileLoad.text = ""


func _on_Load_Campaign_pressed():
	var selected_item : int = SavedCampaigns.get_selected_items()[0]
	emit_signal("load_campaign_from_start_menu", SavedCampaigns.get_item_metadata(selected_item))
	show_return()


func _on_FromText_pressed():
	var campaign_clip = JSON.parse(TextFileLoad.text)
	if campaign_clip.error == OK:
		campaign_clip = campaign_clip.result
		if campaign_clip.has("campaignName") and campaign_clip.has("creatorCode"):
			emit_signal("load_campaign_from_start_menu", campaign_clip)
			FileLoad.hide()
	else:
		FileLoadMessage.text = "LOAD FAILED"
		FileLoadMessage.show()


func _on_FromFile_pressed():
	fileInput.click()

func _on_load_pressed():
	fileInput.click()

func _on_LoadLHCC_pressed():
	emit_signal("load_campaign_from_start_menu", lhcc)
	show_return()

const lhcc : Dictionary = {
	"is_lhcc":true,
	"mapNodes": [
		{
			"t": 0,
			"scpost": 0,
			"pre_gr18": 0,
			"n": "\"Power Extract\" by Kalhua",
			"pre_all": 0,
			"pre_coin": 0,
			"bm": 0,
			"ch": 1,
			"gr18": 1,
			"levelID": "tz051h8",
			"scpre": 0,
			"x": 424,
			"y": -195,
			"main": 1,
			"pre_chall": 0,
			"scale": 1,
			"pre": [
				"6k5pvv0"
			],
			"weather": 0,
			"sc": 0,
			"b_time": 75
		},
		{
			"t": 0,
			"scpost": 0,
			"pre_gr18": 0,
			"n": "\"Space Spark\" by Pawlogates",
			"pre_all": 0,
			"pre_coin": 0,
			"bm": 3,
			"ch": 1,
			"gr18": 1,
			"levelID": "64p02sf",
			"scpre": 0,
			"x": 560,
			"y": -2159,
			"main": 1,
			"pre_chall": 0,
			"scale": 0.9,
			"pre": [
				"30sfcgk"
			],
			"weather": 1,
			"sc": 0,
			"b_time": 180
		},
		{
			"t": 0,
			"scpost": 0,
			"pre_gr18": 0,
			"n": "\"Big Brain Time\" by Glorious Cashew",
			"pre_all": 0,
			"pre_coin": 0,
			"bm": 0,
			"ch": 0,
			"gr18": 0,
			"levelID": "4p35222",
			"scpre": 1,
			"x": 263,
			"y": -1541,
			"main": 0,
			"pre_chall": 0,
			"scale": 0.4,
			"pre": [
				"64p02sf"
			],
			"weather": 0,
			"sc": 0,
			"b_time": 32
		},
		{
			"t": 0,
			"scpost": 0,
			"pre_gr18": 0,
			"n": "\"Rip The Sky\" by Fr75s",
			"pre_all": 0,
			"pre_coin": 0,
			"bm": 0,
			"ch": 1,
			"gr18": 1,
			"levelID": "p30mfks",
			"scpre": 0,
			"x": -664,
			"y": 175,
			"main": 1,
			"pre_chall": 0,
			"scale": 0.75121951219512,
			"pre": [
				"50zz4sm"
			],
			"weather": 0,
			"sc": 0,
			"b_time": 32
		},
		{
			"t": 0,
			"scpost": 0,
			"pre_gr18": 0,
			"n": "\"Blopsack Bounce\" by iLoveKitties",
			"pre_all": 0,
			"pre_coin": 1,
			"bm": 0,
			"ch": 1,
			"gr18": 1,
			"levelID": "b5jfb0x",
			"scpre": 1,
			"x": -944,
			"y": -222,
			"main": 0,
			"pre_chall": 0,
			"scale": 0.77170731707317,
			"pre": [
				"p30mfks"
			],
			"weather": 0,
			"sc": 0,
			"b_time": 45
		},
		{
			"t": 0,
			"scpost": 0,
			"pre_gr18": 1,
			"n": "\"Palace Of Action Illusion\" by Dearg Doom",
			"pre_all": 0,
			"pre_coin": 0,
			"bm": 1,
			"ch": 0,
			"gr18": 0,
			"levelID": "46p1c4k",
			"scpre": 1,
			"x": 1693,
			"y": 233,
			"main": 0,
			"pre_chall": 0,
			"scale": 0.80975609756098,
			"pre": [
				"v27r60z"
			],
			"weather": 0,
			"sc": 0,
			"b_time": 35
		},
		{
			"t": 0,
			"scpost": 0,
			"pre_gr18": 0,
			"n": "\"Lost Ruins\" by BAITness",
			"pre_all": 0,
			"pre_coin": 0,
			"bm": 1,
			"ch": 1,
			"gr18": 1,
			"levelID": "0mxrts3",
			"scpre": 1,
			"x": 1962,
			"y": 544,
			"main": 0,
			"pre_chall": 0,
			"scale": 0.9,
			"pre": [
				"46p1c4k"
			],
			"weather": 0,
			"sc": 0,
			"b_time": 150
		},
		{
			"t": 0,
			"scpost": 0,
			"pre_gr18": 0,
			"n": "\"Blopfush Blaster\" by Reaun Da Crayon",
			"pre_all": 0,
			"pre_coin": 0,
			"bm": 1,
			"ch": 1,
			"gr18": 0,
			"levelID": "g0nkgqt",
			"scpre": 1,
			"x": 3132,
			"y": 280,
			"main": 0,
			"pre_chall": 1,
			"scale": 0.5,
			"pre": [
				"0q54834"
			],
			"weather": 0,
			"sc": 0,
			"b_time": 70
		},
		{
			"t": 0,
			"scpost": 0,
			"pre_gr18": 0,
			"n": "\"The Peanut Of Doom.\" by ICErovTERROR",
			"pre_all": 0,
			"pre_coin": 0,
			"bm": 0,
			"ch": 0,
			"gr18": 0,
			"levelID": "gz3j0ph",
			"scpre": 0,
			"x": 162,
			"y": -793,
			"main": 1,
			"pre_chall": 0,
			"scale": 0.6,
			"pre": [
				"1v0m021"
			],
			"weather": 0,
			"sc": 0,
			"b_time": 80
		},
		{
			"t": 0,
			"scpost": 0,
			"pre_gr18": 0,
			"n": "\"Temple Of Shade\" by Maoy",
			"pre_all": 0,
			"pre_coin": 0,
			"bm": 1,
			"ch": 1,
			"gr18": 0,
			"levelID": "0ddb18m",
			"scpre": 1,
			"x": 1114,
			"y": -943,
			"main": 1,
			"pre_chall": 0,
			"scale": 0.56682926829268,
			"pre": [
				"gz3j0ph"
			],
			"weather": 0,
			"sc": 0,
			"b_time": 42
		},
		{
			"t": 0,
			"scpost": 0,
			"pre_gr18": 0,
			"n": "\"The Jabber Run\" by Fr75s",
			"pre_all": 0,
			"pre_coin": 0,
			"bm": 1,
			"ch": 1,
			"gr18": 1,
			"levelID": "bb1v39n",
			"scpre": 0,
			"x": 2536,
			"y": -578,
			"main": 1,
			"pre_chall": 0,
			"scale": 0.6,
			"pre": [
				"wjwk1zj"
			],
			"weather": 0,
			"sc": 0,
			"b_time": 28
		},
		{
			"t": 0,
			"scpost": 0,
			"pre_gr18": 1,
			"n": "\"Peanut Temple Puzzle\" by SpyRay",
			"pre_all": 0,
			"pre_coin": 0,
			"bm": 2,
			"ch": 1,
			"gr18": 1,
			"levelID": "fdbdq8k",
			"scpre": 1,
			"x": 3336,
			"y": -2671,
			"main": 0,
			"pre_chall": 0,
			"scale": 0.64,
			"pre": [
				"fqx7njd"
			],
			"weather": 1,
			"sc": 0,
			"b_time": 135
		},
		{
			"t": 0,
			"scpost": 0,
			"pre_gr18": 0,
			"n": "\"Mound About Mountain\" by PureKnix",
			"pre_all": 0,
			"pre_coin": 0,
			"bm": 2,
			"ch": 1,
			"gr18": 1,
			"levelID": "fqx7njd",
			"scpre": 0,
			"x": 2850,
			"y": -2534,
			"main": 1,
			"pre_chall": 0,
			"scale": 0.7,
			"pre": [
				"2zrmd5n"
			],
			"weather": 0,
			"sc": 0,
			"b_time": 70
		},
		{
			"t": 0,
			"scpost": 0,
			"pre_gr18": 0,
			"n": "\"Rebound Palace\" by SupervillainLex",
			"pre_all": 0,
			"pre_coin": 0,
			"bm": 3,
			"ch": 0,
			"gr18": 0,
			"levelID": "gf0nm05",
			"scpre": 0,
			"x": 91,
			"y": -2034,
			"main": 1,
			"pre_chall": 0,
			"scale": 0.8,
			"pre": [
				"64p02sf"
			],
			"weather": 0,
			"sc": 0,
			"b_time": 75
		},
		{
			"t": 0,
			"scpost": 0,
			"pre_gr18": 0,
			"n": "\"Shady Cannon Canyon\" by Arity",
			"pre_all": 0,
			"pre_coin": 0,
			"bm": 1,
			"ch": 1,
			"gr18": 1,
			"levelID": "568wt38",
			"scpre": 0,
			"x": 1460,
			"y": -734,
			"main": 1,
			"pre_chall": 0,
			"scale": 0.79512195121951,
			"pre": [
				"0ddb18m"
			],
			"weather": 0,
			"sc": 0,
			"b_time": 65
		},
		{
			"t": 0,
			"scpost": 0,
			"pre_gr18": 0,
			"n": "\"Solid Steel Structure\" by Nanomical",
			"pre_all": 0,
			"pre_coin": 0,
			"bm": 1,
			"ch": 1,
			"gr18": 1,
			"levelID": "0q54834",
			"scpre": 0,
			"x": 3371,
			"y": -148,
			"main": 1,
			"pre_chall": 0,
			"scale": 0.47317073170732,
			"pre": [
				"8kpdh0p"
			],
			"weather": 0,
			"sc": 0,
			"b_time": 45
		},
		{
			"t": 0,
			"scpost": 0,
			"pre_gr18": 0,
			"n": "\"Ramshackle Bridge\" by Maoy",
			"pre_all": 0,
			"pre_coin": 0,
			"bm": 0,
			"ch": 1,
			"gr18": 1,
			"levelID": "ckcpzb0",
			"scpre": 0,
			"x": -1301,
			"y": 525,
			"main": 1,
			"pre_chall": 0,
			"scale": 0.7,
			"pre": [],
			"weather": 0,
			"sc": 0,
			"b_time": 35
		},
		{
			"t": 0,
			"scpost": 0,
			"pre_gr18": 0,
			"n": "\"Cliff Cavern Island\" by Kalhua",
			"pre_all": 0,
			"pre_coin": 0,
			"bm": 1,
			"ch": 1,
			"gr18": 1,
			"levelID": "s1xrg4v",
			"scpre": 0,
			"x": 1710,
			"y": -309,
			"main": 1,
			"pre_chall": 0,
			"scale": 1,
			"pre": [
				"568wt38"
			],
			"weather": 0,
			"sc": 0,
			"b_time": 50
		},
		{
			"t": 0,
			"scpost": 0,
			"pre_gr18": 0,
			"n": "\"Forgotten Fissure\" by TheViralMelon",
			"pre_all": 0,
			"pre_coin": 0,
			"bm": 3,
			"ch": 0,
			"gr18": 1,
			"levelID": "wc5dkk5",
			"scpre": 1,
			"x": 1385,
			"y": -1759,
			"main": 0,
			"pre_chall": 1,
			"scale": 0.6,
			"pre": [
				"f1v0h1c"
			],
			"weather": 0,
			"sc": 0,
			"b_time": 35
		},
		{
			"t": 0,
			"scpost": 0,
			"pre_gr18": 0,
			"n": "\"Ride Star Ridge\" by PureKnix",
			"pre_all": 0,
			"pre_coin": 0,
			"bm": 2,
			"ch": 1,
			"gr18": 1,
			"levelID": "0bsmn4f",
			"scpre": 0,
			"x": 2083,
			"y": -2817,
			"main": 1,
			"pre_chall": 0,
			"scale": 0.9,
			"pre": [
				"5990bm2"
			],
			"weather": 0,
			"sc": 0,
			"b_time": 90
		},
		{
			"t": 0,
			"scpost": 0,
			"pre_gr18": 0,
			"n": "\"Storm The Gateway\" by Glorious Cashew",
			"pre_all": 1,
			"pre_coin": 0,
			"bm": 0,
			"ch": 0,
			"gr18": 1,
			"levelID": "1v0m021",
			"scpre": 0,
			"x": -20,
			"y": -439,
			"main": 1,
			"pre_chall": 0,
			"scale": 0.6,
			"pre": [
				"6ss0v4j",
				"tz051h8",
				"4wvn070"
			],
			"weather": 0,
			"sc": 0,
			"b_time": 45
		},
		{
			"t": 0,
			"scpost": 0,
			"pre_gr18": 0,
			"n": "\"Tower Dark\" by Slothybutt",
			"pre_all": 0,
			"pre_coin": 0,
			"bm": 3,
			"ch": 0,
			"gr18": 0,
			"levelID": "fgl2p0c",
			"scpre": 0,
			"x": -507,
			"y": -2584,
			"main": 1,
			"pre_chall": 0,
			"scale": 0.7,
			"pre": [
				"j8x4fzp"
			],
			"weather": 0,
			"sc": 0,
			"b_time": 60
		},
		{
			"t": 0,
			"scpost": 0,
			"pre_gr18": 0,
			"n": "\"Warm Room\" by Slothybutt",
			"pre_all": 0,
			"pre_coin": 1,
			"bm": 3,
			"ch": 0,
			"gr18": 0,
			"levelID": "6pxd96b",
			"scpre": 1,
			"x": -892,
			"y": -2688,
			"main": 0,
			"pre_chall": 0,
			"scale": 0.45560975609756,
			"pre": [
				"fgl2p0c"
			],
			"weather": 0,
			"sc": 0,
			"b_time": 40
		},
		{
			"t": 0,
			"scpost": 0,
			"pre_gr18": 0,
			"n": "\"Rush Into Sprint Speed!\" by Ditchen Catastrophic",
			"pre_all": 0,
			"pre_coin": 0,
			"bm": 0,
			"ch": 1,
			"gr18": 1,
			"levelID": "50zz4sm",
			"scpre": 0,
			"x": -477,
			"y": 580,
			"main": 1,
			"pre_chall": 0,
			"scale": 1,
			"pre": [
				"tz0q5gb"
			],
			"weather": 1,
			"sc": 0,
			"b_time": 50
		},
		{
			"t": 0,
			"scpost": 0,
			"pre_gr18": 0,
			"n": "\"Hop, Zap And Jump!\" by MakeJake",
			"pre_all": 0,
			"pre_coin": 0,
			"bm": 0,
			"ch": 1,
			"gr18": 1,
			"levelID": "d2228fl",
			"scpre": 0,
			"x": 15,
			"y": 559,
			"main": 1,
			"pre_chall": 0,
			"scale": 1,
			"pre": [
				"50zz4sm"
			],
			"weather": 0,
			"sc": 0,
			"b_time": 45
		},
		{
			"t": 0,
			"scpost": 0,
			"pre_gr18": 0,
			"n": "\"The Boss Is Meh!\" by Noob Jr",
			"pre_all": 0,
			"pre_coin": 0,
			"bm": 2,
			"ch": 1,
			"gr18": 1,
			"levelID": "b8xxm0k",
			"scpre": 0,
			"x": 2363,
			"y": -3158,
			"main": 1,
			"pre_chall": 0,
			"scale": 0.6,
			"pre": [
				"0bsmn4f"
			],
			"weather": 1,
			"sc": 0,
			"b_time": 90
		},
		{
			"t": 0,
			"scpost": 0,
			"pre_gr18": 0,
			"n": "\"Ouch! That Cart Hurt!\" by Mr Existent",
			"pre_all": 0,
			"pre_coin": 0,
			"bm": 3,
			"ch": 0,
			"gr18": 0,
			"levelID": "30sfcgk",
			"scpre": 1,
			"x": 1005,
			"y": -2434,
			"main": 1,
			"pre_chall": 0,
			"scale": 0.6,
			"pre": [
				"b8xxm0k"
			],
			"weather": 1,
			"sc": 0,
			"b_time": 35
		},
		{
			"t": 0,
			"scpost": 0,
			"pre_gr18": 1,
			"n": "\"Mastery Of Space-Time\" by JeanneOskoure",
			"pre_all": 0,
			"pre_coin": 0,
			"bm": 3,
			"ch": 1,
			"gr18": 0,
			"levelID": "mnw4mfm",
			"scpre": 0,
			"x": -1043,
			"y": -1957,
			"main": 0,
			"pre_chall": 0,
			"scale": 0.8,
			"pre": [
				"j8x4fzp"
			],
			"weather": 0,
			"sc": 0,
			"b_time": 360
		},
		{
			"t": 0,
			"scpost": 1,
			"pre_gr18": 0,
			"n": "\"Bump Up The Mushroom\" by Saltbearer",
			"pre_all": 0,
			"pre_coin": 0,
			"bm": 3,
			"ch": 1,
			"gr18": 1,
			"levelID": "4835f7m",
			"scpre": 1,
			"x": 70,
			"y": -2575,
			"main": 0,
			"pre_chall": 0,
			"scale": 0.6,
			"pre": [
				"gf0nm05"
			],
			"weather": 1,
			"sc": 0,
			"b_time": 90
		},
		{
			"t": 0,
			"scpost": 0,
			"pre_gr18": 0,
			"n": "\"Illusion Machine\" by Maoy",
			"pre_all": 0,
			"pre_coin": 0,
			"bm": 3,
			"ch": 1,
			"gr18": 1,
			"levelID": "qjbv3rb",
			"scpre": 0,
			"x": -238,
			"y": -3052,
			"main": 1,
			"pre_chall": 0,
			"scale": 1,
			"pre": [
				"4835f7m",
				"fgl2p0c"
			],
			"weather": 1,
			"sc": 0,
			"b_time": 180
		},
		{
			"t": 0,
			"scpost": 0,
			"pre_gr18": 0,
			"n": "\"Canoodle Land\" by KoJi",
			"pre_all": 0,
			"pre_coin": 0,
			"bm": 0,
			"ch": 1,
			"gr18": 1,
			"levelID": "tz0q5gb",
			"scpre": 0,
			"x": -897,
			"y": 516,
			"main": 1,
			"pre_chall": 0,
			"scale": 0.51121951219512,
			"pre": [
				"ckcpzb0"
			],
			"weather": 1,
			"sc": 0,
			"b_time": 40
		},
		{
			"t": 0,
			"scpost": 0,
			"pre_gr18": 0,
			"n": "\"The Incredible Shade!\" by MakeJake",
			"pre_all": 0,
			"pre_coin": 0,
			"bm": 3,
			"ch": 1,
			"gr18": 1,
			"levelID": "f1v0h1c",
			"scpre": 0,
			"x": 1968,
			"y": -1910,
			"main": 1,
			"pre_chall": 0,
			"scale": 0.9,
			"pre": [
				"09lrbv2"
			],
			"weather": 0,
			"sc": 0,
			"b_time": 155
		},
		{
			"t": 0,
			"scpost": 0,
			"pre_gr18": 0,
			"n": "\"Ninja Rope Rise!\" by Green0ne",
			"pre_all": 1,
			"pre_coin": 0,
			"bm": 2,
			"ch": 1,
			"gr18": 1,
			"levelID": "5990bm2",
			"scpre": 0,
			"x": 2183,
			"y": -2333,
			"main": 1,
			"pre_chall": 0,
			"scale": 0.9,
			"pre": [
				"f1v0h1c",
				"fqx7njd"
			],
			"weather": 1,
			"sc": 0,
			"b_time": 70
		},
		{
			"t": 0,
			"scpost": 0,
			"pre_gr18": 0,
			"n": "\"Dark Peak Castle\" by JeanneOskoure",
			"pre_all": 0,
			"pre_coin": 0,
			"bm": 3,
			"ch": 1,
			"gr18": 1,
			"levelID": "j8x4fzp",
			"scpre": 0,
			"x": -529,
			"y": -2047,
			"main": 1,
			"pre_chall": 0,
			"scale": 1,
			"pre": [
				"gf0nm05"
			],
			"weather": 0,
			"sc": 0,
			"b_time": 180
		},
		{
			"t": 0,
			"scpost": 0,
			"pre_gr18": 0,
			"n": "\"The Super-Jump Experience\" by Omnikar",
			"pre_all": 0,
			"pre_coin": 0,
			"bm": 2,
			"ch": 0,
			"gr18": 0,
			"levelID": "2tst0m5",
			"scpre": 1,
			"x": 2869,
			"y": -1655,
			"main": 1,
			"pre_chall": 0,
			"scale": 0.7,
			"pre": [
				"mr12qh0"
			],
			"weather": 0,
			"sc": 0,
			"b_time": 40
		},
		{
			"t": 0,
			"scpost": 0,
			"pre_gr18": 0,
			"n": "\"The Grand Ascent\" by DFI01",
			"pre_all": 0,
			"pre_coin": 0,
			"bm": 2,
			"ch": 1,
			"gr18": 1,
			"levelID": "2zrmd5n",
			"scpre": 0,
			"x": 2892,
			"y": -2079,
			"main": 1,
			"pre_chall": 0,
			"scale": 0.9,
			"pre": [
				"2tst0m5"
			],
			"weather": 1,
			"sc": 0,
			"b_time": 135
		},
		{
			"t": 0,
			"scpost": 0,
			"pre_gr18": 0,
			"n": "\"Void Blossom Curse\" by Green0ne",
			"pre_all": 0,
			"pre_coin": 0,
			"bm": 1,
			"ch": 1,
			"gr18": 1,
			"levelID": "wjwk1zj",
			"scpre": 0,
			"x": 2089,
			"y": -552,
			"main": 1,
			"pre_chall": 0,
			"scale": 0.88,
			"pre": [
				"s1xrg4v"
			],
			"weather": 0,
			"sc": 0,
			"b_time": 90
		},
		{
			"t": 0,
			"scpost": 0,
			"pre_gr18": 0,
			"n": "\"Rebound Up The Tower!\" by Radio Inactive",
			"pre_all": 0,
			"pre_coin": 0,
			"bm": 0,
			"ch": 1,
			"gr18": 1,
			"levelID": "s70td0k",
			"scpre": 0,
			"x": 438,
			"y": 624,
			"main": 1,
			"pre_chall": 0,
			"scale": 0.65756097560976,
			"pre": [
				"d2228fl"
			],
			"weather": 0,
			"sc": 0,
			"b_time": 80
		},
		{
			"t": 0,
			"scpost": 0,
			"pre_gr18": 0,
			"n": "\"Power Planet Destroy\" by joejoecraft",
			"pre_all": 0,
			"pre_coin": 0,
			"bm": 0,
			"ch": 0,
			"gr18": 0,
			"levelID": "6ss0v4j",
			"scpre": 0,
			"x": -461,
			"y": -270,
			"main": 1,
			"pre_chall": 0,
			"scale": 0.49073170731707,
			"pre": [
				"p30mfks"
			],
			"weather": 0,
			"sc": 0,
			"b_time": 210
		},
		{
			"t": 0,
			"scpost": 0,
			"pre_gr18": 0,
			"n": "\"Dangerous Elevator Business\" by SupervillainLex",
			"pre_all": 0,
			"pre_coin": 0,
			"bm": 1,
			"ch": 1,
			"gr18": 1,
			"levelID": "wg06h3x",
			"scpre": 0,
			"x": 3493,
			"y": -565,
			"main": 1,
			"pre_chall": 0,
			"scale": 0.8,
			"pre": [
				"0q54834"
			],
			"weather": 0,
			"sc": 0,
			"b_time": 50
		},
		{
			"t": 0,
			"scpost": 0,
			"pre_gr18": 0,
			"n": "\"Vacrat High Way\" by ICErovTERROR",
			"pre_all": 1,
			"pre_coin": 0,
			"bm": 1,
			"ch": 1,
			"gr18": 1,
			"levelID": "8kpdh0p",
			"scpre": 0,
			"x": 2873,
			"y": -287,
			"main": 1,
			"pre_chall": 0,
			"scale": 1,
			"pre": [
				"bb1v39n",
				"8qzl087"
			],
			"weather": 1,
			"sc": 0,
			"b_time": 70
		},
		{
			"t": 0,
			"scpost": 0,
			"pre_gr18": 0,
			"n": "\"The Forgotten Factory\" by DomoZam",
			"pre_all": 0,
			"pre_coin": 0,
			"bm": 0,
			"ch": 1,
			"gr18": 1,
			"levelID": "6k5pvv0",
			"scpre": 0,
			"x": 626,
			"y": 275,
			"main": 1,
			"pre_chall": 0,
			"scale": 0.80390243902439,
			"pre": [
				"s70td0k"
			],
			"weather": 1,
			"sc": 0,
			"b_time": 47
		},
		{
			"t": 0,
			"scpost": 0,
			"pre_gr18": 1,
			"n": "\"Destruction Plateau Climb\" by ICErovTERROR",
			"pre_all": 0,
			"pre_coin": 0,
			"bm": 0,
			"ch": 1,
			"gr18": 0,
			"levelID": "nxbd4wc",
			"scpre": 1,
			"x": 996,
			"y": 470,
			"main": 0,
			"pre_chall": 0,
			"scale": 0.8,
			"pre": [
				"6k5pvv0"
			],
			"weather": 0,
			"sc": 0,
			"b_time": 150
		},
		{
			"t": 0,
			"scpost": 0,
			"pre_gr18": 0,
			"n": "\"Laser Power Switch\" by WaddlesTNT",
			"pre_all": 0,
			"pre_coin": 0,
			"bm": 0,
			"ch": 1,
			"gr18": 1,
			"levelID": "4wvn070",
			"scpre": 0,
			"x": -21,
			"y": 80,
			"main": 1,
			"pre_chall": 0,
			"scale": 0.76585365853659,
			"pre": [
				"d2228fl"
			],
			"weather": 0,
			"sc": 0,
			"b_time": 65
		},
		{
			"t": 0,
			"scpost": 0,
			"pre_gr18": 0,
			"n": "\"Rip, Rise, And Zap\" by SupervillainLex",
			"pre_all": 0,
			"pre_coin": 0,
			"bm": 2,
			"ch": 0,
			"gr18": 0,
			"levelID": "09lrbv2",
			"scpre": 0,
			"x": 2476,
			"y": -1898,
			"main": 1,
			"pre_chall": 0,
			"scale": 0.7,
			"pre": [
				"2zrmd5n"
			],
			"weather": 0,
			"sc": 0,
			"b_time": 40
		},
		{
			"t": 0,
			"scpost": 0,
			"pre_gr18": 0,
			"n": "\"Vacsteak Dance Desert\" by MakeJake",
			"pre_all": 0,
			"pre_coin": 1,
			"bm": 1,
			"ch": 1,
			"gr18": 1,
			"levelID": "ff2jgwx",
			"scpre": 1,
			"x": 2481,
			"y": -1342,
			"main": 0,
			"pre_chall": 0,
			"scale": 1,
			"pre": [
				"2tst0m5"
			],
			"weather": 1,
			"sc": 0,
			"b_time": 70
		},
		{
			"t": 0,
			"scpost": 0,
			"pre_gr18": 0,
			"n": "\"Harbinger Of The End\" by Slothy Oskoure Jr",
			"pre_all": 0,
			"pre_coin": 0,
			"bm": 3,
			"ch": 0,
			"gr18": 0,
			"levelID": "xwr3jpm",
			"scpre": 0,
			"x": -252,
			"y": -3385,
			"main": 1,
			"pre_chall": 0,
			"scale": 0.7,
			"pre": [
				"qjbv3rb"
			],
			"weather": 1,
			"sc": 0,
			"b_time": 240
		},
		{
			"t": 0,
			"scpost": 0,
			"pre_gr18": 0,
			"n": "\"Void Sky Battle\" by WaddlesTNT",
			"pre_all": 0,
			"pre_coin": 0,
			"bm": 1,
			"ch": 0,
			"gr18": 0,
			"levelID": "mr12qh0",
			"scpre": 0,
			"x": 3498,
			"y": -940,
			"main": 1,
			"pre_chall": 0,
			"scale": 0.89170731707317,
			"pre": [
				"wg06h3x"
			],
			"weather": 1,
			"sc": 0,
			"b_time": 195
		},
		{
			"t": 0,
			"scpost": 0,
			"pre_gr18": 0,
			"n": "\"Abandoned Mine\" by joejoecraft",
			"pre_all": 0,
			"pre_coin": 0,
			"bm": 1,
			"ch": 1,
			"gr18": 1,
			"levelID": "v27r60z",
			"scpre": 0,
			"x": 2058,
			"y": -12,
			"main": 1,
			"pre_chall": 0,
			"scale": 0.68390243902439,
			"pre": [
				"s1xrg4v"
			],
			"weather": 0,
			"sc": 0,
			"b_time": 60
		},
		{
			"t": 0,
			"scpost": 0,
			"pre_gr18": 0,
			"n": "\"Bounce Cavern\" by FlowArt",
			"pre_all": 0,
			"pre_coin": 0,
			"bm": 1,
			"ch": 1,
			"gr18": 1,
			"levelID": "8qzl087",
			"scpre": 0,
			"x": 2537,
			"y": -40,
			"main": 1,
			"pre_chall": 0,
			"scale": 0.7,
			"pre": [
				"v27r60z"
			],
			"weather": 0,
			"sc": 0,
			"b_time": 38
		},
		{
			"t": 0,
			"scpost": 0,
			"pre_gr18": 1,
			"n": "\"Carry The Shade, GR-18!\" by Mr Existent",
			"pre_all": 0,
			"pre_coin": 0,
			"bm": 2,
			"ch": 1,
			"gr18": 1,
			"levelID": "310qt18",
			"scpre": 1,
			"x": 3338,
			"y": -1991,
			"main": 0,
			"pre_chall": 0,
			"scale": 0.53756097560976,
			"pre": [
				"2zrmd5n"
			],
			"weather": 1,
			"sc": 0,
			"b_time": 22
		},
		{
			"t": 0,
			"scpost": 0,
			"pre_gr18": 0,
			"n": "\"Beautiful Musical World\" by Glorious Cashew & Maoy",
			"pre_all": 0,
			"pre_coin": 0,
			"bm": 0,
			"ch": 1,
			"gr18": 1,
			"levelID": "804v33j",
			"scpre": 0,
			"x": -305,
			"y": -1411,
			"main": 0,
			"pre_chall": 0,
			"scale": 0.8,
			"pre": [
				"4p35222"
			],
			"weather": 1,
			"sc": 1,
			"b_time": 122
		}
	],
	"landmarks": [
		{
			"rwig_amt": -0.75,
			"elId": 15,
			"rot": 13,
			"x": 2175,
			"dep": 25,
			"y": -2219,
			"sc": 1,
			"rsp": -7.4999999999999
		},
		{
			"elId": 11,
			"rot": 12.75,
			"dep": 25,
			"y": 95,
			"x": 883.50000000909,
			"rsp": -4.5
		},
		{
			"rwig_amt": 11.625,
			"rot": 0,
			"dep": 50,
			"x": 1157,
			"rsp": 0,
			"elId": 17,
			"y": -190,
			"sc": 1,
			"rwig_spd": 0.5
		},
		{
			"rot": -3,
			"dep": 49,
			"ywig_spd": 0.33333333333333,
			"y": 40,
			"xsp": 0,
			"xwig_spd": 0.41666666666667,
			"elId": 0,
			"ywig_amt": 8.3333333333334,
			"x": 7.5000000909495,
			"sc": 0.99585416666667,
			"xwig_amt": 18.75
		},
		{
			"rot": -8,
			"ywig_amt": 6.25,
			"x": -175,
			"y": -1405,
			"xsp": 4.1666666666666,
			"elId": 4,
			"dep": 50,
			"rsp": 0,
			"ysp": 4.1666666666666,
			"xwig_amt": 12.5
		},
		{
			"xsp": 0,
			"elId": 12,
			"rot": -4,
			"dep": 45,
			"x": 1754,
			"sc": 1,
			"y": -850
		},
		{
			"rwig_amt": 0,
			"elId": 11,
			"rot": 65.5,
			"dep": 30,
			"rsp": 7.5,
			"x": 1096,
			"y": -1015
		},
		{
			"rwig_amt": 5.25,
			"rot": -10,
			"dep": 25,
			"x": -1301,
			"y": 585,
			"rwig_off": 26.25,
			"elId": 1,
			"rwig_spd": 0,
			"sc": 0.99585416666667,
			"ywig_amt": 0
		},
		{
			"elId": 8,
			"rot": 12,
			"dep": 29,
			"x": 197,
			"y": -2056
		},
		{
			"rwig_amt": 0.375,
			"elId": 7,
			"rot": -1.25,
			"dep": 44,
			"rsp": 1.5,
			"x": 905,
			"y": -2214
		},
		{
			"rot": -10,
			"dep": 71,
			"x": 376,
			"y": -469,
			"xwig_spd": 0.83333333333333,
			"elId": 3,
			"ywig_amt": 2.0833333333333,
			"sc": 0.99585416666667,
			"xwig_amt": 6.25
		},
		{
			"elId": 18,
			"rot": 0,
			"x": 483,
			"dep": 25,
			"rsp": 10.5,
			"sc": 0.99585416666667,
			"y": -617
		},
		{
			"rwig_amt": 0,
			"elId": 8,
			"rot": 17.5,
			"dep": 24,
			"rsp": -19.5,
			"x": 2886,
			"y": -287
		},
		{
			"rwig_amt": 19.875,
			"elId": 16,
			"rot": 1700,
			"x": 1358,
			"dep": 46,
			"y": -1209,
			"sc": 0.99585416666667,
			"rsp": 7.5
		},
		{
			"xsp": 0,
			"elId": 13,
			"rot": -8.75,
			"dep": 25,
			"y": -300,
			"x": -900,
			"rsp": -1.4999999999999
		},
		{
			"elId": 8,
			"rot": -18.5,
			"dep": 12,
			"y": 172,
			"x": 158,
			"rsp": 18
		}
	],
	"creatorCode": "mlf95t",
	"creatorName": "Maoy",
	"version": 12,
	"campaignName": "Community Campaign"
}




func _on_LinkButton_pressed():
	OS.shell_open('https://level-kit.netlify.app/setting/')


func _on_Button_pressed():
	download_lhcc_progress()
