extends Node3D


func blow():
	SIN_WORLD_DATA.last_death_reason = 'mine'
	get_tree().change_scene_to_file.bind("res://scenes/death/death.tscn").call_deferred()


func _on_trigger_body_exited(body):
	if body.is_in_group('player'):
		body.queue_free()
		blow()
	else:
		if body.is_in_group('car'):
			if body.isPlayerInside:
				blow()


func _on_trigger_body_entered(body):
	$mine_stand.play()
