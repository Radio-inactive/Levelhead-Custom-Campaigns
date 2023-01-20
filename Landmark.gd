extends AnimatedSprite

var x := 0
var y := 0
var xsp := 0
var elId := 0 # ID of the landmark graphics
var rot := 0 # rotation
var dep := 0 # "depth" = parallax
var depthFactor: float = 0 # 0 menas attached to world, 1 means attached to camera
var rsp := 0 # rotation speed
var sc := 1 # scale
var world_pos := Vector2.ZERO
var world_scale : = Vector2.ONE

const dict_base := {
	"x":0,
	"y":0,
	"xsp":0,
	"elId":0,
	"rot":0,
	"dep":0,
	"rsp":0,
	"sc":0
}

func instance_from_json(json):
	if "x" in json and "y" in json:
		world_pos = Vector2(json.x, json.y)
	for key in json.keys():
		if key in self:
			self[key] = json[key]
			if key == "sc":
				world_scale = Vector2(json[key],json[key])
			elif key == "dep":
				# landmarks with higher depth appear behind those with lower depth in LH
				z_index = 100 - json.dep
				# put it behind level nodes & co
				z_index -= 100
				var factor := json.dep as float
				factor /= 100
				factor = factor*factor
				depthFactor = factor
			elif key == "rot":
				rotation_degrees = -json.rot
			#ToDo: implement motion
		else:
			print("PROPERTY NOT KNOWN: " + key)

func to_dict() -> Dictionary:
	var dict_out := dict_base.duplicate(true)
	
	for key in dict_out.keys():
		if key in self:
			dict_out[key] = self[key]
	return dict_out

func _ready():
	play(String(elId))
	
func _process(_delta):
	var cam = getCurrentCamera2D()
	if not cam:
		return
	var cam_pos = cam.global_position + world_pos
	position = lerp(world_pos, cam_pos, depthFactor)
	var cam_scale = world_scale * cam.zoom
	scale = lerp(world_scale, cam_scale, depthFactor)

# Godot why
# It's in 4, and there's a PR to bring it to 3 https://github.com/godotengine/godot/pull/69426
func getCurrentCamera2D() -> Camera2D:
	var viewport = get_viewport()
	if not viewport:
		return null
	var camerasGroupName = "__cameras_%d" % viewport.get_viewport_rid().get_id()
	var cameras = get_tree().get_nodes_in_group(camerasGroupName)
	for camera in cameras:
		if camera is Camera2D and camera.current:
			return camera
	return null
