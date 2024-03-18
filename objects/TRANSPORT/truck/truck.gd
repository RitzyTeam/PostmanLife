extends VehicleBody3D

@export var player: PackedScene
var current_tank: Object = null
var isEngineOn: bool = false

var item: Dictionary = {
	'id': 'car',
	'res_fuel': 20.0,
	'res_energy': 100.0,
	'isPlayerInside': false
}

@onready var wheel_1 = $wheel_1
@onready var wheel_2 = $wheel_2
@onready var wheel_3 = $wheel_3
@onready var wheel_4 = $wheel_4
@onready var pos_of_exit = $pos_of_exit
@onready var rul = $rul_hinge/rul
@onready var handle = $automat/handle

# CAR SYSTEMS
var isFlashlightsOn: bool = false
# PLAYER-RELATED
# RESOURCES
var max_fuel: float = 20.0
@export var consumption_fuel: float = 0.002 ## FUEL CONSUMPTION PER FRAME (DRIVING CAR)
@export var consumption_energy: float = 0.001 ## ENERGY CONSUMPTION PER FRAME (LIGHTS AND ALERTS)
# RUL ANIMATION
var steer_points: float = 0.0
var max_steer_points: float = 720.0
# WHEEL SETTINGS
var wheel_stiffness: float = 200
var wheel_max_force: float = 12000.0
var wheel_travel_distance: float = 0.1
# ENGINE SETTINGS
@export var MAX_STEER: float = 0.4 ## POWER OF CAR ROTATION
@export var MAX_TORQUE: float = 5000 ## POWER OF CAR ENGINE
@export var MAX_RPM: int = 500 ## POWER OF CAR WHEEL ROTATION
# ANIMATORS
@onready var anim_flashlights = $anim_flashlights


func _ready():
	# SET CAMERA FAR FROM SETTINGS
	$CAMERA.far = SIN_SETTINGS.SETTINGS['GRAPHICS']['far']
	# SET STIFFNESS
	wheel_1.suspension_stiffness = wheel_stiffness
	wheel_2.suspension_stiffness = wheel_stiffness
	wheel_3.suspension_stiffness = wheel_stiffness
	wheel_4.suspension_stiffness = wheel_stiffness
	# MAX FORCE
	wheel_1.suspension_max_force = wheel_max_force
	wheel_2.suspension_max_force = wheel_max_force
	wheel_3.suspension_max_force = wheel_max_force
	wheel_4.suspension_max_force = wheel_max_force
	# TRAVEL DISTANCE
	wheel_1.suspension_travel = wheel_travel_distance
	wheel_2.suspension_travel = wheel_travel_distance
	wheel_3.suspension_travel = wheel_travel_distance
	wheel_4.suspension_travel = wheel_travel_distance

func _input(event):
	if item.isPlayerInside:
		if event.is_action_pressed('key_f'):
			if isEngineOn:
				if int(item.res_energy) > 0:
					if not anim_flashlights.is_playing():
						isFlashlightsOn = not isFlashlightsOn
						if isFlashlightsOn:
							lights_on()
							$stat_flashlight/icon.texture = load('res://assets/images/res_flashlight_green.png')
						else:
							lights_off()
							$stat_flashlight/icon.texture = load('res://assets/images/res_flashlight.png')
		if event.is_action_pressed('rmb'):
			if isEngineOn:
				if int(item.res_energy) > 0:
					if not $beep.playing:
						$beep.play()
						item.res_energy -= consumption_energy
						$stat_energy/value.text = str(int(item.res_energy)) + '%'
		if event.is_action_pressed('key_e'):
			leave()
		if event.is_action_pressed('key_1'):
			isEngineOn = not isEngineOn
			if isEngineOn:
				$engine_on.play()
				$driving.play()
				$stat_engine/icon.modulate = Color('00ff00')
			else:
				$engine_on.stop()
				$driving.stop()
				$stat_engine/icon.modulate = Color('ff0000')
				if isFlashlightsOn:
					$stat_flashlight/icon.texture = load('res://assets/images/res_flashlight.png')
					lights_off()

func _physics_process(delta):
	if not current_tank == null:
		if item.res_fuel < max_fuel:
			if current_tank.item['litres'] >= 0.01:
				item.res_fuel += 0.01
				current_tank.item['litres'] -= 0.01
				current_tank.item['weight'] = int(current_tank.item['litres'])
				if int(item.res_energy) > 0:
					$stat_fuel/value.text = str(int(item.res_fuel)) + 'л.'
			else:
				current_tank.freeze = false
				current_tank = null
		else:
			current_tank.freeze = false
			current_tank = null
	if isFlashlightsOn:
		item.res_energy -= consumption_energy
		if int(item.res_energy) > 0:
			$stat_energy/value.text = str(int(item.res_energy)) + '%'
		else:
			$stat_energy/value.text = '0%'
	if isEngineOn:
		item.res_energy -= consumption_energy
		if int(item.res_energy) > 0:
			$stat_energy/value.text = str(int(item.res_energy)) + '%'
		else:
			$stat_energy/value.text = '0%'
			#isEngineOn = false
			#$driving.stop()
			if isFlashlightsOn:
				$stat_flashlight/icon.texture = load('res://assets/images/res_flashlight.png')
				lights_off()
	if item.isPlayerInside:
		# UPDATE UI
		var speed = int(abs(linear_velocity.x) + abs(linear_velocity.y) + abs(linear_velocity.z))
		if int(item.res_energy) > 0:
			$speedometer/speed.text = str(speed)
		# ANIMATE LEVER
		if int(item.res_energy) > 0 and isEngineOn:
			set_lever(speed)
		# DRIVING FUNCTION
		if int(item.res_fuel) > 0 and isEngineOn:
			var accel = Input.get_axis("move_backward", "move_foward")
			var rpm_wheel_2 = $wheel_2.get_rpm()
			wheel_2.engine_force =  accel * MAX_TORQUE * (1 - rpm_wheel_2 / MAX_RPM)
			var rpm_wheel_3 = $wheel_3.get_rpm()
			wheel_3.engine_force =  accel * MAX_TORQUE * (1 - rpm_wheel_3 / MAX_RPM)
		else:
			engine_force = 0
		# CONTROLS
		if Input.is_action_pressed('move_foward'):
			$driving.pitch_scale = lerp($driving.pitch_scale, 1.5, 0.05)
			if item.res_fuel >= consumption_fuel:
				item.res_fuel -= consumption_fuel
			if int(item.res_energy) > 0:
				$stat_fuel/value.text = str(int(item.res_fuel)) + 'л.'
		elif Input.is_action_pressed('move_backward'):
			$driving.pitch_scale = lerp($driving.pitch_scale, 0.7, 0.05)
			if item.res_fuel >= consumption_fuel:
				item.res_fuel -= consumption_fuel
			if int(item.res_energy) > 0:
				$stat_fuel/value.text = str(int(item.res_fuel)) + 'л.'
		else:
			$driving.pitch_scale = lerp($driving.pitch_scale, 1.0, 0.05)
		# STEERING BY RUL
		if Input.is_action_pressed('move_left'):
			if steer_points < max_steer_points:
				steer_points += 2.0
		elif Input.is_action_pressed('move_right'):
			if steer_points > -max_steer_points:
				steer_points -= 2.0
		else:
			steer_points = lerp(steer_points, 0.0, 0.1)
		var target_steer = move_toward(steering, Input.get_axis("move_right", "move_left") * MAX_STEER, delta * 2.5)
		steering = lerp(steering, deg_to_rad(steer_points/5), 0.05)
		rul.rotation.y = lerp(rul.rotation.y, deg_to_rad(steer_points), 0.05)

func enter(player_obj: Object):
	if not item.isPlayerInside:
		item.isPlayerInside = true
		player_obj.queue_free()
		$CAMERA.current = true

func leave():
	if item.isPlayerInside:
		item.isPlayerInside = false
		steering = 0
		engine_force = 0
		var player_obj = player.instantiate()
		get_tree().get_root().add_child(player_obj)
		player_obj.inventory_loader.load_inventory_visual()
		player_obj.inventory_loader.load_hand_visual(1)
		player_obj.set_slot_selected(1)
		player_obj.global_position = pos_of_exit.global_position
		$CAMERA.current = false

func lights_on():
	anim_flashlights.play("on")

func lights_off():
	anim_flashlights.play("off")

func set_lever(speed: float):
	if speed > 0 and speed < 15:
		handle.position.z = lerp(handle.position.z,  0.575, 0.1)
		handle.position.x = lerp(handle.position.x,  -0.332, 0.1)
	elif speed >= 15 and speed < 30:
		handle.position.z = lerp(handle.position.z,  0.195, 0.1)
		handle.position.x = lerp(handle.position.x,  -0.332, 0.1)
	elif speed >= 30 and speed < 45:
		handle.position.z = lerp(handle.position.z,  -0.13, 0.1)
		handle.position.x = lerp(handle.position.x,  -0.332, 0.1)
	elif speed >= 45 and speed < 60:
		handle.position.z = lerp(handle.position.z,  -0.455, 0.1)
		handle.position.x = lerp(handle.position.x,  -0.332, 0.1)
	elif speed >= 60:
		handle.position.z = lerp(handle.position.z,  0.37, 0.1)
		handle.position.x = lerp(handle.position.x,  0.273, 0.1)

func _on_area_body_entered(body):
	if body is RigidBody3D:
		if 'item' in body:
			if body.has_method('grab'):
				if not body.item['litres'] == null:
					if body.item['litres'] > 0:
						if item.res_fuel < max_fuel:
							if current_tank == null:
								linear_velocity.x = 0
								linear_velocity.z = 0
								current_tank = body
								body.freeze = true
								rotate_tank()
								var tween = create_tween()
								tween.tween_property(current_tank, 'global_position', $fuel_hole.global_position, 1)
								tween.play()

func rotate_tank():
	var tween = create_tween()
	tween.tween_property(current_tank, 'global_rotation', $fuel_hole.global_rotation, 1)
	tween.play()

func _on_area_body_exited(body):
	if body is RigidBody3D:
		if 'item' in body:
			if body.has_method('grab'):
				if not body.item['litres'] == null:
					body.freeze = false

# DEATH BY CAR BUMP INTO OBJECT
func _on_bump_area_body_entered(body):
	var velo = float(abs(linear_velocity.x) + abs(linear_velocity.y) + abs(linear_velocity.z))
	if velo > 90.0:
		if item.isPlayerInside:
			SIN_WORLD_DATA.last_death_reason = 'car'
			get_tree().change_scene_to_file.bind("res://scenes/death/death.tscn").call_deferred()