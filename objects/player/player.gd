extends CharacterBody3D

var isOnLadder: bool = false

# HOW MUCH KILOGRAMMS
var payload: int = 0
var payload_multiplier: float = 10.0

# MUST BE HERE IN ORDER TO SAVE PLAYER
var item: Dictionary = {
	'id': 'player'
}

# Money UI
@onready var money = $UI/UI/money

# FPS Counter
@onready var fps_counter = $UI/UI/fps_counter

# ESC MENU
var isEscMenuOpened: bool = false
@onready var esc_menu = $UI/esc_menu
@onready var anim_esc_menu = $UI/esc_menu/anim_esc_menu

# INVENTORY
@onready var inventory_loader = $INVENTORY_LOADER
@export var throw_item_power: float = 10.0
var current_slot_selected: int = 1
@onready var slot_1 = $UI/UI/inventory/slot_1
@onready var slot_2 = $UI/UI/inventory/slot_2
@onready var slot_3 = $UI/UI/inventory/slot_3
@onready var slot_4 = $UI/UI/inventory/slot_4


@export_category("Character")
@export var base_speed : float = 3.0
@export var sprint_speed : float = 6.0
@export var crouch_speed : float = 1.0
@export var acceleration : float = 10.0
@export var jump_velocity : float = 4.5
@export var mouse_sensitivity : float = 0.1

@export var initial_facing_direction : Vector3 = Vector3.ZERO

@export_group("Nodes")
@export var HEAD : Node3D
@export var CAMERA : Camera3D
@export var HEADBOB_ANIMATION : AnimationPlayer
@export var JUMP_ANIMATION : AnimationPlayer
@export var CROUCH_ANIMATION : AnimationPlayer
@export var COLLISION_MESH : CollisionShape3D

@export_group("Controls")
# We are using UI controls because they are built into Godot Engine so they can be used right away
@export var JUMP : String = "move_jump"
@export var LEFT : String = "move_left"
@export var RIGHT : String = "move_right"
@export var FORWARD : String = "move_foward"
@export var BACKWARD : String = "move_backward"
@export var PAUSE : String = "ui_cancel"
@export var CROUCH : String
@export var SPRINT : String

# Uncomment if you want full controller support
#@export var LOOK_LEFT : String
#@export var LOOK_RIGHT : String
#@export var LOOK_UP : String
#@export var LOOK_DOWN : String

@export_group("Feature Settings")
@export var immobile : bool = false
@export var jumping_enabled : bool = true
@export var in_air_momentum : bool = true
@export var motion_smoothing : bool = true
@export var sprint_enabled : bool = true
@export var crouch_enabled : bool = true
@export_enum("Hold to Crouch", "Toggle Crouch") var crouch_mode : int = 0
@export_enum("Hold to Sprint", "Toggle Sprint") var sprint_mode : int = 0
@export var dynamic_fov : bool = true
@export var continuous_jumping : bool = true
@export var view_bobbing : bool = true
@export var jump_animation : bool = true

# Member variables
var speed : float = base_speed
var current_speed : float = 0.0
var stamina: float = 100.0
# States: normal, crouching, sprinting
var state : String = "normal"
var low_ceiling : bool = false # This is for when the cieling is too low and the player needs to crouch.
var was_on_floor : bool = true

# Get the gravity from the project settings to be synced with RigidBody nodes
var gravity : float = ProjectSettings.get_setting("physics/3d/default_gravity") # Don't set this as a const, see the gravity section in _physics_process

func _ready():
	# CONNECT ALL SIGNALS NEEDED
	SIN_WORLD_SIGNALS.GHOST_GIRL_ANGRY.connect(_go_insane)
	SIN_WORLD_SIGNALS.PLAYER_UI_CASH_UPDATE.connect(_update_money_ui)
	# SET CAMERA FAR FROM SETTINGS
	$Head/Camera.far = SIN_SETTINGS.SETTINGS['GRAPHICS']['far']
	# SET VISIBLE FPS COUNTER
	fps_counter.visible = SIN_SETTINGS.SETTINGS['ADDITIONAL']['fps_counter']
	# EVERYTHING ELSE
	set_money_value_ui()
	set_slot_selected(1)
	calculate_speed()
	inventory_loader.load_hand_visual(1)
	inventory_loader.load_inventory_visual()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	# Set the camera rotation to whatever initial_facing_direction is
	if initial_facing_direction:
		HEAD.set_rotation_degrees(initial_facing_direction) # I don't want to be calling this function if the vector is zero
	
	# Reset the camera position
	HEADBOB_ANIMATION.play("RESET")
	JUMP_ANIMATION.play("RESET")

func _physics_process(delta):
	SIN_WORLD_DATA.player_position = global_position
#region СТАМИНА
	if stamina < 100 and state == 'normal':
		stamina += 0.1
	if Input.is_action_pressed(SPRINT):
		var a = stamina - 0.1
		if a > 0:
			stamina -= 0.2
#endregion
	current_speed = Vector3.ZERO.distance_to(get_real_velocity())
	var cv : Vector3 = get_real_velocity()
	var vd : Array[float] = [
		snappedf(cv.x, 0.001),
		snappedf(cv.y, 0.001),
		snappedf(cv.z, 0.001)
	]
	
	# Gravity
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	handle_jumping()
	
	var input_dir = Vector2.ZERO
	if !immobile:
		input_dir = Input.get_vector(LEFT, RIGHT, FORWARD, BACKWARD)
	handle_movement(delta, input_dir)
	
	low_ceiling = $CrouchCeilingDetection.is_colliding()
	
	handle_state(input_dir)
	if dynamic_fov:
		update_camera_fov()
	
	if view_bobbing:
		headbob_animation(input_dir)
	
	if jump_animation:
		if !was_on_floor and is_on_floor(): # Just landed
			JUMP_ANIMATION.play("land")
		was_on_floor = is_on_floor() # This must always be at the end of physics_process

func handle_jumping():
	if jumping_enabled:
		if continuous_jumping:
			if isOnLadder:
				if Input.is_action_pressed(JUMP):
					velocity.y = 2
			if Input.is_action_pressed(JUMP) and is_on_floor() and !low_ceiling:
				if jump_animation:
					JUMP_ANIMATION.play("jump")
				velocity.y += jump_velocity
		else:
			if Input.is_action_just_pressed(JUMP) and is_on_floor() and !low_ceiling:
				if jump_animation:
					JUMP_ANIMATION.play("jump")
				velocity.y += jump_velocity

func handle_movement(delta, input_dir):
	var direction = input_dir.rotated(-HEAD.rotation.y)
	direction = Vector3(direction.x, 0, direction.y)
	move_and_slide()
	
	if in_air_momentum:
		if is_on_floor():
			if motion_smoothing:
				velocity.x = lerp(velocity.x, direction.x * speed, acceleration * delta)
				velocity.z = lerp(velocity.z, direction.z * speed, acceleration * delta)
			else:
				velocity.x = direction.x * speed
				velocity.z = direction.z * speed
	else:
		if motion_smoothing:
			velocity.x = lerp(velocity.x, direction.x * speed, acceleration * delta)
			velocity.z = lerp(velocity.z, direction.z * speed, acceleration * delta)
		else:
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed

func handle_state(moving):
	if sprint_enabled:
		if sprint_mode == 0:
			if Input.is_action_pressed(SPRINT) and state != "crouching" and int(stamina) > 0:
				if moving:
					if state != "sprinting":
						enter_sprint_state()
				else:
					if state == "sprinting":
						enter_normal_state()
			elif state == "sprinting":
				enter_normal_state()
		elif sprint_mode == 1:
			if moving:
				# If the player is holding sprint before moving, handle that cenerio
				if Input.is_action_pressed(SPRINT) and state == "normal":
					enter_sprint_state()
				if Input.is_action_just_pressed(SPRINT):
					match state:
						"normal":
							enter_sprint_state()
						"sprinting":
							enter_normal_state()
			elif state == "sprinting":
				enter_normal_state()
	
	if crouch_enabled:
		if crouch_mode == 0:
			if Input.is_action_pressed(CROUCH) and state != "sprinting":
				if state != "crouching":
					enter_crouch_state()
			elif state == "crouching" and !$CrouchCeilingDetection.is_colliding():
				enter_normal_state()
		elif crouch_mode == 1:
			if Input.is_action_just_pressed(CROUCH):
				match state:
					"normal":
						enter_crouch_state()
					"crouching":
						if !$CrouchCeilingDetection.is_colliding():
							enter_normal_state()

func enter_normal_state():
	var prev_state = state
	if prev_state == "crouching":
		CROUCH_ANIMATION.play_backwards("crouch")
	state = "normal"
	if base_speed - (payload/payload_multiplier) > 0:
		speed = base_speed - (payload/payload_multiplier)
	else:
		speed = 0

func enter_crouch_state():
	var prev_state = state
	state = "crouching"
	CROUCH_ANIMATION.play("crouch")
	
	if crouch_speed - (payload/payload_multiplier) > 0:
		speed = crouch_speed - (payload/payload_multiplier)
	else:
		speed = 0

func enter_sprint_state():
	var prev_state = state
	if prev_state == "crouching":
		CROUCH_ANIMATION.play_backwards("crouch")
	state = "sprinting"
	if sprint_speed  - (payload/payload_multiplier) > 0:
		speed = sprint_speed  - (payload/payload_multiplier)
	else:
		speed = 0

func update_camera_fov():
	if state == "sprinting":
		CAMERA.fov = lerp(CAMERA.fov, 85.0, 0.3)
	else:
		CAMERA.fov = lerp(CAMERA.fov, 75.0, 0.3)

func headbob_animation(moving):
	if moving and is_on_floor():
		var was_playing : bool = false
		if HEADBOB_ANIMATION.current_animation == "headbob":
			was_playing = true
		HEADBOB_ANIMATION.play("headbob", 0.25)
		HEADBOB_ANIMATION.speed_scale = (current_speed / base_speed) * 1.75
		if !was_playing:
			HEADBOB_ANIMATION.seek(float(randi() % 2)) # Randomize the initial headbob direction
			# Let me explain that piece of code because it looks like it does the opposite of what it actually does.
			# The headbob animation has two starting positions. One is at 0 and the other is at 1.
			# randi() % 2 returns either 0 or 1, and so the animation randomly starts at one of the starting positions.
		
	else:
		HEADBOB_ANIMATION.play("RESET", 0.25)
		HEADBOB_ANIMATION.speed_scale = 1

func _process(delta):
	_update_time_ui()
	fps_counter.text = 'FPS: ' + str(Performance.get_monitor(Performance.TIME_FPS))
	var status : String = state
	if !is_on_floor():
		status += " in the air"
	
	if Input.is_action_just_pressed(PAUSE):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		elif Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	HEAD.rotation.x = clamp(HEAD.rotation.x, deg_to_rad(-90), deg_to_rad(90))
	
	# Uncomment if you want full controller support
	#var controller_view_rotation = Input.get_vector(LOOK_LEFT, LOOK_RIGHT, LOOK_UP, LOOK_DOWN)
	#HEAD.rotation_degrees.y -= controller_view_rotation.x * 1.5
	#HEAD.rotation_degrees.x -= controller_view_rotation.y * 1.5

func add_item_to_inv(item_data: Dictionary) -> bool:
	var hasFreeSlot: bool = false
	var target_slot: int = -1
	if SIN_WORLD_DATA.WORLD_DATA['player_inv']['slot_4']['id'] == 'void':
		hasFreeSlot = true
		target_slot = 4
	if SIN_WORLD_DATA.WORLD_DATA['player_inv']['slot_3']['id'] == 'void':
		hasFreeSlot = true
		target_slot = 3
	if SIN_WORLD_DATA.WORLD_DATA['player_inv']['slot_2']['id'] == 'void':
		hasFreeSlot = true
		target_slot = 2
	if SIN_WORLD_DATA.WORLD_DATA['player_inv']['slot_1']['id'] == 'void':
		hasFreeSlot = true
		target_slot = 1
	if hasFreeSlot:
		SIN_WORLD_DATA.WORLD_DATA['player_inv']['slot_' + str(target_slot)] = item_data
		inventory_loader.load_inventory_visual()
		inventory_loader.load_hand_visual(target_slot)
		set_slot_selected(target_slot)
		calculate_speed()
		return true
	return false

func drop_item_slot(slot_id: int):
	var item_full_data = SIN_WORLD_DATA.WORLD_DATA['player_inv']['slot_' + str(slot_id)]
	match item_full_data.id:
		'void':
			pass
		'box':
			var obj = load('res://objects/PROPS/package_box/package_box.tscn').instantiate()
			get_tree().get_root().add_child(obj)
			obj.item = SIN_WORLD_DATA.WORLD_DATA['player_inv']['slot_' + str(slot_id)]
			obj.set_labels()
			obj.global_position = $Head/Camera/item_display/box.global_position
			obj.global_rotation = $Head/Camera/item_display/box.global_rotation
			obj.apply_central_impulse($Head/Camera/item_display/box.global_transform.basis.z * -throw_item_power)
			SIN_WORLD_DATA.WORLD_DATA['player_inv']['slot_' + str(slot_id)] = {'id': 'void'}
		'letter':
			var obj = load('res://objects/PROPS/package_letter/package_letter.tscn').instantiate()
			get_tree().get_root().add_child(obj)
			obj.item = SIN_WORLD_DATA.WORLD_DATA['player_inv']['slot_' + str(slot_id)]
			obj.global_position = $Head/Camera/item_display/letter.global_position
			obj.global_rotation = $Head/Camera/item_display/letter.global_rotation
			obj.apply_central_impulse($Head/Camera/item_display/letter.global_transform.basis.z * -throw_item_power)
			SIN_WORLD_DATA.WORLD_DATA['player_inv']['slot_' + str(slot_id)] = {'id': 'void'}
		'ball':
			var obj = load('res://objects/PROPS/ball/ball.tscn').instantiate()
			get_tree().get_root().add_child(obj)
			obj.item = SIN_WORLD_DATA.WORLD_DATA['player_inv']['slot_' + str(slot_id)]
			obj.global_position = $Head/Camera/item_display/ball.global_position
			obj.global_rotation = $Head/Camera/item_display/ball.global_rotation
			obj.apply_central_impulse($Head/Camera/item_display/ball.global_transform.basis.z * -100)
			SIN_WORLD_DATA.WORLD_DATA['player_inv']['slot_' + str(slot_id)] = {'id': 'void'}
		'fuel_tank':
			var obj = load('res://objects/PROPS/fuel_tank/fuel_tank.tscn').instantiate()
			get_tree().get_root().add_child(obj)
			obj.item = SIN_WORLD_DATA.WORLD_DATA['player_inv']['slot_' + str(slot_id)]
			obj.global_position = $Head/Camera/item_display/fuel_tank.global_position
			obj.global_rotation = $Head/Camera/item_display/fuel_tank.global_rotation
			obj.apply_central_impulse($Head/Camera/item_display/fuel_tank.global_transform.basis.x * throw_item_power)
			SIN_WORLD_DATA.WORLD_DATA['player_inv']['slot_' + str(slot_id)] = {'id': 'void'}
		'shotgun':
			var obj = load("res://objects/PROPS/shotgun/shotgun.tscn").instantiate()
			get_tree().get_root().add_child(obj)
			obj.item = SIN_WORLD_DATA.WORLD_DATA['player_inv']['slot_' + str(slot_id)]
			obj.global_position = $Head/Camera/item_display/fuel_tank.global_position
			obj.global_rotation = $Head/Camera/item_display/fuel_tank.global_rotation
			obj.global_rotation.y += deg_to_rad(90)
			obj.apply_central_impulse($Head/Camera/item_display/fuel_tank.global_transform.basis.x * throw_item_power)
			SIN_WORLD_DATA.WORLD_DATA['player_inv']['slot_' + str(slot_id)] = {'id': 'void'}
		'shell':
			var obj = load("res://objects/PROPS/shell/shell.tscn").instantiate()
			get_tree().get_root().add_child(obj)
			obj.item = SIN_WORLD_DATA.WORLD_DATA['player_inv']['slot_' + str(slot_id)]
			obj.global_position = $Head/Camera/item_display/fuel_tank.global_position
			obj.global_rotation = $Head/Camera/item_display/fuel_tank.global_rotation
			obj.global_rotation.y += deg_to_rad(180)
			obj.apply_central_impulse($Head/Camera/item_display/fuel_tank.global_transform.basis.x * throw_item_power)
			SIN_WORLD_DATA.WORLD_DATA['player_inv']['slot_' + str(slot_id)] = {'id': 'void'}
		'milk':
			var obj = load("res://objects/PROPS/FOOD/milk/milk.tscn").instantiate()
			get_tree().get_root().add_child(obj)
			obj.item = SIN_WORLD_DATA.WORLD_DATA['player_inv']['slot_' + str(slot_id)]
			obj.global_position = $Head/Camera/item_display/fuel_tank.global_position
			obj.global_rotation = $Head/Camera/item_display/fuel_tank.global_rotation
			obj.global_rotation.y += deg_to_rad(180)
			obj.apply_central_impulse($Head/Camera/item_display/fuel_tank.global_transform.basis.x * throw_item_power)
			SIN_WORLD_DATA.WORLD_DATA['player_inv']['slot_' + str(slot_id)] = {'id': 'void'}
		'spray_orange':
			var obj = load("res://objects/PROPS/spray_orange/spray_orange.tscn").instantiate()
			get_tree().get_root().add_child(obj)
			obj.item = SIN_WORLD_DATA.WORLD_DATA['player_inv']['slot_' + str(slot_id)]
			obj.global_position = $Head/Camera/item_display/spray_orange.global_position
			obj.global_rotation = $Head/Camera/item_display/spray_orange.global_rotation
			obj.apply_central_impulse($Head/Camera/item_display/spray_orange.global_transform.basis.x * throw_item_power)
			SIN_WORLD_DATA.WORLD_DATA['player_inv']['slot_' + str(slot_id)] = {'id': 'void'}
		'coffee_can':
			var obj = load("res://objects/PROPS/FOOD/coffee_can/coffee_can.tscn").instantiate()
			get_tree().get_root().add_child(obj)
			obj.item = SIN_WORLD_DATA.WORLD_DATA['player_inv']['slot_' + str(slot_id)]
			obj.global_position = $Head/Camera/item_display/coffee_can.global_position
			obj.global_rotation = $Head/Camera/item_display/coffee_can.global_rotation
			obj.apply_central_impulse($Head/Camera/item_display/coffee_can.global_transform.basis.z * -throw_item_power)
			SIN_WORLD_DATA.WORLD_DATA['player_inv']['slot_' + str(slot_id)] = {'id': 'void'}
	inventory_loader.load_hand_visual(current_slot_selected)
	inventory_loader.load_hand_visual(current_slot_selected)
	calculate_speed()
	inventory_loader.load_inventory_visual()

func set_slot_selected(slot_id: int):
	match slot_id:
		1:
			current_slot_selected = 1
			slot_1.modulate.a = 1
			slot_2.modulate.a = 0.4
			slot_3.modulate.a = 0.4
			slot_4.modulate.a = 0.4
			inventory_loader.load_hand_visual(current_slot_selected)
		2:
			current_slot_selected = 2
			slot_1.modulate.a = 0.4
			slot_2.modulate.a = 1
			slot_3.modulate.a = 0.4
			slot_4.modulate.a = 0.4
			inventory_loader.load_hand_visual(current_slot_selected)
		3:
			current_slot_selected = 3
			slot_1.modulate.a = 0.4
			slot_2.modulate.a = 0.4
			slot_3.modulate.a = 1
			slot_4.modulate.a = 0.4
			inventory_loader.load_hand_visual(current_slot_selected)
		4:
			current_slot_selected = 4
			slot_1.modulate.a = 0.4
			slot_2.modulate.a = 0.4
			slot_3.modulate.a = 0.4
			slot_4.modulate.a = 1
			inventory_loader.load_hand_visual(current_slot_selected)

func _unhandled_input(event):
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		HEAD.rotation_degrees.y -= event.relative.x * mouse_sensitivity
		HEAD.rotation_degrees.x -= event.relative.y * mouse_sensitivity
	
	# INVENTORY MOUSE WHEEL
	if event.is_action_pressed('wheel_up'):
		if current_slot_selected < 4:
			current_slot_selected += 1
		else:
			current_slot_selected = 1
	if event.is_action_pressed('wheel_down'):
		if current_slot_selected > 1:
			current_slot_selected -= 1
		else:
			current_slot_selected = 4
	set_slot_selected(current_slot_selected)
	
	# INVENTORY BY KEYS
	if event.is_action_pressed("key_1"):
		set_slot_selected(1)
	if event.is_action_pressed("key_2"):
		set_slot_selected(2)
	if event.is_action_pressed("key_3"):
		set_slot_selected(3)
	if event.is_action_pressed("key_4"):
		set_slot_selected(4)
	
	# DROP ITEMS
	if event.is_action_pressed('key_g'):
		drop_item_slot(current_slot_selected)
	
	# PICKUP/INTERACT WITH ITEMS/PROPS
	if event.is_action_pressed("key_e"):
		if not SIN_WORLD_DATA.WORLD_DATA['player_insane']:
			if $Head/Camera/raycast_hand.is_colliding():
				if not $Head/Camera/raycast_hand.get_collider() == null:
					# BUY PETROL FROM GAS STATION
					if $Head/Camera/raycast_hand.get_collider().has_method('buy_petrol'):
						$Head/Camera/raycast_hand.get_collider().buy_petrol()
					# GRAB PACKAGES
					if $Head/Camera/raycast_hand.get_collider().has_method('grab'):
						if add_item_to_inv($Head/Camera/raycast_hand.get_collider().grab()):
							$Head/Camera/raycast_hand.get_collider().queue_free()
					# PUT PACKAGE IN A BOX
					if $Head/Camera/raycast_hand.get_collider().has_method('try_put_package'):
						if $Head/Camera/raycast_hand.get_collider().try_put_package(SIN_WORLD_DATA.WORLD_DATA['player_inv']['slot_' + str(current_slot_selected)]):
							SIN_WORLD_DATA.WORLD_DATA['player_inv']['slot_' + str(current_slot_selected)] = {'id': 'void'}
							inventory_loader.load_inventory_visual()
							inventory_loader.load_hand_visual(current_slot_selected)
					# DRIVE A CAR
					if $Head/Camera/raycast_hand.get_collider().has_method('enter'):
						$Head/Camera/raycast_hand.get_collider().enter(self)
					# INTERRACT WITH ITEM
					if $Head/Camera/raycast_hand.get_collider().has_method('interract'):
						$Head/Camera/raycast_hand.get_collider().interract()

func _go_insane():
	SIN_WORLD_DATA.WORLD_DATA['player_insane'] = true

func _update_money_ui(value_changed):
	var notif_money_change = load("res://objects/UI/money_change_notification/money_change_notification.tscn").instantiate()
	$UI/UI/money_change_notifications.add_child(notif_money_change)
	notif_money_change.set_content(value_changed)
	set_money_value_ui()

func set_money_value_ui():
	if SIN_WORLD_DATA.WORLD_DATA['money'] >= 0:
		$UI/UI/money.add_theme_color_override('font_color', Color('00ff00'))
		$UI/UI/money.text = str(SIN_WORLD_DATA.WORLD_DATA['money']) + '₽'
	else:
		$UI/UI/money.add_theme_color_override('font_color', Color('ff0000'))
		$UI/UI/money.text = '0(' + str(SIN_WORLD_DATA.WORLD_DATA['money']) + ')₽'

func _update_time_ui():
	var time_hours = int(SIN_WORLD_DATA.WORLD_DATA['tod']/60)
	var time_minutes = int(SIN_WORLD_DATA.WORLD_DATA['tod']%60)
	var time_h_str: String = ''
	var time_m_str: String = ''
	if time_hours < 10:
		time_h_str = '0' + str(time_hours)
	else:
		time_h_str = str(time_hours)
	if time_minutes < 10:
		time_m_str = '0' + str(time_minutes)
	else:
		time_m_str = str(time_minutes)
	$UI/UI/time.text = str(time_h_str) + ':' + str(time_m_str)

func calculate_speed():
	payload = 0
	for i in range(SIN_WORLD_DATA.WORLD_DATA['player_inv'].size()):
		if not SIN_WORLD_DATA.WORLD_DATA['player_inv']['slot_' + str(i+1)] == {}:
			if SIN_WORLD_DATA.WORLD_DATA['player_inv']['slot_' + str(i+1)].has('weight'):
				payload += SIN_WORLD_DATA.WORLD_DATA['player_inv']['slot_' + str(i+1)]['weight']
	$UI/UI/weight.text = str(payload) + 'кг'
	set_speed_by_payload()

func set_speed_by_payload():
	match state:
		'crouching':
			enter_crouch_state()
		'normal':
			enter_normal_state()
		'sprinting':
			enter_sprint_state()

func _on_check_die_from_height_body_entered(body):
	if -velocity.y > 20:
		SIN_WORLD_DATA.last_death_reason = 'fall'
		queue_free()
		get_tree().change_scene_to_file.bind("res://scenes/death/death.tscn").call_deferred()

