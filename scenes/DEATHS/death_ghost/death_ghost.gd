extends Node

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	SIN_WORLD_DATA.data_reset()
	$anim.play('play')




func _on_btn_start_from_zero_pressed():
	$overlapper/anim_overlapper.play('go_to_world')

func _on_btn_exit_to_menu_pressed():
	$overlapper/anim_overlapper.play('go_to_main')

func _on_anim_overlapper_animation_finished(anim_name):
	match anim_name:
		'go_to_world':
			get_tree().change_scene_to_file('res://scenes/world/World.tscn')
		'go_to_main':
			get_tree().change_scene_to_file('res://scenes/main/main.tscn')
			



