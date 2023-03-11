## A bunch of utility functions
extends Node

var window = JavaScriptBridge.get_interface("window")

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

func set_file(name : String, data : String, folder : String):
	if OS.has_feature("HTML5") and OS.has_feature("JavaScript"):
	# saves campaign in browser's local storage
		window.localStorage.setItem(name, data)
	
	else:
		#save in file
		var file = FileAccess.open(folder + name + ".json", FileAccess.WRITE)
		file.store_string(data)
		file = null

func get_file(name : String, folder : String) -> String:
	if OS.has_feature("HTML5") and OS.has_feature("JavaScript"):
	# saves campaign in browser's local storage
		return window.localStorage.getItem(name)

	else:
		var file = FileAccess.open(folder + name + ".json", FileAccess.READ)
		var content = file.get_as_text()
		file = null
		return content

func get_files_that_match_uc(folder : String):
	var files = []
	var dir = DirAccess.open(folder)
	dir.list_dir_begin() # TODOGODOT4 fill missing arguments https://github.com/godotengine/godot/pull/40547
	if OS.has_feature("HTML5") and OS.has_feature("JavaScript"):
		for key in range(0,window.localStorage.length):
			if window.localStorage.key(key).left(3) == "UC_":
				var test_json_conv = JSON.new()
				test_json_conv.parse(window.localStorage.getItem(window.localStorage.key(key)))
				var campaign_out = test_json_conv.get_data()
				if campaign_out.error == OK:
					files.append(campaign_out.result)
		return files
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif file.left(3) == "UC_":
			print(file)
			var file_buf = FileAccess.open(folder + file, FileAccess.READ)
			var campaign_out
			var test_json_conv = JSON.new()
			test_json_conv.parse(file_buf.get_as_text())
			campaign_out = test_json_conv.get_data()
			file_buf.close()
			if campaign_out:
				files.append(campaign_out)
			else:
				printerr("Error %d while parsing %s at line %d:" % [campaign_out.error, file, campaign_out.error_line])
				printerr(campaign_out.error_string)
	
	dir.list_dir_end()
	
	return files

	
