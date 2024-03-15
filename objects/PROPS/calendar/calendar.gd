extends MeshInstance3D

func _ready():
	SIN_WORLD_SIGNALS.WORK_DAY_START.connect(update_calendar)

func update_calendar():
	$day.text = str(SIN_WORLD_DATA.WORLD_DATA['day_num'])
