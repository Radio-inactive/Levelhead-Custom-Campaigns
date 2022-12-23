## A bunch of utility functions
extends Node

func apply_dict_to_obj(dict : Dictionary, obj : Object, key : String):
	if key in obj:
		obj[key] = dict[key]
	else:
		print("PROPERTY NOT KNOWN: " + key)

func apply_all_dict_to_obj(dict : Dictionary, obj : Object):
	for key in dict.keys():
		apply_dict_to_obj(dict, obj, key)

static func delete_children(node):
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()
