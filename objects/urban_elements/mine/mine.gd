extends Node3D


func blow():
	get_tree().change_scene_to_file('res://scenes/DEATHS/death_mine/death_mine.tscn')


func _on_trigger_body_exited(body):
	if body is CharacterBody3D:
		blow()


func _on_trigger_body_entered(body):
	$mine_stand.play()
