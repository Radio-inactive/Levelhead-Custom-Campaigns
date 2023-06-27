extends VBoxContainer

onready var completed = $Completed
onready var jems = $Jems
onready var bugs = $Bugs
onready var gr17 = $GR17
onready var otd = $OTDs
onready var scores = $Scores

onready var completed_label: Label = $Completed/Label
onready var jems_label: Label = $Jems/Label
onready var bugs_label: Label = $Bugs/Label
onready var gr17_label: Label = $GR17/Label
onready var otd_label: Label = $OTDs/Label
onready var scores_label: Label = $Scores/Label

onready var total_completion = $Total

func update_stats(stats):
	completed_label.text = str(stats.completed_got) + "/" + str(stats.completed_total)
	if stats.jem_total != 0:
		jems_label.text = str(stats.jem_got) + "/" + str(stats.jem_total)
	else: jems.hide()
	if stats.bug_total != 0:
		bugs_label.text = str(stats.bug_got) + "/" + str(stats.bug_total)
	else: bugs.hide()
	if stats.gr17_total != 0:
		gr17_label.text = str(stats.gr17_got) + "/" + str(stats.gr17_total)
	else: gr17.hide()
	if stats.otd_total != 0:
		otd_label.text = str(stats.otd_got) + "/" + str(stats.otd_total)
	else: otd.hide()
	if stats.score_total != 0:
		scores_label.text = str(stats.score_got) + "/" + str(stats.score_total)
	else: scores.hide()
	total_completion.text = "%.2f%%" % stats.get_completion_percentage()


