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
	"landmarks": [
		{
			"x": 1754,
			"y": -850,
			"elId": 12,
			"dep": 45,
			"xsp": 0,
			"rot": -4,
			"sc": 1
		},
		{
			"elId": 8,
			"y": 172,
			"dep": 12,
			"x": 158,
			"rot": -18.5,
			"rsp": 18
		},
		{
			"rwig_amt": 19.875,
			"x": 1358,
			"y": -1209,
			"elId": 16,
			"dep": 46,
			"sc": 0.99585416666667,
			"rot": 1700,
			"rsp": 7.5
		},
		{
			"elId": 8,
			"rot": 12,
			"dep": 29,
			"x": 197,
			"y": -2056
		},
		{
			"rwig_amt": 0,
			"x": 2886,
			"rot": 17.5,
			"dep": 24,
			"elId": 8,
			"y": -287,
			"rsp": -19.5
		},
		{
			"rwig_amt": -0.75,
			"x": 2175,
			"y": -2219,
			"elId": 15,
			"dep": 25,
			"sc": 1,
			"rot": 13,
			"rsp": -7.4999999999999
		},
		{
			"xwig_spd": 0.83333333333333,
			"elId": 3,
			"y": -469,
			"ywig_amt": 2.0833333333333,
			"rot": -10,
			"dep": 71,
			"x": 376,
			"xwig_amt": 6.25,
			"sc": 0.99585416666667
		},
		{
			"x": -175,
			"y": -1405,
			"ywig_amt": 6.25,
			"ysp": 4.1666666666666,
			"rot": -8,
			"elId": 4,
			"dep": 50,
			"xsp": 4.1666666666666,
			"xwig_amt": 12.5,
			"rsp": 0
		},
		{
			"rwig_amt": 0.375,
			"x": 905,
			"rot": -1.25,
			"dep": 44,
			"elId": 7,
			"y": -2214,
			"rsp": 1.5
		},
		{
			"elId": 11,
			"y": 95,
			"dep": 25,
			"x": 883.50000000909,
			"rot": 12.75,
			"rsp": -4.5
		},
		{
			"x": -900,
			"y": -300,
			"elId": 13,
			"dep": 25,
			"xsp": 0,
			"rot": -8.75,
			"rsp": -1.4999999999999
		},
		{
			"xwig_spd": 0.41666666666667,
			"x": 7.5000000909495,
			"y": 40,
			"ywig_amt": 8.3333333333334,
			"elId": 0,
			"rot": -3,
			"xsp": 0,
			"dep": 49,
			"ywig_spd": 0.33333333333333,
			"xwig_amt": 18.75,
			"sc": 0.99585416666667
		},
		{
			"rwig_spd": 0,
			"y": 585,
			"ywig_amt": 0,
			"rwig_amt": 5.25,
			"rot": -10,
			"elId": 1,
			"dep": 25,
			"x": -1301,
			"rwig_off": 26.25,
			"sc": 0.99585416666667
		},
		{
			"rwig_amt": 0,
			"x": 1096,
			"rot": 65.5,
			"dep": 30,
			"elId": 11,
			"y": -1015,
			"rsp": 7.5
		},
		{
			"elId": 18,
			"y": -617,
			"x": 483,
			"dep": 25,
			"rsp": 10.5,
			"rot": 0,
			"sc": 0.99585416666667
		},
		{
			"rwig_spd": 0.5,
			"y": -190,
			"rwig_amt": 11.625,
			"rot": 0,
			"x": 1157,
			"dep": 50,
			"rsp": 0,
			"elId": 17,
			"sc": 1
		}
	],
	"version": 11,
	"mapNodes": [
		{
			"t": 0,
			"levelID": "s1xrg4v",
			"scpost": 0,
			"pre_gr18": 0,
			"pre_all": 0,
			"b_time": 50,
			"pre_chall": 0,
			"ch": 1,
			"weather": 0,
			"gr18": 1,
			"x": 1710,
			"y": -309,
			"pre": [
				"568wt38"
			],
			"n": "\"Cliff Cavern Island\" by Kalhua",
			"main": 1,
			"pre_coin": 0,
			"scpre": 0,
			"scale": 1,
			"bm": 1,
			"sc": 0
		},
		{
			"levelID": "g0nkgqt",
			"scpost": 0,
			"pre_gr18": 0,
			"pre_all": 0,
			"pre_coin": 0,
			"pre_chall": 1,
			"ch": 1,
			"weather": 0,
			"gr18": 0,
			"x": 3132,
			"y": 280,
			"pre": [
				"0q54834"
			],
			"n": "\"Blopfush Blaster\" by Reaun Da Crayon",
			"main": 0,
			"scpre": 1,
			"scale": 0.5,
			"bm": 1,
			"t": 0,
			"sc": 0
		},
		{
			"t": 0,
			"levelID": "4p35222",
			"scpost": 0,
			"pre_gr18": 0,
			"pre_all": 0,
			"b_time": 32,
			"pre_chall": 0,
			"ch": 0,
			"weather": 0,
			"gr18": 0,
			"x": 263,
			"y": -1541,
			"pre": [
				"64p02sf"
			],
			"n": "\"Big Brain Time\" by Glorious Cashew",
			"main": 0,
			"pre_coin": 0,
			"scpre": 1,
			"scale": 0.4,
			"bm": 0,
			"sc": 0
		},
		{
			"t": 0,
			"levelID": "64p02sf",
			"scpost": 0,
			"pre_gr18": 0,
			"pre_all": 0,
			"b_time": 180,
			"pre_chall": 0,
			"ch": 1,
			"weather": 1,
			"gr18": 1,
			"x": 560,
			"y": -2159,
			"pre": [
				"30sfcgk"
			],
			"n": "\"Space Spark\" by Pawlogates",
			"main": 1,
			"pre_coin": 0,
			"scpre": 0,
			"scale": 0.9,
			"bm": 3,
			"sc": 0
		},
		{
			"t": 0,
			"levelID": "b8xxm0k",
			"scpost": 0,
			"pre_gr18": 0,
			"pre_all": 0,
			"b_time": 120,
			"pre_chall": 0,
			"ch": 1,
			"weather": 1,
			"gr18": 1,
			"x": 2363,
			"y": -3158,
			"pre": [
				"0bsmn4f"
			],
			"n": "\"The Boss Is Meh!\" by Noob Jr",
			"main": 1,
			"pre_coin": 0,
			"scpre": 0,
			"scale": 0.6,
			"bm": 2,
			"sc": 0
		},
		{
			"t": 0,
			"levelID": "45xms67",
			"scpost": 0,
			"pre_gr18": 1,
			"pre_all": 0,
			"b_time": 600,
			"pre_chall": 0,
			"ch": 1,
			"weather": 0,
			"gr18": 0,
			"x": -1043,
			"y": -1957,
			"pre": [
				"nf933wx"
			],
			"n": "\"Mastery Of Space-Time\" by JeanneOskoure",
			"main": 0,
			"pre_coin": 0,
			"scpre": 0,
			"scale": 0.8,
			"bm": 3,
			"sc": 0
		},
		{
			"t": 0,
			"levelID": "nf933wx",
			"scpost": 0,
			"pre_gr18": 0,
			"pre_all": 0,
			"b_time": 180,
			"pre_chall": 0,
			"ch": 1,
			"weather": 0,
			"gr18": 1,
			"x": -529,
			"y": -2047,
			"pre": [
				"j8vqkf4"
			],
			"n": "\"Dark Peak Castle\" by JeanneOskoure",
			"main": 1,
			"pre_coin": 0,
			"scpre": 0,
			"scale": 1,
			"bm": 3,
			"sc": 0
		},
		{
			"t": 0,
			"levelID": "1v0m021",
			"scpost": 0,
			"pre_gr18": 0,
			"pre_all": 1,
			"b_time": 45,
			"pre_chall": 0,
			"ch": 0,
			"weather": 0,
			"gr18": 1,
			"x": -20,
			"y": -439,
			"pre": [
				"6ss0v4j",
				"tz051h8",
				"4wvn070"
			],
			"n": "\"Storm The Gateway\" by Glorious Cashew",
			"main": 1,
			"pre_coin": 0,
			"scpre": 0,
			"scale": 0.6,
			"bm": 0,
			"sc": 0
		},
		{
			"t": 0,
			"levelID": "wjwk1zj",
			"scpost": 0,
			"pre_gr18": 0,
			"pre_all": 0,
			"b_time": 90,
			"pre_chall": 0,
			"ch": 1,
			"weather": 0,
			"gr18": 1,
			"x": 2089,
			"y": -552,
			"pre": [
				"s1xrg4v"
			],
			"n": "\"Void Blossom Curse\" by Green0ne",
			"main": 1,
			"pre_coin": 0,
			"scpre": 0,
			"scale": 0.88,
			"bm": 1,
			"sc": 0
		},
		{
			"t": 0,
			"levelID": "568wt38",
			"scpost": 0,
			"pre_gr18": 0,
			"pre_all": 0,
			"b_time": 65,
			"pre_chall": 0,
			"ch": 1,
			"weather": 0,
			"gr18": 1,
			"x": 1460,
			"y": -734,
			"pre": [
				"0ddb18m"
			],
			"n": "\"Shady Cannon Canyon\" by Arity",
			"main": 1,
			"pre_coin": 0,
			"scpre": 0,
			"scale": 0.79512195121951,
			"bm": 1,
			"sc": 0
		},
		{
			"t": 0,
			"levelID": "30sfcgk",
			"scpost": 0,
			"pre_gr18": 0,
			"pre_all": 0,
			"b_time": 35,
			"pre_chall": 0,
			"ch": 0,
			"weather": 1,
			"gr18": 0,
			"x": 1005,
			"y": -2434,
			"pre": [
				"b8xxm0k"
			],
			"n": "\"Ouch! That Cart Hurt!\" by Mr Existent",
			"main": 1,
			"pre_coin": 0,
			"scpre": 1,
			"scale": 0.6,
			"bm": 3,
			"sc": 0
		},
		{
			"t": 0,
			"levelID": "wg06h3x",
			"scpost": 0,
			"pre_gr18": 0,
			"pre_all": 0,
			"b_time": 50,
			"pre_chall": 0,
			"ch": 1,
			"weather": 0,
			"gr18": 1,
			"x": 3493,
			"y": -565,
			"pre": [
				"0q54834"
			],
			"n": "\"Dangerous Elevator Business\" by SuperVillainLex",
			"main": 1,
			"pre_coin": 0,
			"scpre": 0,
			"scale": 0.8,
			"bm": 1,
			"sc": 0
		},
		{
			"t": 0,
			"levelID": "fdbdq8k",
			"scpost": 0,
			"pre_gr18": 1,
			"pre_all": 0,
			"b_time": 135,
			"pre_chall": 0,
			"ch": 1,
			"weather": 1,
			"gr18": 1,
			"x": 3336,
			"y": -2671,
			"pre": [
				"fqx7njd"
			],
			"n": "\"Peanut Temple Puzzle\" by SpyRay",
			"main": 0,
			"pre_coin": 0,
			"scpre": 1,
			"scale": 0.64,
			"bm": 2,
			"sc": 0
		},
		{
			"t": 0,
			"levelID": "5990bm2",
			"scpost": 0,
			"pre_gr18": 0,
			"pre_all": 1,
			"b_time": 70,
			"pre_chall": 0,
			"ch": 1,
			"weather": 1,
			"gr18": 1,
			"x": 2183,
			"y": -2333,
			"pre": [
				"f1v0h1c",
				"fqx7njd"
			],
			"n": "\"Ninja Rope Rise!\" by Green0ne",
			"main": 1,
			"pre_coin": 0,
			"scpre": 0,
			"scale": 0.9,
			"bm": 2,
			"sc": 0
		},
		{
			"t": 0,
			"levelID": "fqx7njd",
			"scpost": 0,
			"pre_gr18": 0,
			"pre_all": 0,
			"b_time": 70,
			"pre_chall": 0,
			"ch": 1,
			"weather": 0,
			"gr18": 1,
			"x": 2850,
			"y": -2534,
			"pre": [
				"2zrmd5n"
			],
			"n": "\"Mound About Mountain\" by PureKnix",
			"main": 1,
			"pre_coin": 0,
			"scpre": 0,
			"scale": 0.7,
			"bm": 2,
			"sc": 0
		},
		{
			"t": 0,
			"levelID": "4wvn070",
			"scpost": 0,
			"pre_gr18": 0,
			"pre_all": 0,
			"b_time": 65,
			"pre_chall": 0,
			"ch": 1,
			"weather": 0,
			"gr18": 1,
			"x": -21,
			"y": 80,
			"pre": [
				"d2228fl"
			],
			"n": "\"Laser Power Switch\" by WaddlesTNT",
			"main": 1,
			"pre_coin": 0,
			"scpre": 0,
			"scale": 0.76585365853659,
			"bm": 0,
			"sc": 0
		},
		{
			"t": 0,
			"levelID": "0q54834",
			"scpost": 0,
			"pre_gr18": 0,
			"pre_all": 0,
			"b_time": 45,
			"pre_chall": 0,
			"ch": 1,
			"weather": 0,
			"gr18": 1,
			"x": 3371,
			"y": -148,
			"pre": [
				"8kpdh0p"
			],
			"n": "\"Solid Steel Structure\" by Nanomical",
			"main": 1,
			"pre_coin": 0,
			"scpre": 0,
			"scale": 0.47317073170732,
			"bm": 1,
			"sc": 0
		},
		{
			"t": 0,
			"levelID": "bb1v39n",
			"scpost": 0,
			"pre_gr18": 0,
			"pre_all": 0,
			"b_time": 28,
			"pre_chall": 0,
			"ch": 1,
			"weather": 0,
			"gr18": 1,
			"x": 2536,
			"y": -578,
			"pre": [
				"wjwk1zj"
			],
			"n": "\"The Jabber Run\" by Fr75s",
			"main": 1,
			"pre_coin": 0,
			"scpre": 0,
			"scale": 0.6,
			"bm": 1,
			"sc": 0
		},
		{
			"t": 0,
			"levelID": "2zrmd5n",
			"scpost": 0,
			"pre_gr18": 0,
			"pre_all": 0,
			"b_time": 135,
			"pre_chall": 0,
			"ch": 1,
			"weather": 1,
			"gr18": 1,
			"x": 2892,
			"y": -2079,
			"pre": [
				"wghjczd"
			],
			"n": "\"The Grand Ascent\" by DFI01",
			"main": 1,
			"pre_coin": 0,
			"scpre": 0,
			"scale": 0.9,
			"bm": 2,
			"sc": 0
		},
		{
			"t": 0,
			"levelID": "wc5dkk5",
			"scpost": 0,
			"pre_gr18": 0,
			"pre_all": 0,
			"b_time": 35,
			"pre_chall": 1,
			"ch": 0,
			"weather": 0,
			"gr18": 1,
			"x": 1385,
			"y": -1759,
			"pre": [
				"f1v0h1c"
			],
			"n": "\"Forgotten Fissure\" by TheViralMelon",
			"main": 0,
			"pre_coin": 0,
			"scpre": 1,
			"scale": 0.6,
			"bm": 3,
			"sc": 0
		},
		{
			"t": 0,
			"levelID": "f1v0h1c",
			"scpost": 0,
			"pre_gr18": 0,
			"pre_all": 0,
			"b_time": 155,
			"pre_chall": 0,
			"ch": 1,
			"weather": 0,
			"gr18": 1,
			"x": 1968,
			"y": -1910,
			"pre": [
				"nsvjhvw"
			],
			"n": "\"The Incredible Shade!\" by MakeJake",
			"main": 1,
			"pre_coin": 0,
			"scpre": 0,
			"scale": 0.9,
			"bm": 3,
			"sc": 0
		},
		{
			"t": 0,
			"levelID": "8kpdh0p",
			"scpost": 0,
			"pre_gr18": 0,
			"pre_all": 1,
			"b_time": 70,
			"pre_chall": 0,
			"ch": 1,
			"weather": 1,
			"gr18": 1,
			"x": 2873,
			"y": -287,
			"pre": [
				"bb1v39n",
				"8qzl087"
			],
			"n": "\"Vacrat High Way\" by ICErovTERROR",
			"main": 1,
			"pre_coin": 0,
			"scpre": 0,
			"scale": 1,
			"bm": 1,
			"sc": 0
		},
		{
			"t": 0,
			"levelID": "ff2jgwx",
			"scpost": 0,
			"pre_gr18": 0,
			"pre_all": 0,
			"b_time": 70,
			"pre_chall": 0,
			"ch": 1,
			"weather": 1,
			"gr18": 1,
			"x": 2481,
			"y": -1342,
			"pre": [
				"wghjczd"
			],
			"n": "\"Vacsteak Dance Desert\" by MakeJake",
			"main": 0,
			"pre_coin": 1,
			"scpre": 1,
			"scale": 1,
			"bm": 1,
			"sc": 0
		},
		{
			"t": 0,
			"levelID": "4835f7m",
			"scpost": 0,
			"pre_gr18": 0,
			"pre_all": 0,
			"b_time": 90,
			"pre_chall": 0,
			"ch": 1,
			"weather": 1,
			"gr18": 1,
			"x": 70,
			"y": -2575,
			"pre": [
				"j8vqkf4"
			],
			"n": "\"Bump Up The Mushroom\" by Saltbearer",
			"main": 1,
			"pre_coin": 0,
			"scpre": 0,
			"scale": 0.8,
			"bm": 3,
			"sc": 0
		},
		{
			"levelID": "chcx-mlf95t-lhcc-levelNode-bnvtl",
			"scpost": 0,
			"pre_gr18": 0,
			"pre_all": 0,
			"pre_coin": 0,
			"pre_chall": 0,
			"ch": 0,
			"weather": 0,
			"gr18": 0,
			"x": -305,
			"y": -1411,
			"pre": [
				"4p35222"
			],
			"n": "Missing Secret Level (coming soon!)",
			"main": 0,
			"scpre": 0,
			"t": 0,
			"sc": 1
		},
		{
			"t": 0,
			"levelID": "p30mfks",
			"scpost": 0,
			"pre_gr18": 0,
			"pre_all": 0,
			"b_time": 32,
			"pre_chall": 0,
			"ch": 1,
			"weather": 0,
			"gr18": 1,
			"x": -664,
			"y": 175,
			"pre": [
				"50zz4sm"
			],
			"n": "\"Rip The Sky\" by Fr75s",
			"main": 1,
			"pre_coin": 0,
			"scpre": 0,
			"scale": 0.75121951219512,
			"bm": 0,
			"sc": 0
		},
		{
			"t": 0,
			"levelID": "0bsmn4f",
			"scpost": 0,
			"pre_gr18": 0,
			"pre_all": 0,
			"b_time": 90,
			"pre_chall": 0,
			"ch": 1,
			"weather": 0,
			"gr18": 1,
			"x": 2083,
			"y": -2817,
			"pre": [
				"5990bm2"
			],
			"n": "\"Ride Star Ridge\" by PureKnix",
			"main": 1,
			"pre_coin": 0,
			"scpre": 0,
			"scale": 0.9,
			"bm": 2,
			"sc": 0
		},
		{
			"t": 0,
			"levelID": "tz051h8",
			"scpost": 0,
			"pre_gr18": 0,
			"pre_all": 0,
			"b_time": 75,
			"pre_chall": 0,
			"ch": 1,
			"weather": 0,
			"gr18": 1,
			"x": 424,
			"y": -195,
			"pre": [
				"6k5pvv0"
			],
			"n": "\"Power Extract\" by Kalhua",
			"main": 1,
			"pre_coin": 0,
			"scpre": 0,
			"scale": 1,
			"bm": 0,
			"sc": 0
		},
		{
			"levelID": "6ss0v4j",
			"scpost": 0,
			"pre_gr18": 0,
			"pre_all": 0,
			"pre_coin": 0,
			"pre_chall": 0,
			"ch": 0,
			"weather": 0,
			"gr18": 0,
			"x": -461,
			"y": -270,
			"pre": [
				"p30mfks"
			],
			"n": "\"Power Planet Destroy\" by JoeJoeCraft",
			"main": 1,
			"scpre": 0,
			"scale": 0.49073170731707,
			"bm": 0,
			"t": 0,
			"sc": 0
		},
		{
			"t": 0,
			"levelID": "6k5pvv0",
			"scpost": 0,
			"pre_gr18": 0,
			"pre_all": 0,
			"b_time": 47,
			"pre_chall": 0,
			"ch": 1,
			"weather": 1,
			"gr18": 1,
			"x": 626,
			"y": 275,
			"pre": [
				"s70td0k"
			],
			"n": "\"The Forgotten Factory\" by DomoZam",
			"main": 1,
			"pre_coin": 0,
			"scpre": 0,
			"scale": 0.80390243902439,
			"bm": 0,
			"sc": 0
		},
		{
			"t": 0,
			"levelID": "s70td0k",
			"scpost": 0,
			"pre_gr18": 0,
			"pre_all": 0,
			"b_time": 80,
			"pre_chall": 0,
			"ch": 1,
			"weather": 0,
			"gr18": 1,
			"x": 438,
			"y": 624,
			"pre": [
				"d2228fl"
			],
			"n": "\"Rebound Up The Tower!\" by Radio Inactive",
			"main": 1,
			"pre_coin": 0,
			"scpre": 0,
			"scale": 0.65756097560976,
			"bm": 0,
			"sc": 0
		},
		{
			"t": 0,
			"levelID": "j8vqkf4",
			"scpost": 0,
			"pre_gr18": 0,
			"pre_all": 0,
			"b_time": 120,
			"pre_chall": 0,
			"ch": 0,
			"weather": 0,
			"gr18": 0,
			"x": 91,
			"y": -2034,
			"pre": [
				"64p02sf"
			],
			"n": "\"Rebound Palace\" by SuperVillainLex",
			"main": 1,
			"pre_coin": 0,
			"scpre": 0,
			"scale": 0.8,
			"bm": 3,
			"sc": 0
		},
		{
			"t": 0,
			"levelID": "0ddb18m",
			"scpost": 0,
			"pre_gr18": 0,
			"pre_all": 0,
			"b_time": 42,
			"pre_chall": 0,
			"ch": 1,
			"weather": 0,
			"gr18": 0,
			"x": 1114,
			"y": -943,
			"pre": [
				"gz3j0ph"
			],
			"n": "\"Temple Of Shade\" by Maoy",
			"main": 1,
			"pre_coin": 0,
			"scpre": 1,
			"scale": 0.56682926829268,
			"bm": 1,
			"sc": 0
		},
		{
			"t": 0,
			"levelID": "gz3j0ph",
			"scpost": 0,
			"pre_gr18": 0,
			"pre_all": 0,
			"b_time": 80,
			"pre_chall": 0,
			"ch": 0,
			"weather": 0,
			"gr18": 0,
			"x": 162,
			"y": -793,
			"pre": [
				"1v0m021"
			],
			"n": "\"The Peanut Of Doom.\" by ICErovTERROR",
			"main": 1,
			"pre_coin": 0,
			"scpre": 0,
			"scale": 0.6,
			"bm": 0,
			"sc": 0
		},
		{
			"t": 0,
			"levelID": "7jt5w2k",
			"scpost": 0,
			"pre_gr18": 0,
			"pre_all": 0,
			"b_time": 240,
			"pre_chall": 0,
			"ch": 0,
			"weather": 1,
			"gr18": 0,
			"x": -252,
			"y": -3385,
			"pre": [
				"qjbv3rb"
			],
			"n": "\"Harbinger Of The End\" by Slothy Oskoure Jr",
			"main": 1,
			"pre_coin": 0,
			"scpre": 0,
			"scale": 0.7,
			"bm": 3,
			"sc": 0
		},
		{
			"t": 0,
			"levelID": "0mxrts3",
			"scpost": 0,
			"pre_gr18": 0,
			"pre_all": 0,
			"b_time": 150,
			"pre_chall": 0,
			"ch": 1,
			"weather": 0,
			"gr18": 1,
			"x": 1962,
			"y": 544,
			"pre": [
				"46p1c4k"
			],
			"n": "\"Lost Ruins\" by BAITness",
			"main": 0,
			"pre_coin": 0,
			"scpre": 1,
			"scale": 0.9,
			"bm": 1,
			"sc": 0
		},
		{
			"t": 0,
			"levelID": "wghjczd",
			"scpost": 0,
			"pre_gr18": 0,
			"pre_all": 0,
			"b_time": 40,
			"pre_chall": 0,
			"ch": 0,
			"weather": 0,
			"gr18": 0,
			"x": 2869,
			"y": -1655,
			"pre": [
				"pr82pvb"
			],
			"n": "\"The Super-Jump Experience\" by Omnikar",
			"main": 1,
			"pre_coin": 0,
			"scpre": 1,
			"scale": 0.7,
			"bm": 2,
			"sc": 0
		},
		{
			"t": 0,
			"levelID": "nsvjhvw",
			"scpost": 0,
			"pre_gr18": 0,
			"pre_all": 0,
			"b_time": 40,
			"pre_chall": 0,
			"ch": 0,
			"weather": 0,
			"gr18": 0,
			"x": 2476,
			"y": -1898,
			"pre": [
				"2zrmd5n"
			],
			"n": "\"Rip, Rise, And Zap\" by SuperVillainLex",
			"main": 1,
			"pre_coin": 0,
			"scpre": 0,
			"scale": 0.7,
			"bm": 2,
			"sc": 0
		},
		{
			"t": 0,
			"levelID": "qjbv3rb",
			"scpost": 0,
			"pre_gr18": 0,
			"pre_all": 0,
			"b_time": 180,
			"pre_chall": 0,
			"ch": 1,
			"weather": 1,
			"gr18": 1,
			"x": -238,
			"y": -3052,
			"pre": [
				"4835f7m",
				"fgl2p0c"
			],
			"n": "\"Illusion Machine\" by Maoy",
			"main": 1,
			"pre_coin": 0,
			"scpre": 0,
			"scale": 1,
			"bm": 3,
			"sc": 0
		},
		{
			"t": 0,
			"levelID": "ckcpzb0",
			"scpost": 0,
			"pre_gr18": 0,
			"pre_all": 0,
			"b_time": 35,
			"pre_chall": 0,
			"ch": 1,
			"weather": 0,
			"gr18": 1,
			"x": -1301,
			"y": 525,
			"pre": [],
			"n": "\"Ramshackle Bridge\" by Maoy",
			"main": 1,
			"pre_coin": 0,
			"scpre": 0,
			"scale": 0.7,
			"bm": 0,
			"sc": 0
		},
		{
			"t": 0,
			"levelID": "8qzl087",
			"scpost": 0,
			"pre_gr18": 0,
			"pre_all": 0,
			"b_time": 35,
			"pre_chall": 0,
			"ch": 1,
			"weather": 0,
			"gr18": 1,
			"x": 2537,
			"y": -40,
			"pre": [
				"v27r60z"
			],
			"n": "\"Bounce Cavern\" by FlowArt",
			"main": 1,
			"pre_coin": 0,
			"scpre": 0,
			"scale": 0.7,
			"bm": 1,
			"sc": 0
		},
		{
			"t": 0,
			"levelID": "50zz4sm",
			"scpost": 0,
			"pre_gr18": 0,
			"pre_all": 0,
			"b_time": 50,
			"pre_chall": 0,
			"ch": 1,
			"weather": 1,
			"gr18": 1,
			"x": -477,
			"y": 580,
			"pre": [
				"tz0q5gb"
			],
			"n": "\"Rush Into Sprint Speed!\" by Ditchen Catastrophic",
			"main": 1,
			"pre_coin": 0,
			"scpre": 0,
			"scale": 1,
			"bm": 0,
			"sc": 0
		},
		{
			"t": 0,
			"levelID": "d2228fl",
			"scpost": 0,
			"pre_gr18": 0,
			"pre_all": 0,
			"b_time": 45,
			"pre_chall": 0,
			"ch": 1,
			"weather": 0,
			"gr18": 1,
			"x": 15,
			"y": 559,
			"pre": [
				"50zz4sm"
			],
			"n": "\"Hop, Zap And Jump!\" by MakeJake",
			"main": 1,
			"pre_coin": 0,
			"scpre": 0,
			"scale": 1,
			"bm": 0,
			"sc": 0
		},
		{
			"t": 0,
			"levelID": "tz0q5gb",
			"scpost": 0,
			"pre_gr18": 0,
			"pre_all": 0,
			"b_time": 40,
			"pre_chall": 0,
			"ch": 1,
			"weather": 1,
			"gr18": 1,
			"x": -897,
			"y": 516,
			"pre": [
				"ckcpzb0"
			],
			"n": "\"Canoodle Land\" by KoJi",
			"main": 1,
			"pre_coin": 0,
			"scpre": 0,
			"scale": 0.51121951219512,
			"bm": 0,
			"sc": 0
		},
		{
			"t": 0,
			"levelID": "6pxd96b",
			"scpost": 0,
			"pre_gr18": 0,
			"pre_all": 0,
			"b_time": 40,
			"pre_chall": 0,
			"ch": 0,
			"weather": 0,
			"gr18": 0,
			"x": -892,
			"y": -2688,
			"pre": [
				"fgl2p0c"
			],
			"n": "\"Warm Room\" by Slothybutt",
			"main": 0,
			"pre_coin": 1,
			"scpre": 1,
			"scale": 0.45560975609756,
			"bm": 3,
			"sc": 0
		},
		{
			"t": 0,
			"levelID": "fgl2p0c",
			"scpost": 0,
			"pre_gr18": 0,
			"pre_all": 0,
			"b_time": 60,
			"pre_chall": 0,
			"ch": 0,
			"weather": 0,
			"gr18": 0,
			"x": -507,
			"y": -2584,
			"pre": [
				"nf933wx"
			],
			"n": "\"Tower Dark\" by Slothybutt",
			"main": 1,
			"pre_coin": 0,
			"scpre": 0,
			"scale": 0.7,
			"bm": 3,
			"sc": 0
		},
		{
			"t": 0,
			"levelID": "46p1c4k",
			"scpost": 0,
			"pre_gr18": 1,
			"pre_all": 0,
			"b_time": 35,
			"pre_chall": 0,
			"ch": 0,
			"weather": 0,
			"gr18": 0,
			"x": 1693,
			"y": 233,
			"pre": [
				"v27r60z"
			],
			"n": "\"Palace Of Action Illusion\" by Dearg Doom",
			"main": 0,
			"pre_coin": 0,
			"scpre": 1,
			"scale": 0.80975609756098,
			"bm": 1,
			"sc": 0
		},
		{
			"t": 0,
			"levelID": "v27r60z",
			"scpost": 0,
			"pre_gr18": 0,
			"pre_all": 0,
			"b_time": 60,
			"pre_chall": 0,
			"ch": 1,
			"weather": 0,
			"gr18": 1,
			"x": 2058,
			"y": -12,
			"pre": [
				"s1xrg4v"
			],
			"n": "\"Abandoned Mine\" by JoeJoeCraft",
			"main": 1,
			"pre_coin": 0,
			"scpre": 0,
			"scale": 0.68390243902439,
			"bm": 1,
			"sc": 0
		},
		{
			"t": 0,
			"levelID": "310qt18",
			"scpost": 0,
			"pre_gr18": 1,
			"pre_all": 0,
			"b_time": 22,
			"pre_chall": 0,
			"ch": 1,
			"weather": 1,
			"gr18": 1,
			"x": 3338,
			"y": -1991,
			"pre": [
				"2zrmd5n"
			],
			"n": "\"Carry The Shade, GR-18!\" by Mr Existent",
			"main": 0,
			"pre_coin": 0,
			"scpre": 1,
			"scale": 0.53756097560976,
			"bm": 2,
			"sc": 0
		},
		{
			"t": 0,
			"levelID": "pr82pvb",
			"scpost": 0,
			"pre_gr18": 0,
			"pre_all": 0,
			"b_time": 195,
			"pre_chall": 0,
			"ch": 0,
			"weather": 1,
			"gr18": 0,
			"x": 3498,
			"y": -940,
			"pre": [
				"wg06h3x"
			],
			"n": "\"Void Sky Battle\" by WaddlesTNT",
			"main": 1,
			"pre_coin": 0,
			"scpre": 0,
			"scale": 0.89170731707317,
			"bm": 1,
			"sc": 0
		},
		{
			"t": 0,
			"levelID": "nxbd4wc",
			"scpost": 0,
			"pre_gr18": 1,
			"pre_all": 0,
			"b_time": 150,
			"pre_chall": 0,
			"ch": 1,
			"weather": 0,
			"gr18": 0,
			"x": 996,
			"y": 470,
			"pre": [
				"6k5pvv0"
			],
			"n": "\"Destruction Plateau Climb\" by ICErovTERROR",
			"main": 0,
			"pre_coin": 0,
			"scpre": 1,
			"scale": 0.8,
			"bm": 0,
			"sc": 0
		},
		{
			"t": 0,
			"levelID": "b5jfb0x",
			"scpost": 0,
			"pre_gr18": 0,
			"pre_all": 0,
			"b_time": 45,
			"pre_chall": 0,
			"ch": 1,
			"weather": 0,
			"gr18": 1,
			"x": -944,
			"y": -222,
			"pre": [
				"p30mfks"
			],
			"n": "\"Blopsack Bounce\" by iLoveKittens",
			"main": 0,
			"pre_coin": 1,
			"scpre": 1,
			"scale": 0.77170731707317,
			"bm": 0,
			"sc": 0
		}
	],
	"creatorName": "Maoy",
	"creatorCode": "mlf95t",
	"campaignName": "Community Campaign"
}



func _on_LinkButton_pressed():
	OS.shell_open('https://level-kit.netlify.app/setting/')


func _on_Button_pressed():
	download_lhcc_progress()
