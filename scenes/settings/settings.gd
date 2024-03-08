extends Node

@onready var anim = $anim

# LAYERS OF SETTINGS
@onready var panel_audio = $UI/bg/visibility_changer/panel_audio
@onready var panel_graphics = $UI/bg/visibility_changer/panel_graphics
@onready var panel_additional = $UI/bg/visibility_changer/panel_additional

# SETTINGS

# GRAPHICAL SETTINGS UI
# ALIASING
@onready var alias_no = $UI/bg/visibility_changer/panel_graphics/margin/smoother/gr_box/item_aliasing/options/alias_no
@onready var alias_x_2 = $UI/bg/visibility_changer/panel_graphics/margin/smoother/gr_box/item_aliasing/options/alias_x2
@onready var alias_x_4 = $UI/bg/visibility_changer/panel_graphics/margin/smoother/gr_box/item_aliasing/options/alias_x4
@onready var alias_x_8 = $UI/bg/visibility_changer/panel_graphics/margin/smoother/gr_box/item_aliasing/options/alias_x8
# GLOW
@onready var glow_no = $UI/bg/visibility_changer/panel_graphics/margin/smoother/gr_box/item_glow/options/glow_no
@onready var glow_yes = $UI/bg/visibility_changer/panel_graphics/margin/smoother/gr_box/item_glow/options/glow_yes
# VSYNC
@onready var vsync_no = $UI/bg/visibility_changer/panel_graphics/margin/smoother/gr_box/item_vsync/options/vsync_no
@onready var vsync_yes = $UI/bg/visibility_changer/panel_graphics/margin/smoother/gr_box/item_vsync/options/vsync_yes
# FXAA
@onready var fxaa_no = $UI/bg/visibility_changer/panel_graphics/margin/smoother/gr_box/item_fxaa/options/fxaa_no
@onready var fxaa_yes = $UI/bg/visibility_changer/panel_graphics/margin/smoother/gr_box/item_fxaa/options/fxaa_yes
# TAA
@onready var taa_no = $UI/bg/visibility_changer/panel_graphics/margin/smoother/gr_box/item_taa/options/taa_no
@onready var taa_yes = $UI/bg/visibility_changer/panel_graphics/margin/smoother/gr_box/item_taa/options/taa_yes
# SDFGI
@onready var sdfgi_no = $UI/bg/visibility_changer/panel_graphics/margin/smoother/gr_box/item_sdfgi/options/sdfgi_no
@onready var sdfgi_yes = $UI/bg/visibility_changer/panel_graphics/margin/smoother/gr_box/item_sdfgi/options/sdfgi_yes
#SSAO
@onready var ssao_no = $UI/bg/visibility_changer/panel_graphics/margin/smoother/gr_box/item_ssao/options/ssao_no
@onready var ssao_yes = $UI/bg/visibility_changer/panel_graphics/margin/smoother/gr_box/item_ssao/options/ssao_yes
# SHADOWS
@onready var no_shadows = $UI/bg/visibility_changer/panel_graphics/margin/smoother/gr_box/item_shadows/options/no_shadows
@onready var bad_shadows = $UI/bg/visibility_changer/panel_graphics/margin/smoother/gr_box/item_shadows/options/bad_shadows
@onready var mid_shadows = $UI/bg/visibility_changer/panel_graphics/margin/smoother/gr_box/item_shadows/options/mid_shadows
@onready var good_shadows = $UI/bg/visibility_changer/panel_graphics/margin/smoother/gr_box/item_shadows/options/good_shadows
# FREQ
@onready var freq_slider = $UI/bg/visibility_changer/panel_graphics/margin/smoother/gr_box/item_frequency/options/frequency
@onready var freq_value = $UI/bg/visibility_changer/panel_graphics/margin/smoother/gr_box/item_frequency/options/value

# AUDIO SETTINGS UI
@onready var db_sounds = $UI/bg/visibility_changer/panel_audio/margin/smoother/au_box/item_sounds/options/db_sounds
@onready var db_sounds_value = $UI/bg/visibility_changer/panel_audio/margin/smoother/au_box/item_sounds/options/db_sounds_value
@onready var db_music = $UI/bg/visibility_changer/panel_audio/margin/smoother/au_box/item_music/options/db_music
@onready var db_music_value = $UI/bg/visibility_changer/panel_audio/margin/smoother/au_box/item_music/options/db_music_value



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
	SIN_SETTINGS.settings_consume()

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
	
	# LOAD AUDIO SETTINGS
	db_sounds.value = float(SIN_SETTINGS.SETTINGS['AUDIO']['db_sounds'])
	db_music.value = float(SIN_SETTINGS.SETTINGS['AUDIO']['db_music'])
	if db_sounds.value > 0:
		db_sounds_value.text = '+' + str(db_sounds.value)
	else:
		db_sounds_value.text = str(db_sounds.value)
	
	if db_music.value > 0:
		db_music_value.text = '+' + str(db_music.value)
	else:
		db_music_value.text = str(db_music.value)
	
	# LOAD GRAPHICAL SETTINGS
	freq_slider.value = SIN_SETTINGS.SETTINGS['GRAPHICS']['frequency']
	freq_value.text = str(SIN_SETTINGS.SETTINGS['GRAPHICS']['frequency']) +' Гц'
	
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
	match SIN_SETTINGS.SETTINGS['GRAPHICS']['vsync']:
		'no':
			vsync_no.button_pressed = true
			vsync_yes.button_pressed = false
		'yes':
			vsync_no.button_pressed = false
			vsync_yes.button_pressed = true
	match SIN_SETTINGS.SETTINGS['GRAPHICS']['fxaa']:
		'no':
			fxaa_no.button_pressed = true
			fxaa_yes.button_pressed = false
		'yes':
			fxaa_no.button_pressed = false
			fxaa_yes.button_pressed = true
	match SIN_SETTINGS.SETTINGS['GRAPHICS']['taa']:
		'no':
			taa_no.button_pressed = true
			taa_yes.button_pressed = false
		'yes':
			taa_no.button_pressed = false
			taa_yes.button_pressed = true
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
	
	
	# LOAD MISC SETTINGS
	
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

# GRAPHICS - VSYNC PICK

func _on_vsync_no_pressed():
	vsync_no.button_pressed = true
	vsync_yes.button_pressed = false
	SIN_SETTINGS.SETTINGS['GRAPHICS']['vsync'] = 'no'
func _on_vsync_yes_pressed():
	vsync_no.button_pressed = false
	vsync_yes.button_pressed = true
	SIN_SETTINGS.SETTINGS['GRAPHICS']['vsync'] = 'yes'

# GRAPHICS - FXAA PICK

func _on_fxaa_no_pressed():
	fxaa_no.button_pressed = true
	fxaa_yes.button_pressed = false
	SIN_SETTINGS.SETTINGS['GRAPHICS']['fxaa'] = 'no'
func _on_fxaa_yes_pressed():
	fxaa_no.button_pressed = false
	fxaa_yes.button_pressed = true
	SIN_SETTINGS.SETTINGS['GRAPHICS']['fxaa'] = 'yes'

# GRAPHICS - TAA PICK

func _on_taa_no_pressed():
	taa_no.button_pressed = true
	taa_yes.button_pressed = false
	SIN_SETTINGS.SETTINGS['GRAPHICS']['taa'] = 'no'
func _on_taa_yes_pressed():
	taa_no.button_pressed = false
	taa_yes.button_pressed = true
	SIN_SETTINGS.SETTINGS['GRAPHICS']['taa'] = 'yes'

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

# GRAPHICS - FREQUENCY PICK

func _on_frequency_value_changed(value):
	freq_value.text = str(value) + ' Гц'
	SIN_SETTINGS.SETTINGS['GRAPHICS']['frequency'] = value

# AUDIO - SOUND DB PICK

func _on_db_sounds_value_changed(value):
	SIN_SETTINGS.SETTINGS['AUDIO']['db_sounds'] = str(value)
	if value > 0:
		db_sounds_value.text = '+' + str(value)
	else:
		db_sounds_value.text = str(value)

# AUDIO - MUSIC DB PICK

func _on_db_music_value_changed(value):
	SIN_SETTINGS.SETTINGS['AUDIO']['db_music'] = str(value)
	if value > 0:
		db_music_value.text = '+' + str(value)
	else:
		db_music_value.text = str(value)
		












