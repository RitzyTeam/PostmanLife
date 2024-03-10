extends Node3D

@onready var spot_light_3d = $SpotLight3D
@onready var anim_light = $anim_light

func _ready():
	SIN_WORLD_SIGNALS.LIGHTS_ON.connect(_lights_on)
	SIN_WORLD_SIGNALS.LIGHTS_OFF.connect(_lights_off)

func _lights_on():
	anim_light.play("lights_on")

func _lights_off():
	anim_light.play("lights_off")
