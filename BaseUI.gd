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

func set_delegation_key_warnig(vis : bool):
	$VBoxContainer/HBoxContainer/Logo/PanelContainer.visible = vis
	delegation_key_present = vis

signal load_campaign_from_start_menu(campaign)

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
			emit_signal("load_campaign_from_start_menu", campaign_clip)
			FileLoad.hide()
	else:
		FileLoadMessage.text = "LOAD FAILED"
		FileLoadMessage.show()

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


func _on_LoadLHCC_pressed():
	emit_signal("load_campaign_from_start_menu", lhcc)
	show_return()

const lhcc : Dictionary = {
	"is_lhcc":true,
"landmarks": [
		{
			"y": -617,
			"rsp": 10.5,
			"elId": 18,
			"rot": 0,
			"x": 483,
			"dep": 25,
			"sc": 0.99585416666667
		},
		{
			"y": -190,
			"rsp": 0,
			"rwig_spd": 0.5,
			"rwig_amt": 11.625,
			"x": 1157,
			"rot": 0,
			"elId": 17,
			"dep": 50,
			"sc": 1
		},
		{
			"y": -1209,
			"rsp": 7.5,
			"rwig_amt": 19.875,
			"elId": 16,
			"rot": 1700,
			"x": 1358,
			"dep": 46,
			"sc": 0.99585416666667
		},
		{
			"y": -850,
			"xsp": 0,
			"elId": 12,
			"rot": -4,
			"x": 1754,
			"dep": 45,
			"sc": 1
		},
		{
			"y": 172,
			"rsp": 18,
			"elId": 8,
			"rot": -18.5,
			"dep": 12,
			"x": 158
		},
		{
			"y": -2219,
			"rsp": -7.4999999999999,
			"rwig_amt": -0.75,
			"elId": 15,
			"rot": 13,
			"x": 2175,
			"dep": 25,
			"sc": 1
		},
		{
			"y": -287,
			"rsp": -19.5,
			"rwig_amt": 0,
			"elId": 8,
			"rot": 17.5,
			"dep": 24,
			"x": 2886
		},
		{
			"y": -2056,
			"elId": 8,
			"rot": 12,
			"dep": 29,
			"x": 197
		},
		{
			"y": -469,
			"xwig_spd": 0.83333333333333,
			"elId": 3,
			"xwig_amt": 6.25,
			"ywig_amt": 2.0833333333333,
			"rot": -10,
			"x": 376,
			"dep": 71,
			"sc": 0.99585416666667
		},
		{
			"y": -1405,
			"rsp": 0,
			"elId": 4,
			"xwig_amt": 12.5,
			"ywig_amt": 6.25,
			"ysp": 4.1666666666666,
			"rot": -8,
			"xsp": 4.1666666666666,
			"dep": 50,
			"x": -175
		},
		{
			"y": -300,
			"rsp": -1.4999999999999,
			"elId": 13,
			"rot": -8.75,
			"xsp": 0,
			"dep": 25,
			"x": -900
		},
		{
			"y": -1015,
			"rsp": 7.5,
			"rwig_amt": 0,
			"elId": 11,
			"rot": 65.5,
			"dep": 30,
			"x": 1096
		},
		{
			"y": 585,
			"rwig_spd": 0,
			"elId": 1,
			"ywig_amt": 0,
			"rwig_amt": 5.25,
			"x": -1301,
			"rot": -10,
			"rwig_off": 26.25,
			"dep": 25,
			"sc": 0.99585416666667
		},
		{
			"y": 40,
			"xsp": 0,
			"xwig_spd": 0.41666666666667,
			"elId": 0,
			"xwig_amt": 18.75,
			"ywig_amt": 8.3333333333334,
			"x": 7.5000000909495,
			"sc": 0.99585416666667,
			"rot": -3,
			"dep": 49,
			"ywig_spd": 0.33333333333333
		},
		{
			"y": -2214,
			"rsp": 1.5,
			"rwig_amt": 0.375,
			"elId": 7,
			"rot": -1.25,
			"dep": 44,
			"x": 905
		},
		{
			"y": 95,
			"rsp": -4.5,
			"elId": 11,
			"rot": 12.75,
			"dep": 25,
			"x": 883.50000000909
		}
	],
	"creatorCode": "mlf95t",
	"campaignName": "Community Campaign",
	"creatorName": "Maoy",
	"version": 5,
	"mapNodes": [
		{
			"scale": 0.6,
			"sc": 0,
			"b_time": 28,
			"scpre": 0,
			"t": 0,
			"scpost": 0,
			"n": "\"The Jabber Run\" by Fr75s",
			"pre_gr18": 0,
			"levelID": "bb1v39n",
			"pre_all": 0,
			"x": 2536,
			"y": -578,
			"pre_chall": 0,
			"pre": [
				"wjwk1zj"
			],
			"ch": 1,
			"pre_coin": 0,
			"gr18": 1,
			"bm": 1,
			"weather": 0,
			"main": 1
		},
		{
			"scale": 0.9,
			"sc": 0,
			"b_time": 155,
			"scpre": 0,
			"t": 0,
			"scpost": 0,
			"n": "\"The Incredible Shade!\" by MakeJake",
			"pre_gr18": 0,
			"levelID": "f1v0h1c",
			"pre_all": 0,
			"x": 1968,
			"y": -1910,
			"pre_chall": 0,
			"pre": [
				"nsvjhvw"
			],
			"ch": 1,
			"pre_coin": 0,
			"gr18": 1,
			"bm": 3,
			"weather": 0,
			"main": 1
		},
		{
			"scale": 0.7,
			"sc": 0,
			"b_time": 40,
			"scpre": 1,
			"t": 0,
			"scpost": 0,
			"n": "\"The Super-Jump Experience\" by Omnikar",
			"pre_gr18": 0,
			"levelID": "wghjczd",
			"pre_all": 0,
			"x": 2869,
			"y": -1655,
			"pre_chall": 0,
			"pre": [
				"pr82pvb"
			],
			"ch": 0,
			"pre_coin": 0,
			"gr18": 0,
			"bm": 2,
			"weather": 0,
			"main": 1
		},
		{
			"scale": 0.68390243902439,
			"sc": 0,
			"b_time": 60,
			"scpre": 0,
			"t": 0,
			"scpost": 0,
			"n": "\"Abandoned Mine\" by JoeJoeCraft",
			"pre_gr18": 0,
			"levelID": "v27r60z",
			"pre_all": 0,
			"x": 2058,
			"y": -12,
			"pre_chall": 0,
			"pre": [
				"s1xrg4v"
			],
			"ch": 1,
			"pre_coin": 0,
			"gr18": 1,
			"bm": 1,
			"weather": 0,
			"main": 1
		},
		{
			"scale": 0.7,
			"sc": 0,
			"b_time": 60,
			"scpre": 0,
			"t": 0,
			"scpost": 0,
			"n": "\"Tower Dark\" by Slothybutt",
			"pre_gr18": 0,
			"levelID": "fgl2p0c",
			"pre_all": 0,
			"x": -507,
			"y": -2584,
			"pre_chall": 0,
			"pre": [
				"nf933wx"
			],
			"ch": 0,
			"pre_coin": 0,
			"gr18": 0,
			"bm": 3,
			"weather": 0,
			"main": 1
		},
		{
			"scale": 0.80975609756098,
			"sc": 0,
			"b_time": 35,
			"scpre": 1,
			"t": 0,
			"scpost": 0,
			"n": "\"Palace Of Action Illusion\" by Dearg Doom",
			"pre_gr18": 1,
			"levelID": "46p1c4k",
			"pre_all": 0,
			"x": 1693,
			"y": 233,
			"pre_chall": 0,
			"pre": [
				"v27r60z"
			],
			"ch": 0,
			"pre_coin": 0,
			"gr18": 0,
			"bm": 1,
			"weather": 0,
			"main": 0
		},
		{
			"scale": 1,
			"sc": 0,
			"b_time": 180,
			"scpre": 0,
			"t": 0,
			"scpost": 0,
			"n": "\"Illusion Machine\" by Maoy",
			"pre_gr18": 0,
			"levelID": "qjbv3rb",
			"pre_all": 1,
			"x": -238,
			"y": -3052,
			"pre_chall": 0,
			"pre": [
				"4835f7m",
				"fgl2p0c"
			],
			"ch": 1,
			"pre_coin": 0,
			"gr18": 1,
			"bm": 3,
			"weather": 1,
			"main": 1
		},
		{
			"sc": 0,
			"scpre": 0,
			"scpost": 0,
			"t": 0,
			"pre_gr18": 0,
			"levelID": "chcx-mlf95t-lhcc-levelNode-4tsvp",
			"pre_all": 0,
			"gr18": 0,
			"weather": 0,
			"pre_chall": 0,
			"pre": [
				"qjbv3rb"
			],
			"ch": 0,
			"main": 1,
			"x": -252,
			"pre_coin": 0,
			"y": -3385,
			"n": "TBD"
		},
		{
			"scale": 0.5,
			"sc": 0,
			"scpre": 1,
			"t": 0,
			"scpost": 0,
			"n": "\"Blopfush Blaster\" by Reaun Da Crayon",
			"pre_gr18": 0,
			"levelID": "g0nkgqt",
			"pre_all": 0,
			"x": 3132,
			"y": 280,
			"pre_chall": 1,
			"pre": [
				"0q54834"
			],
			"ch": 1,
			"pre_coin": 0,
			"gr18": 0,
			"bm": 1,
			"weather": 0,
			"main": 0
		},
		{
			"scale": 0.9,
			"sc": 0,
			"b_time": 135,
			"scpre": 0,
			"t": 0,
			"scpost": 0,
			"n": "\"The Grand Ascent\" by DFI01",
			"pre_gr18": 0,
			"levelID": "2zrmd5n",
			"pre_all": 0,
			"x": 2892,
			"y": -2079,
			"pre_chall": 0,
			"pre": [
				"wghjczd"
			],
			"ch": 1,
			"pre_coin": 0,
			"gr18": 1,
			"bm": 2,
			"weather": 1,
			"main": 1
		},
		{
			"scale": 0.9,
			"sc": 0,
			"b_time": 90,
			"scpre": 0,
			"t": 0,
			"scpost": 0,
			"n": "\"Ride Star Ridge\" by PureKnix",
			"pre_gr18": 0,
			"levelID": "0bsmn4f",
			"pre_all": 0,
			"x": 2083,
			"y": -2817,
			"pre_chall": 0,
			"pre": [
				"5990bm2"
			],
			"ch": 1,
			"pre_coin": 0,
			"gr18": 1,
			"bm": 2,
			"weather": 0,
			"main": 1
		},
		{
			"scale": 0.64,
			"sc": 0,
			"b_time": 135,
			"scpre": 1,
			"t": 0,
			"scpost": 0,
			"n": "\"Peanut Temple Puzzle\" by SpyRay",
			"pre_gr18": 1,
			"levelID": "fdbdq8k",
			"pre_all": 0,
			"x": 3336,
			"y": -2671,
			"pre_chall": 0,
			"pre": [
				"fqx7njd"
			],
			"ch": 1,
			"pre_coin": 0,
			"gr18": 1,
			"bm": 2,
			"weather": 1,
			"main": 0
		},
		{
			"scale": 1,
			"sc": 0,
			"b_time": 50,
			"scpre": 0,
			"t": 0,
			"scpost": 0,
			"n": "\"Cliff Cavern Island\" by Kalhua",
			"pre_gr18": 0,
			"levelID": "s1xrg4v",
			"pre_all": 0,
			"x": 1710,
			"y": -309,
			"pre_chall": 0,
			"pre": [
				"568wt38"
			],
			"ch": 1,
			"pre_coin": 0,
			"gr18": 1,
			"bm": 1,
			"weather": 0,
			"main": 1
		},
		{
			"scale": 0.47317073170732,
			"sc": 0,
			"b_time": 45,
			"scpre": 0,
			"t": 0,
			"scpost": 0,
			"n": "\"Solid Steel Structure\" by Nanomical",
			"pre_gr18": 0,
			"levelID": "0q54834",
			"pre_all": 0,
			"x": 3371,
			"y": -148,
			"pre_chall": 0,
			"pre": [
				"8kpdh0p"
			],
			"ch": 1,
			"pre_coin": 0,
			"gr18": 1,
			"bm": 1,
			"weather": 0,
			"main": 1
		},
		{
			"scale": 0.9,
			"sc": 0,
			"b_time": 70,
			"scpre": 0,
			"t": 0,
			"scpost": 0,
			"n": "\"Ninja Rope Rise!\" by Green0ne",
			"pre_gr18": 0,
			"levelID": "5990bm2",
			"pre_all": 1,
			"x": 2183,
			"y": -2333,
			"pre_chall": 0,
			"pre": [
				"f1v0h1c",
				"fqx7njd"
			],
			"ch": 1,
			"pre_coin": 0,
			"gr18": 1,
			"bm": 2,
			"weather": 1,
			"main": 1
		},
		{
			"scale": 1,
			"sc": 0,
			"b_time": 70,
			"scpre": 0,
			"t": 0,
			"scpost": 0,
			"n": "\"Vacrat High Way\" by ICErovTERROR",
			"pre_gr18": 0,
			"levelID": "8kpdh0p",
			"pre_all": 1,
			"x": 2873,
			"y": -287,
			"pre_chall": 0,
			"pre": [
				"bb1v39n",
				"8qz1087"
			],
			"ch": 1,
			"pre_coin": 0,
			"gr18": 1,
			"bm": 1,
			"weather": 1,
			"main": 1
		},
		{
			"scale": 1,
			"sc": 0,
			"b_time": 180,
			"scpre": 0,
			"t": 0,
			"scpost": 0,
			"n": "\"Dark Peak Castle\" by JeanneOskoure",
			"pre_gr18": 0,
			"levelID": "nf933wx",
			"pre_all": 0,
			"x": -529,
			"y": -2047,
			"pre_chall": 0,
			"pre": [
				"j8vqkf4"
			],
			"ch": 1,
			"pre_coin": 0,
			"gr18": 1,
			"bm": 3,
			"weather": 0,
			"main": 1
		},
		{
			"scale": 0.7,
			"sc": 0,
			"b_time": 35,
			"scpre": 0,
			"t": 0,
			"scpost": 0,
			"n": "\"Ramshackle Bridge\" by Maoy",
			"pre_gr18": 0,
			"levelID": "ckcpzb0",
			"pre_all": 0,
			"x": -1301,
			"y": 525,
			"pre_chall": 0,
			"pre": [],
			"ch": 1,
			"pre_coin": 0,
			"gr18": 1,
			"bm": 0,
			"weather": 0,
			"main": 1
		},
		{
			"sc": 1,
			"scpre": 0,
			"scpost": 0,
			"t": 0,
			"pre_gr18": 0,
			"levelID": "chcx-mlf95t-lhcc-levelNode-bnvtl",
			"pre_all": 0,
			"gr18": 0,
			"weather": 0,
			"pre_chall": 0,
			"pre": [
				"chcx-mlf95t-lhcc-levelNode-twf7l"
			],
			"ch": 0,
			"main": 0,
			"x": -305,
			"pre_coin": 0,
			"y": -1411,
			"n": "TBD"
		},
		{
			"scale": 1,
			"sc": 0,
			"b_time": 45,
			"scpre": 0,
			"t": 0,
			"scpost": 0,
			"n": "\"Hop, Zap And Jump!\" by MakeJake",
			"pre_gr18": 0,
			"levelID": "d2228fl",
			"pre_all": 0,
			"x": 15,
			"y": 559,
			"pre_chall": 0,
			"pre": [
				"50zz4sm"
			],
			"ch": 1,
			"pre_coin": 0,
			"gr18": 1,
			"bm": 0,
			"weather": 0,
			"main": 1
		},
		{
			"scale": 0.56682926829268,
			"sc": 0,
			"b_time": 42,
			"scpre": 1,
			"t": 0,
			"scpost": 0,
			"n": "\"Temple Of Shade\" by Maoy",
			"pre_gr18": 0,
			"levelID": "0ddb18m",
			"pre_all": 0,
			"x": 1114,
			"y": -943,
			"pre_chall": 0,
			"pre": [
				"gz3j0ph"
			],
			"ch": 1,
			"pre_coin": 0,
			"gr18": 0,
			"bm": 1,
			"weather": 0,
			"main": 1
		},
		{
			"scale": 0.8,
			"sc": 0,
			"b_time": 90,
			"scpre": 0,
			"t": 0,
			"scpost": 0,
			"n": "\"Bump Up The Mushroom\" by Saltbearer",
			"pre_gr18": 0,
			"levelID": "4835f7m",
			"pre_all": 0,
			"x": 70,
			"y": -2575,
			"pre_chall": 0,
			"pre": [
				"j8vqkf4"
			],
			"ch": 1,
			"pre_coin": 0,
			"gr18": 1,
			"bm": 3,
			"weather": 1,
			"main": 1
		},
		{
			"scale": 0.9,
			"sc": 0,
			"b_time": 180,
			"scpre": 0,
			"t": 0,
			"scpost": 0,
			"n": "\"Space Spark\" by Pawlogates",
			"pre_gr18": 0,
			"levelID": "64p02sf",
			"pre_all": 0,
			"x": 560,
			"y": -2159,
			"pre_chall": 0,
			"pre": [
				"30sfcgk"
			],
			"ch": 1,
			"pre_coin": 0,
			"gr18": 1,
			"bm": 3,
			"weather": 1,
			"main": 1
		},
		{
			"scale": 1,
			"sc": 0,
			"b_time": 50,
			"scpre": 0,
			"t": 0,
			"scpost": 0,
			"n": "\"Rush Into Sprint Speed!\" by Ditchen Catastrophic",
			"pre_gr18": 0,
			"levelID": "50zz4sm",
			"pre_all": 0,
			"x": -477,
			"y": 580,
			"pre_chall": 0,
			"pre": [
				"tz0q5gb"
			],
			"ch": 1,
			"pre_coin": 0,
			"gr18": 1,
			"bm": 0,
			"weather": 1,
			"main": 1
		},
		{
			"scale": 1,
			"sc": 0,
			"b_time": 70,
			"scpre": 1,
			"t": 0,
			"scpost": 0,
			"n": "\"Vacsteak Dance Desert\" by MakeJake",
			"pre_gr18": 0,
			"levelID": "ff2jgwx",
			"pre_all": 0,
			"x": 2481,
			"y": -1342,
			"pre_chall": 0,
			"pre": [
				"wghjczd"
			],
			"ch": 1,
			"pre_coin": 1,
			"gr18": 1,
			"bm": 1,
			"weather": 1,
			"main": 0
		},
		{
			"scale": 0.6,
			"sc": 0,
			"b_time": 35,
			"scpre": 1,
			"t": 0,
			"scpost": 0,
			"n": "\"Forgotten Fissure\" by TheViralMelon",
			"pre_gr18": 0,
			"levelID": "wc5dkk5",
			"pre_all": 0,
			"x": 1385,
			"y": -1759,
			"pre_chall": 1,
			"pre": [
				"f1v0h1c"
			],
			"ch": 0,
			"pre_coin": 0,
			"gr18": 1,
			"bm": 3,
			"weather": 0,
			"main": 0
		},
		{
			"scale": 0.53756097560976,
			"sc": 0,
			"b_time": 22,
			"scpre": 1,
			"t": 0,
			"scpost": 0,
			"n": "\"Carry The Shade, GR-18!\" by Mr Existent",
			"pre_gr18": 1,
			"levelID": "310qt18",
			"pre_all": 0,
			"x": 3338,
			"y": -1991,
			"pre_chall": 0,
			"pre": [
				"2zrmd5n"
			],
			"ch": 1,
			"pre_coin": 0,
			"gr18": 1,
			"bm": 2,
			"weather": 1,
			"main": 0
		},
		{
			"scale": 0.75121951219512,
			"sc": 0,
			"b_time": 32,
			"scpre": 0,
			"t": 0,
			"scpost": 0,
			"n": "\"Rip The Sky\" by Fr75s",
			"pre_gr18": 0,
			"levelID": "p30mfks",
			"pre_all": 0,
			"x": -664,
			"y": 175,
			"pre_chall": 0,
			"pre": [
				"50zz4sm"
			],
			"ch": 1,
			"pre_coin": 0,
			"gr18": 1,
			"bm": 0,
			"weather": 0,
			"main": 1
		},
		{
			"scale": 0.7,
			"sc": 0,
			"b_time": 40,
			"scpre": 0,
			"t": 0,
			"scpost": 0,
			"n": "\"Rip, Rise, And Zap\" by SuperVillainLex",
			"pre_gr18": 0,
			"levelID": "nsvjhvw",
			"pre_all": 0,
			"x": 2476,
			"y": -1898,
			"pre_chall": 0,
			"pre": [
				"2zrmd5n"
			],
			"ch": 0,
			"pre_coin": 0,
			"gr18": 0,
			"bm": 2,
			"weather": 0,
			"main": 1
		},
		{
			"scale": 0.80390243902439,
			"sc": 0,
			"b_time": 47,
			"scpre": 0,
			"t": 0,
			"scpost": 0,
			"n": "\"The Forgotten Factory\" by DomoZam",
			"pre_gr18": 0,
			"levelID": "6k5pvv0",
			"pre_all": 0,
			"x": 626,
			"y": 275,
			"pre_chall": 0,
			"pre": [
				"s70td0k"
			],
			"ch": 1,
			"pre_coin": 0,
			"gr18": 1,
			"bm": 0,
			"weather": 1,
			"main": 1
		},
		{
			"scale": 0.45560975609756,
			"sc": 0,
			"b_time": 40,
			"scpre": 1,
			"t": 0,
			"scpost": 0,
			"n": "\"Warm Room\" by Slothybutt",
			"pre_gr18": 0,
			"levelID": "6pxd96b",
			"pre_all": 0,
			"x": -892,
			"y": -2688,
			"pre_chall": 0,
			"pre": [
				"fgl2p0c"
			],
			"ch": 0,
			"pre_coin": 1,
			"gr18": 0,
			"bm": 3,
			"weather": 0,
			"main": 0
		},
		{
			"scale": 0.8,
			"sc": 0,
			"b_time": 150,
			"scpre": 1,
			"t": 0,
			"scpost": 0,
			"n": "\"Destruction Plateau Climb\" by ICErovTERROR",
			"pre_gr18": 1,
			"levelID": "nxbd4wc",
			"pre_all": 0,
			"x": 996,
			"y": 470,
			"pre_chall": 0,
			"pre": [
				"6k5pvv0"
			],
			"ch": 1,
			"pre_coin": 0,
			"gr18": 0,
			"bm": 0,
			"weather": 0,
			"main": 0
		},
		{
			"scale": 0.51121951219512,
			"sc": 0,
			"b_time": 40,
			"scpre": 0,
			"t": 0,
			"scpost": 0,
			"n": "\"Canoodle Land\" by KoJi",
			"pre_gr18": 0,
			"levelID": "tz0q5gb",
			"pre_all": 0,
			"x": -897,
			"y": 516,
			"pre_chall": 0,
			"pre": [
				"ckcpzb0"
			],
			"ch": 1,
			"pre_coin": 0,
			"gr18": 1,
			"bm": 0,
			"weather": 1,
			"main": 1
		},
		{
			"scale": 0.49073170731707,
			"sc": 0,
			"scpre": 0,
			"t": 0,
			"scpost": 0,
			"n": "\"Power Planet Destroy\" by JoeJoeCraft",
			"pre_gr18": 0,
			"levelID": "6ss0v4j",
			"pre_all": 0,
			"x": -461,
			"y": -270,
			"pre_chall": 0,
			"pre": [
				"p30mfks"
			],
			"ch": 0,
			"pre_coin": 0,
			"gr18": 0,
			"bm": 0,
			"weather": 0,
			"main": 1
		},
		{
			"scale": 0.7,
			"sc": 0,
			"b_time": 35,
			"scpre": 0,
			"t": 0,
			"scpost": 0,
			"n": "\"Bounce Cavern\" by FlowArt",
			"pre_gr18": 0,
			"levelID": "8qz1087",
			"pre_all": 0,
			"x": 2537,
			"y": -40,
			"pre_chall": 0,
			"pre": [
				"v27r60z"
			],
			"ch": 1,
			"pre_coin": 0,
			"gr18": 1,
			"bm": 1,
			"weather": 0,
			"main": 1
		},
		{
			"sc": 0,
			"scpre": 1,
			"scpost": 0,
			"t": 0,
			"pre_gr18": 0,
			"levelID": "chcx-mlf95t-lhcc-levelNode-twf7l",
			"pre_all": 0,
			"gr18": 0,
			"weather": 0,
			"pre_chall": 0,
			"pre": [
				"64p02sf"
			],
			"ch": 0,
			"main": 0,
			"x": 263,
			"pre_coin": 0,
			"y": -1541,
			"n": "TBD"
		},
		{
			"scale": 0.9,
			"sc": 0,
			"b_time": 150,
			"scpre": 1,
			"t": 0,
			"scpost": 0,
			"n": "\"Lost Ruins\" by BAITness",
			"pre_gr18": 0,
			"levelID": "0mxrts3",
			"pre_all": 0,
			"x": 1962,
			"y": 544,
			"pre_chall": 0,
			"pre": [
				"46p1c4k"
			],
			"ch": 1,
			"pre_coin": 0,
			"gr18": 1,
			"bm": 1,
			"weather": 0,
			"main": 0
		},
		{
			"scale": 0.79512195121951,
			"sc": 0,
			"b_time": 65,
			"scpre": 0,
			"t": 0,
			"scpost": 0,
			"n": "\"Shady Cannon Canyon\" by Arity",
			"pre_gr18": 0,
			"levelID": "568wt38",
			"pre_all": 0,
			"x": 1460,
			"y": -734,
			"pre_chall": 0,
			"pre": [
				"0ddb18m"
			],
			"ch": 1,
			"pre_coin": 0,
			"gr18": 1,
			"bm": 1,
			"weather": 0,
			"main": 1
		},
		{
			"scale": 0.6,
			"sc": 0,
			"b_time": 80,
			"scpre": 0,
			"t": 0,
			"scpost": 0,
			"n": "\"The Peanut Of Doom.\" by ICErovTERROR",
			"pre_gr18": 0,
			"levelID": "gz3j0ph",
			"pre_all": 0,
			"x": 162,
			"y": -793,
			"pre_chall": 0,
			"pre": [
				"1v0m021"
			],
			"ch": 0,
			"pre_coin": 0,
			"gr18": 0,
			"bm": 0,
			"weather": 0,
			"main": 1
		},
		{
			"scale": 0.76585365853659,
			"sc": 0,
			"b_time": 65,
			"scpre": 0,
			"t": 0,
			"scpost": 0,
			"n": "\"Laser Power Switch\" by WaddlesTNT",
			"pre_gr18": 0,
			"levelID": "4wvn070",
			"pre_all": 0,
			"x": -21,
			"y": 80,
			"pre_chall": 0,
			"pre": [
				"d2228fl"
			],
			"ch": 1,
			"pre_coin": 0,
			"gr18": 1,
			"bm": 0,
			"weather": 0,
			"main": 1
		},
		{
			"scale": 0.6,
			"sc": 0,
			"b_time": 45,
			"scpre": 0,
			"t": 0,
			"scpost": 0,
			"n": "\"Storm The Gateway\" by Glorious Cashew",
			"pre_gr18": 0,
			"levelID": "1v0m021",
			"pre_all": 1,
			"x": -20,
			"y": -439,
			"pre_chall": 0,
			"pre": [
				"6ss0v4j",
				"tz051h8",
				"4wvn070"
			],
			"ch": 0,
			"pre_coin": 0,
			"gr18": 1,
			"bm": 0,
			"weather": 0,
			"main": 1
		},
		{
			"scale": 0.89170731707317,
			"sc": 0,
			"b_time": 195,
			"scpre": 0,
			"t": 0,
			"scpost": 0,
			"n": "\"Void Sky Battle\" by WaddlesTNT",
			"pre_gr18": 0,
			"levelID": "pr82pvb",
			"pre_all": 0,
			"x": 3498,
			"y": -940,
			"pre_chall": 0,
			"pre": [
				"wg06h3x"
			],
			"ch": 0,
			"pre_coin": 0,
			"gr18": 0,
			"bm": 1,
			"weather": 1,
			"main": 1
		},
		{
			"scale": 0.65756097560976,
			"sc": 0,
			"b_time": 80,
			"scpre": 0,
			"t": 0,
			"scpost": 0,
			"n": "\"Rebound Up The Tower!\" by Radio Inactive",
			"pre_gr18": 0,
			"levelID": "s70td0k",
			"pre_all": 0,
			"x": 438,
			"y": 624,
			"pre_chall": 0,
			"pre": [
				"d2228fl"
			],
			"ch": 1,
			"pre_coin": 0,
			"gr18": 1,
			"bm": 0,
			"weather": 0,
			"main": 1
		},
		{
			"scale": 0.8,
			"sc": 0,
			"b_time": 50,
			"scpre": 0,
			"t": 0,
			"scpost": 0,
			"n": "\"Dangerous Elevator Business\" by SuperVillainLex",
			"pre_gr18": 0,
			"levelID": "wg06h3x",
			"pre_all": 0,
			"x": 3493,
			"y": -565,
			"pre_chall": 0,
			"pre": [
				"0q54834"
			],
			"ch": 1,
			"pre_coin": 0,
			"gr18": 1,
			"bm": 1,
			"weather": 0,
			"main": 1
		},
		{
			"scale": 1,
			"sc": 0,
			"b_time": 75,
			"scpre": 0,
			"t": 0,
			"scpost": 0,
			"n": "\"Power Extract\" by Kalhua",
			"pre_gr18": 0,
			"levelID": "tz051h8",
			"pre_all": 0,
			"x": 424,
			"y": -195,
			"pre_chall": 0,
			"pre": [
				"6k5pvv0"
			],
			"ch": 1,
			"pre_coin": 0,
			"gr18": 1,
			"bm": 0,
			"weather": 0,
			"main": 1
		},
		{
			"scale": 0.7,
			"sc": 0,
			"b_time": 70,
			"scpre": 0,
			"t": 0,
			"scpost": 0,
			"n": "\"Mound About Mountain\" by PureKnix",
			"pre_gr18": 0,
			"levelID": "fqx7njd",
			"pre_all": 0,
			"x": 2850,
			"y": -2534,
			"pre_chall": 0,
			"pre": [
				"2zrmd5n"
			],
			"ch": 1,
			"pre_coin": 0,
			"gr18": 1,
			"bm": 2,
			"weather": 0,
			"main": 1
		},
		{
			"scale": 0.8,
			"sc": 0,
			"b_time": 120,
			"scpre": 0,
			"t": 0,
			"scpost": 0,
			"n": "\"Rebound Palace\" by SuperVillainLex",
			"pre_gr18": 0,
			"levelID": "j8vqkf4",
			"pre_all": 0,
			"x": 91,
			"y": -2034,
			"pre_chall": 0,
			"pre": [
				"64p02sf"
			],
			"ch": 0,
			"pre_coin": 0,
			"gr18": 0,
			"bm": 3,
			"weather": 0,
			"main": 1
		},
		{
			"scale": 0.6,
			"sc": 0,
			"b_time": 35,
			"scpre": 1,
			"t": 0,
			"scpost": 0,
			"n": "\"Ouch! That Cart Hurt!\" by Mr Existent",
			"pre_gr18": 0,
			"levelID": "30sfcgk",
			"pre_all": 0,
			"x": 1005,
			"y": -2434,
			"pre_chall": 0,
			"pre": [
				"b8xxm0k"
			],
			"ch": 0,
			"pre_coin": 0,
			"gr18": 0,
			"bm": 3,
			"weather": 1,
			"main": 1
		},
		{
			"scale": 0.77170731707317,
			"sc": 0,
			"b_time": 45,
			"scpre": 1,
			"t": 0,
			"scpost": 0,
			"n": "\"Blopsack Bounce\" by iLoveKittens",
			"pre_gr18": 0,
			"levelID": "b5jfb0x",
			"pre_all": 0,
			"x": -944,
			"y": -222,
			"pre_chall": 0,
			"pre": [
				"p30mfks"
			],
			"ch": 1,
			"pre_coin": 1,
			"gr18": 1,
			"bm": 0,
			"weather": 0,
			"main": 0
		},
		{
			"scale": 0.6,
			"sc": 0,
			"b_time": 120,
			"scpre": 0,
			"t": 0,
			"scpost": 0,
			"n": "\"The Boss Is Meh!\" by Noob Jr",
			"pre_gr18": 0,
			"levelID": "b8xxm0k",
			"pre_all": 0,
			"x": 2363,
			"y": -3158,
			"pre_chall": 0,
			"pre": [
				"0bsmn4f"
			],
			"ch": 1,
			"pre_coin": 0,
			"gr18": 1,
			"bm": 2,
			"weather": 1,
			"main": 1
		},
		{
			"scale": 0.8,
			"sc": 0,
			"b_time": 600,
			"scpre": 0,
			"t": 0,
			"scpost": 0,
			"n": "\"Mastery Of Space-Time\" by JeanneOskoure",
			"pre_gr18": 1,
			"levelID": "45xms67",
			"pre_all": 0,
			"x": -1043,
			"y": -1957,
			"pre_chall": 0,
			"pre": [
				"nf933wx"
			],
			"ch": 1,
			"pre_coin": 0,
			"gr18": 0,
			"bm": 3,
			"weather": 0,
			"main": 0
		},
		{
			"scale": 0.88,
			"sc": 0,
			"b_time": 90,
			"scpre": 0,
			"t": 0,
			"scpost": 0,
			"n": "\"Void Blossom Curse\" by Green0ne",
			"pre_gr18": 0,
			"levelID": "wjwk1zj",
			"pre_all": 0,
			"x": 2089,
			"y": -552,
			"pre_chall": 0,
			"pre": [
				"s1xrg4v"
			],
			"ch": 1,
			"pre_coin": 0,
			"gr18": 1,
			"bm": 1,
			"weather": 0,
			"main": 1
		}
	]
}



func _on_LinkButton_pressed():
	OS.shell_open('https://level-kit.netlify.app/setting/')
