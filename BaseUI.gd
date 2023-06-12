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

const lhcc : Dictionary = {
	"creatorCode": "mlf95t",
	"campaignName": "Community Campaign",
	"is_lhcc":true,
	"shipStartPosition":"",
	"mapNodes": [
		{
			"main": 0,
			"sc": 0,
			"scpre": 1,
			"scpost": 0,
			"pre_gr18": 0,
			"weather": 0,
			"pre_all": 0,
			"levelID": "g0nkgqt",
			"n": "Blopfush Blaster",
			"pre_coin": 0,
			"pre_chall": 1,
			"dat": "chcx-mlf95t-lhcc-level-Blopfush_Blaster",
			"ch": 1,
			"t": 0,
			"scale": 1,
			"bm": 1,
			"x": 3132,
			"y": 280,
			"gr18": 0,
			"pre": [
				"0q54834"
			]
		},
		{
			"main": 1,
			"sc": 0,
			"scpre": 0,
			"scpost": 0,
			"levelID": "4wvn070",
			"pre_gr18": 0,
			"weather": 0,
			"pre_all": 0,
			"pre_coin": 0,
			"b_time": 65,
			"bm": 0,
			"pre_chall": 0,
			"dat": "chcx-mlf95t-lhcc-level-Laser_Power_Switch",
			"ch": 1,
			"t": 0,
			"scale": 0.76585365853659,
			"n": "Laser Power Switch",
			"x": -21,
			"y": 80,
			"gr18": 1,
			"pre": [
				"d2228fl"
			]
		},
		{
			"main": 0,
			"sc": 0,
			"scpre": 1,
			"scpost": 0,
			"levelID": "0mxrts3",
			"pre_gr18": 0,
			"weather": 0,
			"pre_all": 0,
			"pre_coin": 0,
			"b_time": 150,
			"bm": 1,
			"pre_chall": 0,
			"dat": "chcx-mlf95t-lhcc-level-Lost_Ruins",
			"ch": 1,
			"t": 0,
			"scale": 0.66634146341463,
			"n": "Lost Ruins",
			"x": 1962,
			"y": 544,
			"gr18": 1,
			"pre": [
				"46p1c4k"
			]
		},
		{
			"main": 1,
			"sc": 0,
			"scpre": 0,
			"scpost": 0,
			"levelID": "ckcpzb0",
			"pre_gr18": 0,
			"weather": 0,
			"pre_all": 0,
			"pre_coin": 0,
			"b_time": 35,
			"bm": 0,
			"pre_chall": 0,
			"dat": "chcx-mlf95t-lhcc-level-Ramshackle_Bridge",
			"ch": 1,
			"t": 0,
			"scale": 0.5990243902439,
			"n": "Ramshackle Bridge",
			"x": -1301,
			"y": 525,
			"gr18": 1,
			"pre": []
		},
		{
			"main": 1,
			"sc": 0,
			"scpre": 0,
			"scpost": 0,
			"pre_gr18": 0,
			"weather": 0,
			"pre_all": 0,
			"levelID": "6ss0v4j",
			"n": "Power Planet Destroy",
			"pre_coin": 0,
			"pre_chall": 0,
			"dat": "chcx-mlf95t-lhcc-level-Power_Planet_Destroy",
			"ch": 0,
			"t": 0,
			"scale": 0.49073170731707,
			"bm": 0,
			"x": -339,
			"y": -212,
			"gr18": 0,
			"pre": [
				"p30mfks"
			]
		},
		{
			"main": 1,
			"sc": 0,
			"scpre": 0,
			"scpost": 0,
			"levelID": "s1xrg4v",
			"pre_gr18": 0,
			"weather": 0,
			"pre_all": 0,
			"pre_coin": 0,
			"b_time": 50,
			"bm": 1,
			"pre_chall": 0,
			"dat": "chcx-mlf95t-lhcc-level-Cliff_Cavern_Island",
			"ch": 1,
			"t": 0,
			"scale": 1,
			"n": "Cliff Cavern Island",
			"x": 1710,
			"y": -309,
			"gr18": 1,
			"pre": [
				"568wt38"
			]
		},
		{
			"main": 1,
			"sc": 0,
			"scpre": 0,
			"scpost": 0,
			"levelID": "568wt38",
			"pre_gr18": 0,
			"weather": 0,
			"pre_all": 0,
			"pre_coin": 0,
			"b_time": 65,
			"bm": 1,
			"pre_chall": 0,
			"dat": "chcx-mlf95t-lhcc-level-Shady_Cannon_Canyon",
			"ch": 1,
			"t": 0,
			"scale": 0.79512195121951,
			"n": "Shady Cannon Canyon",
			"x": 1460,
			"y": -734,
			"gr18": 1,
			"pre": [
				"0ddb18m"
			]
		},
		{
			"main": 1,
			"sc": 0,
			"scpre": 0,
			"scpost": 0,
			"levelID": "1v0m021",
			"pre_gr18": 0,
			"weather": 0,
			"pre_all": 1,
			"pre_coin": 0,
			"b_time": 45,
			"bm": 0,
			"pre_chall": 0,
			"dat": "chcx-mlf95t-lhcc-level-Storm_The_Gateway",
			"ch": 0,
			"t": 0,
			"scale": 0.45560975609756,
			"n": "Storm The Gateway",
			"x": -20,
			"y": -439,
			"gr18": 1,
			"pre": [
				"4wvn070",
				"6ss0v4j",
				"tz051h8"
			]
		},
		{
			"main": 1,
			"sc": 0,
			"scpre": 0,
			"scpost": 0,
			"levelID": "gz3j0ph",
			"pre_gr18": 0,
			"weather": 0,
			"pre_all": 0,
			"pre_coin": 0,
			"b_time": 80,
			"bm": 0,
			"pre_chall": 0,
			"dat": "chcx-mlf95t-lhcc-level-The_Peanut_Of_Doom",
			"ch": 0,
			"t": 0,
			"scale": 0.40585365853659,
			"n": "The Peanut Of Doom.",
			"x": 162,
			"y": -793,
			"gr18": 0,
			"pre": [
				"1v0m021"
			]
		},
		{
			"main": 1,
			"sc": 0,
			"scpre": 0,
			"scpost": 0,
			"levelID": "wjwk1zj",
			"pre_gr18": 0,
			"weather": 0,
			"pre_all": 0,
			"pre_coin": 0,
			"b_time": 90,
			"bm": 1,
			"pre_chall": 0,
			"dat": "chcx-mlf95t-lhcc-level-Void_Blossom_Curse",
			"ch": 1,
			"t": 0,
			"scale": 0.88,
			"n": "Void Blossom Curse",
			"x": 2089,
			"y": -552,
			"gr18": 1,
			"pre": [
				"s1xrg4v"
			]
		},
		{
			"main": 1,
			"sc": 0,
			"scpre": 1,
			"scpost": 0,
			"levelID": "0ddb18m",
			"pre_gr18": 0,
			"weather": 0,
			"pre_all": 0,
			"pre_coin": 0,
			"b_time": 42,
			"bm": 1,
			"pre_chall": 0,
			"dat": "chcx-mlf95t-lhcc-level-Temple_Of_Shade",
			"ch": 1,
			"t": 0,
			"scale": 0.56682926829268,
			"n": "Temple Of Shade",
			"x": 1114,
			"y": -943,
			"gr18": 0,
			"pre": [
				"gz3j0ph"
			]
		},
		{
			"main": 1,
			"sc": 0,
			"scpre": 0,
			"scpost": 0,
			"levelID": "v27r60z",
			"pre_gr18": 0,
			"weather": 0,
			"pre_all": 0,
			"pre_coin": 0,
			"b_time": 60,
			"bm": 1,
			"pre_chall": 0,
			"dat": "chcx-mlf95t-lhcc-level-Abandoned_Mine",
			"ch": 1,
			"t": 0,
			"scale": 0.68390243902439,
			"n": "Abandoned Mine",
			"x": 2054,
			"y": -74,
			"gr18": 1,
			"pre": [
				"s1xrg4v"
			]
		},
		{
			"main": 1,
			"sc": 0,
			"scpre": 0,
			"scpost": 0,
			"levelID": "50zz4sm",
			"pre_gr18": 0,
			"weather": 1,
			"pre_all": 0,
			"pre_coin": 0,
			"b_time": 50,
			"bm": 0,
			"pre_chall": 0,
			"dat": "chcx-mlf95t-lhcc-level-Rush_Into_Sprint_Speed",
			"ch": 1,
			"t": 0,
			"scale": 1,
			"n": "Rush Into Sprint Speed!",
			"x": -477,
			"y": 580,
			"gr18": 1,
			"pre": [
				"tz0q5gb"
			]
		},
		{
			"main": 1,
			"sc": 0,
			"scpre": 0,
			"scpost": 0,
			"levelID": "d2228fl",
			"pre_gr18": 0,
			"weather": 0,
			"pre_all": 0,
			"pre_coin": 0,
			"b_time": 45,
			"bm": 0,
			"pre_chall": 0,
			"dat": "chcx-mlf95t-lhcc-level-Hop_Zap_And_Jump",
			"ch": 1,
			"t": 0,
			"scale": 1,
			"n": "Hop, Zap And Jump!",
			"x": 15,
			"y": 559,
			"gr18": 1,
			"pre": [
				"50zz4sm"
			]
		},
		{
			"main": 1,
			"sc": 0,
			"scpre": 0,
			"scpost": 0,
			"levelID": "8kpdh0p",
			"pre_gr18": 0,
			"weather": 1,
			"pre_all": 1,
			"pre_coin": 0,
			"b_time": 70,
			"bm": 1,
			"pre_chall": 0,
			"dat": "chcx-mlf95t-lhcc-level-Vacrat_High_Way",
			"ch": 1,
			"t": 0,
			"scale": 1,
			"n": "Vacrat High Way",
			"x": 2873,
			"y": -287,
			"gr18": 1,
			"pre": [
				"8qz1087",
				"bb1v39n"
			]
		},
		{
			"main": 1,
			"sc": 0,
			"scpre": 0,
			"scpost": 0,
			"levelID": "0q54834",
			"pre_gr18": 0,
			"weather": 0,
			"pre_all": 0,
			"pre_coin": 0,
			"b_time": 45,
			"bm": 1,
			"pre_chall": 0,
			"dat": "chcx-mlf95t-lhcc-level-Solid_Steel_Structure",
			"ch": 1,
			"t": 0,
			"scale": 0.47317073170732,
			"n": "Solid Steel Structure",
			"x": 3371,
			"y": -148,
			"gr18": 1,
			"pre": [
				"8kpdh0p"
			]
		},
		{
			"main": 0,
			"sc": 0,
			"scpre": 1,
			"scpost": 0,
			"levelID": "nxbd4wc",
			"pre_gr18": 1,
			"weather": 0,
			"pre_all": 0,
			"pre_coin": 0,
			"b_time": 150,
			"bm": 0,
			"pre_chall": 0,
			"dat": "chcx-mlf95t-lhcc-level-Destruction_Plateau_Climb",
			"ch": 1,
			"t": 0,
			"scale": 0.61951219512195,
			"n": "Destruction Plateau Climb",
			"x": 996,
			"y": 470,
			"gr18": 0,
			"pre": [
				"6k5pvv0"
			]
		},
		{
			"main": 1,
			"sc": 0,
			"scpre": 0,
			"scpost": 0,
			"levelID": "tz0q5gb",
			"pre_gr18": 0,
			"weather": 1,
			"pre_all": 0,
			"pre_coin": 0,
			"b_time": 40,
			"bm": 0,
			"pre_chall": 0,
			"dat": "chcx-mlf95t-lhcc-level-Canoodle_Land",
			"ch": 1,
			"t": 0,
			"scale": 0.51121951219512,
			"n": "Canoodle Land",
			"x": -897,
			"y": 516,
			"gr18": 1,
			"pre": [
				"ckcpzb0"
			]
		},
		{
			"main": 0,
			"sc": 0,
			"scpre": 1,
			"scpost": 0,
			"levelID": "46p1c4k",
			"pre_gr18": 1,
			"weather": 0,
			"pre_all": 0,
			"pre_coin": 0,
			"b_time": 35,
			"bm": 1,
			"pre_chall": 0,
			"dat": "chcx-mlf95t-lhcc-level-Palace_Of_Action_Illusion",
			"ch": 0,
			"t": 0,
			"scale": 0.80975609756098,
			"n": "Palace Of Action Illusion",
			"x": 1693,
			"y": 233,
			"gr18": 0,
			"pre": [
				"v27r60z"
			]
		},
		{
			"main": 1,
			"sc": 0,
			"scpre": 0,
			"scpost": 0,
			"levelID": "wg06h3x",
			"pre_gr18": 0,
			"weather": 0,
			"pre_all": 0,
			"pre_coin": 0,
			"b_time": 50,
			"bm": 1,
			"pre_chall": 0,
			"dat": "chcx-mlf95t-lhcc-level-Dangerous_Elevator_Business",
			"ch": 1,
			"t": 0,
			"scale": 0.62536585365854,
			"n": "Dangerous Elevator Business",
			"x": 3493,
			"y": -565,
			"gr18": 1,
			"pre": [
				"0q54834"
			]
		},
		{
			"main": 1,
			"sc": 0,
			"scpre": 0,
			"scpost": 0,
			"levelID": "8qz1087",
			"pre_gr18": 0,
			"weather": 0,
			"pre_all": 0,
			"pre_coin": 0,
			"b_time": 35,
			"bm": 1,
			"pre_chall": 0,
			"dat": "chcx-mlf95t-lhcc-level-Bounce_Cavern",
			"ch": 1,
			"t": 0,
			"scale": 1,
			"n": "Bounce Cavern",
			"x": 2532,
			"y": -82,
			"gr18": 1,
			"pre": [
				"v27r60z"
			]
		},
		{
			"main": 1,
			"sc": 0,
			"scpre": 0,
			"scpost": 0,
			"levelID": "p30mfks",
			"pre_gr18": 0,
			"weather": 0,
			"pre_all": 0,
			"pre_coin": 0,
			"b_time": 32,
			"bm": 0,
			"pre_chall": 0,
			"dat": "chcx-mlf95t-lhcc-level-Rip_The_Sky",
			"ch": 1,
			"t": 0,
			"scale": 0.75121951219512,
			"n": "Rip The Sky",
			"x": -664,
			"y": 175,
			"gr18": 1,
			"pre": [
				"50zz4sm"
			]
		},
		{
			"main": 1,
			"sc": 0,
			"scpre": 0,
			"scpost": 0,
			"levelID": "tz051h8",
			"pre_gr18": 0,
			"weather": 0,
			"pre_all": 0,
			"pre_coin": 0,
			"b_time": 75,
			"bm": 0,
			"pre_chall": 0,
			"dat": "chcx-mlf95t-lhcc-level-Power_Extract",
			"ch": 1,
			"t": 0,
			"scale": 1,
			"n": "Power Extract",
			"x": 337,
			"y": -163,
			"gr18": 1,
			"pre": [
				"6k5pvv0"
			]
		},
		{
			"main": 1,
			"sc": 0,
			"scpre": 0,
			"scpost": 0,
			"levelID": "bb1v39n",
			"pre_gr18": 0,
			"weather": 0,
			"pre_all": 0,
			"pre_coin": 0,
			"b_time": 28,
			"bm": 1,
			"pre_chall": 0,
			"dat": "chcx-mlf95t-lhcc-level-The_Jabber_Run",
			"ch": 1,
			"t": 0,
			"scale": 0.78048780487805,
			"n": "The Jabber Run",
			"x": 2536,
			"y": -578,
			"gr18": 1,
			"pre": [
				"wjwk1zj"
			]
		},
		{
			"main": 1,
			"sc": 0,
			"scpre": 0,
			"scpost": 0,
			"levelID": "pr82pvb",
			"pre_gr18": 0,
			"weather": 1,
			"pre_all": 0,
			"pre_coin": 0,
			"b_time": 195,
			"bm": 1,
			"pre_chall": 0,
			"dat": "chcx-mlf95t-lhcc-level-Void_Sky_Battle",
			"ch": 0,
			"t": 0,
			"scale": 0.89170731707317,
			"n": "Void Sky Battle",
			"x": 3485,
			"y": -932,
			"gr18": 0,
			"pre": [
				"wg06h3x"
			]
		},
		{
			"main": 0,
			"sc": 0,
			"scpre": 1,
			"scpost": 0,
			"levelID": "b5jfb0x",
			"pre_gr18": 0,
			"weather": 0,
			"pre_all": 0,
			"pre_coin": 1,
			"b_time": 45,
			"bm": 0,
			"pre_chall": 0,
			"dat": "chcx-mlf95t-lhcc-level-Blopsack_Bounce",
			"ch": 1,
			"t": 0,
			"scale": 0.77170731707317,
			"n": "Blopsack Bounce",
			"x": -944,
			"y": -222,
			"gr18": 1,
			"pre": [
				"p30mfks"
			]
		},
		{
			"main": 1,
			"sc": 0,
			"scpre": 0,
			"scpost": 0,
			"levelID": "s70td0k",
			"pre_gr18": 0,
			"weather": 0,
			"pre_all": 0,
			"pre_coin": 0,
			"b_time": 80,
			"bm": 0,
			"pre_chall": 0,
			"dat": "chcx-mlf95t-lhcc-level-Rebound_Up_The_Tower",
			"ch": 1,
			"t": 0,
			"scale": 0.65756097560976,
			"n": "Rebound Up The Tower!",
			"x": 438,
			"y": 624,
			"gr18": 1,
			"pre": [
				"d2228fl"
			]
		},
		{
			"main": 1,
			"sc": 0,
			"scpre": 0,
			"scpost": 0,
			"levelID": "6k5pvv0",
			"pre_gr18": 0,
			"weather": 1,
			"pre_all": 0,
			"pre_coin": 0,
			"b_time": 47,
			"bm": 0,
			"pre_chall": 0,
			"dat": "chcx-mlf95t-lhcc-level-The_Forgotten_Factory",
			"ch": 1,
			"t": 0,
			"scale": 0.80390243902439,
			"n": "The Forgotten Factory",
			"x": 626,
			"y": 275,
			"gr18": 1,
			"pre": [
				"s70td0k"
			]
		}
	],
	"creatorName": "Maoy",
	"version": 3,
	"landmarks": [
		{
			"ywig_amt": 0,
			"rwig_off": 26.25,
			"rwig_amt": 5.25,
			"rwig_spd": 0,
			"sc": 0.99585416666667,
			"elId": 1,
			"x": -1301,
			"dep": 25,
			"y": 585,
			"rot": -10
		},
		{
			"rsp": -4.5,
			"elId": 11,
			"x": 883.50000000909,
			"dep": 25,
			"y": 95,
			"rot": 12.75
		},
		{
			"rwig_amt": 11.625,
			"rwig_spd": 0.5,
			"y": -190,
			"rsp": 0,
			"elId": 17,
			"x": 1157,
			"dep": 50,
			"sc": 1,
			"rot": 0
		},
		{
			"rsp": 18,
			"elId": 8,
			"x": 158,
			"dep": 12,
			"y": 172,
			"rot": -18.5
		},
		{
			"ywig_amt": 8.3333333333334,
			"rot": -3,
			"elId": 0,
			"dep": 49,
			"xwig_spd": 0.41666666666667,
			"sc": 0.99585416666667,
			"xwig_amt": 18.75,
			"x": 7.5000000909495,
			"y": 40,
			"xsp": 0,
			"ywig_spd": 0.33333333333333
		},
		{
			"ywig_amt": 2.0833333333333,
			"elId": 3,
			"xwig_spd": 0.83333333333333,
			"sc": 0.99585416666667,
			"xwig_amt": 6.25,
			"x": 376,
			"dep": 71,
			"y": -469,
			"rot": -10
		},
		{
			"y": -300,
			"rsp": -1.4999999999999,
			"elId": 13,
			"x": -900,
			"dep": 25,
			"xsp": 0,
			"rot": -8.75
		},
		{
			"y": -287,
			"rsp": -19.5,
			"elId": 8,
			"x": 2886,
			"rwig_amt": 0,
			"dep": 24,
			"rot": 17.5
		},
		{
			"rsp": 10.5,
			"sc": 0.99585416666667,
			"elId": 18,
			"x": 483,
			"dep": 25,
			"y": -617,
			"rot": 0
		}
	]
}
