extends Node

# EXPORTS
@export var car: PackedScene

@onready var sun: DirectionalLight3D = $WorldEnv/Sun
@onready var anim_tod = $WorldEnv/anim_tod

# DAY TIME
var time_hours: int = 0
var time_minutes: int = 0
var tod: int = 0

var isTimeOfWork: bool = false

func _ready():
	set_tod()
	spawn_car()

func spawn_car():
	var obj_car = car.instantiate()
	add_child(obj_car)
	obj_car.global_position = SIN_WORLD_DATA.WORLD_DATA['car_last_pos']
	obj_car.global_rotation = SIN_WORLD_DATA.WORLD_DATA['car_last_rot']

#region TIME
# ЗАГРУЗКА ВРЕМЕНИ ИЗ ФАЙЛА
func set_tod():
	tod = SIN_WORLD_DATA.WORLD_DATA['tod']
	time_hours = int(tod/60)
	time_minutes = int(tod%60)
	anim_tod.play("tod")
	anim_tod.seek(tod)

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
