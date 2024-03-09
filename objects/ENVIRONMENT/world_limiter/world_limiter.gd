extends Area3D



func _on_body_entered(body):
	if body.is_in_group('player') or body.is_in_group('car'):
		get_tree().change_scene_to_file.bind("res://scenes/DEATHS/death_mine/death_mine.tscn").call_deferred()
