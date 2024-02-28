extends Node

@onready var anim = $anim

# LAYERS OF SETTINGS
@onready var panel_audio = $UI/bg/visibility_changer/panel_audio
@onready var panel_graphics = $UI/bg/visibility_changer/panel_graphics
@onready var panel_additional = $UI/bg/visibility_changer/panel_additional


func _ready():
	set_base_page()
	anim.play("show")


func _on_btn_exit_pressed():
	anim.play("hide")


func _on_anim_animation_finished(anim_name):
	if anim_name == 'hide':
		get_tree().change_scene_to_file('res://scenes/main/main.tscn')

# SWAP LAYERS OF SETTINGS

func set_base_page():
	panel_audio.visible = true
	panel_graphics.visible = false
	panel_additional.visible = false
	
func _on_btn_audio_pressed():
	panel_audio.visible = true
	panel_graphics.visible = false
	panel_additional.visible = false

func _on_btn_graphics_pressed():
	panel_audio.visible = false
	panel_graphics.visible = true
	panel_additional.visible = false

func _on_btn_additional_pressed():
	panel_audio.visible = false
	panel_graphics.visible = false
	panel_additional.visible = true
