extends Node

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	SIN_WORLD_DATA.data_reset()
	set_death_reason()

func set_death_reason():
	match SIN_WORLD_DATA.last_death_reason:
		'car':
			$UI/bg/reason.text = 'Вы разбились на машине'
			$death_sound.stream = load('res://assets/sounds/death_sounds/mine/mine_blow.mp3')
		'fall':
			$UI/bg/reason.text = 'Вы разбились, упав с высоты'
			$death_sound.stream = load("res://assets/sounds/death_sounds/fall/fall.mp3")
		'fired':
			$UI/bg/reason.text = 'Вы были уволены!'
			$death_sound.stream = load('res://assets/sounds/death_sounds/fired/fired.mp3')
		'ghost':
			$UI/bg/reason.text = 'Вам не стоило злить её'
			$death_sound.stream = load('res://assets/sounds/death_sounds/ghost_girl/neck_crack.mp3')
		'mine':
			$UI/bg/reason.text = 'Вы подорвались на мине'
			$death_sound.stream = load('res://assets/sounds/death_sounds/mine/mine_blow.mp3')
		'blow':
			$UI/bg/reason.text = 'Вы взорвались'
			$death_sound.stream = load('res://assets/sounds/death_sounds/mine/mine_blow.mp3')
	$anim.play('play')


func _on_btn_start_from_zero_pressed():
	$overlapper/anim_overlapper.play('go_to_world')

func _on_btn_exit_to_menu_pressed():
	$overlapper/anim_overlapper.play('go_to_main')

func _on_anim_overlapper_animation_finished(anim_name):
	match anim_name:
		'go_to_world':
			get_tree().change_scene_to_file("res://scenes/world_loader/WORLD_LOADER.tscn")
		'go_to_main':
			get_tree().change_scene_to_file('res://scenes/main/main.tscn')
			



