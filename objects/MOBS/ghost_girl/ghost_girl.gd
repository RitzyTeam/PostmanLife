extends CharacterBody3D

@onready var mesh = $mesh
var isTargettingPlayer: bool = false
var obj_targetting: Object = null
var agro_meter: int = 0
var isAgro: bool = false

func _ready():
	SIN_WORLD_SIGNALS.NEW_WORK_DAY.connect(_reset_girl)

func _physics_process(delta):
	if isTargettingPlayer:
		if not obj_targetting == null:
			look_at(Vector3(obj_targetting.global_position.x, global_position.y, obj_targetting.global_position.z), Vector3.UP)
	if isAgro:
		if not obj_targetting == null:
			var tween = create_tween()
			tween.tween_property(self, 'global_position', obj_targetting.global_position, global_position.distance_to(obj_targetting.global_position)/2)
			tween.play()
		
func _on_appearance_trigger_body_entered(body):
	if SIN_WORLD_DATA.WORLD_DATA['tod'] > 1300 or SIN_WORLD_DATA.WORLD_DATA['tod'] < 120:
		if body.is_in_group('player'):
			isTargettingPlayer = true
			mesh.visible = true
			obj_targetting = body
			agro_meter += 1
			$AnimationPlayer.play('show')
			if not isAgro:
				play_random_screamer()
				if agro_meter == 2:
					isAgro = true
					SIN_WORLD_SIGNALS.emit_signal('GHOST_GIRL_ANGRY')

func _on_appearance_trigger_body_exited(body):
	if body.is_in_group('player'):
		if not isAgro:
			# if it is player
			isTargettingPlayer = false
			mesh.visible = false
			obj_targetting = null
			$AnimationPlayer.play('hide')

func play_random_screamer():
	randomize()
	var scream_id: int = randi_range(1,5)
	match scream_id:
		1:
			$screamer_1.play()
		2:
			$screamer_2.play()
		3:
			$screamer_3.play()
		4:
			$screamer_4.play()
		5:
			$screamer_5.play()
		6:
			$screamer_6.play()

func _on_death_area_body_entered(body):
	if body.is_in_group('player'):
		kill_player()
		
func kill_player():
	get_tree().change_scene_to_file("res://scenes/DEATHS/death_ghost_girl/death_ghost_girl.tscn")

func _reset_girl():
	isAgro = false
	agro_meter = 0
	obj_targetting = null
	isTargettingPlayer = false
	global_position = Vector3(50,0,1177)
	$AnimationPlayer.play('hide')
