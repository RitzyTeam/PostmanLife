extends Control

var isEscMenuOpened: bool = false
@onready var anim_esc_menu = $anim_esc_menu

func _input(event):
	if event.is_action_pressed('key_esc'):
		if not anim_esc_menu.is_playing():
			isEscMenuOpened = not isEscMenuOpened
			if isEscMenuOpened:
				Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
				anim_esc_menu.play("show")
				get_tree().paused = true
			else:
				Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
				anim_esc_menu.play("hide")
				get_tree().paused = false

func _on_btn_return_pressed():
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	anim_esc_menu.play("hide")


func _on_btn_exit_pressed():
	get_tree().paused = false
	SIN_WORLD_DATA.data_save()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	anim_esc_menu.play("exit")
	await anim_esc_menu.animation_finished
	get_tree().change_scene_to_file('res://scenes/main/main.tscn')
	
