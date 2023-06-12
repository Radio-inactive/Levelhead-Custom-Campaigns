extends VBoxContainer

const width_break_point := 900

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	if get_viewport().size.x < width_break_point:
		hide()
	else:
		show()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
