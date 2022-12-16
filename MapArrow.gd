extends Button

var destination : String

signal move_ship_to(destination)


func _on_MapArrow_pressed():
	emit_signal("move_ship_to", self.destination)
