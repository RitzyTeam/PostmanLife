extends Node

@onready var anim = $anim

# LAYERS OF SETTINGS
@onready var panel_audio = $UI/bg/visibility_changer/panel_audio
@onready var panel_graphics = $UI/bg/visibility_changer/panel_graphics
@onready var panel_additional = $UI/bg/visibility_changer/panel_additional

# SETTINGS

# GRAPHICAL SETTINGS UI
# ALIASING
@onready var alias_no = $UI/bg/visibility_changer/panel_graphics/margin/gr_box/item_aliasing/options/alias_no
@onready var alias_x_2 = $UI/bg/visibility_changer/panel_graphics/margin/gr_box/item_aliasing/options/alias_x2
@onready var alias_x_4 = $UI/bg/visibility_changer/panel_graphics/margin/gr_box/item_aliasing/options/alias_x4
@onready var alias_x_8 = $UI/bg/visibility_changer/panel_graphics/margin/gr_box/item_aliasing/options/alias_x8
# GLOW
@onready var glow_no = $UI/bg/visibility_changer/panel_graphics/margin/gr_box/item_glow/options/glow_no
@onready var glow_yes = $UI/bg/visibility_changer/panel_graphics/margin/gr_box/item_glow/options/glow_yes
# SDFGI
@onready var sdfgi_no = $UI/bg/visibility_changer/panel_graphics/margin/gr_box/item_sdfgi/options/sdfgi_no
@onready var sdfgi_yes = $UI/bg/visibility_changer/panel_graphics/margin/gr_box/item_sdfgi/options/sdfgi_yes
#SSAO
@onready var ssao_no = $UI/bg/visibility_changer/panel_graphics/margin/gr_box/item_ssao/options/ssao_no
@onready var ssao_yes = $UI/bg/visibility_changer/panel_graphics/margin/gr_box/item_ssao/options/ssao_yes
# SHADOWS
@onready var no_shadows = $UI/bg/visibility_changer/panel_graphics/margin/gr_box/item_shadows/options/no_shadows
@onready var bad_shadows = $UI/bg/visibility_changer/panel_graphics/margin/gr_box/item_shadows/options/bad_shadows
@onready var mid_shadows = $UI/bg/visibility_changer/panel_graphics/margin/gr_box/item_shadows/options/mid_shadows
@onready var good_shadows = $UI/bg/visibility_changer/panel_graphics/margin/gr_box/item_shadows/options/good_shadows

# RESO
@onready var reso_slider = $UI/bg/visibility_changer/panel_graphics/margin/gr_box/item_resolution/options/reso_slider
@onready var reso_value = $UI/bg/visibility_changer/panel_graphics/margin/gr_box/item_resolution/options/value


func _ready():
	anim.play("show")
	set_base_page()
	SIN_SETTINGS.settings_save() # SAVE CURRENT SETTINGS FOR BACKUP
	load_settings()

func _on_btn_exit_pressed():
	SIN_SETTINGS.settings_load()
	anim.play("hide")

func _on_btn_save_pressed():
	SIN_SETTINGS.settings_save()

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

# LOAD SETTINGS VISUALLY FROM FILE

func load_settings():
	# LOAD GRAPHICAL SETTINGS
	
	match SIN_SETTINGS.SETTINGS['GRAPHICS']['antialiasing']:
		'no':
			alias_no.button_pressed = true
			alias_x_2.button_pressed = false
			alias_x_4.button_pressed = false
			alias_x_8.button_pressed = false
		'x2':
			alias_no.button_pressed = false
			alias_x_2.button_pressed = true
			alias_x_4.button_pressed = false
			alias_x_8.button_pressed = false
		'x4':
			alias_no.button_pressed = false
			alias_x_2.button_pressed = false
			alias_x_4.button_pressed = true
			alias_x_8.button_pressed = false
		'x8':
			alias_no.button_pressed = false
			alias_x_2.button_pressed = false
			alias_x_4.button_pressed = false
			alias_x_8.button_pressed = true
	match SIN_SETTINGS.SETTINGS['GRAPHICS']['glow']:
		'no':
			glow_no.button_pressed = true
			glow_yes.button_pressed = false
		'yes':
			glow_no.button_pressed = false
			glow_yes.button_pressed = true
	match SIN_SETTINGS.SETTINGS['GRAPHICS']['sdfgi']:
		'no':
			sdfgi_no.button_pressed = true
			sdfgi_yes.button_pressed = false
		'yes':
			sdfgi_no.button_pressed = false
			sdfgi_yes.button_pressed = true
	match SIN_SETTINGS.SETTINGS['GRAPHICS']['ssao']:
		'no':
			ssao_no.button_pressed = true
			ssao_yes.button_pressed = false
		'yes':
			ssao_no.button_pressed = false
			ssao_yes.button_pressed = true
	match SIN_SETTINGS.SETTINGS['GRAPHICS']['shadows']:
		'no':
			no_shadows.button_pressed = true
			bad_shadows.button_pressed = false
			mid_shadows.button_pressed = false
			good_shadows.button_pressed = false
		'bad':
			no_shadows.button_pressed = false
			bad_shadows.button_pressed = true
			mid_shadows.button_pressed = false
			good_shadows.button_pressed = false
		'mid':
			no_shadows.button_pressed = false
			bad_shadows.button_pressed = false
			mid_shadows.button_pressed = true
			good_shadows.button_pressed = false
		'good':
			no_shadows.button_pressed = false
			bad_shadows.button_pressed = false
			mid_shadows.button_pressed = false
			good_shadows.button_pressed = true
	reso_slider.value = float(SIN_SETTINGS.SETTINGS['GRAPHICS']['resolution'])
# GRAPHICS - ALIASING PICK

func _on_alias_no_pressed():
	alias_no.button_pressed = true
	alias_x_2.button_pressed = false
	alias_x_4.button_pressed = false
	alias_x_8.button_pressed = false
	SIN_SETTINGS.SETTINGS['GRAPHICS']['antialiasing'] = 'no'
func _on_alias_x_2_pressed():
	alias_no.button_pressed = false
	alias_x_2.button_pressed = true
	alias_x_4.button_pressed = false
	alias_x_8.button_pressed = false
	SIN_SETTINGS.SETTINGS['GRAPHICS']['antialiasing'] = 'x2'
func _on_alias_x_4_pressed():
	alias_no.button_pressed = false
	alias_x_2.button_pressed = false
	alias_x_4.button_pressed = true
	alias_x_8.button_pressed = false
	SIN_SETTINGS.SETTINGS['GRAPHICS']['antialiasing'] = 'x4'
func _on_alias_x_8_pressed():
	alias_no.button_pressed = false
	alias_x_2.button_pressed = false
	alias_x_4.button_pressed = false
	alias_x_8.button_pressed = true
	SIN_SETTINGS.SETTINGS['GRAPHICS']['antialiasing'] = 'x8'

# GRAPHICS - GLOW PICK

func _on_glow_no_pressed():
	glow_no.button_pressed = true
	glow_yes.button_pressed = false
	SIN_SETTINGS.SETTINGS['GRAPHICS']['glow'] = 'no'
func _on_glow_yes_pressed():
	glow_no.button_pressed = false
	glow_yes.button_pressed = true
	SIN_SETTINGS.SETTINGS['GRAPHICS']['glow'] = 'yes'

# GRAPHICS - SDFGI PICK

func _on_sdfgi_no_pressed():
	sdfgi_no.button_pressed = true
	sdfgi_yes.button_pressed = false
	SIN_SETTINGS.SETTINGS['GRAPHICS']['sdfgi'] = 'no'
func _on_sdfgi_yes_pressed():
	sdfgi_no.button_pressed = false
	sdfgi_yes.button_pressed = true
	SIN_SETTINGS.SETTINGS['GRAPHICS']['sdfgi'] = 'yes'

# GRAPHICS - SSAO PICK

func _on_ssao_no_pressed():
	ssao_no.button_pressed = true
	ssao_yes.button_pressed = false
	SIN_SETTINGS.SETTINGS['GRAPHICS']['ssao'] = 'no'
func _on_ssao_yes_pressed():
	ssao_no.button_pressed = false
	ssao_yes.button_pressed = true
	SIN_SETTINGS.SETTINGS['GRAPHICS']['ssao'] = 'yes'

# GRAPHICS - SHADOWS PICK

func _on_no_shadows_pressed():
	no_shadows.button_pressed = true
	bad_shadows.button_pressed = false
	mid_shadows.button_pressed = false
	good_shadows.button_pressed = false
	SIN_SETTINGS.SETTINGS['GRAPHICS']['shadows'] = 'no'
func _on_bad_shadows_pressed():
	no_shadows.button_pressed = false
	bad_shadows.button_pressed = true
	mid_shadows.button_pressed = false
	good_shadows.button_pressed = false
	SIN_SETTINGS.SETTINGS['GRAPHICS']['shadows'] = 'bad'
func _on_mid_shadows_pressed():
	no_shadows.button_pressed = false
	bad_shadows.button_pressed = false
	mid_shadows.button_pressed = true
	good_shadows.button_pressed = false
	SIN_SETTINGS.SETTINGS['GRAPHICS']['shadows'] = 'mid'
func _on_good_shadows_pressed():
	no_shadows.button_pressed = false
	bad_shadows.button_pressed = false
	mid_shadows.button_pressed = false
	good_shadows.button_pressed = true
	SIN_SETTINGS.SETTINGS['GRAPHICS']['shadows'] = 'good'

# GRAPHICS - RESOLUTION PICK

func _on_reso_slider_value_changed(value):
	reso_value.text = 'x' + str(value)
	SIN_SETTINGS.SETTINGS['GRAPHICS']['resolution'] = str(value)




