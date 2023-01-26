extends PanelContainer

onready var CampaignTitle := $VBoxContainer/CampaignTitle/Label
onready var SavedCampaigns := $VBoxContainer/HBoxContainer/Menu/Campaigns/SavedLevelsContainer/SavedLevelsContainer/Campaigns

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


func _on_Campaigns_item_selected(index):
	if "campaignName" in SavedCampaigns.get_item_metadata(index):
		CampaignTitle.text = SavedCampaigns.get_item_metadata(index).campaignName
	else:
		CampaignTitle.text = "No Title."
	


func _on_Campaigns_item_activated(index):
	emit_signal("load_campaign_from_start_menu", SavedCampaigns.get_item_metadata(index))


func _on_Return_pressed():
	hide()

func _ready():
	if HIDE_RETURN_ON_START_FLAG:
		$Return.hide()
