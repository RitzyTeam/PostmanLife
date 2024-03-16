extends Area3D



func _on_body_entered(body):
	if body.is_in_group('player') or body.is_in_group('car'):
		SIN_WORLD_DATA.last_death_reason = 'mine'
		get_tree().change_scene_to_file.bind("res://scenes/death/death.tscn").call_deferred()
