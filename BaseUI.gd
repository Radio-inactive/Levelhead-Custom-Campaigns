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
	show_return()

const lhcc : Dictionary = {
	"is_lhcc":true,
	"creatorCode": "mlf95t",
	"campaignName": "Community Campaign",
	"mapNodes": [
		{
			"gr18": 0,
			"t": 0,
			"pre": [
				"6k5pvv0"
			],
			"levelID": "nxbd4wc",
			"sc": 0,
			"pre_chall": 0,
			"scpre": 1,
			"n": "\"Destruction Plateau Climb\" by ICErovTERROR",
			"scpost": 0,
			"weather": 0,
			"pre_gr18": 1,
			"b_time": 150,
			"pre_all": 0,
			"x": 996,
			"y": 470,
			"scale": 0.8,
			"bm": 0,
			"main": 0,
			"ch": 1,
			"pre_coin": 0
		},
		{
			"gr18": 1,
			"t": 0,
			"pre": [
				"fqx7njd"
			],
			"levelID": "fdbdq8k",
			"sc": 0,
			"pre_chall": 0,
			"scpre": 1,
			"n": "\"Peanut Temple Puzzle\" by SpyRay",
			"scpost": 0,
			"weather": 1,
			"pre_gr18": 1,
			"b_time": 135,
			"pre_all": 0,
			"x": 3336,
			"y": -2671,
			"scale": 0.64,
			"bm": 2,
			"main": 0,
			"ch": 1,
			"pre_coin": 0
		},
		{
			"gr18": 0,
			"t": 0,
			"pre": [
				"p30mfks"
			],
			"sc": 0,
			"levelID": "6ss0v4j",
			"scpre": 0,
			"n": "\"Power Planet Destroy\" by JoeJoeCraft",
			"scpost": 0,
			"weather": 0,
			"pre_gr18": 0,
			"pre_chall": 0,
			"pre_all": 0,
			"x": -461,
			"y": -270,
			"main": 1,
			"bm": 0,
			"scale": 0.49073170731707,
			"ch": 0,
			"pre_coin": 0
		},
		{
			"gr18": 1,
			"t": 0,
			"pre": [
				"v27r60z"
			],
			"levelID": "8qz1087",
			"sc": 0,
			"pre_chall": 0,
			"scpre": 0,
			"n": "\"Bounce Cavern\" by FlowArt",
			"scpost": 0,
			"weather": 0,
			"pre_gr18": 0,
			"b_time": 35,
			"pre_all": 0,
			"x": 2537,
			"y": -40,
			"scale": 0.7,
			"bm": 1,
			"main": 1,
			"ch": 1,
			"pre_coin": 0
		},
		{
			"gr18": 1,
			"t": 0,
			"pre": [
				"bb1v39n",
				"8qz1087"
			],
			"levelID": "8kpdh0p",
			"sc": 0,
			"pre_chall": 0,
			"scpre": 0,
			"n": "\"Vacrat High Way\" by ICErovTERROR",
			"scpost": 0,
			"weather": 1,
			"pre_gr18": 0,
			"b_time": 70,
			"pre_all": 1,
			"x": 2873,
			"y": -287,
			"scale": 1,
			"bm": 1,
			"main": 1,
			"ch": 1,
			"pre_coin": 0
		},
		{
			"gr18": 1,
			"t": 0,
			"pre": [
				"6k5pvv0"
			],
			"levelID": "tz051h8",
			"sc": 0,
			"pre_chall": 0,
			"scpre": 0,
			"n": "\"Power Extract\" by Kalhua",
			"scpost": 0,
			"weather": 0,
			"pre_gr18": 0,
			"b_time": 75,
			"pre_all": 0,
			"x": 424,
			"y": -195,
			"scale": 1,
			"bm": 0,
			"main": 1,
			"ch": 1,
			"pre_coin": 0
		},
		{
			"gr18": 0,
			"t": 0,
			"pre": [
				"4835f7m",
				"fgl2p0c"
			],
			"sc": 0,
			"scpre": 0,
			"n": "TBD",
			"scpost": 0,
			"weather": 0,
			"pre_gr18": 0,
			"pre_all": 1,
			"x": -238,
			"y": -3052,
			"levelID": "chcx-mlf95t-lhcc-levelNode-365vn",
			"pre_chall": 0,
			"main": 1,
			"ch": 0,
			"pre_coin": 0
		},
		{
			"gr18": 1,
			"t": 0,
			"pre": [
				"d2228fl"
			],
			"levelID": "s70td0k",
			"sc": 0,
			"pre_chall": 0,
			"scpre": 0,
			"n": "\"Rebound Up The Tower!\" by Radio Inactive",
			"scpost": 0,
			"weather": 0,
			"pre_gr18": 0,
			"b_time": 80,
			"pre_all": 0,
			"x": 438,
			"y": 624,
			"scale": 0.65756097560976,
			"bm": 0,
			"main": 1,
			"ch": 1,
			"pre_coin": 0
		},
		{
			"gr18": 1,
			"t": 0,
			"pre": [
				"p30mfks"
			],
			"levelID": "b5jfb0x",
			"sc": 0,
			"pre_chall": 0,
			"scpre": 1,
			"n": "\"Blopsack Bounce\" by iLoveKittens",
			"scpost": 0,
			"weather": 0,
			"pre_gr18": 0,
			"b_time": 45,
			"pre_all": 0,
			"x": -944,
			"y": -222,
			"scale": 0.77170731707317,
			"bm": 0,
			"main": 0,
			"ch": 1,
			"pre_coin": 1
		},
		{
			"gr18": 1,
			"t": 0,
			"pre": [
				"50zz4sm"
			],
			"levelID": "p30mfks",
			"sc": 0,
			"pre_chall": 0,
			"scpre": 0,
			"n": "\"Rip The Sky\" by Fr75s",
			"scpost": 0,
			"weather": 0,
			"pre_gr18": 0,
			"b_time": 32,
			"pre_all": 0,
			"x": -664,
			"y": 175,
			"scale": 0.75121951219512,
			"bm": 0,
			"main": 1,
			"ch": 1,
			"pre_coin": 0
		},
		{
			"gr18": 1,
			"t": 0,
			"pre": [
				"s70td0k"
			],
			"levelID": "6k5pvv0",
			"sc": 0,
			"pre_chall": 0,
			"scpre": 0,
			"n": "\"The Forgotten Factory\" by DomoZam",
			"scpost": 0,
			"weather": 1,
			"pre_gr18": 0,
			"b_time": 47,
			"pre_all": 0,
			"x": 626,
			"y": 275,
			"scale": 0.80390243902439,
			"bm": 0,
			"main": 1,
			"ch": 1,
			"pre_coin": 0
		},
		{
			"gr18": 0,
			"t": 0,
			"pre": [
				"nf933wx"
			],
			"levelID": "fgl2p0c",
			"sc": 0,
			"pre_chall": 0,
			"scpre": 0,
			"n": "\"Tower Dark\" by Slothybutt",
			"scpost": 0,
			"weather": 0,
			"pre_gr18": 0,
			"b_time": 60,
			"pre_all": 0,
			"x": -507,
			"y": -2584,
			"scale": 0.7,
			"bm": 3,
			"main": 1,
			"ch": 0,
			"pre_coin": 0
		},
		{
			"gr18": 1,
			"t": 0,
			"pre": [
				"0ddb18m"
			],
			"levelID": "568wt38",
			"sc": 0,
			"pre_chall": 0,
			"scpre": 0,
			"n": "\"Shady Cannon Canyon\" by Arity",
			"scpost": 0,
			"weather": 0,
			"pre_gr18": 0,
			"b_time": 65,
			"pre_all": 0,
			"x": 1460,
			"y": -734,
			"scale": 0.79512195121951,
			"bm": 1,
			"main": 1,
			"ch": 1,
			"pre_coin": 0
		},
		{
			"gr18": 1,
			"t": 0,
			"pre": [
				"f1v0h1c"
			],
			"levelID": "wc5dkk5",
			"sc": 0,
			"pre_chall": 1,
			"scpre": 1,
			"n": "\"Forgotten Fissure\" by TheViralMelon",
			"scpost": 0,
			"weather": 0,
			"pre_gr18": 0,
			"b_time": 35,
			"pre_all": 0,
			"x": 1385,
			"y": -1759,
			"scale": 0.4,
			"bm": 3,
			"main": 0,
			"ch": 0,
			"pre_coin": 0
		},
		{
			"gr18": 1,
			"t": 0,
			"pre": [
				"2zrmd5n"
			],
			"levelID": "310qt18",
			"sc": 0,
			"pre_chall": 0,
			"scpre": 1,
			"n": "\"Carry The Shade, GR-18!\" by Mr Existent",
			"scpost": 0,
			"weather": 1,
			"pre_gr18": 1,
			"b_time": 22,
			"pre_all": 0,
			"x": 3338,
			"y": -1991,
			"scale": 0.53756097560976,
			"bm": 2,
			"main": 0,
			"ch": 1,
			"pre_coin": 0
		},
		{
			"gr18": 0,
			"t": 0,
			"pre": [
				"gz3j0ph"
			],
			"levelID": "0ddb18m",
			"sc": 0,
			"pre_chall": 0,
			"scpre": 1,
			"n": "\"Temple Of Shade\" by Maoy",
			"scpost": 0,
			"weather": 0,
			"pre_gr18": 0,
			"b_time": 42,
			"pre_all": 0,
			"x": 1114,
			"y": -943,
			"scale": 0.56682926829268,
			"bm": 1,
			"main": 1,
			"ch": 1,
			"pre_coin": 0
		},
		{
			"gr18": 1,
			"t": 0,
			"pre": [
				"d2228fl"
			],
			"levelID": "4wvn070",
			"sc": 0,
			"pre_chall": 0,
			"scpre": 0,
			"n": "\"Laser Power Switch\" by WaddlesTNT",
			"scpost": 0,
			"weather": 0,
			"pre_gr18": 0,
			"b_time": 65,
			"pre_all": 0,
			"x": -21,
			"y": 80,
			"scale": 0.76585365853659,
			"bm": 0,
			"main": 1,
			"ch": 1,
			"pre_coin": 0
		},
		{
			"gr18": 1,
			"t": 0,
			"pre": [
				"6ss0v4j",
				"tz051h8",
				"4wvn070"
			],
			"levelID": "1v0m021",
			"sc": 0,
			"pre_chall": 0,
			"scpre": 0,
			"n": "\"Storm The Gateway\" by Glorious Cashew",
			"scpost": 0,
			"weather": 0,
			"pre_gr18": 0,
			"b_time": 45,
			"pre_all": 1,
			"x": -20,
			"y": -439,
			"scale": 0.6,
			"bm": 0,
			"main": 1,
			"ch": 0,
			"pre_coin": 0
		},
		{
			"gr18": 1,
			"t": 0,
			"pre": [
				"ckcpzb0"
			],
			"levelID": "tz0q5gb",
			"sc": 0,
			"pre_chall": 0,
			"scpre": 0,
			"n": "\"Canoodle Land\" by KoJi",
			"scpost": 0,
			"weather": 1,
			"pre_gr18": 0,
			"b_time": 40,
			"pre_all": 0,
			"x": -897,
			"y": 516,
			"scale": 0.51121951219512,
			"bm": 0,
			"main": 1,
			"ch": 1,
			"pre_coin": 0
		},
		{
			"gr18": 1,
			"t": 0,
			"pre": [
				"5990bm2"
			],
			"levelID": "0bsmn4f",
			"sc": 0,
			"pre_chall": 0,
			"scpre": 0,
			"n": "\"Ride Star Ridge\" by PureKnix",
			"scpost": 0,
			"weather": 0,
			"pre_gr18": 0,
			"b_time": 90,
			"pre_all": 0,
			"x": 2083,
			"y": -2817,
			"scale": 0.9,
			"bm": 2,
			"main": 1,
			"ch": 1,
			"pre_coin": 0
		},
		{
			"gr18": 0,
			"t": 0,
			"pre": [
				"64p02sf"
			],
			"levelID": "j8vqkf4",
			"sc": 0,
			"pre_chall": 0,
			"scpre": 0,
			"n": "\"Rebound Palace\" by SuperVillainLex",
			"scpost": 0,
			"weather": 0,
			"pre_gr18": 0,
			"b_time": 120,
			"pre_all": 0,
			"x": 91,
			"y": -2034,
			"scale": 0.8,
			"bm": 3,
			"main": 1,
			"ch": 0,
			"pre_coin": 0
		},
		{
			"gr18": 0,
			"t": 0,
			"pre": [
				"chcx-mlf95t-lhcc-levelNode-twf7l"
			],
			"sc": 1,
			"scpre": 0,
			"n": "TBD",
			"scpost": 0,
			"weather": 0,
			"pre_gr18": 0,
			"pre_all": 0,
			"x": -305,
			"y": -1411,
			"levelID": "chcx-mlf95t-lhcc-levelNode-bnvtl",
			"pre_chall": 0,
			"main": 0,
			"ch": 0,
			"pre_coin": 0
		},
		{
			"gr18": 0,
			"t": 0,
			"pre": [
				"v27r60z"
			],
			"levelID": "46p1c4k",
			"sc": 0,
			"pre_chall": 0,
			"scpre": 1,
			"n": "\"Palace Of Action Illusion\" by Dearg Doom",
			"scpost": 0,
			"weather": 0,
			"pre_gr18": 1,
			"b_time": 35,
			"pre_all": 0,
			"x": 1693,
			"y": 233,
			"scale": 0.80975609756098,
			"bm": 1,
			"main": 0,
			"ch": 0,
			"pre_coin": 0
		},
		{
			"gr18": 1,
			"t": 0,
			"pre": [
				"46p1c4k"
			],
			"levelID": "0mxrts3",
			"sc": 0,
			"pre_chall": 0,
			"scpre": 1,
			"n": "\"Lost Ruins\" by BAITness",
			"scpost": 0,
			"weather": 0,
			"pre_gr18": 0,
			"b_time": 150,
			"pre_all": 0,
			"x": 1962,
			"y": 544,
			"scale": 0.9,
			"bm": 1,
			"main": 0,
			"ch": 1,
			"pre_coin": 0
		},
		{
			"gr18": 0,
			"t": 0,
			"pre": [
				"1v0m021"
			],
			"levelID": "gz3j0ph",
			"sc": 0,
			"pre_chall": 0,
			"scpre": 0,
			"n": "\"The Peanut Of Doom.\" by ICErovTERROR",
			"scpost": 0,
			"weather": 0,
			"pre_gr18": 0,
			"b_time": 80,
			"pre_all": 0,
			"x": 162,
			"y": -793,
			"scale": 0.6,
			"bm": 0,
			"main": 1,
			"ch": 0,
			"pre_coin": 0
		},
		{
			"gr18": 1,
			"t": 0,
			"pre": [],
			"levelID": "ckcpzb0",
			"sc": 0,
			"pre_chall": 0,
			"scpre": 0,
			"n": "\"Ramshackle Bridge\" by Maoy",
			"scpost": 0,
			"weather": 0,
			"pre_gr18": 0,
			"b_time": 35,
			"pre_all": 0,
			"x": -1301,
			"y": 525,
			"scale": 0.7,
			"bm": 0,
			"main": 1,
			"ch": 1,
			"pre_coin": 0
		},
		{
			"gr18": 1,
			"t": 0,
			"pre": [
				"30sfcgk"
			],
			"levelID": "64p02sf",
			"sc": 0,
			"pre_chall": 0,
			"scpre": 0,
			"n": "\"Space Spark\" by Pawlogates",
			"scpost": 0,
			"weather": 1,
			"pre_gr18": 0,
			"b_time": 180,
			"pre_all": 0,
			"x": 560,
			"y": -2159,
			"scale": 0.9,
			"bm": 3,
			"main": 1,
			"ch": 1,
			"pre_coin": 0
		},
		{
			"gr18": 1,
			"t": 0,
			"pre": [
				"j8vqkf4"
			],
			"levelID": "nf933wx",
			"sc": 0,
			"pre_chall": 0,
			"scpre": 0,
			"n": "\"Dark Peak Castle\" by JeanneOskoure",
			"scpost": 0,
			"weather": 0,
			"pre_gr18": 0,
			"b_time": 180,
			"pre_all": 0,
			"x": -529,
			"y": -2047,
			"scale": 1,
			"bm": 3,
			"main": 1,
			"ch": 1,
			"pre_coin": 0
		},
		{
			"gr18": 0,
			"t": 0,
			"pre": [
				"nf933wx"
			],
			"levelID": "45xms67",
			"sc": 0,
			"pre_chall": 0,
			"scpre": 0,
			"n": "\"Mastery Of Space-Time\" by JeanneOskoure",
			"scpost": 0,
			"weather": 0,
			"pre_gr18": 1,
			"b_time": 240,
			"pre_all": 0,
			"x": -1043,
			"y": -1957,
			"scale": 0.8,
			"bm": 3,
			"main": 0,
			"ch": 1,
			"pre_coin": 0
		},
		{
			"gr18": 1,
			"t": 0,
			"pre": [
				"8kpdh0p"
			],
			"levelID": "0q54834",
			"sc": 0,
			"pre_chall": 0,
			"scpre": 0,
			"n": "\"Solid Steel Structure\" by Nanomical",
			"scpost": 0,
			"weather": 0,
			"pre_gr18": 0,
			"b_time": 45,
			"pre_all": 0,
			"x": 3371,
			"y": -148,
			"scale": 0.47317073170732,
			"bm": 1,
			"main": 1,
			"ch": 1,
			"pre_coin": 0
		},
		{
			"gr18": 0,
			"t": 0,
			"pre": [
				"0q54834"
			],
			"sc": 0,
			"levelID": "g0nkgqt",
			"scpre": 1,
			"n": "\"Blopfush Blaster\" by Reaun Da Crayon",
			"scpost": 0,
			"weather": 0,
			"pre_gr18": 0,
			"pre_chall": 1,
			"pre_all": 0,
			"x": 3132,
			"y": 280,
			"main": 0,
			"bm": 1,
			"scale": 0.5,
			"ch": 1,
			"pre_coin": 0
		},
		{
			"gr18": 1,
			"t": 0,
			"pre": [
				"0q54834"
			],
			"levelID": "wg06h3x",
			"sc": 0,
			"pre_chall": 0,
			"scpre": 0,
			"n": "\"Dangerous Elevator Business\" by SuperVillainLex",
			"scpost": 0,
			"weather": 0,
			"pre_gr18": 0,
			"b_time": 50,
			"pre_all": 0,
			"x": 3493,
			"y": -565,
			"scale": 0.8,
			"bm": 1,
			"main": 1,
			"ch": 1,
			"pre_coin": 0
		},
		{
			"gr18": 1,
			"t": 0,
			"pre": [
				"f1v0h1c",
				"fqx7njd"
			],
			"levelID": "5990bm2",
			"sc": 0,
			"pre_chall": 0,
			"scpre": 0,
			"n": "\"Ninja Rope Rise!\" by Green0ne",
			"scpost": 0,
			"weather": 1,
			"pre_gr18": 0,
			"b_time": 70,
			"pre_all": 1,
			"x": 2183,
			"y": -2333,
			"scale": 0.9,
			"bm": 2,
			"main": 1,
			"ch": 1,
			"pre_coin": 0
		},
		{
			"gr18": 1,
			"t": 0,
			"pre": [
				"j8vqkf4"
			],
			"levelID": "4835f7m",
			"sc": 0,
			"pre_chall": 0,
			"scpre": 0,
			"n": "\"Bump Up The Mushroom\" by Saltbearer",
			"scpost": 0,
			"weather": 1,
			"pre_gr18": 0,
			"b_time": 90,
			"pre_all": 0,
			"x": 70,
			"y": -2575,
			"scale": 0.8,
			"bm": 3,
			"main": 1,
			"ch": 1,
			"pre_coin": 0
		},
		{
			"gr18": 0,
			"t": 0,
			"pre": [
				"b8xxm0k"
			],
			"levelID": "30sfcgk",
			"sc": 0,
			"pre_chall": 0,
			"scpre": 0,
			"n": "\"Ouch! That Cart Hurt!\" by Mr Existent",
			"scpost": 0,
			"weather": 1,
			"pre_gr18": 0,
			"b_time": 35,
			"pre_all": 0,
			"x": 1005,
			"y": -2434,
			"scale": 0.6,
			"bm": 3,
			"main": 1,
			"ch": 0,
			"pre_coin": 0
		},
		{
			"gr18": 1,
			"t": 0,
			"pre": [
				"0bsmn4f"
			],
			"levelID": "b8xxm0k",
			"sc": 0,
			"pre_chall": 0,
			"scpre": 0,
			"n": "\"The Boss Is Meh!\" by Noob Jr",
			"scpost": 0,
			"weather": 1,
			"pre_gr18": 0,
			"b_time": 140,
			"pre_all": 0,
			"x": 2363,
			"y": -3158,
			"scale": 0.6,
			"bm": 2,
			"main": 1,
			"ch": 1,
			"pre_coin": 0
		},
		{
			"gr18": 1,
			"t": 0,
			"pre": [
				"wghjczd"
			],
			"levelID": "2zrmd5n",
			"sc": 0,
			"pre_chall": 0,
			"scpre": 0,
			"n": "\"The Grand Ascent\" by DFI01",
			"scpost": 0,
			"weather": 1,
			"pre_gr18": 0,
			"b_time": 135,
			"pre_all": 0,
			"x": 2892,
			"y": -2079,
			"scale": 0.9,
			"bm": 2,
			"main": 1,
			"ch": 1,
			"pre_coin": 0
		},
		{
			"gr18": 1,
			"t": 0,
			"pre": [
				"wghjczd"
			],
			"levelID": "ff2jgwx",
			"sc": 0,
			"pre_chall": 0,
			"scpre": 1,
			"n": "\"Vacsteak Dance Desert\" by MakeJake",
			"scpost": 0,
			"weather": 1,
			"pre_gr18": 0,
			"b_time": 70,
			"pre_all": 0,
			"x": 2481,
			"y": -1342,
			"scale": 1,
			"bm": 1,
			"main": 0,
			"ch": 1,
			"pre_coin": 1
		},
		{
			"gr18": 1,
			"t": 0,
			"pre": [
				"s1xrg4v"
			],
			"levelID": "wjwk1zj",
			"sc": 0,
			"pre_chall": 0,
			"scpre": 0,
			"n": "\"Void Blossom Curse\" by Green0ne",
			"scpost": 0,
			"weather": 0,
			"pre_gr18": 0,
			"b_time": 90,
			"pre_all": 0,
			"x": 2089,
			"y": -552,
			"scale": 0.88,
			"bm": 1,
			"main": 1,
			"ch": 1,
			"pre_coin": 0
		},
		{
			"gr18": 1,
			"t": 0,
			"pre": [
				"wjwk1zj"
			],
			"levelID": "bb1v39n",
			"sc": 0,
			"pre_chall": 0,
			"scpre": 0,
			"n": "\"The Jabber Run\" by Fr75s",
			"scpost": 0,
			"weather": 0,
			"pre_gr18": 0,
			"b_time": 28,
			"pre_all": 0,
			"x": 2536,
			"y": -578,
			"scale": 0.6,
			"bm": 1,
			"main": 1,
			"ch": 1,
			"pre_coin": 0
		},
		{
			"gr18": 0,
			"t": 0,
			"pre": [
				"wg06h3x"
			],
			"levelID": "pr82pvb",
			"sc": 0,
			"pre_chall": 0,
			"scpre": 0,
			"n": "\"Void Sky Battle\" by WaddlesTNT",
			"scpost": 0,
			"weather": 1,
			"pre_gr18": 0,
			"b_time": 195,
			"pre_all": 0,
			"x": 3498,
			"y": -940,
			"scale": 0.89170731707317,
			"bm": 1,
			"main": 1,
			"ch": 0,
			"pre_coin": 0
		},
		{
			"gr18": 0,
			"t": 0,
			"pre": [
				"2zrmd5n"
			],
			"levelID": "nsvjhvw",
			"sc": 0,
			"pre_chall": 0,
			"scpre": 0,
			"n": "\"Rip, Rise, And Zap\" by SuperVillainLex",
			"scpost": 0,
			"weather": 0,
			"pre_gr18": 0,
			"b_time": 35,
			"pre_all": 0,
			"x": 2476,
			"y": -1898,
			"scale": 0.7,
			"bm": 2,
			"main": 1,
			"ch": 0,
			"pre_coin": 0
		},
		{
			"gr18": 1,
			"t": 0,
			"pre": [
				"nsvjhvw"
			],
			"levelID": "f1v0h1c",
			"sc": 0,
			"pre_chall": 0,
			"scpre": 0,
			"n": "\"The Incredible Shade!\" by MakeJake",
			"scpost": 0,
			"weather": 0,
			"pre_gr18": 0,
			"b_time": 165,
			"pre_all": 0,
			"x": 1968,
			"y": -1910,
			"scale": 0.9,
			"bm": 3,
			"main": 1,
			"ch": 1,
			"pre_coin": 0
		},
		{
			"gr18": 1,
			"t": 0,
			"pre": [
				"50zz4sm"
			],
			"levelID": "d2228fl",
			"sc": 0,
			"pre_chall": 0,
			"scpre": 0,
			"n": "\"Hop, Zap And Jump!\" by MakeJake",
			"scpost": 0,
			"weather": 0,
			"pre_gr18": 0,
			"b_time": 45,
			"pre_all": 0,
			"x": 15,
			"y": 559,
			"scale": 1,
			"bm": 0,
			"main": 1,
			"ch": 1,
			"pre_coin": 0
		},
		{
			"gr18": 1,
			"t": 0,
			"pre": [
				"568wt38"
			],
			"levelID": "s1xrg4v",
			"sc": 0,
			"pre_chall": 0,
			"scpre": 0,
			"n": "\"Cliff Cavern Island\" by Kalhua",
			"scpost": 0,
			"weather": 0,
			"pre_gr18": 0,
			"b_time": 50,
			"pre_all": 0,
			"x": 1710,
			"y": -309,
			"scale": 1,
			"bm": 1,
			"main": 1,
			"ch": 1,
			"pre_coin": 0
		},
		{
			"gr18": 1,
			"t": 0,
			"pre": [
				"s1xrg4v"
			],
			"levelID": "v27r60z",
			"sc": 0,
			"pre_chall": 0,
			"scpre": 0,
			"n": "\"Abandoned Mine\" by JoeJoeCraft",
			"scpost": 0,
			"weather": 0,
			"pre_gr18": 0,
			"b_time": 60,
			"pre_all": 0,
			"x": 2058,
			"y": -12,
			"scale": 0.68390243902439,
			"bm": 1,
			"main": 1,
			"ch": 1,
			"pre_coin": 0
		},
		{
			"gr18": 1,
			"t": 0,
			"pre": [
				"2zrmd5n"
			],
			"levelID": "fqx7njd",
			"sc": 0,
			"pre_chall": 0,
			"scpre": 0,
			"n": "\"Mound About Mountain\" by PureKnix",
			"scpost": 0,
			"weather": 0,
			"pre_gr18": 0,
			"b_time": 70,
			"pre_all": 0,
			"x": 2850,
			"y": -2534,
			"scale": 0.7,
			"bm": 2,
			"main": 1,
			"ch": 1,
			"pre_coin": 0
		},
		{
			"gr18": 0,
			"t": 0,
			"pre": [
				"fgl2p0c"
			],
			"levelID": "f1q8bwk",
			"sc": 0,
			"pre_chall": 0,
			"scpre": 1,
			"n": "\"Warm Room\" by Slothybutt",
			"scpost": 0,
			"weather": 0,
			"pre_gr18": 0,
			"b_time": 50,
			"pre_all": 0,
			"x": -892,
			"y": -2688,
			"scale": 0.45560975609756,
			"bm": 3,
			"main": 0,
			"ch": 0,
			"pre_coin": 1
		},
		{
			"gr18": 0,
			"t": 0,
			"pre": [
				"pr82pvb"
			],
			"levelID": "wghjczd",
			"sc": 0,
			"pre_chall": 0,
			"scpre": 0,
			"n": "\"The Super-Jump Experience\" by Omnikar",
			"scpost": 0,
			"weather": 0,
			"pre_gr18": 0,
			"b_time": 40,
			"pre_all": 0,
			"x": 2869,
			"y": -1655,
			"scale": 0.7,
			"bm": 2,
			"main": 1,
			"ch": 0,
			"pre_coin": 0
		},
		{
			"gr18": 0,
			"t": 0,
			"pre": [
				"64p02sf"
			],
			"sc": 0,
			"scpre": 1,
			"n": "TBD",
			"scpost": 0,
			"weather": 0,
			"pre_gr18": 0,
			"pre_all": 0,
			"x": 263,
			"y": -1541,
			"levelID": "chcx-mlf95t-lhcc-levelNode-twf7l",
			"pre_chall": 0,
			"main": 0,
			"ch": 0,
			"pre_coin": 1
		},
		{
			"gr18": 0,
			"t": 0,
			"pre": [
				"chcx-mlf95t-lhcc-levelNode-365vn"
			],
			"sc": 0,
			"scpre": 0,
			"n": "TBD",
			"scpost": 0,
			"weather": 0,
			"pre_gr18": 0,
			"pre_all": 0,
			"x": -252,
			"y": -3385,
			"levelID": "chcx-mlf95t-lhcc-levelNode-4tsvp",
			"pre_chall": 0,
			"main": 1,
			"ch": 0,
			"pre_coin": 0
		},
		{
			"gr18": 1,
			"t": 0,
			"pre": [
				"tz0q5gb"
			],
			"levelID": "50zz4sm",
			"sc": 0,
			"pre_chall": 0,
			"scpre": 0,
			"n": "\"Rush Into Sprint Speed!\" by Ditchen Catastrophic",
			"scpost": 0,
			"weather": 1,
			"pre_gr18": 0,
			"b_time": 50,
			"pre_all": 0,
			"x": -477,
			"y": 580,
			"scale": 1,
			"bm": 0,
			"main": 1,
			"ch": 1,
			"pre_coin": 0
		}
	],
	"creatorName": "Maoy",
	"landmarks": [
		{
			"x": 197,
			"y": -2056,
			"elId": 8,
			"rot": 12,
			"dep": 29
		},
		{
			"sc": 0.99585416666667,
			"x": 483,
			"y": -617,
			"elId": 18,
			"rot": 0,
			"rsp": 10.5,
			"dep": 25
		},
		{
			"sc": 1,
			"rsp": 0,
			"rwig_spd": 0.5,
			"x": 1157,
			"y": -190,
			"rwig_amt": 11.625,
			"rot": 0,
			"elId": 17,
			"dep": 50
		},
		{
			"sc": 0.99585416666667,
			"x": 1358,
			"rsp": 7.5,
			"rwig_amt": 19.875,
			"elId": 16,
			"rot": 1700,
			"y": -1209,
			"dep": 46
		},
		{
			"sc": 1,
			"x": 1754,
			"y": -850,
			"elId": 12,
			"rot": -4,
			"xsp": 0,
			"dep": 45
		},
		{
			"x": 158,
			"rsp": 18,
			"elId": 8,
			"rot": -18.5,
			"y": 172,
			"dep": 12
		},
		{
			"sc": 1,
			"x": 2175,
			"rsp": -7.4999999999999,
			"rwig_amt": -0.75,
			"elId": 15,
			"rot": 13,
			"y": -2219,
			"dep": 25
		},
		{
			"x": 2886,
			"y": -287,
			"rwig_amt": 0,
			"elId": 8,
			"rot": 17.5,
			"rsp": -19.5,
			"dep": 24
		},
		{
			"sc": 0.99585416666667,
			"xwig_spd": 0.83333333333333,
			"elId": 3,
			"xwig_amt": 6.25,
			"x": 376,
			"y": -469,
			"rot": -10,
			"ywig_amt": 2.0833333333333,
			"dep": 71
		},
		{
			"x": 1096,
			"y": -1015,
			"rwig_amt": 0,
			"elId": 11,
			"rot": 65.5,
			"rsp": 7.5,
			"dep": 30
		},
		{
			"rsp": 0,
			"elId": 4,
			"xwig_amt": 12.5,
			"x": -175,
			"ywig_amt": 6.25,
			"y": -1405,
			"ysp": 4.1666666666666,
			"rot": -8,
			"xsp": 4.1666666666666,
			"dep": 50
		},
		{
			"x": -900,
			"rsp": -1.4999999999999,
			"xsp": 0,
			"elId": 13,
			"rot": -8.75,
			"y": -300,
			"dep": 25
		},
		{
			"x": 883.50000000909,
			"rsp": -4.5,
			"elId": 11,
			"rot": 12.75,
			"y": 95,
			"dep": 25
		},
		{
			"sc": 0.99585416666667,
			"rwig_spd": 0,
			"elId": 1,
			"x": -1301,
			"y": 585,
			"rwig_amt": 5.25,
			"dep": 25,
			"rot": -10,
			"ywig_amt": 0,
			"rwig_off": 26.25
		},
		{
			"ywig_spd": 0.33333333333333,
			"xsp": 0,
			"xwig_spd": 0.41666666666667,
			"elId": 0,
			"xwig_amt": 18.75,
			"x": 7.5000000909495,
			"y": 40,
			"ywig_amt": 8.3333333333334,
			"rot": -3,
			"sc": 0.99585416666667,
			"dep": 49
		},
		{
			"x": 905,
			"y": -2214,
			"rwig_amt": 0.375,
			"elId": 7,
			"rot": -1.25,
			"rsp": 1.5,
			"dep": 44
		}
	],
	"version": 4
}

