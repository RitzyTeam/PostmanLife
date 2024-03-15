extends Node3D


func blow():
	get_tree().change_scene_to_file.bind("res://scenes/DEATHS/death_mine/death_mine.tscn").call_deferred()


func _on_trigger_body_exited(body):
	if body.is_in_group('player'):
		body.queue_free()
		blow()


func _on_trigger_body_entered(body):
	$mine_stand.play()
