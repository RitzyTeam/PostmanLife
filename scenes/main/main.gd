extends Node

var goto: String = ''

func _ready():
	if SIN_WORLD_DATA.data_is_empty():
		$UI/bg/visibility_toggler/button_list/btn_continue.visible = false
	else:
		$UI/bg/visibility_toggler/button_list/btn_continue.visible = true
	$anim.play('show')


func _on_btn_continue_pressed():
	goto = 'continue'
	$anim.play('hide')
	


func _on_btn_new_game_pressed():
	goto = 'new_game'
	$anim.play('hide')


func _on_btn_settings_pressed():
	goto = 'settings'
	$anim.play('hide')


func _on_btn_exit_pressed():
	goto = 'exit'
	$anim.play('hide')


func _on_anim_animation_finished(anim_name):
	if anim_name == 'hide':
		match goto:
			'continue':
				get_tree().change_scene_to_file('res://scenes/world/World.tscn')
			'new_game':
				SIN_WORLD_DATA.data_reset()
				get_tree().change_scene_to_file('res://scenes/world/World.tscn')
			'settings':
				get_tree().change_scene_to_file('res://scenes/settings/settings.tscn')
			'exit':
				get_tree().quit()
