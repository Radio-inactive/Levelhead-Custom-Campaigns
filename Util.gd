## A bunch of utility functions
extends Node

var window = JavaScript.get_interface("window")

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
		var file = File.new()
		file.open(folder + name + ".json", File.WRITE)
		file.store_string(data)
		file.close()

func get_file(name : String, folder : String) -> String:
	if OS.has_feature("HTML5") and OS.has_feature("JavaScript"):
	# saves campaign in browser's local storage
		return window.localStorage.getItem(name)

	else:
		var file = File.new()
		file.open(folder + name + ".json", File.READ)
		var content = file.get_as_text()
		file.close()
		return content

func get_files_that_match_uc(folder : String):
	var files = []
	var dir = Directory.new()
	dir.open(folder)
	dir.list_dir_begin()
	if OS.has_feature("HTML5") and OS.has_feature("JavaScript"):
		for key in range(0,window.localStorage.length):
			if window.localStorage.key(key).left(3) == "UC_":
				var campaign_out = JSON.parse(window.localStorage.getItem(window.localStorage.key(key)))
				if campaign_out.error == OK:
					files.append(campaign_out.result)
		return files
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif file.left(3) == "UC_":
			print(file)
			var file_buf = File.new();
			var campaign_out
			file_buf.open(folder + file, File.READ)
			campaign_out = JSON.parse(file_buf.get_as_text())
			file_buf.close()
			if campaign_out.error == OK:
				files.append(campaign_out.result)
	
	dir.list_dir_end()
	
	return files

	
