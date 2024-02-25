extends VehicleBody3D

@export var player: PackedScene

@onready var wheel_1 = $wheel_1
@onready var wheel_2 = $wheel_2
@onready var wheel_3 = $wheel_3
@onready var wheel_4 = $wheel_4
@onready var pos_of_exit = $pos_of_exit

var isPlayerInside: bool = false
# WHEEL SETTINGS
var wheel_stiffness: float = 100.0
var wheel_max_force: float = 16000.0
var wheel_travel_distance: float = 0.1
# ENGINE SETTINGS
var MAX_STEER: float = 0.4
var ENGINE_POWER: float = 5000

func _ready():
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
	if isPlayerInside:
		if event.is_action_pressed('key_f'):
			leave()



func _physics_process(delta):
	if isPlayerInside:
		steering = move_toward(steering, Input.get_axis("move_right", "move_left") * MAX_STEER, delta * 2.5)
		engine_force = Input.get_axis("move_backward", "move_foward") * ENGINE_POWER


func enter(player_obj: Object):
	if not isPlayerInside:
		isPlayerInside = true
		player_obj.queue_free()
		$CAMERA.current = true

func leave():
	if isPlayerInside:
		isPlayerInside = false
		var player_obj = player.instantiate()
		get_tree().get_root().add_child(player_obj)
		player_obj.global_position = pos_of_exit.global_position
		$CAMERA.current = false
	
