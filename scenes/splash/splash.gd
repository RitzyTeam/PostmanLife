extends Node


func _ready():
	$anim.play('show')


func _on_anim_animation_finished(anim_name):
	get_tree().change_scene_to_file('res://scenes/main/main.tscn')
