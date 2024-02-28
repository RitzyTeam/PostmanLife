extends Node

@onready var sun: DirectionalLight3D = $WorldEnv/Sun

# DAY TIME
var time_hours: int = 0
var time_minutes: int = 0
var tod: int = 0

var isTimeOfWork: bool = false

func _ready():
	tod = SIN_WORLD_DATA.WORLD_DATA['tod']
	time_hours = int(tod/60)
	time_minutes = int(tod%60)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

#region SERVERS
# ХОД ВРЕМЕНИ
func _on_timer_daycycle_timeout():
	if tod < 1439:
		tod += 1
		time_hours = int(tod/60)
		time_minutes = int(tod%60)
	else:
		SIN_WORLD_DATA.value_day_passed()
		tod = 0
		time_hours = int(tod/60)
		time_minutes = int(tod%60)
	SIN_WORLD_DATA.value_tod_changed(tod)

# РАБОЧАЯ СМЕНА. ПРОВЕРКА. С 9-18.
func checkIsItTimeOfWork():
	return time_hours >= 9 and time_hours < 18
#endregion
