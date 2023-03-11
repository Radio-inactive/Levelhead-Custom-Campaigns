extends AnimatedSprite2D

var x := 0.0
var y := 0.0
@export var xsp := 0
enum lm_type{HUGE_ASTEROID = 0, SMALL_ASTEROID, MEDIUM_ASTEROID, BS_HQ, SQUID,
			TERRARIUM, GRAY_PLANET, MASSIVE_CORAL, RED_CONTAINER, GREEN_CONTAINER,
			ORANGE_CONTAINER, GRAY_CONTAINER, CORAL_PIECE, LONG_CORAL, WHIRL_CORAL,
			WHITE_PLANET, BLUE_PLANET, EYE_PLANET, ASTEROID_PIECE_1, ASTEROID_PIECE_2,
			UNUSED_SATURN, UNUSED_SEMIPLANET}
@export var elId: lm_type # ID of the landmark graphics
@export var rot := 0 # rotation
@export var dep := 0 # "depth" = parallax
var depthFactor: float = 0 # 0 menas attached to world, 1 means attached to camera
@export var rsp := 0 # rotation speed
@export var sc := 1 # scale
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
	play(str(elId))
	if x == 0.0: x = position.x
	if y == 0.0: y = position.y
	

func _process(_delta):
	var cam = get_viewport().get_camera_2d()
	if not cam:
		return
	var cam_pos = cam.global_position + world_pos
	position = lerp(world_pos, cam_pos, depthFactor)
	var cam_scale = world_scale * cam.zoom
	scale = lerp(world_scale, cam_scale, depthFactor)
