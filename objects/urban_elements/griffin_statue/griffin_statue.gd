extends StaticBody3D

func _ready():
	SIN_WORLD_SIGNALS.TOD_DAY_ENDED.connect(_day_ended)
	

func _day_ended():
	$roar.play()
