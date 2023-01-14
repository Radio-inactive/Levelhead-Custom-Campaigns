extends PanelContainer

onready var CampaignTitle := $VBoxContainer/CampaignTitle/Label
onready var SavedCampaigns := $VBoxContainer/HBoxContainer/Menu/Campaigns/SavedLevelsContainer/SavedLevelsContainer/ScrollContainer/Campaigns

var saved_campaigns_dict : Array

signal load_campaign_from_start_menu(campaign)

func load_saved_campaigns(campaigns : Array):
	SavedCampaigns.clear()
	
	for campaign in campaigns:
		if "creatorName" in campaign:
			SavedCampaigns.add_item(campaign.creatorName)
		else:
			SavedCampaigns.add_item("Unknown Creator")
	saved_campaigns_dict = campaigns
	CampaignTitle.text = ""


func _on_Campaigns_item_selected(index):
	if "campaignName" in saved_campaigns_dict[index]:
		CampaignTitle.text = saved_campaigns_dict[index].campaignName
	else:
		CampaignTitle.text = "No Title."
	


func _on_Campaigns_item_activated(index):
	emit_signal("load_campaign_from_start_menu", saved_campaigns_dict[index])
