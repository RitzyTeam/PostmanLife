extends Node3D

@onready var we = $WE
@onready var sun = $Sun

var time_hours: int = 0
var time_minutes: int = 0

func _ready():
	load_graphic_settings()
	launch_tod()

func load_graphic_settings():
	# SET UP SHADOWS
	match SIN_SETTINGS.SETTINGS['GRAPHICS']['shadows']:
		'no':
			sun.shadow_enabled = false
		'bad':
			sun.light.directional_shadow_mode = DirectionalLight3D.SHADOW_ORTHOGONAL
			sun.shadow_enabled = true
		'mid':
			sun.light.directional_shadow_mode = DirectionalLight3D.SHADOW_PARALLEL_2_SPLITS
			sun.shadow_enabled = true
		'good':
			sun.directional_shadow_mode = DirectionalLight3D.SHADOW_PARALLEL_4_SPLITS
			sun.shadow_enabled = true
	# SET UP BLOOM
	match SIN_SETTINGS.SETTINGS['GRAPHICS']['glow']:
		'no':
			we.environment.glow_enabled = false
		'yes':
			we.environment.glow_enabled = true
	match SIN_SETTINGS.SETTINGS['GRAPHICS']['sdfgi']:
		'no':
			we.environment.sdfgi_enabled = false
		'yes':
			we.environment.sdfgi_enabled = true
	match SIN_SETTINGS.SETTINGS['GRAPHICS']['ssao']:
		'no':
			we.environment.ssao_enabled = false
		'yes':
			we.environment.ssao_enabled = true

func launch_tod():
	time_hours = int(SIN_WORLD_DATA.WORLD_DATA['tod']/60)
	time_minutes = int(SIN_WORLD_DATA.WORLD_DATA['tod']%60)
	$timer_daycycle.start()
	$anim.play('tod')
	$anim.seek(SIN_WORLD_DATA.WORLD_DATA['tod'])


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
func isItTimeOfWork():
	return time_hours >= 9 and time_hours < 18
