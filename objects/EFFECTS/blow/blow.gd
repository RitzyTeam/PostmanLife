extends Node3D

@onready var blow = $blow


func _ready():
	blow.play("blow")
	await get_tree().create_timer(0.5).timeout
	$Area3D.monitoring = false
	$Area3D.monitorable = false

func _on_blow_animation_finished(anim_name):
	queue_free()

func _on_area_3d_body_entered(body):
	if body.is_in_group('player'):
		SIN_WORLD_DATA.last_death_reason = 'blow'
		get_tree().change_scene_to_file.bind("res://scenes/death/death.tscn").call_deferred()
	else:
		if body.has_method('hurt'):
			body.hurt()

