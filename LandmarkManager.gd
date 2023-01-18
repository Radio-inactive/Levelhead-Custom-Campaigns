extends Node2D

var Landmark := load("res://Landmark.tscn")

func load_landmarks_from_array(landmarks):
	if landmarks == null:
		return
	for landmark in landmarks:
		var scene = Landmark.instance()
		scene.instance_from_json(landmark)
		add_child(scene)

func get_landmarks_as_dict_array():
	var land_out := []
	for landmark in get_children():
		land_out.append(landmark.to_dict())
	return land_out
