extends ParallaxLayer

onready var landmark_sprite := $AnimatedSprite


var x := 0
var y := 0
var xsp := 0
var elId := 0 # ID of the landmark graphics
var rot := 0 # rotation
var dep := 0 # "depth" = scrolling
var rsp := 0 # rotation speed
var sc := 1 # scale

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
		position = Vector2(json.x, json.y)
	for key in json.keys():
		if key in self:
			self[key] = json[key]
			if key == "sc":
				scale = Vector2(json[key],json[key])
			elif key == "dep":
				motion_scale = Vector2(json[key],json[key])
			#ToDo: implement rotation and shaking
		else:
			print("PROPERTY NOT KNOWN: " + key)

func to_dict() -> Dictionary:
	var dict_out := dict_base.duplicate(true)
	
	for key in dict_out.keys():
		if key in self:
			dict_out[key] = self[key]
	return dict_out

func _ready():
	landmark_sprite.play(String(elId))
