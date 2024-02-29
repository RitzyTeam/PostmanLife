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
	SIN_WORLD_SIGNALS.SAVE_WORLD.connect(_save_world)
	set_tod()

#region WORLD
func _save_world():
	var package = ClassScenePacker.create_package(self)
	ResourceSaver.save(package, SIN_WORLD_DATA.world_path)
#endregion

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
