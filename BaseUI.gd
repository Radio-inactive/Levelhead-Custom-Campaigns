extends Control

onready var CampaignTitle := $VBoxContainer/CampaignTitle/Label
onready var SavedCampaigns := $VBoxContainer/HBoxContainer/Menu/Campaigns/SavedLevelsContainer/SavedLevelsContainer/Campaigns
onready var FileLoad := $FileLoad
onready var FileLoadMessage := $FileLoad/PanelContainer/VBoxContainer/Message

export var HIDE_RETURN_ON_START_FLAG := true

signal load_campaign_from_start_menu(campaign)

func load_saved_campaigns(campaigns : Array):
	SavedCampaigns.clear()
	for campaign in campaigns:
		if "creatorName" in campaign:
			SavedCampaigns.add_item(campaign.creatorName)
			SavedCampaigns.set_item_metadata(SavedCampaigns.get_item_count()-1, campaign)
		else:
			SavedCampaigns.add_item("Unknown Creator")
			SavedCampaigns.set_item_metadata(SavedCampaigns.get_item_count()-1, campaign)
	CampaignTitle.text = ""

func show_return():
	$Return.show()

func _on_Campaigns_item_selected(index):
	if "campaignName" in SavedCampaigns.get_item_metadata(index):
		CampaignTitle.text = SavedCampaigns.get_item_metadata(index).campaignName
	else:
		CampaignTitle.text = "No Title."
	

func _on_Campaigns_item_activated(index):
	emit_signal("load_campaign_from_start_menu", SavedCampaigns.get_item_metadata(index))
	show_return()

func _on_Return_pressed():
	hide()

func _ready():
	if HIDE_RETURN_ON_START_FLAG:
		$Return.hide()


func _on_Load_pressed():
	FileLoad.show()
	FileLoadMessage.hide()

# FILE LOADING

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
