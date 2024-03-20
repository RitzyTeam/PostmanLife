extends StaticBody3D

var isLightsOn: bool = false
@onready var anim = $anim

func interract():
	if not anim.is_playing():
		isLightsOn = not isLightsOn
		if isLightsOn:
			SIN_WORLD_SIGNALS.emit_signal('OFFICE_LIGHTS_ON')
			$switch.pitch_scale = 1.0
			anim.play("on")
			$switch.play()
		else:
			SIN_WORLD_SIGNALS.emit_signal('OFFICE_LIGHTS_OFF')
			anim.play("off")
			$switch.pitch_scale = 0.8
			$switch.play()
