extends CharacterBody3D

@onready var mesh = $mesh
var isTargettingPlayer: bool = false
var obj_targetting: Object = null

func _physics_process(delta):
	if isTargettingPlayer:
		look_at(Vector3(obj_targetting.global_position.x, global_position.y, obj_targetting.global_position.z), Vector3.UP)
		

func _on_appearance_trigger_body_entered(body):
	if SIN_WORLD_DATA.WORLD_DATA['tod'] > 1300 or SIN_WORLD_DATA.WORLD_DATA['tod'] < 120:
		if body is CharacterBody3D and 'inv' in body and body.has_method('handle_movement'):
			# if it is player
			isTargettingPlayer = true
			mesh.visible = true
			obj_targetting = body
			$AnimationPlayer.play('show')


func _on_appearance_trigger_body_exited(body):
	if body is CharacterBody3D and 'inv' in body and body.has_method('handle_movement'):
		# if it is player
		isTargettingPlayer = false
		mesh.visible = false
		obj_targetting = null
		$AnimationPlayer.play('hide')
