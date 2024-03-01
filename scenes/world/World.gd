extends Node

# EXPORTS
@export var car: PackedScene

@onready var sun: DirectionalLight3D = $WorldEnv/Sun

# DAY TIME
var time_hours: int = 0
var time_minutes: int = 0

var isTimeOfWork: bool = false

func _ready():
	set_tod()

#region WORLD

#endregion

#region TIME
# ЗАГРУЗКА ВРЕМЕНИ
func set_tod():
	time_hours = int(SIN_WORLD_DATA.WORLD_DATA['tod']/60)
	time_minutes = int(SIN_WORLD_DATA.WORLD_DATA['tod']%60)

# ХОД ВРЕМЕНИ
func _on_timer_daycycle_timeout():
	if SIN_WORLD_DATA.WORLD_DATA['tod'] < 1439:
		SIN_WORLD_DATA.WORLD_DATA['tod'] += 1
	else:
		SIN_WORLD_DATA.WORLD_DATA['day_num'] += 1
		SIN_WORLD_DATA.WORLD_DATA['tod'] = 0
	time_hours = int(SIN_WORLD_DATA.WORLD_DATA['tod']/60)
	time_minutes = int(SIN_WORLD_DATA.WORLD_DATA['tod']%60)

# РАБОЧАЯ СМЕНА. ПРОВЕРКА. С 9-18.
func checkIsItTimeOfWork():
	return time_hours >= 9 and time_hours < 18
#endregion
