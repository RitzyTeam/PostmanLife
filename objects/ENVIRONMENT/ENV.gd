extends Node3D

@export var thunderbolt: PackedScene

@onready var we = $WE
@onready var sun = $Sun
@onready var weather_rainy = $WEATHER_RAINY
@onready var weather_snowy = $WEATHER_SNOWY

# OBJECTS
@onready var ufo = $"../../MOBS/ufo"

var time_hours: int = 0
var time_minutes: int = 0

var player: Object = null
var state: String = 'idle'
var weather_id: String = 'clear'

func _ready():
	SIN_WORLD_SIGNALS.WEATHER_RAINY.connect(_set_weather_rainy)
	SIN_WORLD_SIGNALS.WEATHER_SNOWY.connect(_set_weather_snowy)
	# === WEATHER
	var arr =  get_tree().get_nodes_in_group('player')
	player = arr[0]
	state = 'player_looking'
	# === SETTINGS
	load_graphic_settings()
	launch_tod()

func load_graphic_settings():
	# SET UP SHADOWS
	match SIN_SETTINGS.SETTINGS['GRAPHICS']['shadows']:
		'no':
			sun.shadow_enabled = false
		'bad':
			sun.directional_shadow_mode = DirectionalLight3D.SHADOW_ORTHOGONAL
			sun.shadow_enabled = true
		'mid':
			sun.directional_shadow_mode = DirectionalLight3D.SHADOW_PARALLEL_2_SPLITS
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
		SIN_WORLD_DATA.value_day_passed()
		SIN_WORLD_DATA.WORLD_DATA['tod'] = 0
		SIN_WORLD_SIGNALS.emit_signal('TOD_DAY_ENDED')
	time_hours = int(SIN_WORLD_DATA.WORLD_DATA['tod']/60)
	time_minutes = int(SIN_WORLD_DATA.WORLD_DATA['tod']%60)
	match_tod()

# ВСЕ ДЕЙСТВИЯ С ВРЕМЕНЕМ
func match_tod():
	# УПРАВЛЕНИЕ ФОНАРЯМИ
	match SIN_WORLD_DATA.WORLD_DATA['tod']:
		1300:
			SIN_WORLD_SIGNALS.emit_signal('LIGHTS_ON')
		120:
			SIN_WORLD_SIGNALS.emit_signal('LIGHTS_OFF')
		# НОВЫЙ РАБОЧИЙ ДЕНЬ НАЧАЛО В 9 УТРА
		540:
			SIN_WORLD_DATA.new_quota()
			SIN_WORLD_SIGNALS.emit_signal('WORK_DAY_START')
		# РАБОЧИЙ ДЕНЬ КОНЧИЛСЯ В 6 ВЕЧЕРА
		1080:
			SIN_WORLD_SIGNALS.emit_signal('WORK_DAY_END')
	spawnMOBS()

# РАБОЧАЯ СМЕНА. ПРОВЕРКА. С 9-18.
func isItTimeOfWork():
	return time_hours >= 9 and time_hours < 18

func spawnMOBS():
	# UFO
	if SIN_WORLD_DATA.WORLD_DATA['tod'] >= 1300 or SIN_WORLD_DATA.WORLD_DATA['tod'] <= 120:
		ufo.visible = true
	else:
		ufo.visible = false


# =============================== WEATHER ======================================

func _physics_process(delta):
	state_machine()
	if not player == null:
		state = 'player_looking'
	if player == null:
		state = 'seeking_for_player'
	
func state_machine():
	match state: 
		'player_looking':
			if not player == null:
				position = player.global_position
		'seeking_for_player':
			state = 'locked'
			var target_car: Object = null
			var cars: Array = get_tree().get_nodes_in_group('car')
			for i in range(cars.size()):
				if cars[i]['item']['isPlayerInside']:
					target_car = cars[i]
			player = target_car

func _input(event):
	if event.is_action_pressed("key_e"):
		var isPlayerInAnyCar: bool = false
		var cars: Array = get_tree().get_nodes_in_group('car')
		for i in range(cars.size()):
			if cars[i]['item']['isPlayerInside']:
				isPlayerInAnyCar = true
		if not isPlayerInAnyCar:
			var arr =  get_tree().get_nodes_in_group('player')
			player = arr[0]

# === WEATHERS

func _set_weather_clear():
	weather_id = 'clear'
	weather_rainy.visible = false
	weather_rainy.emitting = false
	
	weather_snowy.visible = false
	weather_snowy.emitting = false
	
	var tween = create_tween()
	tween.tween_property(we, 'environment:volumetric_fog_density', 0, 15)
	tween.play()

func _set_weather_rainy():
	weather_id = 'rainy'
	weather_rainy.visible = true
	weather_rainy.emitting = true
	
	weather_snowy.visible = false
	weather_snowy.emitting = false
	
	var tween = create_tween()
	var tween2 = create_tween()
	var tween3 = create_tween()
	tween.tween_property(we, 'environment:volumetric_fog_density', 0.1, 15)
	tween2.tween_property(we, 'environment:volumetric_fog_albedo', Color('7f7f7f'), 15)
	tween3.tween_property(we, 'environment:volumetric_fog_emission', Color('7f7f7f'), 15)
	
func _set_weather_snowy():
	weather_id = 'snowy'
	weather_snowy.visible = true
	weather_snowy.emitting = true
	
	weather_rainy.visible = false
	weather_rainy.emitting = false
	
	var tween = create_tween()
	var tween2 = create_tween()
	var tween3 = create_tween()
	tween.tween_property(we, 'environment:volumetric_fog_density', 0.1, 15)
	tween2.tween_property(we, 'environment:volumetric_fog_albedo', Color('ffffff'), 15)
	tween3.tween_property(we, 'environment:volumetric_fog_emission', Color('ffffff'), 15)
		
func _set_weather_foggy():
	weather_id = 'foggy'
	weather_snowy.visible = false
	weather_snowy.emitting = false
	
	weather_rainy.visible = false
	weather_rainy.emitting = false
	
	var tween = create_tween()
	var tween2 = create_tween()
	var tween3 = create_tween()
	tween.tween_property(we, 'environment:volumetric_fog_density', 0.3, 15)
	tween2.tween_property(we, 'environment:volumetric_fog_albedo', Color('7f7f7f'), 15)
	tween3.tween_property(we, 'environment:volumetric_fog_emission', Color('7f7f7f'), 15)

func _set_weather_thunder():
	weather_id = 'thunder'
	weather_snowy.visible = false
	weather_snowy.emitting = false
	
	weather_rainy.visible = false
	weather_rainy.emitting = false
	
	var tween = create_tween()
	var tween2 = create_tween()
	var tween3 = create_tween()
	tween.tween_property(we, 'environment:volumetric_fog_density', 0.3, 15)
	tween2.tween_property(we, 'environment:volumetric_fog_albedo', Color('7f7f7f'), 15)
	tween3.tween_property(we, 'environment:volumetric_fog_emission', Color('7f7f7f'), 15)

func _on_timer_switch_weather_timeout():
	$timer_switch_weather.wait_time = randi_range(240, 1440)
	var weather_id: int = randi_range(0,3)
	match weather_id:
		0:
			_set_weather_clear()
		1:
			_set_weather_foggy()
		2:
			_set_weather_snowy()
		3:
			_set_weather_rainy()
	$timer_switch_weather.start()

func _on_timer_spawn_thunderbolts_timeout():
	if weather_id == 'thunder':
		var spawn_radius: int = 100
		$timer_spawn_thunderbolts.wait_time = randi_range(15, 40)
		var bolt = thunderbolt.instantiate()
		get_tree().get_root().add_child(bolt)
		bolt.global_position = Vector3(player.global_position.x + randi_range(-spawn_radius,spawn_radius), global_position.y, player.global_position.z + randi_range(-spawn_radius,spawn_radius))
	$timer_spawn_thunderbolts.start()
