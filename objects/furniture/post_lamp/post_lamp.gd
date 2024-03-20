extends Node3D

func _ready():
	SIN_WORLD_SIGNALS.OFFICE_LIGHTS_OFF.connect(_lights_off)
	SIN_WORLD_SIGNALS.OFFICE_LIGHTS_ON.connect(_lights_on)

func _lights_off():
	$anim.play('off')

func _lights_on():
	$anim.play('on')
